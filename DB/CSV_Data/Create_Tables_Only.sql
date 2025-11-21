-- ===========================================================
-- CẤU TRÚC DATABASE - CHỈ TẠO BẢNG (KHÔNG CÓ DỮ LIỆU)
-- Tạo từ: Dump20250602.sql
-- Mục đích: Sử dụng khi import dữ liệu từ CSV
-- ===========================================================

-- Cấu hình MySQL
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- ===========================================================
-- TẠO DATABASE
-- ===========================================================

CREATE DATABASE IF NOT EXISTS qldt CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE qldt;

-- ===========================================================
-- XÓA CÁC BẢNG CŨ (NẾU CÓ)
-- ===========================================================

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `lichhoc`;
DROP TABLE IF EXISTS `lichthi`;
DROP TABLE IF EXISTS `lopthi`;
DROP TABLE IF EXISTS `lophocphan`;
DROP TABLE IF EXISTS `bangdiem`;
DROP TABLE IF EXISTS `dangkyhocphan`;
DROP TABLE IF EXISTS `chuongtrinhdaotao`;
DROP TABLE IF EXISTS `lop`;
DROP TABLE IF EXISTS `hp`;
DROP TABLE IF EXISTS `sinhvien`;
DROP TABLE IF EXISTS `giangvien`;
DROP TABLE IF EXISTS `chuongtrinh`;
DROP TABLE IF EXISTS `nhomhocphan`;
DROP TABLE IF EXISTS `phonghoc`;
DROP TABLE IF EXISTS `kyhoc`;
DROP TABLE IF EXISTS `taikhoan`;
DROP TABLE IF EXISTS `truong`;

SET FOREIGN_KEY_CHECKS=1;

-- ===========================================================
-- CẤU TRÚC CÁC BẢNG
-- ===========================================================

-- Bảng: truong (Schools/Faculties)
CREATE TABLE `truong` (
  `MaTruong` varchar(10) NOT NULL,
  `TenTruong` varchar(100) NOT NULL,
  PRIMARY KEY (`MaTruong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: taikhoan (User Accounts)
CREATE TABLE `taikhoan` (
  `Username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng: kyhoc (Academic Terms)
CREATE TABLE `kyhoc` (
  `MaKyHoc` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mã kỳ học, định dạng: yyyy.x (x = 1, 2, 3)',
  PRIMARY KEY (`MaKyHoc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Lưu trữ thông tin các kỳ học';

-- Bảng: phonghoc (Classrooms)
CREATE TABLE `phonghoc` (
  `MaPhongHoc` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaPhongHoc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: nhomhocphan (Course Groups)
CREATE TABLE `nhomhocphan` (
  `MaNhomHP` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TenNhomHP` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaNhomHP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: chuongtrinh (Programs)
CREATE TABLE `chuongtrinh` (
  `MaChuongTrinh` varchar(10) NOT NULL,
  `TenChuongTrinh` varchar(100) NOT NULL,
  `MaTruong` varchar(10) NOT NULL,
  PRIMARY KEY (`MaChuongTrinh`),
  KEY `MaTruong` (`MaTruong`),
  CONSTRAINT `chuongtrinh_ibfk_1` FOREIGN KEY (`MaTruong`) REFERENCES `truong` (`MaTruong`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: giangvien (Lecturers)
CREATE TABLE `giangvien` (
  `MaGV` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `HoTenGV` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `MaTruong` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`MaGV`),
  KEY `MaTruong` (`MaTruong`),
  KEY `Email` (`Email`),
  CONSTRAINT `giangvien_ibfk_1` FOREIGN KEY (`MaTruong`) REFERENCES `truong` (`MaTruong`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `giangvien_ibfk_2` FOREIGN KEY (`Email`) REFERENCES `taikhoan` (`Username`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng: hp (Courses)
CREATE TABLE `hp` (
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TenHP` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ThoiLuong` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `HeSoGK` decimal(3,2) DEFAULT NULL,
  `TinChiHocTap` tinyint unsigned DEFAULT NULL,
  `TinChiHocPhi` tinyint unsigned DEFAULT NULL,
  `MaNhomHP` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`MaHP`),
  KEY `MaNhomHP` (`MaNhomHP`),
  CONSTRAINT `hp_ibfk_1` FOREIGN KEY (`MaNhomHP`) REFERENCES `nhomhocphan` (`MaNhomHP`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng: lop (Classes) - PHẢI TẠO TRƯỚC sinhvien
CREATE TABLE `lop` (
  `MaLop` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `MaTruong` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`MaLop`),
  KEY `MaTruong` (`MaTruong`),
  CONSTRAINT `lop_ibfk_1` FOREIGN KEY (`MaTruong`) REFERENCES `truong` (`MaTruong`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: sinhvien (Students)
CREATE TABLE `sinhvien` (
  `MSSV` varchar(20) NOT NULL,
  `HoTen` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgaySinh` date DEFAULT NULL,
  `GioiTinh` enum('Nam','Nữ','Khác') DEFAULT NULL,
  `QueQuan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CCCD` varchar(20) DEFAULT NULL,
  `MaChuongTrinh` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `MaLop` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`MSSV`),
  KEY `MaChuongTrinh` (`MaChuongTrinh`),
  KEY `MaLop` (`MaLop`),
  KEY `Email` (`Email`),
  CONSTRAINT `sinhvien_ibfk_1` FOREIGN KEY (`MaChuongTrinh`) REFERENCES `chuongtrinh` (`MaChuongTrinh`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `sinhvien_ibfk_2` FOREIGN KEY (`MaLop`) REFERENCES `lop` (`MaLop`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `sinhvien_ibfk_3` FOREIGN KEY (`Email`) REFERENCES `taikhoan` (`Username`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: chuongtrinhdaotao (Curriculum)
CREATE TABLE `chuongtrinhdaotao` (
  `MaChuongTrinh` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `KyHocKhuyenNghi` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`MaChuongTrinh`,`MaHP`),
  KEY `MaHP` (`MaHP`),
  CONSTRAINT `chuongtrinhdaotao_ibfk_1` FOREIGN KEY (`MaChuongTrinh`) REFERENCES `chuongtrinh` (`MaChuongTrinh`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chuongtrinhdaotao_ibfk_2` FOREIGN KEY (`MaHP`) REFERENCES `hp` (`MaHP`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: dangkyhocphan (Course Registration)
CREATE TABLE `dangkyhocphan` (
  `MSSV` varchar(20) NOT NULL COMMENT 'Mã số sinh viên',
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mã học phần',
  `MaKyHoc` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mã kỳ học',
  PRIMARY KEY (`MSSV`,`MaHP`,`MaKyHoc`),
  KEY `FK_DangKyHocPhan_HP` (`MaHP`),
  KEY `FK_DangKyHocPhan_KyHoc` (`MaKyHoc`),
  CONSTRAINT `FK_DangKyHocPhan_HP` FOREIGN KEY (`MaHP`) REFERENCES `hp` (`MaHP`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_DangKyHocPhan_KyHoc` FOREIGN KEY (`MaKyHoc`) REFERENCES `kyhoc` (`MaKyHoc`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_DangKyHocPhan_SinhVien` FOREIGN KEY (`MSSV`) REFERENCES `sinhvien` (`MSSV`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Đăng ký học phần';

-- Bảng: bangdiem (Grades)
CREATE TABLE `bangdiem` (
  `MSSV` varchar(20) NOT NULL,
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `HocKy` varchar(10) NOT NULL,
  `DiemSo` decimal(4,2) DEFAULT NULL,
  `DiemChu` varchar(3) DEFAULT NULL,
  `DiemGK` decimal(4,2) DEFAULT NULL,
  `DiemCK` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`MSSV`,`MaHP`,`HocKy`),
  KEY `MaHP` (`MaHP`),
  CONSTRAINT `bangdiem_ibfk_1` FOREIGN KEY (`MSSV`) REFERENCES `sinhvien` (`MSSV`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bangdiem_ibfk_2` FOREIGN KEY (`MaHP`) REFERENCES `hp` (`MaHP`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: lophocphan (Course Classes)
CREATE TABLE `lophocphan` (
  `MaLopHocPhan` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaGV` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MaKyHoc` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaPhongHoc` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ThuHoc` enum('Thứ 2','Thứ 3','Thứ 4','Thứ 5','Thứ 6','Thứ 7','Chủ nhật') DEFAULT NULL,
  `TietBatDau` tinyint unsigned DEFAULT NULL,
  `SoTiet` tinyint unsigned DEFAULT NULL,
  `SoSV` int DEFAULT '0',
  `BuoiHoc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GhiChu` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `SLSV` int DEFAULT '0',
  `SLDaDK` int DEFAULT '0',
  `TrangThai` enum('Mở đăng ký','Đóng đăng ký','Hủy') DEFAULT 'Mở đăng ký',
  `NgayBatDau` date DEFAULT NULL,
  PRIMARY KEY (`MaLopHocPhan`),
  KEY `MaHP` (`MaHP`),
  KEY `MaGV` (`MaGV`),
  KEY `MaKyHoc` (`MaKyHoc`),
  KEY `MaPhongHoc` (`MaPhongHoc`),
  CONSTRAINT `lophocphan_ibfk_1` FOREIGN KEY (`MaHP`) REFERENCES `hp` (`MaHP`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lophocphan_ibfk_2` FOREIGN KEY (`MaGV`) REFERENCES `giangvien` (`MaGV`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `lophocphan_ibfk_3` FOREIGN KEY (`MaKyHoc`) REFERENCES `kyhoc` (`MaKyHoc`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lophocphan_ibfk_4` FOREIGN KEY (`MaPhongHoc`) REFERENCES `phonghoc` (`MaPhongHoc`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: lopthi (Exam Classes)
CREATE TABLE `lopthi` (
  `MaLopThi` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaPhongThi` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SLSinhVien` int DEFAULT '0',
  `SLDaDK` int DEFAULT '0',
  PRIMARY KEY (`MaLopThi`),
  KEY `MaPhongThi` (`MaPhongThi`),
  CONSTRAINT `lopthi_ibfk_1` FOREIGN KEY (`MaPhongThi`) REFERENCES `phonghoc` (`MaPhongHoc`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: lichhoc (Class Schedule)
CREATE TABLE `lichhoc` (
  `MaLopHocPhan` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayHoc` date NOT NULL,
  PRIMARY KEY (`MaLopHocPhan`,`NgayHoc`),
  CONSTRAINT `lichhoc_ibfk_1` FOREIGN KEY (`MaLopHocPhan`) REFERENCES `lophocphan` (`MaLopHocPhan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Bảng: lichthi (Exam Schedule)
CREATE TABLE `lichthi` (
  `MaLopThi` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayThi` datetime NOT NULL,
  PRIMARY KEY (`MaLopThi`,`NgayThi`),
  CONSTRAINT `lichthi_ibfk_1` FOREIGN KEY (`MaLopThi`) REFERENCES `lopthi` (`MaLopThi`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ===========================================================
-- HOÀN TẤT
-- ===========================================================

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
-- Set to UTF8MB4 instead of restoring old values (to avoid utf8mb3 warnings)
/*!40101 SET CHARACTER_SET_CLIENT=utf8mb4 */;
/*!40101 SET CHARACTER_SET_RESULTS=utf8mb4 */;
/*!40101 SET COLLATION_CONNECTION=utf8mb4_unicode_ci */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

SELECT 'Database structure created successfully. Ready to import CSV data.' AS Status;
