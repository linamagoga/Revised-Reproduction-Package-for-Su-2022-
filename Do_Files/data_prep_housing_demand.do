*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**        Improvements to the Housing Demand       **
**                Generation Do-File               **
*****************************************************


clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"
global temp="/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-"

*******************************************************************************
**# Se generan bases de datos necesarias para correr el código:
*******************************************************************************

*** Medida de ingreso para generar la demanda de vivienda:

/* 
Se encontraba en do data_prep_various_measures y se movió acá para poder correr los do's en el orden en el que especifica el autor en el Readme.
*/

cd $data/ipums_micro
u 1990_2000_2010_temp , clear

* Se limpia base:
drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

* Se genera una variable que traiga los ingresos totales de ese año a términos reales de 2010:

/*
IPC 1990 USA: 130.7
IPC 2000 USA: 172.2
IPC 2010 USA: 218.056 
*/
g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010

* Se divide entre 52 el ingreso total ya que se quiere saber cual es el ingreso semanal de los individuos. Se divide por 40 ya que se quiere saber cuanto salario gana por hora la persona:
g wage_real=inctot_real/(52*40)

* Se generan variables que almacenen los ingresos reales y salarios totales de cada año en variables diferentes:
g inc_mean1990=inctot_real if year==1990
g inc_mean2000=inctot_real if year==2000
g inc_mean2010=inctot_real if year==2010

g wage_real1990=wage_real if year==1990
g wage_real2000=wage_real if year==2000
g wage_real2010=wage_real if year==2010


*Se genera una variable que sume el número de personas por ocupación para ese año y se almacena la información de cada año en variables diferentes:
bysort occ2010 year: egen count=count(perwt) 

g count1990=count if year==1990
g count2000=count if year==2000
g count2010=count if year==2010

*Se agrega la base a nivel ocupación con las variables generadas anteriormente:
collapse (mean) count1990 count2000 count2010 inc_mean1990 inc_mean2000 inc_mean2010 wage_real1990 wage_real2000 wage_real2010  [w=perwt], by(occ2010)
cd $temp/temp_files
save inc_occ_1990_2000_2010, replace


*******************************************************************************
**# Se juntan distintas bases:
*******************************************************************************

cd $temp/temp_files
u tract_impute_share, clear

***Se junta con otras bases de datos:

* Base de ingreso a nivel ocupación para los años 1990, 2000 y 2010:
cd $temp/temp_files
merge m:1 occ2010 using inc_occ_1990_2000_2010
keep if _merge==3
drop _merge
drop count* wage_real1990 wage_real2000 wage_real2010

* Base de salario por área metropolitana:
cd $temp/bases_missing
merge m:1 occ2010 metarea using wage_metarea
keep if _merge==3
drop _merge

***Se genera una variable que sea igual al ingreso promedio de la gente que trabaja en esa ocupación por MSA:
g inc1990=impute_share1990*inc_mean1990*count1990
g inc2010=impute_share2010*inc_mean2010*count2010

***Se agrega la base de datos a nivel área metropolitana:
collapse (sum) inc1990 inc2010, by(gisjoin metarea)

***Se genera una variable que exprese el cambio porcentual de los ingresos del área metropolitana de 2010 respecto a 1990. Se almacena en nueva base de datos:
g ddemand=ln(inc2010)-ln(inc1990)
keep gisjoin ddemand
cd $temp/temp_files
save ddemand, replace
