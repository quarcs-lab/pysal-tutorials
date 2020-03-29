clear

***** Import a first order contiguity spatial weights matrix created in GeoDa

spwmatrix import using WqueenC.gal, wname(WcontQspwmatrix) rowstand replace

*NOTE:  matrix loaded in Stata memory (Stata object)


***** Import, Row-standardize and Export: From a .gal file (created in GeoDa) to a .txt file (general matrix)

spwmatrix import using WqueenC.gal, wname(WcontQspwmatrix) rowstand xport(WcontQspwmatrix, txt) replace


***** Import, Row-standardize and Export: From a .gal file (created in GeoDa) to a .dat file to be used in Matlab and R

spwmatrix import using WqueenC.gal, wname(WcontQspwmatrix) rowstand xport(WcontQspwmatrix, dat) replace


* Install SPLAGVAR': module to generate spatially lagged variables, construct the Moran Scatter plot, and calculate Moran's I statistics

* Create a spatial lag, construct the Moran scatter plot, and Moran's I statistics
spwmatrix import using WqueenC.gal, wname(WcontQspwmatrix) rowstand replace
splagvar povindex, wname(WcontQspwmatrix) wfrom(Stata) plot(povindex) moran(povindex) replace
