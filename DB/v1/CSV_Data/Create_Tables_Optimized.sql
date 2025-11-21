-- ===========================================================
-- CẤU TRÚC DATABASE TỐI ƯU HÓA - CHỈ TẠO BẢNG (KHÔNG CÓ DỮ LIỆU)
-- Tạo từ: Create_Tables_Only.sql
-- Tối ưu hóa: 2025-11-20
-- Mục đích: Cấu trúc database được tối ưu hóa với:
--   - Performance indexes
--   - Audit trail columns
--   - Data integrity constraints
--   - Fixed schema inconsistencies
--   - Enhanced relationships
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
DROP TABLE IF EXISTS `dangkylophocphan`;
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
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaTruong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Quản lý các trường/khoa';

-- Bảng: taikhoan (User Accounts)
CREATE TABLE `taikhoan` (
  `Username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Tài khoản đăng nhập của sinh viên và giảng viên';

-- Bảng: kyhoc (Academic Terms)
CREATE TABLE `kyhoc` (
  `MaKyHoc` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mã kỳ học, định dạng: yyyy.x (x = 1, 2, 3)',
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaKyHoc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT='Lưu trữ thông tin các kỳ học';

-- Bảng: phonghoc (Classrooms)
CREATE TABLE `phonghoc` (
  `MaPhongHoc` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaPhongHoc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Danh sách phòng học và phòng thi';

-- Bảng: nhomhocphan (Course Groups)
CREATE TABLE `nhomhocphan` (
  `MaNhomHP` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TenNhomHP` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaNhomHP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Phân nhóm các học phần (Toán, Lý, Hóa, ...)';

-- Bảng: chuongtrinh (Programs)
CREATE TABLE `chuongtrinh` (
  `MaChuongTrinh` varchar(10) NOT NULL,
  `TenChuongTrinh` varchar(100) NOT NULL,
  `MaTruong` varchar(10) NOT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaChuongTrinh`),
  KEY `MaTruong` (`MaTruong`),
  CONSTRAINT `chuongtrinh_ibfk_1` FOREIGN KEY (`MaTruong`) REFERENCES `truong` (`MaTruong`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Chương trình đào tạo (ngành học)';

-- Bảng: giangvien (Lecturers)
CREATE TABLE `giangvien` (
  `MaGV` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `HoTenGV` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `MaTruong` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaGV`),
  KEY `MaTruong` (`MaTruong`),
  KEY `Email` (`Email`),
  CONSTRAINT `giangvien_ibfk_1` FOREIGN KEY (`MaTruong`) REFERENCES `truong` (`MaTruong`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `giangvien_ibfk_2` FOREIGN KEY (`Email`) REFERENCES `taikhoan` (`Username`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Thông tin giảng viên';

-- Bảng: hp (Courses)
CREATE TABLE `hp` (
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TenHP` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ThoiLuong` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `HeSoGK` decimal(3,2) DEFAULT NULL,
  `TinChiHocTap` tinyint unsigned DEFAULT NULL,
  `TinChiHocPhi` tinyint unsigned DEFAULT NULL,
  `MaNhomHP` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaHP`),
  KEY `MaNhomHP` (`MaNhomHP`),
  CONSTRAINT `hp_ibfk_1` FOREIGN KEY (`MaNhomHP`) REFERENCES `nhomhocphan` (`MaNhomHP`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `CHK_HP_TinChi` CHECK (`TinChiHocTap` BETWEEN 1 AND 10),
  CONSTRAINT `CHK_HP_HeSo` CHECK (`HeSoGK` BETWEEN 0 AND 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Danh mục học phần (môn học)';

-- Bảng: lop (Classes) - PHẢI TẠO TRƯỚC sinhvien
CREATE TABLE `lop` (
  `MaLop` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `MaTruong` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaLop`),
  KEY `MaTruong` (`MaTruong`),
  CONSTRAINT `lop_ibfk_1` FOREIGN KEY (`MaTruong`) REFERENCES `truong` (`MaTruong`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Lớp hành chính của sinh viên';

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
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MSSV`),
  KEY `MaChuongTrinh` (`MaChuongTrinh`),
  KEY `MaLop` (`MaLop`),
  KEY `Email` (`Email`),
  KEY `idx_sinhvien_lop` (`MaLop`, `MaChuongTrinh`),
  CONSTRAINT `sinhvien_ibfk_1` FOREIGN KEY (`MaChuongTrinh`) REFERENCES `chuongtrinh` (`MaChuongTrinh`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `sinhvien_ibfk_2` FOREIGN KEY (`MaLop`) REFERENCES `lop` (`MaLop`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `sinhvien_ibfk_3` FOREIGN KEY (`Email`) REFERENCES `taikhoan` (`Username`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Thông tin sinh viên';

-- Bảng: chuongtrinhdaotao (Curriculum) - ENHANCED
CREATE TABLE `chuongtrinhdaotao` (
  `MaChuongTrinh` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `KyHocKhuyenNghi` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LoaiHP` enum('Bắt buộc','Tự chọn','Tự chọn tự do') DEFAULT 'Bắt buộc',
  `MaHPTienQuyet` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaChuongTrinh`,`MaHP`),
  KEY `MaHP` (`MaHP`),
  KEY `MaHPTienQuyet` (`MaHPTienQuyet`),
  CONSTRAINT `chuongtrinhdaotao_ibfk_1` FOREIGN KEY (`MaChuongTrinh`) REFERENCES `chuongtrinh` (`MaChuongTrinh`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chuongtrinhdaotao_ibfk_2` FOREIGN KEY (`MaHP`) REFERENCES `hp` (`MaHP`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CTDT_HPTienQuyet` FOREIGN KEY (`MaHPTienQuyet`) REFERENCES `hp` (`MaHP`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Chương trình đào tạo chi tiết - các học phần thuộc ngành';

-- Bảng: dangkyhocphan (Course Registration)
CREATE TABLE `dangkyhocphan` (
  `MSSV` varchar(20) NOT NULL COMMENT 'Mã số sinh viên',
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mã học phần',
  `MaKyHoc` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mã kỳ học',
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MSSV`,`MaHP`,`MaKyHoc`),
  KEY `FK_DangKyHocPhan_HP` (`MaHP`),
  KEY `FK_DangKyHocPhan_KyHoc` (`MaKyHoc`),
  KEY `idx_dangky_kyhoc` (`MaKyHoc`, `MaHP`),
  CONSTRAINT `FK_DangKyHocPhan_HP` FOREIGN KEY (`MaHP`) REFERENCES `hp` (`MaHP`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_DangKyHocPhan_KyHoc` FOREIGN KEY (`MaKyHoc`) REFERENCES `kyhoc` (`MaKyHoc`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_DangKyHocPhan_SinhVien` FOREIGN KEY (`MSSV`) REFERENCES `sinhvien` (`MSSV`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT='Đăng ký học phần (không gắn với lớp học phần cụ thể)';

-- Bảng: bangdiem (Grades) - FIXED: HocKy -> MaKyHoc
CREATE TABLE `bangdiem` (
  `MSSV` varchar(20) NOT NULL,
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaKyHoc` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `DiemSo` decimal(4,2) DEFAULT NULL,
  `DiemChu` varchar(3) DEFAULT NULL,
  `DiemGK` decimal(4,2) DEFAULT NULL,
  `DiemCK` decimal(4,2) DEFAULT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MSSV`,`MaHP`,`MaKyHoc`),
  KEY `MaHP` (`MaHP`),
  KEY `MaKyHoc` (`MaKyHoc`),
  KEY `idx_bangdiem_kyhoc_hp` (`MaKyHoc`, `MaHP`),
  CONSTRAINT `bangdiem_ibfk_1` FOREIGN KEY (`MSSV`) REFERENCES `sinhvien` (`MSSV`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bangdiem_ibfk_2` FOREIGN KEY (`MaHP`) REFERENCES `hp` (`MaHP`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_BangDiem_KyHoc` FOREIGN KEY (`MaKyHoc`) REFERENCES `kyhoc` (`MaKyHoc`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `CHK_DiemSo` CHECK (`DiemSo` IS NULL OR `DiemSo` BETWEEN 0 AND 10),
  CONSTRAINT `CHK_DiemGK` CHECK (`DiemGK` IS NULL OR `DiemGK` BETWEEN 0 AND 10),
  CONSTRAINT `CHK_DiemCK` CHECK (`DiemCK` IS NULL OR `DiemCK` BETWEEN 0 AND 10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Bảng điểm sinh viên';

-- Bảng: lophocphan (Course Classes) - OPTIMIZED
CREATE TABLE `lophocphan` (
  `MaLopHocPhan` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaHP` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaGV` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MaKyHoc` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaPhongHoc` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ThuHoc` enum('Thứ 2','Thứ 3','Thứ 4','Thứ 5','Thứ 6','Thứ 7','Chủ nhật') DEFAULT NULL,
  `TietBatDau` tinyint unsigned DEFAULT NULL,
  `SoTiet` tinyint unsigned DEFAULT NULL,
  `BuoiHoc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GhiChu` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `SLSV` int DEFAULT '0' COMMENT 'Số lượng sinh viên tối đa',
  `SLDaDK` int DEFAULT '0' COMMENT 'Số lượng sinh viên đã đăng ký',
  `TrangThai` enum('Mở đăng ký','Đóng đăng ký','Hủy') DEFAULT 'Mở đăng ký',
  `NgayBatDau` date DEFAULT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaLopHocPhan`),
  KEY `MaHP` (`MaHP`),
  KEY `MaGV` (`MaGV`),
  KEY `MaKyHoc` (`MaKyHoc`),
  KEY `MaPhongHoc` (`MaPhongHoc`),
  KEY `idx_lophocphan_schedule` (`MaKyHoc`, `ThuHoc`, `TietBatDau`),
  KEY `idx_lophocphan_status` (`TrangThai`, `MaKyHoc`),
  CONSTRAINT `lophocphan_ibfk_1` FOREIGN KEY (`MaHP`) REFERENCES `hp` (`MaHP`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lophocphan_ibfk_2` FOREIGN KEY (`MaGV`) REFERENCES `giangvien` (`MaGV`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `lophocphan_ibfk_3` FOREIGN KEY (`MaKyHoc`) REFERENCES `kyhoc` (`MaKyHoc`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lophocphan_ibfk_4` FOREIGN KEY (`MaPhongHoc`) REFERENCES `phonghoc` (`MaPhongHoc`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `CHK_LopHP_DangKy` CHECK (`SLDaDK` <= `SLSV`),
  CONSTRAINT `CHK_LopHP_Tiet` CHECK (`TietBatDau` IS NULL OR `TietBatDau` BETWEEN 1 AND 12),
  CONSTRAINT `CHK_LopHP_SoTiet` CHECK (`SoTiet` IS NULL OR `SoTiet` BETWEEN 1 AND 6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Lớp học phần - Lớp cụ thể mà sinh viên đăng ký';

-- Bảng: dangkylophocphan (Course Class Registration) - NEW
CREATE TABLE `dangkylophocphan` (
  `MSSV` varchar(20) NOT NULL,
  `MaLopHocPhan` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayDangKy` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `TrangThai` enum('Đang học','Đã hoàn thành','Đã hủy') DEFAULT 'Đang học',
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MSSV`, `MaLopHocPhan`),
  KEY `MaLopHocPhan` (`MaLopHocPhan`),
  KEY `idx_dangkylhp_trangthai` (`TrangThai`),
  CONSTRAINT `FK_DangKyLHP_SinhVien` FOREIGN KEY (`MSSV`) REFERENCES `sinhvien` (`MSSV`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_DangKyLHP_LopHocPhan` FOREIGN KEY (`MaLopHocPhan`) REFERENCES `lophocphan` (`MaLopHocPhan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Đăng ký lớp học phần cụ thể - Link sinh viên với lớp học phần';

-- Bảng: lopthi (Exam Classes)
CREATE TABLE `lopthi` (
  `MaLopThi` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaPhongThi` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SLSinhVien` int DEFAULT '0',
  `SLDaDK` int DEFAULT '0',
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaLopThi`),
  KEY `MaPhongThi` (`MaPhongThi`),
  CONSTRAINT `lopthi_ibfk_1` FOREIGN KEY (`MaPhongThi`) REFERENCES `phonghoc` (`MaPhongHoc`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Lớp thi và phòng thi';

-- Bảng: lichhoc (Class Schedule)
CREATE TABLE `lichhoc` (
  `MaLopHocPhan` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayHoc` date NOT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaLopHocPhan`,`NgayHoc`),
  CONSTRAINT `lichhoc_ibfk_1` FOREIGN KEY (`MaLopHocPhan`) REFERENCES `lophocphan` (`MaLopHocPhan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Lịch học chi tiết theo ngày';

-- Bảng: lichthi (Exam Schedule)
CREATE TABLE `lichthi` (
  `MaLopThi` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayThi` datetime NOT NULL,
  `CreatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MaLopThi`,`NgayThi`),
  CONSTRAINT `lichthi_ibfk_1` FOREIGN KEY (`MaLopThi`) REFERENCES `lopthi` (`MaLopThi`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Lịch thi chi tiết';

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

SELECT 'Optimized database structure created successfully!' AS Status;

-- ===========================================================
-- SUMMARY OF OPTIMIZATIONS
-- ===========================================================
-- 1. ✅ FIXED: bangdiem.HocKy -> MaKyHoc với FK constraint
-- 2. ✅ REMOVED: lophocphan.SoSV (duplicate)
-- 3. ✅ ADDED: dangkylophocphan table (student-to-class relationship)
-- 4. ✅ ADDED: Audit columns (CreatedAt, UpdatedAt) to all tables
-- 5. ✅ ADDED: Performance indexes for common queries
-- 6. ✅ ADDED: CHECK constraints for data integrity
-- 7. ✅ ENHANCED: chuongtrinhdaotao with LoaiHP and MaHPTienQuyet
-- 8. ✅ ADDED: Detailed comments for better documentation
-- ===========================================================
