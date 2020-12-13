load('E:\SHRms 20200113\SHRms\newclimate\0823global_premodel_IAV.mat')
mean_premodel_IAV=nan(29,5);
std_premodel_IAV=nan(29,5);
for num=1:5   
   	for year=1:29
        temp=squeeze(global_premodel_IAV(1:5,[1,3],:,num,year));
        mean_premodel_IAV(year,num)=mean(temp(:));
        std_premodel_IAV(year,num)=std(temp(:));
    end
end

load('E:\SHRms 20200113\SHRms\newclimate\0823global_swcmodel_IAV.mat')
mean_swcmodel_IAV=nan(29,5);
std_swcmodel_IAV=nan(29,5);
for num=1:5   
   	for year=1:29
        temp=squeeze(global_swcmodel_IAV(1:5,[1,3],:,num,year));
        mean_swcmodel_IAV(year,num)=mean(temp(:));
        std_swcmodel_IAV(year,num)=std(temp(:));
    end
end

load('E:\SHRms 20200113\SHRms\newclimate\0823TRENDYglobal_premodel_IAV.mat')
trendy_mean_premodel_IAV=nan(29,5);
trendy_std_premodel_IAV=nan(29,5);
for num=1:5   
   	for year=1:29
        temp=squeeze(global_premodel_IAV([1:12],num,year));
        trendy_mean_premodel_IAV(year,num)=mean(temp(:));
        trendy_std_premodel_IAV(year,num)=std(temp(:));
    end
end

corr(trendy_mean_premodel_IAV(:,2),trendy_mean_premodel_IAV(:,4))
corr(trendy_mean_premodel_IAV(:,1),trendy_mean_premodel_IAV(:,4))
corr(trendy_mean_premodel_IAV(:,5),trendy_mean_premodel_IAV(:,4))

load('E:\SHRms 20200113\SHRms\newclimate\0823TRENDYglobal_swcmodel_IAV.mat')
trendy_mean_swcmodel_IAV=nan(29,5);
trendy_std_swcmodel_IAV=nan(29,5);
for num=1:5   
   	for year=1:29
        temp=squeeze(global_swcmodel_IAV([1:12],num,year));
        trendy_mean_swcmodel_IAV(year,num)=mean(temp(:));
        trendy_std_swcmodel_IAV(year,num)=std(temp(:));
    end
end

addpath('E:\SHRms 20200113\SHRms')
figure;set(gcf,'position',[10 50 1000 600])
axes('position',[.1 .53 .4 .4]);
fill_spread2(mean_premodel_IAV,std_premodel_IAV,1998,-3,0.8,'Precipitation')
ylabel('SHR IAV ','fontsize',14)
text(1986,3.5,'(a)','fontsize',14)
ylim([-6 4])
set(gca,'xticklabel',{''})
title('Random Forest','fontsize',14)

axes('position',[.55 .53 .4 .4]);
fill_spread2(trendy_mean_premodel_IAV,trendy_std_premodel_IAV,1998,-6,2.4,'Precipitation')
text(1986,13.5,'(b)','fontsize',14)
set(gca,'xticklabel',{''})
title('TRENDY','fontsize',14)
% ylim([-4 3])

axes('position',[.1 .1 .4 .4]);
fill_spread2(mean_swcmodel_IAV,std_swcmodel_IAV,1998,-3,0.8,'Soil moisture')
ylabel('SHR IAV ','fontsize',14)
text(1986,3.5,'(c)','fontsize',14)
ylim([-6 4])

axes('position',[.55 .1 .4 .4]);
fill_spread2(trendy_mean_swcmodel_IAV,trendy_std_swcmodel_IAV,1998,-6,2.4,'Soil moisture')
text(1986,13.5,'(d)','fontsize',14)
% ylim([-4 3])

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 6])
print(gcf,'-dtiff','-r300',['D:\LSCE\ReHet-master\1012 figure 5 all fill no CLIM.tif'])


