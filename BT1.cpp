#include<stdio.h>
#include<conio.h>
#include<stdlib.h>
#include<time.h>
#define MAX 100
void NhapN(int &n)
	{
		do{
			printf("Moi nhap n:");
			scanf("%d", &n);
			if ( n<=0 || n>=50 ) printf("Nhap sai, moi nhap lai...");
		}while (n<=0 || n>=50);
	}
void Sinhmang(int a[], int n)
	{
		for(int i=0; i<n; i++)
		{
			a[i] = rand() %100;
		}
	}
/*void NhapMang(int a[], int n)
	{
		for (int i=0; i<n; i++)
		{
			printf("Nhap a[%d]=",i);
			scanf("%d", &a[i]);
		}
	}*/
void XuatMang(int a[], int n)
	{
		for(int i=0; i<n; i++)
		printf("%4d", a[i]);
	}
int Search(int a[], int n, int key)
{
	int i=0;
	while(i<n && key!=a[i])
 		i++;
	if(i<n)
		return i;
	return -1;
}
void swap(int &a, int &b)
{
	int t=a;
	a=b;
	b=t;
}
void Sapxep(int a[], int n)
	{
		for (int i=0; i<n; i++)
			for(int j=i+1; j<n; j++)
				if(a[i] >a[j])
					swap(a[i], a[j]);
	}
int Timkiemnhiphan(int a[], int n, int key)
	{
		int left=0, right=n-1, mid;
		while (left <= right)
		{
			int mid = (left + right)/2;
			if(a[mid] == key)
				return mid;
			if(a[mid] < key)
				left = mid + 1;
			else
				right = mid - 1;
		}
		return -1;
	}
void main()
	{
		int n;
		NhapN(n);
		int a[MAX];
		/*NhapMang(a, n);*/
		srand ( (unsigned) time (NULL));
		Sinhmang(a, n);
		printf("Mang vua nhap la:");
		XuatMang(a, n);
		int key;
		//printf("\nMoi nhap key can tim=");
		//scanf("%d", &key);
		//int vt = Search(a, n, key);
		//if (vt == -1) printf("\nTim khong thay %d", key);
		//else
		//	{
		//		printf("\nTim thay %d", key);
		//		printf("\nTai vi tri %d", vt);
		//	}
		printf("\n mang sau sap xep");
		Sapxep(a, n);
		XuatMang(a, n);
		printf("\n moi nhap key can tim:");
		scanf("%d", &key);
		int vt = Timkiemnhiphan(a, n, key);
		if (vt == -1) printf("\nTim khong thay %d", key);
		else
			{
				printf("\nTim thay %d", key);
				printf("\nTai vi tri %d", vt);
			}
		printf("\n");
		getch();
	}
