clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

cd $data\ipums_micro

u 1990_2000_2010_temp, clear

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
keep if year==1990 | year==2010


*drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork==0

g greaterthan50=0
replace greaterthan50=1 if uhrswork>=50

collapse greaterthan50 [w=perwt], by(occ2010 year)

by occ2010: g dg_occ=greaterthan50-greaterthan50[_n-1]
keep if year==2010

drop year

cd $data\temp_files

save occ2010_dg, replace


****************************

cd $data\ipums_micro

u 1990_2000_2010_temp, clear

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
*keep if year==1990 | year==2010


*drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork==0

g greaterthan50=0
replace greaterthan50=1 if uhrswork>=50

cd $data\temp_files
merge m:1 occ2010 using val_40_60_total_1990_2000_2010
keep if _merge==3
drop _merge

g college=0
replace college=1 if educ>=10

g g1990= greaterthan50 if year==1990
g g2010=greaterthan50 if year==2010

g g1990_college= greaterthan50 if year==1990 & college==1
g g2010_college=greaterthan50 if year==2010 & college==1

g g1990_nocollege= greaterthan50 if year==1990 & college==0
g g2010_nocollege=greaterthan50 if year==2010 & college==0

g val_1990_college= val_1990 if year==1990 & college==1
g val_2010_college=val_2010 if year==2010 & college==1

g val_1990_nocollege= val_1990 if year==1990 & college==0
g val_2010_nocollege=val_2010 if year==2010 & college==0

merge m:1 occ2010 using occ2010_dg

collapse g1990* g2010* val_1990* val_2010* dg_occ [w=perwt], by(metarea)

cd $data\temp_files

save appendix_eval_reduced_form, replace


************************************************

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

cd $data\temp_files
merge m:1 metarea using appendix_eval_reduced_form
keep if _merge==3
drop _merge

g dg= g2010- g1990

g dg_college= g2010_college- g1990_college
g dg_nocollege= g2010_nocollege- g1990_nocollege
g dval=val_2010-val_1990

*** First prediction
** Coefficient: 
reg dln_ratio_ratio dln_ratio_ratio_cf [w=population] if downtown==1
scalar cons=_b[_cons]
predict predict1, xb
replace predict1 = predict1-cons

** Predicted
sum predict1 [w=population] if downtown==1 & rank<=25
scalar predict1_mean=r(mean)
** Actual: 
sum dln_ratio_ratio [w=population] if downtown==1 & rank<=25

scalar share1=predict1_mean/r(mean)

** Percentage
display share1


*** Second Prediction

** Coefficient:
ivreg2 dln_ratio_ratio (dln_ratio_ratio_cf=dg) [w=population] if downtown==1
scalar cons=_b[_cons]
predict predict2, xb
replace predict2 = predict2-cons

** Predicted
sum predict2 [w=population] if downtown==1 & rank<=25
scalar predict2_mean=r(mean)
** Actual:
sum dln_ratio_ratio [w=population] if downtown==1 & rank<=25

scalar share2=predict2_mean/r(mean)
** Percentage
display share2


*** Third prediction
** Coefficient: 
ivreg2 dln_ratio_ratio (dln_ratio_ratio_cf=dg_college dg_nocollege) [w=population] if downtown==1
scalar cons=_b[_cons]
predict predict3, xb
replace predict3 = predict3-cons

** Predicted
sum predict3 [w=population] if downtown==1 & rank<=25
scalar predict3_mean=r(mean)

** Actual
sum dln_ratio_ratio [w=population] if downtown==1 & rank<=25

scalar share3=predict3_mean/r(mean)
** Percentage
display share3


*** fourth prediction
** Coefficient: 
ivreg2 dln_ratio_ratio (dg=dval) [w=population] if downtown==1
scalar cons=_b[_cons]
predict predict4, xb
replace predict4 = predict4-cons
** Predicted
sum predict4 [w=population] if downtown==1 & rank<=25
scalar predict4_mean=r(mean)
** Actual
sum dln_ratio_ratio [w=population] if downtown==1 & rank<=25

scalar share4=predict4_mean/r(mean)
** Percentage
display share4

