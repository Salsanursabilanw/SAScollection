TITLE'Hubungan Berat Badan dengan Lingkar Perut, Tinggi Badan dan Jogging';
Data Contoh;
Input Berat_Badan Lingkar_Perut tinggi_Badan dan Jogging;
Datalines;
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
PROC PRINT DATA=Hasil;
RUN;
PROC SGPLOT DATA=Hasil;
SCATTER Y=Berat_Badan X=Lingkar_Perut;
PROC SGPLOT DATA=Hasil;
SCATTER Y=Berat_Badan X=Tinggi_Badan;
PROC SGPLOT DATA=Hasil;
SCATTER Y=Berat_Badan X=Jogging;
PROC CORR DATA=Hasil;
VAR Berat_Badan Lingkar_Perut Tinggi_Badan Jogging;
ODS GRAPHICS ON;
PROC MODEL DATA=Hasil;
VAR Berat_Badan Lingkar_Perut Tinggi_Badan Jogging;
PARMS a1 b1 b2 b3;
Berat_Badan=a1+b1*Lingkar_Perut+b2*Tinggi_Badan+b3*Jogging;
FIT Berat_Badan/WHITE BREUSCH=(1 Lingkar_Perut Tinggi_Badan Jogging);
PROC REG DATA=Hasil;
MODEL Berat_Badan=Lingkar_Perut Tinggi_Badan Jogging/VIF DW;
OUTPUT OUT=resids R=res;
PROC UNIVARIATE DATA=resids NORMAL PLOT;
VAR res;
RUN;
PROC REG DATA=Hasil;
MODEL Berat_Badan=Lingkar_Perut TInggi_Badan Jogging /SELECTION=FORWARD SLENTRY=0.05
DETAILS;
RUN;
PROC REG DATA=Hasil;
MODEL Berat_Badan=Lingkar_Perut TInggi_Badan Jogging /SELECTION=BACKWARD SLYSTAY=0.05
DETAILS;
RUN;
PROC REG DATA=Hasil;
MODEL Berat_Badan=Lingkar_Perut TInggi_Badan Jogging /SELECTION=STEPWISE SLENTRY=0.05 SLSTAY=0.05
DETAILS;
RUN;
ODS GRAPHICS OFF;
