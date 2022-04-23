clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


****skill ratio against distance
cd $data\temp_files

u skill_pop, clear
g ratio1990= impute1990_high/ impute1990_low
g ratio2000= impute2000_high/ impute2000_low
g ratio2010= impute2010_high/ impute2010_low

cd $data\geographic\
merge 1:1 gisjoin using tract1990_downtown_200mi
keep if _merge==3
drop _merge

merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

replace distance=distance/1609
g dratio=ln( ratio2010)-ln(ratio1990)
g dratio2000=ln(ratio2000) - ln(ratio1990)
g dratio2010=ln(ratio2010) - ln(ratio2000)
cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge

cd $data\graph\
# delimit 
graph twoway (lpoly dratio distance) (lpoly dratio2000 distance, lpattern(dash)) (lpoly dratio2010 distance,lpattern(shortdash)) if distance<=30 & rank<=25
, ytitle(Change in log skill ratio) xtitle(distance to downtown) legend(lab(1 "1990 - 2010") lab(2 "1990 - 2000") lab(3 "2000 - 2010"))
graphregion(color(white)) yscale(range(0 0.6)) ylabel(0(0.2)0.6);
# delimit cr
graph export dratio_distance_25.emf, replace



**** Figure 4


*** By income 1980s
cd $data\temp_files

u skill_pop, clear
g ratio1990= impute1990_high/ impute1990_low
g ratio2010= impute2010_high/ impute2010_low

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown_200mi
keep if _merge==3
drop _merge

merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

replace distance=distance/1609
g dratio=ln( ratio2010)-ln(ratio1990)

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge
drop if gisjoin==""

ren gisjoin gisjoin1
merge 1:1 gisjoin1 using $data\geographic\tract1990_tract1980_nearest.dta
keep if _merge==3
drop _merge

ren gisjoin2 gisjoin

cd $data\temp_files
merge m:1 gisjoin using 1980_income_rank

g pop1990_high=int(impute1990_high)
g pop2010_high=int(impute2010_high)
g downtown=0
replace downtown=1 if distance<=5
g dpop_high= pop2010_high- pop1990_high
keep if rank<=25
collapse (sum) dpop_high, by(rank_income downtown)

sort downtown
drop if rank_income==.
by downtown: egen total=total(dpop_high)
g dpop_high_share=dpop_high/total
sort downtown rank_income


lab define rank 1 "1st quintile" 2 "2nd quintile" 3 "3rd quintile" 4 "4th quintile" 5 "5th quintile"
lab value rank_income rank
graph bar dpop_high_share if downtown==1, over(rank_income) b1title(Income rank in 1980) ytitle(Fraction of additional high-skilled residents) graphregion(color(white)) yscale(range(0 0.7)) ylabel(0(0.2)0.6)
cd $data\graph
graph export new_skilled_by_1980_income.png, replace


*** By income 2000
cd $data\temp_files

u skill_pop, clear
g ratio1990= impute1990_high/ impute1990_low
g ratio2010= impute2010_high/ impute2010_low

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown_200mi
keep if _merge==3
drop _merge

merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

replace distance=distance/1609
g dratio=ln( ratio2010)-ln(ratio1990)

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge
drop if gisjoin==""

ren gisjoin gisjoin1
merge 1:1 gisjoin1 using $data\geographic\tract1990_tract2000_nearest.dta
keep if _merge==3
drop _merge

ren gisjoin2 gisjoin

cd $data\temp_files
merge m:1 gisjoin using 2000_income_rank

g pop1990_high=int(impute1990_high)
g pop2010_high=int(impute2010_high)
g downtown=0
replace downtown=1 if distance<=5
g dpop_high= pop2010_high- pop1990_high
keep if rank<=25
collapse (sum) dpop_high, by(rank_income downtown)

sort downtown
drop if rank_income==.
by downtown: egen total=total(dpop_high)
g dpop_high_share=dpop_high/total
sort downtown rank_income


lab define rank 1 "1st quintile" 2 "2nd quintile" 3 "3rd quintile" 4 "4th quintile" 5 "5th quintile"
lab value rank_income rank
graph bar dpop_high_share if downtown==1, over(rank_income) b1title(Income rank in 2000) ytitle(Fraction of additional high-skilled residents) graphregion(color(white))  yscale(range(0 0.7)) ylabel(0(0.2)0.6)
cd $data\graph
graph export new_skilled_by_2000_income.png, replace