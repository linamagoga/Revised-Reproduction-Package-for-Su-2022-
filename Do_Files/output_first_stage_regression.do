clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


cd $data\temp_files

u skill_pop, clear
 cd $data\temp_files\iv
merge m:1 gisjoin using sim_iv_total
keep if _merge==3
drop _merge

g dratio=ln(impute2010_high/impute2010_low)-ln(impute1990_high/impute1990_low)
g dratio_sim=dln_sim_high_total - dln_sim_low_total 

** Table A4
** First Stage
* Column 1

reghdfe dratio dratio_sim, absorb(metarea) vce(robust)
* Column 2
reghdfe dratio dln_sim_low_total dln_sim_high_total, absorb(metarea) vce(robust)


