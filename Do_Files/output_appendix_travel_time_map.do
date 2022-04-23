global data="C:\Users\alen_\Dropbox\paper_folder\replication\data"

*** Chicago travel time to (zip: 60605)
cd $data\temp_files
u travel_time_hat, clear

keep if zip==60605 | zip==10005

cd $data\geographic
merge 1:1 gisjoin using longitude_latitude_tract1990
drop _merge

ren gisjoin GISJOIN

merge 1:1 GISJOIN using tract1990_shape

** Chicago
spmap travel_time_hat using tract1990_coord if latitude<=5180000 & latitude>=5123040 & longitude>=-9801742 & longitude<=-9743004, id(id) fcolor(Reds) legend(pos(1)) cln(8)
cd $data\graph
graph export map_travel_time_chicago.png, replace

*** New York travel time to (zip: 10005)
cd $data\geographic
spmap travel_time_hat using tract1990_coord if latitude<=5012000 & latitude>=4949000 & longitude>=-8265000 & longitude<=-8199000, id(id) fcolor(Reds) legend(pos(2)) cln(8)
cd $data\graph
graph export map_travel_time_nyc.png, replace


*** Expected commute time

*** Chicago
cd $data\temp_files\commute

u commute, clear

keep if occ2010==120 | occ2010==2100 | occ2010==4720

*** Chicago: Financial manager

cd $data\geographic
merge m:1 gisjoin using longitude_latitude_tract1990
drop _merge

replace expected_commute=expected_commute/10

ren gisjoin GISJOIN

merge m:1 GISJOIN using tract1990_shape
cd $data\geographic
spmap expected_commute using tract1990_coord if latitude<=5180000 & latitude>=5123040 & longitude>=-9801742 & longitude<=-9743004 & occ2010==120, id(id) fcolor(Reds) legend(pos(1)) clm(c) clb(0 0.32 0.34 0.36 0.38 0.4 0.42 0.45 0.8 2)

cd $data\graph
graph export expected_commute_financial_chicago.png, replace

*** CHicago: Lawyer
cd $data\geographic
spmap expected_commute using tract1990_coord if latitude<=5180000 & latitude>=5123040 & longitude>=-9801742 & longitude<=-9743004 & occ2010==2100, id(id) fcolor(Reds) legend(pos(1)) clm(c) clb(0 0.32 0.34 0.36 0.38 0.4 0.42 0.45 0.8 2)
cd $data\graph
graph export expected_commute_lawyer_chicago.png, replace

*** CHicago: Cashier
cd $data\geographic
spmap expected_commute using tract1990_coord if latitude<=5180000 & latitude>=5123040 & longitude>=-9801742 & longitude<=-9743004 & occ2010==4720, id(id) fcolor(Reds) legend(pos(1)) clm(c) clb(0 0.32 0.34 0.36 0.38 0.4 0.42 0.45 0.8 2)
cd $data\graph
graph export expected_commute_cashier_chicago.png, replace

*******************************************************************************************
*** New York

cd $data\temp_files\commute

u commute, clear

keep if occ2010==120 | occ2010==2100 | occ2010==4720

*** Chicago: FInancial manager

cd $data\geographic
merge m:1 gisjoin using longitude_latitude_tract1990
drop _merge

replace expected_commute=expected_commute/10

ren gisjoin GISJOIN

merge m:1 GISJOIN using tract1990_shape
cd $data\geographic
spmap expected_commute using tract1990_coord if latitude<=5012000 & latitude>=4949000 & longitude>=-8265000 & longitude<=-8199000 & occ2010==120, id(id) fcolor(Reds) legend(pos(1)) clm(c) clb(0 0.42 0.44 0.46 0.48 0.5 0.52 0.55 0.9 2)

cd $data\graph
graph export expected_commute_financial_nyc.png, replace

*** CHicago: Lawyer
cd $data\geographic
spmap expected_commute using tract1990_coord if latitude<=5012000 & latitude>=4949000 & longitude>=-8265000 & longitude<=-8199000 & occ2010==2100, id(id) fcolor(Reds) legend(pos(1)) clm(c) clb(0 0.42 0.44 0.46 0.48 0.5 0.52 0.55 0.9 2)
cd $data\graph
graph export expected_commute_lawyer_nyc.png, replace

*** CHicago: Cashier
cd $data\geographic
spmap expected_commute using tract1990_coord if latitude<=5012000 & latitude>=4949000 & longitude>=-8265000 & longitude<=-8199000 & occ2010==4720, id(id) fcolor(Reds) legend(pos(1)) clm(c) clb(0 0.42 0.44 0.46 0.48 0.5 0.52 0.55 0.9 2)
cd $data\graph
graph export expected_commute_cashier_nyc.png, replace
