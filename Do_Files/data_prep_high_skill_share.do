*****************************************************
** Universidad de los Andes - Facultad de Economía **
** 			      Economía Urbana           	   **
**												   **
** 		      Lina María Gómez García              **
** 			   						               **
**       Improvements to the High Skill Share      **
**                Generation Do-File               **
*****************************************************

clear all
cls
global data="/Users/linagomez/Documents/Stata/Economia_Urbana/Revision_Codigo_Lina/data"
global temp="/Users/linagomez/Documents/GitHub/Revised-Reproduction-Package-for-Su-2022-"

/*Se optimiza el proceso de esta base mediante un loop. Se generan diferentes bases donde se tiene si la proporción de personas con altas habilidades para cada ocupación es mayor a un valor. Este proceso se hace una proporción mayor a 0.3, 0.4 o 0.5.*/


forvalues x=0.3(0.1)0.5{
	
	display `x'
	
	** Se abre la base:
	cd $data/ipums_micro
	u 1990_2000_2010_temp, clear
	
	**Se genera una variable que indica si la persona tiene un número alto
	* de años de educación definido por más de 4 años de educación superior:
	g college=0
	replace college=1 if educ>=10 & educ<.
	
	**La variable educación es una categórica. Se saca la media de la 
	* variable universidad que representa la proporción de personas que tienen
	* universidad de acuerdo con la ocupación en la que trabajan:
	collapse college, by(occ2010)
	
	**Si la proporción de personas en esa ocupación es mayor al 40% se dice 
	* que esa ocupación representa una de altas habilidades. Se genera la 
	* variable que representa esto:
	ren college college_share
	g high_skill=0
	replace high_skill=1 if college_share>=`x'	
	** Se almacena en una nueva base de datos:
	cd $temp/temp_files
	if `x' == 0.4{
		save high_skill, replace
	}
	else{
		save high_skill_`x', replace
	}	
}
