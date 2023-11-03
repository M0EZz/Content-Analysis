* Encoding: UTF-8.

**NOTE: This code only works when run one-by-one or blocks of two. Do not run it all at once and run it sequentially.

* Insert your dataset here:

DATASET ACTIVATE DataSet1.

* Identify Duplicate Cases.
SORT CASES BY C2_link(A) HP_1a_text(A).
MATCH FILES
  /FILE=*
  /BY C2_link HP_1a_text
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

*We filter out the duplicates

USE ALL.
COMPUTE filter_$=(PrimaryLast=1).
VARIABLE LABELS filter_$ 'PrimaryLast=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* remove Qualtrics variable, not needed

DELETE VARIABLES
StartDate
EndDate
Status
IPAddress
Progress
Duration__in_seconds_
Finished
RecordedDate
ResponseId
RecipientLastName
RecipientFirstName
RecipientEmail
ExternalReference
LocationLatitude
LocationLongitude
DistributionChannel
UserLanguage.

*recode multiple items for types into one dichtomous variable

COMPUTE H3= mean(H3a, H3b).
EXECUTE.
COMPUTE H4=mean(H4a, H4b, H4c, H4d).
EXECUTE.
COMPUTE H5=mean(H5a, H5b).
EXECUTE.
COMPUTE H7=mean(H7a, H7b).
EXECUTE.
COMPUTE H8=mean(H8a, H8b, H8c).
EXECUTE.
COMPUTE H9=mean(H9a, H9b).
EXECUTE.
COMPUTE H10=mean(H10a, H10b).
EXECUTE.

*make sure that they equal either 2 (missing/not present) and 1 (present)

RECODE H1a, H2a, H3, H4, H5, H6a, H7, H8, H9, H10 (SYSMIS=2) (2=2)(ELSE=1).
EXECUTE.

* make it into 0 and 1

RECODE HP_1b_HumorP, H1a, H2a, H3, H4, H5, H6a, H7, H8, H9, H10 (2=0) (1=1).
EXECUTE.

* run this manually - change measurement level from scale to categorical

VARIABLE LEVEL C3_typeC, HP_1b_HumorP, H1a, H2a, H3, H4, H5, H6a, H7, H8, H9, H10 (nominal).
EXECUTE.

VARIABLE LEVEL C1_SubR (ordinal).
EXECUTE.

* rename humor types

RENAME VARIABLES (C3_typeC = type_comment) 
                 (HP_1b_HumorP = Humor_presence)
                 (C1_SubR = Subreddit)
                 (H1a = Aggr_humor) 
                 (H2a = SelfD_humor) 
                 (H3 = Sex_humor) 
                 (H4 = Irrev_humor) 
                 (H5 = Coping_humor) 
                 (H6a = Parody_humor) 
                 (H7 = Wordpl_humor) 
                 (H8 = Incongr_humor) 
                 (H9 = Absurd_humor) 
                 (H10 = Hyperb_humor). 
  


*test H1a&H1b

LOGISTIC REGRESSION VARIABLES Humor_presence
  /METHOD=ENTER Subreddit type_comment 
  /CONTRAST (Subreddit)=Indicator(1)
  /CONTRAST (type_comment)=Indicator
  /PRINT= CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

*test H2

*creat the dark humor variable

COMPUTE Dark_humor=mean(Irrev_humor, Aggr_humor, Coping_humor).
EXECUTE.

RECODE Dark_humor (0=0) (ELSE=1).
EXECUTE.

VARIABLE LEVEL Dark_humor (ordinal).
EXECUTE.

* run Chi-square

CROSSTABS
  /TABLES=type_comment BY Dark_humor
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ CC PHI LAMBDA GAMMA 
  /CELLS=COUNT EXPECTED COLUMN RESID PROP 
  /COUNT ROUND CELL.

*exploratory

COMPUTE INCON=mean(Parody_humor, Wordpl_humor, Hyperb_humor, Incongr_humor, Absurd_humor).
EXECUTE.
COMPUTE RELIEF=mean(Irrev_humor, Sex_humor, Coping_humor).
EXECUTE.
COMPUTE SUPER=mean(SelfD_humor, Aggr_humor).
EXECUTE.

RECODE INCON, RELIEF, SUPER (0=0) (ELSE=1).
EXECUTE.

VARIABLE LEVEL INCON, RELIEF, SUPER (ordinal).
EXECUTE.

LOGISTIC REGRESSION VARIABLES INCON
  /METHOD=ENTER type_comment Subreddit 
  /CONTRAST (type_comment)=Indicator
  /CONTRAST (Subreddit)=Indicator
   /PRINT= CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

LOGISTIC REGRESSION VARIABLES RELIEF
  /METHOD=ENTER type_comment Subreddit 
  /CONTRAST (type_comment)=Indicator
  /CONTRAST (Subreddit)=Indicator
   /PRINT= CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).

LOGISTIC REGRESSION VARIABLES SUPER
  /METHOD=ENTER type_comment Subreddit 
  /CONTRAST (type_comment)=Indicator
  /CONTRAST (Subreddit)=Indicator
   /PRINT= CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).



