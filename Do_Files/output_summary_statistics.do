clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

**** Summary statistics

*** Rent

cd $data\temp_files
u data, clear

duplicates drop gisjoin, force

g ln_rent1990=ln(rent1990)
g ln_rent2010=ln(rent2010)

sum ln_rent1990, d
sum ln_rent2010, d

*** Skill ratio

cd $data\final_data
u data, clear

duplicates drop gisjoin, force

keep gisjoin

cd $data\inter_files\demographic\education

merge 1:1 gisjoin using skill_pop
keep if _merge==3
drop _merge
g ln_ratio_1990=ln( impute1990_high/ impute1990_low)
sum ln_ratio_1990, d
g ln_ratio_2010=ln( impute2010_high/ impute2010_low)
sum ln_ratio_2010, d
g dratio= ln_ratio_2010- ln_ratio_1990
sum dratio, d

*** Value of time (Long-hour premium)

cd $data\raw_data\ipums_raw
u 1990_2000_2010_temp , clear

keep if uhrswork>=30

keep if sex==1
keep if age>=25 & age<=65
keep if year==1990 | year==2010

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

replace inctot_real=inctot_real/52

g greaterthan50=0
replace greaterthan50=1 if uhrswork>=50
collapse greaterthan50, by(year occ2010)

reshape wide greaterthan50, i(occ2010) j(year)

g ln_d=ln( greaterthan502010)-ln( greaterthan501990)

cd $data\inter_files\ipums

merge 1:1 occ2010 using inc_occ_1990_2000_2010
drop _merge

drop inc_mean1990 inc_mean2000 inc_mean2010 wage_real1990 wage_real2000 wage_real2010

cd $data\inter_files\ipums\value_of_time

g metarea=112

merge 1:1 occ2010 using val_40_60_total_1990_2000_2010
drop _merge

merge 1:1 metarea occ2010 using val_time_log_wage
drop if _merge==2
drop _merge

g dwage=wage_real2010-wage_real1990

merge 1:1 metarea occ2010 using val_time_sd_earning
drop if _merge==2
drop _merge

g dsd=sd_inctot2010-sd_inctot1990

drop count1990 count2000 count2010

cd $data\inter_files\ipums
merge 1:1 metarea occ2010 using count_metarea
keep if _merge==3
drop _merge

g dval=val_2010-val_1990

cd $data\inter_files\demographic\education
merge m:1 occ2010 using high_skill
drop if _merge==2
drop _merge

keep val_1990 val_2010 dval high_skill

drop if dval==.

sum val_1990 if high_skill==1
sum val_2010 if high_skill==1
sum dval if high_skill==1

sum val_1990 if high_skill==0
sum val_2010 if high_skill==0
sum dval if high_skill==0

sum val_1990
sum val_2010
sum dval


*** Amenities

cd $data\inter_files\geographic
u tract1990_tract1990_2mi, clear

keep if dist<=1610
cd $data\inter_files\demographic\population

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

cd $data\inter_files\demographic\education

merge m:1 gisjoin using skill_pop_1mi
keep if _merge==3
drop _merge

*** Merge the ingredient to compute the instrumental variable for local skill ratio
cd $data\inter_files\instrument
merge m:1 gisjoin using ingredient_for_iv_amenity
keep if _merge==3
drop _merge


collapse (sum) population1990 population2010 impute2010_high impute2010_low impute1990_high impute1990_low sim1990_high sim1990_low sim2010_high sim2010_low, by(gisjoin)

cd $data\inter_files\amenities

merge 1:1 gisjoin using tract_amenities
keep if _merge==3
drop _merge

cd $data\inter_files\geographic

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
cd $data\inter_files\amenities
egen tract_id=group(gisjoin)

g ln_restaurant_1990=ln((est_small_restaurant1990+est_large_restaurant1990+1)/(population1990+1))
g ln_restaurant_2010=ln((est_small_restaurant2010+est_large_restaurant2010+1)/(population2010+1))

g ln_grocery_1990=ln( (est_small_grocery1990+est_large_grocery1990+1)/(population1990+1))
g ln_grocery_2010=ln( (est_small_grocery2010+est_large_grocery2010+1)/(population2010+1))

g ln_gym_1990=ln( (est_gym1990+1)/(population1990+1))
g ln_gym_2010=ln( (est_gym2010+1)/(population2010+1))

g ln_personal_1990=ln( (est_small_personal1990+est_large_personal1990+1)/(population1990+1))
g ln_personal_2010=ln( (est_small_personal2010+est_large_personal2010+1)/(population2010+1))


*** Crime 
* crime amenity

clear all
cd $data\raw_data\geographic_raw\place_tract
import delimited crime_place2013_tract1990.csv , varnames(1) clear

keep gisjoin crime_violent_rate1990 crime_property_rate1990 crime_violent_rate2010 crime_property_rate2010 gisjoin_1

ren gisjoin gisjoin_muni
ren gisjoin_1 gisjoin

cd $data\inter_files\demographic\population

merge 1:1 gisjoin using population1990
keep if _merge==3
drop _merge

merge 1:1 gisjoin using population2010
keep if _merge==3
drop _merge

cd $data\inter_files\demographic\education

merge 1:1 gisjoin using skill_pop
keep if _merge==3
drop _merge

cd $data\inter_files\instrument
merge m:1 gisjoin using ingredient_for_iv_amenity
drop if _merge==2
drop _merge

cd $data\inter_files\geographic

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