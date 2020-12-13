
library(R.matlab)
library(pracma)
soilwvars=c("soilw","TWS","GLDAS")
can_vars=c('LC','MAT','MAP','MAR','Ndep','SC','TC','totalN','totalC')

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
id_soilw_name=c("CPC","TWS","GLDAS")


## regress against pre or smc (no other variables)
CRUrad=rep(NA,360*720*29)
dim(CRUrad)=c(360,720,29)
for (year in 1985:2013) {
	rad=readMat(paste("/home/orchidee04/yyao/SHRtraining/CRUNCEPv8/cruncepv8 annual rad ",year,".mat",sep =""))
	annual_rad=rad$annual.rad
	CRUrad[,,year-1984]=annual_rad
}
tpname=c("cruncep","crujra","princeton","wfdeicru","wfdeigpcc","cpc")
for (tp_num in 1:6) {
	tpdata=tpname[tp_num]
	tpdata_tmp=rep(NA,360*720*29)
	dim(tpdata_tmp)=c(360,720,29)
	tpdata_pre=rep(NA,360*720*29)
	dim(tpdata_pre)=c(360,720,29)
	
	for (year in 1985:2013) {
		tmp=readMat(paste0(file_tp_name[tp_num],"temperature ",year,".mat"))
		annual_tmp=tmp$annual.temp
		pre=readMat(paste0(file_tp_name[tp_num],"precipitation ",year,".mat"))
		annual_pre=pre$annual.prec
		
		tpdata_tmp[,,year-1984]=annual_tmp
		tpdata_pre[,,year-1984]=annual_pre
	}
	
	for (soilw_num in 3:3) {
		DATAsoilw=rep(NA,360*720*29)
		dim(DATAsoilw)=c(360,720,29)
		for (year in 1985:2013) {
			soilw=readMat(paste0(file_soilw_name[soilw_num],year,".mat"))
			annual_soilw=soilw$global.ann.soilw
			DATAsoilw[,,year-1984]=annual_soilw
		}
		for (gpp_num in 1:7) {
			YSHR=rep(NA,360*720*29)
			dim(YSHR)=c(360,720,29)
			for (year in 1985:2013) {
				SHR=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/0823SHRestimation/RFmean ",
				tpdata," ",id_gpp_name[gpp_num]," ",id_soilw_name[soilw_num]," RH year",year,".mat"))			
				YSHR[,,year-1984]=SHR$rh.mean
			}
			premodel_tmp=rep(NA,360*720*29)
			dim(premodel_tmp)=c(360,720,29)
			premodel_pre=rep(NA,360*720*29)
			dim(premodel_pre)=c(360,720,29)
			premodel_rad=rep(NA,360*720*29)
			dim(premodel_rad)=c(360,720,29)
			
			
			pre_sens_tmp=rep(NA,360*720)
			dim(pre_sens_tmp)=c(360,720)
			pre_sens_pre=rep(NA,360*720)
			dim(pre_sens_pre)=c(360,720)
			pre_sens_rad=rep(NA,360*720)
			dim(pre_sens_rad)=c(360,720)
			
			swcmodel_tmp=rep(NA,360*720*29)
			dim(swcmodel_tmp)=c(360,720,29)
			swcmodel_swc=rep(NA,360*720*29)
			dim(swcmodel_swc)=c(360,720,29)
			swcmodel_rad=rep(NA,360*720*29)
			dim(swcmodel_rad)=c(360,720,29)
			
			swc_sens_tmp=rep(NA,360*720)
			dim(swc_sens_tmp)=c(360,720)
			swc_sens_swc=rep(NA,360*720)
			dim(swc_sens_swc)=c(360,720)
			swc_sens_rad=rep(NA,360*720)
			dim(swc_sens_rad)=c(360,720)
			
			
			for (rows in 1:360) {
				for (cols in 1:720) {
					tas_tt=tpdata_tmp[rows,cols,]
					pre_tt=tpdata_pre[rows,cols,]
					rad_tt=CRUrad[rows,cols,]
					SHR_tt=YSHR[rows,cols,]
					swc_tt=DATAsoilw[rows,cols,]
					if (sum(!is.na(tas_tt))==29 & sum(!is.na(pre_tt))==29 & sum(!is.na(rad_tt))==29 & 
					sum(!is.na(SHR_tt))==29 & sum(!is.na(swc_tt))==29){
						tas_anoma=detrend(tas_tt)
						pre_anoma=detrend(pre_tt)
						rad_anoma=detrend(rad_tt)
						SHR_anoma=detrend(SHR_tt)
						if (soilw_num!=2) {
							swc_anoma=detrend(swc_tt)
						} else {swc_anoma=swc_tt}
						
						premodel=lm(SHR_anoma ~ tas_anoma+pre_anoma+rad_anoma-1)
						swcmodel=lm(SHR_anoma ~ tas_anoma+swc_anoma+rad_anoma-1)
						
						premodel_tmp[rows,cols,]=premodel$coefficients[1]*tas_anoma
						premodel_pre[rows,cols,]=premodel$coefficients[2]*pre_anoma
						premodel_rad[rows,cols,]=premodel$coefficients[3]*rad_anoma
						
						swcmodel_tmp[rows,cols,]=swcmodel$coefficients[1]*tas_anoma
						swcmodel_swc[rows,cols,]=swcmodel$coefficients[2]*swc_anoma
						swcmodel_rad[rows,cols,]=swcmodel$coefficients[3]*rad_anoma
						
						pre_sens_tmp[rows,cols]=premodel$coefficients[1]
						pre_sens_pre[rows,cols]=premodel$coefficients[2]
						pre_sens_rad[rows,cols]=premodel$coefficients[3]
						
						swc_sens_tmp[rows,cols]=swcmodel$coefficients[1]
						swc_sens_swc[rows,cols]=swcmodel$coefficients[2]
						swc_sens_rad[rows,cols]=swcmodel$coefficients[3]
					}
				}
			}
			
			writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/PRE ",tpdata," ",id_gpp_name[gpp_num]," ",id_soilw_name[soilw_num]," 1985-2013.mat"),
				premodel_tmp=premodel_tmp,premodel_pre=premodel_pre,premodel_rad=premodel_rad,
				pre_sens_tmp=pre_sens_tmp,pre_sens_pre=pre_sens_pre,pre_sens_rad=pre_sens_rad)
			writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SWC ",tpdata," ",id_gpp_name[gpp_num]," ",id_soilw_name[soilw_num]," 1985-2013.mat"),
				swcmodel_tmp=swcmodel_tmp,swcmodel_swc=swcmodel_swc,swcmodel_rad=swcmodel_rad,
				swc_sens_tmp=swc_sens_tmp,swc_sens_swc=swc_sens_swc,swc_sens_rad=swc_sens_rad)
		}
	}
}
