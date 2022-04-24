*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**      Improvements to the Job Distribution       **
**                Generation Do-File               **
*****************************************************


clear all
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"

*******************************************************************************
**# Participación de cada ocupación en la industria a la que pertenece por año
*******************************************************************************

cd $data/ipums_micro
use 1990_2000_2010_temp, clear

cd"/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"

**perwt representa el número de individuos en la población representados por esa observación. Se suma el número de individuos de acuerdo a la clasificación de ocupación de 2010, la industria de acuerdo con la clasificación de 1990 y el año:
collapse (sum) pop=perwt, by(year ind1990 occ2010)
save ind1990_2010, replace

**Se suma la población de acuerdo con el año y la industria:
collapse (sum) pop_ind1990=pop, by(year ind1990)

**Se junta la base de datos que almacena la población por industria y la población por ocupación. Se limpia la base:
merge 1:m year ind1990 using ind1990_2010
drop _merge
drop if ind1990==0

**Se crea una nueva variable igual a la proporción de la población en una ocupación respecto a la proporción de la población de acuerdo a la industria. Se limpia la base:
g occ_share=pop/pop_ind1990
drop pop pop_ind1990
sort year ind1990 occ2010
save occ_share_perind, replace

**Se genera una base de datos de cada proporción para cada año:

foreach num of numlist 1990(10)2010{
	u occ_share_perind, clear
	keep if year==`num'
	save occ_share_perind`num', replace
}
/* Se optimizó el proceso con un loop. */

*******************************************************************************
**# Descomposición del cruce del CIC-NAICS:

**El IPUMS utiliza el CIC (Census Industry Code). Las bases de datos de información de la industria respecto al zipcode en el que se localizan para 2000 y 2010 utiliza el NAICS (North American Industry Classification System), por lo que es necesario desagregarlo para poder utilizarlo en la limpieza de esta base de datos. 
*******************************************************************************

cd $data/zbp
import excel cic1990_naics97.xlsx, sheet("Sheet1") firstrow clear
drop C

**Limpieza de la variable NAICS:
tostring NAICS, g(naics)
unique naics
duplicates report NAICS
drop NAICS

**Limpieza de la variable CIC: 
destring Census, g(ind1990)
*Se renombra la variable que indica el nombre de la categoría de la industria:
ren Census2000CategoryTitle naics_descr
keep ind1990 naics  naics_descr
*Se genera una variable que represente la longitud del código NAICS:
g digit=length(naics)
*Se almacena en una nueva base de datos:
cd"/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"
save cic1990_naics97, replace

**Se almacena la información para cada longitud del NAICS en una nueva base de datos:
foreach num of numlist 6/2{
	u cic1990_naics97, clear
	keep if digit== `num'
	ren naics naics`num'
	save cic1990_naics97_`num'digit, replace
}
/* Se optimizó el proceso con un loop. */


*******************************************************************************
**# Descomposición del cruce del CIC-SIC:

**El IPUMS utiliza el CIC (Census Industry Code). Las bases de datos de información de la industria respecto al zipcode en el que se localizan para 1994 utiliza el SIC (Standard Industrial Classification), por lo que es necesario desagregarlo para poder utilizarlo en la limpieza de esta base de datos. 
*******************************************************************************

cd $data/zbp
import excel cic_sic_crosswalk.xlsx, sheet("Sheet1") firstrow allstring clear

**Limpieza de la base de datos:
destring cic_code, g(ind1990)
drop cic_code
*Se genera una variable que represente la longitud del código SIC:
g digit=length(sic)
*Se almacena en una nueva base de datos:
cd"/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"
save cic_sic_crosswalk, replace

**Se almacena la información para cada longitud del SIC en una nueva base de datos:
foreach num of numlist 4/2{
	u cic_sic_crosswalk, clear
	keep if digit== `num'
	ren sic sic`num'
	drop digit
	save cic_sic_crosswalk`num'digit, replace		
}

	
*******************************************************************************
**# Número de Empleados para cada Ocupación de Acuerdo al Zip Code para 1990. 
*******************************************************************************

cd $data/zbp
u zip94detail, clear

/* Descripción de las variables: 
EST Total Number of Establishments

N1_4 Number of Establishments: Employment Size Class: 1-4 Employees
N5_9 Number of Establishments: Employment Size Class: 5-9 Employees
N10_19 Number of Establishments: Employment Size Class: 10-19 Employees
N20_49 Number of Establishments: Employment Size Class: 20-49 Employees
N50_99 Number of Establishments: Employment Size Class: 50-99 Employees
N100_249 Number of Establishments: Employment Size Class: 100-249 Employees      
N250_499 Number of Establishments: Employment Size Class: 250-499 Employees
N500_999 Number of Establishments: Employment Size Class: 500-999 Employees
N1000 Number of Establishments: Employment Size Class: 1,000 Or More Employees
*/

**Se genera una variable que represente el número de personas trabajando en cada tipo de establecimiento. Este procedimiento se hace multiplicando el número de establecimientos por la mediana del número de personas que trabajan en ese establecimiento. Se suma el número de personas empleadas para cada zip-sic: 
g n1_4_num=2.5*n1_4
g n5_9_num=7*n5_9
g n10_19_num=14.5*n10_19
g n20_49_num=34.5*n20_49
g n50_99_num=74.5*n50_99
g n100_249_num=174.5*n100_249
g n250_499_num=374.5*n250_499
g n500_999_num=749.5*n500_999
g n1000_num=1500*n1000
g est_num=n1_4_num+n5_9_num+n10_19_num+n20_49_num+n50_99_num+n100_249_num+n250_499_num+n500_999_num+n1000_num

**Se limpia la variable sic eliminando aquellos valores cuyos números no estén completos:
g lastdigit=substr(sic,4,1)
drop if lastdigit=="-"
drop if lastdigit=="\"

**Para cada longitud del sic se junta la base de datos que cruza los datos SIC-CIC con el número de la población para 1994:
cd"/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"

foreach num of numlist 4/2{
	g sic`num'=substr(sic,1,`num')
	merge m:1 sic`num' using cic_sic_crosswalk`num'digit
	ren (_merge ind1990) (_merge_`num'digit ind1990_`num'digit)
	}

/* Se optimiza el proceso con un loop */.

**Se genera una nueva variable que almacene el código de industria de 2, 3 y 4 dígitos.
g ind1990=ind1990_2digit if _merge_2digit==3
replace ind1990=ind1990_3digit if _merge_3digit==3
replace ind1990=ind1990_4digit if _merge_4digit==3

**Se limpia la base de datos:
drop if ind1990==.
drop if zip==.
drop _merge_2digit ind1990_2digit sic2 _merge_3digit ind1990_3digit sic3 _merge_4digit ind1990_4digit sic4 lastdigit

**Se suma el número de empleados para cada industria ubicada en un zipcode particular:
collapse (sum) est_num, by(zip ind1990)

**Se divide el grupo de zip codes para hacer más sencillo al programa el cálculo. Une dos bases de datos con el indicador ind1990 (la base que tiene la proporción de ocupación respecto a industria y la base que tiene el número de empleados por industria para cada zip code). Se almacena en una nueva base de datos: 
cd "/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"
save temp, replace
forvalues i = 0(20000)80000{
	u temp, clear
	local nombre= `i' + 20000
	keep if zip>=`i' & zip<`nombre'
	joinby ind1990 using occ_share_perind1990
	replace est_num=est_num*occ_share
	collapse (sum) est_num, by(zip occ2010)
	save temp`i'_`nombre', replace 	
}

**Se pegan las bases generadas anteriormente para obtener una que tenga la ocupación y el número de personas que trabajan en esa ocupación para cada zip code:
clear all
forvalues i=0(20000)80000{
	local nombre= `i' + 20000
	append using temp`i'_`nombre'	
	}

**Se genera una variable de año y se guarda la base:
g year=1990
save occ_emp_1990, replace
/* Se generan loops para optimizar el proceso */.

*******************************************************************************
**# Número de Empleados para cada Ocupación en Zip Code para 2000, 2010. 
*******************************************************************************

** El proceso es similar a lo anterior por lo que no se repetira la descripción.

**Se genera un loop para realizar todo el proceso ya que las bases del 2000 y 2010 utilizan el NAICS.

local ano 00 10
foreach x in `ano'{
	cd $data/zbp
	display `x'
	u zip`x'detail, clear
	g n1_4_num=2.5*n1_4
	g n5_9_num=7*n5_9
	g n10_19_num=14.5*n10_19
	g n20_49_num=34.5*n20_49
	g n50_99_num=74.5*n50_99
	g n100_249_num=174.5*n100_249
	g n250_499_num=374.5*n250_499
	g n500_999_num=749.5*n500_999
	g n1000_num=1500*n1000
	g est_num=n1_4_num+n5_9_num+n10_19_num+n20_49_num+n50_99_num+n100_249_num+	n250_499_num+n500_999_num+n1000_num
		
	g lastdigit=substr(naics,6,1)
	drop if lastdigit=="-"
	drop lastdigit
	
	sort naics
	
	cd "/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"
	foreach num of numlist 6/2{
		g naics`num'=substr(naics,1,`num')
		merge m:1 naics`num' using cic1990_naics97_`num'digit
		ren (_merge ind1990) (_merge_`num'digit ind1990_`num'digit)
		}
		drop naics`num' digit naics_descr

		
	g ind1990=ind1990_2digit if _merge_2digit==3
	replace ind1990=ind1990_3digit if _merge_3digit==3
	replace ind1990=ind1990_4digit if _merge_4digit==3
	replace ind1990=ind1990_5digit if _merge_5digit==3
	replace ind1990=ind1990_6digit if _merge_6digit==3
	
	drop if ind1990==.
	drop if zip==.
	drop ind1990_6digit _merge_6digit ind1990_5digit _merge_5digit ind1990_4digit _merge_4digit ind1990_3digit _merge_3digit ind1990_2digit _merge_2digit
	
	collapse (sum) est_num, by(zip ind1990)
	save temp, replace
	
	forvalues i = 0(20000)80000{
		u temp, clear
		local nombre= `i' + 20000
		keep if zip>=`i' & zip<`nombre'
		joinby ind1990 using occ_share_perind20`x'
		replace est_num=est_num*occ_share
		collapse (sum) est_num, by(zip occ2010)
		save temp`i'_`nombre', replace 	
	}

	clear all
	forvalues i=0(20000)80000{
		local nombre= `i' + 20000
		append using temp`i'_`nombre'	
		}

	g year = 2000
	save occ_emp_20`x', replace
}
/* Se generan loops para optimizar el proceso */.

*******************************************************************************
**# Génerar la participació de empleo de cada zip code en el metarea. 
*******************************************************************************

forvalues i=1990(10)2010{
	*Para los años 1990, 2000 y 2010, se junta la base que almacena el número 
	*de empleados para cada ocupación por cada zip code y los zip codes que 
	*hacen parte de un área metropolitana.
	cd "/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"
	u occ_emp_`i', clear
	
	cd $data/geographic
	
	merge m:1 zip using zip`i'_metarea
	keep if _merge==3
	drop _merge
	cd "/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"
	save temp, replace
	
	*Se suma el número de empleados para cada ocupación en cada área 
	*metropolitana. Se genera una variable que sea la proporción de empleados 
	*por ocupación para cada zip respecto a la proporción de empleados por 
	*ocupación para cada área metropolitana. Se almacena en una nueva variable
	*y se genera una nueva base de datos.
	
	collapse (sum) est_num_total=est_num, by(occ2010 metarea)
	merge 1:m occ2010 metarea using temp
	drop _merge
	g share=est_num/est_num_total
	keep share zip occ2010 metarea

	save occ_emp_share_`i', replace
	
}
/* Se generan loops para optimizar el proceso */
