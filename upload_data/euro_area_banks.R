library(ecb)
library(plyr)
library(tidyr)
library(pdfetch)
library(dplyr)
#for dropping levels
library(gdata)

#########utility functions#########
sector <- function(input) {
  if (input=="mfi") return ("Banks")
  else if (input == "ofi" || input == "iv" || input == "icpf") return ("Non-banks")
  else if (input == "govt" || input == "hh" || input == "nfc") return ("Real economy")
  else return ("row")
}

toFrame <- function(input){
  #process the name
  str <- deparse(substitute(input))  
  strArr <- unlist(strsplit(str, "[_]"))
  #process the data
  input<-data.frame(input)
  input<-data.frame("source"=strArr[1],"target"=strArr[2],"type"=strArr[3],"time"=input$obstime,"value"=input$obsvalue)
  return (input)
}

toFrame2 <- function(input){
  #process the name
  str <- deparse(substitute(input))  
  strArr <- unlist(strsplit(str, "[_]"))
  #process the data
  input<-data.frame(input)
  input<-data.frame("Node"=strArr[1],"Sector"=sector(strArr[1]),"time"=input$obstime,"value"=input$obsvalue)
  return (input)
}

formatDate <- function(input) {
  yearQuarter<-unlist(strsplit(toString(input), "[-]"))
  quarter<-NULL
  if (yearQuarter[2]=="Q1") {
    yearQuarter[2]<-"03"
  }
  else if (yearQuarter[2]=="Q2") {
    yearQuarter[2]<-"06"
  }
  else if (yearQuarter[2]=="Q3") {
    yearQuarter[2]<-"09"
  }
  else if (yearQuarter[2]=="Q4") {
    yearQuarter[2]<-"12"
  }
  date<-paste(yearQuarter[1],yearQuarter[2],sep="")
  return (date)
}
#########data#########
#time horizon
startPeriod<-"2013-Q4"
endPeriod<-"2017-Q4"


###non mmf investment funds
##bonds
#st

iv_mfi_debtSt<-get_data("QSA.Q.N.I8.W2.S124.S12K.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

iv_mfi_debtLt<-get_data("QSA.Q.N.I8.W2.S124.S12K.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

iv_mfi_shares<-get_data("QSA.Q.N.I8.W2.S124.S12K.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

iv_mfi_ivShares<-get_data("QSA.Q.N.I8.W2.S124.S12K.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

ofi_mfi_debtSt<-get_data("QSA.Q.N.I8.W2.S12O.S12K.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

ofi_mfi_debtLt<-get_data("QSA.Q.N.I8.W2.S12O.S12K.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))


ofi_mfi_shares<-get_data("QSA.Q.N.I8.W2.S12O.S12K.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

ofi_mfi_ivShares<-get_data("QSA.Q.N.I8.W2.S12O.S12K.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))


nfc_mfi_debtSt<-get_data("QSA.Q.N.I8.W2.S11.S12K.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

nfc_mfi_debtLt<-get_data("QSA.Q.N.I8.W2.S11.S12K.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))


nfc_mfi_shares<-get_data("QSA.Q.N.I8.W2.S11.S12K.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

nfc_mfi_ivShares<-get_data("QSA.Q.N.I8.W2.S11.S12K.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))


mfi_nfc_debtSt<-get_data("QSA.Q.N.I8.W2.S12K.S11.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_iv_debtSt<-get_data("QSA.Q.N.I8.W2.S12K.S124.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_mfi_debtSt<-get_data("QSA.Q.N.I8.W2.S12K.S12K.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_ofi_debtSt<-get_data("QSA.Q.N.I8.W2.S12K.S12O.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_icpf_debtSt<-get_data("QSA.Q.N.I8.W2.S12K.S12Q.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_govt_debtSt<-get_data("QSA.Q.N.I8.W2.S12K.S13.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_hh_debtSt<-get_data("QSA.Q.N.I8.W2.S12K.S1M.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

#lt
mfi_nfc_debtLt<-get_data("QSA.Q.N.I8.W2.S12K.S11.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_iv_debtLt<-get_data("QSA.Q.N.I8.W2.S12K.S124.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_mfi_debtLt<-get_data("QSA.Q.N.I8.W2.S12K.S12K.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_ofi_debtLt<-get_data("QSA.Q.N.I8.W2.S12K.S12O.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_icpf_debtLt<-get_data("QSA.Q.N.I8.W2.S12K.S12Q.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_govt_debtLt<-get_data("QSA.Q.N.I8.W2.S12K.S13.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_hh_debtLt<-get_data("QSA.Q.N.I8.W2.S12K.S1M.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

##loans
#st
mfi_nfc_loanSt<-get_data("QSA.Q.N.I8.W2.S12K.S11.N.A.LE.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_iv_loanSt<-get_data("QSA.Q.N.I8.W2.S12K.S124.N.A.LE.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_ofi_loanSt<-get_data("QSA.Q.N.I8.W2.S12K.S12O.N.A.LE.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_icpf_loanSt<-get_data("QSA.Q.N.I8.W2.S12K.S12Q.N.A.LE.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_govt_loanSt<-get_data("QSA.Q.N.I8.W2.S12K.S13.N.A.LE.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_hh_loanSt<-get_data("QSA.Q.N.I8.W2.S12K.S1M.N.A.LE.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

#lt
mfi_nfc_loanLt<-get_data("QSA.Q.N.I8.W2.S12K.S11.N.A.LE.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_iv_loanLt<-get_data("QSA.Q.N.I8.W2.S12K.S124.N.A.LE.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_ofi_loanLt<-get_data("QSA.Q.N.I8.W2.S12K.S12O.N.A.LE.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_icpf_loanLt<-get_data("QSA.Q.N.I8.W2.S12K.S12Q.N.A.LE.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_govt_loanLt<-get_data("QSA.Q.N.I8.W2.S12K.S13.N.A.LE.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_hh_loanLt<-get_data("QSA.Q.N.I8.W2.S12K.S1M.N.A.LE.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

##shares
mfi_nfc_shares<-get_data("QSA.Q.N.I8.W2.S12K.S11.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_iv_shares<-get_data("QSA.Q.N.I8.W2.S12K.S124.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_mfi_shares<-get_data("QSA.Q.N.I8.W2.S12K.S12K.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_ofi_shares<-get_data("QSA.Q.N.I8.W2.S12K.S12O.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_icpf_shares<-get_data("QSA.Q.N.I8.W2.S12K.S12Q.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_govt_shares<-get_data("QSA.Q.N.I8.W2.S12K.S13.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

##iv_shares
mfi_iv_ivShares<-get_data("QSA.Q.N.I8.W2.S12K.S124.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_mfi_ivShares<-get_data("QSA.Q.N.I8.W2.S12K.S12K.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
icpf_mfi_ivShares<-get_data("QSA.Q.N.I8.W2.S12Q.S12K.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

###icpf
##bonds
#st

icpf_mfi_debtSt<-get_data("QSA.Q.N.I8.W2.S12Q.S12K.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

icpf_mfi_debtLt<-get_data("QSA.Q.N.I8.W2.S12Q.S12K.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

icpf_mfi_shares<-get_data("QSA.Q.N.I8.W2.S12Q.S12K.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

govt_mfi_debtSt<-get_data("QSA.Q.N.I8.W2.S13.S12K.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

govt_mfi_debtLt<-get_data("QSA.Q.N.I8.W2.S13.S12K.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

govt_mfi_shares<-get_data("QSA.Q.N.I8.W2.S13.S12K.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

govt_mfi_ivShares<-get_data("QSA.Q.N.I8.W2.S13.S12K.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))


hh_mfi_debtSt<-get_data("QSA.Q.N.I8.W2.S1M.S12K.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

hh_mfi_debtLt<-get_data("QSA.Q.N.I8.W2.S1M.S12K.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))



hh_mfi_shares<-get_data("QSA.Q.N.I8.W2.S1M.S12K.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

hh_mfi_ivShares<-get_data("QSA.Q.N.I8.W2.S1M.S12K.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

#deposits
nfc_mfi_deposits<-get_data("QSA.Q.N.I8.W2.S12K.S11.N.L.LE.F2M.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_mfi_deposits<-get_data("QSA.Q.N.I8.W2.S12K.S124.N.L.LE.F2M.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
ofi_mfi_deposits<-get_data("QSA.Q.N.I8.W2.S12K.S12O.N.L.LE.F2M.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
icpf_mfi_deposits<-get_data("QSA.Q.N.I8.W2.S12K.S12Q.N.L.LE.F2M.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
govt_mfi_deposits<-get_data("QSA.Q.N.I8.W2.S12K.S13.N.L.LE.F2M.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
hh_mfi_deposits<-get_data("QSA.Q.N.I8.W2.S12K.S1M.N.L.LE.F2M.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))


mfi_row_debtSt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
row_mfi_debtSt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.LE.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

mfi_row_debtLt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
row_mfi_debtLt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.LE.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

mfi_row_loanSt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.LE.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
#row_mfi_loanSt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.LE.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

mfi_row_loanLt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.LE.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
row_mfi_loanLt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.LE.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

mfi_row_shares<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
row_mfi_shares<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.LE.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

mfi_row_ivShares<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
row_mfi_ivShares<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.LE.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))

row_mfi_deposits<-get_data("QSA.Q.N.I8.W1.S12K.S1.N.L.LE.F2M.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_row_debtSt$obsvalue<-mfi_row_debtSt$obsvalue-mfi_govt_debtSt$obsvalue-mfi_hh_debtSt$obsvalue-mfi_iv_debtSt$obsvalue-mfi_mfi_debtSt$obsvalue-mfi_icpf_debtSt$obsvalue-mfi_ofi_debtSt$obsvalue-mfi_nfc_debtSt$obsvalue
row_mfi_debtSt$obsvalue<-row_mfi_debtSt$obsvalue-govt_mfi_debtSt$obsvalue-hh_mfi_debtSt$obsvalue-iv_mfi_debtSt$obsvalue-mfi_mfi_debtSt$obsvalue-icpf_mfi_debtSt$obsvalue-ofi_mfi_debtSt$obsvalue-nfc_mfi_debtSt$obsvalue


mfi_row_debtLt$obsvalue<-mfi_row_debtLt$obsvalue-mfi_govt_debtLt$obsvalue-mfi_hh_debtLt$obsvalue-mfi_iv_debtLt$obsvalue-mfi_mfi_debtLt$obsvalue-mfi_icpf_debtLt$obsvalue-mfi_ofi_debtLt$obsvalue-mfi_nfc_debtLt$obsvalue
row_mfi_debtLt$obsvalue<-row_mfi_debtLt$obsvalue-govt_mfi_debtLt$obsvalue-hh_mfi_debtLt$obsvalue-iv_mfi_debtLt$obsvalue-mfi_mfi_debtLt$obsvalue-icpf_mfi_debtLt$obsvalue-ofi_mfi_debtLt$obsvalue-nfc_mfi_debtLt$obsvalue


mfi_row_loanSt$obsvalue<-mfi_row_loanSt$obsvalue-mfi_govt_loanSt$obsvalue-mfi_hh_loanSt$obsvalue-mfi_iv_loanSt$obsvalue-mfi_icpf_loanSt$obsvalue-mfi_ofi_loanSt$obsvalue-mfi_nfc_loanSt$obsvalue
#row_mfi_loanSt$obsvalue<-row_mfi_loanSt$obsvalue-hh_mfi_loanSt$obsvalue-iv_mfi_loanSt$obsvalue-mfi_mfi_loanSt$obsvalue-icpf_mfi_loanSt$obsvalue-ofi_mfi_loanSt$obsvalue-nfc_mfi_loanSt$obsvalue


mfi_row_loanLt$obsvalue<-mfi_row_loanLt$obsvalue-mfi_govt_loanLt$obsvalue-mfi_hh_loanLt$obsvalue-mfi_iv_loanLt$obsvalue-mfi_icpf_loanLt$obsvalue-mfi_ofi_loanLt$obsvalue-mfi_nfc_loanLt$obsvalue

mfi_row_shares$obsvalue<-mfi_row_shares$obsvalue-mfi_govt_shares$obsvalue-mfi_iv_shares$obsvalue-mfi_mfi_shares$obsvalue-mfi_icpf_shares$obsvalue-mfi_ofi_shares$obsvalue-mfi_nfc_shares$obsvalue
row_mfi_shares$obsvalue<-row_mfi_shares$obsvalue-govt_mfi_shares$obsvalue-hh_mfi_shares$obsvalue-iv_mfi_shares$obsvalue-mfi_mfi_shares$obsvalue-icpf_mfi_shares$obsvalue-ofi_mfi_shares$obsvalue-nfc_mfi_shares$obsvalue

mfi_row_ivShares$obsvalue<-mfi_row_ivShares$obsvalue-mfi_iv_ivShares$obsvalue
row_mfi_ivShares$obsvalue<-row_mfi_ivShares$obsvalue-govt_mfi_ivShares$obsvalue-iv_mfi_ivShares$obsvalue-icpf_mfi_ivShares$obsvalue-ofi_mfi_ivShares$obsvalue-nfc_mfi_ivShares$obsvalue-hh_mfi_ivShares$obsvalue


#mfi_assets<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.LE.F._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
#mfi_liabilities<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.LE.F._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))


matrixData<-rbind(toFrame(row_mfi_deposits),toFrame(nfc_mfi_deposits),toFrame(iv_mfi_deposits),toFrame(ofi_mfi_deposits),toFrame(icpf_mfi_deposits),toFrame(govt_mfi_deposits),toFrame(hh_mfi_deposits),toFrame(iv_mfi_debtSt),toFrame(iv_mfi_debtLt),toFrame(iv_mfi_shares),toFrame(iv_mfi_ivShares),toFrame(ofi_mfi_debtSt),toFrame(ofi_mfi_debtLt),toFrame(ofi_mfi_shares),toFrame(ofi_mfi_ivShares),
                  toFrame(nfc_mfi_debtSt),toFrame(nfc_mfi_debtLt),toFrame(nfc_mfi_shares),toFrame(nfc_mfi_ivShares),toFrame(mfi_ofi_debtSt),toFrame(mfi_icpf_debtSt),toFrame(mfi_govt_debtSt),toFrame(mfi_hh_debtSt),
                  toFrame(mfi_nfc_debtLt),toFrame(mfi_iv_debtLt),toFrame(mfi_ofi_debtLt),toFrame(mfi_icpf_debtLt),toFrame(mfi_govt_debtLt),toFrame(mfi_hh_debtLt),
                  toFrame(mfi_nfc_loanSt),toFrame(mfi_iv_loanSt),toFrame(mfi_ofi_loanSt),toFrame(mfi_icpf_loanSt),toFrame(mfi_govt_loanSt),toFrame(mfi_hh_loanSt),
                  toFrame(mfi_nfc_loanLt),toFrame(mfi_iv_loanLt),toFrame(mfi_ofi_loanLt),toFrame(mfi_icpf_loanLt),toFrame(mfi_govt_loanLt),toFrame(mfi_hh_loanLt),
                  toFrame(mfi_nfc_shares),toFrame(mfi_iv_shares),toFrame(mfi_ofi_shares),toFrame(mfi_icpf_shares),toFrame(mfi_govt_shares),
                  toFrame(mfi_iv_ivShares),
                  toFrame(icpf_mfi_debtSt),toFrame(icpf_mfi_debtLt),toFrame(icpf_mfi_shares),toFrame(icpf_mfi_ivShares),
                  toFrame(govt_mfi_debtSt),toFrame(govt_mfi_debtLt),toFrame(govt_mfi_shares),toFrame(govt_mfi_ivShares),toFrame(hh_mfi_debtSt),toFrame(hh_mfi_debtLt),toFrame(hh_mfi_shares),toFrame(hh_mfi_ivShares),
                  toFrame(mfi_row_debtSt),toFrame(mfi_row_debtLt),toFrame(mfi_row_ivShares),toFrame(mfi_row_loanLt),toFrame(mfi_row_loanSt),toFrame(mfi_row_shares),
                  toFrame(row_mfi_debtSt),toFrame(row_mfi_debtLt),toFrame(row_mfi_loanLt),toFrame(row_mfi_shares),toFrame(row_mfi_ivShares)
)

matrixData$type<-as.character(matrixData$type)
matrixData$source<-as.character(matrixData$source)
matrixData$target<-as.character(matrixData$target)
matrixData$time<-as.character(matrixData$time)
matrixData$maturity<-"null"
matrixData[which(matrixData$type=="debtSt"),"maturity"]<-"debtSt"
matrixData[which(matrixData$type=="debtLt"),"maturity"]<-"debtLt"
matrixData[which(matrixData$type=="loanSt"),"maturity"]<-"loanSt"
matrixData[which(matrixData$type=="loanLt"),"maturity"]<-"loanLt"
matrixData[which(matrixData$type=="debtSt"),"type"]<-"debt"
matrixData[which(matrixData$type=="debtLt"),"type"]<-"debt"
matrixData[which(matrixData$type=="loanSt"),"type"]<-"loan"
matrixData[which(matrixData$type=="loanLt"),"type"]<-"loan"

#matrixData<-data.frame(matrixData,stringsAsFactors = FALSE)

#asset side
##sector/asset
assets<-matrixData[matrixData$source=="mfi",]
asset_maturity<-assets[(assets$type=="debt" | assets$type=="loan"),]
asset_other<-assets[(assets$type!="debt" & assets$type!="loan"),]

#loan and debt
asset_maturity$source<-paste(asset_maturity$target,asset_maturity$maturity,sep=" ")
asset_maturity$target<-asset_maturity$maturity
asset_maturity$source_level<-0
asset_maturity$target_level<-1

maturity_other<-ddply(asset_maturity,.(maturity,time),summarize,value=sum(value))
maturity_other$type<-"null"
maturity_other[which(maturity_other$maturity=="debtSt" | maturity_other$maturity=="debtLt"),"type"]<-"debt"
maturity_other[which(maturity_other$maturity=="loanSt" | maturity_other$maturity=="loanLt"),"type"]<-"loan"
maturity_other$source<-maturity_other$maturity
maturity_other$target<-maturity_other$type
maturity_other$source_level<-1
maturity_other$target_level<-2

#others
asset_other$source<-paste(asset_other$target,asset_other$type,sep=" ")
asset_other$target<-asset_other$type

asset_other$source_level<-0
asset_other$target_level<-2

#asset to core
assets_core<-rbind(maturity_other,asset_other)
assets_core<-ddply(assets_core,.(type,time),summarize,value=sum(value))
assets_core$maturity="null"
assets_core$source<-asset_core$type
assets_core$target<-"core"
assets_core$source_level<-2
assets_core$target_level<-3

assets<-rbind(asset_maturity,asset_other,maturity_other,assets_core)
assets<-subset(assets,select=-c(maturity))

#liability side
liabilities<-matrixData[matrixData$target=="mfi",]
liability_maturity<-liabilities[(liabilities$type=="debt" | liabilities$type=="loan"),]
liability_other<-liabilities[(liabilities$type!="debt" & liabilities$type!="loan"),]

#loan and debt
liability_maturity$target<-paste(liability_maturity$source,liability_maturity$maturity,sep=" ")
liability_maturity$source<-liability_maturity$maturity
liability_maturity$source_level<-5
liability_maturity$target_level<-6

other_maturity<-ddply(liability_maturity,.(maturity,time),summarize,value=sum(value))
other_maturity$type<-"null"
other_maturity[which(other_maturity$maturity=="debtSt" | other_maturity$maturity=="debtLt"),"type"]<-"debt"
other_maturity[which(other_maturity$maturity=="loanSt" | other_maturity$maturity=="loanLt"),"type"]<-"loan"
other_maturity$source<-other_maturity$type
other_maturity$target<-other_maturity$maturity
other_maturity$source_level<-4
other_maturity$target_level<-5

#others
liability_other$target<-paste(liability_other$source,liability_other$type,sep=" ")
liability_other$source<-liability_other$type

liability_other$source_level<-4
liability_other$target_level<-6

#asset to core
core_liability<-rbind(liability_maturity,liability_other)
core_liability<-ddply(core_liability,.(type,time),summarize,value=sum(value))
core_liability$maturity="null"
core_liability$source<-"core"
core_liability$target<-core_liability$type
core_liability$source_level<-3
core_liability$target_level<-4

liability<-rbind(liability_maturity,liability_other,other_maturity,core_liability)
liability<-subset(liability,select=-c(maturity))

data<-rbind(assets,liability)
data$value<-data$value/1000
names(data)[names(data) == "type"] <- "edge_type"
#data<-data$value/1000
file<-paste("ea_banks_bs.csv",sep="")
write.csv(data,file)
