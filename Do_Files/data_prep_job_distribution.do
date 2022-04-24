clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

***
* generate occupation share per industry by year using the IPUMS microdata
cd $data\ipums_micro
use 1990_2000_2010_temp, clear

cd $data\temp_files

collapse (sum) pop=perwt, by(year ind1990 occ2010)
save ind1990_2010, replace
collapse (sum) pop_ind1990=pop, by(year ind1990)
merge 1:m year ind1990 using ind1990_2010
drop _merge
drop if ind1990==0
g occ_share=pop/pop_ind1990
drop pop pop_ind1990
sort year ind1990 occ2010
save occ_share_perind, replace

u occ_share_perind, clear
keep if year==1990
save occ_share_perind1990, replace

u occ_share_perind, clear
keep if year==2000
save occ_share_perind2000, replace

u occ_share_perind, clear
keep if year==2010
save occ_share_perind2010, replace


***
******************************************
******************************************
** decompose the cic-NAICS crosswalk

cd $data\zbp
import excel cic1990_naics97.xlsx, sheet("Sheet1") firstrow clear
tostring NAICS, g(naics)
unique naics
duplicates tag naics, g(tag)
drop if tag>=1
drop NAICS

destring Census, g(ind1990)
ren Census2000CategoryTitle naics_descr
keep ind1990 naics  naics_descr
g digit=length(naics)

cd $data\temp_files
save cic1990_naics97, replace

u cic1990_naics97, clear
keep if digit==6
save cic1990_naics97_6digit, replace

u cic1990_naics97, clear
keep if digit==5
ren naics naics5
save cic1990_naics97_5digit, replace

u cic1990_naics97, clear
keep if digit==4
ren naics naics4
save cic1990_naics97_4digit, replace

u cic1990_naics97, clear
keep if digit==3
ren naics naics3
save cic1990_naics97_3digit, replace

u cic1990_naics97, clear
keep if digit==2
ren naics naics2
save cic1990_naics97_2digit, replace

******************************************
******************************************
** decompose the cic-sic crosswalk

cd $data\zbp
import excel cic_sic_crosswalk.xlsx, sheet("Sheet1") firstrow allstring clear
destring cic_code, g(ind1990)
drop cic_code

g digit=length(sic)

cd $data\temp_files
save cic_sic_crosswalk, replace

u cic_sic_crosswalk, clear
keep if digit==4
ren sic sic4
drop digit
save cic_sic_crosswalk4digit, replace

u cic_sic_crosswalk, clear
keep if digit==3
ren sic sic3
drop digit
save cic_sic_crosswalk3digit, replace

u cic_sic_crosswalk, clear
keep if digit==2
ren sic sic2
drop digit
save cic_sic_crosswalk2digit, replace




cd $data\zbp
u zip94detail, clear

g n1_4_num=2.5*n1_4
g n5_9_num=7*n5_9
g n10_19_num=14.5*n10_19
g n20_49_num=34.5*n20_49
g n50_99_num=74.5*n50_99
g n100_249_num=174.5*n100_249
g n250_499_num=374.5*n250_499
g n500_999_num=749.5*n500_999
g n1000_num=1500*n1000
g est_num=n1_4_num+n5_9_num+n10_19_num+n20_49_num+n50_99_num+n100_249_num+n250_499_num+n500_999_num+n1000_num


g lastdigit=substr(sic,4,1)
drop if lastdigit=="-"
drop if lastdigit=="\"

g sic4=sic

cd $data\temp_files
merge m:1 sic4 using cic_sic_crosswalk4digit
ren _merge _merge_4digit
ren ind1990 ind1990_4digit

g sic3=substr(sic,1,3)
merge m:1 sic3 using cic_sic_crosswalk3digit
ren _merge _merge_3digit
ren ind1990 ind1990_3digit

g sic2=substr(sic,1,2)
merge m:1 sic2 using cic_sic_crosswalk2digit
ren _merge _merge_2digit
ren ind1990 ind1990_2digit

g ind1990=ind1990_2digit if _merge_2digit==3
replace ind1990=ind1990_3digit if _merge_3digit==3
replace ind1990=ind1990_4digit if _merge_4digit==3

drop _merge_2digit ind1990_2digit sic2 _merge_3digit ind1990_3digit sic3 _merge_4digit ind1990_4digit sic4 lastdigit
drop if ind1990==.
drop if zip==.

collapse (sum) est_num, by(zip ind1990)

cd $data\temp_files
save temp, replace

cd $data\temp_files
u temp, clear
keep if zip<20000
joinby ind1990 using occ_share_perind1990
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp0_20000, replace

u temp, clear
keep if zip>=20000 & zip<40000
joinby ind1990 using occ_share_perind1990
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp20000_40000, replace

u temp, clear
keep if zip>=40000 & zip<60000
joinby ind1990 using occ_share_perind1990
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp40000_60000, replace

u temp, clear
keep if zip>=60000 & zip<80000
joinby ind1990 using occ_share_perind1990
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp60000_80000, replace

u temp, clear
keep if zip>=80000 & zip<100000
joinby ind1990 using occ_share_perind1990
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp80000_100000, replace

clear all
append using temp0_20000
append using temp20000_40000
append using temp40000_60000
append using temp60000_80000
append using temp80000_100000
*g year=1990

save occ_emp_1994, replace



***2000
cd $data\zbp
u zip00detail, clear

g n1_4_num=2.5*n1_4
g n5_9_num=7*n5_9
g n10_19_num=14.5*n10_19
g n20_49_num=34.5*n20_49
g n50_99_num=74.5*n50_99
g n100_249_num=174.5*n100_249
g n250_499_num=374.5*n250_499
g n500_999_num=749.5*n500_999
g n1000_num=1500*n1000
g est_num=n1_4_num+n5_9_num+n10_19_num+n20_49_num+n50_99_num+n100_249_num+n250_499_num+n500_999_num+n1000_num

g lastdigit=substr(naics,6,1)
drop if lastdigit=="-"
drop lastdigit

sort naics
cd $data\temp_files
merge m:1 naics using cic1990_naics97_6digit
ren _merge _merge_6digit
ren ind1990 ind1990_6digit
drop digit naics_descr

g naics5=substr(naics,1,5)
merge m:1 naics5 using cic1990_naics97_5digit
ren ind1990 ind1990_5digit
drop naics5 digit naics_descr
ren _merge _merge_5digit

g naics4=substr(naics,1,4)
merge m:1 naics4 using cic1990_naics97_4digit
ren ind1990 ind1990_4digit
drop naics4 digit naics_descr
ren _merge _merge_4digit

g naics3=substr(naics,1,3)
merge m:1 naics3 using cic1990_naics97_3digit
ren ind1990 ind1990_3digit
drop naics3 digit naics_descr
ren _merge _merge_3digit

g naics2=substr(naics,1,2)
merge m:1 naics2 using cic1990_naics97_2digit
ren ind1990 ind1990_2digit
drop naics2 digit naics_descr
ren _merge _merge_2digit

g ind1990=ind1990_2digit if _merge_2digit==3
replace ind1990=ind1990_3digit if _merge_3digit==3
replace ind1990=ind1990_4digit if _merge_4digit==3
replace ind1990=ind1990_5digit if _merge_5digit==3
replace ind1990=ind1990_6digit if _merge_6digit==3

drop ind1990_6digit _merge_6digit ind1990_5digit _merge_5digit ind1990_4digit _merge_4digit ind1990_3digit _merge_3digit ind1990_2digit _merge_2digit

drop if ind1990==.
drop if zip==.

collapse (sum) est_num, by(zip ind1990)
save temp, replace

u temp, clear
keep if zip<20000
joinby ind1990 using occ_share_perind2000
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp0_20000, replace

u temp, clear
keep if zip>=20000 & zip<40000
joinby ind1990 using occ_share_perind2000
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp20000_40000, replace

u temp, clear
keep if zip>=40000 & zip<60000
joinby ind1990 using occ_share_perind2000
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp40000_60000, replace

u temp, clear
keep if zip>=60000 & zip<80000
joinby ind1990 using occ_share_perind2000
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp60000_80000, replace

u temp, clear
keep if zip>=80000 & zip<100000
joinby ind1990 using occ_share_perind2000
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp80000_100000, replace

clear all
append using temp0_20000
append using temp20000_40000
append using temp40000_60000
append using temp60000_80000
append using temp80000_100000
g year=2000
save occ_emp_2000, replace

***2010
cd $data\zbp
u zip10detail, clear

g n1_4_num=2.5*n1_4
g n5_9_num=7*n5_9
g n10_19_num=14.5*n10_19
g n20_49_num=34.5*n20_49
g n50_99_num=74.5*n50_99
g n100_249_num=174.5*n100_249
g n250_499_num=374.5*n250_499
g n500_999_num=749.5*n500_999
g n1000_num=1500*n1000
g est_num=n1_4_num+n5_9_num+n10_19_num+n20_49_num+n50_99_num+n100_249_num+n250_499_num+n500_999_num+n1000_num

g lastdigit=substr(naics,6,1)
drop if lastdigit=="-"
drop lastdigit

sort naics
cd $data\temp_files
merge m:1 naics using cic1990_naics97_6digit
ren _merge _merge_6digit
ren ind1990 ind1990_6digit
drop digit naics_descr

g naics5=substr(naics,1,5)
merge m:1 naics5 using cic1990_naics97_5digit
ren ind1990 ind1990_5digit
drop naics5 digit naics_descr
ren _merge _merge_5digit

g naics4=substr(naics,1,4)
merge m:1 naics4 using cic1990_naics97_4digit
ren ind1990 ind1990_4digit
drop naics4 digit naics_descr
ren _merge _merge_4digit

g naics3=substr(naics,1,3)
merge m:1 naics3 using cic1990_naics97_3digit
ren ind1990 ind1990_3digit
drop naics3 digit naics_descr
ren _merge _merge_3digit

g naics2=substr(naics,1,2)
merge m:1 naics2 using cic1990_naics97_2digit
ren ind1990 ind1990_2digit
drop naics2 digit naics_descr
ren _merge _merge_2digit

g ind1990=ind1990_2digit if _merge_2digit==3
replace ind1990=ind1990_3digit if _merge_3digit==3
replace ind1990=ind1990_4digit if _merge_4digit==3
replace ind1990=ind1990_5digit if _merge_5digit==3
replace ind1990=ind1990_6digit if _merge_6digit==3

drop ind1990_6digit _merge_6digit ind1990_5digit _merge_5digit ind1990_4digit _merge_4digit ind1990_3digit _merge_3digit ind1990_2digit _merge_2digit

drop if ind1990==.
drop if zip==.

collapse (sum) est_num, by(zip ind1990)
save temp, replace

u temp, clear
keep if zip<20000
joinby ind1990 using occ_share_perind2010
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp0_20000, replace

u temp, clear
keep if zip>=20000 & zip<40000
joinby ind1990 using occ_share_perind2010
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp20000_40000, replace

u temp, clear
keep if zip>=40000 & zip<60000
joinby ind1990 using occ_share_perind2010
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp40000_60000, replace

u temp, clear
keep if zip>=60000 & zip<80000
joinby ind1990 using occ_share_perind2010
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp60000_80000, replace

u temp, clear
keep if zip>=80000 & zip<100000
joinby ind1990 using occ_share_perind2010
replace est_num=est_num*occ_share
collapse (sum) est_num, by(zip occ2010)
save temp80000_100000, replace

clear all
append using temp0_20000
append using temp20000_40000
append using temp40000_60000
append using temp60000_80000
append using temp80000_100000
g year=2010
save occ_emp_2010, replace


*******************************************


*** generate zip level employment share among its respective METAREA
cd $data\temp_files
u occ_emp_1994, clear

cd $data\geographic
merge m:1 zip using zip1990_metarea
keep if _merge==3
drop _merge
cd $data\temp_files
save temp, replace

collapse (sum) est_num_total=est_num, by(occ2010 metarea)

merge 1:m occ2010 metarea using temp
drop _merge
g share=est_num/est_num_total
keep share zip occ2010 metarea

save occ_emp_share_1994, replace

**2000
cd $data\temp_files
u occ_emp_2000, clear

cd $data\geographic
merge m:1 zip using zip2000_metarea
keep if _merge==3
drop _merge
cd $data\temp_files
save temp, replace

collapse (sum) est_num_total=est_num, by(occ2010 metarea)

merge 1:m occ2010 metarea using temp
drop _merge
g share=est_num/est_num_total
keep share zip occ2010 metarea

save occ_emp_share_2000, replace

** 2010
cd $data\temp_files
u occ_emp_2010, clear

cd $data\geographic
merge m:1 zip using zip2010_metarea
keep if _merge==3
drop _merge
cd $data\temp_files
save temp, replace

collapse (sum) est_num_total=est_num, by(occ2010 metarea)

merge 1:m occ2010 metarea using temp
drop _merge
g share=est_num/est_num_total
keep share zip occ2010 metarea

save occ_emp_share_2010, replace