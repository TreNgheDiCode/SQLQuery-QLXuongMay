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
	○ Giới tính chỉ có thể là NAM-0 hoặc NỮ-1 (CK_KHACHHANG_KiemTraGioiTinh)
	○ Khách hàng phải trên 0 tuổi và không vượt quá 100 tuổi (CK_KHACHHANG_KiemTraSoTuoi)
	○ Năm sinh của khách hàng không được vượt quá năm hiện tại (CK_KHACHHANG_KiemTraNamSinh)
*/
alter table KHACHHANG
	add constraint CK_KHACHHANG_KiemTraGioiTinh check (
		GioiTinh in (0, 1)
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
		LoaiCV in (N'Bán thời gian', N'Toàn thời gian')
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
		GioiTinh in (0, 1)
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
		datediff(day, ThoiGianDatHang, getdate()) >= 0
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

/*
- Đối với bảng HOADON
	○ Số lượng sản phẩm không được bằng 0 và không vượt quá 10 (CK_DONHANG_KiemTraSoLuong)
*/

alter table HOADON
	add constraint CK_HOADON_KiemTraSoLuong check (
		SoLuong > 0 and SoLuong <= 10
	)
--------------------------------
-->>>>RÀNG BUỘC VỚI TRIGGER<<<--
--------------------------------
--Khi xóa dữ liệu trong bảng sản phẩm, nếu sản phẩm đó có trong bảng hóa đơn thì không cho xóa.
GO
CREATE TRIGGER TG_1
ON SANPHAM
FOR DELETE
AS
BEGIN
	DECLARE @MASP CHAR(10)
	SELECT @MASP=MaSP FROM deleted
	IF EXISTS (SELECT *
				FROM HOADON
				WHERE @MASP=MaSP)
	BEGIN
			ROLLBACK TRAN
			RAISERROR (N'KHÔNG THỂ XÓA',16,1)
	END
END

DELETE FROM SANPHAM WHERE MaSP='SP001'


DROP TRIGGER TG_1
select * from KHACHHANG
select * from HOADON

--Khi thêm hoặc sửa dữ liệu trong bảng sản phẩm, đơn giá phải lớn hơn 1000.
GO
CREATE TRIGGER TG_2
ON SANPHAM
FOR INSERT, UPDATE
AS
BEGIN
		DECLARE @GiaThanh int
		SELECT @GiaThanh=GiaThanh FROM inserted
		if @GiaThanh <1000
			BEGIN
				ROLLBACK TRAN
				RAISERROR (N'GIÁ CỦA SẢN PHẨM PHẢI LỚN HƠN 100000',16,1)
			END
END

INSERT INTO SANPHAM
VALUES ('SP006', N'Áo Croptop', 'S', N'Trắng', 200000, N'Áo', '2023-8-10', 10)

DELETE FROM SANPHAM WHERE MaSP='SP006'

DROP TRIGGER TG_2

--Khi thêm hoặc sửa dữ liệu trong bảng sản phẩm, tên sản phẩm không được trùng nhau.
GO
CREATE TRIGGER TG_3
ON SANPHAM
FOR INSERT, UPDATE
AS
BEGIN
		DECLARE @TENSP NVARCHAR(100)
		DECLARE @COUNT INT
		SET @COUNT =0
		SELECT @TENSP=TenSP FROM inserted
		
		SELECT @COUNT=COUNT(*)
		FROM SANPHAM
		WHERE @TENSP=TenSP

		IF @COUNT>1
		BEGIN
			ROLLBACK TRAN
			RAISERROR (N'TÊN SẢN PHẨM KHÔNG ĐƯỢC TRÙNG NHAU',16,1)
		END
END

INSERT INTO SANPHAM
VALUES ('SP007', N'Áo croptop', 'M', N'Denim', 150000, N'Áo', '2023-8-10', 10)


select * from KHACHHANG
select * from SANPHAM
--Khi thêm một hóa đơn mới thì mã sản phẩm phải có trong bảng sản phẩm và mã khách hàng phải có trong bảng khách hàng.


--Khi thêm hoặc sửa dữ liệu trong bảng HoaDon , Khuyến mãi không được vượt quá 50000.
GO
CREATE TRIGGER TG_5 
ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
		DECLARE @KHUYENMAI INT
		SELECT @KHUYENMAI=KhuyenMai from inserted
		IF @KHUYENMAI>1
		BEGIN
			ROLLBACK TRAN
			RAISERROR (N'KHUYỄN MÃI KHÔNG ĐƯỢC VƯỢT QUÁ 100%',16,1)
		END
END

INSERT INTO HOADON (MaDH, MaSP, SoLuong, KhuyenMai)
VALUES ('DH001', 'SP002', 2, 1.2)

DROP TRIGGER TG_5


-----------------------------------------
-->>>>RÀNG BUỘC VỚI STORED PROCEDURE<<<--
-----------------------------------------
--Viết thủ tục nhập vào mã sản phẩm, xuất ra tổng số tiền bán của sản phẩm đó. Biết rằng số tiền = số lượng * với đơn giá	
GO
CREATE PROC CR_1 @MASP CHAR(10)
AS
BEGIN
	SELECT SANPHAM.MaSP, TenSP, SUM(SoLuong*GiaThanh) AS GIA
	FROM SANPHAM, HOADON
	WHERE SANPHAM.MaSP=HOADON.MaSP AND @MASP=SANPHAM.MaSP AND @MASP=HOADON.MaSP 
	GROUP BY SANPHAM.MaSP, TenSP
END
EXEC CR_1 'SP001';
DROP PROC CR_1
		
SELECT * FROM HOADON
						
--Viết thủ tục nhận vào giá sản phẩm, xuất ra thông tin sản phẩm có giá lớn hơn giá nhập vào						
GO
CREATE PROC CR_2 @GiaThanh int
AS
BEGIN
	SELECT *
	FROM SANPHAM
	WHERE @GiaThanh<GiaThanh
END

EXEC CR_2 120000;
DROP PROC CR_2

--Viết thủ tục nhập vào mã sản phẩm, xuất ra tổng số lượng bán của sản phẩm đó.						
GO
CREATE PROC CR_3 @MASP CHAR(10)
AS
BEGIN
	SELECT MaSP, SUM(SOLUONG) AS SLBAN
	FROM HOADON
	WHERE @MASP=MaSP
	GROUP BY MaSP

END
EXEC CR_3 'SP001';
DROP PROC CR_3

SELECT * FROM HOADON


--Nhận vào tham số là MaSP, trả về MaKH và số lượng mua của khách hàng mua sản phẩm đó nhiều nhất.
GO
CREATE PROC PR_4 @MASP CHAR(10)
AS
BEGIN
	SELECT top 1 MaKH, sum(SOLUONG) as SL
	FROM HOADON,DONHANG
	WHERE HOADON.MaDH=DONHANG.MaDH  AND @MASP=MaSP
	GROUP BY MaKH
END
EXEC PR_4 'SP001';
DROP PROC PR_4
SELECT * FROM HOADON
SELECT * FROM DONHANG		
SELECT * FROM SANPHAM


--Nhận vào tham số là ngày, trả về MaKH và số tiền mua hàng của khách hàng của khách hàng mua nhiều tiền nhất.
GO
CREATE PROC PR_5 @NGAY DATE
AS
BEGIN
	SELECT TOP 1 MaKH, sum(SoLuong*GiaThanh) AS THANHTIEN
	FROM DONHANG, HOADON, SANPHAM
	WHERE DONHANG.MaDH=HOADON.MaDH and @NGAY=ThoiGianDatHang AND SANPHAM.MaSP=HOADON.MaSP
	GROUP BY MaKH
END

EXEC PR_5 '2023-07-01';
DROP PROC PR_5


--Nhận tham số đầu vào là ngày, trả về tổng số tiền bán tất cả sản phẩm trong ngày.
GO
CREATE PROC PR_6 @NGAY DATE
AS
BEGIN
	SELECT SUM(SoLuong*GiaThanh-KhuyenMai) AS TONGTIEN
	FROM HOADON, SANPHAM, DONHANG
	WHERE @NGAY=ThoiGianDatHang AND HOADON.MaDH=DONHANG.MaDH AND SANPHAM.MaSP=HOADON.MaSP
END

EXEC PR_6 '2023-07-01';
DROP PROC PR_6

Go

CREATE PROCEDURE PR_7
@Thang INT
AS
BEGIN
    SELECT TOP 10 SP.MaSP, SP.TenSP, SUM(HD.SoLuong) AS SoLuongBan
    FROM SANPHAM SP
    INNER JOIN HOADON HD ON SP.MaSP = HD.MaSP
    WHERE MONTH(HD.MaDH) = @Thang
    GROUP BY SP.MaSP, SP.TenSP
    ORDER BY SoLuongBan DESC;
END;
EXEC PR_7 @Thang = 7; 

------Nhập mã đơn hàng xuất ra thông tin khách hàng đã mua đơn hàng đó------
GO
CREATE PROCEDURE Cr_8
    @MaDH char(10)
AS
BEGIN
    SELECT KH.MaKH, KH.HoTen, KH.GioiTinh, KH.NgaySinh, KH.DiaChi, KH.SoDienThoai
    FROM KHACHHANG KH
    JOIN DONHANG DH ON KH.MaKH = DH.MaKH
    WHERE DH.MaDH = @MaDH;
END;
EXEC Cr_8 @MaDH = 'DH001';

----Nhập tháng Tính tổng số đơn hàng mà mỗi nhân viên đã tạo-----
GO
CREATE PROCEDURE Cr_9
    @Thang int
AS
BEGIN
    SELECT NV.MaNV, NV.HoTen, COUNT(DH.MaDH) AS TongSoDonHang
    FROM NHANVIEN NV
    LEFT JOIN DONHANG DH ON NV.MaNV = DH.MaNV
    WHERE MONTH(DH.ThoiGianDatHang) = @Thang
    GROUP BY NV.MaNV, NV.HoTen;
END;
EXEC Cr_9 @Thang = 7; 