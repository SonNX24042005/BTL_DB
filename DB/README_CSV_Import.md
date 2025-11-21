# Database QLDT - Hệ Thống Quản Lý Đào Tạo

> ✅ **Đã import thành công:** 35,839 records vào 17 bảng

## 📂 Cấu Trúc Thư Mục

```
BTL_DB/DB/
│
├── Dump20250602.sql              # SQL dump gốc (cấu trúc + dữ liệu)
├── extract_csv_from_sql.py       # Script Python tách dữ liệu thành CSV
├── README_CSV_Import.md          # File này
│
└── CSV_Data/                     # ⭐ Thư mục chính
    ├── README.md                 # Hướng dẫn chi tiết
    ├── Create_Tables_Only.sql    # Tạo cấu trúc database
    ├── import_from_csv_ordered.sql  # Import dữ liệu từ CSV
    └── *.csv (17 files)          # Dữ liệu các bảng
```

---

## 🚀 Quick Start

### Option 1: Import Trực Tiếp từ SQL Dump (Nhanh nhất)

```powershell
mysql -u root -p < Dump20250602.sql
```

✅ Xong! Database `qldt` đã có đầy đủ cấu trúc + dữ liệu.

---

### Option 2: Import từ CSV (Linh hoạt - Đã test)

```powershell
cd CSV_Data

# Bước 1: Tạo cấu trúc
mysql -u root -p < Create_Tables_Only.sql

# Bước 2: Bật local_infile
mysql -u root -p -e "SET GLOBAL local_infile = 1;"

# Bước 3: Import dữ liệu
Get-Content import_from_csv_ordered.sql | mysql --local-infile=1 -u root -p qldt
```

✅ Import thành công 35,839 records!

---

## 📊 Database Overview

**Tên Database:** `qldt`  
**Encoding:** UTF8MB4  
**Số bảng:** 17  
**Tổng records:** 35,839

### Các Bảng Chính:

| Bảng | Records | Mô Tả |
|------|---------|-------|
| `sinhvien` | 1,825 | Sinh viên |
| `giangvien` | 103 | Giảng viên |
| `hp` | 7,062 | Học phần/môn học |
| `lophocphan` | 7,636 | Lớp học phần |
| `lichhoc` | 14,600 | Lịch học |
| `taikhoan` | 1,933 | Tài khoản người dùng |
| ... | ... | 11 bảng khác |

**Chi tiết đầy đủ:** Xem `CSV_Data/README.md`

---

## ✅ Kiểm Tra Sau Import

```sql
USE qldt;

-- Tổng quan
SELECT 
    (SELECT COUNT(*) FROM sinhvien) as 'Sinh Viên',
    (SELECT COUNT(*) FROM giangvien) as 'Giảng Viên',
    (SELECT COUNT(*) FROM hp) as 'Học Phần',
    (SELECT COUNT(*) FROM lophocphan) as 'Lớp HP';

-- Dữ liệu mẫu
SELECT * FROM sinhvien WHERE MSSV = '20230089';
```

**Kết quả mong đợi:**
- Sinh Viên: 1,825
- Giảng Viên: 103
- Học Phần: 7,062
- Lớp HP: 7,636

---

## 🛠️ Công Cụ

### Script Tách Dữ liệu

`extract_csv_from_sql.py` - Tách dữ liệu từ SQL dump thành CSV:

```powershell
python extract_csv_from_sql.py
```

**Output:**
- 17 file CSV trong `CSV_Data/`
- Script SQL import tự động
- Tài liệu hướng dẫn

---

## 📝 Schema Database

### Quan Hệ Chính:

```
truong
  ├── chuongtrinh
  │     └── sinhvien
  │           └── bangdiem
  ├── giangvien
  └── lop

hp ← lophocphan → lichhoc
   ← bangdiem
```

### Foreign Keys:

- Có ràng buộc đầy đủ giữa các bảng
- Cascade delete/update được cấu hình sẵn
- Data integrity được đảm bảo

---

## 🎯 Use Cases

### 1. Web Application Backend
```javascript
// Node.js example
const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  database: 'qldt'
});
```

### 2. Data Analysis
```python
# Python pandas example
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('mysql+pymysql://root:password@localhost/qldt')
df = pd.read_sql('SELECT * FROM sinhvien', engine)
```

### 3. Business Intelligence
- Kết nối với Power BI / Tableau
- Dashboard quản lý đào tạo
- Phân tích dữ liệu sinh viên

---

## ⚠️ Lưu Ý Quan Trọng

### KHÔNG Làm:
```powershell
# ❌ SAI - Import 2 lần sẽ bị duplicate
mysql < Dump20250602.sql
cd CSV_Data
Get-Content import_from_csv_ordered.sql | mysql ...
```

### ✅ Làm Đúng:
**Chọn 1 trong 2 option ở trên, KHÔNG dùng cả 2!**

---

## 📚 Tài Liệu

- **Hướng dẫn chi tiết:** `CSV_Data/README.md`
- **SQL dump gốc:** `Dump20250602.sql`
- **Script Python:** `extract_csv_from_sql.py`

---

## 🔧 Troubleshooting

### MySQL không nhận CSV?
→ Bật `local_infile`: `SET GLOBAL local_infile = 1;`

### PowerShell lỗi `<` operator?
→ Dùng `Get-Content file.sql | mysql ...`

### Foreign key error?
→ Dùng `import_from_csv_ordered.sql` (đã sắp xếp đúng thứ tự)

---

## 📊 Statistics

- **Database size:** ~2.5 MB (dữ liệu)
- **CSV files size:** ~1.8 MB
- **SQL dump size:** ~2.3 MB
- **Import time:** ~5-10 giây
- **Testing:** ✅ Verified trên MySQL 8.0

---

## 🎉 Kết Quả

✅ Database hoạt động hoàn hảo  
✅ Dữ liệu đầy đủ và chính xác  
✅ Foreign keys được thiết lập đúng  
✅ Encoding UTF8MB4 hỗ trợ đầy đủ  
✅ Sẵn sàng cho production  

---

**Created:** 2025-11-20  
**Version:** 1.0  
**Status:** Production Ready ✅
