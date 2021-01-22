
pfs = uigetfilemult('*cri_hunt_new.mat','load for hunt');
win=[-20,20];edges_1 = win(1):0.5:win(2);
N_edges_1 = edges_1(1:end-1) + 0.5 * diff(edges_1([1,2]));
% Firing_n = zeros(length(pfs),length(N_edges_1));
for i=1:length(pfs)
   mat = load(cell2mat(pfs(i)));
   SPK = mat.SPK - mat.dur_attack(1);
   [N,~] = histcounts(SPK,edges_1);
   N = N/0.5;%%
   N_zscore = (N - mean(mat.base_spknum))/std(mat.base_spknum);
   Zscore_n(i,:) = N_zscore(:);
   firingrate(i,:) = [mean(mat.base_spknum),mat.AP_putin,mat.AP_chase,mat.AP_attack,mat.AP_eating];
end
%% Zscore
figure;
bar(mean(firingrate))
%%
a = Zscore_n;
[b,ind] = sort(mean(a(:,N_edges_1>0&N_edges_1<1),2),'descend');
c = a(ind,:);
figure;
imagesc(N_edges_1,1:size(a,1),c(:,1:80),[-2 10]);
