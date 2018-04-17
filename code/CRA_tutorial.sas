/*This code follows the book Credit Risk Analytics by Baesens et. al.*/
/*Run using SAS Studio (free version in university edition)*/

/*Create new table called 'EXAMPLE' in WORK*/
DATA example;
SET data.mortgage;

/*delete some observations*/
IF FICO_orig_time< 500 THEN DELETE;

/*generate new variable*/
IF FICO_orig_time> 500 THEN FICO_cat=1;
IF FICO_orig_time> 700 THEN FICO_cat=2;

/*filter data*/
WHERE default_time=1;

/*drop variable*/
DROP status_time;
RUN;

/*Show summary using PROC MEANS*/
PROC MEANS DATA=data.mortgage;
VAR default_time FICO_orig_time ltv_orig_time gdp_time;
RUN;

/*Example of linear regression (p.21)*/
PROC REG DATA=data.mortgage;
MODEL default_time = FICO_orig_time ltv_orig_time gdp_time;
RUN;

/*Define a macro for linear regression*/
%MACRO example(datain, lhs, rhs);
PROC REG DATA=&datain;
MODEL &lhs = &rhs;
RUN;
%MEND example;

/*Calling macro for linear regression*/
%example(datain=data.mortgage, lhs=default_time, rhs=FICO_orig_time );
%example(datain=data.mortgage, lhs=default_time, rhs=FICO_orig_time ltv_orig_time);
%example(datain=data.mortgage, lhs=default_time, rhs=FICO_orig_time ltv_orig_time gdp_time);

/*Build model and save parameters as 'parameters' in the WORK library*/
ODS LISTING CLOSE;
ODS OUTPUT PARAMETERESTIMATES=parameters;
PROC REG DATA=data.mortgage;
MODEL default_time = FICO_orig_time ltv_orig_time gdp_time;
RUN;
ODS OUTPUT CLOSE;
ODS LISTING;

/*Export 'parameters' as export.csv (p.23)*/
PROC EXPORT DATA=parameters 
			REPLACE 
			DBMS=CSV 
			OUTFILE='/folders/myfolders/sasuser.v94/export.csv';
RUN;

/*Use IML to find the square root of a number accurate to 3 decimals*/
PROC IML;

START MySqrt(x);
   y = 1;
   DO UNTIL (w<1e-3);
      z = y;
      y = 0.5#(z+x/z);
      w = ABS(y-z);
   END;
   RETURN(y);
FINISH;
t = MySqrt({3,4,7,9}); *apply our function;
s = SQRT({3,4,7,9});   *apply build-in function;
diff = t - s;		   *compare the two outputs;
PRINT t s diff;
QUIT;

PROC SETINIT;