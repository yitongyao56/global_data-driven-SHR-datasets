library(R.matlab)
library(randomForest)


load("/home/orchidee04/yyao/SHRtraining/newclimate/SRDBprinceton.Rdata")
	load("/home/orchidee04/yyao/SHRtraining/newtestSRDB.Rdata")
	agg.data$totalC=agg.data$SC+agg.data$TC
	agg.data=agg.data[agg.data$RH<1550,]
	agg.data$MAT=SRDBprinceton$MAT
	agg.data$MAP=SRDBprinceton$MAP

	GPPname=c("GPP_1","GPP_2","GPP_3","GPP_4","GPP_5","GPP_6","PmodelGPP")
	soilWname=c("soilw","TWS","GLDAS")

	for (num_gpp in 1:7) {
		for (num_soilw in 1:3) {
			var_series=c('LC','MAT','MAP','MAR','Ndep','totalN','totalC',GPPname[num_gpp],soilWname[num_soilw],"RH") # subsoil
			randomData=agg.data[,var_series]
			cv_all_obs=data.frame()
			cv_all_pred=data.frame()
			for (k in 1:455) {
			  cv_train=randomData[-k,] # constant folds
			  cv_test=randomData[k,]
			  #mymodel <- train(as.data.frame(cv_train[,var_series]), as.vector(as.matrix(cv_train[,"RH"])),
							   #method = "rf", num.trees=200)
			  mymodel <- randomForest(RH ~ ., data=cv_train, ntree=1000,
              keep.forest=TRUE, importance=TRUE)
			  cv_train_preds=predict(mymodel,cv_train)
			  cv_test_preds=predict(mymodel,cv_test)

			  cv_test_obs=cv_test$RH

			  cv_all_obs=rbind(cv_all_obs,as.data.frame(cv_test_obs))
			  cv_all_pred=rbind(cv_all_pred,as.data.frame(cv_test_preds))
			}

				#cor(cv_all_obs,cv_all_pred)^2
			#plot(cv_all_obs$cv_test_obs,cv_all_pred$cv_test_preds,ylim=c(0,1500),xlim=c(0,1500),xlab="Observed annual SHR (gC m-2yr-1)",ylab="Predicted annual SHR (gCm-2yr-1)",cex.lab=2,cex.axis=2)
			#abline(0,1,lwd=2,lty=2)
			writeMat(paste("/home/orchidee04/yyao/SHRtraining/newclimate/LOOCV/LOOCV princeton ",GPPname[num_gpp]," ",soilWname[num_soilw],".mat",sep=""),cv_all_obs=cv_all_obs,cv_all_pred=cv_all_pred)
		}
	}
