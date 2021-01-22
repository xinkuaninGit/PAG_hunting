pfs_merge = uigetfilemult('*.mat');
StemgAttack = [];StemgEating = [];Spk_zsAttack = [];
for i=1:length(pfs_merge)
    mat = load(pfs_merge{i});
    StemgAttack(end+1:end+length(mat.pfs),:) = mat.STemg_attack;
    StemgEating(end+1:end+length(mat.pfs),:) = mat.STemg_eating;
    Spk_zsAttack(end+1:end+length(mat.pfs),:) = mat.Spk_zs_att;
end
center = -400:400;
%%
% [maxind,~] = mean(StemgAttack(:,center>-60&center<60),2);
[~,sortind] = sort(max(StemgAttack(:,center>-60&center<60),[],2),'descend');%mean(Spk_zsAttack(:,25:50),2)
figure;
imagesc(center,1:size(StemgAttack,1),StemgAttack(sortind,:),[-2,2])
% colormap('hot');
hold on;
plot([-60 -60],ylim,'w--');
plot([60 60],ylim,'w--');
figure;
imagesc(center,1:size(StemgAttack,1),StemgEating(sortind,:),[-2,3])
colormap('hot')
hold on;
plot([-60 -60],ylim,'w--');
plot([60 60],ylim,'w--');
figure;
imagesc(Spk_zsAttack(sortind,:),[-2 4])
colormap('hot')

%%
Stemg = StemgAttack;
for i=1:size(Stemg,1)
    FringUp = prctile(Stemg(i,center>60|center<-60),98);
    agt2=[0  Stemg(i,center>-60&center<60)>FringUp 0] ; 
    dagt2=diff(agt2); 
    ind1=find(dagt2==-1);
    ind2=find(dagt2==1);
    if max(ind1-ind2)>5
        StemgSignAttack(i) = 1;
    else
        StemgSignAttack(i) = 0;
    end
end
ind_StemgSignAttack = find(StemgSignAttack==1)';
%%
stemg_all_att = StemgAttack(ind_StemgSignAttack,:);
stemg_all_eat = StemgEating(ind_StemgSignAttack,:);
Spk_zsAttack_all = Spk_zsAttack(ind_StemgSignAttack,:);
[~,maxind] = max(StemgAttack(ind_StemgSignAttack,center>-60&center<60),[],2);
[~,sortind] = sort(maxind,'descend');%mean(Spk_zsAttack(:,25:50),2)
figure;
imagesc(center,1:size(stemg_all_att,1),stemg_all_att(sortind,:),[-2,3])
colormap('hot')
hold on;
plot([-60 -60],ylim,'w--');
plot([60 60],ylim,'w--');
figure;
imagesc(center,1:size(stemg_all_att,1),stemg_all_eat(sortind,:),[-2,3])
colormap('hot');
hold on;
plot([-60 -60],ylim,'w--');
plot([60 60],ylim,'w--');
figure;
imagesc(Spk_zsAttack_all(sortind,:),[-2 4]);colormap('hot');
%%
ind =  find(max(Spk_zsAttack(:,25:50),[],2)>2.8);
ind = intersect(ind,ind_StemgSignAttack);
%%
data = get(gco,'cdata');
% edges = -5:0.2:5;centers = edges(1:end-1) + 0.5* diff(edges([1 2]));
centers = -400:400;
figure;
BF_plotwSEM2(centers,mean(data),std(data)/sqrt(size(data,1)),'k');