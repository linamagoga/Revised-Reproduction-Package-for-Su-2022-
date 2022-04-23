clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

****************

*** create counterfatual location share in 2010

cd $data\temp_files
u tract_impute_share, clear


cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term1990
keep if _merge==3
drop _merge

ren counterfactual_share value_term1990
cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2010
keep if _merge==3
drop _merge
ren counterfactual_share value_term2010

replace value_term1990=ln(value_term1990)
replace value_term2010=ln(value_term2010)

g sim2010=exp(ln(impute_share1990)-value_term1990+value_term2010)
sort occ2010 metarea gisjoin

by occ2010 metarea: egen total_sim2010=sum(sim2010)

g counterfactual_share=sim2010/total_sim2010
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

cd $data\temp_files

merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge

ren count1990 count1990_2
ren count2000 count2000_2
ren count2010 count2010_2

cd $data\temp_files
merge m:1 occ2010 using inc_occ_1990_2000_2010
keep if _merge==3
drop _merge
drop count1990 count2000 count2010 wage_real1990 wage_real2000 wage_real2010

ren count1990_2 count1990
ren count2000_2 count2000
ren count2010_2 count2010

g impute2010_high_cf=counterfactual_share*count1990*high_skill
g impute2010_low_cf=counterfactual_share*count1990*(1-high_skill)

g impute2010_high=impute_share2010*count2010*high_skill
g impute2010_low=impute_share2010*count2010*(1-high_skill)

g impute1990_high=impute_share1990*count1990*high_skill
g impute1990_low=impute_share1990*count1990*(1-high_skill)

g inc1990=impute_share1990*inc_mean1990*count1990
g inc2010_cf=counterfactual_share*inc_mean1990*count1990

collapse (sum) impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute1990_high impute1990_low inc1990 inc2010_cf, by(metarea gisjoin)


cd $data\temp_files
merge m:1 gisjoin using room_density1980_1mi
drop if _merge==2
drop _merge

replace room_density_1mi_3mi=(room_density_1mi_3mi-8127.921)/14493.66

save impute, replace

cd $data\temp_files
u impute, clear

g predict2010_high_cf=impute2010_high_cf
g predict2010_low_cf=impute2010_low_cf

save temp, replace


**************************************
**** Three Mile evaluation
cd $data\temp_files
u temp, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown3mi
drop if _merge==2
g downtown=0
replace downtown=1 if _merge==3
drop _merge
collapse (sum) predict2010_high_cf predict2010_low_cf impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute1990_high impute1990_low , by( metarea downtown)

g ratio2010_cf=predict2010_high_cf/(predict2010_low_cf)
g ratio2010=impute2010_high/(impute2010_low)
g ratio1990=impute1990_high/(impute1990_low)

g dln_ratio_cf=ln( ratio2010_cf)-ln(ratio1990)
g dln_ratio=ln( ratio2010)-ln(ratio1990)

cd $data\temp_files
merge m:1 metarea using population1990_metarea
keep if _merge==3
drop _merge

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge

sort metarea downtown
by metarea: g dln_ratio_ratio_cf=dln_ratio_cf-dln_ratio_cf[_n-1]
by metarea: g dln_ratio_ratio=dln_ratio-dln_ratio[_n-1]

* Table A2

* Column 1
reg dln_ratio_ratio dln_ratio_ratio_cf  [w=population] if downtown==1, r
********************************
********************************
********************************
********************************
********************************
********************************
********************************

********************************
********************************
********************************
********************************
********************************
********************************
********************************

**** Actual 1990-2000 on predicted 1990-2010


cd $data\temp_files
u tract_impute_share, clear


cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term1990
keep if _merge==3
drop _merge

ren counterfactual_share value_term1990
cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2010
keep if _merge==3
drop _merge
ren counterfactual_share value_term2010

replace value_term1990=ln(value_term1990)
replace value_term2010=ln(value_term2010)

g sim2010=exp(ln(impute_share1990)-value_term1990+value_term2010)
sort occ2010 metarea gisjoin

by occ2010 metarea: egen total_sim2010=sum(sim2010)

g counterfactual_share=sim2010/total_sim2010
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

cd $data\temp_files

merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge

ren count1990 count1990_2
ren count2000 count2000_2
ren count2010 count2010_2

cd $data\temp_files
merge m:1 occ2010 using inc_occ_1990_2000_2010
keep if _merge==3
drop _merge
drop count1990 count2000 count2010 wage_real1990 wage_real2000 wage_real2010

ren count1990_2 count1990
ren count2000_2 count2000
ren count2010_2 count2010

g impute2010_high_cf=counterfactual_share*count1990*high_skill
g impute2010_low_cf=counterfactual_share*count1990*(1-high_skill)

g impute2010_high=impute_share2000*count2000*high_skill
g impute2010_low=impute_share2000*count2000*(1-high_skill)

g impute1990_high=impute_share1990*count1990*high_skill
g impute1990_low=impute_share1990*count1990*(1-high_skill)

g inc1990=impute_share1990*inc_mean1990*count1990
g inc2010_cf=counterfactual_share*inc_mean1990*count1990

collapse (sum) impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute1990_high impute1990_low inc1990 inc2010_cf, by(metarea gisjoin)


cd $data\temp_files
merge m:1 gisjoin using room_density1980_1mi
drop if _merge==2
drop _merge

replace room_density_1mi_3mi=(room_density_1mi_3mi-8127.921)/14493.66

save impute, replace

cd $data\temp_files
u impute, clear

g predict2010_high_cf=impute2010_high_cf
g predict2010_low_cf=impute2010_low_cf

save temp, replace


**************************************
**** Three Mile evaluation
cd $data\temp_files
u temp, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown3mi
drop if _merge==2
g downtown=0
replace downtown=1 if _merge==3
drop _merge
collapse (sum) predict2010_high_cf predict2010_low_cf impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute1990_high impute1990_low , by( metarea downtown)

g ratio2010_cf=predict2010_high_cf/(predict2010_low_cf)
g ratio2010=impute2010_high/(impute2010_low)
g ratio1990=impute1990_high/(impute1990_low)

g dln_ratio_cf=ln( ratio2010_cf)-ln(ratio1990)
g dln_ratio=ln( ratio2010)-ln(ratio1990)

cd $data\temp_files
merge m:1 metarea using population1990_metarea
keep if _merge==3
drop _merge

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge

sort metarea downtown
by metarea: g dln_ratio_ratio_cf=dln_ratio_cf-dln_ratio_cf[_n-1]
by metarea: g dln_ratio_ratio=dln_ratio-dln_ratio[_n-1]


* Table A2

* Column 2

reg dln_ratio_ratio dln_ratio_ratio_cf  [w=population] if downtown==1, r


********************************
********************************
********************************
*******************************

**** Actual 2000-2010 on predicted 1990-2010

cd $data\temp_files
u tract_impute_share, clear


cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term1990
keep if _merge==3
drop _merge

ren counterfactual_share value_term1990
cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2010
keep if _merge==3
drop _merge
ren counterfactual_share value_term2010

replace value_term1990=ln(value_term1990)
replace value_term2010=ln(value_term2010)

g sim2010=exp(ln(impute_share1990)-value_term1990+value_term2010)
sort occ2010 metarea gisjoin

by occ2010 metarea: egen total_sim2010=sum(sim2010)

g counterfactual_share=sim2010/total_sim2010
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

cd $data\temp_files

merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge

ren count1990 count1990_2
ren count2000 count2000_2
ren count2010 count2010_2

cd $data\temp_files
merge m:1 occ2010 using inc_occ_1990_2000_2010
keep if _merge==3
drop _merge
drop count1990 count2000 count2010 wage_real1990 wage_real2000 wage_real2010

ren count1990_2 count1990
ren count2000_2 count2000
ren count2010_2 count2010

g impute2010_high_cf=counterfactual_share*count1990*high_skill
g impute2010_low_cf=counterfactual_share*count1990*(1-high_skill)

g impute2010_high=impute_share2010*count2010*high_skill
g impute2010_low=impute_share2010*count2010*(1-high_skill)

g impute2000_high=impute_share2000*count2000*high_skill
g impute2000_low=impute_share2000*count2000*(1-high_skill)

g impute1990_high=impute_share1990*count1990*high_skill
g impute1990_low=impute_share1990*count1990*(1-high_skill)

g inc1990=impute_share1990*inc_mean1990*count1990
g inc2010_cf=counterfactual_share*inc_mean1990*count1990

collapse (sum) impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute2000_high impute2000_low impute1990_high impute1990_low inc1990 inc2010_cf, by(metarea gisjoin)


cd $data\temp_files
merge m:1 gisjoin using room_density1980_1mi
drop if _merge==2
drop _merge

replace room_density_1mi_3mi=(room_density_1mi_3mi-8127.921)/14493.66

save impute, replace

cd $data\temp_files
u impute, clear

g predict2010_high_cf=impute2010_high_cf
g predict2010_low_cf=impute2010_low_cf

save temp, replace


**************************************
**** Three Mile evaluation
cd $data\temp_files
u temp, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown3mi
drop if _merge==2
g downtown=0
replace downtown=1 if _merge==3
drop _merge
collapse (sum) predict2010_high_cf predict2010_low_cf impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute2000_high impute2000_low impute1990_high impute1990_low , by( metarea downtown)

g ratio2010_cf=predict2010_high_cf/(predict2010_low_cf)
g ratio2010=impute2010_high/(impute2010_low)
g ratio2000=impute2000_high/(impute2000_low)
g ratio1990=impute1990_high/(impute1990_low)

g dln_ratio_cf=ln( ratio2010_cf)-ln(ratio1990)
g dln_ratio=ln( ratio2010)-ln(ratio2000)

cd $data\temp_files
merge m:1 metarea using population1990_metarea
keep if _merge==3
drop _merge

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge

sort metarea downtown
by metarea: g dln_ratio_ratio_cf=dln_ratio_cf-dln_ratio_cf[_n-1]
by metarea: g dln_ratio_ratio=dln_ratio-dln_ratio[_n-1]

* Table A2

* Column 4
reg dln_ratio_ratio dln_ratio_ratio_cf  [w=population] if downtown==1, r


*******************************
*******************************
*******************************


**** Actual 1990-2000 on predicted 1990-2000


cd $data\temp_files
u tract_impute_share, clear


cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term1990
keep if _merge==3
drop _merge

ren counterfactual_share value_term1990
cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2000
keep if _merge==3
drop _merge
ren counterfactual_share value_term2000

replace value_term1990=ln(value_term1990)
replace value_term2000=ln(value_term2000)

g sim2000=exp(ln(impute_share1990)-value_term1990+value_term2000)
sort occ2010 metarea gisjoin

by occ2010 metarea: egen total_sim2000=sum(sim2000)

g counterfactual_share=sim2000/total_sim2000
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

cd $data\temp_files

merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge

ren count1990 count1990_2
ren count2000 count2000_2
ren count2010 count2010_2

cd $data\temp_files
merge m:1 occ2010 using inc_occ_1990_2000_2010
keep if _merge==3
drop _merge
drop count1990 count2000 count2010 wage_real1990 wage_real2000 wage_real2010

ren count1990_2 count1990
ren count2000_2 count2000
ren count2010_2 count2010

g impute2000_high_cf=counterfactual_share*count1990*high_skill
g impute2000_low_cf=counterfactual_share*count1990*(1-high_skill)

g impute2010_high=impute_share2010*count2010*high_skill
g impute2010_low=impute_share2010*count2010*(1-high_skill)

g impute2000_high=impute_share2000*count2000*high_skill
g impute2000_low=impute_share2000*count2000*(1-high_skill)

g impute1990_high=impute_share1990*count1990*high_skill
g impute1990_low=impute_share1990*count1990*(1-high_skill)

g inc1990=impute_share1990*inc_mean1990*count1990
g inc2010_cf=counterfactual_share*inc_mean1990*count1990

collapse (sum) impute2000_high_cf impute2000_low_cf impute2000_high impute2000_low impute1990_high impute1990_low inc1990 inc2010_cf, by(metarea gisjoin)


cd $data\temp_files
merge m:1 gisjoin using room_density1980_1mi
drop if _merge==2
drop _merge

replace room_density_1mi_3mi=(room_density_1mi_3mi-8127.921)/14493.66

save impute, replace

cd $data\temp_files
u impute, clear

g predict2000_high_cf=impute2000_high_cf
g predict2000_low_cf=impute2000_low_cf

save temp, replace


**************************************
**** Three Mile evaluation
cd $data\temp_files
u temp, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown3mi
drop if _merge==2
g downtown=0
replace downtown=1 if _merge==3
drop _merge
collapse (sum) predict2000_high_cf predict2000_low_cf impute2000_high_cf impute2000_low_cf impute2000_high impute2000_low impute1990_high impute1990_low , by( metarea downtown)

g ratio2000_cf=predict2000_high_cf/(predict2000_low_cf)
g ratio2000=impute2000_high/(impute2000_low)
g ratio1990=impute1990_high/(impute1990_low)

g dln_ratio_cf=ln( ratio2000_cf)-ln(ratio1990)
g dln_ratio=ln( ratio2000)-ln(ratio1990)

cd $data\temp_files
merge m:1 metarea using population1990_metarea
keep if _merge==3
drop _merge

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge

sort metarea downtown
by metarea: g dln_ratio_ratio_cf=dln_ratio_cf-dln_ratio_cf[_n-1]
by metarea: g dln_ratio_ratio=dln_ratio-dln_ratio[_n-1]

* Table A2

* Column 3
reg dln_ratio_ratio dln_ratio_ratio_cf  [w=population] if downtown==1, r

***************************************
***************************************
***************************************


**** Actual 2000 - 2010 on predicted 2000 - 2010 


cd $data\temp_files
u tract_impute_share, clear


cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2000
keep if _merge==3
drop _merge

ren counterfactual_share value_term2000
cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2010
keep if _merge==3
drop _merge
ren counterfactual_share value_term2010

replace value_term2000=ln(value_term2000)
replace value_term2010=ln(value_term2010)

g sim2010=exp(ln(impute_share2000)-value_term2000+value_term2010)
sort occ2010 metarea gisjoin

by occ2010 metarea: egen total_sim2010=sum(sim2010)

g counterfactual_share=sim2010/total_sim2010
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

cd $data\temp_files

merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge

ren count1990 count1990_2
ren count2000 count2000_2
ren count2010 count2010_2

cd $data\temp_files
merge m:1 occ2010 using inc_occ_1990_2000_2010
keep if _merge==3
drop _merge
drop count1990 count2000 count2010 wage_real1990 wage_real2000 wage_real2010

ren count1990_2 count1990
ren count2000_2 count2000
ren count2010_2 count2010

g impute2010_high_cf=counterfactual_share*count2000*high_skill
g impute2010_low_cf=counterfactual_share*count2000*(1-high_skill)

g impute2010_high=impute_share2010*count2010*high_skill
g impute2010_low=impute_share2010*count2010*(1-high_skill)

g impute2000_high=impute_share2000*count2000*high_skill
g impute2000_low=impute_share2000*count2000*(1-high_skill)

g impute1990_high=impute_share1990*count1990*high_skill
g impute1990_low=impute_share1990*count1990*(1-high_skill)

g inc1990=impute_share1990*inc_mean1990*count1990
g inc2010_cf=counterfactual_share*inc_mean1990*count1990

collapse (sum) impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute2000_high impute2000_low inc1990 inc2010_cf, by(metarea gisjoin)


cd $data\temp_files
merge m:1 gisjoin using room_density1980_1mi
drop if _merge==2
drop _merge

replace room_density_1mi_3mi=(room_density_1mi_3mi-8127.921)/14493.66

save impute, replace

cd $data\temp_files
u impute, clear

g predict2010_high_cf=impute2010_high_cf
g predict2010_low_cf=impute2010_low_cf

save temp, replace


**************************************
**** Three Mile evaluation
cd $data\temp_files
u temp, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown3mi
drop if _merge==2
g downtown=0
replace downtown=1 if _merge==3
drop _merge
collapse (sum) predict2010_high_cf predict2010_low_cf impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute2000_high impute2000_low , by( metarea downtown)

g ratio2010_cf=predict2010_high_cf/(predict2010_low_cf)
g ratio2010=impute2010_high/(impute2010_low)
g ratio2000=impute2000_high/(impute2000_low)

g dln_ratio_cf=ln( ratio2010_cf)-ln(ratio2000)
g dln_ratio=ln( ratio2010)-ln(ratio2000)

cd $data\temp_files
merge m:1 metarea using population1990_metarea
keep if _merge==3
drop _merge

cd $data\geographic
merge m:1 metarea using 1990_rank
drop _merge

sort metarea downtown
by metarea: g dln_ratio_ratio_cf=dln_ratio_cf-dln_ratio_cf[_n-1]
by metarea: g dln_ratio_ratio=dln_ratio-dln_ratio[_n-1]

* Table A2

* Column 5

reg dln_ratio_ratio dln_ratio_ratio_cf  [w=population] if downtown==1, r