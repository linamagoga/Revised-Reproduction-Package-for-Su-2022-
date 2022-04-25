*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**           Improvements to the Prep Rent         **
**                Generation Do-File               **
*****************************************************

clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"
global temp="/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-"

*** 1990:

** Se abre base:
cd $data/nhgis
import delimited nhgis0018_ds120_1990_tract.csv, clear
******************************************************************************
**# Se almacena en diferentes bases la renta traída a precios reales de 2010:
******************************************************************************


**Se renombran las variables para que se entienda que significa y se mantienen solo esas variables. Se organiza la base por el identificador único: 
ren (est001 es6001) (hp rent)
keep gisjoin hp rent
sort gisjoin

**Está trayendo el precio de la vivienda y el valor de la renta de 1990 en términos de precios reales del 2010:
/*
IPC 1990 USA: 130.7
IPC 2000 USA: 172.2
IPC 2010 USA: 218.056 
*/
replace hp=hp*218.056/130.7
replace rent=rent*218.056/130.7

** Se almacena en una nueva base:
cd $temp/temp_files
save rent1990, replace


/** Se realiza el mismo para proceso para la base del 2000 y 2010. No se optimiza el proceso mediante un loop porque el nombre de las variables en cada base son diferentes. No se describirá el proceso al ser el mismo. */

*** 2000:

cd $data/nhgis
import delimited nhgis0018_ds151_2000_tract.csv, clear
ren (gb7001 gbg001) (hp rent)
keep gisjoin hp rent
sort gisjoin
replace hp=hp*218.056/172.2
replace rent=rent*218.056/172.2
cd $temp/temp_files
save rent2000, replace

*** 2010:

cd $data/nhgis
import delimited nhgis0018_ds184_20115_2011_tract.csv, clear 
ren (muje001 mu2e001) (rent hp)
keep gisjoin hp rent
sort gisjoin
cd $temp/temp_files
save rent2010, replace

******************************************************************************
**# Se genera base de datos que tenga la renta:
******************************************************************************

** Se abre base de datos que cruza la información de tract de 1990 y 2010:
cd $data/geographic
u tract1990_tract2010_nearest, clear
*Se limpia: 
ren gisjoin1 gisjoin

** Se junta esta base con las bases que tienen información de la renta para 1990 y 2010:

foreach num of numlist 1990 2010{
	cd $temp/temp_files
	merge m:1 gisjoin using rent`num'
	keep if _merge==3
	drop _merge
	ren rent rent`num'
	
	if `num' == 1990{
		ren gisjoin gisjoin1
		ren gisjoin2 gisjoin
	}
	else{
		drop gisjoin
	}
}

** Se junta la base generada con las bases que tienen información de tract de 1990 y 2000:
cd $data/geographic
merge 1:1 gisjoin1 using tract1990_tract2000_nearest
keep if _merge==3
drop _merge
ren gisjoin2 gisjoin

** Se junta la base generada con la base que tiene información de la renta para 2000:
cd $temp/temp_files
merge m:1 gisjoin using rent2000
keep if _merge==3
drop _merge 
ren rent rent2000
drop gisjoin
ren gisjoin1 gisjoin
keep gisjoin rent*
save rent, replace


******************************************************************************
**# Reemplazar valores de renta missing con la renta promedio a nivel MSA:
******************************************************************************

** Se abre base:
cd $temp/temp_files
u rent, clear

**Se junta con base que cruza información del tract de 1990 con el área metropolitana:
cd $data/geographic
merge 1:1 gisjoin using tract1990_metarea
cd $temp/temp_files
keep if _merge==3
drop _merge
save temp, replace


** Se genera el promedio de la renta para cada uno de los años de acuerdo con área metropolitana y se almacena en una nueva base de datos:
collapse mean_rent1990=rent1990 mean_rent2000=rent2000 mean_rent2010=rent2010, by(metarea)
save rent_metarea, replace

** Se junta este promedio de renta por área metropolitana con la renta para cada tract:
merge 1:m metarea using temp
drop _merge

** Se limpia la base:
*Para valores de renta que no tiene información, reemplace su valor con el promedio de la renta en esa área metropolitana:
forvalues x=1990(10)2010{
replace rent`x'=mean_rent`x' if rent`x'==0 | rent`x'==.
}
keep gisjoin rent2010 rent2000 rent1990
sort gisjoin

** Se almacena la base de datos:
save rent, replace
