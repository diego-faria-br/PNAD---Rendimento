BASE - PNAD - 2014

CRIAR NOVOS DOMICÍLIOS (EMPREGADOS DOMÉSTICOS E PENSIONISTAS)

* B2

GET
  FILE='C:\Users\r1342200\Documents\PNAD\PNAD 2014.sav'.

USE ALL.
SELECT IF((v0401 = 6) & (v0402 = 1 | v0402 = 6)).
EXECUTE .

IF ((v0401 = 6) & (v0402 = 1 | v0402 = 6)) PD = 1 .
EXECUTE .

IF ((v0302 = 2 | v0302 = 4)) Base = 2 .
EXECUTE .

SAVE OUTFILE='F:\Modelo de Projeção - Atualização\PNAD 2014\B2.sav'
 /COMPRESSED.

* B3

GET
  FILE='C:\Users\r1342200\Documents\PNAD\PNAD 2014.sav'.

IF ((v0401 = 7) & (v0402 = 1 | v0402 = 7)) Domesti = 1 .
EXECUTE .

RECODE
  Domesti (-1=0) (SYSMIS=0).
EXECUTE .

AGGREGATE
  /OUTFILE=*
  MODE=ADDVARIABLES
  /BREAK=ild
  /ED = SUM(Domesti) .

USE ALL.
SELECT IF((Domesti >= 1) & (v0401 = 7 | v0401 = 8)).
EXECUTE .

IF ((v0401 = 7) & (v0402 = 1 | v0402 = 7)) PD = 1 .
IF ((v0401 = 8)) PD = v0402 .
EXECUTE .

IF ((v0302 = 2 | v0302 = 4)) Base = 3 .
EXECUTE .

DELETE VARIABLES Domesti ED.

SAVE OUTFILE='F:\Modelo de Projeção - Atualização\PNAD 2014\B3.sav'
 /COMPRESSED.

* B1

GET
  FILE='C:\Users\r1342200\Documents\PNAD\PNAD 2014.sav'.

IF ((v0401 = 7) & (v0402 = 1 | v0402 = 7)) Domesti = 1 .
EXECUTE .

RECODE
  Domesti (-1=0) (SYSMIS=0).
EXECUTE .

AGGREGATE
  /OUTFILE=*
  MODE=ADDVARIABLES
  /BREAK=ild
  /ED = SUM(Domesti) .

USE ALL.
SELECT IF (v0401 >= 1 & v0401 <= 5) or ((v0401 = 6) & (v0402 ~= 1 & v0402 ~= 6)) or ((Domesti = 0) & (v0401 = 8)) or ((v0401 = 7) & (v0402 ~= 1 & v0402 ~= 7)) .
EXECUTE .

IF ((v0302 = 2 | v0302 = 4)) PD = v0401 .
EXECUTE .

IF ((v0302 = 2 | v0302 = 4)) Base = 1 .
EXECUTE .

DELETE VARIABLES Domesti ED.

SAVE OUTFILE='F:\Modelo de Projeção - Atualização\PNAD 2014\B1.sav'
 /COMPRESSED.

* Base Completa

ADD FILES /FILE=*
 /FILE='F:\Modelo de Projeção - Atualização\PNAD 2014\B2.sav'.
EXECUTE.

ADD FILES /FILE=*
 /FILE='F:\Modelo de Projeção - Atualização\PNAD 2014\B3.sav'.
EXECUTE.

* ILDF

DO IF PD = 1.
COMPUTE #temp = #temp+1.
END IF.
COMPUTE ildf = #temp.
EXECUTE.

SAVE OUTFILE='F:\Modelo de Projeção - Atualização\PNAD 2014\Base - PNAD - 2014.sav'
 /COMPRESSED.

* BATIMENTO *

FREQUENCIES
  VARIABLES=V4805 V4704 V4706
  /ORDER=  ANALYSIS .
