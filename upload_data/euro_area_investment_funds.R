library(ecb)
library(plyr)
library(pdfetch)

#Aggregated balance sheet of Euro Area Investment Funds

#node names
core<-"Euro Area Investment Funds"
debt_sec<-"debt securities"
assets<-"core"
IF_shares<-"Investment fund and money market shares"
equity<-"equity"
dep<-"deposit and loan claims"
non_fin<-"non-financial assets"
rem<-"remaining"
liabilities<-assets
debt_sec_mfi<-"mfi debt sec"
debt_sec_govt<-"govt debt sec"
debt_sec_ofi<-"ofi debt sec"
debt_sec_icpf<-"icpf debt sec"
debt_sec_nfc<-"nfc debt sec"
debt_sec_euro<-"Euro Area debt sec"
debt_sec_exEuro<-"outside Euro Area debt sec"
debt_sec_euExEuro<-"EU member states outside the Euro Area debt sec"
debt_sec_US<-"United States debt sec"
debt_sec_Jap<-"Japan debt sec"
equity_exEuro<-"outside Euro Area equity"
equity_euro<-"Euro Area equity"
equity_mfi<-"mfi equity"
equity_ofi<-"ofi equity"
equity_nfc<-"nfc equity"
equity_icpf<-"icpf equity"
equity_Jap<-"Japan equity"
equity_US<-"United States equity"
equity_euExEuro<-"outside Euro Area Equity"
bf<-"bond funds"
ef<-"equity funds"
mf<-"mixed funds"
rf<-"real estate funds"
hf<-"hedge funds"
of<-"other funds"

#levels
asset_issuer_level<-0
asset_region_level<-asset_issuer_level+1
asset_group_level<-asset_region_level+1
asset_level<-asset_group_level+1
#core_level<-3
liab_level<-asset_level
liab_group_level<-liab_level+1
liab_issuer_level<-liab_group_level+1

#edge_types
eu<-"total"

#time horizon
startPeriod<-"2008-Q4"
endPeriod<-"2017-Q4"
startPeriodM<-"2008-03"
endPeriodM<-"2017-12"

#convert month to quarter
replDate<-function(data) {
  data$time<-gsub("-03","-Q1",data$time)
  data$time<-gsub("-06","-Q2",data$time)
  data$time<-gsub("-09","-Q3",data$time)
  data$time<-gsub("-12","-Q4",data$time)
  data<-data[grepl("Q",data$time),]
  return (data)  
}

#assets
debt_sec_held<-get_data("IVF.Q.U2.N.T0.A30.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held<-data.frame(debt_sec_held)
debt_sec_held<-data.frame("source"=debt_sec,"source_level"=asset_group_level, "target"=assets, "target_level"=asset_level,"edge_type"=debt_sec,"time"=debt_sec_held$obstime,
           "value"=debt_sec_held$obsvalue)

debt_sec_held_mfi<-get_data("IVF.Q.U2.N.T0.A30.A.1.U2.1000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held_mfi<-data.frame(debt_sec_held_mfi)
debt_sec_held_mfi<-data.frame("source"=debt_sec_mfi,"source_level"=asset_issuer_level, "target"=debt_sec_euro, "target_level"=asset_region_level,"edge_type"=debt_sec,"time"=debt_sec_held_mfi$obstime,
                          "value"=debt_sec_held_mfi$obsvalue)

debt_sec_held_govt<-get_data("IVF.Q.U2.N.T0.A30.A.1.U2.2100.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held_govt<-data.frame(debt_sec_held_govt)
debt_sec_held_govt<-data.frame("source"=debt_sec_govt,"source_level"=asset_issuer_level, "target"=debt_sec_euro, "target_level"=asset_region_level,"edge_type"=debt_sec,"time"=debt_sec_held_govt$obstime,
                              "value"=debt_sec_held_govt$obsvalue)

debt_sec_held_ofi<-get_data("IVF.Q.U2.N.T0.A30.A.1.U2.2210.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held_ofi<-data.frame(debt_sec_held_ofi)
debt_sec_held_ofi<-data.frame("source"=debt_sec_ofi,"source_level"=asset_issuer_level, "target"=debt_sec_euro, "target_level"=asset_region_level,"edge_type"=debt_sec,"time"=debt_sec_held_ofi$obstime,
                               "value"=debt_sec_held_ofi$obsvalue)

debt_sec_held_icpf<-get_data("IVF.Q.U2.N.T0.A30.A.1.U2.2220.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held_icpf<-data.frame(debt_sec_held_icpf)
debt_sec_held_icpf<-data.frame("source"=debt_sec_icpf,"source_level"=asset_issuer_level, "target"=debt_sec_euro, "target_level"=asset_region_level,"edge_type"=debt_sec,"time"=debt_sec_held_icpf$obstime,
                              "value"=debt_sec_held_icpf$obsvalue)

debt_sec_held_nfc<-get_data("IVF.Q.U2.N.T0.A30.A.1.U2.2240.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held_nfc<-data.frame(debt_sec_held_nfc)
debt_sec_held_nfc<-data.frame("source"=debt_sec_nfc,"source_level"=asset_issuer_level, "target"=debt_sec_euro, "target_level"=asset_region_level,"edge_type"=debt_sec,"time"=debt_sec_held_nfc$obstime,
                               "value"=debt_sec_held_nfc$obsvalue)

debt_sec_held_euroArea<-debt_sec_held_nfc
debt_sec_held_euroArea$source<-debt_sec_euro
debt_sec_held_euroArea$source_level<-asset_region_level
debt_sec_held_euroArea$target<-debt_sec
debt_sec_held_euroArea$target_level<-asset_group_level
debt_sec_held_euroArea$value<-debt_sec_held_mfi$value+debt_sec_held_govt$value+debt_sec_held_ofi$value+debt_sec_held_nfc$value+debt_sec_held_icpf$value

debt_sec_held_euExEuro<-get_data("IVF.Q.U2.N.T0.A30.A.1.U3.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held_euExEuro<-data.frame(debt_sec_held_euExEuro)
debt_sec_held_euExEuro<-data.frame("source"=debt_sec_euExEuro,"source_level"=asset_issuer_level, "target"=debt_sec_exEuro, "target_level"=asset_region_level,"edge_type"=debt_sec,"time"=debt_sec_held_euExEuro$obstime,
                              "value"=debt_sec_held_euExEuro$obsvalue)

debt_sec_held_US<-get_data("IVF.Q.U2.N.T0.A30.A.1.US.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held_US<-data.frame(debt_sec_held_US)
debt_sec_held_US<-data.frame("source"=debt_sec_US,"source_level"=asset_issuer_level, "target"=debt_sec_exEuro, "target_level"=asset_region_level,"edge_type"=debt_sec,"time"=debt_sec_held_US$obstime,
                                   "value"=debt_sec_held_US$obsvalue)

debt_sec_held_Jap<-get_data("IVF.Q.U2.N.T0.A30.A.1.JP.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_held_Jap<-data.frame(debt_sec_held_Jap)
debt_sec_held_Jap<-data.frame("source"=debt_sec_Jap,"source_level"=asset_issuer_level, "target"=debt_sec_exEuro, "target_level"=asset_region_level,"edge_type"=debt_sec,"time"=debt_sec_held_Jap$obstime,
                             "value"=debt_sec_held_Jap$obsvalue)

debt_sec_held_other<-debt_sec_held_Jap
debt_sec_held_other$source<-"other"
debt_sec_held_other$value<-debt_sec_held$value-debt_sec_held_Jap$value-debt_sec_held_US$value-debt_sec_held_euExEuro$value-debt_sec_held_icpf$value-debt_sec_held_nfc$value-debt_sec_held_ofi$value-debt_sec_held_mfi$value-debt_sec_held_govt$value

debt_sec_held_exEuroArea<-debt_sec_held_other
debt_sec_held_exEuroArea$source<-debt_sec_exEuro
debt_sec_held_exEuroArea$source_level<-asset_region_level
debt_sec_held_exEuroArea$target<-debt_sec
debt_sec_held_exEuroArea$target_level<-asset_group_level
debt_sec_held_exEuroArea$value<-debt_sec_held_US$value+debt_sec_held_Jap$value+debt_sec_held_euExEuro$value+debt_sec_held_other$value

IF_shares_held<-get_data("IVF.Q.U2.N.T0.A52.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
IF_shares_held<-data.frame(IF_shares_held)
                          IF_shares_held<-data.frame("source"=IF_shares,"source_level"=asset_group_level, "target"=assets, "target_level"=asset_level,"edge_type"=equity,"time"=IF_shares_held$obstime,
                          "value"=IF_shares_held$obsvalue)
                          
equity_held<-get_data("IVF.Q.U2.N.T0.A5A.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held<-data.frame(equity_held)
equity_held<-data.frame("source"=equity,"source_level"=asset_group_level, "target"=assets, "target_level"=asset_level,"edge_type"=eu,"time"=equity_held$obstime,
                           "value"=equity_held$obsvalue)

equity_held_mfi<-get_data("IVF.Q.U2.N.T0.A5A.A.1.U2.1000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_mfi<-data.frame(equity_held_mfi)
equity_held_mfi<-data.frame("source"=equity_mfi,"source_level"=asset_issuer_level, "target"=equity_euro, "target_level"=asset_region_level,"edge_type"=equity,"time"=equity_held_mfi$obstime,
                                   "value"=equity_held_mfi$obsvalue)

equity_held_ofi<-get_data("IVF.Q.U2.N.T0.A5A.A.1.U2.2210.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_ofi<-data.frame(equity_held_ofi)
equity_held_ofi<-data.frame("source"=equity_ofi,"source_level"=asset_issuer_level, "target"=equity_euro, "target_level"=asset_region_level,"edge_type"=equity,"time"=equity_held_ofi$obstime,
                            "value"=equity_held_ofi$obsvalue)

equity_held_nfc<-get_data("IVF.Q.U2.N.T0.A50.A.1.U2.2240.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_nfc<-data.frame(equity_held_nfc)
equity_held_nfc<-data.frame("source"=equity_nfc,"source_level"=asset_issuer_level, "target"=equity_euro, "target_level"=asset_region_level,"edge_type"=eu,"time"=equity_held_nfc$obstime,
                            "value"=equity_held_nfc$obsvalue)

equity_held_icpf<-get_data("IVF.Q.U2.N.T0.A50.A.1.U2.2220.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_icpf<-data.frame(equity_held_icpf)
equity_held_icpf<-data.frame("source"=equity_icpf,"source_level"=asset_issuer_level, "target"=equity_euro, "target_level"=asset_region_level,"edge_type"=eu,"time"=equity_held_icpf$obstime,
                            "value"=equity_held_icpf$obsvalue)


equity_held_euroArea<-get_data("IVF.Q.U2.N.T0.A5A.A.1.U2.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_euroArea<-data.frame(equity_held_euroArea)
equity_held_euroArea<-data.frame("source"=equity_euro,"source_level"=asset_region_level, "target"=equity, "target_level"=asset_group_level,"edge_type"=equity,"time"=equity_held_euroArea$obstime,
                            "value"=equity_held_euroArea$obsvalue)

equity_held_Jap<-get_data("IVF.Q.U2.N.T0.A5A.A.1.JP.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_Jap<-data.frame(equity_held_Jap)
equity_held_Jap<-data.frame("source"=equity_Jap,"source_level"=asset_issuer_level, "target"=equity_exEuro, "target_level"=asset_region_level,"edge_type"=equity,"time"=equity_held_Jap$obstime,
                                   "value"=equity_held_Jap$obsvalue)

equity_held_euExEuroArea<-get_data("IVF.Q.U2.N.T0.A5A.A.1.U3.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_euExEuroArea<-data.frame(equity_held_euExEuroArea)
equity_held_euExEuroArea<-data.frame("source"=equity_euExEuro,"source_level"=asset_issuer_level, "target"=equity_exEuro, "target_level"=asset_region_level,"edge_type"=equity,"time"=equity_held_euExEuroArea$obstime,
                            "value"=equity_held_euExEuroArea$obsvalue)

equity_held_US<-get_data("IVF.Q.U2.N.T0.A5A.A.1.US.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_US<-data.frame(equity_held_US)
equity_held_US<-data.frame("source"=equity_US,"source_level"=asset_issuer_level, "target"=equity_exEuro, "target_level"=asset_region_level,"edge_type"=equity,"time"=equity_held_US$obstime,
                                     "value"=equity_held_US$obsvalue)

equity_held_exEuroArea<-get_data("IVF.Q.U2.N.T0.A5A.A.1.U4.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
equity_held_exEuroArea<-data.frame(equity_held_exEuroArea)
equity_held_exEuroArea<-data.frame("source"=equity_exEuro,"source_level"=asset_region_level, "target"=equity, "target_level"=asset_group_level,"edge_type"=equity,"time"=equity_held_exEuroArea$obstime,
                        "value"=equity_held_exEuroArea$obsvalue)

equity_held_other<-equity_held_US
equity_held_other$source<-rem
equity_held_other$value<-equity_held_exEuroArea$value-equity_held_US$value-equity_held_euExEuroArea$value-equity_held_Jap$value

dep_held<-get_data("IVF.Q.U2.N.T0.A20.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
dep_held<-data.frame(dep_held)
dep_held<-data.frame("source"=dep,"source_level"=asset_group_level, "target"=assets, "target_level"=asset_level,"edge_type"=dep,"time"=dep_held$obstime,
                        "value"=dep_held$obsvalue)

non_fin_held<-get_data("IVF.Q.U2.N.T0.A60.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
non_fin_held<-data.frame(non_fin_held)
non_fin_held<-data.frame("source"=non_fin,"source_level"=asset_group_level, "target"=assets, "target_level"=asset_level,"edge_type"=non_fin,"time"=non_fin_held$obstime,
                     "value"=non_fin_held$obsvalue)

rem_held<-get_data("IVF.Q.U2.N.T0.AT1.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
rem_held<-data.frame(rem_held)
rem_held<-data.frame("source"=rem,"source_level"=asset_group_level, "target"=assets, "target_level"=asset_level,"edge_type"=rem,"time"=rem_held$obstime,
                         "value"=rem_held$obsvalue)

total_held<-rem_held
total_held$edge_type<-assets
total_held$source<-assets
total_held$source_level<-asset_level
total_held$target<-core
total_held$target_level<-core_level
total_held$value<-debt_sec_held$value+IF_shares_held$value+equity_held$value+dep_held$value+non_fin_held$value+rem_held$value

#liabilities
dep_rec<-get_data("IVF.Q.U2.N.T0.L20.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
dep_rec<-data.frame(dep_rec)
dep_rec<-data.frame("source"=liabilities,"source_level"=liab_level, "target"=dep, "target_level"=liab_group_level,"edge_type"=dep,"time"=dep_rec$obstime,
                          "value"=dep_rec$obsvalue)

IF_shares_issued<-get_data("IVF.Q.U2.N.T0.L30.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
IF_shares_issued<-data.frame(IF_shares_issued)
IF_shares_issued<-data.frame("source"=liabilities,"source_level"=liab_level, "target"=IF_shares, "target_level"=liab_group_level,"edge_type"=equity,"time"=IF_shares_issued$obstime,
                    "value"=IF_shares_issued$obsvalue)

bf_issued<-get_data("IVF.M.U2.N.20.L30.A.1.Z5.0000.Z01.E",filter=list(startPeriodM=startPeriod,endPeriodM=endPeriod))
bf_issued<-data.frame(bf_issued)
bf_issued<-data.frame("source"=IF_shares,"source_level"=liab_group_level, "target"=bf, "target_level"=liab_issuer_level,"edge_type"=equity,"time"=bf_issued$obstime,
                             "value"=bf_issued$obsvalue)
bf_issued<-replDate(bf_issued)

ef_issued<-get_data("IVF.M.U2.N.10.L30.A.1.Z5.0000.Z01.E",filter=list(startPeriodM=startPeriod,endPeriodM=endPeriod))
ef_issued<-data.frame(ef_issued)
ef_issued<-data.frame("source"=IF_shares,"source_level"=liab_group_level, "target"=ef, "target_level"=liab_issuer_level,"edge_type"=equity,"time"=ef_issued$obstime,
                      "value"=ef_issued$obsvalue)
ef_issued<-replDate(ef_issued)

mf_issued<-get_data("IVF.M.U2.N.30.L30.A.1.Z5.0000.Z01.E",filter=list(startPeriodM=startPeriod,endPeriodM=endPeriod))
mf_issued<-data.frame(mf_issued)
mf_issued<-data.frame("source"=IF_shares,"source_level"=liab_group_level, "target"=mf, "target_level"=liab_issuer_level,"edge_type"=equity,"time"=mf_issued$obstime,
                      "value"=mf_issued$obsvalue)
mf_issued<-replDate(mf_issued)

rf_issued<-get_data("IVF.M.U2.N.40.L30.A.1.Z5.0000.Z01.E",filter=list(startPeriodM=startPeriod,endPeriodM=endPeriod))
rf_issued<-data.frame(rf_issued)
rf_issued<-data.frame("source"=IF_shares,"source_level"=liab_group_level, "target"=rf, "target_level"=liab_issuer_level,"edge_type"=equity,"time"=rf_issued$obstime,
                      "value"=rf_issued$obsvalue)
rf_issued<-replDate(rf_issued)

hf_issued<-get_data("IVF.M.U2.N.50.L30.A.1.Z5.0000.Z01.E",filter=list(startPeriodM=startPeriod,endPeriodM=endPeriod))
hf_issued<-data.frame(hf_issued)
hf_issued<-data.frame("source"=IF_shares,"source_level"=liab_group_level, "target"=hf, "target_level"=liab_issuer_level,"edge_type"=equity,"time"=hf_issued$obstime,
                      "value"=hf_issued$obsvalue)
hf_issued<-replDate(hf_issued)

of_issued<-get_data("IVF.M.U2.N.60.L30.A.1.Z5.0000.Z01.E",filter=list(startPeriodM=startPeriod,endPeriodM=endPeriod))
of_issued<-data.frame(of_issued)
of_issued<-data.frame("source"=IF_shares,"source_level"=liab_group_level, "target"=of, "target_level"=liab_issuer_level,"edge_type"=equity,"time"=of_issued$obstime,
                      "value"=of_issued$obsvalue)
of_issued<-replDate(of_issued)

rem_liab<-get_data("IVF.Q.U2.N.T0.LT1.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
rem_liab<-data.frame(rem_liab)
rem_liab<-data.frame("source"=liabilities,"source_level"=liab_level, "target"=rem, "target_level"=liab_group_level,"edge_type"=rem,"time"=rem_liab$obstime,
                             "value"=rem_liab$obsvalue)

total_liab<-rem_liab
total_liab$edge_type<-liabilities
total_liab$source<-core
total_liab$source_level<-core_level
total_liab$target<-liabilities
total_liab$target_level<-liab_level
total_liab$value<-dep_rec$value+IF_shares_issued$value+rem_liab$value

links<-rbind(debt_sec_held,equity_held,debt_sec_held_mfi,debt_sec_held_govt,debt_sec_held_ofi,debt_sec_held_icpf,debt_sec_held_nfc,
             debt_sec_held_euExEuro,debt_sec_held_US,debt_sec_held_Jap,debt_sec_held_other,debt_sec_held_euroArea,debt_sec_held_exEuroArea,
             equity_held_euroArea,equity_held_exEuroArea,equity_held_euExEuroArea,equity_held_Jap,equity_held_US,equity_held_mfi,equity_held_ofi,
             bf_issued,ef_issued,mf_issued,rf_issued,hf_issued,of_issued,equity_held_icpf,equity_held_nfc,equity_held_other,IF_shares_held,dep_held,non_fin_held,rem_held,dep_rec,IF_shares_issued,
             rem_liab)
links$value<-links$value/1000

file<-paste("ea_iv_bs.csv",sep="")
write.csv(links,file)
