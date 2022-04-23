clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


cd $data\ipums_micro
u 1990_2000_2010_temp , clear

keep if uhrswork>=30

keep if year==1990 | year==2010

drop wage distance tranwork trantime pwpuma ownershp ownershpd gq

drop if uhrswork==0
replace inctot=0 if inctot<0
replace inctot=. if inctot==9999999

collapse (count) count=inctot, by(occ2010 year)

reshape wide count ,i(occ2010) j(year)

cd $data\temp_files
save count1990_onet, replace


cd $data\onet
import delimited "Work Context_2016.txt", clear 
g code=substr(onetsoccode,1,7)
destring code, g(code_num) ignore("-")
sort code
drop code
tostring code_num, g(code)
g soc_rough=substr(code,1,4)
drop if category=="n/a"
sort soc_rough

cd $data\temp_files
save work_context_2016, replace


cd $data\onet
import excel "2010_OccCode_Crosswalk.xls", sheet("2010OccCodeList") firstrow clear
destring soc_l, g(soc_l_num) ignore("-")
destring soc_u, g(soc_u_num) ignore("-")
destring occ2010, g(occ2010_num)
drop occ2010
ren occ2010_num occ2010
drop soc_l soc_u
ren soc_l_num soc_l
ren soc_u_num soc_u
drop A
tostring soc_l, g(soc_l_st)
g soc_rough=substr(soc_l_st,1,4)
sort soc_rough

cd $data\temp_files
save 2010_occcode_crosswalk, replace

cd $data\temp_files
u 2010_occcode_crosswalk, clear
joinby soc_rough using work_context_2016
keep if code_num<=soc_u & code_num>=soc_l

destring category, g(category_num)

g score=datavalue*(25*(category_num-1))/100
replace score=datavalue*(50*(category_num-1))/100 if elementname=="Duration of Typical Work Week" | elementname=="Work Schedules"
collapse (sum) score, by(occ_name occ2010 elementname onetsoccode date domainsource)
collapse score, by(occ2010 elementname onetsoccode)

by occ2010 elementname: g rank=_n
keep if rank==1

cd $data\temp_files
save soc_occ_context_score, replace



*** standardize the scores

cd $data\temp_files
u soc_occ_context_score, clear

egen element=group(elementname)
drop elementname

reshape wide score, i(occ2010) j(element)

cd $data\temp_files
merge 1:1 occ2010 using val_40_60_total_1990_2000_2010
keep if _merge==3
drop _merge
*drop dval
g dval=val_2010-val_1990
keep if dval!=. 

cd $data\temp_files
merge 1:1 occ2010 using count1990_onet

keep if _merge==3
drop _merge

foreach num of numlist 1(1)57 {
sum score`num' [w=count1990]
replace score`num'=(score`num'-r(mean))/r(sd)
}

sum dval  [w=count1990]
replace dval=(dval-r(mean))/r(sd)

keep occ2010 count1990 score* dval


*** weight by count
replace dval=dval*sqrt(count1990)

foreach num of numlist 1(1)57 {
replace score`num'=score`num'*sqrt(count1990)
}
*/
ren score1 score01
ren score2 score02
ren score3 score03
ren score4 score04
ren score5 score05
ren score6 score06
ren score7 score07
ren score8 score08
ren score9 score09

cd $data\temp_files
export delimited using "temp_occ_char.csv", replace

