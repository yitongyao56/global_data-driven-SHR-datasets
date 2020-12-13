load('E:\SHRms 20200113\SHRms\Regress0823\ALL13premodel_newveg_IAV.mat')
load('E:\SHRms 20200113\SHRms\Regress0823\ALL13swcmodel_newveg_IAV.mat')
mean_premodel_IAV=nan(6,5,29);
std_premodel_IAV=nan(6,5,29);
for biome=1:6
    for num=1:5   
        for year=1:29
            temp=squeeze(premodel_IAV(:,biome,year,num));
            mean_premodel_IAV(biome,num,year)=mean(temp);
            std_premodel_IAV(biome,num,year)=std(temp);
        end
    end
end

mean_swcmodel_IAV=nan(6,5,29);
std_swcmodel_IAV=nan(6,5,29);
for biome=1:6
    for num=1:5   
        for year=1:29
            temp=squeeze(swcmodel_IAV(:,biome,year,num));
            mean_swcmodel_IAV(biome,num,year)=mean(temp);
            std_swcmodel_IAV(biome,num,year)=std(temp);
        end
    end
end
%% only CPC and GLDAS
land_cover={sprintf('Tropical forest'),sprintf('Extra-tropical forest'),...
    sprintf('Semi-arid'),sprintf('Arctic tundra'),sprintf('Grass crop'),sprintf('sparsely vegetated')};
bias=[3 1.2 1.5 1.5 0.7];
yest=[-8 -5.3 -4 -4 -1.3];
figure;set(gcf,'position',[10 50 1300 500])
for biome=1:5
    axes('position',[.05+(biome-1)*0.19 .52 .16 .4]);

    biome_IAV=squeeze(mean_premodel_IAV(biome,:,:))';
    biome_std=squeeze(std_premodel_IAV(biome,:,:))';
    if biome~=1
        fill_spread_NO2(biome_IAV,biome_std,1998,yest(biome),bias(biome),'Precipitation')
    else
        fill_spread2(biome_IAV,biome_std,1986,yest(biome),bias(biome),'Precipitation')        
    end
    set(gca,'xticklabel',{''})
    title(land_cover{biome},'fontsize',14)
    if biome==1
        ylabel('SHR IAV','fontsize',14)
    end
    if biome==3 || biome==4
        ylim([-10 8])
    end
    if biome==5
       ylim([-4 4]) 
    end
end

for biome=1:5
    axes('position',[.05+(biome-1)*0.19 .08 .16 .4]);

    biome_IAV=squeeze(mean_swcmodel_IAV(biome,:,:))';
    biome_std=squeeze(std_swcmodel_IAV(biome,:,:))';
    if biome~=1
        fill_spread_NO2(biome_IAV,biome_std,1998,yest(biome),bias(biome),'Soil Moisture')
    else
        fill_spread2(biome_IAV,biome_std,1986,yest(biome),bias(biome),'Soil Moisture')
    end
    if biome==1
        ylabel('SHR IAV','fontsize',14)
    end
    if biome==3 || biome==4
        ylim([-10 8])
    end
    if biome==5
       ylim([-4 4]) 
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 13 5])
print(gcf,'-dtiff','-r300',['D:\LSCE\ReHet-master\1012 newveg IAV.tif'])

%% %%  0825 TRENDY models
load('E:\SHRms 20200113\SHRms\Regress0823\ALLTRENDYpremodel_newveg_IAV.mat')
load('E:\SHRms 20200113\SHRms\Regress0823\ALLTRENDYswcmodel_newveg_IAV.mat')

mean_premodel_IAV=nan(6,5,29);
std_premodel_IAV=nan(6,5,29);
for biome=1:6
    for num=1:5   
        for year=1:29
            temp=squeeze(premodel_IAV(:,biome,year,num));
            mean_premodel_IAV(biome,num,year)=mean(temp);
            std_premodel_IAV(biome,num,year)=std(temp);
        end
    end
end

mean_swcmodel_IAV=nan(6,5,29);
std_swcmodel_IAV=nan(6,5,29);
for biome=1:6
    for num=1:5   
        for year=1:29
            temp=squeeze(swcmodel_IAV(:,biome,year,num));
            mean_swcmodel_IAV(biome,num,year)=mean(temp);
            std_swcmodel_IAV(biome,num,year)=std(temp);
        end
    end
end

land_cover={sprintf('Tropical forest'),sprintf('Extra-tropical forest'),...
    sprintf('Semi-arid'),sprintf('Actic tundra'),sprintf('Grass crop'),sprintf('sparsely vegetated')};
bias=[4 3 3 3 2.5];
yest=[-9 -8 -8 -8 -5];
figure;set(gcf,'position',[10 50 1300 500])
for biome=1:5
    axes('position',[.05+(biome-1)*0.19 .52 .16 .4]);

    biome_IAV=squeeze(mean_premodel_IAV(biome,:,:))';
    biome_std=squeeze(std_premodel_IAV(biome,:,:))';
    fill_spread_NO2(biome_IAV,biome_std,1998,yest(biome),bias(biome),'Precipitation')
    set(gca,'xticklabel',{''})
    title(land_cover{biome},'fontsize',14)
    if biome==1
        ylabel('SHR IAV','fontsize',14)
    end
    if biome==3 || biome==4
        ylim([-20 20])
    end
    if biome==5
       ylim([-15 15]) 
    end
    if biome==1
        ylim([-25 25])
    end
    if biome==2
        ylim([-20 20])
    end
end

for biome=1:5
    axes('position',[.05+(biome-1)*0.19 .08 .16 .4]);

    biome_IAV=squeeze(mean_swcmodel_IAV(biome,:,:))';
    biome_std=squeeze(std_swcmodel_IAV(biome,:,:))';
    fill_spread_NO2(biome_IAV,biome_std,1998,yest(biome),bias(biome),'Soil Moisture')
    if biome==1
        ylabel('SHR IAV','fontsize',14)
    end
   if biome==3 || biome==4
        ylim([-20 20])
    end
    if biome==5
       ylim([-15 15]) 
    end
    if biome==1
        ylim([-25 25])
    end
    if biome==2
        ylim([-20 20])
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 13 5])
print(gcf,'-dtiff','-r300',['D:\LSCE\ReHet-master\1012 TRENDY newveg IAV.tif'])
