/*vvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
---------------------------------
-->>>>QUẢN LÝ XƯỞNG DỆT MAY<<<<--
---------------------------------
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

------------------------
-->>>>KHỞI TẠO CSDL<<<--
------------------------
/*
	Mindset khi tạo các cột thuộc tính cho bảng
- Tên ngắn gọn, dễ hiểu, bám sát vào kiểu dữ liệu và độ dài dữ liệu
- Thuộc tính phải thể hiện tính độc nhất hoặc minh bạch
- Thuộc tính được tạo ra từ bảng quan hệ nhiều nhiều sẽ thể hiện các phép tính được tính DUY NHẤT từ bảng thuộc quan hệ
- Thuộc tính có trong bảng (trừ nhiều nhiều) có thể được tính từ thuộc tính của các bảng khác
*/

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
	TenPB nvarchar(100) not null,
	DiaChi nvarchar(100) not null
);

/*
	Bảng lưu trữ thông tin chức vụ
- MaCV: Khóa chính của bảng, dùng để định danh tính độc nhất của 1 chức vụ
- TenCV: Tên chức vụ, có thể dùng có dấu
- HeSoLuong: Hệ số lương của chức vụ, sử dụng số thập phân
- HeSoThuong: Hệ số thưởng của chức vụ, sử dụng số thập phân
- LoaiCV: Loại chức vụ, làm việc toàn thời gian hoặc bán thời gian
*/
create table CHUCVU (
	MaCV char(10) primary key,
	TenCV nvarchar(100) not null,
	HeSoLuong float default 0,
	HeSoThuong float default 0,
	LoaiCV nvarchar(20)
);

/*
	Bảng lưu trữ thông tin nhân viên
- MaNV: Khóa chính của bảng, dùng để định danh tính độc nhất của 1 nhân viên.
- HinhDaiDien: Ảnh đại diện của nhân viên
- HoTen: Có thể gõ tiếng Việt có dấu, dùng lưu trữ họ tên nhân viên
- GioiTinh: Lưu trữ giới tính nhân viên - 0 là nam, 1 là nữ
- NgaySinh: Lưu trữ ngày sinh nhân viên theo dạng mặc định (năm/tháng/ ngày)
- DiaChi: Lưu trữ thông tin địa chỉ nơi ở hiện tại của nhân viên
- Email: Địa chỉ Email của nhân viên.
- SoDienThoai: Lưu trữ số điện thoại liên hệ của nhân viên - tối đa 11 số
- TrinhDoHocVan: TH, THCS, THPT, CD, DH,...,
- CCCD_CMT: Mã căn cước công dân hoặc chứng minh thư của nhân viên
- MaPB: Mà phòng tham chiếu phòng ban nhân viên
- MaCV: Mã chức vụ tham chiếu công việc nhân viên
- MaTruongPhong: Mã định danh nhân viên là trưởng phòng hoặc không
*/
create table NHANVIEN (
	MaNV char(10) primary key,
	HinhDaiDien Image,
	HoTen nvarchar(100) not null,
	GioiTinh bit not null,
	NgaySinh date not null,
	DiaChi nvarchar(100) not null,
	Email nvarchar(100),
	SoDienThoai char(11) not null,
	TrinhDoHocVan varchar(5) not null,
	CCCD_CMT varchar(20) not null,
	MaPB char(10) foreign key references PHONGBAN(MaPB) on delete cascade,
	MaCV char(10) foreign key references CHUCVU(MaCV) on delete cascade,
	MaTruongPhong char(10) foreign key references NHANVIEN(MaNV) default null
);

/*
	Bảng lưu trữ thông tin lương
- NgayNhanLuong: Khóa chính của bảng, thể hiện tính độc nhất của 1 tập ghi về lương, ngày nhận lương của nhân viên
- LuongCung: Lương cứng của nhân viên (Được tính bằng công thức Lương cơ bản [Khởi tạo chung] * Hệ số lương [Chức vụ] * Số giờ làm [Bảng NhanVienDiemDanh]
*/
create table LUONG (
	NgayNhanLuong datetime2 primary key,
	LuongCung int default 0,
	LuongThuong int default 0,
	LuongPhat int default 0,
);

/*
	Bảng thể hiện quan hệ nhiều nhiều giữa Nhân viên và Lương
- MaNV, NgayNhanLuong: Khóa chính của bảng gồm 2 thuộc tính là Mã nhân viên và Ngày nhận lương
*/
create table NHANVIEN_LUONG (
	MaNV char(10),
	NgayNhanLuong datetime2 default GETDATE(),
	constraint PK_NhanVien_Luong primary key (MaNV, NgayNhanLuong),
	constraint FK_NhanVienLuong_NhanVien foreign key (MaNV) references NHANVIEN(MaNV),
	constraint FK_NhanVienLuong_Luong foreign key (NgayNhanLuong) references LUONG(NgayNhanLuong)
);

/*
	Bảng lưu trữ thông tin công việc cho nhân viên đăng ký
- MaCongViec: Khóa chính của bảng, tính độc nhất của 1 dòng dữ liệu công việc
- MaPhongBan: Mã phòng ban (thay thế cho tác dụng địa chỉ thực thi công việc)
- MaChucVu: Mã chức vụ (thay thế cho tác dụng điều kiện tối thiểu để được nhận công việc)
- TenCongViec: Tiêu đề ngắn gọn thể hiện việc làm của công việc
- NoiDungCongViec: Miêu tả chi tiết công việc
- NgayBatDau: Ngày bắt đầu thực hiện công việc
- NgayKetThuc: Ngày kết thúc công việc
- SoLuong: Số lượng người có thể nhận công việc
- SoNguoiNhan: Số lượng người theo thời gian thực đang nhận công việc
*/
create table CONGVIEC (
	MaCongViec char(10) primary key,
	MaPhongBan char(10),
	MaChucVu char(10),
	TenCongViec nvarchar(100) not null,
	NoiDungCongViec nvarchar(max) not null,
	NgayBatDau datetime2 not null,
	NgayKetThuc datetime2 not null,
	SoLuong int not null,
	SoNguoiNhan int default 0,
	constraint FK_CongViec_PhongBan foreign key (MaPhongBan) references PHONGBAN(MaPB) on delete cascade,
	constraint FK_CongViec_ChucVu foreign key (MaChucVu) references CHUCVU(MaCV) on delete cascade
);

/*
	Bảng thể hiện quan hệ nhiều nhiều giữa Nhân viên và Công việc
- MaNV, MaCV: Khóa chính của bảng gồm các thuộc tính Mã nhân viên và Mã công việc
*/
create table NHANVIEN_CONGVIEC (
	MaNV char(10),
	MaCV char(10),
	constraint PK_NhanVien_CongViec primary key (MaNV, MaCV),
	constraint FK_NhanVienCongViec_NhanVien foreign key (MaNV) references NHANVIEN(MaNV),
	constraint FK_NhanVienCongViec_CongViec foreign key (MaCV) references CONGVIEC(MaCongViec)
)
	
/*
	Bảng lưu trữ thông tin điểm danh của nhân viên
- ThoiGianDiemDanh: Thời gian điểm danh bắt đầu làm việc của nhân viên
- ThoiGianKetThuc: Thời gian kết thúc phiên làm việc tính từ lúc nhân viên xác nhận
*/
create table DIEMDANH (
	ThoiGianDiemDanh datetime2 default GETDATE(),
	ThoiGianKetThuc datetime2 default GETDATE(),
	constraint PK_DIEMDANH primary key (ThoiGianDiemDanh, ThoiGianKetThuc)
);

/*
	Bảng thể hiện quan hệ nhiều nhiều giữa Nhân viên và Điểm danh
- MaNV, ThoiGianDiemDanh, ThoiGianKetThuc: Khóa chính của bảng gồm các thuộc tính Mã nhân viên, Thời gian điểm danh, Thời gian kết thúc
*/
create table NHANVIEN_DIEMDANH (
	MaNV char(10),
	ThoiGianDiemDanh datetime2,
	ThoiGianKetThuc datetime2,
	constraint PK_NhanVien_DiemDanh primary key (MaNV, ThoiGianDiemDanh, ThoiGianKetThuc),
	constraint FK_NhanVienDiemDanh_NhanVien foreign key (MaNV) references NHANVIEN(MaNV),
	constraint FK_NhanVienDiemDanh_DiemDanh foreign key (ThoiGianDiemDanh, ThoiGianKetThuc) references DIEMDANH(ThoiGianDiemDanh, ThoiGianKetThuc)
)

--Tạo bảng KHACHHANG
create table KHACHHANG (
	MaKH char(10) primary key,
	HoTen nvarchar(100),
	GioiTinh nchar(10),
	NgaySinh date,
	DiaChi nvarchar(100),
	SoDienThoai char(15)
);

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

--Tạo bảng KHOHANG
create table KHOHANG (
	MaSP char(10) foreign key references SANPHAM(MaSP),
	SoLuongTon int,
	constraint PK_KHOHANG primary key (MaSP)
);

--Tạo bảng DONHANG
create table DONHANG(
	MaDH char(10) primary key,
	NgayDatHang date,
	TrangThai nvarchar(20),
	MaKH char(10) foreign key references KHACHHANG(MaKH),
	MaNV char(10) foreign key references NHANVIEN(MaNV)
);

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