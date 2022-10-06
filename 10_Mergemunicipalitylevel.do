********************************************************************************
*																			   *
*								Title: 1_Merges.do		 	 		   *
*																			   *
********************************************************************************


*Creation: Made by Sarah Wappel on 07/06/2022

*Version: 1 

*Last Modified: 07/07
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Merging the datasets into the master
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	Not in Stata
		
+ Inputs: 

		* YUG91 shapefile as csv

		
+ Outputs
	
		* Create YUG91.dta which will later be merged with census and WWII 
		casualty data
  
  Changed:
	*Version 1: First version, no changes to log.
	07/07: Fix string errors in WWII casualty data, merge with census data


 ==============================  TOP MATTER ==============================*/
 
import excel "C:\Users\skirk\Downloads\casualties by municipality.xlsx", sheet("Sheet1") firstrow clear
replace Total = 0 if Total==.
replace Serbs = 0 if Serbs==.
replace Croats = 0 if Croats==.
replace Jews = 0 if Jews==.
replace Slovenes = 0 if Slovenes==.
replace Muslims = 0 if Muslims==.
replace Montenegrins = 0 if Montenegrins==.
replace Roma = 0 if Roma==.
replace Macedonians = 0 if Macedonians==.
replace Roma = 0 if Roma==.
replace Albanians = 0 if Albanians==.
replace Hungarians = 0 if Hungarians==.
replace Slovakians = 0 if Slovakians==.
replace Turks = 0 if Turks==.


replace municipality = "Djurdjevac" if municipality == "Djurdevac"
replace municipality = "Gorazde" if municipality == "Goradze"
replace municipality = "Jagodina" if municipality == "Svetozarevo"
replace municipality = "Korenica" if municipality == "Titova Korenica"
replace municipality = "Postojna" if municipality == "Postonja"
replace municipality = "Svilajnac" if municipality == "Svilanjac"
replace municipality = "Varazdin" if municipality == "Varadzin"
replace municipality = "Veles" if municipality == "Titov Veles"
replace municipality = "Vozdovac" if municipality == "Vodzovac"
save "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Casualties.dta", replace

use "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Census.dta"

merge 1:1 municipality using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Casualties.dta"

drop if _merge==2 
drop _merge

save "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Censuscasualties.dta", replace

