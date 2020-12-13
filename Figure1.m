[~,~,location]=xlsread('D:\work\extract SRDB.xlsx',8);
types=unique(location(:,3));
types=types(1:7);
for i=1:7
    rows=find(strcmp(location(:,3),types{i,1}));
    types{i,2}=length(rows);
end
addpath('D:\work\cbrewer\cbrewer')
load('D:\work\MCD12Q1\reclassify\MODIS land cover yr 2001.mat')
newclassLC=nan(360,720);
newclassLC(classLC==1)=3;
newclassLC(classLC==3)=2;
newclassLC(classLC==2)=1;
newclassLC(classLC==4)=4;
newclassLC(classLC==5)=5;
newclassLC(classLC==6)=7;
newclassLC(classLC==7)=6;
newcm=cbrewer('qual','Set1',7,'cubic');
% mapcm=[newcm(3,:);newcm(1,:);newcm(2,:);newcm(4,:);newcm(5,:);newcm(7,:);newcm(6,:)];
% mapcm=mapcm.*2.3;
% mapcm(mapcm>1)=1;
mapcm=cbrewer('qual','Pastel1',7,'cubic');
geoidlegend=[2,90,0];
%%
figure;set(gcf,'position',[100 100 800 400])
load('coast')
axes('position',[.05 .05 .6 .8])
new_nee=[newclassLC(:,361:720),newclassLC(:,1:360)];
axesm eckert4;   
framem; gridm; 
axis off ;
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(land,'FaceColor', 'none'); 
h=geoshow(flipud(new_nee), geoidlegend, 'DisplayType', 'texturemap');
set(h,'facealpha','texturemap','alphadata',double(~isnan(flipud(new_nee))))
caxis([1 7])
plotm(lat,long,'k-')
newcm=mapcm;
colormap(newcm)
axes('position',[.05 .05 .6 .8])
axesm eckert4; 
framem; 
plotm(lat,long,'k')
newcm=cbrewer('qual','Set1',7,'cubic');
for i=1:7
    rows=find(strcmp(types{i},location(:,3)));
    latlat=cell2mat(location(rows,1));
    lonlon=cell2mat(location(rows,2));
    plotm(latlat,lonlon,'o','color',newcm(i,:),'markersize',6,'linewidth',2)
end
axis off;
axes('position',[.6 .4 .03 .1])
axis off;
new_sites=xlsread('D:\LSCE\ReHet-master\new_siteslevel.csv');
obs_lc=xlsread('D:\LSCE\ReHet-master\obs_lc.csv');
type_code=[10,11,1,100,101,111,110];
count_sites=nan(7,1);
for i=1:7
    row=find(obs_lc(:,2)==type_code(i));
    count_sites(i)=length(unique(new_sites(row,2)));
end
text(0.7,1.45,['Agriculture (',num2str(count_sites(1)),' sites, 29 site-years)'],'color',newcm(1,:),'fontsize',13);
text(0.7,1,['Desert (',num2str(count_sites(2)),' site, 1 site-year)'],'color',newcm(2,:),'fontsize',13);
text(0.7,0.55,['Forest (',num2str(count_sites(3)),' sites, 369 site-years)'],'color',newcm(3,:),'fontsize',13);
text(0.7,0.1,['Grassland (',num2str(count_sites(4)),' sites, 48 site-years)'],'color',newcm(4,:),'fontsize',13);
text(0.7,-0.35,['Savanna (',num2str(count_sites(5)),' site, 1 site-year)'],'color',newcm(5,:),'fontsize',13);
text(0.7,-0.8,['Shrubland (',num2str(count_sites(6)),' sites, 3 site-years)'],'color',newcm(6,:),'fontsize',13);
text(0.7,-1.25,['Wetland (',num2str(count_sites(7)),' sites, 4 site-years)'],'color',newcm(7,:),'fontsize',13);

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4])
print(gcf,'-dtiff','-r300',['D:\LSCE\ReHet-master\Figure 1.tif'])
