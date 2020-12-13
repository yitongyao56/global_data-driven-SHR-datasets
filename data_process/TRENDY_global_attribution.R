
##### TRENDY model regression attribution 
library(raster)
library(R.matlab)
library(pracma)
r <- raster(nrow=360, ncol=720) # km2
global_area <- area(r)
global_area=as.matrix(global_area)


CRUtmp=rep(0,360*720*29)
dim(CRUtmp)=c(360,720,29)
CRUpre=rep(0,360*720*29)
dim(CRUpre)=c(360,720,29)
CRUrad=rep(0,360*720*29)
dim(CRUrad)=c(360,720,29)

file_tp_name=c("/home/orchidee04/yyao/SHRtraining/newclimate/CRUNCEPv8/CRUNCEP annual ",
"/home/orchidee04/yyao/SHRtraining/newclimate/CRUNCEP/CRUNCEP annual ") 
tp_num=1 # 
for (year in 1985:2013) {

	tmp=readMat(paste(file_tp_name[tp_num],"temperature ",year,".mat",sep =""))
    annual_tmp=tmp$annual.temp
	
	pre=readMat(paste(file_tp_name[tp_num],"precipitation ",year,".mat",sep =""))
    annual_pre=pre$annual.prec
	
	rad=readMat(paste(file_tp_name[tp_num],"radiation ",year,".mat",sep =""))
    annual_rad=rad$annual.rad  

	CRUtmp[,,year-1984]=annual_tmp
	CRUpre[,,year-1984]=annual_pre
	CRUrad[,,year-1984]=annual_rad
}


overlap=readMat("/home/orchidee04/yyao/SHRtraining/newclimate/newoverlap.mat")
overlap_mask=overlap$newmask
#model_name=c("CABLE","CLASS-CTEM","CLM4.5","DLEM","ISAM","JSBACH","JULES","LPJ","LPX","OCN","ORCHIDEE-MICT","ORCHIDEE","SDGVM","SURFEX","VEGAS","VISIT")
model_name=c("CABLE","CLASS-CTEM","CLM4.5","ISAM","JSBACH","JULES","LPX","OCN","ORCHIDEE-MICT","ORCHIDEE","VEGAS","VISIT")

for (model_num in 1:12) {

	trendy=readMat(paste0("/home/orchidee04/yyao/TRENDYv6/1980-2013 ",model_name[model_num],"_S3_rh_1degC_annual sum.mat"))
	trendy_SHR=trendy$rh.annual.sum
	trendy_SHR=trendy_SHR[,,6:34]
	trendy_SHR=aperm(trendy_SHR,c(2,1,3))
	trendy_SHR05=rep(NA,360*720*29)
	dim(trendy_SHR05)=c(360,720,29)
	for (year in 1:29) {
		for (rows in 1:180) {
			for (cols in 1:360) {
			    rep_var=rep(trendy_SHR[rows,cols,year],2*2)
				dim(rep_var)=c(2,2)
				trendy_SHR05[c((rows*2-1):(rows*2)),c((cols*2-1):(cols*2)),year]=rep_var
			}
		}
		trendy_SHR05[,,year]=cbind(trendy_SHR05[,361:720,year],trendy_SHR05[,1:360,year])
	}
	trendy_SHR05=trendy_SHR05[360:1,,]
	
	trendy=readMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/TRENDYsoilw/TRENDYsoilw ",model_name[model_num]," ",
	"1980-2013.mat"))
	trendy_soilw=trendy$annual.soilw
	trendy_soilw=trendy_soilw[,,6:34]
	
	trendy_soilw05=rep(NA,360*720*29)
	dim(trendy_soilw05)=c(360,720,29)
	for (year in 1:29) {
		for (rows in 1:180) {
			for (cols in 1:360) {
			    rep_var=rep(trendy_soilw[rows,cols,year],2*2)
				dim(rep_var)=c(2,2)
				trendy_soilw05[c((rows*2-1):(rows*2)),c((cols*2-1):(cols*2)),year]=rep_var
			}
		}
		trendy_soilw05[,,year]=cbind(trendy_soilw05[,361:720,year],trendy_soilw05[,1:360,year])
	}
	
	
	premodel_tmp=rep(NA,360*720*29)
	dim(premodel_tmp)=c(360,720,29)
	premodel_pre=rep(NA,360*720*29)
	dim(premodel_pre)=c(360,720,29)
	premodel_rad=rep(NA,360*720*29)
	dim(premodel_rad)=c(360,720,29)
	
	YSHR_anoma=rep(NA,360*720*29)
	dim(YSHR_anoma)=c(360,720,29)
	
	swcmodel_tmp=rep(NA,360*720*29)
	dim(swcmodel_tmp)=c(360,720,29)
	swcmodel_swc=rep(NA,360*720*29)
	dim(swcmodel_swc)=c(360,720,29)
	swcmodel_rad=rep(NA,360*720*29)
	dim(swcmodel_rad)=c(360,720,29)
			
	pre_sens_tmp=rep(NA,360*720)
	dim(pre_sens_tmp)=c(360,720)
	pre_sens_pre=rep(NA,360*720)
	dim(pre_sens_pre)=c(360,720)
	pre_sens_rad=rep(NA,360*720)
	dim(pre_sens_rad)=c(360,720)
	
	swc_sens_tmp=rep(NA,360*720)
	dim(swc_sens_tmp)=c(360,720)
	swc_sens_swc=rep(NA,360*720)
	dim(swc_sens_swc)=c(360,720)
	swc_sens_rad=rep(NA,360*720)
	dim(swc_sens_rad)=c(360,720)
			
	for (rows in 1:360) {
		for (cols in 1:720) {
			tas_tt=CRUtmp[rows,cols,]
			pre_tt=CRUpre[rows,cols,]
			rad_tt=CRUrad[rows,cols,]
			SHR_tt=trendy_SHR05[rows,cols,]
			soilw_tt=trendy_soilw05[rows,cols,]
			if (sum(!is.na(tas_tt))==29 & sum(!is.na(pre_tt))==29 & sum(!is.na(rad_tt))==29 & 
			sum(!is.na(SHR_tt))==29 & sum(!is.na(soilw_tt))==29){
				tas_anoma=detrend(tas_tt)
				pre_anoma=detrend(pre_tt)
				rad_anoma=detrend(rad_tt)
				SHR_anoma=detrend(SHR_tt)
				swc_anoma=detrend(soilw_tt)
				
				premodel=lm(SHR_anoma ~ tas_anoma+pre_anoma+rad_anoma-1)
				
				premodel_tmp[rows,cols,]=premodel$coefficients[1]*tas_anoma
				premodel_pre[rows,cols,]=premodel$coefficients[2]*pre_anoma
				premodel_rad[rows,cols,]=premodel$coefficients[3]*rad_anoma
				
				YSHR_anoma[rows,cols,]=SHR_anoma	
				
				pre_sens_tmp[rows,cols]=premodel$coefficients[1]
				pre_sens_pre[rows,cols]=premodel$coefficients[2]
				pre_sens_rad[rows,cols]=premodel$coefficients[3]
				
				swcmodel=lm(SHR_anoma ~ tas_anoma+swc_anoma+rad_anoma-1)
				swcmodel_tmp[rows,cols,]=swcmodel$coefficients[1]*tas_anoma
				swcmodel_swc[rows,cols,]=swcmodel$coefficients[2]*swc_anoma
				swcmodel_rad[rows,cols,]=swcmodel$coefficients[3]*rad_anoma
				
				swc_sens_tmp[rows,cols]=swcmodel$coefficients[1]
				swc_sens_swc[rows,cols]=swcmodel$coefficients[2]
				swc_sens_rad[rows,cols]=swcmodel$coefficients[3]
						
			}
		}
	}
	
	writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/PRE TRENDY ",model_name[model_num]," 1985-2013.mat"),
			premodel_tmp=premodel_tmp,premodel_pre=premodel_pre,premodel_rad=premodel_rad,
			pre_sens_tmp=pre_sens_tmp,pre_sens_pre=pre_sens_pre,pre_sens_rad=pre_sens_rad)	
	
	writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SWC TRENDY ",model_name[model_num]," 1985-2013.mat"),
			swcmodel_tmp=swcmodel_tmp,swcmodel_swc=swcmodel_swc,swcmodel_rad=swcmodel_rad,
			swc_sens_tmp=swc_sens_tmp,swc_sens_swc=swc_sens_swc,swc_sens_rad=swc_sens_rad)
			
	writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/Regress0823/SHRanomaly TRENDY ",model_name[model_num],"1985-2013.mat"),YSHR_anoma=YSHR_anoma)

	
	premodel_rec=premodel_tmp+premodel_pre+premodel_rad		
	
	premodel_IAV=rep(NA,29*5)
	dim(premodel_IAV)=c(29,5)
	for (year in 1:29) {
		sSHR=premodel_tmp[,,year]*global_area*overlap_mask
		sarea=(!is.na(premodel_tmp[,,year]))*global_area*overlap_mask
		premodel_IAV[year,1]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
		
		sSHR=premodel_pre[,,year]*global_area*overlap_mask
		sarea=(!is.na(premodel_tmp[,,year]))*global_area*overlap_mask
		premodel_IAV[year,2]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
		
		sSHR=premodel_rad[,,year]*global_area*overlap_mask
		sarea=(!is.na(premodel_tmp[,,year]))*global_area*overlap_mask
		premodel_IAV[year,3]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
		
		sSHR=YSHR_anoma[,,year]*global_area*overlap_mask
		sarea=(!is.na(premodel_tmp[,,year]))*global_area*overlap_mask
		premodel_IAV[year,4]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
		
		sSHR=premodel_rec[,,year]*global_area*overlap_mask
		sarea=(!is.na(premodel_tmp[,,year]))*global_area*overlap_mask
		premodel_IAV[year,5]=sum(sSHR,na.rm=T)/sum(sarea,na.rm=T)
	}

	swcmodel_rec=swcmodel_tmp+swcmodel_swc+swcmodel_rad

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
			
			
	writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/factIAV0823/factIAV PRE TRENDY ",model_name[model_num]," 1985-2013.mat"),premodel_IAV=premodel_IAV)
	writeMat(paste0("/home/orchidee04/yyao/SHRtraining/newclimate/factIAV0823/factIAV SWC TRENDY ",model_name[model_num]," 1985-2013.mat"),swcmodel_IAV=swcmodel_IAV)
	
}




