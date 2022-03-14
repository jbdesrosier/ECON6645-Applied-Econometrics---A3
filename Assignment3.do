/* python:
import numpy as np
import pandas as pd
from pandas import DataFrame as df
import statsmodels.api as sm
#from statsmodels import OaxacaBlinder2
#print(OaxacaBlinder2)

SLID1 = pd.read_stata("D:/Documents/MA Economics/Courses - Winter 2022/ECON6645 - Applied Econometrics/Assignment 3/SLID1.dta")
#df.mean(SLID[['educ_yrs','wage']])

SLID = pd.DataFrame(SLID1, columns = ['educ_yrs', 'wage', 'female'])

SLID = SLID.astype({"educ_yrs": 'str', "wage": 'str', "female": 'str'})
SLID
print(SLID.dtypes)

#model = Oaxaca(SLID, female, wage, debug)

model = sm.OaxacaBlinder(SLID.wage, SLID.educ_yrs, 3, hasconst = False)

end */

/*python:
import os
cwd = os.getcwd()
print(cwd)
end*/

// ECON 6645 - Assignment 3

cd "D:\Documents\MA Economics\Courses - Winter 2022\ECON6645 - Applied Econometrics\Assignment 3"

//1
clear
use ".\SLID1.dta"

decode firm_size, gen(a)

gen str20 s1 = ustrregexs(1) if ustrregexm(a,"([\d,]+)")
gen str20 s2 = ustrregexs(2) if ustrregexm(a,"([\d,]+)[^\d,]+([\d,]+)")
	destring s1 s2, ignore(",") generate(L U)
	drop a s1 s2
		replace U = 20 if firm_size==1
		replace L = 1 if firm_size==1

gen firm_size_mid = runiform(L, U)

tab firm_size

gen a = log(2613/1773)/log(1000/500)
gen b = a/(a-1)*-999

	replace firm_size_mid=b if firm_size_mid==. & L!=.
	drop L U a b
	
	


est clear
	estpost tabstat wage educ_yrs experience firm_size_mid union manager 					married, 												///
					c(stat) stat(n mean median min max) by(female) 
	esttab using tab1.tex, replace	///										
	cells("count(fmt(%13.0fc)) mean(fmt(%13.2fc)) p50 min max") 			///
	nonumber nomtitle nonote noobs label booktabs 							///
	collabels("n" "Mean" "Median" "Min" "Max")


est clear
eststo: reg wage educ_yrs experience firm_size_mid union manager married 		ib3.region [pweight=weight] if female==0
eststo: reg wage educ_yrs experience firm_size_mid union manager married 		ib3.region [pweight=weight] if female==1
esttab using tab2.tex, se replace


ssc install oaxaca, replace

tab region, gen(region_)

oaxaca wage educ_yrs experience firm_size_mid union manager married 		   region_1 region_2 region_3 region_4 region_5 				[pweight=weight], by (female) weight(0) noisily relax

	est clear
	eststo: oaxaca, eform
	esttab using tab3.tex, se replace


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
