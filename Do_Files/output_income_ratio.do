
clear all
global data="/Users/linagomez/Documents/Stata/Economía Urbana/132721-V1/data"


***********************************
*** income ratio (5 miles)
**********************************
cd "$data/nhgis"
import delimited nhgis0038_ds82_1950_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1950_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1950_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1950, replace

**
cd "$data/nhgis"
import delimited nhgis0005_ds92_1960_tract.csv,  clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1960_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1960_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1960, replace
**

cd "$data/nhgis"
import delimited nhgis0005_ds99_1970_tract.csv, clear
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1970_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1970_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1970, replace

**
cd "$data/nhgis"
import delimited nhgis0005_ds107_1980_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1980_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1980_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1980, replace

**
cd "$data/nhgis"
import delimited nhgis0005_ds123_1990_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1990_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1990, replace

***

cd "$data/nhgis"
import delimited nhgis0005_ds151_2000_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract2000_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge

cd "$data/geographic"
merge m:1 gisjoin using tract2000_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 2000, replace

cd "$data/nhgis"
import delimited nhgis0005_ds184_20115_2011_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract2010_metarea
keep if _merge==3
drop _merge
drop year
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract2010_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 2010, replace



****1960 ****
cd "$data/temp_files"
u 1960, clear
keep gisjoin year state metarea downtown  b8w001 
g income=500
drop if b8w001==0
ren b8w001 count
keep income downtown metarea gisjoin count
save 1, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w002 
g income=1500
drop if b8w002==0
ren b8w002 count
keep income downtown metarea gisjoin count
save 2, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w003 
g income=2500
drop if b8w003==0
ren b8w003 count
keep income downtown metarea gisjoin count
save 3, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w004 
g income=3500
drop if b8w004==0
ren b8w004 count
keep income downtown metarea gisjoin count
save 4, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w005 
g income=4500
drop if b8w005==0
ren b8w005 count
keep income downtown metarea gisjoin count
save 5, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w006 
g income=5500
drop if b8w006==0
ren b8w006 count
keep income downtown metarea gisjoin count
save 6, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w007 
g income=6500
drop if b8w007==0
ren b8w007 count
keep income downtown metarea gisjoin count
save 7, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w008
g income=7500
drop if b8w008==0
ren b8w008 count
keep income downtown metarea gisjoin count
save 8, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w009
g income=8500
drop if b8w009==0
ren b8w009 count
keep income downtown metarea gisjoin count
save 9, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w010
g income=9500
drop if b8w010==0
ren b8w010 count
keep income downtown metarea gisjoin count
save 10, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w011
g income=12500
drop if b8w011==0
ren b8w011 count
keep income downtown metarea gisjoin count
save 11, replace

u 1960, clear
keep gisjoin year state metarea downtown b8w012
g income=20000
drop if b8w012==0
ren b8w012 count
keep income downtown metarea gisjoin count
save 12, replace

u 1960, clear
keep gisjoin year state metarea downtown b8w013
g income=25000
drop if b8w013==0
ren b8w013 count
keep income downtown metarea gisjoin count
save 13, replace

clear
foreach num of numlist 1(1)13 {
append using `num'
*erase `num'.dta
}

g year=1960
sort metarea
save 1960_income, replace



**** 1970 ****
cd "$data/temp_files"
u 1970, clear
g income=500
drop if c3t001==0
ren c3t001 count
keep income downtown metarea gisjoin count
save 1, replace

u 1970, clear
g income=1500
drop if c3t002==0
ren c3t002 count
keep income downtown metarea gisjoin count
save 2, replace

u 1970, clear
g income=2500
drop if c3t003==0
ren c3t003 count
keep income downtown metarea gisjoin count
save 3, replace

u 1970, clear
g income=3500
drop if c3t004==0
ren c3t004 count
keep income downtown metarea gisjoin count
save 4, replace

u 1970, clear
g income=4500
drop if c3t005==0
ren c3t005 count
keep income downtown metarea gisjoin count
save 5, replace

u 1970, clear
g income=5500
drop if c3t006==0
ren c3t006 count
keep income downtown metarea gisjoin count
save 6, replace

u 1970, clear
g income=6500
drop if c3t007==0
ren c3t007 count
keep income downtown metarea gisjoin count
save 7, replace

u 1970, clear
g income=7500
drop if c3t008==0
ren c3t008 count
keep income downtown metarea gisjoin count
save 8, replace

u 1970, clear
g income=8500
drop if c3t009==0
ren c3t009 count
keep income downtown metarea gisjoin count
save 9, replace

u 1970, clear
g income=9500
drop if c3t010==0
ren c3t010 count
keep income downtown metarea gisjoin count
save 10, replace

u 1970, clear
g income=11000
drop if c3t011==0
ren c3t011 count
keep income downtown metarea gisjoin count
save 11, replace

u 1970, clear
g income=14000
drop if c3t012==0
ren c3t012 count
keep income downtown metarea gisjoin count
save 12, replace

u 1970, clear
g income=20000
drop if c3t013==0
ren c3t013 count
keep income downtown metarea gisjoin count
save 13, replace

u 1970, clear
g income=32500
drop if c3t014==0
ren c3t014 count
keep income downtown metarea gisjoin count
save 14, replace

u 1970, clear
g income=50000
drop if c3t015==0
ren c3t015 count
keep income downtown metarea gisjoin count
save 15, replace


foreach num of numlist 1(1)15 {
append using `num'
*erase `num'.dta
}

g year=1970
sort metarea
replace count=0 if count==-1
save 1970_income, replace


*** 1980 ***
cd "$data/temp_files"
u 1980, clear
g income=1250
drop if did001==0
ren did001 count
keep income downtown metarea gisjoin count
save 1, replace

u 1980, clear 
g income=3750
drop if did002==0
ren did002 count
keep income downtown metarea gisjoin count
save 2, replace

u 1980, clear 
g income=6250
drop if did003==0
ren did003 count
keep income downtown metarea gisjoin count
save 3, replace

u 1980, clear
g income=8750
drop if did004==0
ren did004 count
keep income downtown metarea gisjoin count
save 4, replace

u 1980, clear
g income=11250
drop if did005==0
ren did005 count
keep income downtown metarea gisjoin count
save 5, replace

u 1980, clear
g income=13750
drop if did006==0
ren did006 count
keep income downtown metarea gisjoin count
save 6, replace

u 1980, clear 
g income=16250
drop if did007==0
ren did007 count
keep income downtown metarea gisjoin count
save 7, replace

u 1980, clear
g income=18750
drop if did008==0
ren did008 count
keep income downtown metarea gisjoin count
save 8, replace

u 1980, clear
g income=21250
drop if did009==0
ren did009 count
keep income downtown metarea gisjoin count
save 9, replace

u 1980, clear
g income=23750
drop if did010==0
ren did010 count
keep income downtown metarea gisjoin count
save 10, replace

u 1980, clear
g income=26250
drop if did011==0
ren did011 count
keep income downtown metarea gisjoin count
save 11, replace

u 1980, clear
g income=28750
drop if did012==0
ren did012 count
keep income downtown metarea gisjoin count
save 12, replace

u 1980, clear
g income=32500
drop if did013==0
ren did013 count
keep income downtown metarea gisjoin count
save 13, replace

u 1980, clear
g income=37500
drop if did014==0
ren did014 count
keep income downtown metarea gisjoin count
save 14, replace

u 1980, clear
g income=45000
drop if did015==0
ren did015 count
keep income downtown metarea gisjoin count
save 15, replace

u 1980, clear
g income=62500
drop if did016==0
ren did016 count
keep income downtown metarea gisjoin count
save 16, replace

u 1980, clear
g income=75000
drop if did017==0
ren did017 count
keep income downtown metarea gisjoin count
save 17, replace

foreach num of numlist 1(1)17 {
append using `num'
*erase `num'.dta
}

g year=1980
sort metarea
replace count=0 if count==-1
save 1980_income, replace

*** 1990 ***
cd "$data/temp_files"
u 1990, clear
g income=2500
drop if e4t001==0
ren e4t001 count
keep income downtown metarea gisjoin count
save 1, replace

u 1990, clear
g income=7500
drop if e4t002==0
ren e4t002 count
keep income downtown metarea gisjoin count
save 2, replace

u 1990, clear
g income=11250
drop if e4t003==0
ren e4t003 count
keep income downtown metarea gisjoin count
save 3, replace

u 1990, clear
g income=13750
drop if e4t004==0
ren e4t004 count
keep income downtown metarea gisjoin count
save 4, replace

u 1990, clear
g income=16250
drop if e4t005==0
ren e4t005 count
keep income downtown metarea gisjoin count
save 5, replace

u 1990, clear
g income=18750
drop if e4t006==0
ren e4t006 count
keep income downtown metarea gisjoin count
save 6, replace

u 1990, clear
g income=21250
drop if e4t007==0
ren e4t007 count
keep income downtown metarea gisjoin count
save 7, replace

u 1990, clear
g income=23750
drop if e4t008==0
ren e4t008 count
keep income downtown metarea gisjoin count
save 8, replace

u 1990, clear
g income=26250
drop if e4t009==0
ren e4t009 count
keep income downtown metarea gisjoin count
save 9, replace

u 1990, clear
g income=28750
drop if e4t010==0
ren e4t010 count
keep income downtown metarea gisjoin count
save 10, replace

u 1990, clear
g income=31250
drop if e4t011==0
ren e4t011 count
keep income downtown metarea gisjoin count
save 11, replace

u 1990, clear
g income=33750
drop if e4t012==0
ren e4t012 count
keep income downtown metarea gisjoin count
save 12, replace

u 1990, clear
g income=37250
drop if e4t013==0
ren e4t013 count
keep income downtown metarea gisjoin count
save 13, replace

u 1990, clear
g income=38750
drop if e4t014==0
ren e4t014 count
keep income downtown metarea gisjoin count
save 14, replace

u 1990, clear
g income=41250
drop if e4t015==0
ren e4t015 count
keep income downtown metarea gisjoin count
save 15, replace

u 1990, clear
g income=43750
drop if e4t016==0
ren e4t016 count
keep income downtown metarea gisjoin count
save 16, replace

u 1990, clear
g income=46250
drop if e4t017==0
ren e4t017 count
keep income downtown metarea gisjoin count
save 17, replace

u 1990, clear
g income=48750
drop if e4t018==0
ren e4t018 count
keep income downtown metarea gisjoin count
save 18, replace

u 1990, clear
g income=52500
drop if e4t019==0
ren e4t019 count
keep income downtown metarea gisjoin count
save 19, replace

u 1990, clear
g income=57500
drop if e4t020==0
ren e4t020 count
keep income downtown metarea gisjoin count
save 20, replace

u 1990, clear
g income=62500
drop if e4t021==0
ren e4t021 count
keep income downtown metarea gisjoin count
save 21, replace

u 1990, clear
g income=87500
drop if e4t022==0
ren e4t022 count
keep income downtown metarea gisjoin count
save 22, replace

u 1990, clear
g income=112500
drop if e4t023==0
ren e4t023 count
keep income downtown metarea gisjoin count
save 23, replace

u 1990, clear
g income=137500
drop if e4t024==0
ren e4t024 count
keep income downtown metarea gisjoin count
save 24, replace


u 1990, clear
g income=150000
drop if e4t025==0
ren e4t025 count
keep income downtown metarea gisjoin count
save 25, replace

foreach num of numlist 1(1)25 {
append using `num'
*erase `num'.dta
}

g year=1990
sort metarea
replace count=0 if count==-1
save 1990_income, replace


*** 2000 ***
cd "$data/temp_files"
u 2000, clear
g income=5000
drop if gmx001==0
ren gmx001 count
keep income downtown metarea gisjoin count
save 1, replace

u 2000, clear
g income=12500
drop if gmx002==0
ren gmx002 count
keep income downtown metarea gisjoin count
save 2, replace

u 2000, clear
g income=17500
drop if gmx003==0
ren gmx003 count
keep income downtown metarea gisjoin count
save 3, replace

u 2000, clear
g income=22500
drop if gmx004==0
ren gmx004 count
keep income downtown metarea gisjoin count
save 4, replace

u 2000, clear
g income=27500
drop if gmx005==0
ren gmx005 count
keep income downtown metarea gisjoin count
save 5, replace

u 2000, clear
g income=32500
drop if gmx006==0
ren gmx006 count
keep income downtown metarea gisjoin count
save 6, replace

u 2000, clear
g income=37500
drop if gmx007==0
ren gmx007 count
keep income downtown metarea gisjoin count
save 7, replace

u 2000, clear
g income=42500
drop if gmx008==0
ren gmx008 count
keep income downtown metarea gisjoin count
save 8, replace

u 2000, clear
g income=47500
drop if gmx009==0
ren gmx009 count
keep income downtown metarea gisjoin count
save 9, replace

u 2000, clear
g income=55000
drop if gmx010==0
ren gmx010 count
keep income downtown metarea gisjoin count
save 10, replace

u 2000, clear
g income=67500
drop if gmx011==0
ren gmx011 count
keep income downtown metarea gisjoin count
save 11, replace

u 2000, clear
g income=87500
drop if gmx012==0
ren gmx012 count
keep income downtown metarea gisjoin count
save 12, replace

u 2000, clear
g income=112500
drop if gmx013==0
ren gmx013 count
keep income downtown metarea gisjoin count
save 13, replace

u 2000, clear
g income=137500
drop if gmx014==0
ren gmx014 count
keep income downtown metarea gisjoin count
save 14, replace

u 2000, clear
g income=175000
drop if gmx015==0
ren gmx015 count
keep income downtown metarea gisjoin count
save 15, replace

u 2000, clear
g income=200000
drop if gmx016==0
ren gmx016 count
keep income downtown metarea gisjoin count
save 16, replace


foreach num of numlist 1(1)16 {
append using `num'
*erase `num'.dta
}

g year=2000
sort metarea
replace count=0 if count==-1
save 2000_income, replace


*** 2010 ***
cd "$data/temp_files"
u 2010, clear
g income=5000
drop if mp0e002==0
ren mp0e002 count
keep income downtown metarea gisjoin count
save 2, replace

u 2010, clear
g income=12500
drop if mp0e003==0
ren mp0e003 count
keep income downtown metarea gisjoin count
save 3, replace

u 2010, clear
g income=17500
drop if mp0e004==0
ren mp0e004 count
keep income downtown metarea gisjoin count
save 4, replace

u 2010, clear
g income=22500
drop if mp0e005==0
ren mp0e005 count
keep income downtown metarea gisjoin count
save 5, replace

u 2010, clear
g income=27500
drop if mp0e006==0
ren mp0e006 count
keep income downtown metarea gisjoin count
save 6, replace

u 2010, clear
g income=32500
drop if mp0e007==0
ren mp0e007 count
keep income downtown metarea gisjoin count
save 7, replace

u 2010, clear
g income=37500
drop if mp0e008==0
ren mp0e008 count
keep income downtown metarea gisjoin count
save 8, replace

u 2010, clear
g income=42500
drop if mp0e009==0
ren mp0e009 count
keep income downtown metarea gisjoin count
save 9, replace

u 2010, clear
g income=47500
drop if mp0e010==0
ren mp0e010 count
keep income downtown metarea gisjoin count
save 10, replace

u 2010, clear
g income=55000
drop if mp0e011==0
ren mp0e011 count
keep income downtown metarea gisjoin count
save 11, replace

u 2010, clear
g income=67500
drop if mp0e012==0
ren mp0e012 count
keep income downtown metarea gisjoin count
save 12, replace

u 2010, clear
g income=87500
drop if mp0e013==0
ren mp0e013 count
keep income downtown metarea gisjoin count
save 13, replace

u 2010, clear
g income=112500
drop if mp0e014==0
ren mp0e014 count
keep income downtown metarea gisjoin count
save 14, replace

u 2010, clear
g income=137500
drop if mp0e015==0
ren mp0e015 count
keep income downtown metarea gisjoin count
save 15, replace

u 2010, clear
g income=175000
drop if mp0e016==0
ren mp0e016 count
keep income downtown metarea gisjoin count
save 16, replace

u 2010, clear
g income=200000
drop if mp0e017==0
ren mp0e017 count
keep income downtown metarea gisjoin count
save 17, replace


foreach num of numlist 2(1)17 {
append using `num'
}

g year=2010
sort metarea
replace count=0 if count==-1
save 2010_income, replace

*****
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank<=25
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if rank<=25
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

*** Main Figure (Figure 1a)

** income ratio (5 miles to downtown) top 25 MSAs
graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) yscale(range(0.72 0.85)) ylabel(0.7(0.05)0.9)
graph export "$data/graph/income_ratio_25.emf", replace


*** Appendix Figures
**** Ranking (1-10)
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank>=1 & rank<=10
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if rank>=1 & rank<=10
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) 
graph export "$data/graph"\income_ratio_1_10_5mi.emf, replace

**** Ranking (11-25)
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank>=11 & rank<=25
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if rank>=11 & rank<=25
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) 
graph export "$data/graph"\income_ratio_11_25_5mi.emf, replace



**** Ranking (25-50)
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank>25 & rank<=50
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if  rank>25 & rank<=50
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) 
graph export "$data/graph"\income_ratio_25_50_5mi.emf, replace
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank>50
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if  rank>50
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) 
graph export "$data/graph"\income_ratio_50+_5mi.emf, replace

*******************************************************************************
*******************************************************************************
*******************************************************************************
*******************************************************************************
***********************************
*** income ratio (3 miles)
**********************************
cd "$data/nhgis"
import delimited nhgis0038_ds82_1950_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1950_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1950_downtown3mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1950, replace

**
cd "$data/nhgis"
import delimited nhgis0005_ds92_1960_tract.csv,  clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1960_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1960_downtown3mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1960, replace
**

cd "$data/nhgis"
import delimited nhgis0005_ds99_1970_tract.csv, clear
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1970_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1970_downtown3mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1970, replace

**
cd "$data/nhgis"
import delimited nhgis0005_ds107_1980_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1980_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/geographic"
merge m:1 gisjoin using tract1980_downtown3mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1980, replace

**
cd "$data/nhgis"
import delimited nhgis0005_ds123_1990_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
*keep if rank<=25
cd "$data/geographic"
merge m:1 gisjoin using tract1990_downtown3mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 1990, replace

***

cd "$data/nhgis"
import delimited nhgis0005_ds151_2000_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract2000_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
*keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract2000_downtown3mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 2000, replace

cd "$data/nhgis"
import delimited nhgis0005_ds184_20115_2011_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract2010_metarea
keep if _merge==3
drop _merge
drop year
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
*keep if rank<=25
cd "$data/geographic"
merge m:1 gisjoin using tract2010_downtown3mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

cd "$data/temp_files"
save 2010, replace



****1960 ****
cd "$data/temp_files"
u 1960, clear
keep gisjoin year state metarea downtown  b8w001 
g income=500
drop if b8w001==0
ren b8w001 count
keep income downtown metarea gisjoin count
save 1, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w002 
g income=1500
drop if b8w002==0
ren b8w002 count
keep income downtown metarea gisjoin count
save 2, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w003 
g income=2500
drop if b8w003==0
ren b8w003 count
keep income downtown metarea gisjoin count
save 3, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w004 
g income=3500
drop if b8w004==0
ren b8w004 count
keep income downtown metarea gisjoin count
save 4, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w005 
g income=4500
drop if b8w005==0
ren b8w005 count
keep income downtown metarea gisjoin count
save 5, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w006 
g income=5500
drop if b8w006==0
ren b8w006 count
keep income downtown metarea gisjoin count
save 6, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w007 
g income=6500
drop if b8w007==0
ren b8w007 count
keep income downtown metarea gisjoin count
save 7, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w008
g income=7500
drop if b8w008==0
ren b8w008 count
keep income downtown metarea gisjoin count
save 8, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w009
g income=8500
drop if b8w009==0
ren b8w009 count
keep income downtown metarea gisjoin count
save 9, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w010
g income=9500
drop if b8w010==0
ren b8w010 count
keep income downtown metarea gisjoin count
save 10, replace

u 1960, clear
keep gisjoin year state metarea downtown  b8w011
g income=12500
drop if b8w011==0
ren b8w011 count
keep income downtown metarea gisjoin count
save 11, replace

u 1960, clear
keep gisjoin year state metarea downtown b8w012
g income=20000
drop if b8w012==0
ren b8w012 count
keep income downtown metarea gisjoin count
save 12, replace

u 1960, clear
keep gisjoin year state metarea downtown b8w013
g income=25000
drop if b8w013==0
ren b8w013 count
keep income downtown metarea gisjoin count
save 13, replace

clear
foreach num of numlist 1(1)13 {
append using `num'
*erase `num'.dta
}

g year=1960
sort metarea
save 1960_income, replace



**** 1970 ****
cd "$data/temp_files"
u 1970, clear
g income=500
drop if c3t001==0
ren c3t001 count
keep income downtown metarea gisjoin count
save 1, replace

u 1970, clear
g income=1500
drop if c3t002==0
ren c3t002 count
keep income downtown metarea gisjoin count
save 2, replace

u 1970, clear
g income=2500
drop if c3t003==0
ren c3t003 count
keep income downtown metarea gisjoin count
save 3, replace

u 1970, clear
g income=3500
drop if c3t004==0
ren c3t004 count
keep income downtown metarea gisjoin count
save 4, replace

u 1970, clear
g income=4500
drop if c3t005==0
ren c3t005 count
keep income downtown metarea gisjoin count
save 5, replace

u 1970, clear
g income=5500
drop if c3t006==0
ren c3t006 count
keep income downtown metarea gisjoin count
save 6, replace

u 1970, clear
g income=6500
drop if c3t007==0
ren c3t007 count
keep income downtown metarea gisjoin count
save 7, replace

u 1970, clear
g income=7500
drop if c3t008==0
ren c3t008 count
keep income downtown metarea gisjoin count
save 8, replace

u 1970, clear
g income=8500
drop if c3t009==0
ren c3t009 count
keep income downtown metarea gisjoin count
save 9, replace

u 1970, clear
g income=9500
drop if c3t010==0
ren c3t010 count
keep income downtown metarea gisjoin count
save 10, replace

u 1970, clear
g income=11000
drop if c3t011==0
ren c3t011 count
keep income downtown metarea gisjoin count
save 11, replace

u 1970, clear
g income=14000
drop if c3t012==0
ren c3t012 count
keep income downtown metarea gisjoin count
save 12, replace

u 1970, clear
g income=20000
drop if c3t013==0
ren c3t013 count
keep income downtown metarea gisjoin count
save 13, replace

u 1970, clear
g income=32500
drop if c3t014==0
ren c3t014 count
keep income downtown metarea gisjoin count
save 14, replace

u 1970, clear
g income=50000
drop if c3t015==0
ren c3t015 count
keep income downtown metarea gisjoin count
save 15, replace


foreach num of numlist 1(1)15 {
append using `num'
*erase `num'.dta
}

g year=1970
sort metarea
replace count=0 if count==-1
save 1970_income, replace


*** 1980 ***
cd "$data/temp_files"
u 1980, clear
g income=1250
drop if did001==0
ren did001 count
keep income downtown metarea gisjoin count
save 1, replace

u 1980, clear 
g income=3750
drop if did002==0
ren did002 count
keep income downtown metarea gisjoin count
save 2, replace

u 1980, clear 
g income=6250
drop if did003==0
ren did003 count
keep income downtown metarea gisjoin count
save 3, replace

u 1980, clear
g income=8750
drop if did004==0
ren did004 count
keep income downtown metarea gisjoin count
save 4, replace

u 1980, clear
g income=11250
drop if did005==0
ren did005 count
keep income downtown metarea gisjoin count
save 5, replace

u 1980, clear
g income=13750
drop if did006==0
ren did006 count
keep income downtown metarea gisjoin count
save 6, replace

u 1980, clear 
g income=16250
drop if did007==0
ren did007 count
keep income downtown metarea gisjoin count
save 7, replace

u 1980, clear
g income=18750
drop if did008==0
ren did008 count
keep income downtown metarea gisjoin count
save 8, replace

u 1980, clear
g income=21250
drop if did009==0
ren did009 count
keep income downtown metarea gisjoin count
save 9, replace

u 1980, clear
g income=23750
drop if did010==0
ren did010 count
keep income downtown metarea gisjoin count
save 10, replace

u 1980, clear
g income=26250
drop if did011==0
ren did011 count
keep income downtown metarea gisjoin count
save 11, replace

u 1980, clear
g income=28750
drop if did012==0
ren did012 count
keep income downtown metarea gisjoin count
save 12, replace

u 1980, clear
g income=32500
drop if did013==0
ren did013 count
keep income downtown metarea gisjoin count
save 13, replace

u 1980, clear
g income=37500
drop if did014==0
ren did014 count
keep income downtown metarea gisjoin count
save 14, replace

u 1980, clear
g income=45000
drop if did015==0
ren did015 count
keep income downtown metarea gisjoin count
save 15, replace

u 1980, clear
g income=62500
drop if did016==0
ren did016 count
keep income downtown metarea gisjoin count
save 16, replace

u 1980, clear
g income=75000
drop if did017==0
ren did017 count
keep income downtown metarea gisjoin count
save 17, replace

foreach num of numlist 1(1)17 {
append using `num'
*erase `num'.dta
}

g year=1980
sort metarea
replace count=0 if count==-1
save 1980_income, replace

*** 1990 ***
cd "$data/temp_files"
u 1990, clear
g income=2500
drop if e4t001==0
ren e4t001 count
keep income downtown metarea gisjoin count
save 1, replace

u 1990, clear
g income=7500
drop if e4t002==0
ren e4t002 count
keep income downtown metarea gisjoin count
save 2, replace

u 1990, clear
g income=11250
drop if e4t003==0
ren e4t003 count
keep income downtown metarea gisjoin count
save 3, replace

u 1990, clear
g income=13750
drop if e4t004==0
ren e4t004 count
keep income downtown metarea gisjoin count
save 4, replace

u 1990, clear
g income=16250
drop if e4t005==0
ren e4t005 count
keep income downtown metarea gisjoin count
save 5, replace

u 1990, clear
g income=18750
drop if e4t006==0
ren e4t006 count
keep income downtown metarea gisjoin count
save 6, replace

u 1990, clear
g income=21250
drop if e4t007==0
ren e4t007 count
keep income downtown metarea gisjoin count
save 7, replace

u 1990, clear
g income=23750
drop if e4t008==0
ren e4t008 count
keep income downtown metarea gisjoin count
save 8, replace

u 1990, clear
g income=26250
drop if e4t009==0
ren e4t009 count
keep income downtown metarea gisjoin count
save 9, replace

u 1990, clear
g income=28750
drop if e4t010==0
ren e4t010 count
keep income downtown metarea gisjoin count
save 10, replace

u 1990, clear
g income=31250
drop if e4t011==0
ren e4t011 count
keep income downtown metarea gisjoin count
save 11, replace

u 1990, clear
g income=33750
drop if e4t012==0
ren e4t012 count
keep income downtown metarea gisjoin count
save 12, replace

u 1990, clear
g income=37250
drop if e4t013==0
ren e4t013 count
keep income downtown metarea gisjoin count
save 13, replace

u 1990, clear
g income=38750
drop if e4t014==0
ren e4t014 count
keep income downtown metarea gisjoin count
save 14, replace

u 1990, clear
g income=41250
drop if e4t015==0
ren e4t015 count
keep income downtown metarea gisjoin count
save 15, replace

u 1990, clear
g income=43750
drop if e4t016==0
ren e4t016 count
keep income downtown metarea gisjoin count
save 16, replace

u 1990, clear
g income=46250
drop if e4t017==0
ren e4t017 count
keep income downtown metarea gisjoin count
save 17, replace

u 1990, clear
g income=48750
drop if e4t018==0
ren e4t018 count
keep income downtown metarea gisjoin count
save 18, replace

u 1990, clear
g income=52500
drop if e4t019==0
ren e4t019 count
keep income downtown metarea gisjoin count
save 19, replace

u 1990, clear
g income=57500
drop if e4t020==0
ren e4t020 count
keep income downtown metarea gisjoin count
save 20, replace

u 1990, clear
g income=62500
drop if e4t021==0
ren e4t021 count
keep income downtown metarea gisjoin count
save 21, replace

u 1990, clear
g income=87500
drop if e4t022==0
ren e4t022 count
keep income downtown metarea gisjoin count
save 22, replace

u 1990, clear
g income=112500
drop if e4t023==0
ren e4t023 count
keep income downtown metarea gisjoin count
save 23, replace

u 1990, clear
g income=137500
drop if e4t024==0
ren e4t024 count
keep income downtown metarea gisjoin count
save 24, replace


u 1990, clear
g income=150000
drop if e4t025==0
ren e4t025 count
keep income downtown metarea gisjoin count
save 25, replace

foreach num of numlist 1(1)25 {
append using `num'
*erase `num'.dta
}

g year=1990
sort metarea
replace count=0 if count==-1
save 1990_income, replace


*** 2000 ***
cd "$data/temp_files"
u 2000, clear
g income=5000
drop if gmx001==0
ren gmx001 count
keep income downtown metarea gisjoin count
save 1, replace

u 2000, clear
g income=12500
drop if gmx002==0
ren gmx002 count
keep income downtown metarea gisjoin count
save 2, replace

u 2000, clear
g income=17500
drop if gmx003==0
ren gmx003 count
keep income downtown metarea gisjoin count
save 3, replace

u 2000, clear
g income=22500
drop if gmx004==0
ren gmx004 count
keep income downtown metarea gisjoin count
save 4, replace

u 2000, clear
g income=27500
drop if gmx005==0
ren gmx005 count
keep income downtown metarea gisjoin count
save 5, replace

u 2000, clear
g income=32500
drop if gmx006==0
ren gmx006 count
keep income downtown metarea gisjoin count
save 6, replace

u 2000, clear
g income=37500
drop if gmx007==0
ren gmx007 count
keep income downtown metarea gisjoin count
save 7, replace

u 2000, clear
g income=42500
drop if gmx008==0
ren gmx008 count
keep income downtown metarea gisjoin count
save 8, replace

u 2000, clear
g income=47500
drop if gmx009==0
ren gmx009 count
keep income downtown metarea gisjoin count
save 9, replace

u 2000, clear
g income=55000
drop if gmx010==0
ren gmx010 count
keep income downtown metarea gisjoin count
save 10, replace

u 2000, clear
g income=67500
drop if gmx011==0
ren gmx011 count
keep income downtown metarea gisjoin count
save 11, replace

u 2000, clear
g income=87500
drop if gmx012==0
ren gmx012 count
keep income downtown metarea gisjoin count
save 12, replace

u 2000, clear
g income=112500
drop if gmx013==0
ren gmx013 count
keep income downtown metarea gisjoin count
save 13, replace

u 2000, clear
g income=137500
drop if gmx014==0
ren gmx014 count
keep income downtown metarea gisjoin count
save 14, replace

u 2000, clear
g income=175000
drop if gmx015==0
ren gmx015 count
keep income downtown metarea gisjoin count
save 15, replace

u 2000, clear
g income=200000
drop if gmx016==0
ren gmx016 count
keep income downtown metarea gisjoin count
save 16, replace


foreach num of numlist 1(1)16 {
append using `num'
*erase `num'.dta
}

g year=2000
sort metarea
replace count=0 if count==-1
save 2000_income, replace


*** 2010 ***
cd "$data/temp_files"
u 2010, clear
g income=5000
drop if mp0e002==0
ren mp0e002 count
keep income downtown metarea gisjoin count
save 2, replace

u 2010, clear
g income=12500
drop if mp0e003==0
ren mp0e003 count
keep income downtown metarea gisjoin count
save 3, replace

u 2010, clear
g income=17500
drop if mp0e004==0
ren mp0e004 count
keep income downtown metarea gisjoin count
save 4, replace

u 2010, clear
g income=22500
drop if mp0e005==0
ren mp0e005 count
keep income downtown metarea gisjoin count
save 5, replace

u 2010, clear
g income=27500
drop if mp0e006==0
ren mp0e006 count
keep income downtown metarea gisjoin count
save 6, replace

u 2010, clear
g income=32500
drop if mp0e007==0
ren mp0e007 count
keep income downtown metarea gisjoin count
save 7, replace

u 2010, clear
g income=37500
drop if mp0e008==0
ren mp0e008 count
keep income downtown metarea gisjoin count
save 8, replace

u 2010, clear
g income=42500
drop if mp0e009==0
ren mp0e009 count
keep income downtown metarea gisjoin count
save 9, replace

u 2010, clear
g income=47500
drop if mp0e010==0
ren mp0e010 count
keep income downtown metarea gisjoin count
save 10, replace

u 2010, clear
g income=55000
drop if mp0e011==0
ren mp0e011 count
keep income downtown metarea gisjoin count
save 11, replace

u 2010, clear
g income=67500
drop if mp0e012==0
ren mp0e012 count
keep income downtown metarea gisjoin count
save 12, replace

u 2010, clear
g income=87500
drop if mp0e013==0
ren mp0e013 count
keep income downtown metarea gisjoin count
save 13, replace

u 2010, clear
g income=112500
drop if mp0e014==0
ren mp0e014 count
keep income downtown metarea gisjoin count
save 14, replace

u 2010, clear
g income=137500
drop if mp0e015==0
ren mp0e015 count
keep income downtown metarea gisjoin count
save 15, replace

u 2010, clear
g income=175000
drop if mp0e016==0
ren mp0e016 count
keep income downtown metarea gisjoin count
save 16, replace

u 2010, clear
g income=200000
drop if mp0e017==0
ren mp0e017 count
keep income downtown metarea gisjoin count
save 17, replace


foreach num of numlist 2(1)17 {
append using `num'
}

g year=2010
sort metarea
replace count=0 if count==-1
save 2010_income, replace

*****
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank<=25
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if rank<=25
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

** income ratio (3 miles to downtown) top 25 MSAs
graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) yscale(range(0.72 0.85)) ylabel(0.7(0.05)0.9)
graph export "$data/graph"\income_ratio_25_3mi.emf, replace


**** Ranking (1-10)
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank>=1 & rank<=10
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if rank>=1 & rank<=10
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) 
graph export "$data/graph"\income_ratio_1_10_3mi.emf, replace

**** Ranking (11-25)
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank>=11 & rank<=25
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if rank>=11 & rank<=25
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) 
graph export "$data/graph"\income_ratio_11_25_3mi.emf, replace



**** Ranking (25-50)
****1950
cd "$data/temp_files"
u 1950, clear
keep if rank>25 & rank<=50
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if  rank>25 & rank<=50
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) 
graph export "$data/graph"\income_ratio_25_50_3mi.emf, replace


****1950
cd "$data/temp_files"
u 1950, clear
keep if rank>50
collapse income=b0f001 [w=b0u001], by(downtown)
g year=1950
save temp_1950, replace

cd "$data/temp_files"
foreach num of numlist 1960(10)2010 {
u `num'_income, clear
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
cd "$data/temp_files"
keep if  rank>50
collapse income [w=count], by(downtown year)
save temp_`num', replace
}
clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'
}
drop if downtown==.
reshape wide income, i(year) j(downtown)
g income_ratio=income1/income0

graph twoway connected income_ratio year, xlabel(1950(10)2010) ytitle(Central city income/suburb household income)  xtitle(Census year) graphregion(color(white)) 
graph export "$data/graph"\income_ratio_50+_3mi.emf, replace


******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
*******************************
*** home value ratio
*********************************

*** Extract from raw data (NHGIS)

cd "$data/nhgis"

import delimited nhgis0004_ds82_1950_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1950_metarea
keep if _merge==3
drop _merge
cd "$data/temp_files"
save 1950, replace

cd "$data/nhgis"
import delimited nhgis0004_ds92_1960_tract.csv,  clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1960_metarea
keep if _merge==3
drop _merge
cd "$data/temp_files"
save 1960, replace

cd "$data/nhgis"
import delimited nhgis0004_ds95_1970_tract.csv, clear
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1970_metarea
keep if _merge==3
drop _merge
cd "$data/temp_files"
save 1970, replace

cd "$data/nhgis"
import delimited nhgis0004_ds104_1980_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1980_metarea
keep if _merge==3
drop _merge
cd "$data/temp_files"
save 1980, replace

cd "$data/nhgis"
import delimited nhgis0004_ds120_1990_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge
cd "$data/temp_files"
save 1990, replace

cd "$data/nhgis"
import delimited nhgis0004_ds151_2000_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract2000_metarea
keep if _merge==3
drop _merge
cd "$data/temp_files"
save 2000, replace

cd "$data/nhgis"
import delimited nhgis0004_ds176_20105_2010_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract2010_metarea
keep if _merge==3
drop _merge
cd "$data/temp_files"
save 2010, replace

***
cd "$data/temp_files"
u 1950, clear

cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1950_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge


ren b05001 rent
ren b09001 hvalue
replace rent=. if rent==0
replace hvalue=. if hvalue==0
collapse (mean) rent (mean) hvalue, by(downtown)
drop if downtown==.
cd "$data/temp_files"
g year=1950
save temp_1950, replace


cd "$data/temp_files"
u 1960, clear

cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1960_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge


# delimit
collapse (sum) b7o001 b7o002 b7o003 b7o004 b7o005 b7o006 b7o007 
b7o008 b7o009 b7o010 b7p001 b7p002 b7p003 b7p004 b7p005 b7p006 
b7p007 b7p008 b7p009 b7p010 b7p011 b7p012 b7p013, by(downtown);
# delimit cr

# delimit
g hvalue=(2500*b7o001+6200*b7o002+8700*b7o003+11200*b7o004+13700*b7o005+16200*b7o006+
18700*b7o007+22450*b7o008+29950*b7o009+35000*b7o010)/(b7o001+b7o002+b7o003+b7o004+b7o005+
b7o006+b7o007+b7o008+b7o009+b7o010);
# delimit cr

# delimit
g rent=(10*b7p001+24.5*b7p002+34.5*b7p003+44.5*b7p004+54.5*b7p005+64.5*b7p006+74.5*b7p007+
84.5*b7p008+94.5*b7p009+109.5*b7p010+129.5*b7p011+174.5*b7p012+200*b7p013)/(b7p001+b7p002+
b7p003+b7p004+b7p005+b7p006+b7p007+b7p008+b7p009+b7p010+b7p011+b7p012+b7p013);
# delimit cr
drop if downtown==.
keep downtown hvalue rent
cd "$data/temp_files"
g year=1960
save temp_1960, replace

cd "$data/temp_files"
u 1970, clear

cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1970_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

# delimit
collapse (sum) cg7001 cg7002 cg7003 cg7004 cg7005 cg7006 cg7007 
cg7008 cg7009 cg7010 cg7011 cha001 cha002 cha003 cha004 cha005 
cha006 cha007 cha008 cha009 cha010 cha011 cha012 cha013 cha014, by(downtown);
# delimit cr

# delimit
g hvalue=(2500*cg7001+6250*cg7002+8750*cg7003+11250*cg7004+13750*cg7005+
16250*cg7006+18750*cg7007+22500*cg7008+30000*cg7009+42500*cg7010+50000*cg7011)/
(cg7001+cg7002+cg7003+cg7004+cg7005+
cg7006+cg7007+cg7008+cg7009+cg7010+cg7011);
# delimit cr

# delimit
g rent=(15*cha001+35*cha002+45*cha003+55*cha004+65*cha005+75*cha006+85*cha007
+95*cha008+110*cha009+130*cha010+175*cha011+225*cha012+275*cha013+300*cha014)/
(cha001+cha002+cha003+cha004+cha005+cha006+cha007
+cha008+cha009+cha010+cha011+cha012+cha013+cha014);
# delimit cr

drop if downtown==.
keep downtown hvalue rent
cd "$data/temp_files"
g year=1970
save temp_1970, replace


cd "$data/temp_files"
u 1980, clear

cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1980_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

# delimit
collapse (sum) c8i001 c8i002 c8i003 c8i004 c8i005 c8i006 c8i007 
c8i008 c8i009 c8i010 c8i011 c8i012 c8i013 c8n001 c8n002 c8n003 
c8n004 c8n005 c8n006 c8n007 c8n008 c8n009 c8n010 c8n011 c8n012 c8n013,
 by(downtown);
# delimit cr

# delimit
g hvalue=(5000*c8i001+12500*c8i002+17500*c8i003+22500*c8i004+27500*c8i005+
32500*c8i006+37500*c8i007+45000*c8i008+65000*c8i009+90000*c8i010+125000*c8i011
+175000*c8i012+200000*c8i013)/
(c8i001+c8i002+c8i003+c8i004+c8i005+c8i006+c8i007+c8i008+c8i009+c8i010+c8i011
+c8i012+c8i013);
# delimit cr

# delimit
g rent=(25*c8n001+75*c8n002+110*c8n003+130*c8n004+145*c8n005+155*c8n006
+165*c8n007+180*c8n008+225*c8n009+275*c8n010+350*c8n011+450*c8n012+500*c8n013)/
(c8n001+c8n002+c8n003+c8n004+c8n005+c8n006
+c8n007+c8n008+c8n009+c8n010+c8n011+c8n012+c8n013);
# delimit cr
drop if downtown==.
keep downtown hvalue rent
cd "$data/temp_files"
g year=1980
save temp_1980, replace

cd "$data/temp_files"
u 1990, clear

cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1990_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

# delimit
collapse (sum) esr001 esr002 esr003 esr004 esr005 esr006 
esr007 esr008 esr009 esr010 esr011 esr012 esr013 esr014 
esr015 esr016 esr017 esr018 esr019 esr020 
es4001 es4002 es4003 es4004 es4005 es4006 es4007 es4008 
es4009 es4010 es4011 es4012 es4013 es4014 es4015 es4016, by(downtown);
# delimit cr

# delimit
g hvalue=(7500*esr001+17500*esr002+22500*esr003+27500*esr004
+32500*esr005+37500*esr006+42500*esr007+47500*esr008
+55000*esr009+67500*esr010+87500*esr011+112500*esr012
+137500*esr013+162500*esr014+187500*esr015+225000*esr016
+275000*esr017+350000*esr018+450000*esr019+500000*esr020)/
(esr001+esr002+esr003+esr004
+esr005+esr006+esr007+esr008
+esr009+esr010+esr011+esr012
+esr013+esr014+esr015+esr016
+esr017+esr018+esr019+esr020);
# delimit cr

# delimit
g rent=(50*es4001+125*es4002+175*es4003+225*es4004+275*es4005
+325*es4006+375*es4007+425*es4008+475*es4009+525*es4010+575*es4011
+625*es4012+675*es4013+725*es4014+875*es4015+1000*es4016)/
(es4001+es4002+es4003+es4004+es4005
+es4006+es4007+es4008+es4009+es4010+es4011
+es4012+es4013+es4014+es4015+es4016);
# delimit cr
drop if downtown==.
keep downtown hvalue rent
cd "$data/temp_files"
g year=1990
save temp_1990, replace


cd "$data/temp_files"
u 2000, clear

cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract2000_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

# delimit
collapse (sum)
gbe001 gbe002 gbe003 gbe004 gbe005 gbe006 gbe007 gbe008 
gbe009 gbe010 gbe011 gbe012 gbe013 gbe014 gbe015 gbe016 
gbe017 gbe018 gbe019 gbe020 gbe021 gb5001 gb5002 
gb5003 gb5004 gb5005 gb5006 gb5007 gb5008 gb5009 gb5010 
gb5011 gb5012 gb5013 gb5014 gb5015 gb5016 gb5017 gb5018 
gb5019 gb5020 gb5021 gb5022 gb5023 gb5024, by(downtown);
# delimit cr

# delimit
g hvalue=(5000*gb5001+12500*gb5002 
+17500*gb5003+22500*gb5004+27500*gb5005+32500*gb5006+37500*gb5007+
45000*gb5008+55000*gb5009+65000*gb5010+75000*gb5011+85000*gb5012+
95000*gb5013+112500*gb5014+137500*gb5015+162500*gb5016+187500*gb5017+
225000*gb5018+275000*gb5019+350000*gb5020+450000*gb5021+625000*gb5022+
875000*gb5023+1000000*gb5024)/
(gb5001+gb5002+gb5003+gb5004+gb5005+gb5006+gb5007+gb5008+gb5009+gb5010+
gb5011+gb5012+gb5013+gb5014+gb5015+gb5016+gb5017+gb5018+
gb5019+gb5020+gb5021+gb5022+gb5023+gb5024);
# delimit cr

# delimit
g rent=(50*gbe001+125*gbe002+175*gbe003+225*gbe004+275*gbe005+325*gbe006+375*gbe007+425*gbe008+
475*gbe009+525*gbe010+575*gbe011+625*gbe012+675*gbe013+725*gbe014+775*gbe015+850*gbe016+
950*gbe017+1125*gbe018+1375*gbe019+1750*gbe020+2000*gbe021)/
(gbe001+gbe002+gbe003+gbe004+gbe005+gbe006+gbe007+gbe008+
gbe009+gbe010+gbe011+gbe012+gbe013+gbe014+gbe015+gbe016+
gbe017+gbe018+gbe019+gbe020+gbe021);
# delimit cr

drop if downtown==.
keep downtown hvalue rent
cd "$data/temp_files"
g year=2000
save temp_2000, replace


cd "$data/temp_files"
u 2010, clear
drop year
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract2010_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

# delimit
collapse (sum)
jsxe003 jsxe004 jsxe005 jsxe006 jsxe007 
jsxe008 jsxe009 jsxe010 jsxe011 jsxe012 jsxe013 jsxe014 
jsxe015 jsxe016 jsxe017 jsxe018 jsxe019 jsxe020 jsxe021 
jsxe022 jsxe023
jtge002 jtge003 jtge004 jtge005 jtge006 
jtge007 jtge008 jtge009 jtge010 jtge011 jtge012 
jtge013 jtge014 jtge015 jtge016 jtge017 jtge018 
jtge019 jtge020 jtge021 jtge022 jtge023 jtge024 
jtge025, by(downtown);
# delimit cr

# delimit
g hvalue=(5000*jtge002+12500*jtge003+17500*jtge004+22500*jtge005+27500*jtge006+
32500*jtge007+37500*jtge008+45000*jtge009+55000*jtge010+65000*jtge011+75000*jtge012+
85000*jtge013+95000*jtge014+112500*jtge015+137500*jtge016+162500*jtge017+187500*jtge018+
225000*jtge019+275000*jtge020+350000*jtge021+450000*jtge022+625000*jtge023+875000*jtge024+
1000000*jtge025)/
(jtge002+jtge003+jtge004+jtge005+jtge006+
jtge007+jtge008+jtge009+jtge010+jtge011+jtge012+
jtge013+jtge014+jtge015+jtge016+jtge017+jtge018+
jtge019+jtge020+jtge021+jtge022+jtge023+jtge024+
jtge025);
# delimit cr

# delimit
g rent=(50*jsxe003+125*jsxe004+175*jsxe005+225*jsxe006+275*jsxe007+
325*jsxe008+375*jsxe009+425*jsxe010+475*jsxe011+525*jsxe012+575*jsxe013+625*jsxe014+
675*jsxe015+725*jsxe016+775*jsxe017+850*jsxe018+950*jsxe019+1125*jsxe020+1375*jsxe021+
1750*jsxe022+2000*jsxe023)/
(jsxe003+jsxe004+jsxe005+jsxe006+jsxe007+
jsxe008+jsxe009+jsxe010+jsxe011+jsxe012+jsxe013+jsxe014+
jsxe015+jsxe016+jsxe017+jsxe018+jsxe019+jsxe020+jsxe021+
jsxe022+jsxe023);
# delimit cr
drop if downtown==.
keep downtown hvalue rent
cd "$data/temp_files"
g year=2010
save temp_2010, replace

clear
foreach num of numlist 1950(10)2010 {
append using temp_`num'

}
reshape wide rent hvalue, i(year) j(downtown)
g rent_ratio=rent1/rent0
g hvalue_ratio=hvalue1/hvalue0


*** Main Figure (Figure 1b)
cd "$data/graph"
*****Graphs - home value ratio (3 miles within downtown pin vs outside)
graph twoway connected hvalue_ratio year, xlabel(1950(10)2010) ytitle(Central city home value/suburb home value) xtitle(Census year) graphregion(color(white))
graph export hvalue_ratio_25.emf, replace


***** Population (top 25 MSA)
cd "$data/nhgis"
import delimited nhgis0039_ds82_1950_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1950_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1950_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

g total=bz8001
keep gisjoin metarea downtown total
g year=1950
cd "$data/temp_files"
save 1950, replace

***** Population (top 25 MSA)
cd "$data/nhgis"
import delimited nhgis0039_ds92_1960_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1960_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1960_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

g total=ca4001
keep gisjoin metarea downtown total
g year=1960
cd "$data/temp_files"
save 1960, replace

***** Population (top 25 MSA)
cd "$data/nhgis"
import delimited nhgis0039_ds97_1970_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1970_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1970_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

g total=cy7001
keep gisjoin metarea downtown total
g year=1970
cd "$data/temp_files"
save 1970, replace

***** Population (top 25 MSA)
cd "$data/nhgis"
import delimited nhgis0039_ds104_1980_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1980_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1980_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

g total=c7l001
keep gisjoin metarea downtown total
g year=1980
cd "$data/temp_files"
save 1980, replace

***** Population (top 25 MSA)
cd "$data/nhgis"
import delimited nhgis0039_ds120_1990_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract1990_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

g total=et1001
keep gisjoin metarea downtown total
g year=1990
cd "$data/temp_files"
save 1990, replace

cd "$data/nhgis"
import delimited nhgis0039_ds146_2000_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract2000_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract2000_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

g total=fl5001
keep gisjoin metarea downtown total
g year=2000
cd "$data/temp_files"
save 2000, replace

cd "$data/nhgis"
import delimited nhgis0039_ds184_20115_2011_tract.csv, clear 
duplicates tag gisjoin, g(tag)
drop if tag>0
drop tag
sort gisjoin
drop county
cd "$data/geographic"
merge 1:1 gisjoin using tract2010_metarea
keep if _merge==3
drop _merge
cd "$data/geographic"
merge m:1 metarea using 1990_rank, force
drop _merge
keep if rank<=25

cd "$data/geographic"
merge m:1 gisjoin using tract2010_downtown5mi
g downtown=0
replace downtown=1 if _merge==3
drop if _merge==2
drop _merge

g total=mnte001
keep gisjoin metarea downtown total
g year=2010
cd "$data/temp_files"
save 2010, replace


cd "$data/temp_files"
clear
append using 1950
append using 1960
append using 1970
append using 1980
append using 1990
append using 2000
append using 2010

collapse (sum) total, by(year downtown)
sort year downtown
by year: g ratio=total/(total+total[_n-1])

# delimit
graph twoway (connected ratio year if downtown==1), 
xlabel(1950(10)2010) ylabel(0(0.1)0.4) ytitle(Central city population share)  xtitle(year) graphregion(color(white)) 
xscale(range(1950 2010)) yscale(range(0 0.2));
# delimit cr
graph export "$data/graph/pop_share25.emf", replace
