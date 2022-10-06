********************************************************************************
*																			   *
*								Title: 01_CleaningTRI.do		 	 		   *
*																			   *
********************************************************************************


*Creation: Made by Sarah Wappel on 07/04/2022

*Version: 1 

*Last Modified: 07/07
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Merging the TRI means for each municipality to the master municipality 
	dataset. Finding the missing observation what Arcgis dropped and fixing it 
	via hardcoding and cross referencing Arc. Then merging with the hubdistances
	calculated in QGIS
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	No
		
+ Inputs: 

		* CSV version of Popovic's YUG91 shapefile
		* CSV of Arcgis model builder output TRI_means
		* CSV of centriod distances calculated from QGIS

		
+ Outputs
	
		* Create YUG91.dta which will later be merged with census and WWII 
		casualty data
  
  Changed:
	*Version 1: First version, no changes to log.
	07/06: Manually inputted TRI for Belgrade after merging features 
	07/07: merged with centriod distances after calculating centriods for 
	new Belgrade municipality


 ==============================  TOP MATTER ==============================*/
 
**************** Set arguments ****************
macro drop _all
clear all 

**************** Project paths ****************
local workingdir "\Users\skirk\Dropbox\AH Yugoslavia Project" 
di "This project is in `workingdir'"

local RAW "`workingdir'\Raw"
di "`RAW'"

local GIS "`workingdir'\GIS"
di "`GIS'"

**************** Importing the data ****************

import delimited "`GIS'\YUG91final.csv", clear
save "`workingdir'\YUG91.dta", replace

import delimited "`GIS'\TRI_means.csv", clear 

merge 1:1 munic using "\YUG91.dta"
tab name if _merge==2

/* Missing observation: Cres-Losinj 
	This issue undoubtedly stems from the "-" but it would take far too long to 
	re-run the whole set, so I will just redo the extract by mask + zonal stats
	for Cres-Losinj (using the QGIS calculated TRI layer as the input 
	and YUG91 shapefile with C-L selected as the mask) and then add it here. 
	Referencing model outputs from Arc the mean TRI is 76.845148816308
	Missing observation: Belgrade
	Belgrade created from joining smaller polygons in Arcgis to ensure 
	consistency with census data. Same process as above run, mean TRI is 19.9179
	*/
	
rename mean TRI_mean

replace TRI_mean = 76.845148816308 if name=="Cres-Losinj"

replace TRI_mean = 19.9178783113008 if name == "Belgrade"

/* Belgrade granuarity: YUG91 and casualty dataset have Belgrade in various 
	municipalities. The census data does not. 
*/

drop oid_ zone_code area munic id_2 _merge 


save "\YUG91.dta", replace

import delimited "`GIS'\hubdist centriods AH.csv", clear 

merge 1:1 name using "\YUG91.dta"

drop _merge
save "\YUG91.dta", replace

