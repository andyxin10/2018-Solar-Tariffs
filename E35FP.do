// California

import excel "/Users/andyxin/Desktop/ECON035/Final_Project/E35Cali.xlsx", firstrow clear
save "/Users/andyxin/Desktop/ECON035/Final_Project/E35Cali.dta", replace

use "/Users/andyxin/Desktop/ECON035/Final_Project/E35Cali.dta"

keep if state == "California"

// regression without controls
areg net_generation tariff_level, absorb(month) vce(robust)
estimates store netCali

areg solar_percentage_total tariff_level, absorb(month) vce(robust)
estimates store pctCali

// regression with controls
areg net_generation tariff_level ln_population ln_real_gdp ln_income energy_price, absorb(month) vce(robust)
estimates store CnetCali

areg solar_percentage_total tariff_level ln_population ln_real_gdp ln_income energy_price, absorb(month) vce(robust)
estimates store CpctCali

esttab netCali pctCali CnetCali CpctCali using "/Users/andyxin/Desktop/ECON035/Final_Project/Cali.tex", replace ///
	title("California Tariffs Regression") ///
    se star(* 0.10 ** 0.05 *** 0.01)

// Country
import excel "/Users/andyxin/Desktop/ECON035/Final_Project/50MSY.xlsx", firstrow clear
save "/Users/andyxin/Desktop/ECON035/Final_Project/usa.dta", replace

use "/Users/andyxin/Desktop/ECON035/Final_Project/usa.dta"

// Summary Statistics

estpost summarize net_generation solar_percentage_total population real_gdp income electricity_price
esttab using "/Users/andyxin/Desktop/ECON035/Final_Project/summary.tex", replace ///
cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") ///
title("Summary Statistics")

// Month FE

// No Controls

reghdfe net_generation tariff_level, absorb(state month) vce(cluster state)
estimates store net50

reghdfe solar_percentage_total tariff_level, absorb(state month) vce(cluster state)
estimates store pct50

// Controls

reghdfe net_generation tariff_level ln_population ln_real_gdp ln_income electricity_price, absorb(state month) vce(cluster state)
estimates store Cnet50

reghdfe solar_percentage_total tariff_level ln_population ln_real_gdp ln_income electricity_price, absorb(state month) vce(cluster state)
estimates store Cpct50

esttab net50 pct50 Cnet50 Cpct50 using "/Users/andyxin/Desktop/ECON035/Final_Project/usa.tex", replace ///
	title("USA Tariffs Regression") ///
    se star(* 0.10 ** 0.05 *** 0.01)

// Month FE + IE
reghdfe net_generation tariff_level ln_population ln_real_gdp ln_income electricity_price tlevel_population, absorb(state month) vce(cluster state)
estimates store netmonthIEpop

reghdfe net_generation tariff_level ln_population ln_real_gdp ln_income electricity_price tlevel_gdp, absorb(state month) vce(cluster state)
estimates store netmonthIEgdp

reghdfe net_generation tariff_level ln_population ln_real_gdp ln_income electricity_price tlevel_income, absorb(state month) vce(cluster state)
estimates store netmonthIEincome

reghdfe net_generation tariff_level ln_population ln_real_gdp ln_income electricity_price tlevel_price, absorb(state month) vce(cluster state)
estimates store netmonthIEprice

reghdfe solar_percentage_total tariff_level ln_population ln_real_gdp ln_income electricity_price tlevel_population, absorb(state month) vce(cluster state)
estimates store pctmonthIEpop

reghdfe solar_percentage_total tariff_level ln_population ln_real_gdp ln_income electricity_price tlevel_gdp, absorb(state month) vce(cluster state)
estimates store pctmonthIEgdp

reghdfe solar_percentage_total tariff_level ln_population ln_real_gdp ln_income electricity_price tlevel_income, absorb(state month) vce(cluster state)
estimates store pctmonthIEincome

reghdfe solar_percentage_total tariff_level ln_population ln_real_gdp ln_income electricity_price tlevel_price, absorb(state month) vce(cluster state)
estimates store pctmonthIEprice

esttab netmonthIEpop netmonthIEgdp netmonthIEincome netmonthIEprice pctmonthIEpop pctmonthIEgdp pctmonthIEincome pctmonthIEprice using "/Users/andyxin/Desktop/ECON035/Final_Project/statemonthIE.tex", replace ///
title("USA Tariffs Regression") ///
se star(* 0.10 ** 0.05 *** 0.01)

// Binary
gen tariff_binary = tariff_level > 0



