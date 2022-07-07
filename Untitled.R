  library(PNADcIBGE)
  library(survey)
  library(dplyr)
  library(srvyr)
  library(ggplot2)
  library(tidyr)

  dadosPNADc <- get_pnadc(year=2021,quarter = 1,var =c(  'V1014', 'V1022', 'V1023', 'V1030', 
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
                                                         'VD5005'))
  dados_srvyr<-as_survey(dadosPNADc)
  dados_srvyr %>% group_by(V2007) %>% summarise("Rend Medio" = survey_mean(VD4020,na.rm=T))
  dados_srvyr %>% group_by(V2007) %>% summarise("Rend Medio" = survey_total())
  
  
  dados_srvyr$familia <-paste(dados_srvyr$UPA, dados_srvyr$V1008, dados_srvyr$V1014, dados_srvyr$V2003, sep="")
  
  dados_familias <- dados_srvyr %>% group_by(UPA,V1008,V1014) %>% summarise("Renda Domicilio" = survey_total(VD4020,na.rm = T))
  
  quantiles_hist = c(.1,.2,.3,.4,.5,.6,.7,.8,.9,.99)
  quant<-dados_srvyr %>% summarise(qt = survey_quantile(VD4020,quantiles = quantiles_hist,na.rm=T))
  quant_quant<-quant %>% pivot_longer(!contains('se'),names_to = "Quantiles",values_to = "Income")%>% select(Quantiles,Income)
  ggplot(quant_quant,aes(x=Quantiles,y=Income)) + stat_identity(geom ="bar")
  
  #Servidor Publico
  quantiles_hist = c(.1,.2,.3,.4,.5,.6,.7,.8,.9,.99)
  quant_public_serv<-dados_srvyr %>% filter(V4001=='Sim') %>%  summarise(qt = survey_quantile(VD4020,quantiles = 0.50,na.rm=T))
  quant_quant<-quant %>% pivot_longer(!contains('se'),names_to = "Quantiles",values_to = "Income")%>% select(Quantiles,Income)
  ggplot(quant_quant,aes(x=Quantiles,y=Income)) + stat_identity(geom ="bar")
  