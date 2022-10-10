*\ 20 Falsification: Dropping Extreme events

*Version: 1 

*Last Modified: 07/19
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
	
		* Tables --> GRAVEYARD
  
  Changed:
	*Version 1: First version, no changes to log.
	


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
 
 use "\Municipality level.dta", clear

*** Dropping Belgrade duplicates
drop if municipality =="Barajevo" | municipality =="Cukarina" | municipality =="Grocka" | municipality =="Lazurevac" | municipality =="Mladenovac" |municipality == "Novi Beograd" | municipality =="Obrenovac" | municipality =="Palilula" | municipality =="Rakovica" | municipality =="Sovski Venac" | municipality =="Sopot" | municipality =="Stari Grad" |municipality =="Vracar" | municipality =="Vozdovac" | municipality =="Zemun" | municipality =="Zvezdara"
 
 drop if municipality == "Srebrenica"
 
* === 1910 Border === * 
* ========== Border Specification ========== *
reg outcome ah_indic, vce(cluster municipality)

reg outcome ah_indic i.country, vce(cluster municipality)

reg outcome ah_indic TRI_mean, vce(cluster municipality)

reg outcome ah_indic TRI_mean ethnic_polar, vce(cluster municipality)

reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties, vce(cluster municipality)

* ========== RD Specification ========== *
rdrobust outcome RV, p(2) vce(cluster munic_fact) all

rdrobust outcome RV i.country, p(2) vce(cluster munic_fact) all

rdrobust outcome RV, covs(TRI_mean) vce(cluster munic_fact) all

rdrobust outcome RV, kernel(tri) p(2) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all

rdrobust outcome RV, kernel(tri) p(2) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all 



* === No BiH Border === *
* ========== Border Specification ========== *
reg outcome nobos_indic, vce(cluster municipality)

reg outcome nobos_indic i.country, vce(cluster municipality)

reg outcome nobos_indic TRI_mean, vce(cluster municipality)

reg outcome nobos_indic TRI_mean ethnic_polar, vce(cluster municipality)

reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties, vce(cluster municipality)

* ========== RD Specification ========== *
rdrobust outcome RV_2, p(2) vce(cluster munic_fact) all

rdrobust outcome RV i.country, p(2) vce(cluster munic_fact) all

rdrobust outcome RV_2, covs(TRI_mean) vce(cluster munic_fact) all

rdrobust outcome RV_2, kernel(tri) p(2) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all

rdrobust outcome RV_2, kernel(tri) p(2) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all