* 2013

GET
  FILE='C:\Graziela\PNAD\PNAD 2013 (RRR).SAV'.

* SEGURADOS NÃO AGRÍCOLAS

WEIGHT
  BY v4729 .

RECODE
  v9062 v9005 v9092 v9097 v9099 v9103 v9073 v9095 v9096 (-1=0) (SYSMIS=0).
EXECUTE .

RECODE
  v9972 v9991 (SYSMIS=999999999999).
EXECUTE .

USE ALL.
COMPUTE filter_$=((v4706 = 4 or v4706 = 7 or v4706 = 9 or v4706 = 12 or v4706 = 13) & (v4809 >= 2 & v4809 <= 13)).
VARIABLE LABEL filter_$ '(v4706 = 4 or v4706 = 7 or v4706 = 9 or v4706 = 12 or v4706 = 13) & (v4809 >= 2 & v4809 <= 13) (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

FREQUENCIES
  VARIABLES=v4805 v9005 v9059
  /ORDER=  ANALYSIS .

WEIGHT
  OFF.

FILTER OFF.
USE ALL.
EXECUTE .

IF ((v4706 = 4 or v4706 = 7 or v4706 = 9 or v4706 = 12 or v4706 = 13) & (v4809 >= 2 & v4809 <= 13) & (v4805 = 1)) SEU = 1 .
EXECUTE .

IF ((SEU = 1) & (v9059 = 1)) SEG_Urb = 1 .
IF ((SEU = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 <= 5002) & (v9092 = 3 or v9092 = 5 or v9092 = 6)) SEG_Urb = 2 .
IF ((SEU = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 <= 5002) & (v9095 ~= 1 & v9096 ~= 2) & (v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6) & ((v9097 = 1) or (v9099 = 1) or (v9103 = 1))) SEG_Urb = 3 .
IF ((SEU = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 <= 5002) & (v9097 ~= 1 & v9099 ~= 1 & v9103 ~= 1 & v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6)) SEG_Urb = 4 .
IF ((SEU = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 > 5002) & (v9095 = 1 or v9096 = 2)) SEG_Urb = 5 .
IF ((SEU = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 > 5002) & (v9095 ~= 1 & v9096 ~= 2) & ((v9097 = 1) or (v9099 = 1) or (v9103 = 1))) SEG_Urb = 6 .
IF ((SEU = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 > 5002) & (v9097 ~= 1 & v9099 ~= 1 & v9103 ~= 1 & v9095 ~= 1 & v9096 ~= 2)) SEG_Urb = 7 .
IF ((SEU = 1) & (v9059 ~= 1) & (v9005 = 1) & (v9062 = 2) & ((v9611 = 0) & (v9612 <= 3)) & (v9972 <= 5002) & (v9073 = 6 or v9073 = 11 or v9073 = 12 or v9073 = 13)) SEG_Urb = 8 .
IF ((SEU = 1) & (v9059 ~= 1) & (v9005 = 1) & ((v9062 ~= 2) or ((v9062 = 2)  & (((v9611 ~= 0) or (v9612 > 3)) or (v9972 > 5002) or (v9073 ~= 6 & v9073 ~= 11 & v9073 ~= 12 & v9073 ~= 13))))) SEG_Urb = 9 .
EXECUTE .

WEIGHT
  BY v4729 .

FREQUENCIES
  VARIABLES=SEU SEG_Urb 
  /ORDER=  ANALYSIS .

RECODE
  SEG_Urb (SYSMIS=99).
EXECUTE .

Seg_NA = 0 (agricultores familiares)
Seg_NA = 1 (segurados rurais)
Seg_NA = 2 (servidores públicos e militares)
Seg_NA = 3 (segurados urbanos)
Seg_NA = 4 (não segurados urbanos)

IF ((SEG_Urb = 2) or (SEG_Urb = 8)) SEG_NA = 0 .
IF ((SEG_Urb = 3)) SEG_NA = 1 .
IF ((SEG_Urb = 5)) SEG_NA = 2 .
IF ((SEG_Urb = 1) or (SEG_Urb = 6)) SEG_NA = 3 .
IF ((SEG_Urb = 4) or (SEG_Urb = 7) or (SEG_Urb = 9)) SEG_NA = 4 .
EXECUTE .

FREQUENCIES
  VARIABLES=SEU SEG_Urb SEG_NA
  /ORDER=  ANALYSIS .

IF ((v4706 = 1 or v4706 = 2 or v4706 = 3 or v4706 = 5 or v4706 = 6 or v4706 = 8 or v4706 = 10 or v4706 = 11 or v4706 = 14) & (v4809 >= 2 & v4809 <= 13) & (v4805 = 1)) SEUF = 1 .
EXECUTE .

SEG_Urf = 1 (segurados urbanos)
SEG_Urf = 2 (servidores públicos e militares)
SEG_Urf = 3 (empregadores contribuintes)
SEG_Urf = 4 (não segurados urbanos)

IF ((SEUF = 1) & ((v4706 = 1 or v4706 = 6) or ((SEUF = 1) & (v4706 = 5 or v4706 = 8 or v4706 = 11 or v4706 = 14) & (v9059 = 1)))) SEG_Urf = 1 .
IF ((SEUF = 1) & (v4706 = 2 or v4706 = 3)) SEG_Urf = 2 .
IF ((SEUF = 1) & (v4706 = 10) & (v9059 = 1)) SEG_Urf = 3 .
IF ((SEUF = 1) & (((v4706 = 10) & (v9059 ~= 1)) or ((v4706 = 5 or v4706 = 8 or v4706 = 11 or v4706 = 14) & (v9059 ~= 1)))) SEG_Urf = 4 .
EXECUTE .

FREQUENCIES
  VARIABLES=SEUF SEG_Urf
  /ORDER=  ANALYSIS .

* SEGURADOS AGRÍCOLAS

WEIGHT
  BY v4729 .

RECODE
  v9062 v9005 v9092 v9097 v9099 v9103 v9073 v9095 v9096 v9017 v9018 (-1=0) (SYSMIS=0).
EXECUTE .

RECODE
  v9972 v9991 (SYSMIS=999999999999).
EXECUTE .

USE ALL.
COMPUTE filter_$=((v4706 = 4) & (v4809 = 1)).
VARIABLE LABEL filter_$ '(v4706 = 4) & (v4809 = 1) (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

FREQUENCIES
  VARIABLES=v4805 v9005 v9059
  /ORDER=  ANALYSIS .

WEIGHT
  OFF.

FILTER OFF.
USE ALL.
EXECUTE .

IF ((v4706 = 4) & (v4809 = 1) & (v4805 = 1)) SER = 1 .
EXECUTE .

IF ((SER = 1) & (v9059 = 1)) SEG_Rur = 1 .
IF ((SER = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 <= 5002) & (v9092 = 3 or v9092 = 5 or v9092 = 6)) SEG_Rur = 2 .
IF ((SER = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 <= 5002) & (v9095 ~= 1 & v9096 ~= 2) & (v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6) & ((v9097 = 1) or (v9099 = 1) or (v9103 = 1))) SEG_Rur = 3 .
IF ((SER = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 <= 5002) & (v9097 ~= 1 & v9099 ~= 1 & v9103 ~= 1 & v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6)) SEG_Rur = 4 .
IF ((SER = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 > 5002) & (v9095 = 1 or v9096 = 2)) SEG_Rur = 5 .
IF ((SER = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 > 5002) & (v9095 ~= 1 & v9096 ~= 2) & ((v9097 = 1) or (v9099 = 1) or (v9103 = 1))) SEG_Rur = 6 .
IF ((SER = 1) & (v9059 ~= 1) & (v9005 ~= 1) & (v9991 > 5002) & (v9097 ~= 1 & v9099 ~= 1 & v9103 ~= 1 & v9095 ~= 1 & v9096 ~= 2)) SEG_Rur = 7 .
IF ((SER = 1) & (v9059 ~= 1) & (v9005 = 1) & (v9062 = 2) & ((v9611 = 0) & (v9612 <= 3)) & (v9972 <= 5002) & (v9073 = 6 or v9073 = 11 or v9073 = 12 or v9073 = 13)) SEG_Rur = 8 .
IF ((SER = 1) & (v9059 ~= 1) & (v9005 = 1) & ((v9062 ~= 2) or ((v9062 = 2)  & (((v9611 ~= 0) or (v9612 > 3)) or (v9972 > 5002) or (v9073 ~= 6 & v9073 ~= 11 & v9073 ~= 12 & v9073 ~= 13))))) SEG_Rur = 9 .
EXECUTE .

WEIGHT
  BY v4729 .

FREQUENCIES
  VARIABLES=SER SEG_Rur 
  /ORDER=  ANALYSIS .

RECODE
  SEG_Rur (SYSMIS=99).
EXECUTE .

Seg_A = 0 (agricultores familiares)
Seg_A = 1 (segurados rurais)
Seg_A = 2 (servidores públicos e militares)
Seg_A = 3 (segurados urbanos)
Seg_A = 4 (potenciais segurados rurais)

IF ((SEG_Rur = 2) or (SEG_Rur = 8)) SEG_A = 0 .
IF ((SEG_Rur = 1) or (SEG_Rur = 3)) SEG_A = 1 .
IF ((SEG_Rur = 5)) SEG_A = 2 .
IF ((SEG_Rur = 6)) SEG_A = 3 .
IF ((SEG_Rur = 4) or (SEG_Rur = 7) or (SEG_Rur = 9)) SEG_A = 4 .
EXECUTE .

FREQUENCIES
  VARIABLES=SER SEG_Rur SEG_A
  /ORDER=  ANALYSIS .

IF ((v4706 = 1 or v4706 = 2 or v4706 = 3 or v4706 = 5 or v4706 = 6 or v4706 = 7 or v4706 = 8 or v4706 = 9 or v4706 = 10 or v4706 = 11 or v4706 = 12 or v4706 = 13 or v4706 = 14) & (v4809 = 1) & (v4805 = 1)) SERF = 1 .
EXECUTE .

SEG_Ruf = 1 (segurados rurais - inclusive empregados não segurados especiais)
SEG_Ruf = 2 (agricultores familiares)
SEG_Ruf = 3 (servidores públicos e militares)
SEG_Ruf = 4 (não segurados rurais)

IF (((SERF = 1) & ((v4706 = 1 or v4706 = 6) or ((v4706 = 5 or v4706 = 7 or v4706 = 8 or v4706 = 12 or v4706 = 14) & (v9059 = 1)))) or ((SERF = 1) & (v4706 = 10) & (v9059 = 1) & (((v9017 ~= 1 & v9017 ~= 3) or (v9018 ~= 4))))) SEG_Ruf = 1 .
IF ((SERF = 1) & ((v4706 = 9 or v4706 = 11 or v4706 = 13) or ((v4706 = 10) & ((v9017 = 1 or v9017 = 3) & (v9018 = 4))))) SEG_Ruf = 2 .
IF ((SERF = 1) & (v4706 = 2 or v4706 = 3)) SEG_Ruf = 3 .
IF ((SERF = 1) & (((v4706 = 10) & (v9059 ~= 1) & ((v9017 ~= 1 & v9017 ~= 3) or (v9018 ~= 4))) or ((v4706 = 5 or v4706 = 7 or v4706 = 8 or v4706 = 12 or v4706 = 14) & (v9059 ~= 1)))) SEG_Ruf = 4 .
EXECUTE .

FREQUENCIES
  VARIABLES=SERF SEG_Ruf
  /ORDER=  ANALYSIS .

* SEGURADOS - URBANOS E RURAIS

SEG = 0 (potenciais segurados rurais)
SEG = 1 (agricultores familiares)
SEG = 2 (segurados rurais)
SEG = 3 (servidores públicos e militares)
SEG = 4 (segurados urbanos)
SEG = 5 (não segurados urbanos)
SEG = 6 (não segurados rurais)

IF ((SEG_A = 4)) SEG = 0 .
IF ((SEG_Ruf = 2) or (SEG_A = 0) or (SEG_NA = 0)) SEG = 1 .
IF ((SEG_Ruf = 1) or (SEG_A = 1) or (SEG_NA = 1)) SEG = 2 .
IF ((SEG_Urf = 2) or (SEG_Ruf = 3) or (SEG_A = 2) or (SEG_NA = 2)) SEG = 3 .
IF ((SEG_Urf = 3) or (SEG_Urf = 1) or (SEG_A = 3) or (SEG_NA = 3)) SEG = 4 .
IF ((SEG_Urf = 4) or (SEG_NA = 4)) SEG = 5 .
IF ((SEG_Ruf = 4)) SEG = 6 .
EXECUTE .

FREQUENCIES
  VARIABLES=SEUF SEG_Urf SERF SEG_Ruf SEG v4809
  /ORDER=  ANALYSIS .

RECODE
  v9122 (-1=0) (SYSMIS=0).
EXECUTE .

IF ((v8005 >= 16 & v8005 < 999) & (v9122 ~= 2) & (v4805 = 1)) Segurado = 1 .
EXECUTE .

RECODE
  Segurado (-1=0) (SYSMIS=0).
EXECUTE .

CROSSTABS
  /TABLES=SEG  BY Segurado
  /FORMAT= AVALUE TABLES
  /CELLS= COUNT
  /COUNT ROUND CELL .

IF ((v8005 >= 0 & v8005 < 90)) Idade = v8005 .
IF ((v8005 >= 90)) Idade = 90 .
EXECUTE .

* Definir propriedades da variável.
*Idade.
VARIABLE LEVEL  Idade(NOMINAL).
EXECUTE.

USE ALL.
COMPUTE filter_$=(Segurado = 1).
VARIABLE LABEL filter_$ 'Segurado = 1 (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

* Tabelas personalizadas.
CTABLES
  /VLABELS VARIABLES=Idade SEG V0302 DISPLAY=LABEL
  /TABLE Idade [COUNT F40.0] BY SEG > V0302
  /CATEGORIES VARIABLES=Idade SEG V0302 ORDER=A KEY=VALUE EMPTY=EXCLUDE.

FILTER OFF.
USE ALL.
EXECUTE .

IF ((SEG = 0) & (Segurado = 1)) SFB = 0 .
IF ((SEG = 1) & (Segurado = 1)) SFB = 1 .
IF ((SEG = 2) & (Segurado = 1)) SFB = 2 .
IF ((SEG = 3) & (Segurado = 1)) SFB = 3 .
IF ((SEG = 4) & (Segurado = 1)) SFB = 4 .
IF ((SEG = 5) & (Segurado = 1)) SFB = 5 .
IF ((SEG = 6) & (Segurado = 1)) SFB = 6 .
EXECUTE .

IF  ((V4718 >= 0 & V4718 <= 678)) GRUPO_REND=1.
IF  ((V4718 > 678 & V4718 < 999999999999)) GRUPO_REND=2.
IF  ((V4718 = 999999999999)) GRUPO_REND=9.
EXECUTE.

* Tabelas personalizadas.
CTABLES
  /VLABELS VARIABLES=Idade V0302 SFB GRUPO_REND DISPLAY=LABEL
  /TABLE Idade [C] BY V0302 [C] > SFB [C] > GRUPO_REND [C][COUNT F40.0]
  /CATEGORIES VARIABLES=Idade V0302 GRUPO_REND ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES 
    POSITION=AFTER
  /CATEGORIES VARIABLES=SFB ORDER=A KEY=VALUE EMPTY=INCLUDE TOTAL=YES POSITION=AFTER.

USE ALL.
COMPUTE filter_$=((v4718 > 0 & v4718 < 999999999999)).
VARIABLE LABEL filter_$ '(v4718 > 0 & v4718 < 999999999999)'+
 ' (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

* Tabelas personalizadas.
CTABLES
  /VLABELS VARIABLES=Idade V0302 SFB GRUPO_REND V4718 DISPLAY=LABEL
  /TABLE Idade [C] BY V0302 [C] > SFB [C] > GRUPO_REND > V4718 [S][MEAN]
  /CATEGORIES VARIABLES=Idade V0302 GRUPO_REND ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES 
    POSITION=AFTER
  /CATEGORIES VARIABLES=SFB ORDER=A KEY=VALUE EMPTY=INCLUDE TOTAL=YES POSITION=AFTER.

