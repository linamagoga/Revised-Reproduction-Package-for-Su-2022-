*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**       Improvements to the Location Choice       **
**                Generation Do-File               **
*****************************************************

clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"
global temp="/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-"


*******************************************************************************
**# Cruce entre el grupo de ocupación y la ocupación
*******************************************************************************

*******************************************************************************
**Se agrupan las ocupaciones del IPUMS por grupo de ocupación del NHGIS de 1990.
*******************************************************************************

*1) Se agrupan las ocupaciones en grupos y se almacenan en una base temporal:


***Para 1990:

cd $data/ipums_micro
u 1990_2000_2010_temp if year==1990, clear
replace puma = puma1990
drop puma1990

g occ1990_group=1 if occ1990>=0 & occ1990<=42
replace occ1990_group=2 if occ1990>=43 & occ1990<=202
replace occ1990_group=3 if occ1990>=203 & occ1990<=242
replace occ1990_group=4 if occ1990>=243 & occ1990<=302
replace occ1990_group=5 if occ1990>=303 & occ1990<=402
replace occ1990_group=6 if occ1990>=403 & occ1990<=412
replace occ1990_group=7 if occ1990>=413 & occ1990<=432
replace occ1990_group=8 if occ1990>=433 & occ1990<=472
replace occ1990_group=9 if occ1990>=473 & occ1990<=502
replace occ1990_group=10 if occ1990>=503 & occ1990<=702
replace occ1990_group=11 if occ1990>=703 & occ1990<=802
replace occ1990_group=12 if occ1990>=803 & occ1990<=863
replace occ1990_group=13 if occ1990>=864 & occ1990<=902
replace occ1990_group=14 if occ1990==999

cd $temp/temp_files
save temp_1990, replace

***Para 2000:

/* Número: Grupo Ocupación 2000*/
/*
1: Management
2: Profesional
3: Salud
4: Protección
5: Preparación comida
6: Mantenimiento y limpieza de construcciones
7: Cuidado personal
8: Ventas
9: Oficina y administrativos
10: Farming
11: Pesca
12: Construcción y extracción
13: Instalación
14: Producción
15: Transporte
*/

cd $data/ipums_micro
u 1990_2000_2010_temp if year==2000, clear

g occ2000_group=1 if occ>=1 & occ<=95
replace occ2000_group=2 if occ>=100 & occ<=354
replace occ2000_group=3 if occ>=360 & occ<=365
replace occ2000_group=4 if occ>=370 & occ<=395
replace occ2000_group=5 if occ>=400 & occ<=413
replace occ2000_group=6 if occ>=420 & occ<=425
replace occ2000_group=7 if occ>=430 & occ<=465
replace occ2000_group=8 if occ>=470 & occ<=496
replace occ2000_group=9 if occ>=500 & occ<=593
replace occ2000_group=10 if occ>=600 & occ<=605
replace occ2000_group=11 if occ>=610 & occ<=613
replace occ2000_group=12 if occ>=620 & occ<=694
replace occ2000_group=13 if occ>=700 & occ<=762
replace occ2000_group=14 if occ>=770 & occ<=896
replace occ2000_group=15 if occ>=900 & occ<=975

cd $temp/temp_files
save temp_2000, replace

***Para 2010:

/* Número: Grupo Ocupación 2000*/
/*
5:  
6:  Negocios y finanzas
8:  Computación y matemáticas
9:  Arquitectura e ingenieria
10: Ciencias físicas, sociales o biológicas
12: Servicio social y comunitario
13: Legal
14: Educacción, entrenamiento y biblioteca
15: Arte, diseño, entretenimiento, deporte y media
16: Diagnóstico en salud, médicos tratantes y otros técnicos
20: Técnicos y tecnólogos en Salud
21: Protección: bombero, etc.
24: Preparación comida
25: Mantenimiento y limpieza de construcciones
26: Cuidado personal
28: Ventas
29: Oficina y administrativos
31: Farming, Pesca y Forestry
32: Construcción y extracción
33: Instalación, mantenimiento y reparaciones
35: Producción
36: Transporte
37: Material moviendo ocupaciones
38: Desempleado
*/

cd $data/ipums_micro
u 1990_2000_2010_temp if year==2010, clear

g occ2010_group=5 if occ2010>=10 & occ2010<=430
replace occ2010_group=6 if occ2010>=500 & occ2010<=950
replace occ2010_group=8 if occ2010>=1000 & occ2010<=1240
replace occ2010_group=9 if occ2010>=1300 & occ2010<=1560
replace occ2010_group=10 if occ2010>=1600 & occ2010<=1980
replace occ2010_group=12 if occ2010>=2000 & occ2010<=2060
replace occ2010_group=13 if occ2010>=2100 & occ2010<=2150
replace occ2010_group=14 if occ2010>=2200 & occ2010<=2550
replace occ2010_group=15 if occ2010>=2600 & occ2010<=2920
replace occ2010_group=16 if occ2010>=3000 & occ2010<=3540
replace occ2010_group=20 if occ2010>=3600 & occ2010<=3650
replace occ2010_group=21 if occ2010>=3700 & occ2010<=3950
replace occ2010_group=24 if occ2010>=4000 & occ2010<=4150
replace occ2010_group=25 if occ2010>=4200 & occ2010<=4250
replace occ2010_group=26 if occ2010>=4300 & occ2010<=4650
replace occ2010_group=28 if occ2010>=4700 & occ2010<=4965
replace occ2010_group=29 if occ2010>=5000 & occ2010<=5940
replace occ2010_group=31 if occ2010>=6005 & occ2010<=6130
replace occ2010_group=32 if occ2010>=6200 & occ2010<=6940
replace occ2010_group=33 if occ2010>=7000 & occ2010<=7630
replace occ2010_group=35 if occ2010>=7700 & occ2010<=8965
replace occ2010_group=36 if occ2010>=9000 & occ2010<=9420
replace occ2010_group=37 if occ2010>=9510 & occ2010<=9750
replace occ2010_group=38 if occ2010==9920

cd $temp/temp_files
save temp_2010, replace

/* Se generan loops para optimizar el proceso posterior para 1990, 2000 y 2010 */

forvalues x=1990(10)2010{

*2) Partiendo de esta base, se cruzan los grupos generados de ocupación de 1990 con los grupos por ocupcación de 2010. Se genera una base que tenga el grupo para 1990 y la ocupación para 2010.

*Se agrupa el número de hogares por grupo de ocupación y ocupación:
cd $temp/temp_files
u temp_`x', clear
g a=1
collapse (count) count=a, by(occ2010 occ`x'_group)
*Se ordena de acuerdo a la ocupación y se calcula el valor máximo de observaciones dentro de una ocupación y en que posición se encuentra dentro de esta observación. De esta forma si hay duplicados se está eliminando aquel que tiene un menor número de personas trabajando en esa ocupación:
sort occ2010 count
by occ2010: g max=_N
by occ2010: g rank=_n
keep if max==rank
keep occ2010 occ`x'_group
sort occ2010 occ`x'_group
save occ_occ_group`x', replace

*3) Se agrupa el número de hogares por Estado, PUMA, ocupación del 2010 y grupo de ocupación de 1990 particular:
cd $temp/temp_files
u temp_`x', clear
collapse (count) count=serial, by(statefip puma occ2010 occ`x'_group)
drop if occ2010==9920
drop if occ`x'_group==.
save temp1, replace

*4) Se agrupa el número de hogares por Estado, PUMA y grupo de ocupación de 1990 particular: 
collapse (sum) count_occ=count, by(statefip puma occ`x'_group)

*5) Se junta la base de datos que contiene el número de hogares Estado, PUMA y grupo de ocupación de 1990 particular y la base que agrupa por esto y adicionalmente por la ocupación en el 2010:
merge 1:m statefip puma occ`x'_group using temp1
drop _merge

*6) Se genera una nueva variable que calcule la proporción de la población que trabaja en cada ocupación del grupo de ocupación: 
g occ_group_share=count/ count_occ
keep statefip puma occ2010 occ`x'_group occ_group_share

*7) Se almacena esto en una nueva base de datos:
cd $temp/temp_files
save occ_group_share`x', replace
}

*******************************************************************************
**# Escogencia de ubicación por ocupación:

/* Estas bases contiene la probilidad de escoger ubicación de los trabajadores para cada ocupación en cada MSA para cada año. */
*******************************************************************************

***1990:

*Significado de las variables con las que se trabajaran (grupo de ocupación):
/*
gisjoin: identificador que incluye Estado, County, Census Tract, Census Block
e4q001: Managerial and professional (000-202): Executive, administrative
e4q002: Managerial and professional (000-202): Professional specialist
e4q003: Technical, sales, administrative support (203-402): Technicians
e4q004: Technical, sales, administrative support (203-402): Sales occupation
e4q005: Technical, sales, administrative support (203-402): Administratitive
e4q006: Service occupations (403-472): Private household occupations (403-412)
e4q007: Service occupations (403-472): Protective service occupations (413-432)
e4q008: Service occupations (403-472): Service occupations, except protective and househ
e4q009: Farming, forestry, fishing occupations (473-502)
e4q010: Precision production, craft, and repair occupations (503-702)
e4q011: Operators, fabricators,laborers (703-902): Machine operators, assembler
e4q012: Operators, fabricators,laborers (703-902): Transportation, material mov
e4q013: Operators, fabricators,laborers (703-902): Handlers, equipment cleaners
*/



*1) Se junta la base de datos de ocupación para 1990 de la nhgis con la base de datos que almacena la equivalencia entre los PUMA y los tracts para ese año:
*Ocupación NHGIS:
cd $data/nhgis/occupation
import delimited nhgis0013_ds123_1990_tract.csv, clear 
duplicates report gisjoin
sort gisjoin

*Tract-Puma:
cd $data/geographic
merge 1:1 gisjoin using puma1990_tract1990
keep if _merge==3
drop _merge

*Se limpia la base de datos:
drop anrca county year res_onlya trusta aianhha res_trsta blck_grpa tracta cda c_citya countya cty_suba divisiona msa_cmsaa placea pmsaa regiona state statea urbrurala urb_areaa zipa cd103a anpsadpi


*2) Se genera una variable que almacena los datos de la variable e4q0.. que representan el número de personas en cada grupo de ocupación para el tract, dentro del county, dentro del Estado. Se almacena estas variables en una base de datos: 

foreach num of numlist 1(1)9 {
	g occ1990_group`num'=e4q00`num'
}
foreach num of numlist 10(1)13 {
	g occ1990_group`num'=e4q0`num'
}

*Se limpia la base:
drop e4p* e4q*
sort gisjoin
cd $temp/temp_files
save occ_tract1990, replace


*3) Se genera el número de empleados para cada cada grupo de ocupación de acuerdo con el Census tract:
cd $temp/temp_files
u occ_tract1990, clear
keep gisjoin statefip puma occ1990*

*Se cambia la base de datos de formato wide a formato long mediante los identificadores gisjoin, statefip y puma. Se busca que se almacene en una nueva variable group que determine el grupo de ocupación al que pertenece el número de personas:
reshape long occ1990_group, i(gisjoin statefip puma) j(group)

*Se limpia la base:
ren (occ1990_group group) (number_occ1990 occ1990_group)

preserve
*Se suma el número de personas en cada grupo de ocupación en cada tract dentro del puma, county y Estado. Se almacena en una base de datos
collapse (sum) number_tract=number_occ1990, by(gisjoin statefip puma)
save number_tract1990, replace
restore

*4) Se junta la base que identifica el número de personas que trabajan en cada grupo de ocupación de acuerdo con el census tract con la base que cruza la información entre el grupo de ocupación y ocupación partiendo de los identificadores statefip, grupo de ocupación para 1990 y puma:
cd $temp/temp_files
joinby statefip puma occ1990_group using occ_group_share1990

*5) Se imputa el número de empleados por ocupación para cada census tract de 1990 multiplicando el número de personas en cada grupo de ocupación por la proporción de personas que trabajan en cada ocupación dentro del grupo de ocupación al que pertenecen:
g impute=number_occ1990*occ_group_share

*6) Se suma el número de empleados por ocupación de acuerdo con la ocupación, census tract, puma y Estado.
collapse (sum) impute, by(gisjoin statefip puma occ2010)
*Se junta esta base con la base que tiene el grupo de ocupación para 1990 y la ocupación para 2010:
keep gisjoin statefip puma occ2010 impute
*Se limpia la base:
merge m:1 occ2010 using occ_occ_group1990
keep if _merge==3
drop _merge

*7) Para cada identificador gisjoin existen diferentes ocupaciones reportadas. Para que todos tengan los mismas ocupaciones reportadas se utiliza el comando fillin que completa estas ocupaciones y les pone missings. A las observaciones con missing en impute se les pone 0:
fillin gisjoin occ2010
replace impute=0 if impute==.

*Se limpia la base:
drop _fillin statefip puma occ1990_group
replace impute=round(impute)
save tract_impute1990, replace


*** 2000:


*Significado de las variables con las que se trabajaran (grupo de ocupación):
/*
h04001: Male - Management, prof, related occupations: Management, business
h04002: Male - Management, prof, related occupations: Professional and related
h04003: Male - Service: Healthcare support occupations
h04004: Male - Service: Protective service occupations
h04005: Male - Service: Food preparation and serving related occupations
h04006: Male - Service: Building and grounds cleaning and maintenance occup
h04007: Male - Service: Personal care and service occupations
h04008: Male - Sales and office: Sales and related
h04009: Male - Sales and office: Office and administrative support
h04010: Male - Farming, fishing, forestry: Agricultural workers
h04011: Male - Farming, fishing, forestry: Fishing, hunting, and forest
h04012: Male - Construction, extraction, maintenance: Construction
h04013: Male - Construction, extraction, maintenance: Installation
h04014: Male - Production, transportation, material moving: Production 
h04015: Male - Production, transportation, material moving: Transportation
h04016: Female - Management, prof, related occupations: Management, business
h04017: Female - Management, prof, related occupations: Professional and rela
h04018: Female - Service: Healthcare support occupations
h04019  Female - Service: Protective service occupations
h04020: Female - Service: Food preparation and serving related occupations
h04021: Female - Service: Building and grounds cleaning and maintenance occup
h04022: Female - Service: Personal care and service occupations
h04023: Female - Sales and office: Sales and related
h04024: Female - Sales and office: Office and administrative support
h04025: Female - Farming, fishing, forestry: Agricultural workers
h04026: Female - Farming, fishing, forestry: Fishing, hunting, and forest
h04027: Female - Construction, extraction, maintenance: Construction
h04028: Female - Construction, extraction, maintenance: Installation
h04029: Female - Production, transportation, material moving: Production 
h04030: Female - Production, transportation, material moving: Transportation
*/




*1) Se junta la base de datos de ocupación para 2000 de la nhgis con la base de datos que almacena la equivalencia entre los tracts de 1990 y 2000:
cd $data/nhgis/occupation
import delimited nhgis0014_ds153_2000_tract.csv, clear 

*Se limpia la base de datos:
drop year regiona divisiona state statea county countya cty_suba placea tracta trbl_cta blck_grpa trbl_bga c_citya res_onlya trusta aianhha trbl_suba anrca msa_cmsaa pmsaa necmaa urb_areaa cd106a cd108a cd109a zip3a zctaa name
sort gisjoin

*Tract 1990-2000:
cd $data/geographic
merge 1:m gisjoin using tract1990_tract2000
keep if _merge==3
drop _merge

*2) Creación de base que tenga el número de personas en cada grupo de ocupación para el tract:

*Se genera una variable que almacena los datos de la variable h040.. por el porcentaje que representan el número de hombres o mujeres en cada grupo de ocupación para el tract, dentro del county, dentro del Estado: 
foreach num of numlist 1(1)9 {
replace h0400`num'=h0400`num'*percentage
}

foreach num of numlist 10(1)30 {
replace h040`num'=h040`num'*percentage
}

*Se limpia la base eliminando uno de los identificadores únicos que contenia la base:
drop gisjoin
ren gisjoin_1 gisjoin

*Al haber duplicados, se hace un collapse de todas las variables importantes de acuerdo al identificador gisjoin para que para cada census tract quede una observación:
collapse (sum) h04001-h04030 , by(gisjoin)

*Al tenerse desagregada la información para cada grupo por sexo, se suman las observaciones para tener el número total de individuos por grupo de ocupación:
g occ2000_group1=h04001 + h04016
g occ2000_group2=h04002 + h04017
g occ2000_group3=h04003 + h04018
g occ2000_group4=h04004 + h04019
g occ2000_group5=h04005 + h04020
g occ2000_group6=h04006 + h04021
g occ2000_group7=h04007 + h04022
g occ2000_group8=h04008 + h04023
g occ2000_group9=h04009 + h04024
g occ2000_group10=h04010 + h04025
g occ2000_group11=h04011 + h04026
g occ2000_group12=h04012 + h04027
g occ2000_group13=h04013 + h04028
g occ2000_group14=h04014 + h04029
g occ2000_group15=h04015 + h04030

*Para cada variable, se redondea el número de observaciones:
foreach num of numlist 1(1)15 {
replace occ2000_group`num'=round(occ2000_group`num')
}

*Se limpia la base:
drop h04* 
sort gisjoin

*Se junta base creada con base que tiene el cruce del número del Tract con el PUMA:
cd $data/geographic
merge 1:1 gisjoin using puma_tract1990
keep if _merge==3
drop _merge

*Se almacena la base:
cd $temp/temp_files
save occ_tract2000, replace


*3) Se genera el número de empleados para cada cada grupo de ocupación de acuerdo con el Census tract:
cd $temp/temp_files
u occ_tract2000, clear
keep gisjoin statefip puma occ2000*

*Se cambia la base de datos de formato wide a formato long mediante los identificadores gisjoin, statefip y puma. Se busca que se almacene en una nueva variable group que determine el grupo de ocupación al que pertenece el número de personas:
reshape long occ2000_group, i(gisjoin statefip puma) j(group)

*Se limpia la base:
ren (occ2000_group group) (number_occ2000 occ2000_group)

preserve
*Se suma el número de personas en cada grupo de ocupación en cada bloque dentro del tract, puma, county y Estado. Se almacena en una base de datos:
collapse (sum) number_tract=number_occ2000, by(gisjoin statefip puma)
save number_tract2000, replace
restore

*4) Se junta la base que identifica el número de personas que trabajan en cada grupo de ocupación de acuerdo con el census tract con la base que cruza la información entre el grupo de ocupación y ocupación partiendo de los identificadores statefip, grupo de ocupación para 2000:
cd $temp/temp_files
joinby statefip puma occ2000_group using occ_group_share2000

*5) Se imputa el número de empleados por ocupación para cada census tract de 2000 multiplicando el número de personas en cada grupo de ocupación por la proporción de personas que trabajan en cada ocupación dentro del grupo de ocupación al que pertenecen:
g impute=number_occ2000*occ_group_share

*6) Se suma el número de empleados por ocupación de acuerdo con la ocupación, census tract, puma y Estado.
collapse (sum) impute, by(gisjoin statefip puma occ2010)
*Se junta esta base con la base que tiene el grupo de ocupación para 2000 y la ocupación para 2010:
keep gisjoin statefip puma occ2010 impute
*Se limpia la base:
merge m:1 occ2010 using occ_occ_group2000
keep if _merge==3
drop _merge

*7) Para cada identificador gisjoin existen diferentes ocupaciones reportadas. Para que todos tengan los mismas ocupaciones reportadas se utiliza el comando fillin que completa estas ocupaciones y les pone missings. A las observaciones con missing en impute se les pone 0:
fillin gisjoin occ2010
replace impute=0 if impute==.

*Se limpia la base:
replace impute=round(impute)
keep gisjoin occ2010 impute 
save tract_impute2000, replace

*** 2010:


*1) Se junta la base de datos de ocupación para 2010 de la nhgis con la base de datos que almacena la equivalencia entre los tracts de 1990 y 2010:

*Ocupación NHGIS:
cd $data/nhgis/occupation
import delimited nhgis0013_ds184_20115_2011_tract.csv, clear 


*Tract 1990-2010:
cd $data/geographic
merge 1:m gisjoin using tract1990_tract2010
keep if _merge==3
drop _merge

*Se limpia la base de datos:
drop year regiona divisiona state statea county countya name_m cousuba placea tracta blkgrpa concita aianhha res_onlya trusta aitscea anrca cbsaa csaa metdiva nectaa cnectaa nectadiva uaa cdcurra sldua sldla zcta5a submcda sdelma sdseca sdunia puma5a bttra btbga name_e


*2) Creación de base que tenga el número de personas en cada grupo de ocupación para el tract:

*Se genera una variable que almacena los datos de la variable mspe0..., ms=e0.. por el porcentaje que representan el número de hombres o mujeres en cada grupo de ocupación para el tract, dentro del county, dentro del Estado: 
foreach num of numlist 1(1)9 {
replace mspe00`num'=mspe00`num'*percentage
}

foreach num of numlist 10(1)73 {
replace mspe0`num'=mspe0`num'*percentage
}


foreach num of numlist 1(1)9 {
replace ms0e00`num'=ms0e00`num'*percentage
}

foreach num of numlist 10(1)55 {
replace ms0e0`num'=ms0e0`num'*percentage
}

*Se limpia la base eliminando uno de los identificadores únicos que contenia la base:
drop gisjoin
ren gisjoin_1 gisjoin

*Al haber duplicados, se hace un collapse de todas las variables importantes de acuerdo al identificador gisjoin para que para cada census tract quede una observación:
collapse (sum) mspe001-mspe073, by(gisjoin)

*Al tenerse desagregada la información para cada grupo por sexo, se suman las observaciones para tener el número total de individuos por grupo de ocupación:
g occ2010_group1=mspe001
g occ2010_group2=mspe002+mspe038
g occ2010_group3=mspe003+mspe039
g occ2010_group4=mspe004+mspe040
g occ2010_group5=mspe005+mspe041
g occ2010_group6=mspe006+mspe042
g occ2010_group7=mspe007+mspe043
g occ2010_group8=mspe008+mspe044
g occ2010_group9=mspe009+mspe045
g occ2010_group10=mspe010+mspe046
g occ2010_group11=mspe011+mspe047
g occ2010_group12=mspe012+mspe048
g occ2010_group13=mspe013+mspe049
g occ2010_group14=mspe014+mspe050
g occ2010_group15=mspe015+mspe051
g occ2010_group16=mspe016+mspe052
g occ2010_group17=mspe017+mspe053
g occ2010_group18=mspe018+mspe054
g occ2010_group19=mspe019+mspe055
g occ2010_group20=mspe020+mspe056
g occ2010_group21=mspe021+mspe057
g occ2010_group22=mspe022+mspe058
g occ2010_group23=mspe023+mspe059
g occ2010_group24=mspe024+mspe060
g occ2010_group25=mspe025+mspe061
g occ2010_group26=mspe026+mspe062
g occ2010_group27=mspe027+mspe063
g occ2010_group28=mspe028+mspe064
g occ2010_group29=mspe029+mspe065
g occ2010_group30=mspe030+mspe066
g occ2010_group31=mspe031+mspe067
g occ2010_group32=mspe032+mspe068
g occ2010_group33=mspe033+mspe069
g occ2010_group34=mspe034+mspe070
g occ2010_group35=mspe035+mspe071
g occ2010_group36=mspe036+mspe072
g occ2010_group37=mspe037+mspe073


*Para cada variable se redondea el número de observaciones:
foreach num of numlist 1(1)37 {
replace occ2010_group`num'=round(occ2010_group`num')
}

*Se limpia la base:
drop mspe*
drop occ2010_group1 occ2010_group2
sort gisjoin

*Se junta base creada con base que tiene el cruce del número del Tract con el PUMA:
cd $data/geographic
merge 1:1 gisjoin using puma_tract1990
keep if _merge==3
drop _merge

*Se almacena la base:
cd $temp/temp_files
save occ_tract2010, replace


*3) Se genera el número de empleados para cada cada grupo de ocupación de acuerdo con el Census tract:
cd $temp/temp_files
u occ_tract2010, clear
keep gisjoin statefip puma occ2010*

*Se cambia la base de datos de formato wide a formato long mediante los identificadores gisjoin, statefip y puma. Se busca que se almacene en una nueva variable group que determine el grupo de ocupación al que pertenece el número de personas:
reshape long occ2010_group, i(gisjoin statefip puma) j(group)

*Se limpia la base:
ren (occ2010_group group) (number_occ2010 occ2010_group)

preserve
*Se suma el número de personas en cada grupo de ocupación en cada bloque dentro del tract, puma, county y Estado. Se almacena en una base de datos:
collapse (sum) number_tract=number_occ2010, by(gisjoin statefip puma)
save number_tract2010, replace
restore

*4) Se junta la base que identifica el número de personas que trabajan en cada grupo de ocupación de acuerdo con el census tract con la base que cruza la información entre el grupo de ocupación y ocupación partiendo de los identificadores statefip, grupo de ocupación para 1990:
cd $temp/temp_files
joinby statefip puma occ2010_group using occ_group_share2010

*5) Se imputa el número de empleados por ocupación para cada census tract de 2000 multiplicando el número de personas en cada grupo de ocupación por la proporción de personas que trabajan en cada ocupación dentro del grupo de ocupación al que pertenecen:
g impute=number_occ2010*occ_group_share

*6) Se suma el número de empleados por ocupación de acuerdo con la ocupación, census tract, puma y Estado.
collapse (sum) impute, by(gisjoin statefip puma occ2010)
*Se junta esta base con la base que tiene el grupo de ocupación para 2000 y la ocupación para 2010:
keep gisjoin statefip puma occ2010 impute
*Se limpia la base:
merge m:1 occ2010 using occ_occ_group2010
keep if _merge==3
drop _merge


*7) Para cada identificador gisjoin existen diferentes ocupaciones reportadas. Para que todos tengan los mismas ocupaciones reportadas se utiliza el comando fillin que completa estas ocupaciones y les pone missings. A las observaciones con missing en impute se les pone 0:
fillin gisjoin occ2010
replace impute=0 if impute==.

*Se limpia la base:
replace impute=round(impute)
keep gisjoin occ2010 impute 
sort gisjoin occ2010
cd $temp/temp_files
save tract_impute2010, replace


*******************************************************************************
**# Combinación de todas las bases:
*******************************************************************************

/*
El proceso para generar la base occ2010_count se encontraba en /Do-File/data_prep_various_measures. Se pasa a esta base ya que aquí se utiliza por primera vez. El autor sugiere revisar los do's en un orden particular en el cual esta base estaba primero, por lo que la especificación  dada por él no es la adecuada para el paquete de replicación.
*/


*1) Se genera una base que tenga el número de personas por ocupación en 1990 y 2010:

cd $data/ipums_micro
u 1990_2000_2010_temp , clear

*Se limpia la base (eliminan variables, observaciones cuyos valores se salen de un rango deseado):
drop wage distance tranwork trantime pwpuma ownershp ownershpd gq
drop if uhrswork<30
keep if age>=25 & age<=65
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

*Se genera una variable que cuente el número de personas que representa cada una de las observaciones de la base y se suma el número de personas por cada ocupación de 2010:
g count1990=perwt if year==1990
g count2000=perwt if year==2000
g count2010=perwt if year==2010
collapse (count) count1990 count2010, by(occ2010)
replace count1990=. if count1990==0
replace count2010=. if count2010==0
*Se guarda la base
cd $temp/temp_files
save occ2010_count, replace

/* Se generan loops para optimizar el proceso */

*2) Se pegan las tres bases de datos generadas en apartado anterior:
u tract_impute1990, clear
foreach x of numlist 1990 2000{
	ren impute impute`x'
	local a = `x'+10
	merge 1:1 occ2010 gisjoin using tract_impute`a'
	drop _merge
	replace impute`x'=0 if impute`x'==.
}

*Se limpia la base:
ren impute impute2010
replace impute2010=0 if impute2010==.

*3) Se asegura que las observaciones sean consistentes en los tres periodos:
*Se junta la base con aquella que tiene el número de personas por ocupación en 1990 y 2010:
cd $temp/temp_files
merge m:1 occ2010 using occ2010_count
keep if _merge==3
drop _merge
drop count*

*Se junta con la base que tiene las equivalencias entre tract de 1990 y área metropolitana:
cd $data/geographic
merge m:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

*4) Se suma 1 a todas las variables para suavizar las observaciones cuyo valor es 0. 
cd $temp/temp_files
replace impute1990=impute1990+1
replace impute2000=impute2000+1
replace impute2010=impute2010+1
save tract_impute, replace

*5) Se genera una base que tenga el conteo de la población por ocupación para cada MSA para el año 1990, 2000 y 2010:
collapse (sum) impute_total1990=impute1990 impute_total2000=impute2000 impute_total2010=impute2010, by(occ2010 metarea)

*6) Se junta base de población por ocupación para cada MSA con base de población por ocupación para cada Tract:
merge 1:m occ2010 metarea using tract_impute
drop _merge

*7) Se genera variable de proporción de población por ocupación para cada tract respecto al MSA. Se almacena en una base de datos:
g impute_share1990=impute1990/impute_total1990
g impute_share2000=impute2000/impute_total2000
g impute_share2010=impute2010/impute_total2010
keep occ2010 metarea gisjoin impute_share1990 impute_share2000 impute_share2010
save tract_impute_share, replace
