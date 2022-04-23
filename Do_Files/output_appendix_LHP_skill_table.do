clear all
global data="C:\Users\alen_su\Dropbox\paper_folder\replication\data"

cd $data\temp_files

u val_40_60_total_1990_2000_2010, clear

merge 1:1 occ2010 using high_skill
keep if _merge==3
drop _merge

g dval=val_2010-val_1990
g neg_high_skill=-high_skill
sort neg_high_skill occ2010

order occ2010 val_1990 val_2000 val_2010 dval high_skill

** Table A10
edit occ2010 val_1990 val_2010 dval high_skill if val_1990!=. & val_2000!=. & val_2010!=.