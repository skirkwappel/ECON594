*\ 20 Results Appendix 

*Version: 1 

*Last Modified: 07/26
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Appendix material 
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	All previous files
		
+ Inputs: 

		* Municipality level.dta

		
+ Outputs
	
		* McCrary Density Tests 
		* Appendix Table 6
  
  Changed:
	*Version 1: First version, no changes to log.
	*07/20 Created Pseudo-Borders and  created table
	*07/26: RD PB + Relevant table added 
	


 ==============================  TOP MATTER ==============================*/
 
 
 ****** McCrary Density *******
 *rddensity RV, c(0) plot
 
 *rddensity RV_2, c(0) plot
 
 
 ****** Summary Statistics ********
 

 
*\ 20 Results Appendix 

*Version: 1 

*Last Modified: 07/20
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Appendix material 
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	All previous files
		
+ Inputs: 

		* Municipality level.dta

		
+ Outputs
	
		* McCrary Density Tests 
		* Appendix Table 6
  
  Changed:
	*Version 1: First version, no changes to log.
	*07/20 Created Pseudo-Borders and  created table
	


 ==============================  TOP MATTER ==============================*/
 
 
 ****** McCrary Density *******
 *rddensity RV, c(0) plot
 
 *rddensity RV_2, c(0) plot
 
 
 ****** Summary Statistics ********
 

 
 ****** Pseudo- Borders *******
*\ 20 Results Appendix 

*Version: 1 

*Last Modified: 07/20
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Appendix material 
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	All previous files
		
+ Inputs: 

		* Municipality level.dta

		
+ Outputs
	
		* McCrary Density Tests 
		* Appendix Table 6
  
  Changed:
	*Version 1: First version, no changes to log.
	*07/20 Created Pseudo-Borders and  created table
	


 ==============================  TOP MATTER ==============================*/
 
 
 ****** McCrary Density *******
 *rddensity RV, c(0) plot
 
 *rddensity RV_2, c(0) plot
 
 
 ****** Summary Statistics ********
 

 
 ****** Pseudo- Borders *******
 use "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Municipality level.dta", clear

*** Dropping Belgrade duplicates
drop if municipality =="Barajevo" | municipality =="Cukarina" | municipality =="Grocka" | municipality =="Lazurevac" | municipality =="Mladenovac" |municipality == "Novi Beograd" | municipality =="Obrenovac" | municipality =="Palilula" | municipality =="Rakovica" | municipality =="Sovski Venac" | municipality =="Sopot" | municipality =="Stari Grad" |municipality =="Vracar" | municipality =="Vozdovac" | municipality =="Zemun" | municipality =="Zvezdara"
 
gen dist_PB_1910_pos = RV + 100
gen ah_indic_PB_pos = 0
replace ah_indic_PB_pos = 0 if dist_PB_1910_pos < 0
replace ah_indic_PB_pos = 1 if dist_PB_1910_pos > 0
label variable ah_indic_PB_pos "Pseudo-Austria-Hungary"

gen dist_PB_1910_neg =  RV - 100
gen ah_indic_PB_neg = 0
replace ah_indic_PB_neg = 0 if dist_PB_1910_neg < 0
replace ah_indic_PB_neg = 1 if dist_PB_1910_neg > 0
label variable ah_indic_PB_neg "Pseudo-Austria-Hungary"

gen dist_PB_nobos_pos = RV_2 + 100
gen nobos_indic_PB_pos = 0
replace nobos_indic_PB_pos = 0 if dist_PB_nobos_pos < 0
replace nobos_indic_PB_pos = 1 if dist_PB_nobos_pos > 0
label variable nobos_indic_PB_pos "Pseudo-Austria-Hungary"

gen dist_PB_nobos_neg = RV_2 - 100
gen nobos_indic_PB_neg = 0
replace nobos_indic_PB_neg = 0 if dist_PB_nobos_neg < 0
replace nobos_indic_PB_neg = 1 if dist_PB_nobos_neg > 0
label variable nobos_indic_PB_neg "Pseudo-Austria-Hungary"


* === 1910 Border === * 

eststo: reg outcome ah_indic_PB_neg if dist_PB_1910_neg < 250, vce(cluster municipality)

eststo: reg outcome ah_indic_PB_neg TRI_mean if dist_PB_1910_neg < 250, vce(cluster municipality)

eststo: reg outcome ah_indic_PB_neg TRI_mean ethnic_polar if dist_PB_1910_neg < 250, vce(cluster municipality)

eststo: reg outcome ah_indic_PB_neg TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if dist_PB_1910_neg < 250, vce(cluster municipality)
 
 
 * === No BiH Border === *
eststo: reg outcome nobos_indic_PB_neg if dist_PB_nobos_neg < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic_PB_neg TRI_mean if dist_PB_nobos_neg < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic_PB_neg TRI_mean ethnic_polar if dist_PB_nobos_neg < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic_PB_neg TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if dist_PB_nobos_neg < 250, vce(cluster municipality)

esttab using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA7a.tex", title(Pseudo-Borders) mlabel((1) (2) (3) (4) (5) (6) (7) (8)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) se label page(dcolumn) nonumber r2
eststo clear


 
 * === 1910 Border === * 
 eststo: reg outcome ah_indic_PB_pos if dist_PB_1910_pos < 250, vce(cluster municipality)

eststo: reg outcome ah_indic_PB_pos TRI_mean if dist_PB_1910_pos < 250, vce(cluster municipality)

eststo: reg outcome ah_indic_PB_pos TRI_mean ethnic_polar if dist_PB_1910_pos < 250, vce(cluster municipality)

eststo: reg outcome ah_indic_PB_pos TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if dist_PB_1910_pos < 250, vce(cluster municipality)
 
 
 * === No BiH Border === *
eststo: reg outcome nobos_indic_PB_pos if dist_PB_nobos_pos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic_PB_pos TRI_mean if dist_PB_nobos_pos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic_PB_pos TRI_mean ethnic_polar if dist_PB_nobos_pos < 250, vce(cluster municipality)

eststo: reg outcome nobos_indic_PB_pos TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties if dist_PB_nobos_pos < 250, vce(cluster municipality)

 esttab using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA7b.tex", title(Falsification Panel B) mlabel((1) (2) (3) (4) (5) (6) (7) (8)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) drop(_cons gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) se label page(dcolumn) nonumber r2
eststo clear

* ===== Pseudo-Borders: Regression Discontinuity ===== *

**** Generating Running Variable for RDD
gen RV_PB_pos = dist_PB_1910_pos

gen RV_PB_neg = dist_PB_1910_neg

gen RV_2_PB_pos = dist_PB_nobos_pos

gen RV_2_PB_neg = dist_PB_nobos_neg

* === 1910 Border === * 
encode municipality, generate(munic_fact)

xi: rdrobust outcome RV_PB_pos, vce(cluster munic_fact) all
estimates store mA71, title((1))

xi: rdrobust outcome RV_PB_pos, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mA72, title((2))

xi: rdrobust outcome RV_PB_pos, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mA73, title((3))

xi: rdrobust outcome RV_PB_pos, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all 
estimates store mA74, title((4))


xi: rdrobust outcome RV_PB_neg, vce(cluster munic_fact) all
estimates store mA75, title((5))

xi: rdrobust outcome RV_PB_neg, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mA76, title((6))

xi: rdrobust outcome RV_PB_neg, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mA77, title((7))

xi: rdrobust outcome RV_PB_neg, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all 
estimates store mA78, title((8))


esttab mA71 mA72 mA73 mA74 mA75 mA76 mA77 mA78 using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA8a.tex", title(Pseudo-Border 1910: Regression Discontinuity) mlabel((1) (2) (3) (4) (5) (6) (7) (8)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber
eststo clear


* ==== No BiH Border ==== * 

xi: rdrobust outcome RV_2_PB_pos, vce(cluster munic_fact) all
estimates store mA81, title((1))

xi: rdrobust outcome RV_2_PB_pos, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mA82, title((2))

xi: rdrobust outcome RV_2_PB_pos, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mA83, title((3))

xi: rdrobust outcome RV_2_PB_pos, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all 
estimates store mA84, title((4))


xi: rdrobust outcome RV_2_PB_neg, vce(cluster munic_fact) all
estimates store mA85, title((5))

xi: rdrobust outcome RV_2_PB_neg, covs(TRI_mean) vce(cluster munic_fact) all
estimates store mA86, title((6))

xi: rdrobust outcome RV_2_PB_neg, kernel(tri) covs(TRI_mean ethnic_polar) vce(cluster munic_fact) all
estimates store mA87, title((7))

xi: rdrobust outcome RV_PB_neg, kernel(tri) covs(TRI_mean ethnic_polar gdp_pc soc_lab jna schooling pop_density capacity ww2_casualties) vce(cluster munic_fact) all 
estimates store mA88, title((8))



esttab mA81 mA82 mA83 mA84 mA85 mA86 mA87 mA88 using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\TableA8b.tex", title(Pseudo-Border 1867: Regression Discontinuity) mlabel((1) (2) (3) (4) (5) (6) (7) (8)) addnote("Standard errors are clustered by municipality") star(* 0.10 ** 0.05 *** 0.01) se label page(dcolumn) nonumber
eststo clear


