clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

****************
** Create value for employment proximity term in 1990
cd $data\temp_files
u occ_emp_share_1994, clear
cd $data\temp_files
merge m:1 occ2010 using val_40_60_total_1990_2000_2010
keep if _merge==3
drop _merge

cd $data\temp_files
merge m:1 occ2010 using val_time_weekly_earnings_total
keep if _merge==3
drop _merge

cd $data\temp_files
merge m:1 occ2010 using high_skill
drop if _merge==2
drop _merge

drop se_1990 se_2010 
cd $data\temp_files
save occ_emp_share_temp, replace

***
cd $data\temp_files
u data, clear

cd $data\temp_files
merge m:1 gisjoin using skill_pop
keep if _merge==3
drop _merge

g ratio1990=ln(impute1990_high/impute1990_low)
g ratio2010=ln(impute2010_high/impute2010_low)
replace rent1990=ln(rent1990+1)
replace rent2010=ln(rent2010+1)

g delta1990= ln(impute_share1990)+1.408819*val_1990*(1-high_skill)*expected_commute +6.002858*val_1990*high_skill*expected_commute - 0.34529*ln(impute1990_high/impute1990_low)*(1-high_skill) - 1.6172921*ln(impute1990_high/impute1990_low)*high_skill + 0.43598*rent1990*(1-high_skill) + 0.5732421*rent1990*high_skill

keep gisjoin delta1990 occ2010
cd $data\temp_files
save delta1990, replace


cd $data\temp_files
u impute, clear

g dln_sim_high_total  = ln(impute2010_high_cf)- ln(impute1990_high)
g dln_sim_low_total =ln(impute2010_low_cf)-ln(impute1990_low)

g drent_predict=0.0984*(ln(inc2010_cf)-ln(inc1990)) + 0.01814*room_density_1mi_3mi

egen high2010_total=sum(impute2010_high)
egen low2010_total=sum(impute2010_low)

egen high1990_total=sum(impute1990_high)
egen low1990_total=sum(impute1990_low)

g impute2010_high_hat=(impute2010_high/high2010_total)*high1990_total
g impute2010_low_hat=(impute2010_low/low2010_total)*low1990_total

g ratio1990=impute1990_high/impute1990_low
g ratio2010=impute2010_high_hat/impute2010_low_hat
g dratio=ln(ratio2010)-ln(ratio1990)

keep gisjoin dln_sim_high_total dln_sim_low_total ratio1990 ratio2010 dratio drent_predict

cd $data\geographic
merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge


cd $data\temp_files
merge m:1 metarea using population1990_metarea
keep if _merge==3
drop _merge

*** rent
cd $data\temp_files
merge m:1 gisjoin using rent
drop if _merge==2
drop _merge

g drent=ln(rent2010)-ln(rent1990)

reg dratio i.metarea  dln_sim_high_total  dln_sim_low_total [w=population]
predict dln_ratio_cf, xb
reg drent i.metarea drent_predict  [w=population]
predict drent_cf, xb

keep gisjoin dln_ratio_cf drent_cf
cd $data\temp_files
save pre_welfare, replace


*** combine census tract data
cd $data\temp_files
u delta1990, clear

merge m:1 gisjoin using rent
drop if _merge==2
drop _merge

cd $data\temp_files
merge m:1 gisjoin using skill_pop
keep if _merge==3
drop _merge

cd $data\geographic
merge m:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

sort metarea occ2010
by metarea occ2010: egen high1990_total=sum(impute1990_high)
by metarea occ2010: egen low1990_total=sum(impute1990_low)

by metarea occ2010: egen high2010_total=sum(impute2010_high)
by metarea occ2010: egen low2010_total=sum(impute2010_low)

g impute2010_high_hat=(impute2010_high/high2010_total)*high1990_total
g impute2010_low_hat=(impute2010_low/low2010_total)*low1990_total

drop *_total
cd $data\temp_files
merge m:1 gisjoin using pre_welfare
keep if _merge==3
drop _merge

cd $data\temp_files
save temp, replace



***

# delimit

foreach num of numlist  30 120 130 150 205 230 310
350 410 430 520 530 540 560 620
710 730 800
860 1000 1010 1220 1300 1320 1350 1360 1410
1430 1460 1530 1540 1550 1560 1610 1720
1740 1820 1920 1960 2000 2010 2040 2060 2100 2140
2200 2300 
2310 2320 2340 2430 2540 2600 2630 2700 2720
2750 2810 2825 2840 2850 2910 3010 3030 3050 3060 3130
3160 3220 3230 3240 3300 3310 3410 3500 3530 3640
3650 3740 3930 3940 3950 4000 4010 4030 4040
4060 4110 4130 4200 4210 4220 4230 4250
4320 4350 4430 4500 4510 4600 4620 4700
4720 4740  4750 4760 4800 4810 4820
4840 4850 4900  4950 4965 5000 5020 5100
5110 5120 5140 5160 5260 5300 5310 5320
5330 5350 5360 5400 5410 5420 5510 5520
5600 5610 5620 5630 5700 5800 5810 5820 5850
5860 5900 5940 6050 6200 6220 6230 6240 6250 6260 6320
6330 6355 6420 6440 6515 6520 6530 6600 6660 7000
7010 7020 7140 7150 7200 7210 7220 7315 7330
7340 7700 7720 7750 7800 7810 7950 8030 8130  8140
8220 8230 8300 8320 8350 8500 8610 8650 8710 8740
8760 8800 8810 8830 8965
9000 9030 9050 9100 9130 9140 9350
9510 9600 9610 9620 9640 {;

# delimit cr
cd $data\temp_files
u temp, clear
keep if occ2010==`num'

cd $data\temp_files
save temp1, replace

cd $data\temp_files
u occ_emp_share_temp, clear
keep if occ2010==`num'
cd $data\travel

merge 1:m zip using travel_time_hat
keep if _merge==3
drop _merge

ren travel_time_hat travel_time
** commuting hours per work week
replace travel_time=travel_time*10

cd $data\temp_files
merge m:1 gisjoin using temp1
keep if _merge==3
drop _merge

replace rent1990=ln(rent1990+1)
replace rent2010=ln(rent2010+1)


g value1990=exp(-1.408819*val_1990*(1-high_skill)*travel_time -6.002858*val_1990*high_skill*travel_time + 1.408819*inctot_real1990 *(1-high_skill) + 6.002858*inctot_real1990*high_skill + 0.34529*ln(impute1990_high/impute1990_low)*(1-high_skill) + 1.6172921*ln(impute1990_high/impute1990_low)*high_skill -0.43598*rent1990*(1-high_skill) - 0.5732421*rent1990*high_skill+ delta1990)

g value2010_inc=exp(-1.408819*val_1990*(1-high_skill)*travel_time -6.002858*val_1990*high_skill*travel_time + 1.408819*inctot_real2010 *(1-high_skill) + 6.002858*inctot_real2010*high_skill + 0.34529*ln(impute1990_high/impute1990_low)*(1-high_skill) + 1.6172921*ln(impute1990_high/impute1990_low)*high_skill -0.43598*rent1990*(1-high_skill) - 0.5732421*rent1990*high_skill+ delta1990)

g value2010_val=exp(-1.408819*val_2010*(1-high_skill)*travel_time -6.002858*val_2010*high_skill*travel_time + 1.408819*inctot_real2010 *(1-high_skill) + 6.002858*inctot_real2010*high_skill + 0.34529*ln(impute1990_high/impute1990_low)*(1-high_skill) + 1.6172921*ln(impute1990_high/impute1990_low)*high_skill -0.43598*rent1990*(1-high_skill) - 0.5732421*rent1990*high_skill+ delta1990)

g value2010_rent=exp(-1.408819*val_2010*(1-high_skill)*travel_time -6.002858*val_2010*high_skill*travel_time + 1.408819*inctot_real2010 *(1-high_skill) + 6.002858*inctot_real2010*high_skill + 0.34529*ln(impute1990_high/impute1990_low)*(1-high_skill) + 1.6172921*ln(impute1990_high/impute1990_low)*high_skill -0.43598*(rent1990+drent_cf)*(1-high_skill) - 0.5732421*(rent1990+drent_cf)*high_skill+ delta1990)

g value2010_full=exp(-1.408819*val_2010*(1-high_skill)*travel_time -6.002858*val_2010*high_skill*travel_time + 1.408819*inctot_real2010 *(1-high_skill) + 6.002858*inctot_real2010*high_skill + 0.34529*(ln(impute1990_high/impute1990_low)+dln_ratio_cf)*(1-high_skill) + 1.6172921*(ln(impute1990_high/impute1990_low)+dln_ratio_cf)*high_skill -0.43598*(rent1990+drent_cf)*(1-high_skill) - 0.5732421*(rent1990+drent_cf)*high_skill+ delta1990)

g value2010_full_norent=exp(-1.408819*val_2010*(1-high_skill)*travel_time -6.002858*val_2010*high_skill*travel_time + 1.408819*inctot_real2010 *(1-high_skill) + 6.002858*inctot_real2010*high_skill + 0.34529*(ln(impute1990_high/impute1990_low)+dln_ratio_cf)*(1-high_skill) + 1.6172921*(ln(impute1990_high/impute1990_low)+dln_ratio_cf)*high_skill -0.43598*(rent1990)*(1-high_skill) - 0.5732421*(rent1990)*high_skill+ delta1990)


*** Real rent and amenity (skill ratio) change
 
g value2010_rent_real=exp(-1.408819*val_2010*(1-high_skill)*travel_time -6.002858*val_2010*high_skill*travel_time + 1.408819*inctot_real2010 *(1-high_skill) + 6.002858*inctot_real2010*high_skill + 0.34529*ln(impute1990_high/impute1990_low)*(1-high_skill) + 1.6172921*ln(impute1990_high/impute1990_low)*high_skill -0.43598*(rent2010)*(1-high_skill) - 0.5732421*(rent2010)*high_skill+ delta1990)

g value2010_full_real=exp(-1.408819*val_2010*(1-high_skill)*travel_time -6.002858*val_2010*high_skill*travel_time + 1.408819*inctot_real2010 *(1-high_skill) + 6.002858*inctot_real2010*high_skill + 0.34529*(ln(impute2010_high/impute2010_low))*(1-high_skill) + 1.6172921*(ln(impute2010_high/impute2010_low))*high_skill -0.43598*(rent2010)*(1-high_skill) - 0.5732421*(rent2010)*high_skill+ delta1990)

g value2010_full_norent_real=exp(-1.408819*val_2010*(1-high_skill)*travel_time -6.002858*val_2010*high_skill*travel_time + 1.408819*inctot_real2010 *(1-high_skill) + 6.002858*inctot_real2010*high_skill + 0.34529*(ln(impute2010_high/impute2010_low))*(1-high_skill) + 1.6172921*(ln(impute2010_high/impute2010_low))*high_skill -0.43598*(rent1990)*(1-high_skill) - 0.5732421*(rent1990)*high_skill+ delta1990)


sort zip

ren value1990 value1990_ind
by zip: egen value1990=sum(value1990_ind)
ren value2010_inc value2010_inc_ind
by zip: egen value2010_inc=sum(value2010_inc_ind)
ren value2010_val value2010_val_ind
by zip: egen value2010_val=sum(value2010_val_ind)
ren value2010_rent value2010_rent_ind
by zip: egen value2010_rent=sum(value2010_rent_ind)
ren value2010_full value2010_full_ind
by zip: egen value2010_full=sum(value2010_full_ind)
ren value2010_full_norent value2010_full_norent_ind
by zip: egen value2010_full_norent=sum(value2010_full_norent_ind)

ren value2010_rent_real value2010_rent_real_ind
by zip: egen value2010_rent_real=sum(value2010_rent_real_ind)
ren value2010_full_real value2010_full_real_ind
by zip: egen value2010_full_real=sum(value2010_full_real_ind)
ren value2010_full_norent_real value2010_full_norent_real_ind
by zip: egen value2010_full_norent_real=sum(value2010_full_norent_real_ind)

keep value1990 value2010_inc value2010_val value2010_rent value2010_full value2010_full_norent value2010_rent_real value2010_full_real value2010_full_norent_real share zip

duplicates drop zip, force

replace value1990=ln(value1990)*share
replace value2010_inc=ln(value2010_inc)*share
replace value2010_val=ln(value2010_val)*share
replace value2010_rent=ln(value2010_rent)*share
replace value2010_full=ln(value2010_full)*share
replace value2010_full_norent=ln(value2010_full_norent)*share

replace value2010_rent_real=ln(value2010_rent_real)*share
replace value2010_full_real=ln(value2010_full_real)*share
replace value2010_full_norent_real=ln(value2010_full_norent_real)*share

cd $data\geographic

merge m:1 zip using zip1990_metarea

collapse (sum) value1990 value2010_inc value2010_val value2010_rent value2010_full value2010_full_norent value2010_rent_real value2010_full_real value2010_full_norent_real, by(metarea)

g occ2010=`num'
cd $data\temp_files\welfare
save value1990_full_`num', replace
}

cd $data\temp_files\welfare
clear 

# delimit

foreach num of numlist  30 120 130 150 205 230 310
350 410 430 520 530 540 560 620 710 730 800
860 1000 1010 1220 1300 1320 1350 1360 1410
1430 1460 1530 1540 1550 1560 1610 1720
1740 1820 1920 1960 2000 2010 2040 2060 2100 2140
2200 2300 
2310 2320 2340 2430 2540 2600 2630 2700 2720
2750 2810 2825 2840 2850 2910 3010 3030 3050 3060 3130
3160 3220 3230 3240 3300 3310 3410 3500 3530 3640
3650 3740 3930 3940 3950 4000 4010 4030 4040
4060 4110 4130 4200 4210 4220 4230 4250
4320 4350 4430 4500 4510 4600 4620 4700
4720 4740  4750 4760 4800 4810 4820
4840 4850 4900  4950 4965 5000 5020 5100
5110 5120 5140 5160 5260 5300 5310 5320
5330 5350 5360 5400 5410 5420 5510 5520
5600 5610 5620 5630 5700 5800 5810 5820 5850
5860 5900 5940 6050 6200 6220 6230 6240 6250 6260 6320
6330 6355 6420 6440 6515 6520 6530 6600 6660 7000
7010 7020 7140 7150 7200 7210 7220 7315 7330
7340 7700 7720 7750 7800 7810 7950 8030 8130  8140
8220 8230 8300 8320 8350 8500 8610 8650 8710 8740
8760 8800 8810 8830 8965
9000 9030 9050 9100 9130 9140 9350
9510 9600 9610 9620 9640 {;

# delimit cr

append using value1990_full_`num'

}

save value1990_full, replace

****
cd $data\temp_files
u tract_impute_share, clear


sort metarea occ2010 gisjoin

cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge


g impute2010=impute_share2010*count2010

g impute1990=impute_share1990*count1990

collapse (sum) impute2010 impute1990, by(metarea occ2010)
cd $data\temp_files\welfare
merge 1:m metarea occ2010 using value1990_full
keep if _merge==3
drop _merge
cd $data\temp_files
merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge
cd $data\temp_files\welfare
save value_full, replace



cd $data\temp_files\welfare
u value_full, clear
cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge

cd $data\temp_files
merge m:1 occ2010 using val_time_weekly_earnings_total
keep if _merge==3
drop _merge

drop if value1990==0

collapse value1990 income1990=inctot_real1990 income2010=inctot_real2010 value2010_inc value2010_val value2010_rent value2010_full value2010_full_norent value2010_rent_real value2010_full_real value2010_full_norent_real [w=impute1990] , by(high_skill)

g d_inc=(value2010_inc-value1990)/((1-high_skill)*1.408819+high_skill*6.002858)
g d_val=(value2010_val-value1990)/((1-high_skill)*1.408819+high_skill*6.002858)
g d_rent=(value2010_rent-value1990)/((1-high_skill)*1.408819+high_skill*6.002858)
g d_full=(value2010_full-value1990)/((1-high_skill)*1.408819+high_skill*6.002858)
g d_full_norent=(value2010_full_norent-value1990)/((1-high_skill)*1.408819+high_skill*6.002858)
g d_rent_real=(value2010_rent_real-value1990)/((1-high_skill)*1.408819+high_skill*6.002858)
g d_full_real=(value2010_full_real-value1990)/((1-high_skill)*1.408819+high_skill*6.002858)
g d_full_norent_real=(value2010_full_norent_real-value1990)/((1-high_skill)*1.408819+high_skill*6.002858)

** Table 9
cd $data\temp_files\welfare
save value_temp, replace

g dd_inc=d_inc-d_inc[_n-1]
g dd_val=d_val-d_val[_n-1]
g dd_full_real=d_full_real-d_full_real[_n-1]
g dd_full_norent_real=d_full_norent_real-d_full_norent_real[_n-1]

g income_gap=income1990-income1990[_n-1]

** Welfare gap 1990 (normalized to income gap)
sum income_gap
scalar inc_gap=r(mean)
display inc_gap
***********************************
qui sum dd_inc
scalar change_inc=r(mean)
scalar inc_gap2010=inc_gap+change_inc
** Income gap 2010
display inc_gap2010
** Change in income gap
display change_inc


** Welfare gap in 2010 due to the change in value of time
qui sum dd_val
scalar change_val=r(mean)
scalar val_gap2010=inc_gap+change_val
display val_gap2010
** Change in welfare gap due to the change in the value of time
display change_val

** Effect on welfare gap
scalar delta_change_val=change_val - change_inc
scalar delta_per_change_val=delta_change_val/change_inc
display delta_change_val
*** Percentage 
display delta_per_change_val

*** Welfare gap in 2010 due to the change in value of time, change in amenities and change in rents. 
qui sum dd_full_real
scalar change_full=r(mean)
scalar full_real_gap2010=inc_gap+change_full
display full_real_gap2010
** Change in welfare gap due to the change in the value of time, change in amenities and change in rents. 
display change_full
** Effect on welfare gap
scalar delta_change_full=change_full - change_inc
scalar delta_per_change_full=delta_change_full/change_inc
display delta_change_full
*** Percentage 
display delta_per_change_full


*** Welfare gap in 2010 due to the change in value of time, change in amenities (no rents)
qui sum dd_full_norent_real
scalar change_norent=r(mean)
scalar full_norent_real_gap2010=inc_gap+change_norent
display full_norent_real_gap2010
** Change in welfare gap due to the change in the value of time, change in amenities (no rents). 
display change_norent
** Effect on welfare gap
scalar delta_change_norent=change_norent - change_inc
scalar delta_per_change_norent=delta_change_norent/change_inc
display delta_change_norent
*** Percentage 
display delta_per_change_norent
