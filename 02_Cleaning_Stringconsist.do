*\ 02 Cleaning: String Consistency

*Version: 1 

*Last Modified: 07/07
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================
**# Bookmark #1

+ PURPSOSE:
	
	Cleaning data to ensure string consistency for more merges
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	Not in Stata
		
+ Inputs: 

		* excel census files from Kukic + the Kosovo covariates created
		* YUG91 (merged with hubdistances) CSV

		
+ Outputs
	
		* Census data with (almost) full set of controls
  
  Changed:
	*Version 1: First version, no changes to log.
	07/06: Manually inputted TRI for Belgrade after merging features 
	07/07: calculated population density using Arcgis calculated area, kept 
	Belgrade sub municipalities to ease merge with WWII casualty data


 ==============================  TOP MATTER ==============================*/
 
 macro drop _all
clear all 

**************** Project paths ****************
local workingdir "\Users\skirk\Dropbox\AH Yugoslavia Project" 
di "This project is in `workingdir'"

local RAW "`workingdir'\Raw"
di "`RAW'"

local GIS "`workingdir'\GIS"
di "`GIS'"

*********************************************

import excel "`RAW'\Census.xlsx", sheet("Apended") firstrow clear

rename municipality name

replace name = "Djurdjevac" if name == "Djurdevac"
replace name = "Jagodina" if name == "Svetozarevo"

gen kosovo = 0

replace kosovo = 1 if missing(jna)


save "\Census.dta", replace

merge 1:1 name using "\YUG91.dta"


gen macedonia = 0

replace macedonia = 1 if _merge==2

replace macedonia = 0 if name == "Sremski Karlovci" | name =="Barajevo" | name =="Cukarina" | name =="Grocka" | name =="Lazurevac" | name =="Mladenovac" |name == "Novi Beograd" | name =="Obrenovac" | name =="Palilula" | name =="Rakovica" | name =="Sovski Venac" | name =="Sopot" | name =="Stari Grad" |name =="Vracar" | name =="Vozdovac" | name =="Zemun" | name =="Zvezdara" 

rename name municipality

drop _merge

* Calculating population density using Arcgis calculated area, for consistency

gen pop_dens_arc = 0
replace pop_dens_arc = population / sqkm

save "\Census.dta", replace