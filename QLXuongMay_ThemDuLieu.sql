/*vvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
---------------------------------
-->>>>QUẢN LÝ XƯỞNG DỆT MAY<<<<--
---------------------------------
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

---------------------------
-->>>>THÊM DỮ LIỆU MẪU<<<--
---------------------------
--Khâu tổ chức: PHONGBAN --> CHUCVU --> NHANVIEN --> NHANVIEN_LUONG --> CONGVIEC --> DIEMDANH --> NHANVIEN_DIEMDANH
--Khâu bán hàng: KHACHHANG --> KHOHANG --> SANPHAM --> DONHANG --> HOADON

use QLXuongMay;
go

--------------------------------
-->>>>QUY TẮC THÊM PHONGBAN<<<--
--------------------------------
--Mã phòng ban: PB---, bắt đầu từ PB001
--Tên phòng ban: Tên phòng ban làm việc xưởng dệt may
--Địa chỉ: Địa chỉ của phòng ban làm việc
insert into PHONGBAN values
	('PB001', N'Phòng nhân sự', 'Chi nhánh Quận 10'),
	('PB002', N'Phòng sản phẩm', 'Chi nhánh Quận 3'),
	('PB003', N'Phòng tài chính', 'Chi nhánh Hóc Môn'),
	('PB004', N'Phòng dịch vụ', 'Chi nhánh Tân Bình'),
	('PB005', 'Phong Ban A', N'69 Hai Bà Trưng,P.Bến Nghé, Quận 1,TPHCM'),
    ('PB006', 'Phong Ban B', N'32 Võ Thị Sáu,Quận 3,TPHCM'),
    ('PB007', 'Phong Ban C', N'868 Su Van Hanh,Quận 10,TPHCM');

------------------------------
-->>>>QUY TẮC THÊM CHUCVU<<<--
------------------------------
--Mã chức vụ: TP: Trưởng phòng, QL: Quản lý, GD: Giám đốc, PGD: Phó giám đốc, CN: Nhân viên thường
--Tên chức vụ: Danh từ thể hiện loại chức vụ phải đứng đầu (VD: Trưởng phòng kinh doanh, Quản lý nhân sự, Giám đốc, Phó giám đốc)
--Hệ số lượng: Hệ số thực (1.1 --> 3.0)
--Hệ số thưởng: Hệ số thực (0.5 --> 1.2)
--Loại chức vụ: Trưởng phòng/Quản lý/Giám đốc/Phó giám đốc/Nhân viên
insert into CHUCVU values
	('CN001', N'Nhân viên thời vụ', 1.1, 0.5, N'Bán thời gian'),
	('CN002', N'Nhân viên may',1.2, 0.5, N'Toàn thời gian'),
    ('TP003', N'Nhà Thiết kế' ,1.5, 0.8, N'Toàn thời gian'),
    ('GD004', N'Giám đốc', 2.5, 0.9, N'Toàn thời gian'),
	('CN005', N'Nhân viên thời vụ', 2.5, 0.9, N'Bán thời gian');

--------------------------------
-->>>>QUY TẮC THÊM NHANVIEN<<<--
--------------------------------
--Mã nhân viên: NV---, bắt đầu từ NV001
--Họ tên: Tên có dấu
--Giới tính: Nam hoặc Nữ
--Ngày sinh: Phải là ngày tháng có thật, đúng cú pháp: 'yyyy-mm-dd'
--Địa chỉ: Địa chỉ có dấu
--Số điện thoại: Tối đa 15 ký tự
--Mã phòng ban: Mã phòng ban chính xác nơi nhân viên đang làm việc tại
--Mã chức vụ: Mã chức vụ chính xác chức vụ nhân viên đang đảm nhận
--Mã trưởng phòng: Xác định nhân viên đang nắm giữ chức trưởng phòng

insert into NHANVIEN values
	('NV001', null, N'Phùng Quang Long', 0, '2003-10-17', N'153 Nam Kỳ Khởi Nghĩa', null, '0763615414', 'DH', '089203331111', 'PB001', 'CN001', null)

---------------------------------------------
-->>>>QUY TẮC THÊM LUONG, NHANVIEN_LUONG<<<--
---------------------------------------------

insert into LUONG values
	('2023-7-13', null, null, null)

insert into NHANVIEN_LUONG values
	('NV001', '2023-7-13')

--------------------------------
-->>>>QUY TẮC THÊM CONGVIEC<<<--
--------------------------------

insert into CONGVIEC values
	('CV001', 'PB001', 'CN001', N'Lao động', N'Nhiều chân tay', '2023-7-13', '2023-7-14', 20, null)

-----------------------------------------
-->>>>QUY TẮC THÊM NHANVIEN_CONGVIEC<<<--
-----------------------------------------

insert into NHANVIEN_CONGVIEC values
	('NV001', 'CV001')

--------------------------------
-->>>>QUY TẮC THÊM DIEMDANH<<<--
--------------------------------

insert into DIEMDANH values
	('2023-7-13', '2023-7-14')

-----------------------------------------
-->>>>QUY TẮC THÊM NHANVIEN_DIEMDANH<<<--
-----------------------------------------

insert into NHANVIEN_DIEMDANH values
	('NV001', '2023-7-13', '2023-7-14')

---------------------------------
-->>>>QUY TẮC THÊM KHACHHANG<<<--
---------------------------------
--Mã khách hàng: KH---, bắt đầu từ KH001
--Họ tên: Tên có dấu
--Giới tính: Nam hoặc Nữ
--Ngày sinh: Phải là ngày tháng có thật, đúng cú pháp: 'yyyy-mm-dd'
--Địa chỉ: Địa chỉ có dấu
--Số điện thoại: Tối đa 15 ký tự

insert into KHACHHANG values
	('KH001', null, N'Quang Long', 0, '2003-10-17', N'120 Lạc Long Quân, Phường 4, Quận Tân Bình', null, '0777333444')

-------------------------------
-->>>>QUY TẮC THÊM KHOHANG<<<--
-------------------------------
--Mã kho: K---, bắt đầu từ K001
--Số lượng tồn: Số lượng còn lại của sản phẩm trong kho

insert into KHOHANG values
	('SP001', 30)

-------------------------------
-->>>>QUY TẮC THÊM SANPHAM<<<--
-------------------------------
--Mã sản phẩm: A: Áo, Q: Quần, G: Giày, T: Túi
--Tên sản phẩm: Danh từ thể hiện loại sản phẩm phải đứng đầu (VD: Áo Abc, Quần Abc, Giày Abc)
--Kích thước: S, M, L, X, XL, XXL, XXXL
--Màu sắc: Tùy ý
--Giá thành: Sản phẩm phải không nhỏ hơn 100.000 và không vượt quá 5.000.000
--Loại sản phẩm: Danh từ thể hiện loại con của sản phẩm (VD: Áo thun, Áo tay dài, Quần cộc, quần đùi, quần dài, Giày cao gót)
--Mã kho: Sử dụng chính xác mã kho nơi tồn trữ sản phẩm này

insert into SANPHAM values
	('SP001', N'Áo thun mùa hè', 'S', N'Trắng', 500000, N'Áo thun')

-------------------------------
-->>>>QUY TẮC THÊM DONHANG<<<--
-------------------------------
--Mã đơn hàng: DH---, bắt đầu từ DH001
--Ngày đặt hàng: Phải là ngày tháng có thật, đúng cú pháp: 'yyyy-mm-dd'
--Số lượng: Số lượng đặt hàng
--Tổng tiền: Tổng số tiền của đơn hàng
--Trạng thái: Đã hủy/Đã thanh toán/Chưa thanh toán
--Mã khách hàng: Sử dụng chính xác mã khách hàng tham gia vào đơn hàng này

insert into DONHANG values
	('DH001', '2023-1-22', N'Chưa thanh toán', 'KH001', 'NV001')

------------------------------
-->>>>QUY TẮC THÊM HOADON<<<--
------------------------------
--Mã sản phẩm: Mã sản phẩm được sử dụng trên hóa đơn này
--Mã đơn hàng: Mã đơn hàng được sử dụng trên hóa đơn này
insert into HOADON values
	('DH001', 'SP001', 10, null)