
load('E:\SHRms 20200113\SHRms\newoverlap.mat')
load('E:\SHRms 20200113\SHRms\Regress0823\PREmodel_sensitivity_tmp.mat')
PREmodel_tmp=nan(360,720);
for rows=1:360
    for cols=1:720
        temp=squeeze(PREmodel_sens_tmp(:,:,:,rows,cols));
        PREmodel_tmp(rows,cols)=nanmean(temp(:));
    end
end
clear PREmodel_sens_tmp
%%

addpath('D:\work\cbrewer\cbrewer')
PREmodel_tmp=PREmodel_tmp.*newmask;
PREmodel_tmp(PREmodel_tmp==0)=nan;
load('coast')
geoidlegend=[2,90,0];
figure;set(gcf,'position',[100 100 800 400])
axes('position',[.1 .18 .8 .8])
new_nee=[PREmodel_tmp(:,361:720),PREmodel_tmp(:,1:360)];
axesm eckert4; %注意axesm后面的m,可以使用maps命令查看所有的地图投影的方式,然后选一个  
framem; gridm;  %显示框架和网格线,注意后面都多了个m,表示map  
axis off ;%关闭外部坐标轴,外部坐标轴不同于map axes  
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land,'FaceColor', 'none'); 
h=geoshow(flipud(new_nee), geoidlegend, 'DisplayType', 'texturemap');
set(h,'facealpha','texturemap','alphadata',double(~isnan(flipud(new_nee))))
% land = shaperead('landareas', 'UseGeoCoords', true);
% geoshow(land,'FaceColor', 'none'); 
caxis([-20 20])
plotm(lat,long,'k-')
newcm=cbrewer('div','RdBu',10,'cubic');
newcm=newcm(2:9,:);
colormap(newcm)
%freezeColors;
hc=colorbar( 'LineWidth',1,'location','southoutside','position',[0.15 0.15 0.7 0.03]);
set(get(hc,'Xlabel'),'String','SHR sensitivity to temperature (gC m^{-2} yr^{-1} ^{o}C^{-1})','fontsize',13) ;
set(gca,'fontsize',13)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4])
print(gcf,'-dtiff','-r300',['D:\LSCE\SHRms\Figure 7 temperature sensitivity.tif'])

load('D:\LSCE\SHRms\Regress0823\PREmodel_sensitivity_pre.mat')
PREmodel_pre=nan(360,720);
for rows=1:360
    for cols=1:720
        temp=squeeze(PREmodel_sens_pre(:,[2],:,rows,cols));
        PREmodel_pre(rows,cols)=nanmean(temp(:));
    end
end
clear PREmodel_sens_pre
PREmodel_pre=PREmodel_pre.*100;

PREmodel_pre=PREmodel_pre.*newmask;
PREmodel_pre(PREmodel_pre==0)=nan;
load('coast')
geoidlegend=[2,90,0];
figure;set(gcf,'position',[100 100 800 400])
axes('position',[.1 .18 .8 .8])
new_nee=[PREmodel_pre(:,361:720),PREmodel_pre(:,1:360)];
axesm eckert4; %注意axesm后面的m,可以使用maps命令查看所有的地图投影的方式,然后选一个  
framem; gridm;  %显示框架和网格线,注意后面都多了个m,表示map  
axis off ;%关闭外部坐标轴,外部坐标轴不同于map axes  
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land,'FaceColor', 'none'); 
h=geoshow(flipud(new_nee), geoidlegend, 'DisplayType', 'texturemap');
set(h,'facealpha','texturemap','alphadata',double(~isnan(flipud(new_nee))))
% land = shaperead('landareas', 'UseGeoCoords', true);
% geoshow(land,'FaceColor', 'none'); 
caxis([-20 20])
plotm(lat,long,'k-')
newcm=cbrewer('div','RdBu',10,'cubic');
newcm=newcm(2:9,:);
colormap(newcm)
%freezeColors;
hc=colorbar( 'LineWidth',1,'location','southoutside','position',[0.15 0.15 0.7 0.03]);
set(get(hc,'Xlabel'),'String','SHR sensitivity to precipitation (gC m^{-2} yr^{-1} 100mm^{-1})','fontsize',13) ;
set(gca,'fontsize',13)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4])
print(gcf,'-dtiff','-r300',['D:\LSCE\SHRms\Figure 7 prec sensitivity.tif'])

