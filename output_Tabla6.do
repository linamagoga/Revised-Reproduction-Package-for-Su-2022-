/****    The Rising Value of Time and    ****/
/**** The Origin of Urban Gentrification ****/
/***    Reproducción Inicial Claim B      ***/
/**         Lina María Gómez García        **/
/*                201631198                 */


**** Regresión del cambio en los servicios del barrio respecto al ratio en calificación local.
*** Se realiza la tabla partiendo de los datos ya limpiados que provee el autor (temp_files) (Su, 2022).

clear all
global data="/Users/linagomez/Documents/Stata/Economía Urbana/132721-V1/data"

cd "$data/geographic"
u tract1990_tract1990_2mi, clear

keep if dist<=1610
cd "$data/temp_files"

rename gisjoin2 gisjoin

merge m:1 gisjoin using population1990
keep if _merge==3
drop _merge

rename population population1990

merge m:1 gisjoin using population2010
keep if _merge==3
drop _merge

drop gisjoin
rename gisjoin1 gisjoin

cd "$data/temp_files"

merge m:1 gisjoin using skill_pop_1mi
keep if _merge==3
drop _merge

*** Merge para computar la IV para el ratio de calificación local
cd "$data/temp_files/iv"
merge m:1 gisjoin using ingredient_for_iv_amenity
keep if _merge==3
drop _merge


collapse (sum) population1990 population2010 impute2010_high impute2010_low impute1990_high impute1990_low sim1990_high sim1990_low sim2010_high sim2010_low, by(gisjoin)

cd "$data/temp_files"

merge 1:1 gisjoin using tract_amenities
keep if _merge==3
drop _merge

cd "$data/geographic"

merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

** restaurante:
generate d_large_restaurant=ln( (est_large_restaurant2010+1)/(population2010+1))-ln( (est_large_restaurant1990+1)/(population1990+1))
generate d_small_restaurant=ln( (est_small_restaurant2010+1)/(population2010+1))-ln( (est_small_restaurant1990+1)/(population1990+1))
generate d_restaurant=ln((est_small_restaurant2010+est_large_restaurant2010+1)/(population2010+1))-ln((est_small_restaurant1990+est_large_restaurant1990+1)/(population1990+1))

** cigarrerías:
generate d_large_grocery=ln( (est_large_grocery2010+1)/(population2010+1))-ln( (est_large_grocery1990+1)/(population1990+1))
generate d_small_grocery=ln( (est_small_grocery2010+1)/(population2010+1))-ln( (est_small_grocery1990+1)/(population1990+1))

generate d_grocery=ln( (est_small_grocery2010+est_large_grocery2010+1)/(population2010+1))-ln( (est_small_grocery1990+est_large_grocery1990+1)/(population1990+1))

** gimnasios:
g d_gym=ln( (est_gym2010+1)/(population2010+1))-ln( (est_gym1990+1)/(population1990+1))

** servicios personales:
generate d_large_personal=ln( (est_large_personal2010+1)/(population2010+1))-ln( (est_large_personal1990+1)/(population1990+1))
generate d_small_personal=ln( (est_small_personal2010+1)/(population2010+1))-ln( (est_small_personal1990+1)/(population1990+1))

generate d_personal=ln( (est_small_personal2010+est_large_personal2010+1)/(population2010+1))-ln( (est_small_personal1990+est_large_personal1990+1)/(population1990+1))

generate dratio=ln((impute2010_high+1)/(impute2010_low+1))-ln((impute1990_high+1)/(impute1990_low+1))

generate dratio_sim=ln(sim2010_high/sim2010_low)- ln(sim1990_high/sim1990_low)
generate dln_sim_high=ln(sim2010_high)- ln(sim1990_high)
generate dln_sim_low=ln(sim2010_low)- ln(sim1990_low)

duplicates drop gisjoin, force

cd "$data/temp_files"
egen tract_id=group(gisjoin)

save data_matlab, replace



**** Regresiones
cd "$data/temp_files"

use data_matlab, clear


*** Regresión IV para la ecuación de amenidades
* Columna (1-4) de la Tabla 6
******

cd "/Users/linagomez/Documents/Stata/Economía Urbana/Revisión Código Lina"

ivreghdfe d_restaurant (dratio=dln_sim_high dln_sim_low), absorb(metarea) robust
label var d_restaurant "Restaurantes por 1000 residentes"
label var dratio "Cambio en el ln del ratio de calificacion"
outreg2 using Tabla_6.doc, replace label addtext(Efectos Fijos MSA, Si)

ivreghdfe d_grocery (dratio=dln_sim_high dln_sim_low), absorb(metarea) robust
label var d_grocery "Cigarrerias por 1000 residentes"
outreg2 using Tabla_6.doc, append label  addtext(Efectos Fijos MSA, Si)


ivreghdfe d_gym (dratio= dln_sim_high dln_sim_low), absorb(metarea) robust
label var d_gym "Gimnasios por 1000 residentes"
outreg2 using Tabla_6.doc, append label  addtext(Efectos Fijos MSA, Si)

ivreghdfe d_personal (dratio= dln_sim_high dln_sim_low), absorb(metarea) robust
label var d_personal "Establecimientos Personales por 1000 residentes"
outreg2 using Tabla_6.doc, append label  addtext(Efectos Fijos MSA, Si)


****
** Crimen

clear all
cd "$data/crime"
import delimited crime_place2013_tract1990.csv , varnames(1) clear

keep gisjoin crime_violent_rate1990 crime_property_rate1990 crime_violent_rate2010 crime_property_rate2010 gisjoin_1

rename gisjoin gisjoin_muni
rename gisjoin_1 gisjoin

cd "$data/temp_files"

merge 1:1 gisjoin using population1990
keep if _merge==3
drop _merge

merge 1:1 gisjoin using population2010
keep if _merge==3
drop _merge

cd "$data/temp_files"

merge 1:1 gisjoin using skill_pop
keep if _merge==3
drop _merge

cd "$data/temp_files/iv"
merge m:1 gisjoin using ingredient_for_iv_amenity
drop if _merge==2
drop _merge

cd "$data/geographic"

merge m:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge


collapse (sum) impute2010_high impute2010_low impute1990_high impute1990_low population population2010 sim1990_high sim1990_low sim2010_high sim2010_low (mean) crime_violent_rate* crime_property_rate* , by(gisjoin_muni metarea)

generate dratio=ln((impute2010_high+1)/(impute2010_low+1))-ln((impute1990_high+1)/(impute1990_low+1))
generate dratio_sim=ln(sim2010_high/sim2010_low)- ln(sim1990_high/sim1990_low)
generate dviolent=ln( crime_violent_rate2010+0.1)-ln( crime_violent_rate1990+0.1)
generate dproperty=ln( crime_property_rate2010+0.1)-ln( crime_property_rate1990+0.1)


generate dln_sim_high=ln(sim2010_high)- ln(sim1990_high)
generate dln_sim_low=ln(sim2010_low)- ln(sim1990_low)


*** Columna 5-6 de la Tabla 6
cd "/Users/linagomez/Documents/Stata/Economía Urbana/Revisión Código Lina"

ivreghdfe dproperty (dratio=dln_sim_high dln_sim_low) [w=population] , absorb(metarea) robust
label var dproperty "Crimen de Propiedad por 1000 residentes"
label var dratio "Cambio en el ln del ratio de calificacion"
outreg2 using Tabla_6.doc, append label  addtext(Efectos Fijos MSA, Si)

ivreghdfe dviolent (dratio=dln_sim_high dln_sim_low) [w=population], absorb(metarea) robust
label var dviolent "Crimen Violento por 1000 residentes"
outreg2 using Tabla_6.doc, append label  addtext(Efectos Fijos MSA, Si)
