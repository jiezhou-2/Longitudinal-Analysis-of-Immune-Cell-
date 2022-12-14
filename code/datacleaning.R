
confounder=read.csv("//dartfs-hpc.dartmouth.edu/rc/lab/M/MRKepistor7/collab/JieZhou/SourceFiles/req19jul2019_ym_06jul2020.csv")
linkage=read.csv("//dartfs-hpc.dartmouth.edu/rc/lab/M/MRKepistor7/collab/JieZhou/SourceFiles/MBLID_linkage.csv")
load("./data/inputdataMZILN.Rdata")
##6-week data
data6w=genusdata.nozeros
#12-month data
data12m=readRDS(file="./data/SILVAtaxtab_G_12M.RDS")[1:272,]
#crosswalk data
crosswalk=read.csv(file="./data/NHBCSreq19SEP2018ym_deided.csv",header = T)[,c(1,2)]
#mblid for 6-week data,remove the trailing whitespace from the row names
mblid6w=trimws(rownames(genusdata.nozeros))
#mblid for 12-month data,remove the trailing whitespace from the row names
mblid12m=trimws(rownames(data12m))[1:272]
#mblid in crosswalk file
mblid=trimws(crosswalk$mblid)
#id6w=substring(rownames(genusdata.nozeros),3,8)
#id12m=substring(rownames(data12M),3,8)
#genus12mdata=data.frame()
subject6w=rep(0,length(mblid6w))
subject12m=rep(0,length(mblid12m))
for (i in 1:length(mblid6w)) {
  index1=which(mblid==mblid6w[i])
  if (length(index1)==1)  {
    subject6w[i]=crosswalk$subject_id[index1]
  }else{
    subject6w[i]=NA
  }
}
data6w=cbind(subject6w,6,data6w)
df.bcelladj6w=cbind(subject6w,df.bcelladj)
df.cd4tadj6w=cbind(subject6w,df.cd4tadj)
df.cd8tadj6w=cbind(subject6w,df.cd8tadj)
df.granadj6w=cbind(subject6w,df.granadj)
df.nrbcadj6w=cbind(subject6w,df.nrbcadj)
df.nkadj6w=cbind(subject6w,df.nkadj)
df.monoadj6w=cbind(subject6w,df.monoadj)
df.cd8tcd4tadj6w=cbind(subject6w,df.cd8tcd4tadj)
for (i in 1:length(subject12m)) {
  index2=which(mblid==mblid12m[i])
  if (length(index2)==1)  {
    subject12m[i]=crosswalk$subject_id[index2]
  }else{
    subject12m[i]=i
  }
}
data12m=cbind(subject12m,12,data12m)

colnames(data6w)[1:2]=c("subject","time")
colnames(data12m)[1:2]=c("subject","time")
name6w=colnames(data6w)[-c(1,2)]
name12m=colnames(data12m)[-c(1,2)]
jointname=unique(c(name6w, name12m))
n1=nrow(data6w)
n2=nrow(data12m)
data6w_swell=data.frame(matrix(nrow = n1,ncol = length(jointname)))
data12m_swell=data.frame(matrix(nrow = n2,ncol = length(jointname)))
for (j in 1:length(jointname)) {
  index1=which(name6w==jointname[j])
  index2=which(name12m==jointname[j])
  if (length(index1)==1){
    data6w_swell[,j]=data6w[,index1+2]
  }else{
    data6w_swell[,j]=0
  }
  if (length(index2)==1){
    data12m_swell[,j]=data12m[,index2+2]
  }else{
    data12m_swell[,j]=0
  }
}
data6w_swell=cbind(data6w$subject,data6w$time, data6w_swell)
rownames(data6w_swell)=rownames(data6w)
colnames(data6w_swell)=c("subject","time",jointname)
data12m_swell=cbind(data12m$subject,data12m$time, data12m_swell)
rownames(data12m_swell)=rownames(data12m)
colnames(data12m_swell)=c("subject","time",jointname)
data6w12m=rbind(data6w_swell,data12m_swell)
#which(apply(data6w12m[,-c(1,2)], 2, sum)==0)
data6w12m=data6w12m[,-207]
index=order(data6w12m$subject,data6w12m$time)
data6w12m=data6w12m[index,]
save(data6w12m,file = "data6w12m.Rdata")


overlap=intersect(data6w_swell$subject,data12m_swell$subject)
##overlapping data
data12msub=data.frame()
df.bcelladj_o=data.frame()
df.cd4tadj_o=data.frame()
df.cd8tadj_o=data.frame()
df.cd8tcd4tadj_o=data.frame()
df.monoadj_o=data.frame()
df.nkadj_o=data.frame()
df.nrbcadj_o=data.frame()
df.granadj_o=data.frame()
for (i in 1:length(overlap)) {
  index1=which(data12m_swell$subject==overlap[i])
  a=data12m_swell[index1,]
  data12msub=rbind(data12msub,a)

  index1=which(df.bcelladj6w$subject6w==overlap[i])
  a=df.bcelladj6w[index1,]
  df.bcelladj_o=rbind(df.bcelladj_o,a)


  a=df.cd4tadj6w[index1,]
  df.cd4tadj_o=rbind(df.cd4tadj_o,a)

  a=df.cd8tadj6w[index1,]
  df.cd8tadj_o=rbind(df.cd8tadj_o,a)

  a=df.cd8tcd4tadj6w[index1,]
  df.cd8tcd4tadj_o=rbind(df.cd8tcd4tadj_o,a)


  a=df.monoadj6w[index1,]
  df.monoadj_o=rbind(df.monoadj_o,a)

  a=df.nkadj6w[index1,]
  df.nkadj_o=rbind(df.nkadj_o,a)

  a=df.nrbcadj6w[index1,]
  df.nrbcadj_o=rbind(df.nrbcadj_o,a)

  a=df.granadj6w[index1,]
  df.granadj_o=rbind(df.granadj_o,a)
}
longidata=rbind(data6w_swell,data12msub)
longibcell=rbind(df.bcelladj6w,df.bcelladj_o)
longicd4=rbind(df.cd4tadj6w,df.cd4tadj_o)
longicd8=rbind(df.cd8tadj6w, df.cd8tadj_o)
longicd8cd4=rbind(df.cd8tcd4tadj6w,df.cd8tcd4tadj_o)
longimono=rbind(df.monoadj6w,df.monoadj_o)
longink=rbind(df.nkadj6w,df.nkadj_o)
longinrbc=rbind(df.nrbcadj6w,df.nrbcadj_o)
longigran=rbind(df.granadj6w,df.granadj_o)

library(vegan)
index=order(longidata[,1],longidata[,2])
longidata=longidata[index,]
alpha6w=diversity(data6w_swell[,-c(1,2)],index = "shannon")
alpha12m=diversity(data12msub[,-c(1,2)],index = "shannon")
alpha=diversity(longidata[,-c(1,2)],index = "shannon")
longibcell=cbind(longibcell[index,],alpha)
longicd4=cbind(longicd4[index,],alpha)
longicd8=cbind(longicd8[index,],alpha)
longicd8cd4=cbind(longicd8cd4[index,],alpha)
longigran=cbind(longigran[index,],alpha)
longimono=cbind(longimono[index,],alpha)
longink=cbind(longink[index,],alpha)
longinrbc=cbind(longinrbc[index,],alpha)


exmblid=rownames(longidata)
deliver=c()
for (i in 1:length(exmblid)) {
  index2=which(linkage[,2]==exmblid[i])
  unq_id=linkage[index2,1]
  index3=which(confounder[,1]==unq_id)
  a=confounder$deliverytype[index3]
  deliver=c(deliver,a)
}

longibcell=cbind(longibcell,deliver)
longicd4=cbind(longicd4,deliver)
longicd8=cbind(longicd8,deliver)
longimono=cbind(longimono,deliver)
longink=cbind(longink,deliver)
longinrbc=cbind(longinrbc,deliver)
longigran=cbind(longigran,deliver)


