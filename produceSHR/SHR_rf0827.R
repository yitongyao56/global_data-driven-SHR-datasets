
library(caret)
library(randomForest)
library(R.matlab)
library(quantregForest)
library(raster)
gppvars=c("GPP_1","GPP_2","GPP_3","GPP_4","GPP_5","GPP_6","PmodelGPP")
soilwvars=c("soilw","TWS","GLDAS")

can_vars=c('LC','MAT','MAP','MAR','Ndep','SC','TC','totalN','totalC')

tpname=c("cruncep","crujra","princeton","wfdeicru","wfdeigpcc","cpc")

file_gpp_name=c("/home/orchidee04/yyao/SHRtraining/newclimate/FLUXCOM/FLUXCOM GPP_1 ",
"/home/orchidee04/yyao/SHRtraining/newclimate/FLUXCOM/FLUXCOM GPP_2 ",
"/home/orchidee04/yyao/SHRtraining/newclimate/FLUXCOM/FLUXCOM GPP_3 ",
"/home/orchidee04/yyao/SHRtraining/newclimate/FLUXCOM/FLUXCOM GPP_4 ",
"/home/orchidee04/yyao/SHRtraining/newclimate/FLUXCOM/FLUXCOM GPP_5 ",
"/home/orchidee04/yyao/SHRtraining/newclimate/FLUXCOM/FLUXCOM GPP_6 ",
                "/home/orchidee04/yyao/SHRtraining/pmodelGPP/pmodelGPP annual ")
file_soilw_name=c("/home/orchidee04/yyao/SHRtraining/globalSoilw/global annual soilw ",
                  "/home/orchidee04/yyao/SHRtraining/GRACE reconstruction ann TWS/GRACE annual TWS ",
                  "/home/orchidee04/yyao/SHRtraining/annual_GLDAS/GLDAS annual noweighted soilm ","/home/orchidee04/yyao/SHRtraining/ESACCI/ESACCI soilw ")
file_tp_name=c("/home/orchidee04/yyao/SHRtraining/newclimate/CRUNCEP/CRUNCEP annual ",
"/home/orchidee04/yyao/SHRtraining/newclimate/CRUJRA/CRUJRA annual ",
"/home/orchidee04/yyao/SHRtraining/newclimate/Princeton/Princeton annual ",
"/home/orchidee04/yyao/SHRtraining/newclimate/WFDEI_CRU/WFDEI_CRU annual ",
"/home/orchidee04/yyao/SHRtraining/newclimate/WFDEI_GPCC/WFDEI_GPCC annual ",
"/home/orchidee04/yyao/SHRtraining/newclimate/CPC/CPC annual ")

id_gpp_name=c("GPP_1","GPP_2","GPP_3","GPP_4","GPP_5","GPP_6","PmodelGPP")
id_soilw_name=c("soilw","TWS","GLDAS")

output_soilw=name=c("CPC","TWS","GLDAS")

sc05=readMat(paste("/home/orchidee04/yyao/SHRtraining/SC05.mat",sep=""))
annual_sc05=sc05$SC.05
tc05=readMat(paste("/home/orchidee04/yyao/SHRtraining/TC05.mat",sep=""))
annual_tc05=tc05$TC.05
totalN05=readMat(paste("/home/orchidee04/yyao/SHRtraining/totalN05.mat",sep=""))
annual_tN05=totalN05$totalN05

classLC=readMat(paste("/home/orchidee04/yyao/SHRtraining/onehot/onehot MODIS land cover yr ",2001,".mat",sep =""))
global_LC=classLC$onehot.LC


for (tp_num in 5:6) {
	tpdata=tpname[tp_num]
	for (soilnum in 1:3) {
	  for (gppnum in 1:7) {
		explain_vars=c(can_vars,gppvars[gppnum],soilwvars[soilnum])
		load(file = paste("/home/orchidee04/yyao/SHRtraining/newclimate/qrfmodel/RF ",tpdata," ",id_gpp_name[gppnum]," ",id_soilw_name[soilnum],".Rdata",sep=""))
		
		for (year in 1985:2013) {

			
			rad=readMat(paste("/home/orchidee04/yyao/SHRtraining/CRUNCEPv8/cruncepv8 annual rad ",year,".mat",sep =""))
			annual_rad=rad$annual.rad
			tmp=readMat(paste0(file_tp_name[tp_num],"temperature ",year,".mat"))
			annual_tmp=tmp$annual.temp
			pre=readMat(paste0(file_tp_name[tp_num],"precipitation ",year,".mat"))
			annual_pre=pre$annual.prec
			
			ndep=readMat(paste("/home/orchidee04/yyao/SHRtraining/globalNdep/global annual Ndep ",year,".mat",sep =""))
			annual_Ndep=ndep$global.ann.Ndep
			
			soilw=readMat(paste(file_soilw_name[soilnum],year,".mat",sep =""))
			annual_soilw=soilw$global.ann.soilw
			GPP=readMat(paste0(file_gpp_name[gppnum],year,".mat"))
			annual_GPP=GPP$annual.GPP.mean
			
			ndvi_Maps=data.frame(V1=as.data.frame(raster(global_LC)),V2=as.data.frame(raster(annual_tmp)))
			ndvi_Maps[,3]=as.data.frame(raster(annual_pre))
			ndvi_Maps[,4]=as.data.frame(raster(annual_rad))
			ndvi_Maps[,5]=as.data.frame(raster(annual_Ndep))
			ndvi_Maps[,6]=as.data.frame(raster(annual_sc05))
			ndvi_Maps[,7]=as.data.frame(raster(annual_tc05))
			ndvi_Maps[,8]=as.data.frame(raster(annual_tN05))
			ndvi_Maps[,9]=as.data.frame(raster(annual_sc05+annual_tc05))
			ndvi_Maps[,10]=as.data.frame(raster(annual_GPP))
			ndvi_Maps[,11]=as.data.frame(raster(annual_soilw))
			
			names(ndvi_Maps)<-c("LC","MAT","MAP","MAR","Ndep","SC","TC","totalN","totalC",gppvars[gppnum],soilwvars[soilnum])
			
			not.na.row=!is.na(ndvi_Maps[,1])
			for (cols in 2:11){
			  not.na.row=not.na.row & !is.na(ndvi_Maps[,cols])
			}
			new_maps=ndvi_Maps[not.na.row,]
			
			p_all=predict(mymodel,new_maps,predict.all=TRUE)
			
			p_sd=as.matrix(apply(p_all$individual,1,sd))
			p_mean=as.matrix(apply(p_all$individual,1,mean))
			
			p_mean_std=rep(0,259200*2)
			dim(p_mean_std)=c(259200,2)
			#p_quantiles=rep(0,259200*2)
			#dim(p_quantiles)=c(259200,2)
			p_mean_std[not.na.row,1]=p_mean
			p_mean_std[not.na.row,2]=p_sd

			#p_quantiles[not.na.row,1]=p_25
			#p_quantiles[not.na.row,2]=p_75
			rh_mean=(t(matrix(p_mean_std[,1],ncol=360)))
			rh_std=(t(matrix(p_mean_std[,2],ncol=360)))
			
			#rh_q25=(t(matrix(p_quantiles[,1],ncol=360)))
			#rh_q75=(t(matrix(p_quantiles[,2],ncol=360)))
			writeMat(paste("/home/orchidee04/yyao/SHRtraining/newclimate/0826SHRestimation/RFstd ",tpdata," ",id_gpp_name[gppnum]," ",output_soilw[soilnum]," RH year",year,".mat",sep=""),
			rh_mean=rh_mean,rh_std=rh_std)
		}
	  }
	} 
} 



