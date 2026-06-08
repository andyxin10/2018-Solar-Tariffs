// California

use "/Users/andyxin/Desktop/ECON035/Final_Project/E35Cali.dta"

// regression without controls
regress net_generation tariff_level, robust
estimates store netCali

regress solar_percentage_total tariff_level, robust
estimates store pctCali

esttab netCali pctCali using "nocontrolCali.tex", replace r2

// regression with controls
regress net_generation tariff_level ln_population ln_gdp energy_price installation_cost, robust
estimates store CnetCali

regress solar_percentage_total tariff_level ln_population ln_gdp energy_price installation_cost, robust
estimates store CpctCali

esttab CnetCali CpctCali using "controlCali.tex", replace r2

// Country
use "/Users/andyxin/Desktop/ECON035/Final_Project/all50states.dta"

// regression without controls
areg net_generation tariff_level ln_population ln_real_gdp ln_income solar_price, absorb(state) robust
estimates store NCnetIE

areg solar_percentage_total tariff_level ln_population ln_real_gdp ln_income solar_price, absorb(state) robust
estimates store NCpctIE

esttab NCnetIE NCpctIE using "ncIE.tex", replace r2

// regression with controls

gen tlevel_population = tariff_level * ln_population
gen tlevel_gdp = tariff_level * ln_real_gdp
gen tlevel_income = tariff_level * ln_income
gen tlevel_price = tariff_level * solar_price
gen tlevel_solarpct = tariff_level * solar_percentage_total

reghdfe net_generation ln_population ln_real_gdp ln_income tlevel_population, absorb(state year) vce(cluster state) // interact tariff_level and ln_population
estimates store netIEpop

reghdfe net_generation ln_population ln_real_gdp ln_income tlevel_gdp, absorb(state year) vce(cluster state)
// interact tariff_level and ln_real_gdp
estimates store netIEgdp

reghdfe net_generation ln_population ln_real_gdp ln_income tlevel_income, absorb(state year) vce(cluster state)
// interact tariff_level and ln_income
estimates store netIEincome

reghdfe solar_percentage_total ln_population ln_real_gdp ln_income tlevel_population, absorb(state year) vce(cluster state) // interact tariff_level and ln_population
estimates store pctIEpop

reghdfe solar_percentage_total ln_population ln_real_gdp ln_income tlevel_gdp, absorb(state year) vce(cluster state)
// interact tariff_level and ln_real_gdp
estimates store pctIEgdp

reghdfe solar_percentage_total ln_population ln_real_gdp ln_income tlevel_income, absorb(state year) vce(cluster state)
// interact tariff_level and ln_income
estimates store pctIEincome

esttab netIEpop netIEgdp netIEincome pctIEpop pctIEgdp pctIEincome using "/Users/andyxin/Desktop/ECON035/Final_Project/E35IE.tex", replace r2

reghdfe net_generation ln_population ln_real_gdp ln_income tlevel_population tlevel_gdp tlevel_income, absorb(state year) vce(cluster state)
estimates store netIE

reghdfe solar_percentage_total ln_population ln_real_gdp ln_income tlevel_population tlevel_gdp tlevel_income, absorb(state year) vce(cluster state)
estimates store pctIE

esttab netIE pctIE using "/Users/andyxin/Desktop/ECON035/Final_Project/IE.tex", replace r2
