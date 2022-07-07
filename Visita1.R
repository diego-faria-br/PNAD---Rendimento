  library(PNADcIBGE)
  library(survey)
  library(dplyr)
  library(srvyr)
  library(ggplot2)
  library(tidyr)
  rm(list = ls())
  
  
  SM <- 998
  
  #Extraindo dados da PNAD
  dadosPNADc_df<- get_pnadc(year=2019,interview = 1)
  
  #Transformando em modelo manipulavel usando dplyr
  dados_srvyr<-as_survey(dadosPNADc_df)
  
  # Quantis de renda per-capita
  a <- svyquantile(~VD5011, design = dados_srvyr, quantiles = seq(0, 1, by=0.25), method = "linear", ties="rounded")
  quantiles<-dados_srvyr %>%
    summarise(qt = survey_quantile(VD5011,quantiles =seq(.1, .9, by=.1),na.rm=T)) %>%
    pivot_longer(!contains('se'),names_to = "Quantiles",values_to = "Income" )%>%
    select(Quantiles,Income)
  dev.off()
  ggplot(quantiles,aes(x=Quantiles,y=Income)) + stat_identity(geom ="bar")
  
  
  
  # use factor() and findInterval()
  dados_familias_quant <- update( dados_srvyr, qtile = factor(findInterval(VD5011,quantiles$Income)))
  dados_familias_quant %>% group_by(qtile) %>% summarise(n = survey_total()) %>% ungroup() %>%  mutate(Pop = sum(n), prop =n/Pop) 
  
  
  #BPC e Aponsetado - Dentro de Cada Quantil
  dados_familias_BPC_Aposentado <- dados_familias_quant %>% mutate(V5001A = as.character(V5001A),V5002A= as.character(V5002A),V5004A = as.character(V5004A)) %>% group_by(UPA,V1008,V1014) %>%
    mutate(tem_bpc = as.integer(any(V5001A=="Sim",na.rm = T)),tem_bf = as.integer(any(V5002A=="Sim",na.rm = T)),tem_apos = as.integer(any(V5004A=="Sim",na.rm = T))) %>% ungroup()
  
  #Bolsa Família - Relativos aos quantis
  tab_bf<- dados_familias_BPC_Aposentado %>% group_by(qtile,tem_bf) %>% summarise(n = survey_total()) %>% mutate(Pop = sum(n), prop =n/Pop)
  tab_bf %>% glimpse()
  
  #BPC - Relativos aos quantis
  tab_bpc<- dados_familias_BPC_Aposentado %>% group_by(tem_bpc,qtile) %>% summarise(n = survey_total()) %>% mutate(Pop = sum(n), prop =n/Pop)
  tab_bpc %>% glimpse()
  
  #Aposentado - Relativos aos quantis
  tab_apos<- dados_familias_BPC_Aposentado %>% group_by(qtile,tem_apos) %>% summarise(n = survey_total()) %>% mutate(Pop = sum(n), prop =n/Pop)
  tab_apos %>% glimpse()
  
  # Distribution
  svytotal(~ qtile , dados_familias_quant)
  
  # Histograma com renda per-capita

  svyhist(~per_capita_familia, dados_familias,xlim = c(0,5000),breaks =300,probability = F )
  
  
  # Histograma com renda individual
  
  svyhist(~VD4020, dados_familias,xlim = c(0,50000),breaks =200)
  svyhist(~VD4020, dados_familias,xlim = c(0,50000),breaks =300,probability = F )
  
  
  # Quantis the renda per-capita for família
  
  quantiles_hist = seq(0,1,.33)
  quant<-dados_familias %>% summarise(qt = survey_quantile(per_capita_familia,quantiles = quantiles_hist,na.rm=T), n_pessoas = survey_count())  %>% pivot_longer(!contains('se'),names_to = "Quantiles",values_to = "Income")%>% select(Quantiles,Income)
  ggplot(quant_quant,aes(x=Quantiles,y=Income)) + stat_identity(geom ="bar")
  quant<-quant %>% mutate(sm = Income/1100)
  quant  
  
  
  
  # Cria coluna para pessoas com empregado público na família
  # Variável VD4008 
  dados_familias<- dados_familias %>% 
  mutate(VD4008 = as.character(VD4008)) %>%
  group_by(UPA,V1008,V1014) %>%
  mutate(tem_serv_pub = as.integer(any(VD4008=="Empregado no setor público (inclusive servidor estatutário e militar)",na.rm = T))) %>% ungroup()
  
  
  # Variável VD4008 
  dados_familias<- dados_familias %>% 
    mutate(V2007 = as.character(V2007),VD4008 = as.character(VD4008)) %>%
    group_by(UPA,V1008,V1014) %>%
    mutate(tem_serv_pub = as.integer(any(VD4008=="Empregado no setor público (inclusive servidor estatutário e militar)",na.rm = T))) %>% ungroup()
  
  # Tables
  ag <- dados_familias %>% 
    group_by(VD4008) %>% 
    survey_tally() %>% 
    mutate(proportion = n / sum(n), 
           n_total = sum(n))
  
  # Variável VD4008 
  quantiles_hist = c(.1,.2,.3,.4,.5,.6,.7,.8,.9,.99)
  quant<-dados_familias %>% filter(tem_serv_pub==0) %>%  summarise(qt = survey_quantile(per_capita_familia,quantiles = quantiles_hist,na.rm=T)) %>% pivot_longer(!contains('se'),names_to = "Quantiles",values_to = "Income" )%>% select(Quantiles,Income)
  ggplot(quant,aes(x=Quantiles,y=Income)) + stat_identity(geom ="bar")
  
  

  
  
  quantiles_hist = c(.1,.2,.3,.4,.5,.6,.7,.8,.9,.99)
  quant<-dados_familias %>% summarise(qt = survey_quantile(per_capita_familia,quantiles = quantiles_hist,na.rm=T))
  quant_quant<-quant %>% pivot_longer(!contains('se'),names_to = "Quantiles",values_to = "Income")%>% select(Quantiles,Income)
  ggplot(quant_quant,aes(x=Quantiles,y=Income)) + stat_identity(geom ="bar")
  
  
  
dados_familias %>% summarise(valor = survey_mean(per_capita_familia,na.rm=T))  
  
  #Histograna
  
  
  svyhist(~per_capita_familia,dados_familias)
  
  
  quantiles_hist = c(.1,.2,.3,.4,.5,.6,.7,.8,.9,.99)
  quant_public_serv<-dados_srvyr %>% filter(V4001=='Sim') %>%  summarise(qt = survey_quantile(VD4020,quantiles = 0.50,na.rm=T))
  quant_quant<-quant %>% pivot_longer(!contains('se'),names_to = "Quantiles",values_to = "Income")%>% select(Quantiles,Income)
  ggplot(quant_quant,aes(x=Quantiles,y=Income)) + stat_identity(geom ="bar")
  