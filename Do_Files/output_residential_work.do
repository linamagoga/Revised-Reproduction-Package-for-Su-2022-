clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


cd $data\temp_files

u occ_emp_1994,clear

cd $data\geographic

merge m:1 zip using zip1990_downtown
drop if _merge==2

g downtown=0
replace downtown=1 if _merge==3
drop _merge


cd $data\geographic

merge m:1 zip using zip1990_metarea
keep if _merge==3
drop _merge

cd $data\geographic

merge m:1 metarea using 1990_rank
keep if _merge==3
drop _merge

cd $data\geographic
keep if rank<=25
drop serial year

collapse (sum) est_num1990=est_num, by(occ2010 downtown)
cd $data\temp_files
save temp1990, replace

**2000
cd $data\temp_files

u occ_emp_2000,clear

cd $data\geographic

merge m:1 zip using zip2000_downtown
drop if _merge==2

g downtown=0
replace downtown=1 if _merge==3
drop _merge


cd $data\geographic

merge m:1 zip using zip2000_metarea
keep if _merge==3
drop _merge

cd $data\geographic

merge m:1 metarea using 1990_rank
keep if _merge==3
drop _merge

cd $data\geographic
keep if rank<=25
drop serial year

collapse (sum) est_num2000=est_num, by(occ2010 downtown)
cd $data\temp_files
save temp2000, replace
***
**2010
cd $data\temp_files

u occ_emp_2010,clear

cd $data\geographic

merge m:1 zip using zip2010_downtown
drop if _merge==2

g downtown=0
replace downtown=1 if _merge==3
drop _merge

cd $data\geographic

merge m:1 zip using zip2010_metarea
keep if _merge==3
drop _merge

cd $data\geographic

merge m:1 metarea using 1990_rank
keep if _merge==3
drop _merge

cd $data\geographic
keep if rank<=25
drop serial year

collapse (sum) est_num2010=est_num, by(occ2010 downtown)
cd $data\temp_files
save temp2010, replace

cd $data\temp_files
clear
u temp1990, clear
merge 1:1 occ2010 downtown using temp2000
keep if _merge==3
drop _merge

merge 1:1 occ2010 downtown using temp2010
keep if _merge==3
drop _merge 

sort occ2010 downtown

by occ2010: g ratio_emp2010=est_num2010/(est_num2010+est_num2010[_n-1])
by occ2010: g ratio_emp2000=est_num2000/(est_num2000+est_num2000[_n-1])
by occ2010: g ratio_emp1990=est_num1990/(est_num1990+est_num1990[_n-1])

keep occ2010 downtown ratio_emp*
save occ_emp_downtown, replace


**** residential share
cd $data\temp_files
 u tract_impute.dta, clear
 cd $data\geographic
 merge m:1 gisjoin using tract1990_downtown5mi
drop if _merge==2
g downtown=0
replace downtown=1 if _merge==3
drop _merge

 cd $data\geographic

merge m:1 metarea using 1990_rank
keep if _merge==3
drop _merge

keep if rank<=25
drop serial year

collapse (sum) impute1990 impute2000 impute2010, by(occ2010 downtown)
by occ2010: g ratio1990=impute1990/(impute1990+impute1990[_n-1])
by occ2010: g ratio2000=impute2000/(impute2000+impute2000[_n-1])
by occ2010: g ratio2010=impute2010/(impute2010+impute2010[_n-1])

keep occ2010 downtown ratio1990 ratio2000 ratio2010

cd $data\temp_files
merge 1:1 occ2010 downtown using occ_emp_downtown
keep if _merge==3
drop _merge
cd $data\geographic

g dratio=ln(ratio2010)-ln(ratio1990)
g dratio_emp=ln(ratio_emp2010)-ln(ratio_emp1990)

label define occ 120 "financial worker" 2100 "Lawyer"
label values occ2010 occ

g occ2010_2=occ2010 if occ2010==800 | occ2010==2100 | occ2010==4820 | occ2010==30 | occ2010==1000 | occ2010==5700 | occ2010==4030
cd $data\temp_files
merge m:1 occ2010 using college_share
keep if _merge==3
drop _merge

g high_skill=0
replace high_skill=1 if college_share1990>0.4

cd $data\temp_files
merge m:1 occ2010 using count1990_rank25
drop _merge

** binscatters
# delimit 
binscatter ratio2010 ratio1990 [w=count1990],  
by(high_skill) legend(lab(1 "Low skill") lab(2 "High skill"))  msymbols(O S)
xtitle(Share of residents in central cities in 1990) ytitle(Share of residents in central cities in 2010) text(0.25 0.1 "Slope (Low-skilled) = 0.688 (0.0713)", size(medsmall))
text(0.23 0.1008 "Slope (High-skilled) = 1.052 (0.0692)", size(medsmall)) text(0.21 0.089 "Difference = 0.364 (0.0994)", size(medsmall));
# delimit cr
graph export $data\graph\central_res_1990_2010.emf, replace
graph export $data\graph\labeled\figure_3a.pdf, replace


# delimit 
binscatter ratio_emp2010 ratio_emp1990 [w=count1990],  
by(high_skill) legend(lab(1 "Low skill") lab(2 "High skill")) msymbols(O S) 
xtitle(Share of employment in central cities in 1994) ytitle(Share of employment in central cities in 2010) text(0.36 0.2 "Slope (Low-skilled) = 0.785 (0.054)", size(medsmall))
text(0.335 0.205 "Slope (High-skilled) = 0.819 (0.0509)", size(medsmall)) text(0.31 0.185 "Difference = 0.0342 (0.0743)", size(medsmall));
# delimit cr
graph export $data\graph\central_emp_1990_2010.emf, replace
graph export $data\graph\labeled\figure_3b.pdf, replace




*** Job concentration in central cities (appendix figure)

**
# delimit 
graph twoway (scatter ratio1990 ratio_emp1990  [w=count1990], msize(small) msymbol(oh)) (line ratio1990 ratio1990)
,legend(lab(1 "Occupation")  lab(2 "45 degree line"))
xtitle(Share of employment in central cities in 1994) ytitle(Share of residents in central cities in 1990) graphregion(color(white));
# delimit cr
graph export $data\graph\central_emp_res.emf, replace
graph export $data\graph\labeled\figure_a9.pdf, replace

cd $data\temp_files
u temp1990, clear
merge 1:1 occ2010 downtown using temp2000
keep if _merge==3
drop _merge

merge 1:1 occ2010 downtown using temp2010
keep if _merge==3
drop _merge 

sort occ2010 downtown

cd $data\temp_files
merge m:1 occ2010 using high_skill
drop if _merge==2
drop _merge

cd $data\temp_files
merge m:1 occ2010 using val_40_60_total_1990_2000_2010
keep if _merge==3
drop _merge

g dval=val_2010-val_1990
g fast=0
replace fast=1 if dval>=0.005

collapse (sum) est_num1990, by(high_skill fast downtown)

by high_skill fast: g share=est_num1990/(est_num1990+est_num1990[_n-1])

lab define fast_lab 1 "{&Delta} LHP>=0.005" 0 "{&Delta} LHP<0.005"
lab define high_skill_lab 1 "High-skilled jobs" 0 "Low-skilled jobs"
lab value fast fast_lab
lab value high_skill high_skill_lab

graph bar share, over(fast, lab(labsize(small))) over(high_skill) graphregion(color(white)) ytitle(Share of jobs in central cities (1994))
cd $data\graph
graph export job_central_cities.png, replace
graph export $data\graph\labeled\figure_a11.pdf, replace
