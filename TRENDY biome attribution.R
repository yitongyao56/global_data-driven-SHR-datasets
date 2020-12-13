
model_name=c("CABLE","CLASS-CTEM","CLM4.5","ISAM","JSBACH","JULES","LPX","OCN","ORCHIDEE-MICT","ORCHIDEE","VEGAS","VISIT")
library(raster)
library(R.matlab)
global_area=area(raster(nrow=360,ncol=720))
global_area=as.matrix(global_area)
overlap=readMat("/home/orchidee04/yyao/SHRtraining/newclimate/newoverlap.mat")
overlap_mask=overlap$newmask
new=readMat("/home/orchidee04/yyao/SHRtraining/new mask.mat")
new_veg=new$new.veg
for (model_num in 1:12) {
	premodel=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/PRE TRENDY ",model_name[model_num]," 1985-2013.mat"))
	premodel_tmp=premodel$premodel.tmp
	premodel_pre=premodel$premodel.pre
	premodel_rad=premodel$premodel.rad

	premodel_rec=premodel_tmp+premodel_pre+premodel_rad	
	
	anomaly=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SHRanomaly TRENDY ",model_name[model_num],"1985-2013.mat"))			
	YSHR_anoma=anomaly$YSHR.anoma			
	
	premodel_newveg_IAV=rep(NA,6*29*5)
	dim(premodel_newveg_IAV)=c(6,29,5)

	for (biome in 1:6) {
		for (year in 1:29) {
			sSHR=premodel_tmp[,,year]*global_area*overlap_mask*(new_veg==biome)
			sarea=(!is.na(premodel_tmp[,,year]))*global_area*overlap_mask*(new_veg==biome)
			premodel_newveg_IAV[biome,year,1]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)

			sSHR=premodel_pre[,,year]*global_area*overlap_mask*(new_veg==biome)
			sarea=(!is.na(premodel_pre[,,year]))*global_area*overlap_mask*(new_veg==biome)
			premodel_newveg_IAV[biome,year,2]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
			
			sSHR=premodel_rad[,,year]*global_area*overlap_mask*(new_veg==biome)
			sarea=(!is.na(premodel_rad[,,year]))*global_area*overlap_mask*(new_veg==biome)
			premodel_newveg_IAV[biome,year,3]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
			
			sSHR=YSHR_anoma[,,year]*global_area*overlap_mask*(new_veg==biome)
			sarea=(!is.na(YSHR_anoma[,,year]))*global_area*overlap_mask*(new_veg==biome)
			premodel_newveg_IAV[biome,year,4]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)		
			sSHR=premodel_rec[,,year]*global_area*overlap_mask*(new_veg==biome)
                        sarea=(!is.na(premodel_rec[,,year]))*global_area*overlap_mask*(new_veg==biome)
                        premodel_newveg_IAV[biome,year,5]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T) 
		}
	}  
	writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/PREnewvegIAV TRENDY ", model_name[model_num]," 1985-2013.mat"),
	premodel_newveg_IAV=premodel_newveg_IAV)
}
			


for (model_num in 1:12) {
	swcmodel=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SWC TRENDY ",model_name[model_num]," 1985-2013.mat"))
	swcmodel_tmp=swcmodel$swcmodel.tmp
	swcmodel_swc=swcmodel$swcmodel.swc
	swcmodel_rad=swcmodel$swcmodel.rad

	swcmodel_rec=swcmodel_tmp+swcmodel_swc+swcmodel_rad	
	
	anomaly=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SHRanomaly TRENDY ",model_name[model_num],"1985-2013.mat"))			
	YSHR_anoma=anomaly$YSHR.anoma			
	
	swcmodel_newveg_IAV=rep(NA,6*29*5)
	dim(swcmodel_newveg_IAV)=c(6,29,5)

	for (biome in 1:6) {
		for (year in 1:29) {
			sSHR=swcmodel_tmp[,,year]*global_area*overlap_mask*(new_veg==biome)
			sarea=(!is.na(swcmodel_tmp[,,year]))*global_area*overlap_mask*(new_veg==biome)
			swcmodel_newveg_IAV[biome,year,1]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)

			sSHR=swcmodel_swc[,,year]*global_area*overlap_mask*(new_veg==biome)
			sarea=(!is.na(swcmodel_swc[,,year]))*global_area*overlap_mask*(new_veg==biome)
			swcmodel_newveg_IAV[biome,year,2]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
			
			sSHR=swcmodel_rad[,,year]*global_area*overlap_mask*(new_veg==biome)
			sarea=(!is.na(swcmodel_rad[,,year]))*global_area*overlap_mask*(new_veg==biome)
			swcmodel_newveg_IAV[biome,year,3]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
			
			sSHR=YSHR_anoma[,,year]*global_area*overlap_mask*(new_veg==biome)
			sarea=(!is.na(YSHR_anoma[,,year]))*global_area*overlap_mask*(new_veg==biome)
			swcmodel_newveg_IAV[biome,year,4]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)		
			sSHR=swcmodel_rec[,,year]*global_area*overlap_mask*(new_veg==biome)
                        sarea=(!is.na(swcmodel_rec[,,year]))*global_area*overlap_mask*(new_veg==biome)
                        swcmodel_newveg_IAV[biome,year,5]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T) 
		}
	}  
	writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SWCnewvegIAV TRENDY ", model_name[model_num]," 1985-2013.mat"),
	swcmodel_newveg_IAV=swcmodel_newveg_IAV)
}


