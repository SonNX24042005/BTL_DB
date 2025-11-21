# Cách chạy trên Windows
- Bước 1
```bash
Get-Content Create_Tables_Optimized.sql | mysql -u root -p
```
- Bước 2
```bash
# Bật local_infile (chỉ cần 1 lần)
mysql -u root -p -e "SET GLOBAL local_infile = 1;"

# Import CSV
Get-Content import_from_csv_ordered.sql | mysql --local-infile=1 -u root -p qldt
```
# Cách chạy trên Ubuntu
- Bước 1
```bash
mysql -u root -p -e "SET GLOBAL local_infile = 1;"
```
- Bước 2
```bash
mysql --local-infile=1 -u root -p qldt < import_from_csv_ordered.sql
```
# Tài liệu chi tiết
- README_CSV_Import.md là tài liệu Overview tổng thể về toàn bộ project database
- CSV_Data/README.md là tài liệu hướng dẫn chi tiết IMPORT từ CSV
- CSV_Data/OPTIMIZATION_GUIDE.md là tài liệu hướng dẫn NÂNG CẤP schema lên phiên bản tối ưu