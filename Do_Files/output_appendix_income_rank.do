global data="C:\Users\alen_\Dropbox\paper_folder\replication\data"

** 1980 1990 2000 2010 income comes from demographic do file. 
clear all

cd $data\temp_files

u 1980_income, clear

collapse income [w=count], by(metarea gisjoin)
egen rank_income=xtile(income), n(5) by(metarea)

keep gisjoin rank_income

save 1980_income_rank, replace

u 1990_income, clear

collapse income [w=count], by(metarea gisjoin)
egen rank_income=xtile(income), n(5) by(metarea)

keep gisjoin rank_income

save 1990_income_rank, replace

u 2000_income, clear

collapse income [w=count], by(metarea gisjoin)
egen rank_income=xtile(income), n(5) by(metarea)

keep gisjoin rank_income

save 2000_income_rank, replace

u 2010_income, clear

collapse income [w=count], by(metarea gisjoin)
egen rank_income=xtile(income), n(5) by(metarea)

keep gisjoin rank_income

save 2010_income_rank, replace

**** income rank vs distance to downtown

cd $data\temp_files
u 1980_income_rank, clear
cd $data\geographic
merge 1:1 gisjoin using tract1980_downtown_200mi
keep if _merge==3
drop _merge

merge 1:1 gisjoin using tract1980_metarea
keep if _merge==3
drop _merge
replace distance=distance/1609
cd $data\temp_files
g year=1980
save temp1980, replace

cd $data\temp_files
u 1990_income_rank, clear
cd $data\geographic
merge 1:1 gisjoin using tract1990_downtown_200mi
keep if _merge==3
drop _merge

merge 1:1 gisjoin using tract1990_metarea
keep if _merge==3
drop _merge

replace distance=distance/1609
cd $data\temp_files
g year=1990
save temp1990, replace

cd $data\temp_files
u 2000_income_rank, clear
cd $data\geographic
merge 1:1 gisjoin using tract2000_downtown_200mi
keep if _merge==3
drop _merge

merge 1:1 gisjoin using tract2000_metarea
keep if _merge==3
drop _merge

replace distance=distance/1609
cd $data\temp_files
g year=2000
save temp2000, replace

cd $data\temp_files
u 2010_income_rank, clear
cd $data\geographic
merge 1:1 gisjoin using tract2010_downtown_200mi
keep if _merge==3
drop _merge

merge 1:1 gisjoin using tract2010_metarea
keep if _merge==3
drop _merge

replace distance=distance/1609
cd $data\temp_files
g year=2010
save temp2010, replace

clear 

u temp1980, clear
append using temp1990
append using temp2000
append using temp2010

cd $data\graph
# delimit 
graph twoway (lpoly rank_income distance if distance<=30 & year==1980,lpattern(dash)) 
(lpoly rank_income distance if distance<=30  & year==1990, lpattern(shortdash) )
(lpoly rank_income distance if distance<=30 & year==2000 , lpattern(longdash_dot))
 (lpoly rank_income distance if distance<=30 & year==2010, lcolor(black)) if metarea==160,
 legend(lab(1 "1980") lab(2 "1990") lab(3 "2000") lab(4 "2010") ) yscale(range(1 5)) ylabel(1(1)5)
 xtitle(distance to downtown (mile)) ytitle(Income quintile) graphregion(color(white))
 ;
 # delimit cr
 graph export chicago_income_quitile_distance.emf, replace
 
 # delimit 
graph twoway (lpoly rank_income distance if distance<=30 & year==1980,lpattern(dash)) 
(lpoly rank_income distance if distance<=30  & year==1990, lpattern(shortdash) )
(lpoly rank_income distance if distance<=30 & year==2000 , lpattern(longdash_dot))
 (lpoly rank_income distance if distance<=30 & year==2010, lcolor(black)) if metarea==560,
 legend(lab(1 "1980") lab(2 "1990") lab(3 "2000") lab(4 "2010") )  yscale(range(1 5)) ylabel(1(1)5)
 xtitle(distance to downtown (mile)) ytitle(Income quintile) graphregion(color(white))
 ;
 # delimit cr
  graph export ny_income_quitile_distance.emf, replace

 
 ********************************************************
 ********************************************************
 ********************************************************
 
  *** In a map (do stata instead of ArcMap)

  

**** Chicago

cd $data\temp_files
u 1980_income_rank, clear

cd $data\geographic
merge 1:1 gisjoin using longitude_latitude_tract1980
drop _merge

ren gisjoin GISJOIN

merge 1:1 GISJOIN using tract1980_shape

spmap rank_income using tract1980_coord if latitude<=5180000 & latitude>=5123040 & longitude>=-9801742 & longitude<=-9743004, id(id) fcolor(Reds) legend(pos(1)) cln(5)
cd $data\graph
graph export chicago_ranking_1980.png, replace

cd $data\temp_files
u 1990_income_rank, clear

cd $data\geographic
merge 1:1 gisjoin using longitude_latitude_tract1990
drop _merge

ren gisjoin GISJOIN

merge 1:1 GISJOIN using tract1990_shape

spmap rank_income using tract1990_coord if latitude<=5180000 & latitude>=5123040 & longitude>=-9801742 & longitude<=-9743004, id(id) fcolor(Reds) legend(pos(1)) cln(5)
cd $data\graph
graph export chicago_ranking_1990.png, replace


cd $data\temp_files
u 2000_income_rank, clear

ren gisjoin GISJOIN
cd $data\geographic
merge 1:1 GISJOIN using tract2000_shape

spmap rank_income using tract2000_coord if latitude<=5180000 & latitude>=5123040 & longitude>=-9801742 & longitude<=-9743004, id(id) fcolor(Reds) legend(pos(1)) cln(5)
cd $data\graph
graph export chicago_ranking_2000.png, replace

cd $data\temp_files
u 2010_income_rank, clear

ren gisjoin GISJOIN
cd $data\geographic
merge 1:1 GISJOIN using tract2010_shape

spmap rank_income using tract2010_coord if latitude<=5180000 & latitude>=5123040 & longitude>=-9801742 & longitude<=-9743004, id(id) fcolor(Reds) legend(pos(1)) cln(5)
cd $data\graph
graph export chicago_ranking_2010.png, replace

*****************************
******************************

**** New York

cd $data\temp_files
u 1980_income_rank, clear

cd $data\geographic
merge 1:1 gisjoin using longitude_latitude_tract1980
drop _merge

ren gisjoin GISJOIN

merge 1:1 GISJOIN using tract1980_shape

spmap rank_income using tract1980_coord if latitude<=5012000 & latitude>=4949000 & longitude>=-8265000 & longitude<=-8199000, id(id) fcolor(Reds) legend(pos(5)) cln(5)
cd $data\graph
graph export nyc_ranking_1980.png, replace

cd $data\temp_files
u 1990_income_rank, clear

cd $data\geographic
merge 1:1 gisjoin using longitude_latitude_tract1990
drop _merge

ren gisjoin GISJOIN

merge 1:1 GISJOIN using tract1990_shape

spmap rank_income using tract1990_coord if latitude<=5012000 & latitude>=4949000 & longitude>=-8265000 & longitude<=-8199000, id(id) fcolor(Reds) legend(pos(5)) cln(5)
cd $data\graph
graph export nyc_ranking_1990.png, replace



cd $data\temp_files
u 2000_income_rank, clear

ren gisjoin GISJOIN

cd $data\geographic
merge 1:1 GISJOIN using tract2000_shape

spmap rank_income using tract2000_coord if latitude<=5012000 & latitude>=4949000 & longitude>=-8265000 & longitude<=-8199000, id(id) fcolor(Reds) legend(pos(5)) cln(5)
cd $data\graph
graph export nyc_ranking_2000.png, replace

cd $data\temp_files
u 2010_income_rank, clear

ren gisjoin GISJOIN
cd $data\geographic
merge 1:1 GISJOIN using tract2010_shape

spmap rank_income using tract2010_coord if latitude<=5012000 & latitude>=4949000 & longitude>=-8265000 & longitude<=-8199000, id(id) fcolor(Reds) legend(pos(5)) cln(5)
cd $data\graph
graph export nyc_ranking_2010.png, replace
