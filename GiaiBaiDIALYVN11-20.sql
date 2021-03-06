--Câu 11: Cho biết số lượng các tỉnh, TP giáp với 'CPC'
select T.Ma_T_TP,Ten_T_TP
from TINH_TP T, BIENGIOI B
where T.Ma_T_TP=B.Ma_T_TP and NUOC='CPC'
--Câu 12: Cho biết tên những tỉnh, TP có diện tích lớn nhất
select Ma_T_TP,Ten_T_TP,DT
from TINH_TP
where DT IN (select max(DT) from TINH_TP)
--Câu 13: Cho biết tên những tỉnh, TP có mật độ dân số đông nhất
select Ma_T_TP,Ten_T_TP,DS/DT
from TINH_TP
where DS/DT IN (select max(DS/DT) from TINH_TP) 
--Câu 14: Cho biết tên những tỉnh, TP giáp với 2 nước
--có biên giới khác nhau
select T.Ma_T_TP,Ten_T_TP
from TINH_TP T, BIENGIOI B
where T.Ma_T_TP=B.Ma_T_TP
group by T.Ma_T_TP,Ten_T_TP
having count(*)=2
--Câu 15: Cho biết ds các miền cùng với các tỉnh, TP
--nằm trong miền đó
select MIEN,Ma_T_TP,Ten_T_TP
from TINH_TP
order by MIEN
--Câu 16: Cho biết tên những tỉnh, TP có nhiều láng giềng nhất
select T.Ma_T_TP,Ten_T_TP,count(*) as [Số LG]
from TINH_TP T, LANGGIENG L
where T.Ma_T_TP=L.Ma_T_TP
group by T.Ma_T_TP,Ten_T_TP
having count(*) >= ALL
	(select count(*) as [Số LG]
	from TINH_TP T, LANGGIENG L
	where T.Ma_T_TP=L.Ma_T_TP
	group by T.Ma_T_TP,Ten_T_TP)
--Câu 17: Cho biết tên những tỉnh, TP có diện tích nhỏ hơn
--diện tích trung bình của tất cả các tỉnh, TP
select Ma_T_TP,Ten_T_TP,DT
from TINH_TP
where DT < (select avg(DT) from Tinh_TP)
--Câu 18: Cho biết tên những tỉnh, TP giáp với các tỉnh, TP --ở miền 'Nam' nhưng không phải là miền 'Nam'.
select distinct T.Ma_T_TP,Ten_T_TP,MIEN
from TINH_TP T,LANGGIENG L
where T.Ma_T_TP=L.Ma_T_TP and MIEN<>'Nam'
and L.LG in
(select Ma_T_TP from TINH_TP where Mien='Nam')
--Câu 19: Cho biết tên các tỉnh, TP có diện tích lớn hơn --tất cả các láng giềng của nó
select T.Ma_T_TP,DT,LG
from TINH_TP T,LANGGIENG L
where T.Ma_T_TP=L.Ma_T_TP
--Câu 19)Cho biết tên những tỉnh, TP có diện tích lớn hơn tất cả các tỉnh, TP
--láng giềng của nó
select T1.Ten_T_TP from TINH_TP T1
where T1.DT >= ALL
(select T2.DT from TINH_TP T2, LANGGIENG L
where T2.Ma_T_TP=L.LG and L.Ma_T_TP=T1.Ma_T_TP)
--Câu 20)--Chua hay
select Ma_T_TP, Ten_T_TP from TINH_TP where Ma_T_TP IN
(select C.LG from LANGGIENG A, LANGGIENG B, LANGGIENG C
where A.Ma_T_TP='HCM' and A.LG=B.Ma_T_TP and B.Ma_T_TP<>
(select Ma_T_TP from TINH_TP where Ten_T_TP=N'TP. Hồ Chí Minh')
and B.LG=C.Ma_T_TP and C.Ma_T_TP<>
(select Ma_T_TP from TINH_TP where Ten_T_TP=N'TP. Hồ Chí Minh')
)
--Cau 20: Cach khac
TINH_TP		LANGGIENG	LANGGIENG	LANGGIENG
HCM		HCM|DN		DN|BTH		BTH|LD
		HCM|LA		LA|TG		TG|AG

select distinct 'HCM',L1.LG,L2.LG,L3.LG
from TINH_TP T, LANGGIENG L1, LANGGIENG L2, LANGGIENG L3
where T.MA_T_TP=L1.MA_T_TP and L1.LG=L2.MA_T_TP and L2.LG=L3.MA_T_TP
	and T.MA_T_TP='HCM'
	and L2.LG<>'HCM' and L3.LG<>'HCM' and L1.LG<>L3.LG