clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


** value of time overall (without controling for education)
cd $data\ipums_micro

u 1990_2000_2010_temp, clear

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork<40
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

replace inctot_real=ln(inctot_real)
drop occ met2013 city puma rentgrs valueh bpl occsoc incwage puma1990 greaterthan40 datanum serial pernum rank ind ind2000 hhwt statefip marst inctot occ1990

g val_2010=.
g se_2010=.
g val_1990=.
g se_1990=.
g dval=.
g se_dval=.
g hours1990=0
g hours2010=0
replace hours1990=uhrswork if year==1990
replace hours2010=uhrswork if year==2010
# delimit
foreach num of numlist 
30 120 130 150 205 230 310
350 410 430 520 530 540 560 620 710 730 800
860 1000 1010 1220 1300 1320 1350 1360 1410
1430 1460 1530 1540 1550 1560 1610 1720
1740 1820 1920 1960 2000 2010 2040 2060 2100 2140
2200 2300 2310 2320 2340 2430 2540 2600 2630 2700 2720
2750 2810 2825 2840 2850 2910 3010 3030 3050 3060 3130
3160 3220 3230 3240 3300 3310 3410 3500 3530 3640
3650 3710 3740 3800 3820 3930 3940 3950 4000 4010 4030 4040
4060 4110 4130 4200 4210 4220 4230 4250
4320 4350 4430 4500 4510 4600 4620 4700
4720 4740  4750 4760 4800 4810 4820
4840 4850 4900  4950 4965 5000 5020 5100
5110 5120 5140 5160 5260 5300 5310 5320
5330 5350 5360 5400 5410 5420 5510 5520
5540 5550 5600 5610 5620 5630 5700 5800 5810 5820 5850
5860 5900 5940 6050 6200 6220 6230 6240 6250 6260 6320
6330 6355 6420 6440 6515 6520 6530 6600 6660 7000
7010 7020 7140 7150 7200 7210 7220 7315 7330
7340 7700 7720 7750 7800 7810 7950 8030 8130  8140
8220 8230 8300 8320 8350 8500 8610 8650 8710 8740
8760 8800 8810 8830 8965
9000 9030 9050 9100 9130 9140 9350
9510 9600 9610 9620 9640 {;
# delimit cr
display `num'
qui reghdfe inctot_real hours1990 hours2010 if occ2010==`num' & uhrswork>=40 & uhrswork<=60 [w=perwt], absorb(i.age#i.year i.sex#i.year i.race#i.year i.hispan#i.year i.ind1990#i.year) cluster(metarea)
replace val_1990=_b[hours1990] if occ2010==`num'
replace se_1990=_se[hours1990] if occ2010==`num'
replace val_2010=_b[hours2010] if occ2010==`num'
replace se_2010=_se[hours2010] if occ2010==`num'
lincom hours2010-hours1990
replace dval=r(estimate) if occ2010==`num'
replace se_dval=r(se) if occ2010==`num'
}

collapse (firstnm) val_1990 se_1990 val_2010 se_2010 dval se_dval, by(occ2010)


cd $data\temp_files

save val_40_60_total_noeduc, replace

*** show that selection only occurs at level estimate but not change
cd $data\temp_files

u val_40_60_total_noeduc, clear

keep occ2010 dval val_1990 val_2010
ren dval dval_noeduc
ren val_1990 val_1990_noeduc
ren val_2010 val_2010_noeduc

merge m:1 occ2010 using val_40_60_total_1990_2000_2010
drop _merge

cd $data\temp_files
merge m:1 occ2010 using high_skill
drop _merge

g dval=val_2010-val_1990

*** plot the degree of selection on observables on skill content of the job
*** The worry is that high-skilled job exhibit increasing cross-sectional relation between earnings and hours due to skill biased technical change
*** One implication of that is that high skill jobs exhibit increasing selection by ability
g ddval=dval_noeduc-dval
g dval_2010=val_2010_noeduc-val_2010
g dval_1990=val_1990_noeduc-val_1990

cd $data\graph
# delimit
graph twoway (scatter ddval college_share) (lfit ddval college_share)
, graphregion(color(white)) xtitle(Skill content - share of college grad in 1990) ytitle(Change in selection on the observable skill)
legend(lab(1 "Occupation") lab(2 "Linear fit"));
# delimit cr
graph export change_in_selection.emf, replace

# delimit
graph twoway (scatter dval_2010 college_share) (lfit dval_2010 college_share) if dval!=.
,  graphregion(color(white)) xtitle(Skill content - share of college grad in 1990) ytitle(Selection on the observable skill)
legend(lab(1 "Occupation") lab(2 "Linear fit"));
# delimit cr
graph export selection2010.emf, replace

# delimit
graph twoway (scatter dval_1990 college_share) (lfit dval_1990 college_share) if dval!=.
,  graphregion(color(white)) xtitle(Skill content - share of college grad in 1990) ytitle(Selection on the observable skill)
legend(lab(1 "Occupation") lab(2 "Linear fit"));
# delimit cr
graph export selection1990.emf, replace


*** Appendix Table A1
edit occ2010 val_1990_noeduc val_2010_noeduc dval_noeduc dval_noeduc val_1990 val_2010 dval if occ2010==30
edit occ2010 val_1990_noeduc val_2010_noeduc dval_noeduc dval_noeduc val_1990 val_2010 dval if occ2010==120
edit occ2010 val_1990_noeduc val_2010_noeduc dval_noeduc dval_noeduc val_1990 val_2010 dval if occ2010==800
edit occ2010 val_1990_noeduc val_2010_noeduc dval_noeduc dval_noeduc val_1990 val_2010 dval if occ2010==1000
edit occ2010 val_1990_noeduc val_2010_noeduc dval_noeduc dval_noeduc val_1990 val_2010 dval if occ2010==2100
edit occ2010 val_1990_noeduc val_2010_noeduc dval_noeduc dval_noeduc val_1990 val_2010 dval if occ2010==2320
edit occ2010 val_1990_noeduc val_2010_noeduc dval_noeduc dval_noeduc val_1990 val_2010 dval if occ2010==4820
edit occ2010 val_1990_noeduc val_2010_noeduc dval_noeduc dval_noeduc val_1990 val_2010 dval if occ2010==5700