*\ 20 Results Robustness: Types of Conflict

*Version: 1 

*Last Modified: 07/22
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Robustness checks: Different types of conflicts
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	All cleaning and merging
		
+ Inputs: 

		* Municipality level.dta

		
+ Outputs
	
		* Table 
  
  Changed:
	*Version 1: First version, no changes to log.
	*07/20 Esttab added, variable creation moved to 03_Cleaning_creating
	*07/21 Narrowed border specification in line with the empirical strategy
	*07/22 Tables for RD


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


* === 1910 Border === * 
* ========== Border Specification ========== *

*Panel A: State Based
eststo: reg outcome_1 ah_indic if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_1 ah_indic TRI_mean if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_1 ah_indic TRI_mean ethnic_polar if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_1 ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 < 250, vce(cluster municipality)

esttab using "`Outputs'\TableA4a.tex", title(Old Border: Border Spec State Based) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label page(dcolumn) nonumber r2
eststo clear

*Panel B: Non-State
eststo: reg outcome_2 ah_indic if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_2 ah_indic TRI_mean if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_2 ah_indic TRI_mean ethnic_polar if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_2 ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 < 250, vce(cluster municipality)

esttab using "`Outputs'\TableA4b.tex", title(Old Border: Border Spec Non-State) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label page(dcolumn) nonumber r2
eststo clear

*Panel C: One-Sided 
eststo: reg outcome_3 ah_indic if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_3 ah_indic TRI_mean if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_3 ah_indic TRI_mean ethnic_polar if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome_3 ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 < 250, vce(cluster municipality)

esttab using "`Outputs'\TableA4c.tex", title(Old Border: Border Spec One-Sided) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label page(dcolumn) nonumber r2
eststo clear

* +++++ Regression Discontinuity +++++ * 
encode municipality, generate(munic_fact)

*Panel A
xi: rdrobust outcome_1 RV, vce(cluster munic_fact) all
estimates store mA51, title((1))

xi: rdrobust outcome_1 RV, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mA52, title((3))

xi: rdrobust outcome_1 RV, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mA53, title((4))

xi: rdrobust outcome_1 RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store mA54, title((5))

esttab mA51 mA52 mA53 mA54 using "`Outputs'\TableA4d.tex", title(1910 RD State-Based) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber r2
eststo clear


*Panel B
xi: rdrobust outcome_2 RV, vce(cluster munic_fact) all
estimates store mB51, title((1))

xi: rdrobust outcome_2 RV, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mB52, title((3))

xi: rdrobust outcome_2 RV, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mB53, title((4))

xi: rdrobust outcome_2 RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store mB54, title((5))

esttab mB51 mB52 mB53 mB54 using "`Outputs'\TableA4e.tex", title(1910 RD Non-State) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber r2
eststo clear


*Panel C
xi: rdrobust outcome_3 RV, vce(cluster munic_fact) all
estimates store mC51, title((1))

xi: rdrobust outcome_3 RV, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mC52, title((3))

xi: rdrobust outcome_3 RV, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mC53, title((4))

xi: rdrobust outcome_3 RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store mC54, title((5))

esttab mC51 mC52 mC53 mC54 using "`Outputs'\TableA4f.tex", title(1910: RD One-Sided) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber r2
eststo clear



* === No BiH Border === *
*Panel A: State Based
eststo: reg outcome_1 nobos_indic if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_1 nobos_indic TRI_mean if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_1 nobos_indic TRI_mean ethnic_polar if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_1 nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos < 250, vce(cluster municipality)

esttab using "`Outputs'\TableA5a.tex", title(Old Border: Border Specification) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label page(dcolumn) nonumber r2
eststo clear

*Panel B: Non-State
eststo: reg outcome_2 nobos_indic if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_2 nobos_indic TRI_mean if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_2 nobos_indic TRI_mean ethnic_polar if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_2 nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos < 250, vce(cluster municipality)

esttab using "`Outputs'\TableA5b.tex", title(Old Border: Border Specification) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label page(dcolumn) nonumber r2
eststo clear

*Panel C: One-Sided 
eststo: reg outcome_3 nobos_indic if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_3 nobos_indic TRI_mean if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_3 nobos_indic TRI_mean ethnic_polar if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome_3 nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos < 250, vce(cluster municipality)

esttab using "`Outputs'\TableA5c.tex", title(Old Border: Border Specification) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label page(dcolumn) nonumber r2
eststo clear

* +++++ Regression Discontinuity +++++ * 

*Panel A
xi: rdrobust outcome_1 RV_2, vce(cluster munic_fact) all
estimates store mA61, title((1))

xi: rdrobust outcome_1 RV_2, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mA62, title((3))

xi: rdrobust outcome_1 RV_2, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mA63, title((4))

xi: rdrobust outcome_1 RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store mA64, title((5))

esttab mA61 mA62 mA63 mA64 using "`Outputs'\TableA5d.tex", title(Old Border: RD state-based) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber r2
eststo clear


*Panel B
xi: rdrobust outcome_2 RV_2, vce(cluster munic_fact) all
estimates store mB61, title((1))

xi: rdrobust outcome_2 RV_2, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mB62, title((3))

xi: rdrobust outcome_2 RV_2, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mB63, title((4))

xi: rdrobust outcome_2 RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store mB64, title((5))

esttab mB61 mB62 mB63 mB64 using "`Outputs'\TableA5e.tex", title(Old Border: RD non-state) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber r2
eststo clear


*Panel C
xi: rdrobust outcome_3 RV_2, vce(cluster munic_fact) all
estimates store mC61, title((1))

xi: rdrobust outcome_3 RV_2, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mC62, title((3))

xi: rdrobust outcome_3 RV_2, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mC63, title((4))

xi: rdrobust outcome_3 RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store mC64, title((5))

esttab mC61 mC62 mC63 mC64 using "`Outputs'\TableA5f.tex", title(Old Border: RD 1-sided) mlabel((1) (2) (3) (4)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber r2
eststo clear
