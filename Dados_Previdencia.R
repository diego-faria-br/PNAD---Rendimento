  library(PNADcIBGE)
  library(survey)
  library(srvyr)
  library(tidyr)
  rm(list = ls())
  
  
SM <- 998

#Extraindo dados da PNAD
dados_srvyr<-as_survey(pnadc_design(read_pnadc("./data/PNADC_2019_visita5.txt","./data/input_PNADC_2019_visita5.txt",vars=c(
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
  
  # dados_srvyr<-get_pnadc(year = 2019, interview = 5, labels = F, vars =c(
  #   'V1022',
  #   'V2005',
  #   'V4010',
  #   'V2009',
  #   'V2007',
  #   'VD4010',
  #   'VD4012',
  #   'VD4002',
  #   'VD4019'))
  # 
  # dados_srvyr<-as_survey(dados_srvyr)
  dados_srvyr <- dados_srvyr %>% mutate(Acima_SM = as.numeric(VD4019>SM))
  
  # Segurados Especiais
  # Sem Carteira - V4029=='2
  #Atividades Agricolas - V40132A==1
  #não contribuem para a previdência social no trabalho principal  - V4032 ==2
  # possuem mais de 1 trabalho (v9005 ≠ 1)
  #no trabalho secundário, também exercem atividades agrícolas (v9991 <= 5002) e são trabalhadores por conta-própria (v9092 = 3)
  #membros da unidade familiar não remunerados (v9092 = 5) ou não remunerados de outro tipo (v9092 = 6)
  
  
  #V1022 - Situacao Domicilia: 1-Urbano, 2-Rural
  #V2005 - '01'-Pessoa responsavel pelo domicilio/02-Conjuge/03-Conjuge
  #V4010 - 6111≤V4010≤6225
  #V2009 - Idade do Morador
  #V2007 - Sexo? 1-Homem, 2-Muher
  #VD4010 - Ramo de atividade do trabalho principal
  #VD4012 - Contribuição Previdencia - 1 Contribuinte, 2- Nao contribuinte
  #VD4002 - 1 - Ocupada, 2-Desocupada 
  #VD4019 - Rendimento Mensal Habitual 
  
  # Classificação de Segurados Urbanos
  #1. Empregados com carteira e empregados dom. com carteira em atividade nao agricola (VD4009 e VD4010)
  #2. Sem carteira/Contra Propria/Empregadores por CP/Em atividada nao agricola que contribuem para previdencia
  #3 - Empregados sem carteira que nao contribuiram para a previdencia/mas que tinha outro emprego em atividade urbana
  #4 - Militares/Func Publicos Estatutarios no trabalho principal
  #5 - Empregados sem carteira com dois empregos, primeiro agricola, e que o segundo seja militar ou servidor estatutario
  #6 - Empregados sem carteira com dois empregos, primeiro agricola, e que o segundo seja militar ou servidor estatutario
  
dados_srvyr <- dados_srvyr %>% mutate(Seg_Urb =ifelse((V2009>=14&
                                                         (VD4009 %in% c('01','03')&VD4010!='01'|
                                                            VD4009 %in% c('02','04','06','08','09','10')&VD4010!='01'&VD4012=='1'|
                                                            VD4009 %in% c('05','07'))
                                                       ),1,0))
  
                                                                 
  
  
  
  
  
  
  # dados_srvyr <- dados_srvyr %>% group_by(UPA,V1008,V1014) %>%  mutate(Seg_Urb_Rural = ifelse((V2005=='01'&V4010>=6111&V4010<=6225)& V4012=='1',1,0),'R','U')
  
  
  
  #Empregado Carteira Assinada, ou Servidor ou Militar que não trabalha em atividade agrícola ou que contribua para a previdencia - Atividades Urbanas
  # dados_srvyr <- dados_srvyr %>% mutate(Seg_Urb =ifelse((V2009>=14&VD4002== '1'&VD4010 != '01')&((
                                                           # VD4009 %in% c('01','03','05','07'))|(VD4012=='1')),1,0))
  
# Maior de 14 - Ocupado - Trabalha no Urbano

dados_srvyr <- dados_srvyr %>% mutate(Ocup_Urb =ifelse((V2009>=14&VD4002== '1'&VD4010 != '01'),1,0))


# Maior de 14 - Ocupado - Trabalha no Ramo Rural
dados_srvyr <- dados_srvyr %>% mutate(Ocup_Rur =ifelse((V2009>=14&VD4002== '1'&VD4010 == '01'),1,0))

  
 
  SalMedSegUrbAcimH<-dados_srvyr %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='1') %>% group_by(V2009) %>% summarise(SalMedSegUrbAcimH = survey_mean(VD4019,na.rm=T))
  
  SalMedSegUrbAcimM<-dados_srvyr %>% mutate(V2009=as.factor(V2009)) %>% filter(Acima_SM==T,Seg_Urb==1,V2007=='2') %>% group_by(V2009) %>% summarise(SalMedSegUrbAcimM = survey_mean(VD4019,na.rm=T))
  
  SalMedPopOcupUrbH<-dados_srvyr %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='1') %>% group_by(V2009) %>% summarise(SalMedPopOcupUrbH = survey_mean(VD4019,na.rm=T))
    
  SalMedPopOcupUrbM<-dados_srvyr %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Urb==1,V2007=='2') %>% group_by(V2009) %>% summarise(SalMedPopOcupUrbM = survey_mean(VD4019,na.rm=T))
  
  SalMedPopOcupRurH<- dados_srvyr %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='1') %>% group_by(V2009) %>% summarise(SalMedPopOcupRurH = survey_mean(VD4019,na.rm=T))
  
  SalMedPopOcupRurM<- dados_srvyr %>% mutate(V2009=as.factor(V2009)) %>% filter(Ocup_Rur==1,V2007=='2') %>% group_by(V2009) %>% summarise(SalMedPopOcupRurM = survey_mean(VD4019,na.rm=T))
  
