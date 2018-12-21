--Tạo database:
CREATE DATABASE DIALYVN
ON
(NAME = 'DIALYVN_DATA', FILENAME = 'C:\DIALYVN.MDF')
LOG ON
(NAME = 'DIALYVN_LOG', FILENAME = 'C:\DIALYVN.LDF')
--Chọn DIALYVN là DB hiện hành:
use DIALYVN
--Tạo các Table:
create table TINH_TP
(
	MA_T_TP	varchar(3) primary key,
	TEN_T_TP nvarchar(20),
	DT float,
	DS bigint,
	MIEN nvarchar(10)
)
create table BIENGIOI
(
	NUOC nvarchar(15),
	MA_T_TP varchar(3),
	primary key (NUOC, MA_T_TP),
	foreign key (MA_T_TP) references TINH_TP(MA_T_TP)
	on update cascade --quan hệ kéo theo: sửa/xóa CHA thì sửa/xóa luôn con
)
create table LANGGIENG
(
	MA_T_TP varchar(3),
	LG varchar(3),
	primary key(MA_T_TP, LG),
	--định nghĩa 2 khóa ngoại:
	foreign key (MA_T_TP) references TINH_TP(MA_T_TP),
	foreign key (LG) references TINH_TP(MA_T_TP)
)
--Thiết lập Database Diagram (nhớ chỉ ra quyền cho user: NT AUTHORITY\SYSTEM)
--Nhập dữ liệu cho các bảng: bảng nào là CHA (tạo trước) thì nhập trước,
--bảng nào là CON (tạo sau) thì nhập sau.
--Cách 1: Nhập bằng lệnh.
insert into TINH_TP values('AG', 'An Giang', 3406, 2142709, 'Nam')
insert into TINH_TP values('BR', 'Bà Rịa - Vũng Tàu', 1982, 996682, 'Nam')
--Xóa dữ liệu:
delete from TINH_TP
where MA_T_TP='BR'
--Nhập lại: Thêm ký tự 'N' trước chuỗi
insert into TINH_TP values('BR', N'Bà Rịa - Vũng Tàu', 1982, 996682, 'Nam')
--Cách 2: Copy và Paste
--Cách Chép DB DIALYVN sang máy khác: Có 2 trường hợp xảy ra:
--1) Máy chép qua có cùng phiên bản SQL Server 2014
--> Sử dụng Detach và Attach: Phải đóng tất cả các file và ko chọn DIALYVN
--là DB hiện hành (Tốt nhất là thoát và mở lại SQL)
--2) Máy chép qua có phiên bản SQL Server thấp hơn:
--> Ko dùng Detach/Attach được. Phải dùng Backup và Restore.
Các kiểu dữ liệu của SQL Server:
--1) Chuỗi: char (cố định) và varchar (ko cố định)
--Vd: char(5), nhập 'ABC' thì: 'ABC__'
--varchar(10), nhập 'ABCDE' thì: 'ABCDE'
--> nachar, nvarchar: bảng mã Unicode
--2) Số:
--Số nguyên: tinyint (1 byte), smallint (2 byte), int (4 byte), bigint (8 byte)
--Số thực: float, decimal(n,p): n là độ dài, p là số con số lẻ
--3) Ngày, Giờ: Date, Time.
--4) Luận lý: C++ dùng kiểu BOOL, 
--SQL dùng kiểu BIT (binary digits): 0 (false), (1 true)
--Thực hiện các truy vấn:
1.	Xuất ra tên tỉnh, TP cùng với dân số của tỉnh,TP:
a) Có diện tích >= 5000 Km2
select TEN_T_TP as N'Tên Tỉnh, TP', DS as [Dân số] --as: alias
from TINH_TP
where DT>=5000
--Hoặc:
select N'Tên Tỉnh, TP'=TEN_T_TP, [Dân số]=DS --hoặc sùng dấu bằng (=)
from TINH_TP
where DT>=5000
b) Có diện tích >= [input] (SV nhập một số bất kỳ)
select TEN_T_TP as N'Tên Tỉnh, TP', DS as [Dân số] --as: alias
from TINH_TP
where DT>=15000
2.	Xuất ra tên tỉnh, TP cùng với diện tích của tỉnh,TP:
a) Thuộc miền Bắc
select TEN_T_TP, DT
from TINH_TP
where MIEN=N'Bắc'
b) Thuộc miền [input] (SV nhập một miền bất kỳ)
3.	Xuất ra các Tên tỉnh, TP biên giới thuộc miền [input] (SV cho một miền bất kỳ)
4.	Cho biết diện tích trung bình của các tỉnh, TP (Tổng DT/Tổng số tỉnh_TP).
select [DT trung bình (km2)]=sum(DT)/count(*) --dount(*): đếm số dòng của 1 bảng
from TINH_TP

5.	Cho biết dân số cùng với tên tỉnh của các tỉnh, TP có diện tích > 7000 Km2.
6.	Cho biết dân số cùng với tên tỉnh của các tỉnh miền 'Bắc'.
select DS, TEN_T_TP
from TINH_TP
where MIEN=N'Bắc'
7.	Cho biết mã các nước là biên giới của các tỉnh miền 'Nam'.
select distinct NUOC --distinct: nhiều dòng trùng nhau thì lấy 1 dòng
from TINH_TP T, BIENGIOI B --đặt bí danh cho bảng
where T.MA_T_TP=B.MA_T_TP and MIEN='Nam'

8.	Cho biết diện tích trung bình của các tỉnh, TP. (Sử dụng hàm)
select avg(DT) as [DT trung bình]
from TINH_TP
9.	Cho biết mật độ dân số (DS/DT) cùng với tên tỉnh, TP của tất cả các tỉnh, TP.
10.	Cho biết tên các tỉnh, TP láng giềng của tỉnh 'Long An'.
--Ý tưởng: Xét bảng LANGGIENG, cột MA_T_TP='LA' thì cột LG là láng giềng.
select TEN_T_TP
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.LG and L.MA_T_TP= --truy vấn lồng
									(select MA_T_TP
									from TINH_TP
									where TEN_T_TP='Long An')
11.	Cho biết số lượng các tỉnh, TP giáp với 'CPC'.
select count(MA_T_TP) as [Số tỉnh, TP giáp CPC]
from BIENGIOI
where NUOC='CPC'
12.	Cho biết tên những tỉnh, TP có diện tích lớn nhất.
--Cách 1: In các tỉnh, TP giảm dần theo DT, lấy dòng đầu tiên, đây là DT lớn nhất.
select top 1 with ties TEN_T_TP, DT --top 1: lấy dòng đầu, 
--with ties: nếu có nhiều dòng bằng nhau thì lấy hết
from TINH_TP
order by DT DESC --ASC: ascending: tăng dần (mặc định), DESC: desceding: giảm dần

--Cách 2: Tìm DT lớn nhất, sau đó in ra tỉnh, TP có DT bằng với DT này
select TEN_T_TP
from TINH_TP
where DT =
			(select MAX(DT)
			from TINH_TP)
--Cách 3: Cách kinh điển, các trường và SGK hay dùng cách này
select TEN_T_TP
from TINH_TP
where DT >= ALL
			(
				select DT
				from TINH_TP
			)
13.	Cho biết tỉnh, TP có mật độ DS đông nhất.
14.	Cho biết tên những tỉnh, TP giáp với hai nước biên giới khác nhau.
--Ý tưởng: xét bảng BIENGIOI, cột MA_T_TP: mã tỉnh, TP nào xuất hiện >=2 thì có từ
--2 biên giới trở lên.
select TEN_T_TP, count(NUOC) as [Số biên giới]
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP
group by TEN_T_TP, B.MA_T_TP --khi gom nhóm trên 1 cột thuộc tính, các thuộc tính còn lại cần sử dụng
--hàm kết hợp để xử lý. Hàm kết hợp (aggregate function) là: COUNT, MAX, MIN, SUM, AVG.
having count(NUOC)>=2 --sau having là điều kiện của nhóm.
--Lưu ý: Sau where là điều kiện kết bảng và lọc dữ liệu
--Sau select có thuộc tính gì thì sau group by phải có các thuộc tính đó, trừ các hàm kết hợp.
--Thuộc tính có trong group by mà không có trong select thì ko sao nhé!

15.	Cho biết danh sách các miền cùng với các tỉnh, TP trong các miền đó.
16.	Cho biết tên những tỉnh, TP có nhiều láng giềng nhất.
