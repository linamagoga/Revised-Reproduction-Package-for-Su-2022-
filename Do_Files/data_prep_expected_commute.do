*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**      Improvements to the Expected Commute       **
**                Generation Do-File               **
*****************************************************

clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"
global temp="/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-"

*******************************************************************************
**# Se generan algunas variables necesarias para la estimación principal
*******************************************************************************



**Se junta la base de datos de la participación de empleo de cada zip code en el metarea:
cd $temp/temp_files
u occ_emp_share_1990, clear

cd $data/geographic
merge m:1 metarea using 1990_rank
drop if _merge == 2
drop _merge

cd $temp/temp_files
save occ_emp_share_temp, replace

** En el siguiente global se delimitan las ocupaciones para las cuales se quieren hacer los siguientes procesos:
# delimit ;
global num 30 120 130 150 205 230 310
350 410 430 520 530 540 560 620 710 730 800
860 1000 1010 1220 1300 1320 1350 1360 1410
1430 1460 1530 1540 1550 1560 1610 1720
1740 1820 1920 1960 2000 2010 2040 2060 2100 2140
2200 2300 
2310 2320 2340 2430 2540 2600 2630 2700 2720
2750 2810 2825 2840 2850 2910 3010 3030 3050 3060 3130
3160 3220 3230 3240 3300 3310 3410 3500 3530 3640
3650 3740 3930 3940 3950 4000 4010 4030 4040
4060 4110 4130 4200 4210 4220 4230 4250
4320 4350 4430 4500 4510 4600 4620 4700
4720 4740  4750 4760 4800 4810 4820
4840 4850 4900  4950 4965 5000 5020 5100
5110 5120 5140 5160 5260 5300 5310 5320
5330 5350 5360 5400 5410 5420 5510 5520
5600 5610 5620 5630 5700 5800 5810 5820 5850
5860 5900 5940 6050 6200 6220 6230 6240 6250 6260 6320
6330 6355 6420 6440 6515 6520 6530 6600 6660 7000
7010 7020 7140 7150 7200 7210 7220 7315 7330
7340 7700 7720 7750 7800 7810 7950 8030 8130  8140
8220 8230 8300 8320 8350 8500 8610 8650 8710 8740
8760 8800 8810 8830 8965
9000 9030 9050 9100 9130 9140 9350
9510 9600 9610 9620 9640;
# delimit cr
macro dir


foreach num of global num{
	
	*Se abre la base y se mantienen solo las observaciones para esas ocupaciones
	*en específico:
	cd $temp/temp_files
	u occ_emp_share_temp, clear
	keep if occ2010== `num'
	drop serial year rank
	
	*Se junta esa base de datos con la base que contiene información del tiempo
	*de desplazamiento tract a zip ajustada por las condiciones de tráfico de 
	*1995:
	cd $data/travel
	merge 1:m zip using travel_time_hat
	keep if _merge==3
	drop _merge
	ren travel_time_hat travel_time
	*Se reemplaza el tiempo de viaje por horas de viaje a la semana (10 viajes -
	*5 ida y 5 vuelta):
	replace travel_time=10*travel_time

	*Según el modelo hay un parámetro de aversión que multiplica el tiempo de
	*de viaje con un parámetro de aversión se genera manualmente:
	/* No se tiene conocimiento de a qué hace referencia ese número */
	g discount=exp(-0.3425*travel_time)
	*Se genera variable que es el parámetro de aversión (escalar).
	*Se genera variable que representa la fracción de empleo en el MSA 
	*localizado en un census tract.
	g pi=share*discount
	sort gisjoin
	by gisjoin: egen pi_total=sum(pi)
	
	*Se calcula la proporción de población empleada en una ocupación respecto a
	*la población en el MSA:
	g  share_tilda=pi/pi_total

	*Se genera la variable que tiene el tiempo de viaje weighted por la 
	*distribución espacial de empleos para cada ocupación:
	g travel_time_share=travel_time*share_tilda
	
	*Se junta la weighted proportion de acuerdo al census tract:
	collapse (sum) expected_commute=travel_time_share, by(gisjoin)

	cd $temp/temp_files/commute
	sort expected
	save commute_`num', replace
}


*** En cada base se adiciona una variable que almacene la ocupación para la 
*que se generó esa base: 
cd $temp/temp_files/commute
foreach num of global num{
	u commute_`num', clear
	g occ2010=`num'
	save commute_`num'_temp, replace
}


*** Se juntan las bases de datos generadas para cada ocupación en una sola y se almacena:
clear
foreach num of global num{
	append using commute_`num'_temp
	
}
cd $temp/temp_files/commute
save commute, replace


*******************************************************************************
**# Se generan algunas variables necesarias para la estimación principal
*******************************************************************************


local a 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 23 24 25 
foreach num of local a{
	cd $temp/temp_files
	u occ_emp_1990, clear
	
	*Se generan grupos de acuerdo con la ocupación:
	
	/* Número_de_la_observación Definición
	* 1: MANAGEMENT, BUSINESS, SCIENCE, AND ARTS
	* 2: BUSINESS OPERATIONS SPECIALISTS
	* 3: FINANCIAL SPECIALISTS
	* 4: COMPUTER AND MATHEMATICAL
	* 5: ARCHITECTURE AND ENGINEERING
	* 6: TECHNICIANS
	* 7: LIFE, PHYSICAL, AND SOCIAL SCIENCE
	* 8: COMMUNITY AND SOCIAL SERVICES
	* 9: LEGAL
	* 10: EDUCATION, TRAINING, AND LIBRARY
	* 11: ARTS, DESIGN, ENTERTAINMENT, SPORTS, AND MEDIA
	* 12: HEALTHCARE PRACTITIONERS AND TECHNICAL
	* 13: HEALTHCARE SUPPORT
	* 14: PROTECTIVE SERVICE
	* 15: FOOD PREPARATION AND SERVING
	* 16: BUILDING AND GROUNDS CLEANING AND MAINTENANCE
	* 17: PERSONAL CARE AND SERVICE
	* 18: SALES AND RELATED
	* 19: OFFICE AND ADMINISTRATIVE SUPPORT
	* 20: FARMING, FISHING, AND FORESTRY
	* 21: CONSTRUCTION
	* 22: EXTRACTION
	* 23: INSTALLATION, MAINTENANCE, AND REPAIR
	* 24: PRODUCTION
	* 25: TRANSPORTATION AND MATERIAL MOVING
	*/
	
	g occ_group=1 if occ2010>=10 & occ2010<=430
	replace occ_group=2 if occ2010>=500 & occ2010<=730
	replace occ_group=3 if occ2010>=800 & occ2010<=950
	replace occ_group=4 if occ2010>=1000 & occ2010<=1240
	replace occ_group=5 if occ2010>=1300 & occ2010<=1540
	replace occ_group=6 if occ2010>=1550 & occ2010<=1560
	replace occ_group=7 if occ2010>=1600 & occ2010<=1980
	replace occ_group=8 if occ2010>=2000 & occ2010<=2060
	replace occ_group=9 if occ2010>=2100 & occ2010<=2150
	replace occ_group=10 if occ2010>=2200 & occ2010<=2550
	replace occ_group=11 if occ2010>=2600 & occ2010<=2920
	replace occ_group=12 if occ2010>=3000 & occ2010<=3540
	replace occ_group=13 if occ2010>=3600 & occ2010<=3650
	replace occ_group=14 if occ2010>=3700 & occ2010<=3950
	replace occ_group=15 if occ2010>=4000 & occ2010<=4150
	replace occ_group=16 if occ2010>=4200 & occ2010<=4250
	replace occ_group=17 if occ2010>=4300 & occ2010<=4650
	replace occ_group=18 if occ2010>=4700 & occ2010<=4965
	replace occ_group=19 if occ2010>=5000 & occ2010<=5940
	replace occ_group=20 if occ2010>=6005 & occ2010<=6130
	replace occ_group=21 if occ2010>=6200 & occ2010<=6765
	replace occ_group=22 if occ2010>=6800 & occ2010<=6940
	replace occ_group=23 if occ2010>=7000 & occ2010<=7630
	replace occ_group=24 if occ2010>=7700 & occ2010<=8965
	replace occ_group=25 if occ2010>=9000 & occ2010<=9750
	
	*Se mantienen todas las observaciones menos las del grupo de ocupación para
	*el cual se está corriendo el loop:
	keep if occ_group != `num'
	
	*Se suma el número de personas por zip code :
	collapse (sum) est_num, by(zip)
	
	*Se junta con la base que cruza el zip con el MSA:
	cd $data/geographic
	merge m:1 zip using zip1990_metarea
	keep if _merge==3
	drop _merge
	sort metarea
	
	*Se genera una variable que almacene por cada área metropolitana el número
	*de personas:
	by metarea: egen est_num_total=sum(est_num)
	
	*Se genera la proporción de personas que trabajan en cada zip respecto al 
	*total del área metropolitana:
	g share=est_num/est_num_total
	keep share zip metarea
	
	*Se junta con la base que organizó la población en orden:
	cd $data/geographic
	merge m:1 metarea using 1990_rank
	drop _merge serial year rank
	
	*Se junta con la base que tiene imputado el tiempo de viaje:
	cd $data/travel
	merge 1:m zip using travel_time_hat
	keep if _merge==3
	drop _merge
	ren travel_time_hat travel_time

	*En esta base se genera el número de horas de viaje por semana:
	replace travel_time=10*travel_time

	*Según el modelo hay un parámetro de aversión que multiplica el tiempo de
	*de viaje con un parámetro de aversión se genera manualmente:
	/* No se tiene conocimiento de a qué hace referencia ese número */
	g discount=exp(-0.3425*travel_time)
	*Se genera variable que es el parámetro de aversión (escalar).
	*Se genera variable que representa la fracción de empleo en el MSA 
	*localizado en un census tract.
	g pi=share*discount
	sort gisjoin
	by gisjoin: egen pi_total=sum(pi)

	*Se calcula la proporción de población empleada en una ocupación respecto a
	*la población en el MSA:
	g  share_tilda=pi/pi_total

	*Se genera la variable que tiene el tiempo de viaje weighted por la 
	*distribución espacial de empleos para cada ocupación:
	g travel_time_share=travel_time*share_tilda

	*Se junta la weighted proportion de acuerdo al census tract:
	collapse (sum) expected_commute=travel_time_share, by(gisjoin)

	*Se almacena en una nueva base:
	sort expected
	ren expected_commute total_commute
	cd $temp/temp_files/commute
	save commute_total`num', replace
}

*** En cada base se adiciona una variable que almacene la ocupación para la que se generó esa base: 
clear
local a 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 23 24 25 
foreach num of local a{
	u commute_total`num', clear
	g occ_group=`num'
	save commute_total`num', replace
}

*** Se almacena en una nueva base:
clear
	foreach num of local a{
	append using commute_total`num'
}

*Se almacena en una nueva base:
save commute_total, replace
