*\ 20 Results Robustness: Finer Analysis 

*Version: 1 

*Last Modified: 07/21
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Robustness checks using the greater number of observations 
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	All cleaning and merging
		
+ Inputs: 

		* UCDP data
		* Census and casualty data

		
+ Outputs
	
		* Appendix Table 
  
  Changed:
	*Version 1: First version, no changes to log.
		Issues with bandwidth selection in the 1910 specification
	*07/22: Problem solved, selected bandwidth manually using h
		Get tables tomorrow. 
	


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
 

import delimited "`RAW'\gedevents-2022-05-14.csv", bindquote(strict) clear

replace municipality = "Belgrade" if municipality =="Barajevo" | municipality =="Cukarina" | municipality =="Grocka" | municipality =="Lazurevac" | municipality =="Mladenovac" |municipality == "Novi Beograd" | municipality =="Obrenovac" | municipality =="Palilula" | municipality =="Rakovica" | municipality =="Sovski Venac" | municipality =="Sopot" | municipality =="Stari Grad" |municipality =="Vracar" | municipality =="Vozdovac" | municipality =="Zemun" | municipality =="Zvezdara"
 
merge m:1 municipality using "\Censuscasualties.dta"
 
save "\Conflict_munic.dta", replace
 
**** Creating the running variables ****

gen RV_UCDP = dist_1910
replace RV_UCDP = -1*dist_1910 if ah_indic == 0

gen RV_UCDP_2 = dist_nobos
replace RV_UCDP_2 = -1*dist_nobos if nobos_indic == 0 


 
 * +++++ 1910 Border +++++ *
 rename Total ww2_casualties
 
* ========== RD Specification ========== *
encode municipality, generate(munic_fact)


xi: rdrobust best_est RV_UCDP, vce(cluster munic_fact) all
estimates store mA61, title((1))

xi: rdrobust best_est RV_UCDP, covs(TRI_mean) vce(cluster munic_fact) all 
estimates store mA62, title((2))

xi: rdrobust best_est RV_UCDP, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all 
estimates store mA63, title((3))


xi: rdrobust best_est RV_UCDP, h(250) kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store mA64, title((4))
 
 esttab mA61 mA62 mA63 mA64 using "`Outputs'\TableA6a.tex", title(1910: Conflict Level) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber
eststo clear
 
 
 * +++++ No BiH Border +++++ *
xi: rdrobust best_est RV_UCDP_2, vce(cluster munic_fact) all
estimates store mA61b, title((1))

xi: rdrobust best_est RV_UCDP_2, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mA62b, title((2))

xi: rdrobust best_est RV_UCDP_2, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mA63b, title((3))

xi: rdrobust best_est RV_UCDP_2, h(250) kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store mA64b, title((4))

 esttab mA61b mA62b mA63b mA64b using "`Outputs'\TableA6b.tex", title(1867: Conflict Level) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber
eststo clear