clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


cd $data\temp_files
u tract_impute_share, clear

cd $data\temp_files
merge m:1 occ2010 metarea using wage_metarea
keep if _merge==3
drop _merge
drop count*

cd $data\temp_files
merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge

cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

g impute2010_high=impute_share2010*count2010*high_skill
g impute2010_low=impute_share2010*count2010*(1-high_skill)

g impute2000_high=impute_share2000*count2000*high_skill
g impute2000_low=impute_share2000*count2000*(1-high_skill)

g impute1990_high=impute_share1990*count1990*high_skill
g impute1990_low=impute_share1990*count1990*(1-high_skill)

collapse (sum) impute2010_high impute2010_low impute2000_high impute2000_low impute1990_high impute1990_low, by(metarea gisjoin)
cd $data\temp_files
save skill_pop, replace


cd $data\temp_files
u skill_pop, clear

g dratio=ln( impute2010_high/ impute2010_low)-ln( impute1990_high/ impute1990_low)
keep gisjoin dratio
save skill_ratio_occupation, replace