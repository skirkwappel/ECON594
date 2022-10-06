********************************************************************************
*																			   *
*								Title: 2_MainEstimation.do		 	 		   *
*																			   *
********************************************************************************


*Creation: Made by Sarah Wappel on 07/20/2022

*Version: 1 

*Last Modified: 07/19
//		by: Sarah Wappel	
//		Make sure to log the changes you made to the do-file on the "changes"
//		section in the notes bellow

/*  ================================  NOTES  ================================

+ PURPSOSE:
	
	Main estimations plus table output
		
+ DEPENDENCIES:
	Do you need to run something else to run this?
	Previous .do files
		
+ Inputs: 

		* YUG91 shapefile as csv

		
+ Outputs
	
		* Create YUG91.dta which will later be merged with census and WWII 
		casualty data
  
  Changed:
	*Version 1: First version, no changes to log.
	*07/19: Corrected duration variable to distinguish length of Habsburg association
	*07/20: Re-label some variables 

 ==============================  TOP MATTER ==============================*/

import delimited "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\gedevents-2022-05-14.csv", bindquote(strict) clear

replace municipality = "Belgrade" if municipality =="Barajevo" | municipality =="Cukarina" | municipality =="Grocka" | municipality =="Lazurevac" | municipality =="Mladenovac" |municipality == "Novi Beograd" | municipality =="Obrenovac" | municipality =="Palilula" | municipality =="Rakovica" | municipality =="Sovski Venac" | municipality =="Sopot" | municipality =="Stari Grad" |municipality =="Vracar" | municipality =="Vozdovac" | municipality =="Zemun" | municipality =="Zvezdara"
 
gen c = 1
egen sum_conflict_type_1 = total(c) if type_of_violence==1, by(municipality)
egen sum_conflict_type_2 = total(c) if type_of_violence==2, by(municipality)
egen sum_conflict_type_3 = total(c) if type_of_violence==3, by(municipality)
egen sum_conflict= total(c), by(municipality)

collapse (max) ah_indic nobos_indic sum_conflict_type_1 sum_conflict_type_2 sum_conflict_type_3 sum_conflict, by(municipality)

merge 1:1 municipality using "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Censuscasualties.dta"

*ARC import glitch
drop if _merge == 1


****** For all municipalities with no conflicts
replace sum_conflict_type_1 = 0 if sum_conflict_type_1==.
replace sum_conflict_type_2 = 0 if sum_conflict_type_2==.
replace sum_conflict_type_3 = 0 if sum_conflict_type_3==.
replace sum_conflict = 0 if sum_conflict==.
replace sum_conflict_type_1=0 if missing(sum_conflict_type_1)
replace sum_conflict_type_2=0 if missing(sum_conflict_type_2)
replace sum_conflict_type_3=0 if missing(sum_conflict_type_3)
replace sum_conflict=0 if missing(sum_conflict)


replace ah_indic =0 if missing(ah_indic)
replace ah_indic=1 if slovenia == 1
replace ah_indic=1 if croatia == 1
replace ah_indic=1 if bosnia == 1
replace ah_indic=1 if nobos_indic==1

replace nobos_indic=0 if missing(nobos_indic)
replace nobos_indic=1 if slovenia==1
replace nobos_indic=1 if croatia == 1
replace nobos_indic=0 if bosnia == 1
replace nobos_indic=1 if municipality == "Bosanski Novi"

gen outcome = (sum_conflict/population)*10000

 
/*
Quick note here about the outcome: Having referenced UCDP, most of the collected
	conflict events in the database for Macedonia are from a conflict separate 
	from the Yugoslav Wars, and since I am not looking at conflicts apart from the
	Yugoslav wars
 */

replace outcome = 0 if macedonia == 1
 

* Duration: mechanism
gen D_100 = 0
replace D_100 = 1 if habsburg>100
gen D_200 = 0
replace D_200 = 1 if habsburg>=200


*** Fixed effects 
generate country = 0
replace country = 1 if croatia == 1
replace country = 2 if bosnia == 1
replace country = 3 if slovenia == 1
replace country = 4 if montenegro == 1
replace country = 5 if serbia == 1
replace country = 6 if kosovo == 1 
replace country = 7 if macedonia == 1

*** Alternatively: Republics *\ This is probably a better measure *\ 

generate republic = 0 
replace republic = 1 if croatia == 1
replace republic = 2 if bosnia == 1
replace republic = 3 if slovenia == 1
replace republic = 4 if montenegro == 1
replace republic  = 5 if serbia == 1
replace republic = 5 if kosovo == 1 
replace republic = 6 if macedonia == 1

rename Total ww2_casualties

label variable ah_indic "Austria-Hungary"
label variable nobos_indic "Austria-Hungary, no BiH"
label variable ethnic_fract "Ethnic Fractionalization"
label variable religious_fract "Religious Fractionalization"
label variable ethnic_polar "Ethnic Polarization"
label variable gdp_pc  "GDP Per Capita"
label variable soc_lab   "Fraction of Labour Force in Social Sector"
label variable jna   "Yugoslav National Army Presence"
label variable pop_density "Population Density"
label variable ww2_casualties "WWII Intensity"
label variable terror  "Fascist Terror"
label variable expend_total "Government Expediture" 
label variable D_100   ">100 years under Habsburgs"
label variable D_200 "$>$ 200 years under Habsburgs"

**** Generating Running Variable for RDD
gen RV = centriod_dist_1910
replace RV = RV*-1 if ah_indic==0

gen RV_2 = centriod_dist_nobos
replace RV_2 = RV_2*-1 if nobos_indic==0

*Generating new outcome variables 

gen outcome_1 = (sum_conflict_type_1/population)*10000
replace outcome_1 = 0 if macedonia == 1
label variable outcome_1 "State Based Conflicts"

gen outcome_2 = (sum_conflict_type_2/population)*10000
replace outcome_2 = 0 if macedonia == 1
label variable outcome_2 "Non-State Conflicts"

gen outcome_3 = (sum_conflict_type_3/population)*10000
replace outcome_3 = 0 if macedonia == 1
label variable outcome_3 "One-Sided Violence"


save "C:\Users\skirk\Documents\2021-2022 Masters\594\Paper\Municipality level.dta", replace