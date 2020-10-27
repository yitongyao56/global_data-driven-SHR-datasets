
#library(quantregForest)
library(R.matlab)
library(randomForest)
tpname=c("cruncep","crujra","princeton","cpc","wfdeicru","wfdeigpcc")
for (tp_num in 1:6) {
	tpdata=tpname[tp_num]
	load(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/SRDB",tpdata,".Rdata"))
	load("/home/orchidee04/yyao/SHRtraining/newtestSRDB.Rdata")
	GPPname=c("GPP_1","GPP_2","GPP_3","GPP_4","GPP_5","GPP_6","PmodelGPP")
	soilWname=c("soilw","TWS","GLDAS","ESACCI")
	
	agg.data$totalC=agg.data$SC+agg.data$TC
	agg.data=agg.data[agg.data$RH<1550,]
	
	
	mat_text=paste0("agg.data$MAT=SRDB",tpdata,"$MAT")
	map_text=paste0("agg.data$MAP=SRDB",tpdata,"$MAP")
	eval(parse(text=mat_text))
	eval(parse(text=map_text))

#	sites=readMat("/home/orchidee04/yyao/SHRtraining/sites_location_index.mat")
	sites=readMat("/home/orchidee04/yyao/SHRtraining/sites_location_spei.mat")
	#agg.data$shallow1=sites$sites.location[,6]
	#agg.data$shallow2=sites$sites.location[,7]
	
	for (num_gpp in 1:7) {
		for (num_soilw in 3:3) {
			 var_series=c('LC','MAT','MAP','MAR','Ndep','totalN','SC','TC','totalC',GPPname[num_gpp],soilWname[num_soilw]) # subsoil
			 Xtrain=agg.data[,var_series]
			 Ytrain=agg.data$RH
			# qrf <- quantregForest(x=Xtrain, y=Ytrain, ntree=3000,
			#						keep.forest=TRUE, importance=TRUE)
		mymodel <- randomForest(RH ~ ., data=agg.data[,c(var_series,"RH")], ntree=1000,
                  keep.forest=TRUE, importance=TRUE)
	
		 save(mymodel, file =paste("/home/orchidee04/yyao/SHRtraining/newclimate/qrfmodel/RF ",tpdata," ",GPPname[num_gpp]," ",soilWname[num_soilw],".Rdata",sep=""))
			 gc(mymodel)
			 rm(mymodel)
		 }
	}

}
