create database NGK
on
(name = 'NGK_Data', filename = 'C:\NGK_Data.mdf')
log on
(name = 'NGK_Log', filename = 'C:\NGK_Log.ldf')
USE NGK
--(1)
CREATE TABLE NHACC
(
	MaNCC varchar(3) primary key,
	TenNCC nvarchar(50),
	DiaChiNCC nvarchar(100),
	DTNCC varchar(12)
)
--(2)
CREATE TABLE LOAINGK
(
	MaLoaiNGK varchar(3) primary key,
	TenLoaiNGK nvarchar(50),
	MaNCC varchar(3),
	foreign key (MaNCC) references NHACC(MaNCC) on update cascade
)
--(3)
CREATE TABLE NGK
(
	MaNGK varchar(3) primary key,
	TenNGK nvarchar(50),
	Quycach nvarchar(10),
	MaLoaiNGK varchar(3),
	foreign key (MaLoaiNGK) references LOAINGK(MaLoaiNGK) on update cascade
)
--(4)
CREATE TABLE KH
(
	MAKH varchar(4) primary key,
	TENKH nvarchar(50),
	DCKH nvarchar(100),
	DTKH varchar(12)
)
--(5)
CREATE TABLE DDH
(
	SoDDH varchar(5) primary key,
	NgayDH datetime,
	MaNCC varchar(3),
	foreign key (MaNCC) references NHACC(MaNCC) on update cascade
)
--(6)
CREATE TABLE CT_DDH
(
	SoDDH varchar(5),
	MaNGK varchar(3),
	SLDat int,
	--khai báo khóa chính
	primary key (SoDDH, MaNGK),
	--khai báo 2 khóa ngoại
	foreign key (SoDDH) references DDH(SoDDH),
	foreign key (MaNGK) references NGK(MaNGK)
)
--(7)
CREATE TABLE PHIEUGH
(
	SoPGH varchar(5) primary key,
	NgayGH datetime,
	SoDDH varchar(5),
	foreign key (SoDDH) references DDH(SoDDH) on update cascade
)
--(8)
CREATE TABLE CT_PGH
(
	SoPGH varchar(5),
	MaNGK varchar(3),
	SLGiao int,
	DGGIAO bigint,
	--khai báo khóa chính
	primary key (SoPGH, MaNGK),
	--khai báo 2 khóa ngoại
	foreign key (SoPGH) references PHIEUGH(SoPGH),
	foreign key (MaNGK) references NGK(MaNGK)
)
--(9)
CREATE TABLE HOADON
(
	SoHD varchar(4) primary key,
	NgaylapHD datetime,
	MaKH varchar(4),
	foreign key (MaKH) references KH(MaKH) on update cascade
)
--(10)
CREATE TABLE CT_HOADON
(
	SoHD varchar(4),
	MaNGK varchar(3),
	SLKHMua int,
	DGBan bigint,
	--khai báo khóa chính
	primary key (SoHD, MaNGK),
	--khai báo 2 khóa ngoại
	foreign key (SoHD) references HOADON(SoHD),
	foreign key (MaNGK) references NGK(MaNGK)
)
--(11)
CREATE TABLE PHIEUHEN
(
	SoPH varchar(4) primary key,
	NgayLapPH datetime,
	NgayHenGiao datetime,
	MaKH varchar(4),
	foreign key (MaKH) references KH(MaKH) on update cascade
)
--(12)
CREATE TABLE CT_PH
(
	SoPH varchar(4),
	MaNGK varchar(3),
	SLHen int,
	--khai báo khóa chính
	primary key (SoPH, MaNGK),
	--khai báo 2 khóa ngoại
	foreign key (SoPH) references PHIEUHEN(SoPH),
	foreign key (MaNGK) references NGK(MaNGK)
)
--(13)
CREATE TABLE PHIEUTRANO 
(
	SoPTN varchar(5) primary key, 
	NgayTra datetime, 
	SoTienTra bigint, 
	SoHD varchar(4),
	--khai báo khóa ngoại
	foreign key (SoHD) references HOADON(SoHD)
)
--Lần lượt nhập dữ liệu vào các bảng theo thứ tự đã tạo:
--1
INSERT NHACC (MaNCC, TenNCC, DiaChiNCC, DTNCC) VALUES ('NC1', N'Công ty NGK quốc tế CocaCola', N'Xa lộ Hà Nội, Thủ Đức, TP.HCM', '088967908')
INSERT NHACC (MaNCC, TenNCC, DiaChiNCC, DTNCC) VALUES ('NC2', N'Công ty NGK quốc tế Pepsi', N'Bến Chương Dương, Quận 1, TP.HCM', '083663366')
INSERT NHACC (MaNCC, TenNCC, DiaChiNCC, DTNCC) VALUES ('NC3', N'Công ty NGK Bến Chương Dương', N'Hàm Tử, Q.5, TP.HCM', '089456677')
--2
INSERT LOAINGK (MaLoaiNGK, TenLoaiNGK, MaNCC) VALUES ('NK1', N'Nước ngọt có gas', 'NC1')
INSERT LOAINGK (MaLoaiNGK, TenLoaiNGK, MaNCC) VALUES ('NK2', N'Nước ngọt không gas', 'NC2')
INSERT LOAINGK (MaLoaiNGK, TenLoaiNGK, MaNCC) VALUES ('NK3', N'Trà', 'NC1')
INSERT LOAINGK (MaLoaiNGK, TenLoaiNGK, MaNCC) VALUES ('NK4', N'Sữa', 'NC2')
--3
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('C2', N'Trà C2', 'Chai', 'NK2')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('CC1', N'Coca Cola', 'Chai', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('CC2', N'Coca Cola', 'Lon', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('ML1', N'Sữa tươi tiệt trùng', N'Bịch', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('NO1', N'Number One', 'Chai', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('NO2', N'Number One', 'Lon', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('OD', N'Trà xanh 0 độ', 'Chai', 'NK2')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('PS1', N'Pepsi', 'Chai', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('PS2', N'Pepsi', 'Lon', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('ST1', N'Sting dâu', 'Chai', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('ST2', N'Sting dâu', 'Lon', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('SV1', N'Seven Up', 'Chai', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('SV2', N'Seven Up', 'Lon', 'NK1')
INSERT NGK (MaNGK, TenNGK, Quycach, MaLoaiNGK) VALUES ('WT1', N'Nước uống đóng chai', 'Chai', 'NK2')
--4
INSERT KH (MAKH, TENKH, DCKH, DTKH) VALUES ('KH01', N'Cửa hàng BT', N'144 XVNT', '088405996')
INSERT KH (MAKH, TENKH, DCKH, DTKH) VALUES ('KH02', N'Cửa hàng Trà', N'198/42 NTT', '085974572')
INSERT KH (MAKH, TENKH, DCKH, DTKH) VALUES ('KH03', N'Siêu thị Coop', N'24 ĐTH', '086547888')
--5
--Chuyển dạng ngày tháng sang Ngày Tháng Năm
set dateformat dmy

INSERT DDH (SoDDH, NgayDH, MaNCC) VALUES ('DDH01', '10/5/2011', 'NC1')
INSERT DDH (SoDDH, NgayDH, MaNCC) VALUES ('DDH02', '20/5/2011', 'NC1')
INSERT DDH (SoDDH, NgayDH, MaNCC) VALUES ('DDH03', '26/5/2011', 'NC2')
INSERT DDH (SoDDH, NgayDH, MaNCC) VALUES ('DDH04', '03/6/2011', 'NC2')
--6
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH01', 'CC1', 20)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH01', 'CC2', 15)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH01', 'PS1', 18)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH01', 'SV2', 12)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH02', 'C2', 10)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH02', 'CC2', 30)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH02', 'PS2', 10)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH02', 'ST1', 15)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH02', 'SV1', 5)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH03', 'OD', 45)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH04', 'CC1', 8)
INSERT CT_DDH (SoDDH, MaNGK, SLDat) VALUES ('DDH04', 'ST2', 12)
--7
INSERT PHIEUGH (SoPGH, NgayGH, SoDDH) VALUES ('PGH01', '12/5/2010', 'DDH01')
INSERT PHIEUGH (SoPGH, NgayGH, SoDDH) VALUES ('PGH02', '15/5/2010', 'DDH01')
INSERT PHIEUGH (SoPGH, NgayGH, SoDDH) VALUES ('PGH03', '21/5/2010', 'DDH02')
INSERT PHIEUGH (SoPGH, NgayGH, SoDDH) VALUES ('PGH04', '22/5/2010', 'DDH02')
INSERT PHIEUGH (SoPGH, NgayGH, SoDDH) VALUES ('PGH05', '28/5/2010', 'DDH03')
--8
INSERT CT_PGH (SoPGH, MaNGK, SLGiao, DGGIAO) VALUES ('PGH01', 'CC1', 15, 5000)
INSERT CT_PGH (SoPGH, MaNGK, SLGiao, DGGIAO) VALUES ('PGH01', 'CC2', 15, 4000)
INSERT CT_PGH (SoPGH, MaNGK, SLGiao, DGGIAO) VALUES ('PGH01', 'SV2', 10, 4000)
INSERT CT_PGH (SoPGH, MaNGK, SLGiao, DGGIAO) VALUES ('PGH02', 'SV2', 2, 4000)
INSERT CT_PGH (SoPGH, MaNGK, SLGiao, DGGIAO) VALUES ('PGH03', 'C2', 10, 8000)
INSERT CT_PGH (SoPGH, MaNGK, SLGiao, DGGIAO) VALUES ('PGH03', 'CC2', 30, 5000)
INSERT CT_PGH (SoPGH, MaNGK, SLGiao, DGGIAO) VALUES ('PGH03', 'PS2', 10, 4000)
INSERT CT_PGH (SoPGH, MaNGK, SLGiao, DGGIAO) VALUES ('PGH03', 'ST1', 15, 9000)
--9
INSERT HOADON (SoHD, NgaylapHD, MaKH) VALUES ('HD01', '10/5/2010', 'KH01')
INSERT HOADON (SoHD, NgaylapHD, MaKH) VALUES ('HD02', '20/5/2010', 'KH01')
INSERT HOADON (SoHD, NgaylapHD, MaKH) VALUES ('HD03', '05/6/2010', 'KH02')
INSERT HOADON (SoHD, NgaylapHD, MaKH) VALUES ('HD04', '16/6/2010', 'KH02')
INSERT HOADON (SoHD, NgaylapHD, MaKH) VALUES ('HD05', '22/6/2011', 'KH02')
INSERT HOADON (SoHD, NgaylapHD, MaKH) VALUES ('HD06', '08/7/2010', 'KH03')
--10
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD01', 'CC1', 20, 6000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD01', 'CC2', 50, 5000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD02', 'ST1', 40, 10000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD03', 'SV2', 60, 5000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD04', 'PS2', 25, 5000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD05', 'C2', 80, 9000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD05', 'CC1', 100, 6000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD05', 'SV1', 12, 8000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD06', 'OD', 55, 1000)
INSERT CT_HOADON (SoHD, MaNGK, SLKHMua, DGBan) VALUES ('HD06', 'ST2', 50, 11000)
--11
INSERT PHIEUHEN (SoPH, NgayLapPH, NgayHenGiao, MaKH) VALUES ('PH01', '08/5/2010', '09/6/2010', 'KH01')
INSERT PHIEUHEN (SoPH, NgayLapPH, NgayHenGiao, MaKH) VALUES ('PH02', '25/5/2010', '28/6/2010', 'KH02')
INSERT PHIEUHEN (SoPH, NgayLapPH, NgayHenGiao, MaKH) VALUES ('PH03', '01/6/2010', '02/6/2010', 'KH03')
--12
INSERT CT_PH (SoPH, MaNGK, SLHen) VALUES ('PH01', 'OD', 8)
INSERT CT_PH (SoPH, MaNGK, SLHen) VALUES ('PH01', 'ST2', 10)
INSERT CT_PH (SoPH, MaNGK, SLHen) VALUES ('PH02', 'CC1', 20)
INSERT CT_PH (SoPH, MaNGK, SLHen) VALUES ('PH03', 'CC2', 9)
INSERT CT_PH (SoPH, MaNGK, SLHen) VALUES ('PH03', 'ST1', 7)
INSERT CT_PH (SoPH, MaNGK, SLHen) VALUES ('PH03', 'SV2', 12)
--INSERT CT_PH (SoPH, MaNGK, SLHen) VALUES ('PH04', 'PS2', 15)
--13
INSERT PHIEUTRANO (SoPTN, NgayTra, SoTienTra, SoHD) VALUES ('PTN01', '18/5/2010', 500000, 'HD01')
INSERT PHIEUTRANO (SoPTN, NgayTra, SoTienTra, SoHD) VALUES ('PTN02', '01/6/2010', 350000, 'HD01')
INSERT PHIEUTRANO (SoPTN, NgayTra, SoTienTra, SoHD) VALUES ('PTN03', '02/6/2010', 650000, 'HD02')
INSERT PHIEUTRANO (SoPTN, NgayTra, SoTienTra, SoHD) VALUES ('PTN04', '15/6/2010', 1020000, 'HD03')
INSERT PHIEUTRANO (SoPTN, NgayTra, SoTienTra, SoHD) VALUES ('PTN05', '01/7/2010', 1080000, 'HD03')
--
-- hoac neu đã có file rồi
--1) Chép 2 file NGK.MDF và NGK.LDF vào C:\
--2) Attach database NGK vào SQL 2014 bằng lệnh:
CREATE DATABASE NGK
ON
	(FILENAME='C:\NGK.MDF')
FOR ATTACH

--3) Khai báo DB hiện hành:
use NGK

--4) Thực hiện tiếp các câu trong bài tập:
6)	Cho biết tên nhà cung cấp không có khả năng cung cấp NGK có tên ‘Pepsi’.
(Hướng dẫn: Cách 1: Sử dụng NOT EXISTS. Cách 2: Sử dụng NOT IN)
7)	Hiển thị thông tin của NGK chưa bán được.
8)	Hiển thị tên và tổng số lượng bán của từng NGK.
select TenNGK, Quycach, sum(SLKHMua) as [Tổng SL bán]
from NGK N, CT_HOADON C
where N.MaNGK=C.MaNGK
group by TenNGK, Quycach
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
	from CT_DDH C
	where N.MaNGK=C.MaNGK
	)

11)	Hiển thị các NGK không được nhập trong tháng 1/2010.
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
20)	Hiển thị ngày nhập hàng gần nhất của cửa hàng.
21)	Cho biết số lần mua hàng của khách có mã là ‘KH001’.
22)	Cho biết tổng tiền của từng hóa đơn.
select H.SoHD, NgaylapHD, sum(SLKHMua*DGBan) as [Tổng tiền HĐ]
from HOADON H, CT_HOADON C
where H.SoHD=C.SoHD
group by H.SoHD, NgaylapHD
23)	Cho biết danh sách các hóa đơn gồm SoHD, NgaylapHD, MaKH, TenKH và tổng trị giá của từng HoaDon. Danh sách sắp xếp tăng dần theo ngày và giảm dần theo tổng trị giá của hóa đơn.
24)	Cho biết các hóa đơn có tổng trị giá lớn hơn tổng trị giá trung bình của các hóa đơn trong ngày 18/06/2010.
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
