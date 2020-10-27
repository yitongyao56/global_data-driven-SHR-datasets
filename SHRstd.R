
library(R.matlab)
tpname=c("cruncep","crujra","princeton","wfdeicru","wfdeigpcc","cpc")
id_gpp_name=c("GPP_1","GPP_2","GPP_3","GPP_4","GPP_5","GPP_6","PmodelGPP")
id_soilw_name=c("CPC","TWS","GLDAS")
for (tp_num in 1:6) {
	tpdata=tpname[tp_num]
	for (gpp_num in 1:7) {
		for (soil_num in 1:3) {
			YSHR_std=rep(NA,360*720*29)
			dim(YSHR_std)=c(360,720,29)
			for (year in 1985:2013) {
				SHR=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/0826SHRestimation/RFstd ",
				tpdata," ",id_gpp_name[gpp_num]," ",id_soilw_name[soil_num]," RH year",year,".mat"))			
				YSHR=SHR$rh.std
				YSHR_std[,,year-1984]=YSHR				
			}	
			writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/meanSHR/RFstd SHR ",tpdata," ",id_gpp_name[gpp_num]," ",id_soilw_name[soil_num],".mat"),YSHR_std=YSHR_std)
		}
	}
}



