library(PNADcIBGE)
library(survey)
library(srvyr)
library(tidyr)
library(dplyr)
library(kableExtra)
library(ggplot2)
rm(list = ls())
SM_2020 <-1045
SM_2019 <-998
SM_2018<-954
SM_2017<-937
SM_2016<-880

# Carrega base de dados

dados_srvyr_2020<-as_survey(pnadc_design(read_pnadc("./data/PNADC_2020_visita5.txt","./data/input_PNADC_2020_visita5.txt",vars=c(
  'V1022',
  'V2005',
  'V4010',
  'V2009',
  'V2007',
  'VD4010',
  'VD4009',
  'VD4012',
  'VD4002',
  'VD4019'))))

dados_srvyr_2019<-as_survey(pnadc_design(read_pnadc("./data/PNADC_2019_visita5.txt","./data/input_PNADC_2019_visita5.txt",vars=c(
  'V1022',
  'V2005',
  'V4010',
  'V2009',
  'V2007',
  'VD4010',
  'VD4009',
  'VD4012',
  'VD4002',
  'VD4019'))))


dados_srvyr_2018<-as_survey(pnadc_design(read_pnadc("./data/PNADC_2018_visita5.txt","./data/input_PNADC_2018_visita5.txt",vars=c(
  'V1022',
  'V2005',
  'V4010',
  'V2009',
  'V2007',
  'VD4010',
  'VD4009',
  'VD4012',
  'VD4002',
  'VD4019'))))

dados_srvyr_2017<-as_survey(pnadc_design(read_pnadc("./data/PNADC_2017_visita5.txt","./data/input_PNADC_2017_visita5.txt",vars=c(
  'V1022',
  'V2005',
  'V4010',
  'V2009',
  'V2007',
  'VD4010',
  'VD4009',
  'VD4012',
  'VD4002',
  'VD4019'))))

dados_srvyr_2016<-as_survey(pnadc_design(read_pnadc("./data/PNADC_2016_visita5.txt","./data/input_PNADC_2016_visita5.txt",vars=c(
  'V1022',
  'V2005',
  'V4010',
  'V2009',
  'V2007',
  'VD4010',
  'VD4009',
  'VD4012',
  'VD4002',
  'VD4019'))))

#Filtros Classificação Segurado Urbano e SM

#2020

dados_srvyr_2020 <- dados_srvyr_2020 %>% mutate(Acima_SM = as.numeric(VD4019>SM_2020))

dados_srvyr_2020 <- dados_srvyr_2020 %>% mutate(Seg_Urb =ifelse((V2009>=14&
                                                                   (VD4009 %in% c('01','03')&VD4010!='01'|
                                                                      VD4009 %in% c('02','04','06','08','09','10')&VD4010!='01'&VD4012=='1'|
                                                                      VD4009 %in% c('05','07'))
),1,0))

#2019

dados_srvyr_2019 <- dados_srvyr_2019 %>% mutate(Acima_SM = as.numeric(VD4019>SM_2019))

dados_srvyr_2019 <- dados_srvyr_2019 %>% mutate(Seg_Urb =ifelse((V2009>=14&
                                                                   (VD4009 %in% c('01','03')&VD4010!='01'|
                                                                      VD4009 %in% c('02','04','06','08','09','10')&VD4010!='01'&VD4012=='1'|
                                                                      VD4009 %in% c('05','07'))
),1,0))

#2018

dados_srvyr_2018 <- dados_srvyr_2018 %>% mutate(Acima_SM = as.numeric(VD4019>SM_2018))

dados_srvyr_2018 <- dados_srvyr_2018 %>% mutate(Seg_Urb =ifelse((V2009>=14&
                                                                   (VD4009 %in% c('01','03')&VD4010!='01'|
                                                                      VD4009 %in% c('02','04','06','08','09','10')&VD4010!='01'&VD4012=='1'|
                                                                      VD4009 %in% c('05','07'))
),1,0))


#2017

dados_srvyr_2017 <- dados_srvyr_2017 %>% mutate(Acima_SM = as.numeric(VD4019>SM_2017))

dados_srvyr_2017 <- dados_srvyr_2017 %>% mutate(Seg_Urb =ifelse((V2009>=14&
                                                                   (VD4009 %in% c('01','03')&VD4010!='01'|
                                                                      VD4009 %in% c('02','04','06','08','09','10')&VD4010!='01'&VD4012=='1'|
                                                                      VD4009 %in% c('05','07'))
),1,0))

#2016

dados_srvyr_2016 <- dados_srvyr_2016 %>% mutate(Acima_SM = as.numeric(VD4019>SM_2020))

dados_srvyr_2016 <- dados_srvyr_2016 %>% mutate(Seg_Urb =ifelse((V2009>=14&
                                                                   (VD4009 %in% c('01','03')&VD4010!='01'|
                                                                      VD4009 %in% c('02','04','06','08','09','10')&VD4010!='01'&VD4012=='1'|
                                                                      VD4009 %in% c('05','07'))
),1,0))




#Ocupado  Maior de 14 - Ocupado - Trabalha no Urbano

dados_srvyr_2020 <- dados_srvyr_2020 %>% mutate(Ocup_Urb =ifelse((V2009>=14&VD4002== '1'&VD4010 != '01'),1,0))

dados_srvyr_2019 <- dados_srvyr_2019 %>% mutate(Ocup_Urb =ifelse((V2009>=14&VD4002== '1'&VD4010 != '01'),1,0))

dados_srvyr_2018 <- dados_srvyr_2018 %>% mutate(Ocup_Urb =ifelse((V2009>=14&VD4002== '1'&VD4010 != '01'),1,0))

dados_srvyr_2017 <- dados_srvyr_2017 %>% mutate(Ocup_Urb =ifelse((V2009>=14&VD4002== '1'&VD4010 != '01'),1,0))

dados_srvyr_2016 <- dados_srvyr_2016 %>% mutate(Ocup_Urb =ifelse((V2009>=14&VD4002== '1'&VD4010 != '01'),1,0))





# Maior de 14 - Ocupado - Trabalha no Ramo Rural
dados_srvyr_2020 <- dados_srvyr_2020 %>% mutate(Ocup_Rur =ifelse((V2009>=14&VD4002=='1'&VD4010 == '01'),1,0))

dados_srvyr_2019 <- dados_srvyr_2019 %>% mutate(Ocup_Rur =ifelse((V2009>=14&VD4002=='1'&VD4010 == '01'),1,0))

dados_srvyr_2018 <- dados_srvyr_2018 %>% mutate(Ocup_Rur =ifelse((V2009>=14&VD4002=='1'&VD4010 == '01'),1,0))

dados_srvyr_2017 <- dados_srvyr_2017 %>% mutate(Ocup_Rur =ifelse((V2009>=14&VD4002=='1'&VD4010 == '01'),1,0))

dados_srvyr_2016 <- dados_srvyr_2016 %>% mutate(Ocup_Rur =ifelse((V2009>=14&VD4002=='1'&VD4010 == '01'),1,0))

# Arquivo 2020
SalMedSegUrbAcimH<-dados_srvyr_2020 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimH = survey_mean(VD4019,na.rm=T))

SalMedSegUrbAcimM<-dados_srvyr_2020 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbH<-dados_srvyr_2020 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbM<-dados_srvyr_2020 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurH<- dados_srvyr_2020 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurM<- dados_srvyr_2020 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurM = survey_mean(VD4019,na.rm=T))


arquivo_final_2020 <- dplyr::bind_cols(SalMedSegUrbAcimH,SalMedSegUrbAcimM[,2:3],SalMedPopOcupUrbH[,2:3],SalMedPopOcupUrbM[,2:3],SalMedPopOcupRurH[,2:3],SalMedPopOcupRurM[,2:3])

arquivo_final_2020 <- arquivo_final_2020 %>% mutate_if(is.numeric , replace_na, replace = 0)

arquivo_final_2020<- arquivo_final_2020 %>% dplyr::rename('idade'='V2009')

openxlsx::write.xlsx(arquivo_final_2020,'arquivo_final_2020.xlsx',sheetName = "Preços")

# Arquivo 2019
SalMedSegUrbAcimH<-dados_srvyr_2019 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimH = survey_mean(VD4019,na.rm=T))

SalMedSegUrbAcimM<-dados_srvyr_2019 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbH<-dados_srvyr_2019 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbM<-dados_srvyr_2019 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurH<- dados_srvyr_2019 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurM<- dados_srvyr_2019 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurM = survey_mean(VD4019,na.rm=T))


arquivo_final_2019 <- dplyr::bind_cols(SalMedSegUrbAcimH,SalMedSegUrbAcimM[,2:3],SalMedPopOcupUrbH[,2:3],SalMedPopOcupUrbM[,2:3],SalMedPopOcupRurH[,2:3],SalMedPopOcupRurM[,2:3])

arquivo_final_2019 <- arquivo_final_2019 %>% mutate_if(is.numeric , replace_na, replace = 0)

arquivo_final_2019<- arquivo_final_2019 %>% dplyr::rename('idade'='V2009')

openxlsx::write.xlsx(arquivo_final_2019,'arquivo_final_2019.xlsx',sheetName = "Preços")

# Arquivo 2018
SalMedSegUrbAcimH<-dados_srvyr_2018 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimH = survey_mean(VD4019,na.rm=T))

SalMedSegUrbAcimM<-dados_srvyr_2018 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbH<-dados_srvyr_2018 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbM<-dados_srvyr_2018 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurH<- dados_srvyr_2018 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurM<- dados_srvyr_2018 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurM = survey_mean(VD4019,na.rm=T))


arquivo_final_2018 <- dplyr::bind_cols(SalMedSegUrbAcimH,SalMedSegUrbAcimM[,2:3],SalMedPopOcupUrbH[,2:3],SalMedPopOcupUrbM[,2:3],SalMedPopOcupRurH[,2:3],SalMedPopOcupRurM[,2:3])

arquivo_final_2018 <- arquivo_final_2018 %>% mutate_if(is.numeric , replace_na, replace = 0)

arquivo_final_2018<- arquivo_final_2018 %>% dplyr::rename('idade'='V2009')

openxlsx::write.xlsx(arquivo_final_2018,'arquivo_final_2018.xlsx',sheetName = "Preços")

# Arquivo 2017
SalMedSegUrbAcimH<-dados_srvyr_2017 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimH = survey_mean(VD4019,na.rm=T))

SalMedSegUrbAcimM<-dados_srvyr_2017 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbH<-dados_srvyr_2017 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbM<-dados_srvyr_2017 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurH<- dados_srvyr_2017 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurM<- dados_srvyr_2017 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurM = survey_mean(VD4019,na.rm=T))


arquivo_final_2017 <- dplyr::bind_cols(SalMedSegUrbAcimH,SalMedSegUrbAcimM[,2:3],SalMedPopOcupUrbH[,2:3],SalMedPopOcupUrbM[,2:3],SalMedPopOcupRurH[,2:3],SalMedPopOcupRurM[,2:3])

arquivo_final_2017 <- arquivo_final_2017 %>% mutate_if(is.numeric , replace_na, replace = 0)

arquivo_final_2017<- arquivo_final_2017 %>% dplyr::rename('idade'='V2009')

openxlsx::write.xlsx(arquivo_final_2017,'arquivo_final_2017.xlsx',sheetName = "Preços")

# Arquivo 2016
SalMedSegUrbAcimH<-dados_srvyr_2016 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimH = survey_mean(VD4019,na.rm=T))

SalMedSegUrbAcimM<-dados_srvyr_2016 %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedSegUrbAcimM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbH<-dados_srvyr_2016 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupUrbM<-dados_srvyr_2016 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupUrbM = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurH<- dados_srvyr_2016 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='1') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurH = survey_mean(VD4019,na.rm=T))

SalMedPopOcupRurM<- dados_srvyr_2016 %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='2') %>% group_by(V2009) %>%
  summarise(SalMedPopOcupRurM = survey_mean(VD4019,na.rm=T))


arquivo_final_2016 <- dplyr::bind_cols(SalMedSegUrbAcimH,SalMedSegUrbAcimM[,2:3],SalMedPopOcupUrbH[,2:3],SalMedPopOcupUrbM[,2:3],SalMedPopOcupRurH[,2:3],SalMedPopOcupRurM[,2:3])

arquivo_final_2016 <- arquivo_final_2016 %>% mutate_if(is.numeric , replace_na, replace = 0)

arquivo_final_2016<- arquivo_final_2016 %>% dplyr::rename('idade'='V2009')

openxlsx::write.xlsx(arquivo_final_2016,'arquivo_final_2016.xlsx',sheetName = "Preços")
