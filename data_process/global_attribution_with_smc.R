
library(R.matlab)
tpname=c("cruncep","crujra","princeton","wfdeicru","wfdeigpcc","cpc")
id_gpp_name=c("GPP_1","GPP_2","GPP_3","GPP_4","GPP_5","GPP_6","PmodelGPP")
id_soilw_name=c("CPC","TWS","GLDAS")
library(raster)
global_area=area(raster(nrow=360,ncol=720))
global_area=as.matrix(global_area)
overlap=readMat("/home/orchidee04/yyao/SHRtraining/newclimate/newoverlap.mat")
overlap_mask=overlap$newmask

for (tp_num in 1:6) {
	tpdata=tpname[tp_num]
	for (soilw_num in 1:3) {
		for (gpp_num in 1:7) {
			swcmodel=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SWC ",tpdata," ",id_gpp_name[gpp_num]," ",id_soilw_name[soilw_num]," 1985-2013.mat"))
			swcmodel_tmp=swcmodel$swcmodel.tmp
			swcmodel_swc=swcmodel$swcmodel.swc
			swcmodel_rad=swcmodel$swcmodel.rad

			swcmodel_rec=swcmodel_tmp+swcmodel_swc+swcmodel_rad	
			
			anomaly=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SHRanomaly ",tpdata," ",id_gpp_name[gpp_num]," ",id_soilw_name[soilw_num],"1985-2013.mat"))			
			YSHR_anoma=anomaly$YSHR.anoma			

			swcmodel_IAV=rep(NA,29*5)
			dim(swcmodel_IAV)=c(29,5)
			for (year in 1:29) {
				sSHR=swcmodel_tmp[,,year]*global_area*overlap_mask
				sarea=(!is.na(swcmodel_tmp[,,year]))*global_area*overlap_mask
				swcmodel_IAV[year,1]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
				
				sSHR=swcmodel_swc[,,year]*global_area*overlap_mask
				sarea=(!is.na(swcmodel_swc[,,year]))*global_area*overlap_mask
				swcmodel_IAV[year,2]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
				
				sSHR=swcmodel_rad[,,year]*global_area*overlap_mask
				sarea=(!is.na(swcmodel_rad[,,year]))*global_area*overlap_mask
				swcmodel_IAV[year,3]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
				
				sSHR=YSHR_anoma[,,year]*global_area*overlap_mask
				sarea=(!is.na(YSHR_anoma[,,year]))*global_area*overlap_mask
				swcmodel_IAV[year,4]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
				
				sSHR=swcmodel_rec[,,year]*global_area*overlap_mask
				sarea=(!is.na(swcmodel_rec[,,year]))*global_area*overlap_mask
				swcmodel_IAV[year,5]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
			}
			writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/factIAV0823/factIAV SWC ",tpdata," ",id_gpp_name[gpp_num]," ",id_soilw_name[soilw_num],".mat"),
			swcmodel_IAV=swcmodel_IAV)
		}
	}
}


