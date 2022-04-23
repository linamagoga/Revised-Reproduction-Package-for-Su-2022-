clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"
*** import area (1980 census tract)
cd $data\geographic
import delimited UStract1980.csv, varnames(1) clear 

keep gisjoin area_sm
destring area_sm, g(area) ignore(",")

keep gisjoin area
cd $data\geographic
save area1980, replace


*** housing in the 1980s
cd $data\nhgis
import delimited nhgis0034_ds107_1980_tract.csv, clear
ren def001 room

keep gisjoin room
sort gisjoin
cd $data\temp_files
save room1980, replace


** Create room density (using 1980 housing data)
cd $data\geographic
u tract1990_tract1980_1mi, clear

ren gisjoin2 gisjoin
cd $data\geographic
merge m:1 gisjoin using area1980
drop _merge
cd $data\temp_files
merge m:1 gisjoin using room1980
drop _merge

collapse (sum) area room, by(gisjoin1)

g room_density_1mi_3mi=(room)/(area)
replace room_density_1mi_3mi=0 if room_density_1mi_3mi==.
ren gisjoin1 gisjoin

save room_density1980_1mi, replace