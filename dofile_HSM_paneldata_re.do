use "https://github.com/apaparini/HumSecMeasures/blob/main/PRIF-dataset-HMI-intervention-years-v-July-2019_raw.dta", clear

**Preparing and adjusting the database to our analysis** 
recode ENDTYPE (1=3) (3=1)
recode NEWVIOL (-88 = 2)
recode DISLOCATE (-99 = . )
recode CONTRA0 (-99 = 0.5)
generate byte GPOWINTERVEN = (COLDWAR == 1 & (INTERVEN1 == "USSR" | INTERVEN1 == "USA"))
egen HMIIC = group(HMIID)
egen HMII_peryear = count(HMIIC), by(YEAR)

**Install package and declare the dataset as panel data**
ssc install xtscc

xtset HMIIC YEAR

**Running the structural neorrealist assumption regression**
xtreg HMII_peryear COLDWAR, re
eststo neor

**Running the path-dependent constructivist assumption regression**
xtreg HMII_peryear L.ENDTYPE L.NEWVIOL UNSC REGIOORG GOVTPERM, re 
eststo const

**Running a combined analysis**
xtreg HMII_peryear COLDWAR L.ENDTYPE L.NEWVIOL UNSC REGIOORG GOVTPERM, re 
eststo both

**Printing our table with the three models**
esttab neor const both using HumSecMeas.rtf, se replace stats(N r2_w r2_o r2_b rmse)