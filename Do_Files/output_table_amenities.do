clear all
global data="/Users/linagomez/Documents/Stata/Economía Urbana/132721-V1/data"

***** pick out establishments of interest and generate zip code statistics to plot. 
**1. Restaurant 2. grocery store 3. gym  4. personal care

cd $data\zbp
*** restaurant
u zip94detail, clear
keep if sic=="5812" | sic=="5813"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save restaurant94,replace

cd $data\zbp
u zip00detail, clear
g lastthreedigit=substr(naics,4,3)
g lasttwodigit=substr(naics,5,2)
g lastdigit=substr(naics,6,1)
drop if lastthreedigit=="---"
drop if lasttwodigit=="--"
drop if lastdigit=="-"
g naics_3=substr(naics,1,3)
keep if naics_3=="722"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save restaurant00,replace

cd $data\zbp
u zip10detail, clear
g lastthreedigit=substr(naics,4,3)
g lasttwodigit=substr(naics,5,2)
g lastdigit=substr(naics,6,1)
drop if lastthreedigit=="---"
drop if lasttwodigit=="--"
drop if lastdigit=="-"
g naics_3=substr(naics,1,3)
keep if naics_3=="722"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save restaurant10,replace


*** grocery store 

cd $data\zbp
u zip94detail, clear
g lasttwodigit=substr(sic,3,2)
g lastdigit=substr(sic,4,1)
drop if lasttwodigit=="--"
drop if lastdigit=="-"
g sic_2=substr(sic,1,2)
keep if sic_2=="54"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save grocery94, replace

cd $data\zbp
u zip00detail, clear
g lastthreedigit=substr(naics,4,3)
g lasttwodigit=substr(naics,5,2)
g lastdigit=substr(naics,6,1)
drop if lastthreedigit=="---"
drop if lasttwodigit=="--"
drop if lastdigit=="-"
g naics_3=substr(naics,1,3)
keep if naics_3=="445"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save grocery00, replace

cd $data\zbp
u zip10detail, clear
g lastthreedigit=substr(naics,4,3)
g lasttwodigit=substr(naics,5,2)
g lastdigit=substr(naics,6,1)
drop if lastthreedigit=="---"
drop if lasttwodigit=="--"
drop if lastdigit=="-"
g naics_3=substr(naics,1,3)
keep if naics_3=="445"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save grocery10, replace

*** gym
cd $data\zbp
u zip94detail, clear
keep if sic=="7991"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save gym94, replace

cd $data\zbp
u zip00detail, clear
g lastdigit=substr(naics,6,1)
drop if lastdigit=="-"
g naics_5=substr(naics,1,5)
keep if naics_5=="71394"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save gym00, replace

cd $data\zbp
u zip10detail, clear
g lastdigit=substr(naics,6,1)
drop if lastdigit=="-"
g naics_5=substr(naics,1,5)
keep if naics_5=="71394"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save gym10, replace


** personal care services
cd $data\zbp
u zip94detail, clear
keep if sic=="7230" | sic=="7240" | sic=="7299"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save personal94, replace

cd $data\zbp
u zip00detail, clear
g lasttwodigit=substr(naics,5,2)
g lastdigit=substr(naics,6,1)
drop if lasttwodigit=="--"
drop if lastdigit=="-"
g naics_4=substr(naics,1,4)
keep if naics_4=="8121"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save personal00, replace

cd $data\zbp
u zip10detail, clear
g lasttwodigit=substr(naics,5,2)
g lastdigit=substr(naics,6,1)
drop if lasttwodigit=="--"
drop if lastdigit=="-"
g naics_4=substr(naics,1,4)
keep if naics_4=="8121"
collapse (sum) est n1_4 n5_9 n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000,by(zip)
cd $data\temp_files
save personal10, replace


**** make it tract level

*** restaurant
cd $data\temp_files
u restaurant94, clear
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip1990_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_restaurant94, replace

cd $data\geographic
u tract1990_zip1990_nearest, clear
cd $data\temp_files
merge m:1 zip using restaurant94
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_restaurant94
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_restaurant94, replace

** 2000
cd $data\temp_files
u restaurant00, clear
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip2000_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_restaurant00, replace

cd $data\geographic
u tract1990_zip2000_nearest, clear
cd $data\temp_files
merge m:1 zip using restaurant00
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_restaurant00
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_restaurant00, replace

** 2010
cd $data\temp_files
u restaurant10, clear
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip2010_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_restaurant10, replace

cd $data\geographic
u tract1990_zip2010_nearest, clear
cd $data\temp_files
merge m:1 zip using restaurant10
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_restaurant10
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_restaurant10, replace



*** grocery
cd $data\temp_files
u grocery94, clear
egen est_small= rowtotal(n1_4 n5_9 n10_19 n20_49)
egen est_large= rowtotal( n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip1990_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_grocery94, replace

cd $data\geographic
u tract1990_zip1990_nearest, clear
cd $data\temp_files
merge m:1 zip using grocery94
egen est_small= rowtotal(n1_4 n5_9 n10_19 n20_49)
egen est_large= rowtotal( n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_grocery94
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_grocery94, replace

** 2000
cd $data\temp_files
u grocery00, clear
egen est_small= rowtotal(n1_4 n5_9 n10_19 n20_49 )
egen est_large= rowtotal(n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip2000_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_grocery00, replace

cd $data\geographic
u tract1990_zip2000_nearest, clear
cd $data\temp_files
merge m:1 zip using grocery00
egen est_small= rowtotal(n1_4 n5_9 n10_19 n20_49)
egen est_large= rowtotal( n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_grocery00
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_grocery00, replace

** 2010
cd $data\temp_files
u grocery10, clear
egen est_small= rowtotal(n1_4 n5_9 n10_19 n20_49)
egen est_large= rowtotal( n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip2010_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_grocery10, replace

cd $data\geographic
u tract1990_zip2010_nearest, clear
cd $data\temp_files
merge m:1 zip using grocery10
egen est_small= rowtotal(n1_4 n5_9 n10_19 n20_49)
egen est_large= rowtotal( n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_grocery10
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_grocery10, replace


*** gym
cd $data\temp_files
u gym94, clear
keep zip est
cd $data\geographic
merge 1:m zip using tract1990_zip1990_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est, by(gisjoin)
cd $data\temp_files
save tract_gym94, replace

cd $data\geographic
u tract1990_zip1990_nearest, clear
cd $data\temp_files
merge m:1 zip using gym94

keep gisjoin est
capture collapse (sum) est_nearest=est, by(gisjoin)
merge 1:1 gisjoin using tract_gym94
drop _merge
replace est=est_nearest if est==.
keep gisjoin est
drop if gisjoin==""
save tract_gym94, replace

** 2000
cd $data\temp_files
u gym00, clear
keep zip est
cd $data\geographic
merge 1:m zip using tract1990_zip2000_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est, by(gisjoin)
cd $data\temp_files
save tract_gym00, replace

cd $data\geographic
u tract1990_zip2000_nearest, clear
cd $data\temp_files
merge m:1 zip using gym00

keep gisjoin est
capture collapse (sum) est_nearest=est, by(gisjoin)
merge 1:1 gisjoin using tract_gym00
drop _merge
replace est=est_nearest if est==.
keep gisjoin est
drop if gisjoin==""
save tract_gym00, replace

** 2010
cd $data\temp_files
u gym10, clear
keep zip est
cd $data\geographic
merge 1:m zip using tract1990_zip2010_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est, by(gisjoin)
cd $data\temp_files
save tract_gym10, replace

cd $data\geographic
u tract1990_zip2010_nearest, clear
cd $data\temp_files
merge m:1 zip using gym10

keep gisjoin est
capture collapse (sum) est_nearest=est, by(gisjoin)
merge 1:1 gisjoin using tract_gym10
drop _merge
replace est=est_nearest if est==.
keep gisjoin est
drop if gisjoin==""
save tract_gym10, replace

*** personal
cd $data\temp_files
u personal94, clear
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip1990_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_personal94, replace

cd $data\geographic
u tract1990_zip1990_nearest, clear
cd $data\temp_files
merge m:1 zip using personal94
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_personal94
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_personal94, replace

** 2000
cd $data\temp_files
u personal00, clear
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip2000_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_personal00, replace

cd $data\geographic
u tract1990_zip2000_nearest, clear
cd $data\temp_files
merge m:1 zip using personal00
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_personal00
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_personal00, replace

** 2010
cd $data\temp_files
u personal10, clear
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep zip est_small est_large
cd $data\geographic
merge 1:m zip using tract1990_zip2010_1mi
keep if _merge==3
drop _merge
capture collapse (sum) est_small est_large, by(gisjoin)
cd $data\temp_files
save tract_personal10, replace

cd $data\geographic
u tract1990_zip2010_nearest, clear
cd $data\temp_files
merge m:1 zip using personal10
egen est_small= rowtotal(n1_4 n5_9)
egen est_large= rowtotal(n10_19 n20_49 n50_99 n100_249 n250_499 n500_999 n1000)
keep gisjoin est_small est_large
capture collapse (sum) est_small_nearest=est_small est_large_nearest=est_large, by(gisjoin)
merge 1:1 gisjoin using tract_personal10
drop _merge
replace est_small=est_small_nearest if est_small==.
replace est_large=est_large_nearest if est_large==.
keep gisjoin est_small est_large
drop if gisjoin==""
save tract_personal10, replace


*** merge
* restaurant
cd $data\temp_files
u tract_restaurant94, clear
ren est_small est_small_restaurant1990
ren est_large est_large_restaurant1990

merge 1:1 gisjoin using tract_restaurant00
drop _merge
ren est_small est_small_restaurant2000
ren est_large est_large_restaurant2000

merge 1:1 gisjoin using tract_restaurant10
drop _merge
ren est_small est_small_restaurant2010
ren est_large est_large_restaurant2010

save tract_restaurant, replace

** grocery
u tract_grocery94, clear
ren est_small est_small_grocery1990
ren est_large est_large_grocery1990

merge 1:1 gisjoin using tract_grocery00
drop _merge
ren est_small est_small_grocery2000
ren est_large est_large_grocery2000

merge 1:1 gisjoin using tract_grocery10
drop _merge
ren est_small est_small_grocery2010
ren est_large est_large_grocery2010

save tract_grocery, replace

*** gym
u tract_gym94, clear
ren est est_gym1990
merge 1:1 gisjoin using tract_gym00
drop _merge
ren est est_gym2000
merge 1:1 gisjoin using tract_gym10
drop _merge
ren est est_gym2010
save tract_gym, replace

** personal
u tract_personal94, clear
ren est_small est_small_personal1990
ren est_large est_large_personal1990

merge 1:1 gisjoin using tract_personal00
drop _merge
ren est_small est_small_personal2000
ren est_large est_large_personal2000

merge 1:1 gisjoin using tract_personal10
drop _merge
ren est_small est_small_personal2010
ren est_large est_large_personal2010

save tract_personal, replace

*** 
u tract_restaurant, clear

merge 1:1 gisjoin using tract_grocery
drop _merge
merge 1:1 gisjoin using tract_gym
drop _merge
merge 1:1 gisjoin using tract_personal
drop _merge


sort gisjoin
save tract_amenities, replace

****************************** Code above generates intermediate files (intermediate files are already generated in the folders)
********************************************************************************************
****************************** Code below generates Table 1 and 6 (Code below can be run directly without running the above code)
**** Regress the change of local neighborhood amenities on local skill ratio

cd $data\geographic
u tract1990_tract1990_2mi, clear

keep if dist<=1610
cd $data\temp_files

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

cd $data\temp_files

merge m:1 gisjoin using skill_pop_1mi
keep if _merge==3
drop _merge

*** Merge the ingredient to compute the instrumental variable for local skill ratio
cd $data\temp_files\iv
merge m:1 gisjoin using ingredient_for_iv_amenity
keep if _merge==3
drop _merge


collapse (sum) population1990 population2010 impute2010_high impute2010_low impute1990_high impute1990_low sim1990_high sim1990_low sim2010_high sim2010_low, by(gisjoin)

cd $data\temp_files

merge 1:1 gisjoin using tract_amenities
keep if _merge==3
drop _merge

cd $data\geographic

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
cd $data\temp_files
egen tract_id=group(gisjoin)

save data_matlab, replace



**** Regressions
* Column (1-4) of Table 1
cd $data\temp_files

u data_matlab, clear

reghdfe d_restaurant dratio, absorb(metarea) vce(robust)
reghdfe d_grocery dratio, absorb(metarea) vce(robust)
reghdfe d_gym dratio, absorb(metarea) vce(robust)
reghdfe d_personal dratio, absorb(metarea) vce(robust)

*** IV regression for amenity equation
* Column (1-4) of Table 6
******
ivreghdfe d_restaurant (dratio=dln_sim_high dln_sim_low), absorb(metarea) robust
ivreghdfe d_grocery (dratio=dln_sim_high dln_sim_low), absorb(metarea) robust
ivreghdfe d_gym (dratio= dln_sim_high dln_sim_low), absorb(metarea) robust
ivreghdfe d_personal (dratio= dln_sim_high dln_sim_low), absorb(metarea) robust

****
** crime amenity

clear all
cd $data\crime
import delimited crime_place2013_tract1990.csv , varnames(1) clear

keep gisjoin crime_violent_rate1990 crime_property_rate1990 crime_violent_rate2010 crime_property_rate2010 gisjoin_1

ren gisjoin gisjoin_muni
ren gisjoin_1 gisjoin

cd $data\temp_files

merge 1:1 gisjoin using population1990
keep if _merge==3
drop _merge

merge 1:1 gisjoin using population2010
keep if _merge==3
drop _merge

cd $data\temp_files

merge 1:1 gisjoin using skill_pop
keep if _merge==3
drop _merge

cd $data\temp_files\iv
merge m:1 gisjoin using ingredient_for_iv_amenity
drop if _merge==2
drop _merge

cd $data\geographic

merge m:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge


collapse (sum) impute2010_high impute2010_low impute1990_high impute1990_low population population2010 sim1990_high sim1990_low sim2010_high sim2010_low (mean) crime_violent_rate* crime_property_rate* , by(gisjoin_muni metarea)

g dratio=ln((impute2010_high+1)/(impute2010_low+1))-ln((impute1990_high+1)/(impute1990_low+1))
g dratio_sim=ln(sim2010_high/sim2010_low)- ln(sim1990_high/sim1990_low)
g dviolent=ln( crime_violent_rate2010+0.1)-ln( crime_violent_rate1990+0.1)
g dproperty=ln( crime_property_rate2010+0.1)-ln( crime_property_rate1990+0.1)


g dln_sim_high=ln(sim2010_high)- ln(sim1990_high)
g dln_sim_low=ln(sim2010_low)- ln(sim1990_low)

*** Column 5-6 of Table 1
reghdfe dproperty dratio [w=population] if dln_sim_high!=., absorb(metarea) vce(robust)
reghdfe dviolent dratio [w=population] if dln_sim_high!=., absorb(metarea)  vce(robust)
*** Column 5-6 of Table 6
ivreghdfe dproperty (dratio=dln_sim_high dln_sim_low) [w=population] , absorb(metarea) robust
ivreghdfe dviolent (dratio=dln_sim_high dln_sim_low) [w=population], absorb(metarea) robust

