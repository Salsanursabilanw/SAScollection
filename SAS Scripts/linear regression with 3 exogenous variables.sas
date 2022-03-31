TITLE 'Analisis Regresi Pengaruh Kehadiran, Banyaknya waktu menghafal, dan Jumlah SKS dengan Pencapaian banyaknya Hafalan Qur-an';
DATA Tugas;
INPUT Banyaknya_Pencapaian Banyaknya_Kehadiran Banyaknya_waktu_menghafal Jumlah_SKS;
DATALINES;
40 17 75 12 
20 13 30 21
28 18 65 18
26 17 60 21
20 14 60 21
10 12 45 24
20 13 30 21
24 17 60 18
20 16 45 21
20 15 45 22
38 15 70 15
19 12 65 20
20 13 40 21
3.5 13 35 24
10.5 7 50 24
21 11 60 20
12 14 45 23
11 11 55 23
11.5 11 65 23
3 3 30 24
14 9 60 21
10 10 50 24
5 6 30 24
19 16 60 22
10.5 10 55 21
28 12 70 18
17 10 50 21
5.5 5 30 24
4.5 8 35 24
9.5 13 30 24
;
PROC CORR DATA=Tugas;
VAR Banyaknya_Pencapaian Banyaknya_Kehadiran Banyaknya_waktu_menghafal Jumlah_SKS;
ODS GRAPHICS ON;
PROC SGPLOT DATA=Tugas;
SCATTER Y=Banyaknya_Pencapaian X=Banyaknya_Kehadiran;
PROC SGPLOT DATA=Tugas;
SCATTER Y=Banyaknya_Pencapaian X=Banyaknya_waktu_menghafal; 
PROC SGPLOT DATA=Tugas;
SCATTER Y=Banyaknya_Pencapaian X=Jumlah_SKS;/*Linearitas*/  
PROC MODEL DATA=Tugas;
PARMS a1 b1 b2 b3;
Banyaknya_Pencapaian=a1+b1*Banyaknya_Kehadiran+b2*Banyaknya_waktu_menghafal+b3*Jumlah_SKS;
FIT Banyaknya_Pencapaian/WHITE BREUSCH=(1 Banyaknya_Kehadiran Banyaknya_waktu_menghafal Jumlah_SKS);/*Heteroskedastisitas*/
PROC REG DATA=Tugas;
MODEL Banyaknya_Pencapaian=Banyaknya_Kehadiran Banyaknya_waktu_menghafal Jumlah_SKS/VIF DW;
OUTPUT OUT=resids R=res;/*Multikolinearitas*/
PROC UNIVARIATE DATA=resids NORMAL PLOT;
VAR res;/*Normalitas*/
RUN;
ODS GRAPHICS OFF;
