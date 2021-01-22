clear
pfs_all = uigetfilemult('*.mat');
FiringRate = zeros(length(pfs_all),7);
zs_firingrate = zeros(length(pfs_all),5);
for i=1:length(pfs_all)
    mat_cri = load(pfs_all{i});
    firingrate_baseline = mean(mat_cri.base_spknum);
    std_baseline = std(mat_cri.base_spknum);
    firingrate_base = sum(mat_cri.SPK>(mat_cri.dur_putin(1)-50)&...
        mat_cri.SPK<(mat_cri.dur_putin(1)-10))/40;
    firingrate_putin = sum(mat_cri.SPK>mat_cri.dur_putin(1)&...
        mat_cri.SPK<mat_cri.dur_putin(2))/diff(mat_cri.dur_putin);
    %     firingrate_putin = sum(mat_cri.SPK>mat_cri.dur_putin(1)&...
    %         mat_cri.SPK<mat_cri.dur_chase(1))/diff([mat_cri.dur_putin(1),mat_cri.dur_chase(1)]);
    firingrate_chase = sum(mat_cri.SPK>mat_cri.dur_chase(1)&...
        mat_cri.SPK<mat_cri.dur_chase(2))/diff(mat_cri.dur_chase);
    firingrate_attack = sum(mat_cri.SPK>mat_cri.dur_attack(1)&...
        mat_cri.SPK<mat_cri.dur_attack(2))/diff(mat_cri.dur_attack);
    firingrate_eating = sum(mat_cri.SPK>mat_cri.dur_eating(1)&...
        mat_cri.SPK<mat_cri.dur_eating(2))/diff(mat_cri.dur_eating);
    FiringRate(i,:) = [firingrate_baseline,firingrate_base,firingrate_putin,firingrate_chase,firingrate_attack,firingrate_eating,std_baseline];
end
delt_FiringRate = [FiringRate(:,2)-FiringRate(:,1),...
    FiringRate(:,3)-FiringRate(:,1),FiringRate(:,4)-FiringRate(:,1),FiringRate(:,5)-FiringRate(:,1),FiringRate(:,6)-FiringRate(:,1)];
for i=1:length(pfs_all)
    zs_firingrate(i,:) = delt_FiringRate(i,1:5)./FiringRate(i,7);
end
%% plot all delt firing rate
figure;
[~,ind] = sort(mean(delt_FiringRate(:,3),2),'descend');% sort by chase activity
a = delt_FiringRate(ind,:);
imagesc(a',[-15,25]);
colorbar;
colormap('jet');
set (gca,'box','off','linewidth',2,'fontsize',15);
xlabel('cell #')
set(gca,'ytick',1:5,'yTickLabel',{'Baseline','Introduction','Chase','Attack','Comsuption'});
title(['Average activity (mean substracted sp/s)']);
%% 计算PCA和聚类
[COEFF,SCORE,latent,tsquare] = princomp(zs_firingrate);
PCA_score = SCORE(:,1:3);
Z = linkage(PCA_score,'complete','euclidean');
% D = pdist(zs_firingrate);
% leafOrder = optimalleaforder(Z,D);
%% 作图
figure;
subplot(1,10,1:3);
[H,~,outperm] = dendrogram(Z,0,'Orientation','left','ColorThreshold', 5);
set(gca,'ytick',[]);
subplot(1,10,5);
imagesc(PCA_score(fliplr(outperm),:),[-3 3]);
colormap(gca,'gray');
subplot(1,10,6:10);
a = zs_firingrate(fliplr(outperm),:);
imagesc(a,[-5,5]);
colorbar;
colormap(gca,'jet');
% set (gca,'box','off','linewidth',2,'fontsize',15);
% ylabel('cell #')
set(gca,'xtick',1:5,'xTickLabel',{'Baseline','Introduction','Chase','Attack','Comsuption'});
title('Zscore');
%% zscore 227 220 217 224 221
T = cluster(Z,'maxclust',5);%按照图上几类修改最大clust参数
figure;hist(T,0:20)
cluster_num = 4;%%输入cluster的第几类
a = zs_firingrate(T==cluster_num,:);
figure;
imagesc(a,[-5,5]);
colorbar;
colormap('jet');
set (gca,'box','off','linewidth',2,'fontsize',15);
ylabel('cell #')
set(gca,'xtick',1:5,'xTickLabel',{'Baseline','Introduction','Chase','Attack','Comsuption'});
title(['Zscore']);
figure;
plot(a','k.','markersize',15);hold on;
plot(median(a),'k','linewidth',2);
xlim([0.5 5.5]);
ylabel('Zscore')
set (gca,'box','off','linewidth',2,'fontsize',15);
set(gca,'xtick',[1 2 3 4 5 ],'xticklabel',{'Bas','Int','Cha','Att','Com'});
figure;
errorbar(median(a),std(a)/(size(a,1)^0.5),'ro');
%%
return;
% set(H,'LineWidth',2)
% scatter3(PCA_score(:,1),PCA_score(:,2),PCA_score(:,3),35,c,'.')
% CGobj = clustergram(PCA_score,'cluster','column','colormap','gray','Linkage','complete');
% sort by clustering ind
figure;
% [c_idx,c_ind] = sort(idx);
% a = [zs_firingrate(c_ind,:),c_idx];
a = zs_firingrate(flipud(str2num(cell2mat(CGobj.RowLabels))),:);
imagesc(a,[-5,5]);
colorbar;
colormap('jet');
set (gca,'box','off','linewidth',2,'fontsize',15);
ylabel('cell #')
set(gca,'xtick',1:5,'xTickLabel',{'Baseline','Introduction','Chase','Attack','Comsuption'});
title(['Zscore']);
%
figure;
% CGStruct = clusterGroup(CGobj, 33, 'row', 'InfoOnly', true);
plot3(PCA_score(:,1),PCA_score(:,2),PCA_score(:,3),'.','markersize',15); hold on;
plot3(PCA_score(1:36,1),PCA_score(1:36,2),PCA_score(1:36,3),'.','markersize',15);
CGStruct = clusterGroup(CGobj, 43, 'row', 'InfoOnly', true);
plot3(CGStruct.ExprValues(:,1),CGStruct.ExprValues(:,2),CGStruct.ExprValues(:,3),'o','markersize',10);
% CGStruct = clusterGroup(CGobj, 218, 'row', 'InfoOnly', true);
% plot3(CGStruct.ExprValues(:,1),CGStruct.ExprValues(:,2),CGStruct.ExprValues(:,3),'.','markersize',15);
% CGStruct = clusterGroup(CGobj, 221, 'row', 'InfoOnly', true);
% plot3(CGStruct.ExprValues(:,1),CGStruct.ExprValues(:,2),CGStruct.ExprValues(:,3),'.','markersize',15);
% CGStruct = clusterGroup(CGobj, 225, 'row', 'InfoOnly', true);
% plot3(CGStruct.ExprValues(:,1),CGStruct.ExprValues(:,2),CGStruct.ExprValues(:,3),'.','markersize',15);
xlabel('PC 1');
ylabel('PC 2');
zlabel('PC 3');
%%
CGStruct = clusterGroup(CGobj, 291, 'row', 'InfoOnly', true);
a1 = zs_firingrate(flipud(str2num(cell2mat(CGStruct.RowNodeNames))),:);
CGStruct = clusterGroup(CGobj, 26, 'row', 'InfoOnly', true);
a2 = zs_firingrate(flipud(str2num(cell2mat(CGStruct.RowNodeNames))),:);
CGStruct = clusterGroup(CGobj, 23, 'row', 'InfoOnly', true);
a3 = zs_firingrate(flipud(str2num(cell2mat(CGStruct.RowNodeNames))),:);
CGStruct = clusterGroup(CGobj, 224, 'row', 'InfoOnly', true);
a4 = zs_firingrate(flipud(str2num(cell2mat(CGStruct.RowNodeNames))),:);
CGStruct = clusterGroup(CGobj, 221, 'row', 'InfoOnly', true);
a5 = zs_firingrate(flipud(str2num(cell2mat(CGStruct.RowNodeNames))),:);
%%
plot_a = a;
figure;
plot(plot_a','k.','markersize',15);hold on;
plot(median(plot_a),'k','linewidth',2);
xlim([0.5 5.5]);
ylabel('Zscore')
set (gca,'box','off','linewidth',2,'fontsize',15);
set(gca,'xtick',[1 2 3 4 5 ],'xticklabel',{'Bas','Int','Cha','Att','Com'});
%%
[~,~,stats] = anova1(a);
multcompare(stats);
