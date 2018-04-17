/*create a library in "My Libraries" called data */
/*used this site as guide: https://communities.sas.com/t5/SAS-Analytics-U/creating-library-in-SAS-University-Edition-Help/td-p/153829*/

libname data '/folders/myfolders/sasuser.v94';
run;

/* turn the mortgage table from csv to SAS table */
/*this only needs to be run once to create the SAS table*/
data data.mortgage;
	infile '/folders/myfolders/sasuser.v94/mortgage.csv' dlm=',' firstobs=2;
	input id time orig_time	first_time mat_time	balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time	REtype_CO_orig_time	REtype_PU_orig_time	REtype_SF_orig_time investor_orig_time balance_orig_time FICO_orig_time LTV_orig_time Interest_Rate_orig_time hpi_orig_time default_time payoff_time status_time;
run;