# Database Optimization Guide

## 📋 Tổng quan

File `Create_Tables_Optimized.sql` là phiên bản tối ưu hóa của `Create_Tables_Only.sql` với các cải tiến về:
- **Performance**: Thêm indexes cho các truy vấn thường dùng
- **Data Integrity**: Thêm CHECK constraints và FK constraints
- **Audit Trail**: Thêm timestamps để track changes
- **Schema Consistency**: Sửa các inconsistencies trong thiết kế
- **Enhanced Relationships**: Thêm bảng quan hệ bị thiếu

---

## 🔄 Breaking Changes

### 1. Bảng `bangdiem`
**Thay đổi:** Cột `HocKy` → `MaKyHoc`

```sql
-- TRƯỚC (Old Schema)
HocKy varchar(10) NOT NULL

-- SAU (Optimized Schema)
MaKyHoc varchar(6) NOT NULL
FOREIGN KEY (MaKyHoc) REFERENCES kyhoc(MaKyHoc)
```

**Impact:**
- ✅ Đảm bảo data consistency với bảng `kyhoc`
- ⚠️ CSV data cần có cột tên `MaKyHoc` thay vì `HocKy`
- ⚠️ Hoặc cần migration script để convert

### 2. Bảng `lophocphan`
**Thay đổi:** Xóa cột `SoSV` (duplicate)

```sql
-- TRƯỚC
SoSV int DEFAULT '0',      -- REMOVED
SLSV int DEFAULT '0',      -- KEPT

-- SAU
SLSV int DEFAULT '0' COMMENT 'Số lượng sinh viên tối đa',
SLDaDK int DEFAULT '0' COMMENT 'Số lượng sinh viên đã đăng ký',
```

**Impact:**
- ✅ Loại bỏ dữ liệu trùng lặp
- ⚠️ CSV data không được có cột `SoSV`

### 3. Bảng mới: `dangkylophocphan`
**Thêm mới:** Link sinh viên với lớp học phần cụ thể

```sql
CREATE TABLE dangkylophocphan (
  MSSV varchar(20) NOT NULL,
  MaLopHocPhan varchar(10) NOT NULL,
  NgayDangKy TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  TrangThai enum('Đang học','Đã hoàn thành','Đã hủy'),
  PRIMARY KEY (MSSV, MaLopHocPhan)
);
```

**Impact:**
- ✅ Bổ sung quan hệ bị thiếu
- ⚠️ Cần tạo CSV data mới cho bảng này (nếu có data)

### 4. Tất cả các bảng
**Thêm:** Audit columns

```sql
CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

**Impact:**
- ✅ Tự động track creation và update time
- ⚠️ CSV data KHÔNG CẦN các cột này (MySQL tự động điền)

---

## 🆕 New Features

### 1. Performance Indexes

```sql
-- Bảng bangdiem
CREATE INDEX idx_bangdiem_kyhoc_hp ON bangdiem(MaKyHoc, MaHP);

-- Bảng lophocphan
CREATE INDEX idx_lophocphan_schedule ON lophocphan(MaKyHoc, ThuHoc, TietBatDau);
CREATE INDEX idx_lophocphan_status ON lophocphan(TrangThai, MaKyHoc);

-- Bảng dangkyhocphan
CREATE INDEX idx_dangky_kyhoc ON dangkyhocphan(MaKyHoc, MaHP);

-- Bảng sinhvien
CREATE INDEX idx_sinhvien_lop ON sinhvien(MaLop, MaChuongTrinh);
```

**Benefit:** Tăng tốc các truy vấn JOIN và WHERE clause

### 2. Data Integrity Constraints

```sql
-- Validate điểm số
CONSTRAINT CHK_DiemSo CHECK (DiemSo BETWEEN 0 AND 10)
CONSTRAINT CHK_DiemGK CHECK (DiemGK IS NULL OR DiemGK BETWEEN 0 AND 10)
CONSTRAINT CHK_DiemCK CHECK (DiemCK IS NULL OR DiemCK BETWEEN 0 AND 10)

-- Validate số lượng đăng ký
CONSTRAINT CHK_LopHP_DangKy CHECK (SLDaDK <= SLSV)

-- Validate tiết học
CONSTRAINT CHK_LopHP_Tiet CHECK (TietBatDau BETWEEN 1 AND 12)
CONSTRAINT CHK_LopHP_SoTiet CHECK (SoTiet BETWEEN 1 AND 6)

-- Validate tín chỉ
CONSTRAINT CHK_HP_TinChi CHECK (TinChiHocTap BETWEEN 1 AND 10)
CONSTRAINT CHK_HP_HeSo CHECK (HeSoGK BETWEEN 0 AND 1)
```

**Benefit:** Ngăn chặn dữ liệu không hợp lệ ngay từ database level

### 3. Enhanced Curriculum Table

```sql
-- Bảng chuongtrinhdaotao
LoaiHP enum('Bắt buộc','Tự chọn','Tự chọn tự do') DEFAULT 'Bắt buộc',
MaHPTienQuyet varchar(8) DEFAULT NULL,
FOREIGN KEY (MaHPTienQuyet) REFERENCES hp(MaHP)
```

**Benefit:** 
- Phân loại học phần bắt buộc/tự chọn
- Quản lý môn học tiên quyết

---

## 📝 CSV Data Requirements

### CSV cần chỉnh sửa

#### 1. `bangdiem.csv`
```csv
# TRƯỚC
MSSV,MaHP,HocKy,DiemSo,DiemChu,DiemGK,DiemCK

# SAU (Đổi HocKy -> MaKyHoc)
MSSV,MaHP,MaKyHoc,DiemSo,DiemChu,DiemGK,DiemCK
```

#### 2. `lophocphan.csv`
```csv
# TRƯỚC
MaLopHocPhan,MaHP,MaGV,MaKyHoc,MaPhongHoc,ThuHoc,TietBatDau,SoTiet,SoSV,BuoiHoc,GhiChu,SLSV,SLDaDK,TrangThai,NgayBatDau

# SAU (Xóa cột SoSV)
MaLopHocPhan,MaHP,MaGV,MaKyHoc,MaPhongHoc,ThuHoc,TietBatDau,SoTiet,BuoiHoc,GhiChu,SLSV,SLDaDK,TrangThai,NgayBatDau
```

### CSV mới cần tạo

#### 3. `dangkylophocphan.csv` (NEW)
```csv
MSSV,MaLopHocPhan,TrangThai
20210001,LHP001,Đang học
20210002,LHP001,Đang học
```

**Lưu ý:** Không cần cột `NgayDangKy`, `CreatedAt`, `UpdatedAt` - MySQL tự động điền

#### 4. `chuongtrinhdaotao.csv` (Enhanced)
```csv
# Thêm 2 cột mới
MaChuongTrinh,MaHP,KyHocKhuyenNghi,LoaiHP,MaHPTienQuyet

# Ví dụ
KTPM,IT3080,1,Bắt buộc,
KTPM,IT3090,2,Bắt buộc,IT3080
KTPM,IT4000,3,Tự chọn,
```

---

## 🚀 Migration từ Schema cũ

### Option 1: Fresh Install (Recommended nếu chưa có data)
```bash
# Xóa database cũ và tạo mới
mysql -u root -p < Create_Tables_Optimized.sql

# Import CSV data (đã chỉnh sửa)
mysql -u root -p qldt < import_csv.sql
```

### Option 2: Migrate Database có sẵn

```sql
-- 1. Backup database cũ
mysqldump -u root -p qldt > backup_qldt.sql

-- 2. Thêm audit columns vào tất cả bảng
ALTER TABLE truong 
  ADD COLUMN CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Repeat cho tất cả các bảng...

-- 3. Fix bảng bangdiem
ALTER TABLE bangdiem 
  CHANGE HocKy MaKyHoc varchar(6) NOT NULL,
  ADD KEY MaKyHoc (MaKyHoc),
  ADD CONSTRAINT FK_BangDiem_KyHoc 
    FOREIGN KEY (MaKyHoc) REFERENCES kyhoc(MaKyHoc) 
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- 4. Fix bảng lophocphan
ALTER TABLE lophocphan 
  DROP COLUMN SoSV;

-- 5. Thêm bảng mới
CREATE TABLE dangkylophocphan (
  MSSV varchar(20) NOT NULL,
  MaLopHocPhan varchar(10) NOT NULL,
  NgayDangKy TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  TrangThai enum('Đang học','Đã hoàn thành','Đã hủy') DEFAULT 'Đang học',
  CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (MSSV, MaLopHocPhan),
  FOREIGN KEY (MSSV) REFERENCES sinhvien(MSSV) ON DELETE CASCADE,
  FOREIGN KEY (MaLopHocPhan) REFERENCES lophocphan(MaLopHocPhan) ON DELETE CASCADE
);

-- 6. Thêm indexes
CREATE INDEX idx_bangdiem_kyhoc_hp ON bangdiem(MaKyHoc, MaHP);
CREATE INDEX idx_lophocphan_schedule ON lophocphan(MaKyHoc, ThuHoc, TietBatDau);
-- ... (thêm các indexes khác)

-- 7. Thêm constraints
ALTER TABLE bangdiem
  ADD CONSTRAINT CHK_DiemSo CHECK (DiemSo IS NULL OR DiemSo BETWEEN 0 AND 10),
  ADD CONSTRAINT CHK_DiemGK CHECK (DiemGK IS NULL OR DiemGK BETWEEN 0 AND 10),
  ADD CONSTRAINT CHK_DiemCK CHECK (DiemCK IS NULL OR DiemCK BETWEEN 0 AND 10);
-- ... (thêm các constraints khác)
```

---

## ✅ Verification Steps

### 1. Kiểm tra cấu trúc bảng
```sql
-- Xem tất cả bảng
SHOW TABLES;

-- Xem cấu trúc bảng cụ thể
DESCRIBE bangdiem;
DESCRIBE lophocphan;
DESCRIBE dangkylophocphan;
```

### 2. Kiểm tra constraints
```sql
SELECT 
  TABLE_NAME, 
  CONSTRAINT_NAME, 
  CONSTRAINT_TYPE 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA='qldt'
ORDER BY TABLE_NAME;
```

### 3. Kiểm tra indexes
```sql
SELECT 
  TABLE_NAME, 
  INDEX_NAME, 
  GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS COLUMNS
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA='qldt'
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME;
```

### 4. Test constraints
```sql
-- Test điểm số không hợp lệ (sẽ fail)
INSERT INTO bangdiem (MSSV, MaHP, MaKyHoc, DiemSo) 
VALUES ('TEST001', 'IT3080', '2024.1', 15);
-- Error: Check constraint 'CHK_DiemSo' is violated.

-- Test đăng ký vượt quá limit (sẽ fail)
UPDATE lophocphan SET SLDaDK = 100 WHERE SLSV = 50;
-- Error: Check constraint 'CHK_LopHP_DangKy' is violated.
```

---

## 📊 Comparison Table

| Feature | Old Schema | Optimized Schema |
|---------|-----------|------------------|
| **Audit Trail** | ❌ Không có | ✅ CreatedAt, UpdatedAt |
| **Performance Indexes** | ⚠️ Chỉ có primary keys | ✅ Composite indexes |
| **Data Validation** | ❌ Minimal | ✅ CHECK constraints |
| **Schema Consistency** | ⚠️ HocKy không có FK | ✅ MaKyHoc với FK |
| **Duplicate Columns** | ❌ SoSV & SLSV | ✅ Chỉ SLSV |
| **Student-Class Link** | ❌ Thiếu | ✅ dangkylophocphan |
| **Curriculum Details** | ⚠️ Basic | ✅ LoaiHP, Tiên quyết |
| **Documentation** | ⚠️ Minimal comments | ✅ Detailed comments |

---

## 🎯 Recommended Workflow

1. **Review** file `Create_Tables_Optimized.sql`
2. **Backup** database hiện tại (nếu có)
3. **Prepare** CSV files theo format mới
4. **Test** trên development environment trước
5. **Import** data vào database mới
6. **Verify** constraints và relationships
7. **Deploy** to production

---

## 📞 Support

Nếu gặp vấn đề khi migration hoặc import CSV, check:
- Constraint violations → Xem error message để biết dữ liệu nào không hợp lệ
- Foreign key errors → Đảm bảo import theo đúng thứ tự (parent tables trước)
- Data type mismatch → Kiểm tra định dạng trong CSV

---

**Created:** 2025-11-20  
**Author:** Antigravity AI  
**Version:** 1.0
