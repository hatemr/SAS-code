/*Chapter 3 of Credit Risk Analytics*/

/*plot frequencies using PROC FREQ*/
PROC FREQ DATA=data.mortgage;
TABLES default_time;
RUN;

/*Plot histograms with PROC UNIVARIATE*/
ODS GRAPHICS ON;
PROC UNIVARIATE DATA=data.mortgage;
VAR FICO_orig_time LTV_orig_time;
CDFPLOT FICO_orig_time LTV_orig_time;
HISTOGRAM FICO_orig_time LTV_orig_time;
RUN;
ODS GRAPHICS OFF;

/*Show summary statistics using PROC MEANS*/
PROC MEANS DATA=data.mortgage
N MEAN MEDIAN MODE P1 P99 MAXDE=4;
VAR DEFAULT_time FICO_orig_time LTV_orig_time;
RUN;

/*Show Q-Q plot using PROC UNIVARIATE*/
ODS GRAPHICS ON;
PROC UNIVARIATE DATA=data.mortgage NOPRINT;
QQPLOT FICO_orig_time / NORMAL(MU=EST SIGMA=EST COLOR=LTGREY);
RUN;
ODS GRAPHICS OFF;

/*Show variance stats using PROC MEANS*/
PROC MEANS DATA=data.mortgage
N MIN MAX RANGE QRANGE VAR STD CV MAXDEC=4;
VAR default_time FICO_orig_time LTV_orig_time;
RUN;

/*Bin the FICO and make 2-D Contingency table*/
DATA mortgage1;
SET data.mortgage;
RUN;

PROC RANK DATA = mortgage1
GROUPS=5
OUT=quint(KEEP=id time FICO_orig_time);
VAR FICO_orig_time;
RUN;

DATA new;
MERGE mortgage1 quint;
BY id time;
RUN;

PROC FREQ DATA=new;
TABLES default_time*FICO_ORIG_TIME;
RUN;

/*Show box plots using PROC BOX-PLOT*/
PROC SORT DATA=mortgage1;
BY default_time;
RUN;

/*Box plot of FICO_orig_time*/
ODS GRAPHICS ON;
PROC BOXPLOT DATA=mortgage1;
PLOT FICO_orig_time*default_time /IDSYMBOL=CIRCLE
IDHEIGHT=2 CBOXES=BLACK BOXWIDTH=10;
RUN;
ODS GRAPHICS OFF;

/*Box plot of LTV_orig_time*/
ODS GRAPHICS ON;
PROC BOXPLOT DATA=mortgage1;
PLOT LTV_orig_time*default_time / IDSYMBOL=CIRCLE
IDHEIGHT=2 CBOXES=BLACK BOXWIDTH=10;
RUN;
ODS GRAPHICS OFF;

/*Chi-square tables*/
PROC FREQ DATA=new;
TABLES default_time*FICO_ORIG_TIME / CHISQ;
RUN;

/*Calculate correlation coefficients*/
DATA sample;
SET data.mortgage;
IF RANUNI(123456) < 0.01;
RUN;

ODS GRAPHICS ON;
PROC CORR DATA=sample
PLOTS(MAXPOINTS=NONE)=SCATTER(NVAR=2 ALPHA=.20 .30)
KENDALL SPEARMAN;
VAR FICO_orig_time LTV_orig_time;
RUN;
ODS GRAPHICS OFF;

/*Confidence intervals of mean with PROC UNIVARIATE*/
ODS SELECT BASICINTERVALS;
PROC UNIVARIATE DATA=data.mortgage CIBASIC(ALPHA=.01);
VAR LTV_orig_time;
RUN;

/*p-value for mean=60*/
ODS GRAPHICS ON;
ODS SELECT TESTSFORLOCATION ;
PROC UNIVARIATE DATA=data.mortgage MU0=60;
VAR LTV_orig_time;
RUN;
ODS GRAPHICS OFF;