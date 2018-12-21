--1) Chép 2 file NGK.MDF và NGK.LDF vào C:\
--2) Attach database NGK vào SQL 2014 bằng lệnh:
CREATE DATABASE NGK
ON
	(FILENAME='C:\NGK.MDF')
FOR ATTACH

--3) Khai báo DB hiện hành:
use NGK

--4) Thực hiện tiếp các câu trong bài tập:
--select
--1)Liệt kê các NGK và loại NGK tương ứng.
--2)	Cho biết thông tin về nhà cung cấp ở Thành phố HCM.
--3)Liệt kê các hóa đơn mua hàng trong tháng 5/2010.
select SoHD, convert(varchar(10), NgaylapHD, 105) as [Ngày lập HĐ], MaKH
from HOADON
where month(NgaylapHD)=5 and year(NgaylapHD)=2010
--4)	Cho biết tên các nhà cung cấp có cung cấp NGK ‘Coca Cola’.
--5)	Cho biết tên các nhà cung cấp có thể cung cấp nhiều loại NGK nhất.
select top 1 with ties TenNCC, count(L.MaloaiNGK) as [Số loại NGK có thể cung cấp]
from NHACC N, LOAINGK L
where N.MaNCC=L.MaNCC
group by TenNCC
order by count(L.MaloaiNGK) DESC
--6)	Cho biết tên nhà cung cấp không có khả năng cung cấp NGK có tên ‘Pepsi’.
(Hướng dẫn: Cách 1: Sử dụng NOT EXISTS. Cách 2: Sử dụng NOT IN)
(Hướng dẫn: Cách 1: Sử dụng NOT EXISTS. Cách 2: Sử dụng NOT IN)
--Cách 1: Sử dụng NOT EXISTS
select MaNCC, TenNCC
from NHACC
where not exists --là Đúng khi sau exists câu lệnh select ko trả về dòng nào
	(select TenNGK
	from NGK N, LOAINGK L
	where N.MaLoaiNGK=L.MaLoaiNGK and L.MaNCC=NHACC.MaNCC
	and TenNGK like 'Pepsi')
--Cách 2: Sử dụng NOT IN
select MaNCC, TenNCC
from NHACC
where MaNCC NOT IN
	(select NHACC.MaNCC --Những nhà cung cấp có khả năng cung cấp Pepsi
	from NHACC, LOAINGK L, NGK N
	where N.MaLoaiNGK=L.MaLoaiNGK and L.MaNCC=NHACC.MaNCC
	and TenNGK like 'Pepsi')
--Cách 1:
select TENNCC
from NHACC N
where NOT EXISTS
(--select ở trên trả về kết quả nếu select bên dưới không trả về dòng nào
	select distinct N.MaNCC
	from LOAINGK L, NGK
	where N.MaNCC=L.MaNCC and L.MaloaiNGK=NGK.MaloaiNGK
	and TENNGK='Pepsi'
)
7)	Hiển thị thông tin của NGK chưa bán được.
select TenNGK, Quycach
from NGK
where MaNGK NOT IN
(--Các NGK đã bán được
	select distinct MaNGK --nếu trùng thì lấy 1 dòng
	from CT_HOADON
)
8)	Hiển thị tên và tổng số lượng bán của từng NGK.
select TenNGK, Quycach, sum(SLKHMua) as [Tổng SL bán]
from NGK N, CT_HOADON C
where N.MaNGK=C.MaNGK
group by TenNGK, Quycach
--c2
select N.MaNGK, TenNGK, Quycach, sum(SLKHMua) as [SL bán được]
from NGK N, CT_HOADON C
where N.MaNGK=C.MaNGK
group by N.MaNGK, TenNGK, Quycach

9)	Hiển thị tên và tổng số lượng của NGK nhập về.
select TenNGK, Quycach, sum(SLDat) as [Tổng SL nhập về]
from NGK N, CT_DDH C
where N.MaNGK=C.MaNGK
group by TenNGK, Quycach
10)	Hiển thị ĐĐH đã đặt NGK với số lượng nhiều nhất so với các ĐĐH khác có đặt NGK đó.
Thông tin hiển thị: SoDDH, MaNGK, [SL đặt nhiều nhất].

select N.MaNGK, TenNGK, SoDDH, SLDat as [SL đặt lớn nhất]
from NGK N, CT_DDH C
where N.MaNGK=C.MaNGK and SLDat >= ALL
	(	
	select SLDat
	rom CT_DDH C
	where N.MaNGK=C.MaNGK
	)

11)	Hiển thị các NGK không được nhập trong tháng 1/2010.
select  MaNGK, TenNGK
from NGK
where MaNGK NOT IN
(--Các NGK nhập về trong tháng 5/2011
	select N.MaNGK
	from DDH D, CT_DDH C, NGK N
	where D.SoDDH=C.SoDDH and C.MaNGK=N.MaNGK 
	and month(NgayDH)=5 and year(NgayDH)=2011
)
12)	Hiển thị tên các NGK không bán được trong tháng 6/2010.
13)	Cho biết cửa hàng bán bao nhiêu thứ NGK.
select count(*) as [Số thứ NGK]
from NGK
14)	Cho biết cửa hàng bán bao nhiêu loại NGK.
select count(distinct MaLoaiNGK) as [Số loại NGK]
from NGK
15)	Hiển thị thông tin của khách hàng có giao dịch với cửa hàng nhiều nhất (căn cứ vào số lần mua hàng).
--Cách 1: >=ALL
select K.MaKH, TenKH, count(H.MaKH) as [Số lần mua hàng]
from KH K, HOADON H
where K.MaKH=H.MaKH
group by K.MaKH, TenKH
having count(H.MaKH) >=ALL
	(
	select count(H.MaKH)
	from KH K, HOADON H
	where K.MaKH=H.MaKH
	group by K.MaKH, TenKH
	)
--Cách 2:
select top 1 with ties K.MaKH, TenKH, count(H.MaKH) as [Số lần mua hàng]
from KH K, HOADON H
where K.MaKH=H.MaKH
group by K.MaKH, TenKH
order by [Số lần mua hàng] DESC --count(H.MaKH)

16)	Tính tổng doanh thu năm 2010 của cửa hàng.
select sum(SLKHMua*DGBan) as [Tổng doanh thu năm 2010]
from HOADON H, CT_HOADON C
where H.SoHD=C.SoHD and year(NgaylapHD)=2010
17)	Liệt kê 5 loại NGK bán chạy nhất (doanh thu) trong tháng 5/2010.
--Cách 1:
select top 5 with ties sum(SLKHMua*DGBan) as [Tổng doanh thu tháng 5/2010]
from HOADON H, CT_HOADON C, NGK N
where H.SoHD=C.SoHD and C.MaNGK=N.MaNGK
and month(NgaylapHD)=5 and year(NgaylapHD)=2010
group by C.MaNGK
order by sum(SLKHMua*DGBan) DESC

18)	Liệt kê thông tin bán NGK của tháng 5/2010. Thông tin hiển thị: Mã NGK, Tên NGK, SL bán.
19)	Liệt kê thông tin của NGK có nhiều người mua nhất.

20)Hiển thị ngày nhập hàng gần nhất của cửa hàng.
select top 1 NgayDH
from DDH
order by NgayDH DESC
21)Cho biết số lần mua hàng của khách có mã là 'KH01'.
select count(MaKH) as [SL KH01 mua]
from HOADON
where MaKH='KH01'
--Cho biết số lần mua hàng của từng KH?
select MaKH,count(MaKH) as [SL KH01 mua]
from HOADON
group by MaKH
22)	Cho biết tổng tiền của từng hóa đơn.
select H.SoHD, NgaylapHD, sum(SLKHMua*DGBan) as [Tổng tiền HĐ]
from HOADON H, CT_HOADON C
where H.SoHD=C.SoHD
group by H.SoHD, NgaylapHD
-- hoac
select SoHD,sum(SLKHMua*DGBan) as [Thành tiền]
from CT_HOADON
group by SoHD

23)	Cho biết danh sách các hóa đơn gồm SoHD, NgaylapHD, MaKH, TenKH và tổng trị giá của từng HoaDon. Danh sách sắp xếp tăng dần theo ngày và giảm dần theo tổng trị giá của hóa đơn.
24)	Cho biết các hóa đơn có tổng trị giá lớn hơn tổng trị giá trung bình của các hóa đơn trong ngày 18/06/2010.
--trị giá trung bình của các hóa đơn trong ngày 18/06/2010.
set dateformat dmy
select H.SoHD,sum(SLKHMua*DGBan) as [Trị giá]
from HOADON H, CT_HOADON C
where H.SoHD=C.SoHD and NgayLapHD='18/6/2010'
group by H.SoHD
having sum(SLKHMua*DGBan)>
	(select avg(SLKHMua*DGBan) as [GT Trung bình]
	from HOADON H, CT_HOADON C
	where H.SoHD=C.SoHD and NgayLapHD='18/6/2010'
	group by NgaylapHD)
--
25)	Cho biết số lượng từng NGK tiêu thụ theo từng tháng của năm 2010.
26)	Đưa ra danh sách NGK chưa được bán trong tháng 9 năm 2010.
27)	Đưa ra danh sách khách hàng có địa chỉ ở TP.HCM và từng mua NGK trong tháng 9 năm 2010.
28)	Đưa ra số lượng đã bán tương ứng của từng NGK trong tháng 10 năm 2010.
29)	Hiển  thị thông tin khách hàng đã từng mua và tổng số lượng của từng NGK tại cửa hàng.
30)	Cho biết trong năm 2010, khách hàng nào đã mua nợ nhiều nhất.
31)	Có bao nhiêu hóa đơn chưa thanh toán hết số tiền?
32)	Liệt kê các hóa đơn cùng tên của khách hàng tương ứng đã mua NGK và thanh toán tiền đầy đủ 1 lần. (Không có phiếu trả nợ)
33)	Thông kê cho biết thông tin đặt hàng của cửa hàng trong năm 2010:
Mã NGK, Tên NGK, Tổng SL đặt.
34)	Để thuận tiện trong việc tặng quà Tết cho khách hàng, hãy liệt kê danh sách khách hàng đã mua NGK với tổng số tiền tương ứng trong năm 2010 (hiển thị giảm dần theo số tiền đã mua).
