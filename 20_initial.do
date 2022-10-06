*\ 20 Main Results: Tables 1 and 2

*Version: 1 

*Last Modified: 07/11
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Creating main outcome variables, labelling variables 
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	Run Cleaning 01,02, and merges
		
+ Inputs: 

		* Censuscasualties .dta 
		* UCDP events data

		
+ Outputs
	
		* Tables 1 and 2
  
  Changed:
	*Version 1: First version, no changes to log.
	*07/11: Outlined the models
	*07/19: Tables 
	*07/20: Fix border spec to be only within 250 km
	*07/21: remove p(2) and let the default do what it wants
	


 ==============================  TOP MATTER ==============================*/
 
 use "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Municipality level.dta", clear

*** Dropping Belgrade duplicates
drop if municipality =="Barajevo" | municipality =="Cukarina" | municipality =="Grocka" | municipality =="Lazurevac" | municipality =="Mladenovac" |municipality == "Novi Beograd" | municipality =="Obrenovac" | municipality =="Palilula" | municipality =="Rakovica" | municipality =="Sovski Venac" | municipality =="Sopot" | municipality =="Stari Grad" |municipality =="Vracar" | municipality =="Vozdovac" | municipality =="Zemun" | municipality =="Zvezdara"
 
 
* === 1910 Border === * 
* ========== Border Specification ========== *
eststo: reg outcome ah_indic if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic i.country if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar if centriod_dist_1910 < 250, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 < 250, vce(cluster municipality)

esttab using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Table1a.tex", title(1910 Border: Border Specification) mlabel((1) (2) (3) (4) (5)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) indicate("Country FE =*.country") drop(_cons) se label page(dcolumn) nonumber r2
eststo clear

* ========== RD Specification ========== *
encode municipality, generate(munic_fact)

quietly rdbwselect outcome RV
*gen bw1 = e(h_mserd) 
*optimal bandwidth is 243.2716


xi: rdrobust outcome RV, vce(cluster munic_fact) all
estimates store m10, title((1))

xi: rdrobust outcome RV i.country, vce(cluster munic_fact) all
estimates store m11, title((2))


xi: rdrobust outcome RV, covs(TRI_mean) vce(cluster munic_fact) all
estimates store m12, title((3))

xi: rdrobust outcome RV, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store m13, title((4))

xi: rdrobust outcome RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all 
estimates store m14, title((5))

esttab m10 m11 m12 m13 m14 using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Table1b.tex", title(1910 Border: Regression Discontinuity) mlabel((1) (2) (3) (4) (5)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber r2
eststo clear

* === No BiH Border === *
* ========== Border Specification ========== *

eststo: reg outcome nobos_indic if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic i.country if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar if centriod_dist_nobos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos < 250, vce(cluster municipality)

esttab using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Table2a.tex", title(Old Border: Border Specification) mlabel((1) (2) (3) (4) (5)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) indicate("Country FE =*.country") drop(_cons) se label page(dcolumn) nonumber r2
eststo clear

* ========== RD Specification ========== *
quietly rdbwselect outcome RV_2
gen bw2 = e(h_mserd) 
*Optimal bandwidth is 91.8426

xi: rdrobust outcome RV_2, vce(cluster munic_fact) all
estimates store m20, title((1))

xi: rdrobust outcome RV_2 i.country, vce(cluster munic_fact) all
estimates store m21, title((2))

xi: rdrobust outcome RV_2, covs(TRI_mean) vce(cluster munic_fact) all
estimates store m22, title((3))

xi: rdrobust outcome RV_2, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store m23, title((4))

xi: rdrobust outcome RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all
estimates store m24, title((5))

esttab m20 m21 m22 m23 m24 using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Table2b.tex", title(Old Border: Regression Discontinuity) mlabel((1) (2) (3) (4) (5)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber r2
eststo clear