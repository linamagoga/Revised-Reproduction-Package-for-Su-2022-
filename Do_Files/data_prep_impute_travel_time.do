*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**    Improvements to the Impute Travel Time       **
**                Generation Do-File               **
*****************************************************



clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"



** Datos de la National Household Travel Survey 1995:
cd $data/travel

u nhts, clear

*** Automobile
keep if TRPTRANS>=1 & TRPTRANS<=5

** Monday - Friday
keep if TRAVDAY>=2 & TRAVDAY<=6
** To and from home
keep if WHYTO==17 | WHYFROM==17
** Miles per hour
replace TRPMILES=. if TRPMILES>=9000
replace TRVL_MIN=. if TRVL_MIN>=9000
g speed=TRPMILES/(TRVL_MIN/60)

g log_distance=ln(TRPMILES)

g log_speed=ln(speed)

g log_time=ln(TRVL_MIN/60)

*** Population density
replace HTPPOPDN=. if HTPPOPDN>90000
g pop_den=HTPPOPDN

** unit density
replace HTHRESDN=. if HTHRESDN>7000
g unit_den=HTHRESDN

** median income 
replace HTHINMED=. if HTHINMED>100000
g inc=HTHINMED
** Percentage of working pop
replace HTINDRET=. if HTINDRET>100
g working=HTINDRET
** log distance squared
g log_distance2=log_distance^2
*** create MSA dummy
g metarea_d=998

replace HHMSA=HHMSA/10
# delimit
foreach num of numlist 52 72 112 128 152 160 164 168 184 192
208 216 268 312 336 348 376 448 492 500
508 512 519 536 556 560 572 588 596 616
620 628 644 678 684 692 704 724 732 736
740 760 828 884 {;
# delimit cr

replace metarea_d=`num' if HHMSA==`num'
}

*** Rush hour
g rush=1
replace rush=0 if STRTTIME<630
replace rush=0 if STRTTIME>1030 & STRTTIME<1630
replace rush=0 if STRTTIME>2030

keep if rush==1

xi i.pop_den i.inc i.working
*reg log_speed log_distance log_distance2 _Ipop_den_* _Iinc_* _Iworking_*, r
reg log_speed log_distance log_distance2 _Ipop_den_* _Iinc_* _Iworking_*, r
estimates store speed_results
**************************************************************
**** recreate the neighborhood characteristics on the census tract map

** Get the land area for each census tract
clear
cd $data\geographic
import delimited tract1990_area.csv, varname(1) clear 

keep gisjoin area_sm
ren area_sm area

cd $data\geographic

sort gisjoin 
save area_sqmile, replace

*** Get the median income for each census tract
clear
cd $data\nhgis
import delimited nhgis0031_ds123_1990_tract.csv, clear
keep gisjoin e4u001
ren e4u001 median_income
sort gisjoin
cd $data\temp_files
save median_income1990, replace

*** Get the percentage of working population
clear 
cd $data\nhgis\working_pop
import delimited nhgis0016_ds123_1990_tract.csv, clear
egen working_pop=rowtotal(e4i001 e4i002 e4i005 e4i006)
keep gisjoin working_pop

cd $data\temp_files
merge 1:1 gisjoin using population1990
drop _merge
g share_working=working_pop/population
drop if share_working==.
replace share_working=1 if share_working>1

keep gisjoin share_working
sort gisjoin

save working_pop1990, replace


*** Get the population density
cd $data\temp_files
u population1990, clear
cd $data\geographic
merge 1:1 gisjoin using area_sqmile
keep if _merge==3
drop _merge

destring area, g(area_num) ignore(",")
drop area 
ren area_num area

g density=population/area
cd $data\geographic
keep gisjoin density
sort gisjoin
save density, replace

*** Create spatial data at census tract level
cd $data\geographic

u density, clear

cd $data\temp_files

merge 1:1 gisjoin using working_pop1990
keep if _merge==3
drop _merge
cd $data\temp_files
merge 1:1 gisjoin using median_income1990
keep if _merge==3
drop _merge

sort gisjoin
cd $data\temp_files
save tract1990_char, replace


** create average char within 2 miles for each census tract
cd $data\geographic

u tract1990_tract1990_2mi, clear

cd $data\temp_files

ren gisjoin2 gisjoin

merge m:1 gisjoin using tract1990_char
keep if _merge==3
drop _merge
ren gisjoin gisjoin2
ren gisjoin1 gisjoin
cd $data\temp_files
save temp, replace

cd $data\temp_files
u tract1990_char, clear
g gisjoin2=gisjoin
append using temp

collapse density share_working median_income, by(gisjoin)
cd $data\temp_files
save tract1990_char_2mi, replace

** Create average char within 2 miles for each zip code
cd $data\geographic
import delimited zip1990_tract1990_nearest.csv, varnames(1) clear
ren in_fid fid
cd $data\geographic
merge m:1 fid using zip1990
keep if _merge==3
drop _merge

drop fid
ren near_fid fid
merge m:1 fid using tract1990 
keep if _merge==3
drop _merge

keep gisjoin zip 
save zip1990_tract1990_nearest, replace

append using tract1990_zip1990_2mi
duplicates drop gisjoin zip, force
*** finished with the crosswalk, now merge with characteristics file

cd $data\temp_files

sort zip gisjoin

merge m:1 gisjoin using tract1990_char
keep if _merge==3
drop _merge

collapse density share_working median_income, by(zip)
save zip1990_char_2mi, replace



cd $data\geographic
import delimited tract1990_zip1990_leftover.csv, varnames(1) clear 
cd $data\geographic
ren input_fid fid
merge m:1 fid using tract1990

keep if _merge==3
drop _merge

drop fid

ren near_fid fid
merge m:1 fid using zip1990
keep if _merge==3
drop _merge

keep gisjoin zip distance
destring distance, g(distance_num) ignore(",")
drop distance
ren distance_num distance

replace distance=distance

replace distance=distance*1.6
g time=3600*distance/(35*1609.34)
cd $data\temp_files
save temp, replace

*** rank>=51
cd $data\geographic
import delimited tract1990_zip1990_leftover_51.csv, varnames(1) clear 
cd $data\geographic
ren input_fid fid
merge m:1 fid using tract1990

keep if _merge==3
drop _merge

drop fid

ren near_fid fid
merge m:1 fid using zip1990
keep if _merge==3
drop _merge

keep gisjoin zip distance
destring distance, g(distance_num) ignore(",")
drop distance
ren distance_num distance

replace distance=distance

replace distance=distance*1.6
g time=3600*distance/(35*1609.34)
cd $data\temp_files
save temp_51, replace

*** call the travel matrix
cd $data\travel
u travel_time, clear
cd $data\temp_files
merge 1:1 gisjoin zip using temp
drop if _merge==2
drop _merge

g leftover=1 if travel_time==-1 | travel_dist==-1 | travel_time==0 | travel_dist==0 | travel_time==. | travel_dist==.
replace travel_time=time if time!=. & leftover==1
replace travel_dist=distance if  distance!=. & leftover==1

drop leftover time distance

merge 1:1 gisjoin zip using temp_51
drop if _merge==2
drop _merge

g leftover=1 if travel_time==-1 | travel_dist==-1 | travel_time==0 | travel_dist==0 | travel_time==. | travel_dist==.
replace travel_time=time if time!=. & leftover==1
replace travel_dist=distance if  distance!=. & leftover==1

drop if zip==93562

drop time distance leftover

cd $data\temp_files
merge m:1 gisjoin using tract1990_char_2mi
drop if _merge==2
drop _merge
ren density density1
ren share_working share_working1
ren median_income median_income1

merge m:1 zip using zip1990_char_2mi
drop if _merge==2
drop _merge

ren density density2
ren share_working share_working2
ren median_income median_income2

*** fill the missing observations

replace density1=5267.096 if density1==.
replace share_working1=.4599274 if share_working1==.
replace median_income1=30438.35 if median_income1==.

replace density2=5267.096 if density2==.
replace share_working2=.4599274 if share_working2==.
replace median_income2=30438.35 if median_income2==.

**
g density=(density1+density2)/2
g share_working=(share_working1+share_working2)/2
g median_income=(median_income1+median_income2)/2

drop *1 *2
** population density

g pop_den=.
replace pop_den=50 if density>=0 & density<100
replace pop_den=300 if density>=100 & density<500
replace pop_den=750 if density>=500 & density<1000
replace pop_den=1500 if density>=1000 & density<2000
replace pop_den=3000 if density>=2000 & density<4000
replace pop_den=7000 if density>=4000 & density<10000
replace pop_den=17000 if density>=10000 & density<25000
replace pop_den=35000 if density>=25000

drop density

***Median income
g inc=.
replace inc=15000 if median_income>=0 & median_income<20000
replace inc=22000 if median_income>=20000 & median_income<25000
replace inc=27000 if median_income>=25000 & median_income<30000
replace inc=32000 if median_income>=30000 & median_income<35000
replace inc=37000 if median_income>=35000 & median_income<40000
replace inc=45000 if median_income>=40000 & median_income<50000
replace inc=60000 if median_income>=50000 & median_income<70000
replace inc=80000 if median_income>=70000
drop median_income
***
g working=.
replace working=0 if share_working>=0 & share_working<0.05
replace working=10 if share_working>=0.05 & share_working<0.15
replace working=20 if share_working>=0.15 & share_working<0.25
replace working=30 if share_working>=0.25 & share_working<0.35
replace working=40 if share_working>=0.35 & share_working<0.45
replace working=50 if share_working>=0.45 & share_working<0.55
replace working=60 if share_working>=0.55 & share_working<0.65
replace working=70 if share_working>=0.65 & share_working<0.75
replace working=80 if share_working>=0.75 & share_working<0.85
replace working=90 if share_working>=0.85 & share_working<0.95
replace working=95 if share_working>=0.95 & share_working<=1
drop share_working

xi i.pop_den i.inc i.working

g log_distance=ln(travel_dist/1609.34)
g log_distance2=log_distance^2

g log_speed=ln((travel_dist/1609.34)/(travel_time/3600))

reg log_speed log_distance log_distance2 _Ipop_den_* _Iinc_* _Iworking_*, r
predict fixed_effects, residual

estimates restore speed_results

# delimit 
predict log_speed_hat, xb;
# delimit cr

replace log_speed_hat=log_speed_hat+fixed_effects
g speed_hat=exp(log_speed_hat)

g travel_time_hat=(travel_dist/1609.34)/speed_hat

keep gisjoin zip travel_time_hat

cd $data\travel
save travel_time_hat, replace
