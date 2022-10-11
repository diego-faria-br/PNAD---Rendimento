BASE - PNAD - 2013


* CHAVE PARA IDENTIFICAÇÃO DO DOMICÍLIO

GET
  FILE='F:\Modelo de Projeção - Atualização\Base - PNAD - 2013.SAV'.

IF (v0302 = 2 | v0302 = 4) ID = PD .
EXECUTE .

* OCUPAÇÃO RURAL (SEM CARTEIRA)

RECODE
  v9062 v9005 (-1=0) (SYSMIS=0).
EXECUTE .

RECODE
  v9972 (SYSMIS=999999999999).
EXECUTE .

* Sem carteira/Atividades agr’colas/Idade maior que 10 anos e Ocupadas

IF ((v4706 = 4) & (v4809 = 1) & (v8005 >= 10 & v8005 < 999) & (v4805 = 1)) SCR = 1 .
EXECUTE .

*	Todas as condi›es anteriores mais: qtde_trabalho 1/Nao saiu de trabalho nos œltimos 358 dias

IF ((SCR = 1) & (v9005 = 1) & (v9062 ~= 2)) SC_Rural = 1 .

*	Todas as condi›es anteriores mais: qtde_trabalho 1/Saiu de trabalho nos œltimos 358 dias/Menos de Trs meses no Trabalho/Empreend. Rural/Contra pr—pria ou Sem Remunaracao ou Subsistncia

IF ((SCR = 1) & (v9005 = 1) & (v9062 = 2) & (v9611 = 0) & (v9612 <= 3) & (v9972 <= 5002) & (v9073 = 6 or v9073 = 11 or v9073 = 12 or v9073 = 13)) SC_Rural = 2 .
IF ((SCR = 1) & (v9005 = 1) & (v9062 = 2) & ((v9611 ~= 0) or (v9612 > 3) or (v9972 > 5002) or (v9073 ~= 6 & v9073 ~= 11 & v9073 ~= 12 & v9073 ~= 13))) SC_Rural = 3 .
IF ((SCR = 1) & (v9005 ~= 1) & (v9991 <= 5002) & (v9092 = 3 or v9092 = 5 or v9092 = 6)) SC_Rural = 4 .
IF ((SCR = 1) & (v9005 ~= 1) & ((v9991 > 5002) or (v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6)) & (v9062 ~= 2)) SC_Rural = 5 .
IF ((SCR = 1) & (v9005 ~= 1) & ((v9991 > 5002) or (v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6)) & (v9062 = 2) & (v9611 = 0) & (v9612 <= 3) & (v9972 <= 5002) & (v9073 = 6 or v9073 = 11 or v9073 = 12 or v9073 = 13)) SC_Rural = 6 .
IF ((SCR = 1) & (v9005 ~= 1) & ((v9991 > 5002) or (v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6)) & (v9062 = 2) & ((v9611 ~= 0) or (v9612 > 3) or (v9972 > 5002) or (v9073 ~= 6 & v9073 ~= 11 & v9073 ~= 12 & v9073 ~= 13))) SC_Rural = 7 .
EXECUTE .

OC_Rural = 0 (agricultores familiares)
OC_Rural = 1 (ocupados rurais)

IF ((SC_Rural = 2) or (SC_Rural = 4) or (SC_Rural = 6)) OC_Rural = 0 .
IF ((SC_Rural = 1) or (SC_Rural = 3) or (SC_Rural = 5) or (SC_Rural = 7)) OC_Rural = 1 .
EXECUTE .

* OCUPAÇÃO URBANA (EMPREGADOS E DOMÉSTICOS SEM CARTEIRA, TRABALHADOR NA CONSTRUÇÃO PARA O PRÓPRIO USO E NÃO REMUNERADOS)

RECODE
  v9062 v9005 (-1=0) (SYSMIS=0).
EXECUTE .

RECODE
  v9972 (SYSMIS=999999999999).
EXECUTE .

IF ((v4706 = 4 or v4706 = 7 or v4706 = 12 or v4706 = 13) & (v4809 >= 2 & v4809 <= 13) & (v8005 >= 10 & v8005 < 999) & (v4805 = 1)) SCU = 1 .
EXECUTE .

IF ((SCU = 1) & (v9005 = 1) & (v9062 ~= 2)) SC_Urban = 1 .
IF ((SCU = 1) & (v9005 = 1) & (v9062 = 2) & (v9611 = 0) & (v9612 <= 3) & (v9972 <= 5002) & (v9073 = 6 or v9073 = 11 or v9073 = 12 or v9073 = 13)) SC_Urban = 2 .
IF ((SCU = 1) & (v9005 = 1) & (v9062 = 2) & ((v9611 ~= 0) or (v9612 > 3) or (v9972 > 5002) or (v9073 ~= 6 & v9073 ~= 11 & v9073 ~= 12 & v9073 ~= 13))) SC_Urban = 3 .
IF ((SCU = 1) & (v9005 ~= 1) & (v9991 <= 5002) & (v9092 = 3 or v9092 = 5 or v9092 = 6)) SC_Urban = 4 .
IF ((SCU = 1) & (v9005 ~= 1) & ((v9991 > 5002) or (v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6)) & (v9062 ~= 2)) SC_Urban = 5 .
IF ((SCU = 1) & (v9005 ~= 1) & ((v9991 > 5002) or (v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6)) & (v9062 = 2) & (v9611 = 0) & (v9612 <= 3) & (v9972 <= 5002) & (v9073 = 6 or v9073 = 11 or v9073 = 12 or v9073 = 13)) SC_Urban = 6 .
IF ((SCU = 1) & (v9005 ~= 1) & ((v9991 > 5002) or (v9092 ~= 3 & v9092 ~= 5 & v9092 ~= 6)) & (v9062 = 2) & ((v9611 ~= 0) or (v9612 > 3) or (v9972 > 5002) or (v9073 ~= 6 & v9073 ~= 11 & v9073 ~= 12 & v9073 ~= 13))) SC_Urban = 7 .
EXECUTE .

OC_Urban = 0 (agricultores familiares)
OC_Urban = 1 (ocupados urbanos)

IF ((SC_Urban = 2) or (SC_Urban = 4) or (SC_Urban = 6)) OC_Urban = 0 .
IF ((SC_Urban = 1) or (SC_Urban = 3) or (SC_Urban = 5) or (SC_Urban = 7)) OC_Urban = 1 .
EXECUTE .

* IDENTIFICAÇÃO DO DOMICÍLIO

RECODE
  v4814 v4713 v4704 v4805 v9067 v9068 v9069 v4809 (-1=0) (SYSMIS=0).
EXECUTE .

RECODE
  OC_Urban (SYSMIS=999999999999).
EXECUTE .

IF (((v8005 >= 10 & v8005 < 999) & (v4805 = 1) & (v4809 = 1)) or (OC_Urban = 0)) Ocup_Rur = 1 .
EXECUTE .

IF ((v8005 >= 10 & v8005 < 999) & (v4805 = 1) & (v4809 >= 2 & v4809 <= 13) & (OC_Urban ~= 0)) Ocup_Urb = 1 .
EXECUTE .

IF ((v8005 >= 10 & v8005 < 999) & (v4805 ~= 1) & (v9067 = 1 or v9068 = 2 or v9069 = 1) & (v9972 <= 5002)) Desi_Rur = 1 .
EXECUTE .

IF ((v8005 >= 10 & v8005 < 999) & (v4805 ~= 1) & (v9067 = 1 or v9068 = 2 or v9069 = 1) & (v9972 > 5002)) Desi_Urb = 1 .
EXECUTE .

RECODE
  Desi_Rur Desi_Urb Ocup_Rur Ocup_Urb (-1=0) (SYSMIS=0).
EXECUTE .

* ETAPAS DE CLASSIFICAÇÃO DO DOMICÍLIO (CHEFES, CÔNJUGES E OCUPADOS)

* Chefes de Família

IF (ID = 1) CHEFE = 1 . 
IF (ID ~= 1) CHEFE = 0 . 
EXECUTE .

IF ((CHEFE = 1) & ((Ocup_Rur = 1) or (Desi_Rur = 1))) CHEFR_Oc = 1 . 
EXECUTE .

IF ((CHEFE = 1) & ((Ocup_Urb = 1) or (Desi_Urb = 1))) CHEFU_Oc = 1 . 
EXECUTE .

RECODE
  CHEFR_Oc CHEFU_Oc (-1=0) (SYSMIS=0).
EXECUTE .

AGGREGATE
  /OUTFILE=*
  MODE=ADDVARIABLES
  /BREAK=ildf
  /Famr_Che = SUM(CHEFR_Oc) / Famu_Che = SUM(CHEFU_Oc)  .

IF (Famr_Che = 1) CHEFE_D = 1 . 
IF (Famu_Che = 1) CHEFE_D = 2 . 
EXECUTE .

* Cônjuges

IF (ID = 2) CONJUGE = 1 . 
IF (ID ~= 2) CONJUGE = 0 . 
EXECUTE .

IF ((CONJUGE = 1) & ((Ocup_Rur = 1) or (Desi_Rur = 1))) Conjr_Oc = 1 . 
EXECUTE .

IF ((CONJUGE = 1) & ((Ocup_Urb = 1) or (Desi_Urb = 1))) Conju_Oc = 1 . 
EXECUTE .

RECODE
  Conjr_Oc Conju_Oc (-1=0) (SYSMIS=0).
EXECUTE .

AGGREGATE
  /OUTFILE=*
  MODE=ADDVARIABLES
  /BREAK=ildf
  /Famr_Con = SUM(Conjr_Oc) / Famu_Con = SUM(Conju_Oc) .

IF (Famr_Con = 1) CONJ_D = 1 . 
IF (Famu_Con = 1) CONJ_D = 2 . 
EXECUTE .

* Total de Ocupados por Domicílio 

AGGREGATE
  /OUTFILE=*
  MODE=ADDVARIABLES
  /BREAK=ildf
  /PRO = SUM(Ocup_Rur) / PRD = SUM(Desi_Rur) / PUO = SUM(Ocup_Urb) / PUD = SUM(Desi_Urb) .

IF ((PRO > PUO) or ((PRO = PUO) & (PRD > PUD))) FRU = 1 . 
EXECUTE .

IF ((PUO > PRO) or ((PUO = PRO) & (PUD >= PRD))) FUR = 1 . 
EXECUTE .

IF (FRU = 1) OCUP_D = 1 . 
IF (FUR = 1) OCUP_D = 2 . 
EXECUTE .

* Variável Final

RECODE
  CHEFE_D CONJ_D OCUP_D (SYSMIS=999).
EXECUTE .

IF ((CHEFE_D = 1) or (CHEFE_D = 999 & CONJ_D = 1) or (CHEFE_D = 999 & CONJ_D = 999 & OCUP_D = 1)) DOM = 0 .
IF ((CHEFE_D = 2) or (CHEFE_D = 999 & CONJ_D = 2) or (CHEFE_D = 999 & CONJ_D = 999 & OCUP_D = 2)) DOM = 1 .
EXECUTE .

* População Urbana (1) e Rural (2)

  População Rural (1) = Pessoas em domicílios rurais (se ocupadas em atividades agrícolas) ou ocupadas em atividades agrícolas (mesmo que moradoras de domicílios urbanos).
  População Urbana (2) = Pessoas em domicílios urbanos (se ocupadas em atividades não-agrícolas) ou ocupadas em atividades não-agrícolas (mesmo que moradoras de domicílios rurais).

IF ((v4805 = 1) & (v8005 >= 10 & v8005 < 999) & (v4809 = 1)) POTP = 1 .
IF ((v4805 = 1) & (v8005 >= 10 & v8005 < 999) & (v4809 >= 2 & v4809 <= 13)) POTP = 2 .
EXECUTE .

RECODE
  POTP (-1=0) (SYSMIS=0).
EXECUTE .

IF (((DOM = 1) & (POTP ~= 1)) or ((DOM = 0) & (POTP = 2))) POUR = 1 .
IF (((DOM = 0) & (POTP ~= 2)) or ((DOM = 1) & (POTP = 1))) POUR = 2 .
EXECUTE .

IF  ((V4718 >= 0 & V4718 <= 678)) GRUPO_REND=1.
IF  ((V4718 > 678 & V4718 < 999999999999)) GRUPO_REND=2.
IF  ((V4718 = 999999999999)) GRUPO_REND=9.
EXECUTE.

IF ((v8005 >= 0 & v8005 < 90)) Idade = v8005 .
IF ((v8005 >= 90)) Idade = 90 .
EXECUTE .

* Definir propriedades da variável.
*POUR.
VARIABLE LABELS  POUR 'POPULAÇÃO POR CLIENTELA'.
VALUE LABELS POUR
  1.00 'URBANA'
  2.00 'RURAL'.
EXECUTE.

* Definir propriedades da variável.
*POTP.
VARIABLE LABELS  POTP 'POPULAÇÃO OCUPADA POR CLIENTELA'.
VALUE LABELS POTP
  .00 'NÃO APLICÁVEL'
  1.00 'RURAL'
  2.00 'URBANA'.
EXECUTE.

* Definir propriedades da variável.
*Idade.
VARIABLE LEVEL  Idade(ORDINAL).
EXECUTE.

WEIGHT
  BY v4729 .

* Tabelas personalizadas.
CTABLES
  /VLABELS VARIABLES=Idade POTP V0302 GRUPO_REND DISPLAY=LABEL
  /TABLE Idade [C] BY POTP [C] > V0302 [C] > GRUPO_REND [C][COUNT F40.0]
  /CATEGORIES VARIABLES=Idade V0302 GRUPO_REND ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES 
    POSITION=AFTER
  /CATEGORIES VARIABLES=POTP ORDER=A KEY=VALUE EMPTY=INCLUDE TOTAL=YES POSITION=AFTER.

IF ((v4805 = 2) & (v8005 >= 10 & v8005 < 999) & (POUR = 2)) PDTP = 1 .
IF ((v4805 = 2) & (v8005 >= 10 & v8005 < 999) & (POUR = 1)) PDTP = 2 .
EXECUTE .

RECODE
  PDTP (-1=0) (SYSMIS=0).
EXECUTE .

FREQUENCIES
  VARIABLES=POTP PDTP
  /ORDER=  ANALYSIS .

CROSSTABS
  /TABLES=v8005  BY PDTP  BY v0302
  /FORMAT= AVALUE TABLES
  /CELLS= COUNT
  /COUNT ROUND CELL .

CROSSTABS
  /TABLES=v8005  BY POUR  BY v0302
  /FORMAT= AVALUE TABLES
  /CELLS= COUNT
  /COUNT ROUND CELL .

CROSSTABS
  /TABLES=v8005  BY POTP  BY v0302
  /FORMAT= AVALUE TABLES
  /CELLS= COUNT
  /COUNT ROUND CELL .

* Rendimento Médio

IF ((v4718 = 0)) Zero = 0 .
IF ((v4718 > 0 & v4718 < 999999999999)) Zero = 1 .
IF ((v4718 = 999999999999)) Zero = 9 .
EXECUTE .

USE ALL.
COMPUTE filter_$=((v0302 = 2)).
VARIABLE LABEL filter_$ '(v0302 = 2) (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

CROSSTABS
  /TABLES=Idade  BY POTP  BY Zero
  /FORMAT= AVALUE TABLES
  /CELLS= COUNT
  /COUNT ROUND CELL .

USE ALL.
COMPUTE filter_$=((v0302 = 4)).
VARIABLE LABEL filter_$ '(v0302 = 4) (FILTER)'.
VALUE LABELS filter_$  0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE .

CROSSTABS
  /TABLES=Idade  BY POTP  BY Zero 
  /FORMAT= AVALUE TABLES
  /CELLS= COUNT
  /COUNT ROUND CELL .

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
  /VLABELS VARIABLES=Idade POTP V0302 GRUPO_REND V4718 DISPLAY=LABEL
  /TABLE Idade [C] BY POTP [C] > V0302 [C] > GRUPO_REND [C] > V4718 [S][MEAN]
  /CATEGORIES VARIABLES=Idade V0302 GRUPO_REND ORDER=A KEY=VALUE EMPTY=EXCLUDE TOTAL=YES 
    POSITION=AFTER
  /CATEGORIES VARIABLES=POTP ORDER=A KEY=VALUE EMPTY=INCLUDE TOTAL=YES POSITION=AFTER.
