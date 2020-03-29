
clear
***** Import, Row-standardize and Export: From a .gal file (created in GeoDa) to a .txt file (general matrix)
*clear
*spwmatrix import using WqueenC.gal, wname(wcontig) rowstand xport(wcontig, txt) replace

***** TRANSLATE the general shapefile into a stata-format shapefile
spshape2dta NapalAid, replace

***** Describe the translated .dta file, which now attached to the stata shapefile _shp.dta
use NapalAid, clear
describe
list in 1/3

*NOTE: 3 variables are added: _ID (Spatial Unit ID), _CX (x-coordinate of area centroid), _CY(y-coordinate of area centroid)
*NOTE: Luckely in this case the new variable _ID is the same as the include variable id
*NOTE: Because of the (linked) translation, whenever you use this NapalAid.dta you can have access to the information in NapalAid_shp.dta

****** SET spatial ID
spset _ID, modify replace

*NOTE: The coordinate system is planar


***** SET coordinate system to latlong in miles
spset, modify coordsys(latlong, miles)
save, replace


***** DROP unnecesary variables
drop id_1 name_1 id_2 name_2 id_3 district depecprov povindex pcinc pcincppp pcincmp malkids lif40 nosafh20 population boyg1_5 girlg1_5 kids1_5 schoolcnt schlpkid schlppop ad_illit ad_ilgt50 lon lat
save, replace

* Merge additional data with the Stata-format shapefile
use NapalAidVariables, clear
describe

merge 1:1 id using NapalAid
keep if _merge==3
drop _merge

* Check the spset
spset

* If Ok, save the merged file
save, replace

* Create a map of the spatial distribution of povindex
grmap, activate
grmap povindex

* Create a row-standardized (qeen) contiguity weights matrix
spmatrix create contiguity WcontQ, normalize(row)

*NOTE: This matrix will be stored in Stata memory as an stata object

* Export contiguity weights matrix as .txt file
spmatrix export WcontQ using WcontQ.txt

* Run the Moran test based on the residuals of an OLS regression
regress povindex pcinc
estat moran, errorlag(WcontQ)


* Fit a model with a spatial lag of the dependent variable
spregress povindex pcinc, ml dvarlag(WcontQ)
spregress povindex pcinc, ml dvarlag(WcontQ) vce(robust)
spregress povindex pcinc, gs2sls dvarlag(WcontQ)

*NOTE: vce(robust) does not work with vce(robust)

* Interpret the model measuring the spillover (indirect) effect
estat impact

* Fit a model with a spatial lag of the independent variables
spregress povindex pcinc, ml ivarlag(WcontQ:pcinc)
spregress povindex pcinc, ml ivarlag(WcontQ:pcinc) vce(robust)
spregress povindex pcinc, gs2sls ivarlag(WcontQ:pcinc)

* Interpret the model measuring the spillover (indirect) effect
estat impact

* Fit a model with a  spatially autoregressive error
spregress povindex pcinc, ml errorlag(WcontQ)
spregress povindex pcinc, ml errorlag(WcontQ) vce(robust)
spregress povindex pcinc, gs2sls errorlag(WcontQ)

* Interpret the mode: Be careful, there are NO spillovers
estat impact

*NOTE: there are NO spillovers
