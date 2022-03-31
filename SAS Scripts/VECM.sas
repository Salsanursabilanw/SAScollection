/*input data*/
data close;
input palm lsip sgro ssms;
cards;
218 1450 2400 825
208 1435 2500 830
202 1370 2400 825
200 1375 2460 805
200 1355 2400 800
202 1430 2400 845
200 1430 2400 815
200 1390 2400 800
206 1375 2400 825
199 1340 2400 790
200 1325 2400 790
200 1340 2330 815
198 1295 2350 790
199 1265 2350 825
195 1265 2490 805
190 1245 2490 820
200 1215 2480 810
199 1175 2480 785
199 1170 2400 785
206 1205 2400 795
206 1200 2400 780
206 1175 2400 800
195 1150 2400 765
195 1160 2360 745
202 1215 2380 790
191 1265 2380 800
191 1275 2380 800
192 1205 2350 790
192 1215 2350 785
192 1215 2390 790
190 1160 2390 800
190 1160 2390 800
190 1165 2340 795
202 1165 2340 795
192 1160 2340 800
192 1150 2260 800
182 1120 2340 795
190 1060 2400 785
190 1065 2260 820
174 1020 2300 795
170 1005 2300 795
168 970 2200 810
168 945 2200 840
168 1010 2180 805
171 1030 2220 785
180 1050 2220 775
190 990 2390 825
195 825 2300 765
195 820 2300 780
195 770 2250 795
195 695 2180 800
190 705 2250 810
178 660 2250 810
178 615 2200 770
178 575 2250 780
178 535 2150 840
178 560 2250 840
178 540 2250 815
170 610 2300 835
170 755 2500 950
200 835 2460 955
200 780 2390 920
198 840 2480 935
198 785 2490 965
198 785 2450 1000
198 800 2450 1005
236 830 2490 1045
220 890 2490 1010
220 830 2430 975
220 850 2480 1000
206 825 2470 1000
192 820 2490 990
192 775 2500 975
192 735 2490 975
192 755 2500 955
200 740 2510 930
186 690 2510 925
186 645 2510 915
186 635 2510 905
186 615 2500 885
186 610 2510 895
186 675 2490 890
186 675 2500 900
186 710 2490 895
180 690 2510 895
180 695 2490 900
180 705 2500 895
180 730 2500 895
180 775 2490 885
180 725 2490 880
180 730 2500 880
180 690 2500 875
170 725 2500 910
171 725 2500 925
198 745 2470 945
196 710 2490 930
183 720 2340 910
171 715 2340 900
199 710 2340 895
200 690 2340 835
187 735 2320 835
185 785 2320 875
202 765 2330 875
200 775 2330 860
200 820 2200 845
200 870 2200 855
199 835 2200 830
200 790 2190 850
190 795 2200 825
186 790 2180 800
177 825 2200 820
190 835 2200 810
200 835 2190 810
190 820 2200 800
195 865 2200 805
197 875 2200 780
195 860 2190 790
195 825 2190 795
197 825 2190 790
195 810 2100 790
191 830 2080 780
184 845 2100 790
191 870 2100 785
191 860 2100 790
200 890 2000 795
188 870 2000 800
200 870 2000 800
195 870 2000 795
195 845 2000 795
191 875 2000 800
190 890 2000 800
185 940 2000 825
186 940 1945 820
187 945 1950 830
198 990 1935 840
196 1005 1900 850
187 1000 1900 850
190 1015 1895 845
199 995 1900 845
238 1005 1800 850
234 965 1800 835
240 990 1795 835
240 990 1790 820
;
run;
/*stasionerity*/
proc arima data=close;
identify var=palm stationarity=(adf=(3));
identify var=lsip stationarity=(adf=(3));
identify var=sgro stationarity=(adf=(3));
identify var=ssms stationarity=(adf=(3));
run;
/*differencing*/
proc arima data=close;
identify var=palm(1) stationarity=(adf=(3));
identify var=lsip(1) stationarity=(adf=(3));
identify var=sgro(1) stationarity=(adf=(3));
identify var=ssms(1) stationarity=(adf=(3));
run;
/*cointegration and optimum lag*/
proc varmax data=close;
model palm lsip sgro ssms/p=1 dify(1) dftest minic=(TYPE=AIC P=5 q=0) cointtest=(johansen);
run;
/*vecm dan irf*/
proc varmax data=close plots=impulse printall;
model palm lsip sgro ssms/p=1 dify(1) noint ecm=(rank=4 normalize=palm) minic=(TYPE=AIC P=5 q=0) print=(iarr estimates);
run;
/* granger causality*/
proc varmax data=close;
model palm lsip sgro ssms/p=1;
causal group1=(palm) group2=(lsip sgro ssms);
causal group1=(palm) group2=(lsip sgro);
causal group1=(palm) group2=(lsip ssms);
causal group1=(palm) group2=(sgro ssms);
causal group1=(palm) group2=(lsip);
causal group1=(palm) group2=(sgro);
causal group1=(palm) group2=(ssms);
causal group1=(lsip) group2=(palm sgro ssms);
causal group1=(lsip) group2=(palm sgro);
causal group1=(lsip) group2=(palm ssms);
causal group1=(lsip) group2=(sgro ssms);
causal group1=(lsip) group2=(palm);
causal group1=(lsip) group2=(sgro);
causal group1=(lsip) group2=(ssms);
causal group1=(sgro) group2=(palm lsip ssms);
causal group1=(sgro) group2=(palm lsip);
causal group1=(sgro) group2=(palm ssms);
causal group1=(sgro) group2=(lsip ssms);
causal group1=(sgro) group2=(palm);
causal group1=(sgro) group2=(lsip);
causal group1=(sgro) group2=(ssms);
causal group1=(ssms) group2=(palm lsip sgro);
causal group1=(ssms) group2=(palm lsip);
causal group1=(ssms) group2=(palm sgro);
causal group1=(ssms) group2=(lsip sgro);
causal group1=(ssms) group2=(palm);
causal group1=(ssms) group2=(lsip);
causal group1=(ssms) group2=(sgro);
run;
