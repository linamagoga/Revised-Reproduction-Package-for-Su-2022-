*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**           Improvements to the Skill Ratio       **
**                Generation Do-File               **
*****************************************************

clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"
global temp="/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-"


*******************************************************************************
**# Se generan base de datos necesarias para correr el código:
** Este proceso estaba antes en do file various measures pero según el orden del autor este do se debe correr primero por lo que se pasó la creación de esta base a este código:
*******************************************************************************

*** Base número de personas en cada ocupación por área metropolitana:

cd $data/ipums_micro
u 1990_2000_2010_temp , clear

* Se limpia la base:
drop wage distance tranwork trantime pwpuma ownershp ownershpd gq
drop if uhrswork<30
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

* Se crea la variable count que suma el número de personas de acuerdo a la ocupación, área metropolitana y año:
bysort metarea occ2010 year: egen count=total(perwt) 

* Se almacena el conteo en diferentes variables de acuerdo con el año y se organiza la base para que quede una fila por cada ocupación dentro de un metarea. 
g count1990=count if year==1990
g count2000=count if year==2000
g count2010=count if year==2010

collapse (mean) count1990 count2000 count2010 [w=perwt], by(metarea occ2010)

cd $temp/temp_files

save count_metarea, replace


*******************************************************************************
**# Junta diferentes bases de datos:
*******************************************************************************

** Se abre base de datos que almacena la proporción de población por ocupación para cada tract respecto al MSA:
cd $temp/temp_files
u tract_impute_share, clear

/* No se sabe de donde sale esta base de datos que junta con la base de tract_impute_share. No aparece como raw data y en ninguno de los do-files la genera */


*** Base salario por metarea:
cd $temp/bases_missing
merge m:1 occ2010 metarea using wage_metarea
keep if _merge==3
drop _merge
drop count*

*** Base nivel de habilidad para cada ocupación basada en la proporción de personas que que fueron a universidad por cada ocupación en 1990:
cd $temp/temp_files
merge m:1 occ2010 using high_skill
keep if _merge==3
drop _merge

*** Base número de personas en cada ocupación por área metropolitana:
cd $temp/temp_files
merge m:1 occ2010 metarea using count_metarea
keep if _merge==3
drop _merge

*******************************************************************************
**# Generación de variables:
*******************************************************************************

*** Se genera una variable que diga el número de personas que trabajan en ocupaciones con altas habilidades para cada año:
g impute2010_high=impute_share2010*count2010*high_skill
g impute2000_high=impute_share2000*count2000*high_skill
g impute1990_high=impute_share1990*count1990*high_skill

*** Se genera una variable que diga el número de personas que trabajan en ocupaciones con bajas habilidades para cada año:
g impute2010_low=impute_share2010*count2010*(1-high_skill)
g impute2000_low=impute_share2000*count2000*(1-high_skill)
g impute1990_low=impute_share1990*count1990*(1-high_skill)

*** Se organiza la base de datos para que queden el número de personas de acuerdo con área metropolitana y census tract (se deja de lado la población por ocupación):
collapse (sum) impute2010_high impute2010_low impute2000_high impute2000_low impute1990_high impute1990_low, by(metarea gisjoin)
cd $temp/temp_files
save skill_pop, replace

*** Se genera una variable que sea el cambio porcentual de la proporción de personas que trabajan en ocupaciones que requieren alta habilidad respecto a baja habilidad entre el 2010 y 1990::
cd $temp/temp_files
u skill_pop, clear

g dratio=ln( impute2010_high/ impute2010_low)-ln( impute1990_high/ impute1990_low)
keep gisjoin dratio

save skill_ratio_occupation, replace
