  library(PNADcIBGE)
  library(survey)
  library(dplyr)
  library(srvyr)
  library(ggplot2)
  library(tidyr)

  dadosPNADc_df<- get_pnadc(year=2021,quarter = 1,var =c(  'V1014', 'V1022', 'V1023', 'V1030', 
                                                         'V1031', 'V1032', 'POSEST', 'V2001', 
                                                         'V2003', 'V2005', 'V2007', 'V2008', 
                                                         'V20081', 'V20082', 'V2009', 'V2010', 
                                                         'V3001', 'V3002', 'V3009A', 'V3014',
                                                         'V4012', 'V4019', 'V4029', 'V4048',
                                                         'VD2002', 'VD2003', 'VD2004', 'VD3001', 
                                                         'VD3002', 'VD4001', 'VD4002', 'VD4003', 
                                                         'VD4004A', 'VD4005', 'VD4007', 'VD4008', 
                                                         'VD4009', 'VD4010', 'VD4011', 'VD4012', 
                                                         'VD4013', 'VD4014', 'VD4015', 'VD4016', 
                                                         'VD4017', 'VD4018', 'VD4019', 'VD4020', 
                                                         'VD4031', 'VD4035', 'VD4036', 'VD4037',
                                                         'VD5005'),design = FALSE)
  dados_srvyr<-as_survey(dadosPNADc)

  
  
  # BPC absoluta  = quantis
  
  # BPC relativa  aos quantis
  
  # Cria coluna com renda per-capita
  dados_familias <- dados_srvyr %>% 
    group_by(UPA,V1008,V1014) %>%
    mutate(soma_familia = sum(VD4020,na.rm = T)) %>%
    ungroup() %>% mutate(per_capita_familia = soma_familia/V2001)
  
  
  a <- svyquantile(~per_capita_familia, design = dados_familias, quantiles = seq(0, 1, by=0.1), method = "linear", ties="rounded")
  
  quantiles<-dados_familias %>% summarise(qt = survey_quantile(per_capita_familia,quantiles =seq(0, 1, by=0.1),na.rm=T)) %>% pivot_longer(!contains('se'),names_to = "Quantiles",values_to = "Income" )%>% select(Quantiles,Income)
  
  # use factor() and findInterval()
  dados_familias_quant <- update( dados_familias, qtile = factor(findInterval(per_capita_familia ,quantiles$Income)))
  dados_familias_salaries <- update(dados_familias, salaries_unity = factor(findInterval(per_capita_familia ,seq(0,5000,1))))
  
  
  dados_familias_quant %>% group_by(qtile) %>% summarise(n = survey_total()) %>% ungroup() %>%  mutate(Pop = sum(n), ) 
  
  # distribution
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
  