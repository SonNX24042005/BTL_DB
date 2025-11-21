-- ===========================================================
-- Script Import Dữ Liệu từ CSV vào Database QLDT
-- Tạo bởi: extract_csv_from_sql.py
-- ===========================================================

USE qldt;

-- Tắt kiểm tra foreign key và auto-commit tạm thời
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT=0;

-- ===========================================================
-- BƯỚC 1: Import các bảng gốc (không có foreign key)
-- ===========================================================

-- Bảng Truong (School/Faculty)
LOAD DATA LOCAL INFILE 'truong.csv'
INTO TABLE `truong`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported truong' AS status, COUNT(*) AS row_count FROM truong;

-- Bảng Taikhoan (User Accounts)
LOAD DATA LOCAL INFILE 'taikhoan.csv'
INTO TABLE `taikhoan`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported taikhoan' AS status, COUNT(*) AS row_count FROM taikhoan;

-- Bảng KyHoc (Academic Terms)
LOAD DATA LOCAL INFILE 'kyhoc.csv'
INTO TABLE `kyhoc`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported kyhoc' AS status, COUNT(*) AS row_count FROM kyhoc;

-- Bảng PhongHoc (Classrooms)
LOAD DATA LOCAL INFILE 'phonghoc.csv'
INTO TABLE `phonghoc`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported phonghoc' AS status, COUNT(*) AS row_count FROM phonghoc;

-- Bảng NhomHocPhan (Course Groups)
LOAD DATA LOCAL INFILE 'nhomhocphan.csv'
INTO TABLE `nhomhocphan`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported nhomhocphan' AS status, COUNT(*) AS row_count FROM nhomhocphan;

COMMIT;

-- ===========================================================
-- BƯỚC 2: Import các bảng phụ thuộc cấp 1
-- ===========================================================

-- Bảng ChuongTrinh (Programs) - depends on Truong
LOAD DATA LOCAL INFILE 'chuongtrinh.csv'
INTO TABLE `chuongtrinh`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported chuongtrinh' AS status, COUNT(*) AS row_count FROM chuongtrinh;

-- Bảng GiangVien (Lecturers) - depends on Truong, Taikhoan
LOAD DATA LOCAL INFILE 'giangvien.csv'
INTO TABLE `giangvien`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported giangvien' AS status, COUNT(*) AS row_count FROM giangvien;

-- Bảng SinhVien (Students) - depends on ChuongTrinh, Taikhoan
LOAD DATA LOCAL INFILE 'sinhvien.csv'
INTO TABLE `sinhvien`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported sinhvien' AS status, COUNT(*) AS row_count FROM sinhvien;

-- Bảng HP (Courses) - depends on NhomHocPhan
LOAD DATA LOCAL INFILE 'hp.csv'
INTO TABLE `hp`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported hp' AS status, COUNT(*) AS row_count FROM hp;

-- Bảng Lop (Classes) - depends on Truong
LOAD DATA LOCAL INFILE 'lop.csv'
INTO TABLE `lop`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported lop' AS status, COUNT(*) AS row_count FROM lop;

COMMIT;

-- ===========================================================
-- BƯỚC 3: Import các bảng phụ thuộc cấp 2
-- ===========================================================

-- Bảng ChuongTrinhDaoTao (Curriculum) - depends on ChuongTrinh, HP
LOAD DATA LOCAL INFILE 'chuongtrinhdaotao.csv'
INTO TABLE `chuongtrinhdaotao`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported chuongtrinhdaotao' AS status, COUNT(*) AS row_count FROM chuongtrinhdaotao;

-- Bảng DangKyHocPhan (Course Registration) - depends on SinhVien, HP, KyHoc
LOAD DATA LOCAL INFILE 'dangkyhocphan.csv'
INTO TABLE `dangkyhocphan`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported dangkyhocphan' AS status, COUNT(*) AS row_count FROM dangkyhocphan;

-- Bảng BangDiem (Grades) - depends on SinhVien, HP
LOAD DATA LOCAL INFILE 'bangdiem.csv'
INTO TABLE `bangdiem`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported bangdiem' AS status, COUNT(*) AS row_count FROM bangdiem;

-- Bảng LopHocPhan (Course Classes) - depends on HP, GiangVien, KyHoc, PhongHoc
LOAD DATA LOCAL INFILE 'lophocphan.csv'
INTO TABLE `lophocphan`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported lophocphan' AS status, COUNT(*) AS row_count FROM lophocphan;

-- Bảng LopThi (Exam Classes) - depends on PhongHoc
LOAD DATA LOCAL INFILE 'lopthi.csv'
INTO TABLE `lopthi`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported lopthi' AS status, COUNT(*) AS row_count FROM lopthi;

COMMIT;

-- ===========================================================
-- BƯỚC 4: Import các bảng phụ thuộc cấp 3
-- ===========================================================

-- Bảng LichHoc (Class Schedule) - depends on LopHocPhan
LOAD DATA LOCAL INFILE 'lichhoc.csv'
INTO TABLE `lichhoc`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported lichhoc' AS status, COUNT(*) AS row_count FROM lichhoc;

-- Bảng LichThi (Exam Schedule) - depends on LopThi
LOAD DATA LOCAL INFILE 'lichthi.csv'
INTO TABLE `lichthi`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT 'Imported lichthi' AS status, COUNT(*) AS row_count FROM lichthi;

COMMIT;

-- Bật lại kiểm tra foreign key
SET FOREIGN_KEY_CHECKS=1;
SET AUTOCOMMIT=1;

-- ===========================================================
-- Kiểm tra kết quả
-- ===========================================================

SELECT 
    'SUMMARY' as Info,
    (SELECT COUNT(*) FROM truong) as truong,
    (SELECT COUNT(*) FROM taikhoan) as taikhoan,
    (SELECT COUNT(*) FROM kyhoc) as kyhoc,
    (SELECT COUNT(*) FROM phonghoc) as phonghoc,
    (SELECT COUNT(*) FROM nhomhocphan) as nhomhocphan,
    (SELECT COUNT(*) FROM chuongtrinh) as chuongtrinh,
    (SELECT COUNT(*) FROM giangvien) as giangvien,
    (SELECT COUNT(*) FROM sinhvien) as sinhvien,
    (SELECT COUNT(*) FROM hp) as hp,
    (SELECT COUNT(*) FROM lop) as lop,
    (SELECT COUNT(*) FROM chuongtrinhdaotao) as chuongtrinhdaotao,
    (SELECT COUNT(*) FROM dangkyhocphan) as dangkyhocphan,
    (SELECT COUNT(*) FROM bangdiem) as bangdiem,
    (SELECT COUNT(*) FROM lophocphan) as lophocphan,
    (SELECT COUNT(*) FROM lopthi) as lopthi,
    (SELECT COUNT(*) FROM lichhoc) as lichhoc,
    (SELECT COUNT(*) FROM lichthi) as lichthi;

SELECT 'Import completed successfully!' AS Status;
