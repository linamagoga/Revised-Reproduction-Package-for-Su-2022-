clear all
global data="/Users/linagomez/Documents/Stata/Economía Urbana/132721-V1/data"


** residential data
cd "$data/temp_files"
u tract_impute_share, clear

** Commute time data
cd "$data/temp_files/commute"

merge 1:m gisjoin occ2010 using commute
keep if _merge==3
drop _merge

ren expected_commute expected_commute_1990

merge 1:m gisjoin occ2010 using commute2010
keep if _merge==3
drop _merge

ren expected_commute expected_commute_2010
ren expected_commute_1990 expected_commute

g dexpected=expected_commute_2010-expected_commute

*** value of time data
cd "$data/temp_files"
merge m:1 occ2010 using val_40_60_total_1990_2000_2010
keep if _merge==3
drop _merge

drop se_1990 se_2000

*** rent
cd "$data/temp_files"
merge m:1 gisjoin using rent
drop if _merge==2
drop _merge

*** instrument for location demand


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

cd "$data/temp_files/commute"
merge m:1 gisjoin occ_group using commute_total
drop _merge


cd "$data/temp_files/iv"
merge m:1 gisjoin occ_group using sim_iv
keep if _merge==3
drop _merge

merge m:1 gisjoin using sim_iv_total
keep if _merge==3
drop _merge

cd "$data/temp_files"
merge m:1 gisjoin using skill_ratio_occupation
keep if _merge==3
drop _merge

cd "$data/geographic"
merge m:1 metarea using 1990_rank
drop _merge

cd "$data/temp_files"
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

drop if count1990==.

g dimpute=ln(impute_share2010)-ln(impute_share1990)
egen tract_id=group(gisjoin)
egen metarea_occ=group(metarea occ2010)
drop year serial
drop  count2000 count2010

g dval=val_2010-val_1990

g dval_expected_commute=dval*expected_commute

g drent=ln(rent2010+1)-ln(rent1990+1)

ren count1990 count

cd "$data/temp_files"
merge m:1 occ2010 using high_skill
drop if _merge==2
drop _merge


cd "$data/temp_files"
merge m:1 gisjoin using room_density1980_1mi
drop if _merge==2
drop _merge

replace room_density_1mi_3mi=(room_density_1mi_3mi-8127.921)/14493.66


g high_skill_dratio=high_skill*dratio

g high_skill_dln_sim_high=high_skill* dln_sim_high

g high_skill_dln_sim_low=high_skill* dln_sim_low

g high_skill_dln_sim=high_skill*dln_sim

g dln_sim_density=dln_sim*room_density_1mi_3mi

g dln_sim_high_density=dln_sim_high*room_density_1mi_3mi

g dln_sim_low_density=dln_sim_low*room_density_1mi_3mi

g dln_sim_total_density=dln_sim_total*room_density_1mi_3mi

g dln_sim_high_total_density=dln_sim_high_total*room_density_1mi_3mi

g dln_sim_low_total_density=dln_sim_low_total*room_density_1mi_3mi


***
g high_skill_drent= high_skill*drent
g high_skill_dln_sim_density = high_skill*dln_sim_density
g high_skill_dln_sim_high_density= high_skill*dln_sim_high_density 
g high_skill_dln_sim_low_density =high_skill*dln_sim_low_density
g high_skill_room_density_1mi_3mi= high_skill*room_density_1mi_3mi
g high_skill_expected_commute=high_skill*expected_commute
g high_dval_expected_commute=high_skill*dval_expected_commute
*** construct rent equation variable
cd "$data/temp_files"
merge m:1 gisjoin using ddemand
keep if _merge==3
drop _merge

cd "$data/temp_files"
merge m:1 metarea occ2010 using trantime_metarea_occ2010
drop _merge

g dtran_expected_commute=dtran*expected_commute
g high_dtran_expected_commute= high_skill*dtran_expected_commute

merge m:1 occ2010 using val_time_sd_earning_total_standard
drop _merge

merge m:1 occ2010 using val_greaterthan50
drop _merge

replace ln_d=ln(greaterthan502010)-ln(greaterthan501990)

g dsd_expected_commute=(sd_inctot2010-sd_inctot1990)*expected_commute
g high_dsd_expected_commute=high_skill*dsd_expected_commute

g ln_d_expected_commute=ln_d*expected_commute
g high_ln_d_expected_commute=high_skill*ln_d_expected_commute

cd "$temp_files"
save data, replace

**** Regress 
cd "$data/temp_files"
u data, clear

 g ddemand_density=room_density_1mi_3mi*ddemand
 ******************************************************************
 *** Main specification (Table 5)
 
 ** Panel A
 ** Worker's residential location demand
  *ivreghdfe es regresión variable instrumental con múltiples niveles de efectos fijos.
  # delimit
ivreghdfe dimpute expected_commute high_skill_expected_commute dval_expected_commute high_dval_expected_commute 
(dratio high_skill_dratio drent high_skill_drent=  dln_sim_high dln_sim_low high_skill_dln_sim_high high_skill_dln_sim_low dln_sim_density dln_sim_high_density dln_sim_low_density high_skill_dln_sim_density high_skill_dln_sim_high_density high_skill_dln_sim_low_density high_skill_room_density_1mi_3mi room_density_1mi_3mi)
[w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id) gmm2s;
 # delimit cr

 * Commute cost
 
* High-skilled
*lincom - linear combination of parameters. After fitting a model and obtaining estimates for coefficients B1, B2,... you may want to view estimates for linear combinations of the  Bi. lincom can display estimates for any linear combination of the form c0 + c1 1 + c2 2 + ... + ck k.
lincom dval_expected_commute + high_dval_expected_commute
* Low-skilled
lincom dval_expected_commute

* Amenities

* High-skilled
lincom dratio + high_skill_dratio
* low-skilled
lincom dratio

* Rent

* High_skilled
lincom drent + high_skill_drent
* Low-skilled
lincom drent

 
 * Panel B
 ** Housing supply equation
  ivreghdfe drent room_density_1mi_3mi (ddemand_density =dln_sim_total_density dln_sim_low_total_density dln_sim_high_total_density)[w=count], absorb(i.metarea) cluster(tract_id) gmm2s

 
 *** robustness checks (Table 7)
 
 * Column 1
 
 *** Commute only
   # delimit
reghdfe dimpute expected_commute high_skill_expected_commute dval_expected_commute high_dval_expected_commute [w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id);
 # delimit cr
 
 * Commute cost
 
* High-skilled
lincom dval_expected_commute+ high_dval_expected_commute
* Low-skilled
lincom dval_expected_commute
 
 ** Column 2
 * Commute and amenities
 
  # delimit
ivreghdfe dimpute expected_commute high_skill_expected_commute dval_expected_commute high_dval_expected_commute (dratio high_skill_dratio=  dln_sim_high dln_sim_low high_skill_dln_sim_high high_skill_dln_sim_low ) [w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id) gmm2s;
 # delimit cr
 
** Commute cost
 
* High-skilled
lincom dval_expected_commute+ high_dval_expected_commute
 * Low-skilled
lincom dval_expected_commute
 
** Amenities
 
* High-skilled
lincom dratio + high_skill_dratio
* Low-skilled
lincom dratio

 ** Column 3
 ** Commute and rents
 
   # delimit
ivreghdfe dimpute expected_commute high_skill_expected_commute dval_expected_commute high_dval_expected_commute  (drent high_skill_drent=   dln_sim_density dln_sim_high_density dln_sim_low_density high_skill_dln_sim_density high_skill_dln_sim_high_density high_skill_dln_sim_low_density high_skill_room_density_1mi_3mi room_density_1mi_3mi) [w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id) gmm2s;
 # delimit cr
 
 ** Commute cost
 
* High-skilled
lincom dval_expected_commute+ high_dval_expected_commute
 * Low-skilled
lincom dval_expected_commute

*  Rent
* High-skilled
lincom drent + high_skill_drent
* Low-skilled
lincom drent

** Column 4
** Residual log earnings dispersion
  # delimit
ivreghdfe dimpute expected_commute high_skill_expected_commute dsd_expected_commute high_dsd_expected_commute (dratio high_skill_dratio drent high_skill_drent=  dln_sim_high dln_sim_low high_skill_dln_sim_high high_skill_dln_sim_low dln_sim_density dln_sim_high_density dln_sim_low_density high_skill_dln_sim_density high_skill_dln_sim_high_density high_skill_dln_sim_low_density high_skill_room_density_1mi_3mi room_density_1mi_3mi) [w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id) gmm2s;
 # delimit cr
 
 ** Commute cost
 
* High-skilled
lincom dsd_expected_commute+ high_dsd_expected_commute
 * Low-skilled
lincom dsd_expected_commute

* Amenities
* High-skilled
lincom dratio + high_skill_dratio
* Low-skilled
lincom dratio
 
*  Rent
* High-skilled
lincom drent + high_skill_drent
* Low-skilled
lincom drent

 ** Column 5
 ** Change in prevalence in long hours
 
    # delimit
ivreghdfe dimpute expected_commute high_skill_expected_commute ln_d_expected_commute high_ln_d_expected_commute (dratio high_skill_dratio drent high_skill_drent=  dln_sim_high dln_sim_low high_skill_dln_sim_high high_skill_dln_sim_low dln_sim_density dln_sim_high_density dln_sim_low_density high_skill_dln_sim_density high_skill_dln_sim_high_density high_skill_dln_sim_low_density high_skill_room_density_1mi_3mi room_density_1mi_3mi) [w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id) gmm2s;
 # delimit cr
 
 
 ** Commute cost
 
 * High-skilled
lincom ln_d_expected_commute+ high_ln_d_expected_commute
 * Low-skilled
lincom ln_d_expected_commute

** Amenities

* High-skilled
lincom dratio + high_skill_dratio
* Low-skilled
lincom dratio
 
*  Rent
* High-skilled
lincom drent + high_skill_drent
* Low-skilled
lincom drent
 
 ** Column 6
 ** Change in observed commute time
 
   # delimit
ivreghdfe dimpute expected_commute high_skill_expected_commute dtran_expected_commute high_dtran_expected_commute (dratio high_skill_dratio drent high_skill_drent=  dln_sim_high dln_sim_low high_skill_dln_sim_high high_skill_dln_sim_low dln_sim_density dln_sim_high_density dln_sim_low_density high_skill_dln_sim_density high_skill_dln_sim_high_density high_skill_dln_sim_low_density high_skill_room_density_1mi_3mi room_density_1mi_3mi) [w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id) gmm2s;
 # delimit cr
 
  ** Commute cost
 
 * High-skilled
lincom dtran_expected_commute+ high_dtran_expected_commute
 * Low-skilled
lincom dtran_expected_commute

** Amenities

* High-skilled
lincom dratio + high_skill_dratio
* Low-skilled
lincom dratio
 
*  Rent
* High-skilled
lincom drent + high_skill_drent
* Low-skilled
lincom drent
 
** Column 7 and 8 are conducted in "output_regression_robustness_skill30.do", "output_regression_robustness_skill50.do"
 
 *** Reduced form results (Table A5)
 
 # delimit
reghdfe dimpute expected_commute high_skill_expected_commute dval_expected_commute high_dval_expected_commute  dln_sim_high dln_sim_low high_skill_dln_sim_high high_skill_dln_sim_low dln_sim_density dln_sim_high_density dln_sim_low_density high_skill_dln_sim_density high_skill_dln_sim_high_density high_skill_dln_sim_low_density high_skill_room_density_1mi_3mi room_density_1mi_3mi [w=count] , absorb(i.metarea_occ i.occ2010#c.dexpected i.occ2010#c.total_commute) cluster(tract_id);
 # delimit cr
 
 * dv*E(c)
 * high-skilled
lincom dval_expected_commute+ high_dval_expected_commute 
 * low-skilled
lincom dval_expected_commute 

 * dln(N_H)
 * high-skilled
lincom dln_sim_high+ high_skill_dln_sim_high
 * low-skilled
lincom dln_sim_high
 
 * dln(N_L)
 * high-skilled
lincom dln_sim_low+ high_skill_dln_sim_low
 * low-skilled
lincom dln_sim_low

 * dln(N_H)* den
 * high-skilled
lincom dln_sim_high_density + high_skill_dln_sim_high_density
 * low-skilled
lincom dln_sim_high_density
 
 * dln(N_L)* den
 * high-skilled
lincom dln_sim_low_density + high_skill_dln_sim_low_density
 * low-skilled
lincom dln_sim_low_density
 
 * dln(N_H+N_L)* den
 * high-skilled
lincom dln_sim_density + high_skill_dln_sim_density
 * low-skilled
lincom dln_sim_density
 
 * den
 * high-skilled
lincom room_density_1mi_3mi + high_skill_room_density_1mi_3mi 
 * low-skilled
lincom room_density_1mi_3mi





******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************


**** Summary statistics (Table 4)


*** Long hour premium
cd "$data/temp_files"
u val_40_60_total_1990_2000_2010, clear

g dval=val_2010-val_1990

merge m:1 occ2010 using high_skill
drop if _merge==2
drop _merge

keep val_1990 val_2010 dval high_skill

drop if dval==.

** Long hour premium
sum val_1990
sum val_2010
sum dval

sum val_1990 if high_skill==1
sum val_2010 if high_skill==1
sum dval if high_skill==1

sum val_1990 if high_skill==0
sum val_2010 if high_skill==0
sum dval if high_skill==0


*** Skill ratio

cd "$data/temp_files"
u data, clear

duplicates drop gisjoin, force

keep gisjoin

merge 1:1 gisjoin using skill_pop
keep if _merge==3
drop _merge
g ln_ratio_1990=ln( impute1990_high/ impute1990_low)
g ln_ratio_2010=ln( impute2010_high/ impute2010_low)
g dratio= ln_ratio_2010- ln_ratio_1990
sum ln_ratio_1990
sum ln_ratio_2010
sum dratio

*** Rent

cd "$data/temp_files"
u data, clear

duplicates drop gisjoin, force


g ln_rent1990=ln(rent1990)
g ln_rent2010=ln(rent2010)
sum ln_rent1990
sum ln_rent2010
sum drent

*** Amenities

cd "$data/geographic"
u tract1990_tract1990_2mi, clear

keep if dist<=1610
cd "$data/temp_files"

ren gisjoin2 gisjoin

merge m:1 gisjoin using population1990
keep if _merge==3
drop _merge

ren population population1990

merge m:1 gisjoin using population2010
keep if _merge==3
drop _merge

drop gisjoin
ren gisjoin1 gisjoin

cd "$data/temp_files"

merge m:1 gisjoin using skill_pop_1mi
keep if _merge==3
drop _merge

*** Merge the ingredient to compute the instrumental variable for local skill ratio
cd "$data/temp_files"\iv
merge m:1 gisjoin using ingredient_for_iv_amenity
keep if _merge==3
drop _merge


collapse (sum) population1990 population2010 impute2010_high impute2010_low impute1990_high impute1990_low sim1990_high sim1990_low sim2010_high sim2010_low, by(gisjoin)

cd "$data/temp_files"

merge 1:1 gisjoin using tract_amenities
keep if _merge==3
drop _merge

cd "$data/geographic"

merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

** restaurant
g d_large_restaurant=ln( (est_large_restaurant2010+1)/(population2010+1))-ln( (est_large_restaurant1990+1)/(population1990+1))
g d_small_restaurant=ln( (est_small_restaurant2010+1)/(population2010+1))-ln( (est_small_restaurant1990+1)/(population1990+1))
g d_restaurant=ln((est_small_restaurant2010+est_large_restaurant2010+1)/(population2010+1))-ln((est_small_restaurant1990+est_large_restaurant1990+1)/(population1990+1))

** grocery stores
g d_large_grocery=ln( (est_large_grocery2010+1)/(population2010+1))-ln( (est_large_grocery1990+1)/(population1990+1))
g d_small_grocery=ln( (est_small_grocery2010+1)/(population2010+1))-ln( (est_small_grocery1990+1)/(population1990+1))

g d_grocery=ln( (est_small_grocery2010+est_large_grocery2010+1)/(population2010+1))-ln( (est_small_grocery1990+est_large_grocery1990+1)/(population1990+1))
** gym
g d_gym=ln( (est_gym2010+1)/(population2010+1))-ln( (est_gym1990+1)/(population1990+1))

** personal services
g d_large_personal=ln( (est_large_personal2010+1)/(population2010+1))-ln( (est_large_personal1990+1)/(population1990+1))
g d_small_personal=ln( (est_small_personal2010+1)/(population2010+1))-ln( (est_small_personal1990+1)/(population1990+1))

g d_personal=ln( (est_small_personal2010+est_large_personal2010+1)/(population2010+1))-ln( (est_small_personal1990+est_large_personal1990+1)/(population1990+1))

g dratio=ln((impute2010_high+1)/(impute2010_low+1))-ln((impute1990_high+1)/(impute1990_low+1))

g dratio_sim=ln(sim2010_high/sim2010_low)- ln(sim1990_high/sim1990_low)
g dln_sim_high=ln(sim2010_high)- ln(sim1990_high)
g dln_sim_low=ln(sim2010_low)- ln(sim1990_low)

duplicates drop gisjoin, force

egen tract_id=group(gisjoin)

g ln_restaurant_1990=ln((est_small_restaurant1990+est_large_restaurant1990+1)/(population1990+1))
g ln_restaurant_2010=ln((est_small_restaurant2010+est_large_restaurant2010+1)/(population2010+1))
g dln_restaurant=ln_restaurant_2010-ln_restaurant_1990

g ln_grocery_1990=ln( (est_small_grocery1990+est_large_grocery1990+1)/(population1990+1))
g ln_grocery_2010=ln( (est_small_grocery2010+est_large_grocery2010+1)/(population2010+1))
g dln_grocery=ln_grocery_2010-ln_grocery_1990

g ln_gym_1990=ln( (est_gym1990+1)/(population1990+1))
g ln_gym_2010=ln( (est_gym2010+1)/(population2010+1))
g dln_gym=ln_gym_2010-ln_gym_1990

g ln_personal_1990=ln( (est_small_personal1990+est_large_personal1990+1)/(population1990+1))
g ln_personal_2010=ln( (est_small_personal2010+est_large_personal2010+1)/(population2010+1))
g dln_personal=ln_personal_2010-ln_personal_1990

** Table 4

** Amenities

** Restaurants

sum ln_restaurant_1990
sum ln_restaurant_2010
sum dln_restaurant

** Grocery

sum ln_grocery_1990
sum ln_grocery_2010
sum dln_grocery

** Gym

sum ln_gym_1990
sum ln_gym_2010
sum dln_gym

** Personal

sum ln_personal_1990
sum ln_personal_2010
sum dln_personal

*** Crime 
* crime amenity

clear all
cd "$data/crime"
import delimited crime_place2013_tract1990.csv , varnames(1) clear

keep gisjoin crime_violent_rate1990 crime_property_rate1990 crime_violent_rate2010 crime_property_rate2010 gisjoin_1

ren gisjoin gisjoin_muni
ren gisjoin_1 gisjoin

cd "$data/temp_files"

merge 1:1 gisjoin using population1990
keep if _merge==3
drop _merge

merge 1:1 gisjoin using population2010
keep if _merge==3
drop _merge

merge 1:1 gisjoin using skill_pop
keep if _merge==3
drop _merge

cd "$data/temp_files"\iv
merge m:1 gisjoin using ingredient_for_iv_amenity
drop if _merge==2
drop _merge

cd "$data/geographic"

merge m:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge


collapse (sum) impute2010_high impute2010_low impute1990_high impute1990_low population population2010 sim1990_high sim1990_low sim2010_high sim2010_low (mean) crime_violent_rate* crime_property_rate* , by(gisjoin_muni metarea)

g dratio=ln((impute2010_high+1)/(impute2010_low+1))-ln((impute1990_high+1)/(impute1990_low+1))
g dratio_sim=ln(sim2010_high/sim2010_low)- ln(sim1990_high/sim1990_low)
g dviolent=ln( crime_violent_rate2010+0.1)-ln( crime_violent_rate1990+0.1)
g dproperty=ln( crime_property_rate2010+0.1)-ln( crime_property_rate1990+0.1)

g ln_violent_1990=ln( crime_violent_rate1990+0.1)

g ln_violent_2010=ln( crime_violent_rate2010+0.1)

g ln_property_1990=ln( crime_property_rate1990+0.1)

g ln_property_2010=ln( crime_property_rate2010+0.1)

g dln_violent=ln_violent_2010-ln_violent_1990
g dln_property=ln_property_2010-ln_property_1990


*** Table 4 
** Violent crime
sum ln_violent_1990
sum ln_violent_2010
sum dln_violent

** Property crime

sum ln_property_1990
sum ln_property_2010
sum dln_property
