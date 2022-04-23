clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


cd $data\temp_files
u tract_impute_share, clear

cd $data\temp_files
merge m:1 occ2010 using inc_occ_1990_2000_2010
keep if _merge==3
drop _merge
drop count* wage_real1990 wage_real2000 wage_real2010

cd $data\temp_files
merge m:1 occ2010 metarea using wage_metarea
keep if _merge==3
drop _merge

g inc1990=impute_share1990*inc_mean1990*count1990
g inc2010=impute_share2010*inc_mean2010*count2010

collapse (sum) inc1990 inc2010, by(gisjoin metarea)
g ddemand=ln(inc2010)-ln(inc1990)
keep gisjoin ddemand
cd $data\temp_files
save ddemand, replace