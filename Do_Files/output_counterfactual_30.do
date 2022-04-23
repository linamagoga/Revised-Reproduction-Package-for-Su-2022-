clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


*** create counterfatual location share in 2010

cd $data\temp_files
u tract_impute_share, clear


cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term1990_high30
keep if _merge==3
drop _merge

ren counterfactual_share value_term1990
cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2010_high30
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

merge m:1 occ2010 using high_skill_30
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

** Table A7

* Column 1 (3 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=25
* Column 4 (3 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=50

**************************************
**** Five Mile evaluation
cd $data\temp_files
u temp, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown5mi
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

** Table A7

* Column 1 (5 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=25
* Column 4 (5 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=50
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
********************************

*** counterfactual when skill ratio can change and rent can change, too. 
cd $data\temp_files
u impute, clear

g dln_sim_high_total  = ln(impute2010_high_cf)- ln(impute1990_high)
g dln_sim_low_total =ln(impute2010_low_cf)-ln(impute1990_low)

g drent_predict=0.099514*(ln(inc2010_cf)-ln(inc1990)) + 0.01814*room_density_1mi_3mi

g ratio1990=impute1990_high/impute1990_low
g ratio2010=impute2010_high/impute2010_low
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

g dln_ratio=dln_sim_high_total -dln_sim_low_total

reg dratio i.metarea  dln_ratio [w=population]

predict dln_ratio_cf, xb
drop dln_ratio

reg drent i.metarea drent_predict  [w=population]

predict drent_cf, xb
drop drent


keep gisjoin dln_ratio_cf drent_cf
cd $data\temp_files
save counterfactual_I_pre_merge, replace

cd $data\temp_files
u data, clear

cd $data\temp_files
merge m:1 gisjoin using counterfactual_I_pre_merge
keep if _merge==3
drop _merge

cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term1990_high30
keep if _merge==3
drop _merge

ren counterfactual_share value_term1990
cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2010_high30
keep if _merge==3
drop _merge
ren counterfactual_share value_term2010

replace value_term1990=ln(value_term1990)
replace value_term2010=ln(value_term2010)


g sim2010=exp(ln(impute_share1990)-value_term1990 + value_term2010 + 0.34529*dln_ratio_cf*(1-high_skill) + 1.6172921*dln_ratio_cf*high_skill  -0.43598*drent_cf*(1-high_skill) - 0.5732421*drent_cf*high_skill)
sort occ2010 metarea gisjoin

by occ2010 metarea: egen total_sim2010=sum(sim2010)

g counterfactual_share=sim2010/total_sim2010

drop count 
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge


g counterfactual=count1990*counterfactual_share

cd $data\temp_files

merge m:1 occ2010 using college_share
keep if _merge==3
drop _merge


g impute2010_high_cf=counterfactual*high_skill
g impute2010_low_cf=counterfactual*(1-high_skill)

g impute2010_high=impute_share2010*count2010*high_skill
g impute2010_low=impute_share2010*count2010*(1-high_skill)

g impute1990_high=impute_share1990*count1990*high_skill
g impute1990_low=impute_share1990*count1990*(1-high_skill)

collapse (sum) impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute1990_high impute1990_low, by(metarea gisjoin)

*************************
cd $data\temp_files

g predict2010_high_cf=impute2010_high_cf
g predict2010_low_cf=impute2010_low_cf

save temp, replace



*****************************************
**** Three mile evaluation
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

** Table A7
* column 2 (3 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=25

* column 5 (3 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=50


*****************************************
**** Five mile evaluation
cd $data\temp_files
u temp, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown5mi
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


** Table A7
* column 2 (5 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=25

* column 5 (5 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=50
********************************
********************************
********************************
********************************
********************************
********************************
********************************
**********************

*** counterfactual when skill ratio can change and rent does not change. 
cd $data\temp_files
u impute, clear

g dln_sim_high_total  = ln(impute2010_high_cf)- ln(impute1990_high)
g dln_sim_low_total =ln(impute2010_low_cf)-ln(impute1990_low)

g drent_predict=0.099514*(ln(inc2010_cf)-ln(inc1990)) + 0.01814*room_density_1mi_3mi


g ratio1990=impute1990_high/impute1990_low
g ratio2010=impute2010_high/impute2010_low
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

g dln_ratio=dln_sim_high_total -dln_sim_low_total

reg dratio i.metarea  dln_ratio [w=population]

predict dln_ratio_cf, xb
drop dln_ratio

reg drent i.metarea drent_predict  [w=population]

predict drent_cf, xb
drop drent


keep gisjoin dln_ratio_cf drent_cf
cd $data\temp_files
save counterfactual_I_pre_merge, replace

cd $data\temp_files
u data, clear

cd $data\temp_files
merge m:1 gisjoin using counterfactual_I_pre_merge
keep if _merge==3
drop _merge

cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term1990_high30
keep if _merge==3
drop _merge

ren counterfactual_share value_term1990
cd $data\temp_files\counterfactual
merge 1:1 occ2010 gisjoin using value_term2010_high30
keep if _merge==3
drop _merge
ren counterfactual_share value_term2010

replace value_term1990=ln(value_term1990)
replace value_term2010=ln(value_term2010)


g sim2010=exp(ln(impute_share1990)-value_term1990 + value_term2010 + 0.34529*dln_ratio_cf*(1-high_skill) + 1.6172921*dln_ratio_cf*high_skill )
sort occ2010 metarea gisjoin

by occ2010 metarea: egen total_sim2010=sum(sim2010)

g counterfactual_share=sim2010/total_sim2010

drop count 
cd $data\temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge


g counterfactual=count1990*counterfactual_share

cd $data\temp_files

merge m:1 occ2010 using college_share
keep if _merge==3
drop _merge


g impute2010_high_cf=counterfactual*high_skill
g impute2010_low_cf=counterfactual*(1-high_skill)

g impute2010_high=impute_share2010*count2010*high_skill
g impute2010_low=impute_share2010*count2010*(1-high_skill)

g impute1990_high=impute_share1990*count1990*high_skill
g impute1990_low=impute_share1990*count1990*(1-high_skill)

collapse (sum) impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute1990_high impute1990_low, by(metarea gisjoin)

*************************
cd $data\temp_files

g predict2010_high_cf=impute2010_high_cf
g predict2010_low_cf=impute2010_low_cf

** counterfactual ratio and actual ratio (by changing value of time and amenity predicted by the value of time shock and rent)
save temp, replace


*****************

*****************************************************
*** Three miles evaluation
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


** Table A7 

* Column 3 (3 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=25

* Column 6 (3 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=50


*****************************************************
*** Five miles evaluation
cd $data\temp_files
u temp, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown5mi
drop if _merge==2
g downtown=0
replace downtown=1 if _merge==3
drop _merge
collapse (sum) predict2010_high_cf predict2010_low_cf impute2010_high_cf impute2010_low_cf impute2010_high impute2010_low impute1990_high impute1990_low , by( metarea downtown)

g ratio2010_cf=predict2010_high_cf/(predict2010_low_cf)
g ratio2010=impute2010_high/(impute2010_low)
g ratio1990=impute1990_high/(impute1990_low)

g dln_ratio_cf=ln( ratio2010_cf)-ln(ratio1990)
g dln_ratio=ln(ratio2010)-ln(ratio1990)


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

** Table A7 

* Column 3 (5 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=25

* Column 6 (5 miles) Actual: mean of dln_ratio_ratio; Model-predicted: mean of dln_ratio_ratio_cf; %: mean of dln_ratio_ratio_cf/mean of dln_ratio_ratio
sum dln_ratio_ratio* [w=population] if downtown==1 & rank<=50
