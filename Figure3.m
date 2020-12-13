load('E:\SHRms 20200113\SHRms\newclimate\multimean annual SHR from 126.mat','YSHR_mean')
load('E:\SHRms 20200113\SHRms\rh_hashimoto_test 1985-2012.mat','rh_hashimoto_test')
load('E:\SHRms 20200113\SHRms\TRENDYmean_SHRinallyears.mat','trendy_model_mean')
load('E:\SHRms 20200113\SHRms\newoverlap.mat','newmask')
RF_mean=YSHR_mean.*newmask;
trendy_mean=nanmean(trendy_model_mean,3).*newmask;
rh_hashimoto_mean=nanmean(rh_hashimoto_test,3).*newmask;
RF_mean(RF_mean==0)=nan;
trendy_mean(trendy_mean==0)=nan;
rh_hashimoto_mean(rh_hashimoto_mean==0)=nan;
load('D:\LSCE\ReHet-master\koning RH reso05 month36.mat')
koning_rh_05_mean=nanmean(koning_rh_05,3);
koning_rh_05_mean(koning_rh_05_mean==0)=nan;
RF_figure=nan(360,720,3);
RF_figure(:,:,1)=RF_mean;
RF_figure(:,:,2)=rh_hashimoto_mean;
RF_figure(:,:,3)=koning_rh_05_mean;
RF_figure(:,:,4)=trendy_mean;
freq_SHR=nan(10,3);
for k=1:4
    shr=squeeze(RF_figure(:,:,k));
    for i=1:10
        temp=sum(sum(shr>=i*100-100 & shr<i*100));
        freq_SHR(i,k)=temp;
    end
    temp=sum(sum(shr>=1000));
    freq_SHR(11,k)=temp;
end
freq_SHR(1:11,1)=freq_SHR(1:11,1)/sum(freq_SHR(1:11,1));
freq_SHR(1:11,2)=freq_SHR(1:11,2)/sum(freq_SHR(1:11,2));
freq_SHR(1:11,3)=freq_SHR(1:11,3)/sum(freq_SHR(1:11,3));
freq_SHR(1:11,4)=freq_SHR(1:11,4)/sum(freq_SHR(1:11,4));

%%
geoidlegend=[2,90,0];
load('coast')
figure; set(gcf,'position',[100 10 700 500])
axes('position',[.01 .5 .5 .5])
rh_unc=RF_mean;
new_nee=[rh_unc(:,361:720),rh_unc(:,1:360)];
axesm eckert4;   
framem; %gridm;  %
axis off ;%
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land,'FaceColor', 'none'); 
h=geoshow(flipud(new_nee), geoidlegend, 'DisplayType', 'texturemap');
set(h,'facealpha','texturemap','alphadata',double(~isnan(flipud(new_nee))))
% land = shaperead('landareas', 'UseGeoCoords', true);
% geoshow(land,'FaceColor', 'none'); 
% plotm(lat,long,'k-')
caxis([0 1000])
newcm=cbrewer('div','Spectral',10,'cubic');
colormap(newcm)
annotation('textbox',[.01 .93 .3 0.04],'string','(a) RF mean','fontsize',14,'edgecolor','none')
% textm(-45,-170,'median','fontsize',14)
axes('position',[.05 .6 .1 .1])
plot(50:100:1050,freq_SHR(:,1),'linewidth',2);
xlim([0 1200])

axes('position',[.01 .1 .5 .5])
rh_unc=koning_rh_05_mean;
new_nee=[rh_unc(:,361:720),rh_unc(:,1:360)];
axesm eckert4; % 
framem; %gridm;  % 
axis off ;% 
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land,'FaceColor', 'none'); 
h=geoshow(flipud(new_nee), geoidlegend, 'DisplayType', 'texturemap');
set(h,'facealpha','texturemap','alphadata',double(~isnan(flipud(new_nee))))
% land = shaperead('landareas', 'UseGeoCoords', true);
% geoshow(land,'FaceColor', 'none'); 
% plotm(lat,long,'k-')
caxis([0 1000])
newcm=cbrewer('div','Spectral',10,'cubic');
colormap(newcm)
annotation('textbox',[.01 .53 .35 0.04],'string','(c) Top-down','fontsize',14,'edgecolor','none')
% textm(-45,-170,'Q1','fontsize',14)
axes('position',[.05 .2 .1 .1])
plot(50:100:1050,freq_SHR(:,3),'linewidth',2);
xlim([0 1200])


axes('position',[.5 .1 .5 .5])
rh_unc=trendy_mean;
new_nee=[rh_unc(:,361:720),rh_unc(:,1:360)];
axesm eckert4; %  
framem; %gridm;  %
axis off ;%
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land,'FaceColor', 'none'); 
h=geoshow(flipud(new_nee), geoidlegend, 'DisplayType', 'texturemap');
set(h,'facealpha','texturemap','alphadata',double(~isnan(flipud(new_nee))))
% land = shaperead('landareas', 'UseGeoCoords', true);
% geoshow(land,'FaceColor', 'none'); 
% plotm(lat,long,'k-')
caxis([0 1000])
newcm=cbrewer('div','Spectral',10,'cubic');
colormap(newcm)
annotation('textbox',[.5 .53 .35 0.04],'string','(d) TRENDY mean','fontsize',14,'edgecolor','none')
% textm(-45,-170,'median','fontsize',14)
% hc=colorbar( 'LineWidth',1,'location','southoutside','position',[0.05 0.15 0.4 0.02]);
% set(get(hc,'Xlabel'),'String','SHR (gC m^{-2} yr^{-1})','fontsize',13) ;
% %set(hc,'xtick',[0:50:400]);
% set(hc,'xtick',[0:200:1000]);
% set(hc,'fontsize',13)
axes('position',[.54 .2 .1 .1])
plot(50:100:1050,freq_SHR(:,4),'linewidth',2);
xlim([0 1200])

axes('position',[.5 .5 .5 .5])
% plot(50:100:1050,freq_SHR,'linewidth',2);
% ylabel('Frequency','fontsize',13)
% xlabel('SHR (gC m^{-2} yr^{-1})','fontsize',13)
% set(gca,'fontsize',13)
% set(gca,'xtick',0:200:1100)
% xlim([0 1100])
% hl=legend('RF mean','Hashimoto','TRENDY mean');
% set(hl,'box','off','location','northeast')
rh_unc=rh_hashimoto_mean;
new_nee=[rh_unc(:,361:720),rh_unc(:,1:360)];
axesm eckert4; %  
framem; %gridm;  %
axis off ;%
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land,'FaceColor', 'none'); 
h=geoshow(flipud(new_nee), geoidlegend, 'DisplayType', 'texturemap');
set(h,'facealpha','texturemap','alphadata',double(~isnan(flipud(new_nee))))
% land = shaperead('landareas', 'UseGeoCoords', true);
% geoshow(land,'FaceColor', 'none'); 
% plotm(lat,long,'k-')
caxis([0 1000])
newcm=cbrewer('div','Spectral',10,'cubic');
colormap(newcm)
annotation('textbox',[.5 .93 .35 0.04],'string','(b) Hashimoto','fontsize',14,'edgecolor','none')
% textm(-45,-170,'median','fontsize',14)
hc=colorbar( 'LineWidth',1,'location','southoutside','position',[0.09 0.12 0.85 0.02]);
set(get(hc,'Xlabel'),'String','SHR (gC m^{-2} yr^{-1})','fontsize',13) ;
%set(hc,'xtick',[0:50:400]);
set(hc,'xtick',[0:200:1000]);
set(hc,'fontsize',13)
axes('position',[.54 .6 .1 .1])
plot(50:100:1050,freq_SHR(:,2),'linewidth',2);
xlim([0 1200])

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 7 5])
print(gcf,'-dtiff','-r300',['D:\LSCE\ReHet-master\Figure 3.tif'])
