*\ 20 Results Robustness: Distances

*Version: 1 

*Last Modified: 07/21
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Robustness checks 
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	All cleaning and merging
		
+ Inputs: 

		* Municipality level.dta

		
+ Outputs
	
		* Table 
  
  Changed:
	*Version 1: First version, no changes to log.
	*07/21: RD bandwidths added 

	


 ==============================  TOP MATTER ==============================*/

 use "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Municipality level.dta", clear

*** Dropping Belgrade duplicates
drop if municipality =="Barajevo" | municipality =="Cukarina" | municipality =="Grocka" | municipality =="Lazurevac" | municipality =="Mladenovac" |municipality == "Novi Beograd" | municipality =="Obrenovac" | municipality =="Palilula" | municipality =="Rakovica" | municipality =="Sovski Venac" | municipality =="Sopot" | municipality =="Stari Grad" |municipality =="Vracar" | municipality =="Vozdovac" | municipality =="Zemun" | municipality =="Zvezdara"
 
 
 **** Changing distances
 /* Given that most of these municipalities located within these finite distances
	are in Serbia, Bosnia, and Croatia, those which I have the full set of 
	controls for, I'm going to use the full model. 
	Also using centriod_dist as it is the absolute value of the RV's*/
	
 * ==== 1910 Border ===== *

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 <= 200, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 <= 150, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 <= 100, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 <= 50, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_1910 <= 25, vce(cluster municipality)

esttab using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA2a.tex", title(1910 Border Different Distances) mlabel(200km 150km 100km 50km 25km) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) se label page(dcolumn) nonumber r2
eststo clear


* ==== No BiH Border ==== * 

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D if centriod_dist_nobos <= 200, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos <= 150, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos <= 100, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos <= 50, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if centriod_dist_nobos <= 25, vce(cluster municipality)

esttab using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA2b.tex", title(Old Border Different Distances) mlabel(200km 150km 100km 50km 25km) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) se label page(dcolumn) nonumber r2
eststo clear



* ============== RD ============= *
encode municipality, generate(munic_fact)

xi: rdrobust outcome RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(200) vce(cluster munic_fact) all 
estimates store m31, title(200km)

xi: rdrobust outcome RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(150) vce(cluster munic_fact) all 
estimates store m32, title(150km)

xi: rdrobust outcome RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(100) vce(cluster munic_fact) all 
estimates store m33, title(100km)

xi: rdrobust outcome RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(100) vce(cluster munic_fact) all 
estimates store m34, title(50km)

xi: rdrobust outcome RV, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(25) vce(cluster munic_fact) all 
estimates store m35, title(25km)

esttab m31 m32 m33 m34 m35 using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA2f.tex", title(1910 Border: Regression Discontinuity) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber
eststo clear



xi: rdrobust outcome RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(200) vce(cluster munic_fact) all 
estimates store m41, title(200km)

xi: rdrobust outcome RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(150) vce(cluster munic_fact) all 
estimates store m42, title(150km)

xi: rdrobust outcome RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(100) vce(cluster munic_fact) all 
estimates store m43, title(100km)

xi: rdrobust outcome RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(100) vce(cluster munic_fact) all 
estimates store m44, title(50km)

xi: rdrobust outcome RV_2, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) h(25) vce(cluster munic_fact) all 
estimates store m45, title(25km)

esttab m41 m42 m43 m44 m45 using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA2g.tex", title(1910 Border: Regression Discontinuity) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber
eststo clear


* ========= Mechanism ========== *
gen D_200 = 0
replace D_200 = 1 if habsburg>=200
label variable D_200   ">200 years under Habsburgs"
 * ==== 1910 Border ===== *

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_1910 <= 200, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_1910 <= 150, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_1910 <= 100, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_1910 <= 50, vce(cluster municipality)

eststo: reg outcome ah_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_1910 <= 25, vce(cluster municipality)

esttab using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA2c.tex", title(1910 Border Different Distances) mlabel(200km 150km 100km 50km 25km) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) se label page(dcolumn) nonumber r2
eststo clear

* ==== No BiH Border ==== * 

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_nobos <= 200, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_nobos <= 150, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_nobos <= 100, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_nobos <= 50, vce(cluster municipality)

eststo: reg outcome nobos_indic TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties D_200 if centriod_dist_nobos <= 25, vce(cluster municipality)

esttab using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA2d.tex", title(Old Border Different Distances) mlabel(200km 150km 100km 50km 25km) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) se label page(dcolumn) nonumber r2
eststo clear