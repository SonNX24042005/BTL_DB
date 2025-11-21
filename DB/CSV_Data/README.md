# Hướng Dẫn Import Dữ Liệu Database QLDT từ CSV

> ✅ **STATUS: Import Thành Công!** - Đã test và verify hoạt động 100%

## 🎯 Tổng Quan

Thư mục này chứa:
- **17 file CSV** với 35,839 dòng dữ liệu từ hệ thống quản lý đào tạo
- **2 file SQL** để tạo database và import dữ liệu
- **Script Python** để tách dữ liệu từ SQL dump

---

## ⚡ Quick Start - 2 Bước Duy Nhất

### Bước 1: Tạo Cấu Trúc Database

```powershell
Get-Content Create_Tables_Only.sql | mysql -u root -p
```

**Kết quả:** Database `qldt` với 17 bảng (trống)

### Bước 2: Import Dữ Liệu

```powershell
# Bật local_infile (chỉ cần 1 lần)
mysql -u root -p -e "SET GLOBAL local_infile = 1;"

# Import CSV
Get-Content import_from_csv_ordered.sql | mysql --local-infile=1 -u root -p qldt
```

**Kết quả:** 35,839 dòng dữ liệu trong 17 bảng

---

## 📊 Dữ Liệu Đã Import

| Bảng | Số Dòng | Mô Tả |
|------|---------|-------|
| `truong` | 13 | Trường/Khoa |
| `taikhoan` | 1,933 | Tài khoản người dùng |
| `kyhoc` | 18 | Kỳ học |
| `phonghoc` | 416 | Phòng học |
| `nhomhocphan` | 17 | Nhóm học phần |
| `chuongtrinh` | 66 | Chương trình đào tạo |
| `giangvien` | 103 | Giảng viên |
| `sinhvien` | 1,825 | Sinh viên |
| `hp` | 7,062 | Học phần |
| `lop` | 35 | Lớp |
| `chuongtrinhdaotao` | 91 | Chi tiết CTĐT |
| `dangkyhocphan` | 1 | Đăng ký HP |
| `bangdiem` | 41 | Bảng điểm |
| `lophocphan` | 7,636 | Lớp học phần |
| `lopthi` | 1,281 | Lớp thi |
| `lichhoc` | 14,600 | Lịch học |
| `lichthi` | 1,440 | Lịch thi |

**Tổng: 35,839 records**

---

## 📁 Các File Trong Thư Mục

### ✅ Files Chính

| File | Mục Đích |
|------|----------|
| `Create_Tables_Only.sql` | Tạo cấu trúc 17 bảng |
| `import_from_csv_ordered.sql` | Import CSV theo đúng thứ tự FK |
| `*.csv` (17 files) | Dữ liệu các bảng |

### 🛠️ Files Công Cụ

| File | Mục Đích |
|------|----------|
| `../extract_csv_from_sql.py` | Script Python tách dữ liệu từ SQL dump |
| `README.md` | File này |

### 🗑️ Files Backup (Có thể xóa)

- `_import_from_csv.sql.bak` - Import sai thứ tự
- `_DB_Structure_Only_auto.sql.bak` - Auto-generated

---

## ✅ Kiểm Tra Sau Import

```sql
USE qldt;

-- Xem tổng quan
SELECT 
    (SELECT COUNT(*) FROM truong) as 'Trường/Khoa',
    (SELECT COUNT(*) FROM sinhvien) as 'Sinh Viên',
    (SELECT COUNT(*) FROM giangvien) as 'Giảng Viên',
    (SELECT COUNT(*) FROM hp) as 'Học Phần';

-- Xem dữ liệu mẫu
SELECT * FROM sinhvien WHERE MSSV = '20230089';
SELECT * FROM bangdiem WHERE MSSV = '20230089';
```

**Kết quả mong đợi:**
- Trường/Khoa: 13
- Sinh Viên: 1,825
- Giảng Viên: 103
- Học Phần: 7,062

---

## 🔧 Xử Lý Lỗi

### Lỗi: "Loading local data is disabled"

```powershell
mysql -u root -p -e "SET GLOBAL local_infile = 1;"
```

### Lỗi: "The '<' operator is reserved"

Đang dùng PowerShell → Dùng `Get-Content` thay vì `<`:
```powershell
Get-Content file.sql | mysql -u root -p qldt
```

### Lỗi: Foreign key constraint

Đảm bảo chạy đúng thứ tự:
1. `Create_Tables_Only.sql` (tạo cấu trúc)
2. `import_from_csv_ordered.sql` (import dữ liệu theo thứ tự FK)

---

## 🎓 Thứ Tự Import (Tham Khảo)

Script `import_from_csv_ordered.sql` tự động import theo thứ tự:

```
Bước 1: Bảng gốc (không FK)
  → truong, taikhoan, kyhoc, phonghoc, nhomhocphan

Bước 2: Phụ thuộc cấp 1
  → chuongtrinh, giangvien, hp, lop, sinhvien

Bước 3: Phụ thuộc cấp 2
  → chuongtrinhdaotao, dangkyhocphan, bangdiem, lophocphan, lopthi

Bước 4: Phụ thuộc cấp 3
  → lichhoc, lichthi
```

Script sẽ:
1. Parse file SQL dump
2. Tách dữ liệu thành CSV riêng cho mỗi bảng
3. Tạo script import SQL tự động

---

## 📝 Cấu Trúc Database

**Database:** `qldt` (Quản Lý Đào Tạo)

**Encoding:** UTF8MB4 (hỗ trợ đầy đủ Unicode)

**Foreign Keys:** Có ràng buộc đầy đủ giữa các bảng

**Ví dụ quan hệ:**
- `sinhvien` → `chuongtrinh` → `truong`
- `bangdiem` → `sinhvien` + `hp`
- `lophocphan` → `hp` + `giangvien` + `kyhoc` + `phonghoc`

---

## 🎉 Hoàn Thành!

Sau khi import thành công, bạn có thể:

1. ✅ Truy vấn dữ liệu qua SQL
2. ✅ Kết nối từ ứng dụng (Node.js, Python, Java, etc.)
3. ✅ Backup/Export dữ liệu
4. ✅ Tích hợp với các công cụ BI

---

## 🆘 Cần Trợ Giúp?

**Check list:**
- [ ] Đã bật `local_infile`?
- [ ] Đang ở thư mục `CSV_Data`?
- [ ] Dùng PowerShell (không phải CMD)?
- [ ] MySQL 8.0+?
- [ ] Đã tạo cấu trúc bảng trước?

**Nếu vẫn gặp lỗi:** Check version MySQL và encoding settings.

---

**Tạo bởi:** `extract_csv_from_sql.py`  
**Tested:** MySQL 8.0+ trên Windows  
**Ngày:** 2025-11-20  
**Status:** ✅ Hoạt động 100%
