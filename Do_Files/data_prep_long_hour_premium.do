*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**      Improvements to the Long Hour Premium      **
**                Generation Do-File               **
*****************************************************


clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"

*Se utiliza la base de datos del US Census:
cd $data/ipums_micro

u 1990_2000_2010_temp, clear

**# Limpieza Base Datos:

** Se eliminan las siguientes variables:
drop wage distance tranwork trantime pwpuma ownershp ownershpd gq occ met2013 city puma rentgrs valueh bpl occsoc incwage puma1990 greaterthan40 datanum serial pernum rank ind ind2000 hhwt statefip marst occ1990

** Se elimina si una persona trabaja menos de 40 horas a la semana ya que esta es la jornada laboral y se quiere estimar cuanto se trabaja por horas extras: 
drop if uhrswork<40

** Valores que no tienen sentido lógico para el ingreso total se cambian por missing o por cero: 
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

** Está trayendo los salarios nominales de 1990 y 2000 en términos de salarios reales del 2010:

/*
IPC 1990 USA: 130.7
IPC 2000 USA: 172.2
IPC 2010 USA: 218.056 
*/

/* Se recomienda definir el significado de los valores de las siguientes tres líneas de código a priori, ya que no se sabía que hacía referencia a los IPC para Estados Unidos */
g inctot_real=inctot*218.056/130.7 if year==1990
replace inctot_real=inctot*218.056/172.2 if year==2000
replace inctot_real=inctot if year==2010
drop inctot

** Se divide entre 52 el ingreso total ya que se quiere saber cual es el ingreso semanal de los individuos. Se hace una transformación logarítmica de esta variable para reducir la varianza. 
replace inctot_real=inctot_real/52
replace inctot_real=ln(inctot_real)

/* Algunas variables se eliminaban en este punto. Para optimizar el código se junto esta linea de código con la línea 24. */

** Se generan nuevas variables:

/* Se optimizó el proceso de generación de variables mediante loops */

global ano 1990 2000 2010
foreach x in $ano{
	local var val se
	foreach y in `var' {
		gen `y'_`x'=.
	}
}

*Se generan variables que indican el número de horas de trabajo semanales para los datos reportados para este año en particular:
foreach x in $ano{
	gen hours`x' = 0
	replace hours`x' = uhrswork if year == `x'	
}

g dval=.
g se_dval=.

**# Creación Variables Long Hour Premium:


*Los números dentro del local indican el código de las ocupaciones que el autor está teniendo en cuenta.
* Se está generando una regresión lineal con múltiples efectos fijos dados por la interacción entre el año y diferentes características sociodemográficas. Esta regresión mide la relación entre las horas extras de trabajo de 1990, 2000 y 2010 y el ingreso total real para cada ocupación. Se almacena en una variable los coeficientes para las horas semanales de un año particular. Así, se encuentra el valor que tiene una hora extra de cada año en términos de ingreso controlando por factores sociodemográficos que no varían en el tiempo.
*El autor utiliza en la regresión clusters a nivel de área metropolitana ya que puede haber autocorrelación entre lo no observable de los individuos que viven en el área metropolitana. 

#delimit ;
local num 30 120 130 150 205 230 310
350 410 430 520 530 540 560 620 710 730 800
860 1000 1010 1220 1300 1320 1350 1360 1410
1430 1460 1530 1540 1550 1560 1610 1720
1740 1820 1920 1960 2000 2010 2040 2060 2100 2140
2200 2300 2310 2320 2340 2430 2540 2600 2630 2700 2720
2750 2810 2825 2840 2850 2910 3010 3030 3050 3060 3130
3160 3220 3230 3240 3300 3310 3410 3500 3530 3640
3650 3710 3740 3800 3820 3930 3940 3950 4000 4010 4030 4040
4060 4110 4130 4200 4210 4220 4230 4250
4320 4350 4430 4500 4510 4600 4620 4700
4720 4740  4750 4760 4800 4810 4820
4840 4850 4900  4950 4965 5000 5020 5100
5110 5120 5140 5160 5260 5300 5310 5320
5330 5350 5360 5400 5410 5420 5510 5520
5540 5550 5600 5610 5620 5630 5700 5800 5810 5820 5850
5860 5900 5940 6050 6200 6220 6230 6240 6250 6260 6320
6330 6355 6420 6440 6515 6520 6530 6600 6660 7000
7010 7020 7140 7150 7200 7210 7220 7315 7330
7340 7700 7720 7750 7800 7810 7950 8030 8130  8140
8220 8230 8300 8320 8350 8500 8610 8650 8710 8740
8760 8800 8810 8830 8965
9000 9030 9050 9100 9130 9140 9350
9510 9600 9610 9620 9640 ;
# delimit cr
macro dir
foreach num in `num'{
display `num'

qui reghdfe inctot_real hours1990 hours2000 hours2010 if occ2010==`num' & uhrswork<=60 [w=perwt], absorb(i.age#i.year i.sex#i.year i.educ#i.year i.race#i.year i.hispan#i.year i.ind1990#i.year) cluster(metarea)
	foreach x in $ano{
		replace val_`x' = _b[hours`x' ] if occ2010 == `num'
		replace se_`x' = _se[hours`x' ] if occ2010 == `num'
		}
}

/* Se altera este proceso para que queda más claro y óptimo de realizar - se genera un local en vez de meter todos los números al comienzo del loop y se genera un loop dentro del loop anterior para optimizar el proceso. */

collapse (firstnm) val_1990 se_1990 val_2000 se_2000 val_2010 se_2010, by(occ2010)


cd"/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-/temp_files"

save val_40_60_total_1990_2000_2010, replace
