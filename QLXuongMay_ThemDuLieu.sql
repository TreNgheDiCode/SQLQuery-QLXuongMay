/*vvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
---------------------------------
-->>>>QUẢN LÝ XƯỞNG DỆT MAY<<<<--
---------------------------------
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

---------------------------
-->>>>THÊM DỮ LIỆU MẪU<<<--
---------------------------
--Khâu tổ chức: Phòng ban --> Chức vụ --> Nhân viên --> Lương --> Công việc --> Điểm danh
--Khâu bán hàng: Khách hàng --> Sản phẩm --> Kho hàng --> Đơn hàng --> Hóa đơn

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
	('PB004', N'Phòng dịch vụ', 'Chi nhánh Tân Bình')

------------------------------
-->>>>QUY TẮC THÊM CHUCVU<<<--
------------------------------
--Mã chức vụ: TP: Trưởng phòng, QL: Quản lý, GD: Giám đốc, PGD: Phó giám đốc, CN: Nhân viên thường
--Tên chức vụ: Danh từ thể hiện loại chức vụ phải đứng đầu (VD: Trưởng phòng kinh doanh, Quản lý nhân sự, Giám đốc, Phó giám đốc)
--Hệ số lượng: Hệ số thực (1.1 --> 3.0)
--Hệ số thưởng: Hệ số thực (0.5 --> 1.2)
--Loại chức vụ: Trưởng phòng/Quản lý/Giám đốc/Phó giám đốc/Nhân viên
insert into CHUCVU values
	('CN001', N'Nhân viên thời vụ', 1.1, 0.5, N'Nhân viên')

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

insert into NHANVIEN values
	('NV001', N'Phùng Quang Long', N'Nam', '2003-10-17', N'153 Nam Kỳ Khởi Nghĩa', '0763615414', 'PB001', 'CN001', null)

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
	('KH001', N'Phùng Quang Long', N'Nam', '2003-10-17', N'828 Sự Vạn Hạnh, Phường 13, Quận 10, Tp. Hồ Chí Minh', '0763123123')

-------------------------------
-->>>>QUY TẮC THÊM KHOHANG<<<--
-------------------------------
--Mã kho: K---, bắt đầu từ K001
--Số lượng tồn: Số lượng còn lại của sản phẩm trong kho
insert into KHOHANG values
	('K001', 30)

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
	('DH001', '2023-6-26', 5, 500000, N'Đã thanh toán', 'KH001')

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
	('A001', N'Áo thun mùa hè', 'S', N'Trắng', 500000, N'Áo thun', 'K001'),
	('A002', N'Áo tay ngắn chống nhiệt', 'XL', N'Đen', 600000, N'Áo tay ngắn', 'K001'),
	('A003', N'Áo tay dài mùa đông', 'XL', N'Kem', 400000, N'Áo tay dài', 'K001'),
	('A004', N'Áo thun in hình khủng long', 'S', N'Trắng sữa', 1000000, N'Áo thun', 'K001'),
	('A005', N'Áo thời trang mùa thu cho bé', 'XXL', N'Hồng', 800000, N'Áo tay dài', 'K001'),
	('Q001', N'Quần thun mùa hè', 'S', N'Trắng', 150000, N'Quần thun', 'K001'),
	('Q002', N'Quần đùi họa tiết caro', 'S', N'Trắng', 350000, N'Quần đùi', 'K001'),
	('Q003', N'Quần tây nhân viên văn phòng', 'S', N'Trắng', 250000, N'Quần tây', 'K001'),
	('Q004', N'Quần jeans quá cỡ', 'XXXL', N'Trắng', 300000, N'Quần jeans', 'K001'),
	('Q005', N'Quần thun có túi', 'S', N'Trắng', 500000, N'Quần thun', 'K001'),
	('G001', N'Giày đế dài', 'S', N'Trắng', 500000, N'Giày đế dài', 'K001'),
	('G002', N'Giày tây', 'S', N'Trắng', 500000, N'Giày tây', 'K001'),
	('G003', N'Giày cao gót', 'S', N'Trắng', 500000, N'Giày cao gót', 'K001'),
	('G004', N'Giày búp bê', 'S', N'Trắng', 500000, N'Giày búp bê', 'K001'),
	('G005', N'Giày đi nước', 'S', N'Trắng', 500000, N'Giày sinh hoạt', 'K001'),
	('T001', N'Túi xách nhãn Gucci', 'S', N'Trắng', 500000, N'Túi xách', 'K001'),
	('T002', N'Túi da bò chống nhiệt', 'S', N'Trắng', 500000, N'Túi chống nhiệt', 'K001'),
	('T003', N'Túi cao su đi chợ cho các bà mẹ', 'S', N'Trắng', 500000, N'Túi sinh hoạt', 'K001'),
	('T004', N'Túi nhiều ngăn đa năng', 'S', N'Trắng', 500000, N'Túi sinh hoạt', 'K001'),
	('T005', N'Túi thông khí đựng thực phẩm', 'S', N'Trắng', 500000, N'Túi sinh hoạt', 'K001')

------------------------------
-->>>>QUY TẮC THÊM HOADON<<<--
------------------------------
--Mã sản phẩm: Mã sản phẩm được sử dụng trên hóa đơn này
--Mã đơn hàng: Mã đơn hàng được sử dụng trên hóa đơn này
insert into HOADON values
	('A001', 'DH001'),
	('Q001', 'DH001'),
	('T001', 'DH001')