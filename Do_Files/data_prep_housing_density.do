*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**        Improvements to the Housing Density      **
**                Generation Do-File               **
*****************************************************

clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"
global temp="/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-"


********************************************************************************
**# Se genera una base que almacene el área del tract para 1980:
********************************************************************************

*** import area (1980 census tract)
cd $data/geographic
import delimited UStract1980.csv, varnames(1) clear 

** Se limpia la base:
keep gisjoin area_sm
destring area_sm, g(area) ignore(",")
keep gisjoin area
cd $data/geographic

** Se almacena la base:
cd $data/geographic
save area1980, replace

********************************************************************************
**# Número de vivienda en 1980:
********************************************************************************

cd $data/nhgis
import delimited nhgis0034_ds107_1980_tract.csv, clear

** Se limpia la base:
ren def001 room
keep gisjoin room
sort gisjoin
cd $temp/temp_files
save room1980, replace

********************************************************************************
**# Densidad habitacional usando datos de 1980:
********************************************************************************

cd $data/geographic
u tract1990_tract1980_1mi, clear

** Se limpia base:
ren gisjoin2 gisjoin

** Se junta con base que almacena el área del tract para 1980:
cd $data/geographic
merge m:1 gisjoin using area1980
drop _merge

** Se junta con base que almacena la vivienda en 1980:
cd $temp/temp_files
merge m:1 gisjoin using room1980
drop _merge

** Se hace un collapse de la base sumando el área y vivienda por identificador de census tract:
collapse (sum) area room, by(gisjoin1)

** Se genera una variable que sea igual al número de vivienda  de cada tract sobre el área del tract para ver:
g room_density_1mi_3mi=(room)/(area)
replace room_density_1mi_3mi=0 if room_density_1mi_3mi==.
ren gisjoin1 gisjoin

** Se almacena en nueva base:
save room_density1980_1mi, replace
