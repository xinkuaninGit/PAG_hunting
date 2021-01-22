pfs = uigetfilemult('*_hunt_new.mat');
Alg_baseline = cell(length(pfs),1);
Alg_putin = cell(length(pfs),1);
Alg_att = cell(length(pfs),1);
Alg_chase = cell(length(pfs),1);
Alg_eat = cell(length(pfs),1);
for i=1:length(pfs)
mat = load(pfs{i});
Alg_baseline{i} = mat.SPK(mat.SPK>mat.dur_putin(1)-30&mat.SPK<mat.dur_putin(1)-10)-mat.dur_putin(1)+20;
Alg_putin{i} = mat.SPK(mat.SPK>mat.dur_putin(1)-5&mat.SPK<mat.dur_putin(1)+5)-mat.dur_putin(1);
Alg_chase{i} = mat.SPK(mat.SPK>mat.dur_chase(1)-5&mat.SPK<mat.dur_chase(1)+5)-mat.dur_chase(1);
Alg_att{i} = mat.SPK(mat.SPK>mat.dur_attack(1)-5&mat.SPK<mat.dur_attack(1)+5)-mat.dur_attack(1);
Alg_eat{i} = mat.SPK(mat.SPK>mat.dur_eating(1)-5&mat.SPK<mat.dur_eating(1)+5)-mat.dur_eating(1);
end
%
edges = -5:0.2:5;
edges_core = edges(1:end-1)+diff([edges(1),edges(2)])/2;
Spk_zs_baseline = zeros(length(pfs),50);
Spk_zs_putin=zeros(length(pfs),length(edges_core));Spk_zs_chase=Spk_zs_putin;
Spk_zs_att=Spk_zs_putin;Spk_zs_eat=Spk_zs_putin;
for i=1:length(pfs)
baseline = histcounts(Alg_baseline{i},-10:0.2:10);
baseline_m = mean(baseline);baseline_std = std(baseline);
if baseline_std == 0
    baseline_std = 1;
end
Spk_baseline(i,:) = baseline(25:74)/0.2;
Spk_putin(i,:) = histcounts(Alg_putin{i},edges)/0.2;
Spk_chase(i,:) = histcounts(Alg_chase{i},edges)/0.2;
Spk_attack(i,:) = histcounts(Alg_att{i},edges)/0.2;
Spk_eating(i,:) = histcounts(Alg_eat{i},edges)/0.2;
Spk_zs_baseline(i,:) = (baseline(25:74)-baseline_m)/baseline_std;
Spk_zs_putin(i,:) = (histcounts(Alg_putin{i},edges)-baseline_m)/baseline_std;
Spk_zs_chase(i,:) = (histcounts(Alg_chase{i},edges)-baseline_m)/baseline_std;
Spk_zs_att(i,:) = (histcounts(Alg_att{i},edges)-baseline_m)/baseline_std;
Spk_zs_eat(i,:) = (histcounts(Alg_eat{i},edges)-baseline_m)/baseline_std;
end

%%
% spk_zs_all = [Spk_zs_baseline,Spk_zs_putin,Spk_zs_chase,Spk_zs_att,Spk_zs_eat];
% spk_zs_all([241;248;239;249],:) = [];
[~,ind_max] = max(spk_zs_all,[],2);
[~,ind_heatmap] = sort(ind_max,'descend');
figure;
subplot(151);
% [~,ind_max] = max(Spk_zs_baseline2,[],2);
%  ind_heatmap= flipud(str2num(cell2mat(CGobj.RowLabels)));
% [~,ind_heatmap] = sort(ind_max,'descend');
% Spk_zs_baseline(Spk_zs_baseline<2) = 0;
imagesc(edges_core,1:size(Spk_zs_baseline,1),spk_zs_all(ind_heatmap,1:50),[-5 5]);
hold on;plot([0 0],ylim,'white--','linewidth',1);colormap('jet');
ylabel('Cell #');
xlabel('Baseline');
subplot(152);
% [~,ind_max] = max(Spk_zs_putin2,[],2);
% [~,ind_heatmap] = sort(ind_max,'descend');
% Spk_zs_putin(Spk_zs_putin<2) = 0;
imagesc(edges_core,1:size(Spk_zs_putin,1),spk_zs_all(ind_heatmap,51:100),[-5 5]);
hold on;plot([0 0],ylim,'white--','linewidth',1);
set(gca,'ytick',[],'ycolor','w');xlabel('Introduction');colormap('jet');
subplot(153);
% [~,ind_max] = max(Spk_zs_chase2,[],2);
% [~,ind_heatmap] = sort(ind_max,'descend');
% Spk_zs_chase(Spk_zs_chase<2) = 0;
imagesc(edges_core,1:size(Spk_zs_chase,1),spk_zs_all(ind_heatmap,101:150),[-5 5]);
hold on;plot([0 0],ylim,'white--','linewidth',1);colormap('jet');
set(gca,'ytick',[],'ycolor','w');xlabel('Chase');
subplot(154);
% [~,ind_max] = max(Spk_zs_att2,[],2);
% [~,ind_heatmap] = sort(ind_max,'descend');
% Spk_zs_att(Spk_zs_att<2) = 0;
imagesc(edges_core,1:size(Spk_zs_att,1),spk_zs_all(ind_heatmap,151:200),[-5 5]);
hold on;plot([0 0],ylim,'white--','linewidth',1);colormap('jet');
set(gca,'ytick',[],'ycolor','w');xlabel('Attack');
subplot(155);
% [~,ind_max] = max(Spk_zs_eat2,[],2);
% [~,ind_heatmap] = sort(ind_max,'descend');
% Spk_zs_eat(Spk_zs_eat<2) = 0;
imagesc(edges_core,1:size(Spk_zs_eat,1),spk_zs_all(ind_heatmap,201:250),[-5 5]);
hold on;plot([0 0],ylim,'white--','linewidth',1);colormap('jet');
set(gca,'ytick',[],'ycolor','w');xlabel('Eating');
%%
edges = -5:0.2:5;
edges_core = edges(1:end-1)+diff([edges(1),edges(2)])/2;
% Spk_zs_baseline = Spk_zs_baseline(~isnan(mean(Spk_zs_baseline,2)),:);
% Spk_zs_putin = Spk_zs_putin(~isnan(mean(Spk_zs_putin,2)),:);
% Spk_zs_chase = Spk_zs_chase(~isnan(mean(Spk_zs_chase,2)),:);
% Spk_zs_att = Spk_zs_att(~isnan(mean(Spk_zs_att,2)),:);
% Spk_zs_eat = Spk_zs_eat(~isnan(mean(Spk_zs_eat,2)),:);
% Spk_zs_eat = Spk_zs_eat(~isinf(mean(Spk_zs_eat,2)),:);
figure;
subplot(151);
BF_plotwSEM2(edges_core,mean(Spk_zs_baseline(ind_heatmap,:)),std(Spk_zs_baseline(ind_heatmap,:))/sqrt(size(Spk_zs_baseline(ind_heatmap,:),1)),'k');
ylabel('Zscore')
xlabel('Baseline');
ylim([-2,8]);
subplot(152);
BF_plotwSEM2(edges_core,mean(Spk_zs_putin(ind_heatmap,:)),std(Spk_zs_putin(ind_heatmap,:))/sqrt(size(Spk_zs_putin(ind_heatmap,:),1)),'k');
set(gca,'ytick',[],'ycolor','w');xlabel('Introduction');
ylim([-2,8]);
subplot(153);
BF_plotwSEM2(edges_core,mean(Spk_zs_chase(ind_heatmap,:)),std(Spk_zs_chase(ind_heatmap,:))/sqrt(size(Spk_zs_chase(ind_heatmap,:),1)),'k');
set(gca,'ytick',[],'ycolor','w');xlabel('Chase')
ylim([-2,8]);
subplot(154);
BF_plotwSEM2(edges_core,mean(Spk_zs_att(ind_heatmap,:)),std(Spk_zs_att(ind_heatmap,:))/sqrt(size(Spk_zs_att(ind_heatmap,:),1)),'k');
set(gca,'ytick',[],'ycolor','w');xlabel('Attack');
ylim([-2,8]);
subplot(155);
BF_plotwSEM2(edges_core,mean(Spk_zs_eat(ind_heatmap,:)),std(Spk_zs_eat(ind_heatmap,:))/sqrt(size(Spk_zs_eat(ind_heatmap,:),1)),'k');
set(gca,'ytick',[],'ycolor','w');xlabel('Eating');
ylim([-2,8]);
%%
SPK_all_zs = [Spk_zs_baseline,Spk_zs_putin,Spk_zs_chase,Spk_zs_att,Spk_zs_eat];
[COEFF,SCORE,latent,tsquare] = pca(SPK_all_zs);
PCA_score = SCORE(:,1:3);
CGobj = clustergram(PCA_score,'cluster','column','colormap','gray','Linkage','complete');
set(CGobj,'OptimalLeafOrder',0);
%%
for i=1:length(pfs)
    [~,maxind] = max(spk_zs_all(i,:));
    if maxind<=2
        Ridge(i,1) = mean(spk_zs_all(i,1:maxind+2));
    else if maxind>=248
            Ridge(i,1) = mean(spk_zs_all(i,maxind-2:end));
        else
            Ridge(i,1) = mean(spk_zs_all(i,maxind-2:maxind+2));
        end
    end
end
mean(Ridge)
%%
for j=1:1000
    Shuffdata = zeros(size(spk_zs_all));
    for i=1:size(spk_zs_all,1)
        Shuffid = randperm(size(spk_zs_all,2));
        rawdata = spk_zs_all(i,:);
        Shuffdata(i,:) = rawdata(Shuffid);
    end
    spk_zs_all = Shuffdata;
end
