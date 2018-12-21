#include<stdio.h>
#include<conio.h>
#define MAX 100
struct Sach
{
	int MaSach;
	char TenSach[41];
	float Gia;
};
void Nhap1QuyenSach(Sach &s)
{
	printf("Ma sach: ");
	scanf("%d", &s.MaSach);
	fflush(stdin);
	printf("Ten sach: ");
	gets(s.TenSach);
	printf("Gia sach: ");
	scanf("%f", &s.Gia);
}
void Xuat1QuyenSach(Sach s)
{
	printf("Ma sach: %d", s.MaSach);
	printf("\nTen sach: %s", s.TenSach);
	printf("\nGia sach: %.3f\n", s.Gia);
}
void NhapKichThuoc(int &n)
{
	do
	{
		printf("Moi nhap kich thuoc mang: ");
		scanf("%d", &n);
		if(n < 0)
			printf("Kich thuoc khong hop le, moi nhap lai");
	}while(n < 0);
}
void NhapDanhSach(Sach a[], int n)
{
	for(int i = 0; i < n; i++)
	{
		printf("Moi nhap cuon sach thu %d: \n", i + 1);
		Nhap1QuyenSach(a[i]);
	}
}
void XuatDanhSach(Sach a[], int n)
{
	for(int i = 0; i < n; i++)
	{
		printf("Cuon sach thu %d: \n", i + 1);
		Xuat1QuyenSach(a[i]);
	}
}
int TimMaSach(Sach a[], int n, int key)
{
	int i = 0;
	while(i < n && a[i].MaSach == key)
		i++;
	if(i < n)
		return i;
	return -1;
}
int TimMaSachBangNhiPhan(Sach a[], int n, int key1)
{
	int left = 0, right = n - 1;
	while(left <= right)
	{
		int mid = (left + right) / 2;
		if(a[mid].MaSach == key1)
			return mid;
		if(a[mid].MaSach > key1)
			right = mid - 1;
		else left = mid + 1;
	}
	return -1;
}
int TimTenSach(Sach a[], int n, char *key2)
{
	int i = 0;
	while(i < n && (a[i].TenSach == key2))
		i++;
	if(i < n)
		return i;
	return -1;
}
void SachCoGiaCaoNhat(Sach a[], int n)
{
	float max = a[0].Gia;
	for(int i = 1; i < n; i++)
	{
		if(a[i].Gia > max)
			max = a[i].Gia;
			printf("Quyen sach thu %d: \n", i + 1);
			Xuat1QuyenSach(a[i]);
	}
}
void main()
{
	int n;
	Sach a[MAX];
	NhapKichThuoc(n);
	printf("Moi nhap danh sach co trong thu vien: \n");
	NhapDanhSach(a, n);
	printf("Danh sach nhung quyen sach trong thu vien: \n");
	XuatDanhSach(a, n);
	
	int key;
	do
	{
		printf("Moi nhap ma sach can tim: ");
		scanf("%d", &key);
		if(key < 0)
			printf("Ma sach khong hop le, moi nhap lai");
	}while(key < 0);
	int vt = TimMaSach(a, n, key);
	if(vt == -1)
		printf("Khong tim thay duoc sach can tim");
	else Xuat1QuyenSach(a[vt]);
	
	int key1;
	do
	{
		printf("Moi nhap ma sach can tim: ");
		scanf("%d", &key1);
		if(key1 < 0)
			printf("Ma sach khong hop le, moi nhap lai");
	}while(key1 < 0);
	int vt1 = TimMaSachBangNhiPhan(a, n, key1);
	if(vt1 == -1)
		printf("Khong tim thay duoc sach can tim");
	else Xuat1QuyenSach(a[vt1]);
	
	char key2;
	printf("Moi nhap ten sach can tim: ");
	scanf("%s", &key2);
	int vt2 = TimTenSach(a, n, &key2);
	if(vt2 == -1)
		printf("Khong tim thay duoc sach can tim");
	else Xuat1QuyenSach(a[vt2]);
	
	printf("Danh sach nhung sach co gia cao nhat: \n");
	SachCoGiaCaoNhat(a, n);
}
