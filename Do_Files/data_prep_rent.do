clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"


cd $data\nhgis

import delimited nhgis0018_ds120_1990_tract.csv, clear

ren est001 hp
ren es6001 rent
keep gisjoin hp rent
sort gisjoin
replace hp=hp*218.056/130.7
replace rent=rent*218.056/130.7

cd $data\temp_files
save rent1990, replace

cd $data\nhgis
import delimited nhgis0018_ds151_2000_tract.csv, clear

ren gb7001 hp
ren gbg001 rent
keep gisjoin hp rent
sort gisjoin
replace hp=hp*218.056/172.2
replace rent=rent*218.056/172.2
cd $data\temp_files

save rent2000, replace

cd $data\nhgis
import delimited nhgis0018_ds184_20115_2011_tract.csv, clear 
ren muje001 rent
ren mu2e001 hp
keep gisjoin hp rent
sort gisjoin
cd $data\temp_files

save rent2010, replace



cd $data\geographic

u tract1990_tract2010_nearest, clear

ren gisjoin1 gisjoin

cd $data\temp_files
merge m:1 gisjoin using rent1990
keep if _merge==3
drop _merge
ren gisjoin gisjoin1
ren rent rent1990
ren gisjoin2 gisjoin

merge m:1 gisjoin using rent2010
keep if _merge==3
drop _merge
ren rent rent2010

drop gisjoin

cd $data\geographic
merge 1:1 gisjoin1 using tract1990_tract2000_nearest
keep if _merge==3
drop _merge

ren gisjoin2 gisjoin
cd $data\temp_files
merge m:1 gisjoin using rent2000
keep if _merge==3
drop _merge 
ren rent rent2000

drop gisjoin
ren gisjoin1 gisjoin
keep gisjoin rent*
save rent, replace


*** fill in the rent with MSA-level average rent
cd $data\temp_files
u rent, clear

cd $data\geographic
merge 1:1 gisjoin using tract1990_metarea
cd $data\temp_files
keep if _merge==3
drop _merge

save temp, replace

collapse mean_rent1990=rent1990 mean_rent2000=rent2000 mean_rent2010=rent2010, by(metarea)
save rent_metarea, replace

merge 1:m metarea using temp
drop _merge

replace rent1990=mean_rent1990 if rent1990==0
replace rent2000=mean_rent2000 if rent2000==0
replace rent2010=mean_rent2010 if rent2010==0

replace rent1990=mean_rent1990 if rent1990==.
replace rent2000=mean_rent2000 if rent2000==.
replace rent2010=mean_rent2010 if rent2010==.

keep gisjoin rent2010 rent2000 rent1990
sort gisjoin

save rent, replace
