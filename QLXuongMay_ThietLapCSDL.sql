/*vvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
---------------------------------
-->>>>QUẢN LÝ XƯỞNG DỆT MAY<<<<--
---------------------------------
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

----------------------------------
-->>>>THIẾT LẬP CƠ SỞ DỮ LIỆU<<<--
----------------------------------
--Khởi tạo các hàm
--Khởi tạo các thủ tục
--Khởi tạo các constraint check
--Khởi tạo các khóa ngoại (nếu có)
--Khởi tạo các trigger
use QLXuongMay;
go

------------------------------
-->>>>RÀNG BUỘC VỚI CHECK<<<--
------------------------------
/*
- Đối với bảng KHACHHANG
	○ Giới tính chỉ có thể là NAM hoặc NỮ (CK_KHACHHANG_KiemTraGioiTinh)
	○ Khách hàng phải trên 0 tuổi và không vượt quá 100 tuổi (CK_KHACHHANG_KiemTraSoTuoi)
	○ Năm sinh của khách hàng không được vượt quá năm hiện tại (CK_KHACHHANG_KiemTraNamSinh)
*/
alter table KHACHHANG
	add constraint CK_KHACHHANG_KiemTraGioiTinh check (
		GioiTinh in (N'Nam', N'Nữ')
	),
	constraint CK_KHACHHANG_KiemTraSoTuoi check (
		year(getdate()) - year(NgaySinh) > 0 
		and year(getdate()) - year(NgaySinh) <= 100
	),
	constraint CK_KHACHHANG_KiemTraNamSinh check (
		year(NgaySinh) <= year(getdate())
	)

/*
- Đối với bảng CHUCVU
	○ Hệ số lương của chức vụ chỉ được dao động từ 1.1 --> 3.0 (CK_CHUCVU_KiemTraHeSoLuong)
	○ Hệ số thưởng của chức vụ chỉ được dao động từ 0.5 --> 1.2 (CK_CHUCVU_KiemTraHeSoThuong)
	○ Loại chức vụ chỉ có thể là Trưởng phòng, Quản lý, Giám đốc, Phó giám đốc, Nhân viên (CK_CHUCVU_KiemTraLoaiChucVu)
*/
alter table CHUCVU
	add constraint CK_CHUCVU_KiemTraHeSoLuong check (
		HeSoLuong >= 1.1 and HeSoLuong <= 3.0
	),
	constraint CK_CHUCVU_KiemTraHeSoThuong check (
		HeSoThuong >= 0.5 and HeSoThuong <= 1.2
	),
	constraint CK_CHUCVU_KiemTraLoaiChucVu check (
		LoaiCV in (N'Trưởng phòng', N'Quản lý', N'Giám đốc', N'Phó giám đốc', N'Nhân viên')
	)

/*
- Đối với bảng SANPHAM
	○ Kích thước sản phẩm chỉ có thể là: S, M, L, X, XL, XXL, XXXL (CK_SANPHAM_KiemTraKichThuoc)
	○ Giá thành sản phẩm phải không nhỏ hơn 100.000 và không vượt quá 5.000.000 (CK_SANPHAM_KiemTraGiaThanh)
*/
alter table SANPHAM
	add constraint CK_SANPHAM_KiemTraKichThuoc check (
		KichThuoc in ('S', 'M', 'L', 'X', 'XL', 'XXL', 'XXXL')
	),
	constraint CK_SANPHAM_KiemTraGiaThanh check (
		GiaThanh >= 100000 and GiaThanh <= 5000000
	)

/*
- Đối với bảng NHANVIEN
	○ Giới tính chỉ có thể là NAM hoặc NỮ (CK_NHANVIEN_KiemTraGioiTinh)
	○ Nhân viên phải đủ 18 tuổi và không vượt quá 60 tuổi (CK_KHACHHANG_KiemTraSoTuoi)
	○ Số điên thoại chỉ được chứa ký tự số và không nhỏ hơn 9 ký tự (CK_NHANVIEN_KiemTraSoDienThoai)
*/

select * from NHANVIEN

alter table NHANVIEN
	add constraint CK_NHANVIEN_KiemTraGioiTinh check (
		GioiTinh in (N'Nam', N'Nữ')
	),
	constraint CK_NHANVIEN_KiemTraSoTuoi check (
		year(getdate()) - year(NgaySinh) >= 18 
		and year(getdate()) - year(NgaySinh) <= 60
	),
	constraint CK_NHANVIEN_KiemTraSoDienThoai check (
		SoDienThoai not like ('%[a-z]%') and Len(SoDienThoai) >= 9
	);

/*
- Đối với bảng DONHANG
	○ Ngày lưu đơn hàng không được vượt qua ngày của hiện tại (CK_DONHANG_KiemTraNgayDatHang)
	○ Số lượng sản phẩm không được bằng 0 và không vượt quá 10 (CK_DONHANG_KiemTraSoLuong)
	○ Tổng tiền không được nhỏ hơn 100.000 (CK_DONHANG_KiemTraTongTien)
	○ Trạng thái chỉ có thể là: Đã hủy, Đã thanh toán, Chưa thanh toán (CK_DONHANG_KiemTraTrangThai)
*/

alter table DONHANG
	add constraint CK_DONHANG_KiemTraNgayDatHang check (
		datediff(day, NgayDatHang, getdate()) >= 0
	),
	constraint CK_DONHANG_KiemTraSoLuong check (
		SoLuong > 0 and SoLuong <= 10
	),
	constraint CK_DONHANG_KiemTraTongTien check (
		TongTien >= 100000
	),
	constraint CK_DONHANG_KiemTraTrangThai check (
		TrangThai in (N'Đã thanh toán', N'Chưa thanh toán', N'Đã hủy')
	)

--------------------------------
-->>>>RÀNG BUỘC VỚI TRIGGER<<<--
--------------------------------


-----------------------------------------
-->>>>RÀNG BUỘC VỚI STORED PROCEDURE<<<--
-----------------------------------------

--------------------------------------------
-->>>>THAO TÁC VỚI HÀM SỰ KIỆN VÀ XỬ LÝ<<<--
--------------------------------------------