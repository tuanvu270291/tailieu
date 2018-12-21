CREATE DATABASE QLSV
on
(NAME = 'QLSV_Data', FILENAME = 'C:\QLSV.mdf')
 LOG ON 
(NAME = 'QLSV_Log', FILENAME = 'C:\QLSV.ldf')
--
use QLSV
--
create table KHOA
(
	MAKHOA		varchar(4)		primary key,
	TENKHOA		nvarchar(30),
	NAMTHANHLAP	int
)
create table SVIEN
(
	MASV	int		primary key,
	TEN		nvarchar (30),
	NAM		int,
	MAKH	varchar(4),
	foreign key (MAKH) references KHOA(MAKHOA) on update cascade
)
create table MHOC
(
	MAMH	varchar(8)	primary key,
	TENMH	nvarchar(30),
	TINCHI	int,
	MAKH	varchar(4),
	foreign key (MAKH) references KHOA(MAKHOA) on update cascade
)
create table DKIEN
(
	MAMH		varchar(8),
	MAMH_TRUOC	varchar(8),
	primary key (MAMH, MAMH_TRUOC), --khóa chính là 1 cặp thuộc tính (PFK: khóa chính kiêm khóa ngoại)
	--định nghĩa 2 khóa ngoại:
	foreign key (MAMH) references MHOC(MAMH), --ko dùng on update cascade
	foreign key (MAMH_TRUOC) references MHOC(MAMH) --ko dùng on update cascade
)
create table HPHAN
(
	MAHP	int			primary key,
	MAMH	varchar(8),
	foreign key (MAMH) references MHOC(MAMH) on update cascade,
	HOCKY	int,
	NAM	int,
	GV	nvarchar(30)
)
create table KQUA
(
	MASV	int,
	MAHP	int,
	DIEM	decimal(3,1),
	primary key (MASV, MAHP), --khóa chính là 1 cặp thuộc tính (PFK: khóa chính kiêm khóa ngoại)
	--định nghĩa 2 khóa ngoại:
	foreign key (MASV) references SVIEN(MASV), --ko dùng on update cascade
	foreign key (MAHP) references HPHAN(MAHP) --ko dùng on update cascade
)
--Tạo Database Diagram: phải gán quyền sở hữu DB, chọn user là: NT AUTHORITY\SYSTEM
--Copy dữ liệu dán vào các table. Bảng nào tạo trước thì dán vào trước
--Thực hiện các truy vấn:
Yêu cầu:

1.	Tạo các quan hệ trên (bao gồm các ràng buộc khóa chính, ràng buộc tham chiếu)

2.	Thêm vào SVIEN bộ <25, "Nam", 2, "CNTT">
insert into SVIEN values(25, 'Nam', 2, 'CNTT')

3.	Thêm vào KQUA 2 bộ <25,102,7>, <25,135,9>
insert into KQUA values(25,102,7)
insert into KQUA values(25,135,9)

4.	Sửa bộ <8,102,8> thành <8,102,9>
update KQUA
set DIEM=9
where MASV=8 and MAHP=102

5.	Xóa bộ <8,135,10>
delete from KQUA
where MASV=8 and MAHP=135
--
6.	Tạo các câu truy vấn sau:
a.	Tên các sinh viên thuộc Khoa 'Công Nghệ Thông tin'.
select TEN
from SVIEN S, KHOA K
where S.MAKH=K.MAKHOA --Khóa chính và khóa ngoại, có thể khác tên nhưng phải củng kiểu dl và cùng độ rông
and TENKHOA=N'Công Nghệ Thông tin'

b.	Kết quả học tập của sinh viên có mã số 8.

c.	Tên sinh viên và mã môn học mà sinh viên đó đăng ký học với kết quả cuối khóa trên 7 điểm.
select TEN, MAMH, DIEM
from SVIEN S, KQUA K, HPHAN H
where S.MASV=K.MASV and K.MAHP=H.MAHP and DIEM>7

d.	Tên các môn học có số tín chỉ nhỏ nhất.
--Cách 1: truyền thống (2 vòng FOR lồng nhau)
select MAMH, TENMH, TINCHI
from MHOC
where TINCHI <= ALL
	(
	select TINCHI
	from MHOC
	)
--Cách 2:
select MAMH, TENMH, TINCHI
from MHOC
where TINCHI IN
	(
		select min(TINCHI)
		from MHOC
	)
--Cách 3: HUTECH
select top 1 with ties MAMH, TENMH, TINCHI
from MHOC
order by TINCHI --ASC

e.	Tên các sinh viên thuộc về Khoa có phụ trách môn học 'Toán rời rạc'.
select TEN
from SVIEN S, KHOA K, MHOC M
where S.MAKH=K.MAKHOA and K.MAKHOA=M.MAKH and TENMH = N'Toán rời rạc'

f.	Tên các môn học phải học ngay trước môn 'Cơ sở dữ liệu'.
select MAMH, TENMH
from MHOC
where MAMH IN
(
	select MAMH_TRUOC
	from MHOC M, DKIEN D
	where M.MAMH=D.MAMH and TENMH=N'Cơ sở dữ liệu'
)

g.	Tên các môn học phải học ngay trước môn "Cơ sở dữ liệu"
select TENMH as [Tên các MH trước môn "Cơ sở dữ liệu"]
from MHOC
where MAMH IN
(
--Lấy được Mã MH trước môn CSDL
select MAMH_TRUOC
from DKIEN 
where MAMH IN
	(
	--Mã MH='Cơ sở dữ liệu'
		select MAMH
		from MHOC
		where TENMH=N'Cơ sở dữ liệu'
	)
)
h.	Tên các môn học phải học ngay sau môn "Cơ sở dữ liệu"
select MAMH_TRUOC
from DKIEN 
where MAMH IN
(
select MAMH
from DKIEN
where MAMH_TRUOC IN
	(
	--Mã MH='Cơ sở dữ liệu'
	select MAMH
	from MHOC
	where TENMH =N'Cơ sở dữ liệu'
	)
)

i.	Mã học phần và số lượng sinh viên đăng ký theo từng học phần.
select MAHP, count(*) as [Số lượng SV đăng ký]
from KQUA
group by MAHP

j.	In ra tên các học phần có từ 2 SV đăng ký trở lên.
select MAHP, count(*) as [Số lượng SV đăng ký]
from KQUA
group by MAHP
having count(*)>=2 --điều kiện của nhóm

k.	Tên sinh viên và điểm trung bình của sinh viên đó trong từng học kỳ của từng năm học.
select TEN, HOCKY, H.NAM, avg(DIEM) as [ĐTB]
from SVIEN S, KQUA K, HPHAN H
where S.MASV=K.MASV and K.MAHP=H.MAHP
group by TEN, HOCKY, H.NAM
-- hoac
 
select TEN, HOCKY, H.NAM, cast(avg(DIEM) as decimal(3,1)) as DTB 
from HPHAN H, KQUA K, SVIEN S
where H.MAHP=K.MAHP and K.MASV=S.MASV
group by TEN, HOCKY, H.NAM


l.	Tên sinh viên đạt điểm cao nhất
select top 1 with ties
TEN, cast(avg(DIEM) as decimal(3,1)) as [DTB cao nhất]
from KQUA K, SVIEN S
where K.MASV=S.MASV
group by TEN
order by avg(DIEM) DESC
m.	Tên sinh viên chưa đăng ký học môn Toán rời rạc
--Các SV chưa đăng ký học môn Toán rời rạc
select MASV, TEN
from SVIEN
where MASV NOT IN
(
	--Các SV đã học môn Toán rời rạc
	select MASV
	from MHOC M, HPHAN H, KQUA K
	where M.MAMH=H.MAMH and H.MAHP=K.MAHP
	and M.MAMH IN
	(
		--Lấy Mã MH của môn Toán rời rạc
		select MAMH
		from MHOC
		where TENMH=N'Toán rời rạc'
	)
)







--

