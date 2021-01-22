% plot PSTH for sigle neuron, to show activity change with different
% hunting phase
% 
if ~exist('pfmat','var')
[f,p] = uigetfile('*.mat');
pfmat = [p,f];
end
mat = load(pfmat');
%%
spk = mat.SPK;
puttime = mat.dur_putin(1);
chasetime = mat.dur_chase(1)-puttime;
attacktime = mat.dur_attack(1)-puttime;
eattime = mat.dur_eating(1)-puttime;
%%
edges = 0:1:floor(spk(end));
[spk_nums,~] = histcounts(spk,edges);
edges_core = edges(1:end-1) + 0.5 * diff(edges([1,2]));
%%
figure;
subplot(311);
barline(spk-puttime);
xlim([-20 40]);
axis off
subplot(3,1,[2,3]);
a = edges_core-puttime;
% b = medfilt1(spk_nums,1);
plot(a,spk_nums,'k-','linewidth',2);
set(gca,'linewidth',2,'fontsize',15,'box','off');
xlim([-20 40]);hold on;
plot([0 0],ylim,'r--','linewidth',2);
plot([chasetime chasetime],ylim,'r--','linewidth',2);
plot([attacktime attacktime],ylim,'r--','linewidth',2);
plot([eattime eattime],ylim,'r--','linewidth',2);
return;
%%
pfs = uigetfilemult('*.mat')
for i=1:length(pfs)
    pfmat = cell2mat(pfs(i));
    allProcess;
end