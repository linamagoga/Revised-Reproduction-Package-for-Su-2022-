
clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

*************************
** Hours definition changes before and after 1976. 
cd $data\cps
u cps_hours_annual, clear
keep if sex==1
keep if age<=65 & age>=25
drop if uhrsworkly>=997
drop if uhrsworkly<30
keep if year>=1976
replace inctot=. if inctot>=99999998

*** generate income percentile for each year

g wage_tile=.
g wage=inctot/uhrsworkly
foreach num of numlist 1976(1)2015 {
xtile wage_tile`num'=wage if year==`num', nq(10)
replace wage_tile=wage_tile`num' if year==`num'
}
cd $data\temp_files
save temp, replace

*** 1962 to 1976
cd $data\cps
u cps_hours, clear
keep if sex==1
keep if age<=65 & age>=25
drop if ahrsworkt>=997
drop if ahrsworkt<30
replace inctot=. if inctot>=99999998

*** generate income percentile for each year

g wage_tile=.
g wage=inctot/ahrsworkt
foreach num of numlist 1962(1)1975 {
xtile wage_tile`num'=wage if year==`num', nq(10)
replace wage_tile=wage_tile`num' if year==`num'
}
cd $data\temp_files
save temp_1962_1975, replace


*** Generate three year moving average of the percentage of full-time workers working at least 50 hours a week

foreach num of numlist 1962(1)2017 {
u temp_1962_1975, clear
append using temp
g greaterthan50=0
replace greaterthan50=1 if ahrsworkt>=50 & ahrsworkt<990 & year<=1975
replace greaterthan50=1 if uhrsworkly>=50 & uhrsworkly<990 & year>=1976
keep if ahrsworkt>=30 | uhrsworkly>=30

keep if year<=`num'+1 & year>=`num'-1
g wage_quintile=1 if wage_tile>=1 & wage_tile<=2
replace wage_quintile=2 if wage_tile>=3 & wage_tile<=4
replace wage_quintile=3 if wage_tile>=5 & wage_tile<=6
replace wage_quintile=4 if wage_tile>=7 & wage_tile<=8
replace wage_quintile=5 if wage_tile>=9 & wage_tile<=10

collapse greaterthan50, by(wage_tile)
g year=`num'
save temp_year`num'_g50, replace
}

clear all
foreach num of numlist 1962(1)2015 {
append using temp_year`num'_g50
}


# delimit 
graph twoway (connected greaterthan50 year if wage_tile==10, msymbol(diamond) msize(small)) (connected greaterthan50 year if wage_tile==1, msize(small))
,yscale(range(0.1 0.6)) ylabel(0.1(0.2)0.6) xlabel(1960(10)2015) graphregion(color(white)) 
xtitle(year) ytitle(Percentage of working >=50 hrs/week) legend(lab(1 "Percent of working long-hour (Top wage decile)") lab(2 "Percent of working long-hour (Bottom wage decile)") col(1)) ;
# delimit cr

graph export $data\graph\hour_trend_1962_2016.png, replace