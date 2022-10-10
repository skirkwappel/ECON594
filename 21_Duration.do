*\ 20 Results Duration 

*Version: 1 

*Last Modified: 07/20
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Mechanism Table 
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	All cleaning and merging
		
+ Inputs: 

		* Municipality level.dta

		
+ Outputs
	
		* Table 3
  
  Changed:
	*Version 1: First version, no changes to log.
	*07/20 Fix border spec, re-do tables 


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

local Outputs "`workingdir'\Outputs"

***** Importing the data ***** 
 
 
 * ================= MECHANISM: DURATION ================== * 
 
use "\Municipality level.dta", clear

*** Dropping Belgrade duplicates
drop if municipality =="Barajevo" | municipality =="Cukarina" | municipality =="Grocka" | municipality =="Lazurevac" | municipality =="Mladenovac" |municipality == "Novi Beograd" | municipality =="Obrenovac" | municipality =="Palilula" | municipality =="Rakovica" | municipality =="Sovski Venac" | municipality =="Sopot" | municipality =="Stari Grad" |municipality =="Vracar" | municipality =="Vozdovac" | municipality =="Zemun" | municipality =="Zvezdara"
 
 
* ========== Border Specification ========== *
 * === 1910 Border === * 

eststo: reg outcome ah_indic D_100 if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic D_100 TRI_mean if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic D_100 TRI_mean ethnic_polar if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic D_100 TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 < 250, vce(cluster municipality)
 
 
 * === No BiH Border === *
eststo: reg outcome nobos_indic D_100 if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic D_100 TRI_mean if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic D_100 TRI_mean ethnic_polar if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic D_100 TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos < 250, vce(cluster municipality)

esttab using "`Outputs'\Table3a.tex", title(Old Border: Border Specification) mlabel((1) (2) (3) (4) (5) (6) (7) (8)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) se label page(dcolumn) nonumber r2
eststo clear

* ++++++ Grosjean (2011) finds social trust after 400 years of common imperial rule, but I'm going to make it 200 because I don't have enough observations +++++*

* === 1910 Border === * 

eststo: reg outcome ah_indic D_200 if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic D_200 TRI_mean if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic D_200 TRI_mean ethnic_polar if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic D_200 TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 < 250, vce(cluster municipality)
 
 
 * === No BiH Border === *
eststo: reg outcome nobos_indic D_200 if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic D_200 TRI_mean if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic D_200 TRI_mean ethnic_polar if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic D_200 TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos < 250, vce(cluster municipality)

esttab using "`Outputs'\Table3b.tex", title(Old Border: Border Specification) mlabel((1) (2) (3) (4) (5) (6) (7) (8)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) se label page(dcolumn) nonumber r2
eststo clear

