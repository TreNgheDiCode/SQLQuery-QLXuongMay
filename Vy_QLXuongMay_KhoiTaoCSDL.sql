/*vvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
---------------------------------
-->>>>QUẢN LÝ XƯỞNG DỆT MAY<<<<--
---------------------------------
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

------------------------
-->>>>KHỞI TẠO CSDL<<<--
------------------------

--Tạo database QLXuongMay
use master
if exists (select * from sysdatabases where name = 'QLXuongMay')
	drop database QLXuongMay
go
create database QLXuongMay
go
use QLXuongMay
go

------------------------------------
-->>>>KHỞI TẠO CÁC BẢNG LƯU TRỮ<<<--
------------------------------------

/*
	Bảng lưu trữ thông tin phòng ban
- MaPB: Khóa chính của bảng, dùng để định danh tính độc nhất của 1 phòng ban
- TenPB: Tên phòng ban, có thể dùng tiếng Việt có dấu
- DiaChi: Lưu trữ thông tin địa chỉ của phòng ban
*/
create table PHONGBAN (
	MaPB char(10) primary key,
	TenPB nvarchar(100),
	DiaChi nvarchar(100)
);
INSERT INTO PHONGBAN (MaPB, TenPB, DiaChi)
VALUES ('PB001', 'Phong Ban A', N'69 Hai Bà Trưng,P.Bến Nghé, Quận 1,TPHCM'),
       ('PB002', 'Phong Ban B', N'32 Võ Thị Sáu,Quận 3,TPHCM'),
       ('PB003', 'Phong Ban C', N'868 Su Van Hanh,Quận 10,TPHCM');

--Tạo bảng CHUCVU
create table CHUCVU (
	MaCV char(10) primary key,
	TenCV nvarchar(100),
	HeSoLuong float,
	HeSoThuong float,
	LoaiCV nvarchar(20)
);
INSERT INTO CHUCVU (MaCV, TenCV, HeSoLuong, HeSoThuong, LoaiCV)
VALUES ('CV001', N'Nhân viên may',1.2, 0.5, N'Toàn thời gian'),
       ('CV002', N'Nhà Thiết kế' ,1.5, 0.8, N'Toàn thời gian'),
       ('CV003', N'Giam đốc'     ,2.5, 0.9, N'Toàn thời gian');
/*
	Bảng lưu trữ thông tin nhân viên
- MaNV: Khóa chính của bảng, dùng để định danh tính độc nhất của 1 nhân viên.
- HoTen: Có thể gõ tiếng Việt có dấu, dùng lưu trữ họ tên nhân viên
- GioiTinh: Lưu trữ giới tính nhân viên - 0 là nam, 1 là nữ
- NgaySinh: Lưu trữ ngày sinh nhân viên theo dạng mặc định (năm/tháng/ ngày)
- DiaChi: Lưu trữ thông tin địa chỉ nơi ở hiện tại của nhân viên
- SoDienThoai: Lưu trữ số điện thoại liên hệ của nhân viên - tối đa 11 số
- TrinhDoHocVan: TH, THCS, THPT, CD, DH,...,
- MaPB: Mà phòng tham chiếu phòng ban nhân viên
- MaCV: Mã chức vụ tham chiếu công việc nhân viên
- MaTruongPhong: Mã định danh nhân viên là trưởng phòng hoặc không

*/
create table NHANVIEN (
	MaNV char(10) primary key,
	HoTen nvarchar(100),
	GioiTinh bit,
	NgaySinh date,
	DiaChi nvarchar(100),
	SoDienThoai char(11),
	TrinhDoHocVan varchar(5),
	MaPB char(10) foreign key references PHONGBAN(MaPB),
	MaCV char(10) foreign key references CHUCVU(MaCV),
	--THÊM: Mã trưởng phòng
	MaTruongPhong char(10) foreign key references NHANVIEN(MaNV) default null

);
INSERT INTO NHANVIEN (MaNV, HoTen, GioiTinh, NgaySinh, DiaChi, SoDienThoai, TrinhDoHocVan, MaPB, MaCV, MaTruongPhong)
VALUES ('NV001', N'Nguyễn Văn A', 1, '1990-05-15', N'Hà Nội'     , '01234567890', 'ĐH', 'PB001', 'CV002', NULL),
       ('NV002', N'Trần Thị B'  , 0, '1995-10-20', N'Hồ Chí Minh', '09876543210', 'CĐ', 'PB002', 'CV001', 'NV001'),
       ('NV003', N'Lê Công C'   , 1, '1988-03-08', N'Đà Nẵng'    , '07654321098', 'ĐH', 'PB002', 'CV002', 'NV001'),
       ('NV004', N'Phạm Thị D'  , 0, '1992-09-12', N'Hải Phòng'  , '05678901234', 'CĐ', 'PB003', 'CV001', 'NV001'),
       ('NV005', N'Trần Văn E'  , 1, '1993-06-25', N'Nghệ An'    , '02345678901', 'ĐH', 'PB002', 'CV001', 'NV003'),
       ('NV006', N'Hoàng Thị F' , 0, '1990-12-18', N'Hà Tĩnh'    , '04567890123', 'ĐH', 'PB001', 'CV003', NULL),
       ('NV007', N'Lê Văn G'    , 1, '1994-08-02', N'Quảng Bình' , '07890123456', 'CĐ', 'PB003', 'CV001', 'NV003');

--Tạo bảng LUONG
create table LUONG (
	MaNV char(10) foreign key references NHANVIEN(MaNV),
	Thang int,
	-- THÊM: Năm
	Nam int,
	SoNgayCong int default 0,
	TongTienLuong int default 0,
	TienThuong int default 0,
	TienPhat int default 0,
	constraint PK_LUONG primary key (MaNV, Thang)
);
INSERT INTO LUONG (MaNV, Thang, Nam, SoNgayCong, TongTienLuong, TienThuong, TienPhat)
VALUES ('NV001', 7, 2023, 20, 5000000, 500000, 0),
       ('NV002', 7, 2023, 18, 4500000, 300000, 0),
       ('NV003', 7, 2023, 22, 5500000, 600000, 0),
       ('NV004', 7, 2023, 19, 4800000, 0, 200000),
       ('NV005', 7, 2023, 21, 5200000, 350000, 0),
       ('NV006', 7, 2023, 18, 4500000, 200000, 0),
       ('NV007', 7, 2023, 23, 5800000, 700000, 0);

--Tạo bảng CONGVIEC
--Phòng ban là địa chỉ, Chức vụ là điều kiện để được nhận công việc
create table CONGVIEC (
	MaNV char(10) foreign key references NHANVIEN(MaNV),
	MaCV char(10) foreign key references CHUCVU(MaCV),
	MaPB char(10) foreign key references PHONGBAN(MaPB),
	TenCongViec nvarchar(100),
	SoNgayLam int default 0,
	SoNgayNghi int default 0,
	ThoiGianBatDau int,
	ThoiGianKetThuc int,
	-- XÓA: Lương theo giờ
	constraint PK_CONGVIEC primary key (MaNV, MACV, MaPB)
);
INSERT INTO CONGVIEC (MaNV, MaCV, MaPB, TenCongViec, SoNgayLam, SoNgayNghi, ThoiGianBatDau, ThoiGianKetThuc)
VALUES ('NV001', 'CV001', 'PB001', N'Cắt may', 20, 2, 8, 16),
       ('NV002', 'CV002', 'PB002', N'Thiết kế', 18, 4, 9, 17),
       ('NV003', 'CV002', 'PB002', N'Thiết kế', 22, 1, 8, 16),
       ('NV004', 'CV001', 'PB003', N'Cắt may', 19, 3, 7, 15),
       ('NV005', 'CV001', 'PB002', N'Cắt may', 21, 1, 8, 16),
       ('NV006', 'CV003', 'PB001', N'Vận hành', 18, 5, 9, 17),
       ('NV007', 'CV001', 'PB003', N'Cắt may', 23, 0, 7, 15);
--Tạo bảng DIEMDANH
create table DIEMDANH (
	Ngay date,
	MaNV char(10) foreign key references NHANVIEN(MaNV),
	SoGioLam int default 0,
	constraint PK_DIEMDANH primary key (Ngay, MaNV)
);
INSERT INTO DIEMDANH (Ngay, MaNV, SoGioLam)
VALUES ('2023-07-01', 'NV001', 8),
       ('2023-07-01', 'NV002', 7),
       ('2023-07-01', 'NV003', 8),
       ('2023-07-02', 'NV002', 6),
       ('2023-07-02', 'NV004', 7),
       ('2023-07-03', 'NV003', 8),
       ('2023-07-03', 'NV005', 8);
--Tạo bảng KHACHHANG
create table KHACHHANG (
	MaKH char(10) primary key,
	HoTen nvarchar(100),
	GioiTinh nchar(10),
	NgaySinh date,
	DiaChi nvarchar(100),
	SoDienThoai char(15)
); 

INSERT INTO KHACHHANG (MaKH, HoTen, GioiTinh, NgaySinh, DiaChi, SoDienThoai)
VALUES ('KH001', N'Nguyễn Văn A', N'Nam', '1990-05-15', N'Hà Nội', '012345678901'),
       ('KH002', N'Trần Thị B', N'Nữ', '1995-10-20', N'Hồ Chí Minh', '098765432101'),
       ('KH003', N'Lê Công C', N'Nam', '1988-03-08', N'Đà Nẵng', '076543210981'),
       ('KH004', N'Phạm Thị D', N'Nữ', '1992-09-12', N'Hải Phòng', '056789012345'),
       ('KH005', N'Trần Văn E', N'Nam', '1993-06-25', N'Nghệ An', '023456789012'),
       ('KH006', N'Hoàng Thị F', N'Nữ', '1990-12-18', N'Hà Tĩnh', '045678901234'),
       ('KH007', N'Lê Văn G', N'Nam', '1994-08-02', N'Quảng Bình', '078901234567');

--XÓA: bảng MAUSAC

--Tạo bảng SANPHAM
create table SANPHAM (
	MaSP char(10) primary key,
	TenSP nvarchar(100),
	KichThuoc varchar(50),
	MauSac nvarchar(100),
	GiaThanh int default 100000,
	LoaiSP nvarchar(50),
);
INSERT INTO SANPHAM (MaSP, TenSP, KichThuoc, MauSac, GiaThanh, LoaiSP)
VALUES ('SP001', N'Áo thun', 'M', N'Denim', 150000, N'Áo'),
       ('SP002', N'Quần jeans', 'L', N'Xanh', 250000, N'Quần'),
       ('SP003', N'Váy dài', 'XL', N'Hồng', 180000, N'Váy'),
       ('SP004', N'Giày sneaker', '39', N'Trắng', 300000, N'Giày'),
       ('SP005', N'Balo học sinh', 'N/A', N'Đen', 120000, N'Túi xách');

--Tạo bảng KHOHANG
create table KHOHANG (
	MaSP char(10) foreign key references SANPHAM(MaSP),
	SoLuongTon int,
	constraint PK_KHOHANG primary key (MaSP)
);
 INSERT INTO KHOHANG (MaSP, SoLuongTon)
VALUES ('SP001', 50),
       ('SP002', 30),
       ('SP003', 20),
       ('SP004', 40),
       ('SP005', 15);
--Tạo bảng DONHANG
create table DONHANG(
	MaDH char(10) primary key,
	NgayDatHang date,
	TrangThai nvarchar(20),
	MaKH char(10) foreign key references KHACHHANG(MaKH),
	MaNV char(10) foreign key references NHANVIEN(MaNV)
);


INSERT INTO DONHANG (MaDH, NgayDatHang, TrangThai, MaKH, MaNV)
VALUES ('DH001', '2023-07-01', N'Đã giao', 'KH001', 'NV001'),
       ('DH002', '2023-07-02', N'Đang xử lý', 'KH002', 'NV002'),
       ('DH003', '2023-07-03', N'Đã hủy', 'KH003', 'NV003'),
       ('DH004', '2023-07-04', N'Chờ xác nhận', 'KH004', 'NV001'),
       ('DH005', '2023-07-05', N'Đã giao', 'KH005', 'NV002');
--Tạo bảng HOADON thể hiện mối quan hệ nhiều nhiều giữa 2 bảng DONHANG và SANPHAM
create table HOADON (
	--THÊM: Mã hóa đơn
	MaHD char(10),
	MaSP char(10),
	MaDH char(10),
	SoLuong int,
	TongTien int,
	KhuyenMai int,
	--SỬA: Khóa chính gồm Mã hóa đơn và mã đơn hàng
	constraint PK_DONHANG_SANPHAM primary key (MaHD, MaDH),
	constraint FK_SANPHAM foreign key (MaSP) references SANPHAM(MaSP),
	constraint FK_DONHANG foreign key (MaDH) references DONHANG(MaDH)
);
INSERT INTO HOADON (MaHD, MaSP, MaDH, SoLuong, TongTien, KhuyenMai)
VALUES ('HD001', 'SP001', 'DH001', 2, 300000, 50000),
       ('HD002', 'SP002', 'DH001', 1, 250000, 0),
       ('HD003', 'SP003', 'DH002', 3, 540000, 20000),
       ('HD004', 'SP004', 'DH003', 1, 300000, 10000),
       ('HD005', 'SP001', 'DH004', 4, 600000, 0);







GO
CREATE PROCEDURE INSERT_KHACHHANG
    @MaKH CHAR(10), -- Mã khách hàng
    @HoTen NVARCHAR(100), -- Họ tên khách hàng
    @GioiTinh NCHAR(10), -- Giới tính khách hàng
    @NgaySinh DATE, -- Ngày sinh khách hàng
    @DiaChi NVARCHAR(100), -- Địa chỉ khách hàng
    @SoDienThoai CHAR(15) -- Số điện thoại khách hàng
AS
BEGIN
        -- Thêm thông tin khách hàng vào bảng KHACHHANG
        INSERT INTO KHACHHANG (MaKH, HoTen, GioiTinh, NgaySinh, DiaChi, SoDienThoai)
        VALUES (@MaKH, @HoTen, @GioiTinh, @NgaySinh, @DiaChi, @SoDienThoai)
    END

GO
CREATE PROCEDURE UPDATE_KHACHHANG
    @MaKH CHAR(10), -- Mã khách hàng
    @HoTen NVARCHAR(100), -- Họ tên khách hàng
    @GioiTinh NCHAR(10), -- Giới tính khách hàng
    @NgaySinh DATE, -- Ngày sinh khách hàng
    @DiaChi NVARCHAR(100), -- Địa chỉ khách hàng
    @SoDienThoai CHAR(15) -- Số điện thoại khách hàng
   AS
    BEGIN
        -- Cập nhật thông tin khách hàng trong bảng KHACHHANG
        UPDATE KHACHHANG
        SET HoTen = @HoTen,
            GioiTinh = @GioiTinh,
            NgaySinh = @NgaySinh,
            DiaChi = @DiaChi,
            SoDienThoai = @SoDienThoai
        WHERE MaKH = @MaKH
    END
GO
CREATE PROCEDURE DELETE_KHACHHANG
    @MaKH CHAR(10), -- Mã khách hàng
    @HoTen NVARCHAR(100), -- Họ tên khách hàng
    @GioiTinh NCHAR(10), -- Giới tính khách hàng
    @NgaySinh DATE, -- Ngày sinh khách hàng
    @DiaChi NVARCHAR(100), -- Địa chỉ khách hàng
    @SoDienThoai CHAR(15) -- Số điện thoại khách hàng
   AS
    BEGIN
        -- Xóa thông tin khách hàng khỏi bảng KHACHHANG
        DELETE FROM KHACHHANG
        WHERE MaKH = @MaKH
    END

--Để sử dụng stored procedure này, bạn có thể gọi nó bằng cách sử dụng câu lệnh EXECUTE hoặc EXEC:
-- Gọi stored procedure để thêm một khách hàng mới

EXECUTE INSERT_KHACHHANG  @MaKH = 'KH008', @HoTen = N'Nguyễn Văn A', @GioiTinh = N'Nam', @NgaySinh = '1990-01-01', @DiaChi = N'Hà Nội', @SoDienThoai = '0123456789'
-- Gọi stored procedure để cập nhật thông tin của một khách hàng
EXECUTE UPDATE_KHACHHANG @MaKH = 'KH008', @HoTen = N'Nguyễn Văn A', @GioiTinh = N'Nam', @NgaySinh = '1990-01-01', @DiaChi = N'Dia chi da update', @SoDienThoai = '0123456789'

-- Gọi stored procedure để xóa một khách hàng
EXECUTE DELETE_KHACHHANG @MaKH = 'KH008', @HoTen = NULL, @GioiTinh = NULL, @NgaySinh = NULL, @DiaChi = NULL, @SoDienThoai = NULL

SELECT * FROM KhachHang




GO
CREATE PROCEDURE INSERT_NhanVien
	@MaNV char(10),
	@HoTen nvarchar(100),
	@GioiTinh bit,
	@NgaySinh date,
	@DiaChi nvarchar(100),
	@SoDienThoai char(11),
	@TrinhDoHocVan varchar(5),
	@MaPB char(10),
	@MaCV char(10),
	@MaTruongPhong char(10) = NULL
AS
BEGIN
	INSERT INTO NHANVIEN (MaNV, HoTen, GioiTinh, NgaySinh, DiaChi, SoDienThoai, TrinhDoHocVan, MaPB, MaCV, MaTruongPhong)
	VALUES (@MaNV, @HoTen, @GioiTinh, @NgaySinh, @DiaChi, @SoDienThoai, @TrinhDoHocVan, @MaPB, @MaCV, @MaTruongPhong)
END

GO
CREATE PROCEDURE UPDATE_NhanVien
	@MaNV char(10),
	@HoTen nvarchar(100),
	@GioiTinh bit,
	@NgaySinh date,
	@DiaChi nvarchar(100),
	@SoDienThoai char(11),
	@TrinhDoHocVan varchar(5),
	@MaPB char(10),
	@MaCV char(10),
	@MaTruongPhong char(10) = NULL
AS
BEGIN
	UPDATE NHANVIEN
	SET HoTen = @HoTen,
		GioiTinh = @GioiTinh,
		NgaySinh = @NgaySinh,
		DiaChi = @DiaChi,
		SoDienThoai = @SoDienThoai,
		TrinhDoHocVan = @TrinhDoHocVan,
		MaPB = @MaPB,
		MaCV = @MaCV,
		MaTruongPhong = @MaTruongPhong
	WHERE MaNV = @MaNV
END

GO
CREATE PROCEDURE DELETE_NhanVien
	@MaNV char(10)
AS
BEGIN
	DELETE FROM NHANVIEN
	WHERE MaNV = @MaNV
END


-- Gọi stored procedure để thêm một nhân viên mới
EXECUTE INSERT_NhanVien @MaNV='NV008', @HoTen=N'Tên nhân viên mới', @GioiTinh=1, @NgaySinh='2000-01-01', @DiaChi=N'Địa chỉ mới', @SoDienThoai='01234567890', @TrinhDoHocVan='THPT',  @MaPB='PB001',  @MaCV='CV001', @MaTruongPhong=NULL

-- Gọi stored procedure để cập nhật thông tin của một nhân viên
EXECUTE UPDATE_NhanVien @MaNV='NV008', @HoTen=N'Tên nhân viên đã sửa đổi', @GioiTinh=0, @NgaySinh='2000-01-01', @DiaChi=N'Địa chỉ đã sửa đổi', @SoDienThoai='09876543210', @TrinhDoHocVan='Đại học',  @MaPB='PB002',  @MaCV='CV002', @MaTruongPhong='NV002'

-- Gọi stored procedure để xóa một nhân viên
EXECUTE DELETE_NhanVien @MaNV='NV008'

select * from NHANVIEN