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
global temp="/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-"

*******************************************************************************
**# Limpieza base NHTS 1995 y el valor que tiene una unidad adicional o 
*un uno porciento adicional de cada una de las variables en el procentaje de la velocidad de viaje:
*******************************************************************************

cd $data/travel
u nhts, clear

**El autor está utilizando la variable modo de transporte para que las observaciones que queden sean aquellas tipo automóvil (automóvil, van, camioneta) o camión:
keep if TRPTRANS>=1 & TRPTRANS<=5
** Se mantienen las observaciones cuyo día de viaje fue entre el Lunes y el Viernes:
keep if TRAVDAY>=2 & TRAVDAY<=6
**Se mantienen las vobservaciones cuyo viaje era de su casa o hasta su casa (17):
keep if WHYTO==17 | WHYFROM==17
** Esta variable mide la distancia reportada en millas. Cambió por missings aquellas distancias mayores a 9000 millas:
replace TRPMILES=. if TRPMILES>=9000
**Esta variable mide el tiempo de viaje en minutos. Cambió por missings aquellos tiempos de viaje mayores a 90000:
replace TRVL_MIN=. if TRVL_MIN>=9000


**Se genera una transformación logarítmica a la distancia y al tiempo de viaje en horas:
g log_distance=ln(TRPMILES)
g log_time=ln(TRVL_MIN/60)
**Se genera el cuadrado del logaritmo de la distancia:
g log_distance2=log_distance^2
**Se genera una variable que mide la velocidad (vel=dist/tiempo) en millas por hora y se realiza una transformación logarítmica:
g speed=TRPMILES/(TRVL_MIN/60)
g log_speed=ln(speed)


**Esta variable mide la densidad poblacional a nivel census tract. Se reemplazan algunos valores por missing (ya que el máximo valor es 35,000 [25k a 999k]) y se genera una variable que represente la densidad:
replace HTPPOPDN=. if HTPPOPDN>90000
g pop_den=HTPPOPDN
**Esta variable mide la densidad residencial a nivel census tract. Se reemplazan algunos valores por missing (ya que el máximo valor es 6,000 [5k a 999k]) y se genera una variable que represente la densidad:
replace HTHRESDN=. if HTHRESDN>7000
g unit_den=HTHRESDN
**Esta variable mide el ingreso mediano del hogar a nivel census tract. Se reemplazan algunos valores por missing (ya que el máximo valor es 80,000 [70k a 999k]) y se genera una variable que represente el ingreso:
replace HTHINMED=. if HTHINMED>100000
g inc=HTHINMED
**Esta variable mide el porcentaje de población trabajadora a nivel census tract. Se reemplazan algunos valores por missing (ya que el máximo valor es 95 [95 a 100]) y se genera una variable que represente el ingreso:
replace HTINDRET=. if HTINDRET>100
g working=HTINDRET


**Se crea una dummy para área metropolitana:
g metarea_d=998


/* No se entiende porque el autor divide el número que identifica el MSA entre 10 */

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


**Se genera una variable que represente las horas al día que son pico (entre las 6:30am y las 10:30am, entre las 4:30pm y las 8:30pm) y se mantienen esas observaciones:
g rush=1 if STRTTIME>= 630 & STRTTIME <= 1030
replace rush=1 if STRTTIME>= 1630 & STRTTIME <= 2030
keep if rush==1


**Se generan dummies partiendo de las variables categóricas densidad poblacional, ingreso mediano del hogar, y proporción de población trabajando a nivel de census tract:
xi i.pop_den i.inc i.working


*Se realiza una regresión entre el logaritmo de la velocidad de viaje y el logaritmo cuadrático de la distancia, las dummies de densidad poblacional, ingreso mediano y proporción de trabajadores por census tract. Los errores estándares son robustos para evitar la heterocedasticidad.

*Los coeficientes representan el valor que tiene una unidad adicional o un  uno porciento adicional de cada una de las variables en el procentaje de la velocidad de viaje:
reg log_speed log_distance log_distance2 _Ipop_den_* _Iinc_* _Iworking_*, r
estimates store speed_results


*******************************************************************************
**# Recreación de las características del barrio en el mapa de Census Tract:
*******************************************************************************

*******************************************************************************
*** Se obtiene el área de cada census tract y se almacena en una nueva base de datos:
*******************************************************************************

clear
cd $data/geographic
import delimited tract1990_area.csv, varname(1) clear 
keep gisjoin area_sm
ren area_sm area
sort gisjoin 
cd $temp/temp_files
save area_sqmile, replace

*******************************************************************************
*** Se obtiene el ingreso mediano para cada census tract  se almacena en una nueva base de datos:
*******************************************************************************
clear
cd $data/nhgis
import delimited nhgis0031_ds123_1990_tract.csv, clear
keep gisjoin e4u001
ren e4u001 median_income
sort gisjoin
cd $temp/temp_files
save median_income1990, replace

*******************************************************************************
*** Se obtiene la proporción de personas trabajadoras para cada census tract  y se almacena en una nueva base de datos:
*******************************************************************************
clear 
cd $data/nhgis/working_pop
import delimited nhgis0016_ds123_1990_tract.csv, clear
egen working_pop=rowtotal(e4i001 e4i002 e4i005 e4i006)
keep gisjoin working_pop

/* La siguiente base no aparece en el ReadMe como un Raw Data. Tampoco aparece en ningún código como si se estuviera generando en Do previo a este. Se descarga del AER pero no se tiene conocimiento de donde sale y si se hizo un proceso de limpieza previo */

*** Se genera la proporción de de poblaciín trabajando sobre el total de la población, se limpia la base y se guarda en una base de datos:
cd $temp/bases_missing
merge 1:1 gisjoin using population1990
drop _merge
g share_working=working_pop/population
drop if share_working==.
replace share_working=1 if share_working>1
keep gisjoin share_working
sort gisjoin
cd $temp/temp_files
save working_pop1990, replace

*******************************************************************************
*** Se genera la población por área metropolitana juntando la base de población para 1990 con la base que almacena el área de cada census tract. Se limpia la base y se almacena en una nueva base de datos:
*******************************************************************************
cd $temp/bases_missing
u population1990, clear
cd $data/geographic
merge 1:1 gisjoin using area_sqmile
keep if _merge==3
drop _merge
destring area, replace ignore(",")
g density=population/area
cd $data/geographic
keep gisjoin density
sort gisjoin
save density, replace

*******************************************************************************
*** Se almacena en una base la proporción de personas que trabajan y el ingreso mediano en cada Census tract:
*******************************************************************************

cd $data/geographic
u density, clear

cd $temp/temp_files
local base working_pop1990 median_income1990
foreach x in `base'{
merge 1:1 gisjoin using `x'
keep if _merge==3
drop _merge
}

sort gisjoin
cd $temp/temp_files
save tract1990_char, replace

*******************************************************************************
*** Se crea el promedio de densidad, proporción de población trabajando e ingreso mediano alrededor de 2 millas de cada Census Tract:
*******************************************************************************

*** Se abre la base que contiene información para los tracts a 2 millas de un Tract particular:
cd $data/geographic
u tract1990_tract1990_2mi, clear
ren gisjoin2 gisjoin

*** Se junta con base que almacenó la proporción de población trabajando, densidad e ingreso mediano por cada census tract: 
cd $temp/temp_files
merge m:1 gisjoin using tract1990_char
keep if _merge==3
drop _merge
ren (gisjoin gisjoin1) (gisjoin2 gisjoin)
cd $temp/temp_files
save temp, replace

*** Se pega a la base original las observaciones generadas para cada dos millas de distancia de un census tract:
cd $temp/temp_files
u tract1990_char, clear
g gisjoin2=gisjoin
append using temp
*** Se saca el promedio de las variables de acuerdo con el census tract:
collapse density share_working median_income, by(gisjoin)
cd $temp/temp_files
save tract1990_char_2mi, replace

*******************************************************************************
*** Se crean las características promedio para 2 millas a la redonda de cada zip code:
*******************************************************************************

*** Se junta base que tiene almacenado la equivalencia entre tract y zip a dos millas con la base que almacena zip:
cd $data/geographic
import delimited zip1990_tract1990_nearest.csv, varnames(1) clear
ren in_fid fid
cd $data/geographic
merge m:1 fid using zip1990
keep if _merge==3
drop _merge

*** Se limpia la base:
drop fid
ren near_fid fid

*** Se junta esta base con la base que tiene el código de Tract:
merge m:1 fid using tract1990 
keep if _merge==3
drop _merge

*** Se limpia la base:
keep gisjoin zip 

*** Se almacena el zip y el tract más cercano:
save zip1990_tract1990_nearest, replace

*** Se pega con el cruce entre el tract y el zip más cercano:
append using tract1990_zip1990_2mi
duplicates drop gisjoin zip, force


*** Se junta con la base que almacena las características por cada census tract: 
cd $temp/temp_files
sort zip gisjoin
merge m:1 gisjoin using tract1990_char
keep if _merge==3
drop _merge

*** Se saca el promedio de las variables respecto al zip más cercano y se almacena en nueva base:
collapse density share_working median_income, by(zip)
save zip1990_char_2mi, replace

*******************************************************************************
**# Se estiman valores de tiempo de viaje de acuerdo con la distancia:
*******************************************************************************

/* La base con 51 toma los rankings mayores a 51 */

local base "tract1990_zip1990_leftover.csv tract1990_zip1990_leftover_51.csv"
local i 1
foreach x in `base'{
	cd $data/geographic
	*** Se importa la base:
	/* El autor en su readme no específica que significan estas bases de
	datos por lo que no se comprende que tipo de base se está usando*/
	import delimited `x', varnames(1) clear 
	ren input_fid fid
	merge m:1 fid using tract1990
	keep if _merge==3
	drop _merge fid
	ren near_fid fid

	*** Se pega junto con el zip code para 1990: 
	merge m:1 fid using zip1990
	keep if _merge==3
	drop _merge
	keep gisjoin zip distance
	destring distance, replace ignore(",")

	*** Se multiplica la distancia por 1.6 para cambiar de millas a kilómetros:
	replace distance=distance*1.6

	*** Se genera una variable del tiempo de viaje que divida la distancia 
	** sobre la velocidad (3600 y 1609.34 es para generar equivalencia entre
	** unidades):

	/* No se sabe de donde sale el 35. En el apéndice menciona que para 	
	encontrar el tiempo se debe multiplicar la distancia por la velocidad 
	pero esta fórmula no tiene sentido para encontrar el tiempo */
	g time=3600*distance/(35*1609.34)
	cd $temp/temp_files
	
	if `i' == 1 {
		save temp, replace
	}
	else {
		save temp_51, replace
	}
	local ++i
}

*******************************************************************************
**# Se genera la base que almacena el tiempo de viaje histórico:
*******************************************************************************


*** Datos del Google Distance Matrix API: 
cd $data/travel
u travel_time, clear
*** Se junta esta base con la base que almaceno el tiempo:
cd $temp/temp_files
merge 1:1 gisjoin zip using temp
drop if _merge==2
drop _merge

*** Se genera una variable que toma el valor de 1 cuando el tiempo de viaje y la distancia de viaje es -1, 0 o "."; Se reemplaza el tiempo de viaje y la distancia por los valores del tiempo de viaje generados en la base anterior:
g leftover=1 if travel_time==-1 | travel_dist==-1 | travel_time==0 | travel_dist==0 | travel_time==. | travel_dist==.
replace travel_time=time if time!=. & leftover==1
replace travel_dist=distance if  distance!=. & leftover==1

**** Se limpia base:
drop leftover time distance

*** Se sigue mismo proceso con base de tiempo 51:
merge 1:1 gisjoin zip using temp_51
drop if _merge==2
drop _merge
g leftover=1 if travel_time==-1 | travel_dist==-1 | travel_time==0 | travel_dist==0 | travel_time==. | travel_dist==.
replace travel_time=time if time!=. & leftover==1
replace travel_dist=distance if  distance!=. & leftover==1
drop if zip==93562
drop time distance leftover

*** Se junta con la base que tiene las características de las personas del barrio 2 millas a la redonda del census tract:
cd $temp/temp_files
merge m:1 gisjoin using tract1990_char_2mi
drop if _merge==2
drop _merge
ren (density share_working median_income) (density1 share_working1 median_income1)

*** Se junta con la base que tiene las características de las personas del barrio 2 millas a la redonda del zip code
merge m:1 zip using zip1990_char_2mi
drop if _merge==2
drop _merge
ren (density share_working median_income) (density2 share_working2 median_income2)


sum density1, detail
*** Se llenan las observaciones missing:

replace density1=5267.096 if density1==.
replace share_working1=.4599274 if share_working1==.
replace median_income1=30438.35 if median_income1==.

replace density2=5267.096 if density2==.
replace share_working2=.4599274 if share_working2==.
replace median_income2=30438.35 if median_income2==.
/* El autor nunca especifica de donde salieron estos números */

*** Con ambas variables se saca un promedio para cada característica:
g density=(density1+density2)/2
g share_working=(share_working1+share_working2)/2
g median_income=(median_income1+median_income2)/2

*** Se limpia la base de datos:
drop *1 *2

*** Se generan variables categóricas para los efectos fijos:

** Densidad:
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

** Ingreso mediano:
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

** Proporción trabajando:
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

*** Se separan las variables categóricas en dummies:
xi i.pop_den i.inc i.working

*** Se hace una transformación logarítmica a la distancia en millas de la Google Matrix desde metros:
g log_distance=ln(travel_dist/1609.34)
** Se eleva la variable al cuadrado:
g log_distance2=log_distance^2

*** Se genera la variable que represente el logaritmo de la velocidad en millas por hora:  
g log_speed=ln((travel_dist/1609.34)/(travel_time/3600))

*** Se utiliza el Google API para estimar los efectos fijos para cada ruta:
reg log_speed log_distance log_distance2 _Ipop_den_* _Iinc_* _Iworking_*, r
predict fixed_effects, residual

*** Con los resultados de la regresión con la NHTS se predice el valor del logaritmo de la velocidad:
estimates restore speed_results
predict log_speed_hat, xb

*** A esta predicció se le suman los efectos fijos de cada ruta y se despeja para la velocidad:
replace log_speed_hat=log_speed_hat+fixed_effects
g speed_hat=exp(log_speed_hat)

*** Se genera el tiempo de viaje en horas y se almacena en base de datos:
g travel_time_hat=(travel_dist/1609.34)/speed_hat
keep gisjoin zip travel_time_hat

cd $data/travel
save travel_time_hat, replace
