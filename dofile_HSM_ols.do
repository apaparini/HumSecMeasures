use "https://github.com/apaparini/HumSecMeasures/blob/main/PRIF-dataset-HMI-intervention-years-v-July-2019_raw.dta", clear

**Preparing and adjusting the database to our analysis** 
recode ENDTYPE (1=3) (3=1)
recode NEWVIOL (-88 = 2)
recode DISLOCATE (-99 = . )
recode CONTRA0 (-99 = 0.5)
generate byte GPOWINTERVEN = (COLDWAR == 1 & (INTERVEN1 == "USSR" | INTERVEN1 == "USA"))
egen HMIIC = group(HMIID)
egen HMII_peryear = count(HMIIC), by(YEAR)

**Running the structural neorrealist assumption regression**
eststo: reg HMII_peryear i.COLDWAR

**Running the path-dependent constructivist assumption regression**
eststo: reg HMII_peryear i.ENDTYPE i.NEWVIOL i.UNSC i.REGIOORG i.GOVTPERM 
gen LOG_ENDTYPE = log10(ENDTYPE)
gen LOG_NEWVIOL = log10(NEWVIOL)
eststo: reg HMII_peryear LOG_ENDTYPE LOG_NEWVIOL i.UNSC i.REGIOORG i.GOVTPERM 


**Running a combined analysis**
eststo: reg HMII_peryear i.COLDWAR i.ENDTYPE i.NEWVIOL i.UNSC i.REGIOORG i.GOVTPERM
eststo: reg HMII_peryear i.COLDWAR LOG_ENDTYPE LOG_NEWVIOL i.UNSC i.REGIOORG i.GOVTPERM
eststo: reg HMII_peryear i.COLDWAR LOG_ENDTYPE LOG_NEWVIOL i.UNSC

**Printing our table with the three models**
esttab using OLSHumSecMeas.rtf, se replace stats(N r2_a rmse)