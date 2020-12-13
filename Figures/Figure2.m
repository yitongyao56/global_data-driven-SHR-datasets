tpname={'cruncep','crujra','princeton','wfdeicru','wfdeigpcc','cpc'};
id_gpp_name={'GPP_1','GPP_2','GPP_3','GPP_4','GPP_5','GPP_6','PmodelGPP'};
id_soilw_name={'soilw','TWS','GLDAS'};
obs_all=nan(455,126);preds_all=nan(455,126);aa=0;
R2_all=nan(126,1);RMSE_all=nan(126,1);
for tp_num=1:6
    tpdata=tpname{tp_num};
    for gpp_num=1:7
        for soilw_num=1:3
            load(['E:\SHRms 20200113\SHRms\newclimate\LOOCV\LOOCV ',tpdata,' ',id_gpp_name{gpp_num},' ',id_soilw_name{soilw_num},'.mat']);
            obs=cv_all_obs.cv_test_obs;
            pred=cv_all_pred.cv_test_preds;
            aa=aa+1;
            obs_all(:,aa)=obs;
            preds_all(:,aa)=pred;
            rr=regstats(pred,obs);
            R2_all(aa)=rr.rsquare;
            RMSE_all(aa)=sqrt(rr.mse);
        end
    end
end
obs_mean=nanmean(obs_all,2);
obs_std=nanstd(obs_all,[],2);
preds_mean=nanmean(preds_all,2);
preds_std=nanstd(preds_all,[],2);

[~,~,vegs]=xlsread('D:\work\extract SRDB.xlsx','location');
vegs=vegs(2:end,:);

types=unique(vegs(:,3));
newcm=cbrewer('qual','Set1',7,'cubic');

tpname={'cruncep','crujra','princeton','wfdeicru','wfdeigpcc','cpc'};
id_gpp_name={'GPP_1','GPP_2','GPP_3','GPP_4','GPP_5','GPP_6','PmodelGPP'};
id_soilw_name={'soilw','TWS','GLDAS'};

vars={'LC','MAT','MAP','MAR','Ndep','SC','TC','totalC','totalN'};
aa=0;
group_varIM=nan(126,11);
for tp_num=1:6
    tpdata=tpname{tp_num};
    for gpp_num=1:7
        for soil_num=1:3
            aa=aa+1;
            load(['D:\LSCE\SHRms\newclimate\qrfmodel\QRF ',tpdata,' ',id_gpp_name{gpp_num},' ',id_soilw_name{soil_num},'.mat'])
            for var=1:9
                rows=find(strcmp(varname,vars{var}));
                group_varIM(aa,var)=importance(rows,1);
            end
            rows=find(strcmp(varname,id_gpp_name{gpp_num}));
            group_varIM(aa,10)=importance(rows,1);
            rows=find(strcmp(varname,id_soilw_name{soil_num}));
            group_varIM(aa,11)=importance(rows,1);
        end
    end
end


%% new figure 2
figure;set(gcf,'position',[100 100 900 400])
axes('position',[.1 .15 .35 .7])
% plot(obs_mean,preds_mean,'k.','markersize',15);hold on;
% errorbar(obs_mean,preds_mean,preds_std,'linestyle','none','color','k')
for i=1:length(types)
    rows=find(strcmp(vegs(:,3),types{i}));
    plot(obs_mean(rows),preds_mean(rows),'.','markersize',15,'color',newcm(i,:));hold on;
    errorbar(obs_mean(rows),preds_mean(rows),preds_std(rows),'linestyle','none','color',newcm(i,:));  
end
axis([0,1600,0,1600])
set(gca,'fontsize',13)
xlabel('Observed annual SHR (gC m^{-2} yr^{-1})','fontsize',14)
ylabel('Predicted annual SHR (gC m^{-2} yr^{-1})','fontsize',14)
set(gca,'xtick',0:500:1500)
set(gca,'ytick',0:500:1500)

line([0 1600],[0 1600],'color','r','linestyle','--','linewidth',2)

text(100,1400,['R^{2}= ',num2str(roundn(mean(R2_all),-2))],'fontsize',13)
text(100,1250,['RMSE= ',num2str(round(mean(RMSE_all))),' gC m^{-2} yr^{-1}'],'fontsize',13)

text(15,1660,'(a)','fontsize',14)

axes('position',[.6 .15 .35 .7])
error_varIM=std(group_varIM);
[sort_var,order]=sort(mean(group_varIM),'descend');
error_varIM=error_varIM(order);
hb=barh(sort_var);
for i=1:11
    line([sort_var(i)-error_varIM(i) sort_var(i)+error_varIM(i)],[i i],'color','k')
end
set(hb,'facecolor','w')
xlabel('%Inc MSE','fontsize',14);
varslabel={'Land cover','MAT','MAP','MAR','Ndep','Subsoil C','Topsoil C','total C','total N','GPP','soil moisture'};
text(0.1,12.5,'(b)','fontsize',14)

set(gca,'yticklabel',varslabel(order),'fontsize',13)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 9 4.5])
print(gcf,'-dtiff','-r300',['D:\LSCE\SHRms\Figure 2.tif'])
