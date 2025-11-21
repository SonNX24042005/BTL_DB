#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script để tách dữ liệu từ file SQL dump thành các file CSV riêng biệt
Sau đó có thể import dữ liệu từ CSV vào database
"""

import re
import csv
import os
from pathlib import Path


def parse_sql_file(sql_file_path):
    """
    Đọc file SQL và tách dữ liệu từ các câu lệnh INSERT
    
    Returns:
        dict: {table_name: {columns: [], data: []}}
    """
    print(f"Dang doc file SQL: {sql_file_path}")
    
    with open(sql_file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    tables_data = {}
    
    # Pattern để tìm câu lệnh INSERT
    # Dạng: INSERT INTO `table_name` VALUES (...),(...);
    insert_pattern = r"INSERT INTO `(\w+)` VALUES (.+?);"
    
    # Pattern để tìm cấu trúc bảng (lấy tên cột)
    create_table_pattern = r"CREATE TABLE `(\w+)` \((.*?)\) ENGINE"
    
    # Tìm tất cả các bảng và cấu trúc
    create_matches = re.finditer(create_table_pattern, content, re.DOTALL | re.IGNORECASE)
    table_structures = {}
    
    for match in create_matches:
        table_name = match.group(1)
        columns_def = match.group(2)
        
        # Trích xuất tên cột từ định nghĩa CREATE TABLE
        columns = []
        for line in columns_def.split('\n'):
            line = line.strip()
            if line.startswith('`'):
                # Lấy tên cột (phần đầu tiên trong backticks)
                col_match = re.match(r'`(\w+)`', line)
                if col_match and not line.upper().startswith('`PRIMARY') and not line.upper().startswith('`KEY') and not line.upper().startswith('`CONSTRAINT'):
                    columns.append(col_match.group(1))
        
        table_structures[table_name] = columns
        print(f"Tim thay bang: {table_name} voi {len(columns)} cot")
    
    # Tìm tất cả các câu lệnh INSERT
    insert_matches = re.finditer(insert_pattern, content, re.DOTALL)
    
    for match in insert_matches:
        table_name = match.group(1)
        values_str = match.group(2)
        
        if table_name not in tables_data:
            tables_data[table_name] = {
                'columns': table_structures.get(table_name, []),
                'data': []
            }
        
        # Parse các giá trị
        # Tách các nhóm (...),(...) 
        rows = parse_insert_values(values_str)
        tables_data[table_name]['data'].extend(rows)
    
    return tables_data


def parse_insert_values(values_str):
    """
    Parse chuỗi VALUES từ câu lệnh INSERT
    VD: ('val1','val2',123),('val3','val4',456)
    
    Returns:
        list: Danh sách các dòng dữ liệu
    """
    rows = []
    
    # Tìm tất cả các nhóm giá trị trong dấu ngoặc đơn
    # Pattern phức tạp để xử lý cả string có dấu ngoặc đơn bên trong
    current_row = []
    in_string = False
    escape_next = False
    paren_depth = 0
    current_value = ""
    
    i = 0
    while i < len(values_str):
        char = values_str[i]
        
        # Xử lý escape character
        if escape_next:
            current_value += char
            escape_next = False
            i += 1
            continue
        
        if char == '\\':
            escape_next = True
            current_value += char
            i += 1
            continue
        
        # Xử lý string quotes
        if char == "'" and not in_string:
            in_string = True
            i += 1
            continue
        elif char == "'" and in_string:
            in_string = False
            i += 1
            continue
        
        # Nếu đang trong string, thêm vào giá trị hiện tại
        if in_string:
            current_value += char
            i += 1
            continue
        
        # Xử lý cấu trúc ngoặc đơn
        if char == '(':
            if paren_depth == 0:
                # Bắt đầu một dòng mới
                current_row = []
                current_value = ""
            paren_depth += 1
        elif char == ')':
            paren_depth -= 1
            if paren_depth == 0:
                # Kết thúc một dòng
                if current_value or current_value == "":
                    current_row.append(clean_value(current_value))
                if current_row:
                    rows.append(current_row)
                current_row = []
                current_value = ""
        elif char == ',' and paren_depth == 1:
            # Phân tách giữa các giá trị trong cùng một dòng
            current_row.append(clean_value(current_value))
            current_value = ""
        elif char == ',' and paren_depth == 0:
            # Phân tách giữa các dòng - bỏ qua
            pass
        elif paren_depth > 0 and char not in [' ', '\t', '\n', '\r'] or (paren_depth > 0 and current_value):
            # Thêm ký tự vào giá trị hiện tại
            current_value += char
        
        i += 1
    
    return rows


def clean_value(value):
    """
    Làm sạch giá trị (bỏ khoảng trắng, xử lý NULL, etc.)
    """
    value = value.strip()
    
    # Xử lý NULL
    if value.upper() == 'NULL':
        return ''
    
    # Bỏ dấu ngoặc kép nếu có
    if value.startswith("'") and value.endswith("'"):
        value = value[1:-1]
    
    # Unescape các ký tự đặc biệt
    value = value.replace("\\'", "'")
    value = value.replace("\\n", "\n")
    value = value.replace("\\r", "\r")
    value = value.replace("\\t", "\t")
    value = value.replace("\\\\", "\\")
    
    return value


def write_csv_files(tables_data, output_dir):
    """
    Ghi dữ liệu ra các file CSV
    
    Args:
        tables_data: dict với cấu trúc {table_name: {columns: [], data: []}}
        output_dir: thư mục đầu ra cho các file CSV
    """
    output_path = Path(output_dir)
    output_path.mkdir(exist_ok=True)
    
    print(f"\nTao thu muc CSV: {output_path}")
    
    for table_name, table_info in tables_data.items():
        csv_file = output_path / f"{table_name}.csv"
        
        with open(csv_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f, quoting=csv.QUOTE_MINIMAL)
            
            # Ghi header (tên cột)
            if table_info['columns']:
                writer.writerow(table_info['columns'])
            
            # Ghi dữ liệu
            for row in table_info['data']:
                writer.writerow(row)
        
        row_count = len(table_info['data'])
        col_count = len(table_info['columns']) if table_info['columns'] else (len(table_info['data'][0]) if table_info['data'] else 0)
        print(f"Da tao: {csv_file.name} ({row_count} dong, {col_count} cot)")


def generate_import_sql(tables_data, output_dir, database_name='qldt'):
    """
    Tạo script SQL để import từ CSV files
    
    Args:
        tables_data: dict với cấu trúc {table_name: {columns: [], data: []}}
        output_dir: thư mục chứa các file CSV
        database_name: tên database
    """
    output_path = Path(output_dir)
    import_script = output_path / "import_from_csv.sql"
    
    with open(import_script, 'w', encoding='utf-8') as f:
        f.write(f"-- Script import dữ liệu từ CSV files vào database {database_name}\n")
        f.write(f"-- Tạo bởi extract_csv_from_sql.py\n\n")
        f.write(f"USE {database_name};\n\n")
        f.write("-- Tắt kiểm tra foreign key tạm thời\n")
        f.write("SET FOREIGN_KEY_CHECKS=0;\n\n")
        
        for table_name in sorted(tables_data.keys()):
            columns = tables_data[table_name]['columns']
            csv_file = f"{table_name}.csv"
            
            f.write(f"-- Import dữ liệu cho bảng {table_name}\n")
            f.write(f"LOAD DATA LOCAL INFILE '{csv_file}'\n")
            f.write(f"INTO TABLE `{table_name}`\n")
            f.write("CHARACTER SET utf8mb4\n")
            f.write("FIELDS TERMINATED BY ','\n")
            f.write("ENCLOSED BY '\"'\n")
            f.write("LINES TERMINATED BY '\\n'\n")
            f.write("IGNORE 1 ROWS;\n\n")
        
        f.write("-- Bật lại kiểm tra foreign key\n")
        f.write("SET FOREIGN_KEY_CHECKS=1;\n")
    
    print(f"\nDa tao script SQL import: {import_script.name}")


def main():
    """
    Ham chinh
    """
    import sys
    import io
    
    # Fix encoding for Windows console
    if sys.platform == 'win32':
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    
    print("=" * 60)
    print("CHUONG TRINH TACH DU LIEU SQL SANG CSV")
    print("=" * 60)
    
    # Duong dan file SQL input
    sql_file = r"d:\DT\Code\PJ\BTL_DB\DB\Dump20250602.sql"
    
    # Thu muc output cho CSV files
    output_dir = r"d:\DT\Code\PJ\BTL_DB\DB\CSV_Data"
    
    # Parse SQL file
    tables_data = parse_sql_file(sql_file)
    
    print(f"\nTong so bang tim thay: {len(tables_data)}")
    
    if not tables_data:
        print("Khong tim thay du lieu trong file SQL!")
        return
    
    # Tao CSV files
    write_csv_files(tables_data, output_dir)
    
    # Tao script import
    generate_import_sql(tables_data, output_dir)
    
    print("\n" + "=" * 60)
    print("HOAN THANH!")
    print("=" * 60)
    print(f"\nCac file CSV da duoc tao trong: {output_dir}")
    print(f"Script import SQL: {output_dir}\\import_from_csv.sql")
    print("\nDe import du lieu vao MySQL:\n")
    print("   1. Copy cac file CSV vao thu muc MySQL co the truy cap")
    print("   2. Chay script import_from_csv.sql hoac")
    print("   3. Su dung MySQL Workbench de import tung file CSV\n")


if __name__ == "__main__":
    main()
