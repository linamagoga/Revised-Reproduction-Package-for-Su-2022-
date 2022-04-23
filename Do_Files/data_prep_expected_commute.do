clear all
global data="C:\Users\alen\Documents\Dropbox\paper_folder"

cd $data\temp_files

u occ_emp_share_1994, clear

cd $data\geographic

merge m:1 metarea using 1990_rank
drop _merge

cd $data\temp_files
save occ_emp_share_temp, replace


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
cd $data\temp_files
u occ_emp_share_temp, clear
keep if occ2010==`num'
drop serial year rank
cd $data\travel

merge 1:m zip using travel_time_hat
keep if _merge==3
drop _merge

ren travel_time_hat travel_time
** commuting hours per work week
replace travel_time=10*travel_time

g discount=exp(-0.3425*travel_time)
g pi=share*discount
sort gisjoin
by gisjoin: egen pi_total=sum(pi)

g  share_tilda=pi/pi_total

g travel_time_share=travel_time*share_tilda

collapse (sum) expected_commute=travel_time_share, by(gisjoin)

cd $data\temp_files\commute
sort expected

save commute_`num', replace
}

cd $data\temp_files\commute
clear
# delimit
foreach num of numlist 30 120 130 150 205 230 310
350 410 430 520 530 540 560 620 710 730 800
860 1000 1010 1220 1300 1320 1350 1360 1410
1430 1460 1530 1540 1550 1560 1610 1720
1740 1820 1920 1960 2000 2010 2040 2060 2100 2140
2200 2300 2310 2320 2340 2430 2540 2600 2630 2700 2720
2750 2810 2825 2840 2850 2910 3010 3030 3050 3060 3130
3160 3220 3230 3240 3300 3310 3410 3500 3530 3640
3650 3740 3930 3940 3950 4000 4010 4030 4040
4060 4110 4130 4200 4210 4220 4230 4250
4320 4350 4430 4500 4510 4600 4620 4700
4720 4740  4750 4760 4800 4810 4820
4840 4850 4900  4950 4965 5000 5020 5100
5110 5120 5140 5160 5260 5300 5310 5320
5330 5350 5360 5400 5410 5420 5510 5520 5600 5610 5620 5630 5700 5800 5810 5820 5850
5860 5900 5940 6050 6200 6220 6230 6240 6250 6260 6320
6330 6355 6420 6440 6515 6520 6530 6600 6660 7000
7010 7020 7140 7150 7200 7210 7220 7315 7330
7340 7700 7720 7750 7800 7810 7950 8030 8130  8140
8220 8230 8300 8320 8350 8500 8610 8650 8710 8740
8760 8800 8810 8830 8965
9000 9030 9050 9100 9130 9140 9350
9510 9600 9610 9620 9640 {;
# delimit cr

u commute_`num', replace
g occ2010=`num'
save commute_`num'_temp, replace

}

clear
# delimit
foreach num of numlist 30 120 130 150 205 230 310
350 410 430 520 530 540 560 620 710 730 800
860 1000 1010 1220 1300 1320 1350 1360 1410
1430 1460 1530 1540 1550 1560 1610 1720
1740 1820 1920 1960 2000 2010 2040 2060 2100 2140
2200 2300 2310 2320 2340 2430 2540 2600 2630 2700 2720
2750 2810 2825 2840 2850 2910 3010 3030 3050 3060 3130
3160 3220 3230 3240 3300 3310 3410 3500 3530 3640
3650 3740 3930 3940 3950 4000 4010 4030 4040
4060 4110 4130 4200 4210 4220 4230 4250
4320 4350 4430 4500 4510 4600 4620 4700
4720 4740  4750 4760 4800 4810 4820
4840 4850 4900  4950 4965 5000 5020 5100
5110 5120 5140 5160 5260 5300 5310 5320
5330 5350 5360 5400 5410 5420 5510 5520 5600 5610 5620 5630 5700 5800 5810 5820 5850
5860 5900 5940 6050 6200 6220 6230 6240 6250 6260 6320
6330 6355 6420 6440 6515 6520 6530 6600 6660 7000
7010 7020 7140 7150 7200 7210 7220 7315 7330
7340 7700 7720 7750 7800 7810 7950 8030 8130  8140
8220 8230 8300 8320 8350 8500 8610 8650 8710 8740
8760 8800 8810 8830 8965
9000 9030 9050 9100 9130 9140 9350
9510 9600 9610 9620 9640 {;
# delimit cr

append using commute_`num'_temp

}
cd $data\temp_files\commute
save commute, replace




*** all employment

foreach num of numlist 1(1)21 {
cd $data\temp_files
u occ_emp_1994, clear

* MANAGEMENT, BUSINESS, SCIENCE, AND ARTS
g occ_group=1 if occ2010>=10 & occ2010<=430
* BUSINESS OPERATIONS SPECIALISTS
replace occ_group=2 if occ2010>=500 & occ2010<=730
* FINANCIAL SPECIALISTS
replace occ_group=3 if occ2010>=800 & occ2010<=950
* COMPUTER AND MATHEMATICAL
replace occ_group=4 if occ2010>=1000 & occ2010<=1240
* ARCHITECTURE AND ENGINEERING
replace occ_group=5 if occ2010>=1300 & occ2010<=1540
* TECHNICIANS
replace occ_group=6 if occ2010>=1550 & occ2010<=1560
* LIFE, PHYSICAL, AND SOCIAL SCIENCE
replace occ_group=7 if occ2010>=1600 & occ2010<=1980
* COMMUNITY AND SOCIAL SERVICES
replace occ_group=8 if occ2010>=2000 & occ2010<=2060
* LEGAL
replace occ_group=9 if occ2010>=2100 & occ2010<=2150
* EDUCATION, TRAINING, AND LIBRARY
replace occ_group=10 if occ2010>=2200 & occ2010<=2550
* ARTS, DESIGN, ENTERTAINMENT, SPORTS, AND MEDIA
replace occ_group=11 if occ2010>=2600 & occ2010<=2920
* HEALTHCARE PRACTITIONERS AND TECHNICAL
replace occ_group=12 if occ2010>=3000 & occ2010<=3540
* HEALTHCARE SUPPORT
replace occ_group=13 if occ2010>=3600 & occ2010<=3650
* PROTECTIVE SERVICE
replace occ_group=14 if occ2010>=3700 & occ2010<=3950
* FOOD PREPARATION AND SERVING
replace occ_group=15 if occ2010>=4000 & occ2010<=4150
* BUILDING AND GROUNDS CLEANING AND MAINTENANCE
replace occ_group=16 if occ2010>=4200 & occ2010<=4250
* PERSONAL CARE AND SERVICE
replace occ_group=17 if occ2010>=4300 & occ2010<=4650
* SALES AND RELATED
replace occ_group=18 if occ2010>=4700 & occ2010<=4965
* OFFICE AND ADMINISTRATIVE SUPPORT
replace occ_group=19 if occ2010>=5000 & occ2010<=5940
* FARMING, FISHING, AND FORESTRY
replace occ_group=20 if occ2010>=6005 & occ2010<=6130
* CONSTRUCTION
replace occ_group=21 if occ2010>=6200 & occ2010<=6765
* EXTRACTION
replace occ_group=22 if occ2010>=6800 & occ2010<=6940
* INSTALLATION, MAINTENANCE, AND REPAIR
replace occ_group=23 if occ2010>=7000 & occ2010<=7630
* PRODUCTION
replace occ_group=24 if occ2010>=7700 & occ2010<=8965
* TRANSPORTATION AND MATERIAL MOVING
replace occ_group=25 if occ2010>=9000 & occ2010<=9750

keep if occ_group!=`num'

collapse (sum) est_num, by(zip)

cd $data\geographic
merge m:1 zip using zip1990_metarea
keep if _merge==3
drop _merge

sort metarea
by metarea: egen est_num_total=sum(est_num)

g share=est_num/est_num_total
keep share zip metarea

cd $data\geographic

merge m:1 metarea using 1990_rank
drop _merge

drop serial year rank
cd $data\travel

merge 1:m zip using travel_time_hat
keep if _merge==3
drop _merge


ren travel_time_hat travel_time

** commuting hours per work week
replace travel_time=10*travel_time

g discount=exp(-0.3425*travel_time)
g pi=share*discount

sort gisjoin
by gisjoin: egen pi_total=sum(pi)


g  share_tilda=pi/pi_total

g travel_time_share=travel_time*share_tilda

collapse (sum) expected_commute=travel_time_share, by(gisjoin)


sort expected

ren expected_commute total_commute
cd $data\temp_files\commute
save commute_total`num', replace
}


foreach num of numlist 23(1)25 {
cd $data\temp_files
u occ_emp_1994, clear

* MANAGEMENT, BUSINESS, SCIENCE, AND ARTS
g occ_group=1 if occ2010>=10 & occ2010<=430
* BUSINESS OPERATIONS SPECIALISTS
replace occ_group=2 if occ2010>=500 & occ2010<=730
* FINANCIAL SPECIALISTS
replace occ_group=3 if occ2010>=800 & occ2010<=950
* COMPUTER AND MATHEMATICAL
replace occ_group=4 if occ2010>=1000 & occ2010<=1240
* ARCHITECTURE AND ENGINEERING
replace occ_group=5 if occ2010>=1300 & occ2010<=1540
* TECHNICIANS
replace occ_group=6 if occ2010>=1550 & occ2010<=1560
* LIFE, PHYSICAL, AND SOCIAL SCIENCE
replace occ_group=7 if occ2010>=1600 & occ2010<=1980
* COMMUNITY AND SOCIAL SERVICES
replace occ_group=8 if occ2010>=2000 & occ2010<=2060
* LEGAL
replace occ_group=9 if occ2010>=2100 & occ2010<=2150
* EDUCATION, TRAINING, AND LIBRARY
replace occ_group=10 if occ2010>=2200 & occ2010<=2550
* ARTS, DESIGN, ENTERTAINMENT, SPORTS, AND MEDIA
replace occ_group=11 if occ2010>=2600 & occ2010<=2920
* HEALTHCARE PRACTITIONERS AND TECHNICAL
replace occ_group=12 if occ2010>=3000 & occ2010<=3540
* HEALTHCARE SUPPORT
replace occ_group=13 if occ2010>=3600 & occ2010<=3650
* PROTECTIVE SERVICE
replace occ_group=14 if occ2010>=3700 & occ2010<=3950
* FOOD PREPARATION AND SERVING
replace occ_group=15 if occ2010>=4000 & occ2010<=4150
* BUILDING AND GROUNDS CLEANING AND MAINTENANCE
replace occ_group=16 if occ2010>=4200 & occ2010<=4250
* PERSONAL CARE AND SERVICE
replace occ_group=17 if occ2010>=4300 & occ2010<=4650
* SALES AND RELATED
replace occ_group=18 if occ2010>=4700 & occ2010<=4965
* OFFICE AND ADMINISTRATIVE SUPPORT
replace occ_group=19 if occ2010>=5000 & occ2010<=5940
* FARMING, FISHING, AND FORESTRY
replace occ_group=20 if occ2010>=6005 & occ2010<=6130
* CONSTRUCTION
replace occ_group=21 if occ2010>=6200 & occ2010<=6765
* EXTRACTION
replace occ_group=22 if occ2010>=6800 & occ2010<=6940
* INSTALLATION, MAINTENANCE, AND REPAIR
replace occ_group=23 if occ2010>=7000 & occ2010<=7630
* PRODUCTION
replace occ_group=24 if occ2010>=7700 & occ2010<=8965
* TRANSPORTATION AND MATERIAL MOVING
replace occ_group=25 if occ2010>=9000 & occ2010<=9750

keep if occ_group!=`num'

collapse (sum) est_num, by(zip)

cd $data\geographic
merge m:1 zip using zip1990_metarea
keep if _merge==3
drop _merge

sort metarea
by metarea: egen est_num_total=sum(est_num)

g share=est_num/est_num_total
keep share zip metarea

cd $data\geographic

merge m:1 metarea using 1990_rank
drop _merge

drop serial year rank

cd $data\travel
merge 1:m zip using travel_time_hat
keep if _merge==3
drop _merge

ren travel_time_hat travel_time

** commuting hours per work week

replace travel_time=10*travel_time

g discount=exp(-0.3425*travel_time)
g pi=share*discount

sort gisjoin
by gisjoin: egen pi_total=sum(pi)


g  share_tilda=pi/pi_total

g travel_time_share=travel_time*share_tilda

collapse (sum) expected_commute=travel_time_share, by(gisjoin)


sort expected

ren expected_commute total_commute
cd $data\temp_files\commute

save commute_total`num', replace
}

clear
foreach num of numlist 1(1)21 {
u commute_total`num', clear
g occ_group=`num'
save commute_total`num', replace
}
foreach num of numlist 23(1)25 {
u commute_total`num', clear
g occ_group=`num'
save commute_total`num', replace
}

clear
foreach num of numlist 1(1)21 {
append using commute_total`num'
}
foreach num of numlist 23(1)25 {
append using commute_total`num'
}

save commute_total, replace
