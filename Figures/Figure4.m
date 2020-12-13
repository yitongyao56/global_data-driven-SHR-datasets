load(['D:\work\new Sworld05.mat'],'newS')

load('E:\SHRms 20200113\SHRms\newclimate\0823 total SHR.mat')
mean_rh=nan(29,1);std_rh=nan(29,1);
for year=1:29
    temp=squeeze(totalSHR(:,year));
    mean_rh(year)=mean(temp(:));
    std_rh(year)=std(temp(:));
end


load('E:\SHRms 20200113\SHRms\TRENDYensemble_SHRinallyears.mat','trendy_model_all')
trendy_total=nan(29,14);
for model=1:14
    for year=1:29
        sSHR=squeeze(trendy_model_all(:,:,model,year)).*newS.*newmask;
        sarea=~isnan(trendy_model_all(:,:,model,year)).*newS.*newmask;
        trendy_total(year,model)=nansum(sSHR(:))./10^15;
    end
end
trendy_total=trendy_total(:,[1:3,5:11,13:14]);
trendy_mean=mean(trendy_total,2);
trendy_std=std(trendy_total,[],2);
load('E:\SHRms 20200113\SHRms\rh_hashimoto_test 1985-2012.mat','rh_hashimoto_test')
hashimoto_total=nan(28,1);
for year=1:28
    sSHR=squeeze(rh_hashimoto_test(:,:,year)).*newS.*newmask;
    sarea=~isnan(squeeze(rh_hashimoto_test(:,:,year))).*newS.*newmask;
    hashimoto_total(year,1)=nansum(sSHR(:))./10^15;
end
%%
figure;set(gcf,'position',[100 100 800 400])
%%% trendy model gray lines 
axes('position',[.1 .15 .6 .7])
% colors=[226 26 28;77 175 74;53 126 183]./255;
plot(1985:2013,mean_rh,'k-','linewidth',2);hold on;
plot(1985:2012,hashimoto_total,'color',[226 26 28]./255,'linewidth',2)
plot(1985:2013,trendy_mean,'color',[53 126 183]./255,'linewidth',2)
plot(1985:2013,trendy_total(:,1),'color',[172,201,216]./255);
xx=1985:2013;
rr=regstats(mean_rh,xx);
xline=rr.beta(2).*xx+rr.beta(1);
plot(xx,xline,'color','k','linestyle','--','linewidth',1)

ylim([35 75])
for i=1:12
    plot(1985:2013,trendy_total(:,i),'color',[172,201,216]./255);
end
xx=(1985:2013)';
y1=mean_rh-std_rh;y2=mean_rh+std_rh;
h = fill([xx; flipud(xx)],[y1; flipud(y2)],'k');
set(h,'FaceColor','k','EdgeColor','none','FaceAlpha',0.4,'EdgeAlpha',0);
rr=regstats(mean_rh,xx);
text(1986,73,['Trend: ',num2str(roundn(rr.beta(2),-2)),' Pg C yr^{-2}'],'fontsize',13,'color','k')

plot(1985:2012,hashimoto_total,'color',[226 26 28]./255,'linewidth',2)
xx=1985:2012;
rr=regstats(hashimoto_total,xx);
text(1986,69,['Trend: ',num2str(roundn(rr.beta(2),-2)),' Pg C yr^{-2}'],'fontsize',13,'color',[226 26 28]./255)

plot(1985:2013,trendy_mean,'color',[53 126 183]./255,'linewidth',2)
xx=(1985:2013)';
% y1=trendy_mean-trendy_std;y2=trendy_mean+trendy_std;
% h = fill([xx; flipud(xx)],[y1; flipud(y2)],'k');
% set(h,'FaceColor',[53 126 183]./255,'EdgeColor','none','FaceAlpha',0.2,'EdgeAlpha',0);

rr=regstats(trendy_mean,xx');
xline=rr.beta(2).*xx+rr.beta(1);
plot(xx,xline,'color',[53 126 183]./255,'linestyle','--','linewidth',2)
text(1986,65,['Trend: ',num2str(roundn(rr.beta(2),-2)),' Pg C yr^{-2}'],'fontsize',13,'color',[53 126 183]./255)

set(gca,'xtick',1985:5:2013)
set(gca,'fontsize',13)
ylabel('Global total SHR (Pg C yr^{-1})','fontsize',13)
xlim([1985 2013])

hl=legend('RF model','Hashimoto','TRENDY mean','TRENDY ensemble','linear regression');
set(hl,'position',[.815 .45 .08 .15],'box','off')

axes('position',[.4 .6 .3 .25])
xx=(1985:2013)';
plot(1985:2013,mean_rh,'k-','linewidth',2);hold on;
y1=mean_rh-std_rh;y2=mean_rh+std_rh;
h = fill([xx; flipud(xx)],[y1; flipud(y2)],'k');
set(h,'FaceColor','k','EdgeColor','none','FaceAlpha',0.4,'EdgeAlpha',0);
rr=regstats(mean_rh,xx);
xline=rr.beta(2).*xx+rr.beta(1);
plot(xx,xline,'color','k','linestyle','--','linewidth',2)

plot(1985:2012,hashimoto_total,'color',[226 26 28]./255,'linewidth',2)
set(gca,'yaxislocation','right')
set(gca,'xticklabel',{''})
set(gca,'fontsize',13)
xlim([1985 2013])
rr=regstats(hashimoto_total,(1985:2012)');
xline=rr.beta(2).*xx+rr.beta(1);
plot(xx,xline,'color',[226 26 28]./255,'linestyle','--','linewidth',2)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4])
print(gcf,'-dtiff','-r300',['D:\LSCE\ReHet-master\Figure 4.tif'])
