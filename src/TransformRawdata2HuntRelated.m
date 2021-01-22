% Transform MClust .wv data (spikes time and waveform)
% add event timestamps into SPK data, to creative a new .mat file for
% former analysis
pfs_spk = uigetfilemult('*wv.mat','spk file');
%% video 
t_cricket_putin =71.499;
dur_putin = [71.499,72.499];
dur_chase = [64.365,65.883];
dur_attack = [83.233,85.827];
dur_eating = [181.675,439.844];
%%
for i=1:length(pfs_spk)
    pf_Spk = cell2mat(pfs_spk(i));
    mat_Spk = load(pf_Spk);
    SPK = mat_Spk.RawData.iTime;
    SPK = SPK-SPK(1);%%
    baseline = SPK(SPK<t_cricket_putin);
    base_spknum = histcounts(baseline,0:1:baseline(end))/1;
    base = bootstrp(5000,@mean,base_spknum);
    edges = 0:0.5:SPK(end);
    edges_core = edges(1:end-1) + 0.5 * diff(edges([1,2]));
    spk_num = histcounts(SPK,edges);
    ConfidenceInterval_5 = prctile(base(:,1),[5 95]);
    ConfidenceInterval_1 = prctile(base(:,1),[1 99]);
    ConfidenceInterval_01 = prctile(base(:,1),[0.1 99.9]);
    AP_putin = getAPintims(SPK,dur_putin);
    AP_attack = getAPintims(SPK,dur_attack);
    AP_eating = getAPintims(SPK,dur_eating);
    AP_chase = getAPintims(SPK,dur_chase);
    %
    figure;
    subplot(3,1,3);
    histogram(base,100,'FaceColor','black','edgecolor','none','FaceAlpha',1);hold on;
    plot([ConfidenceInterval_5;ConfidenceInterval_5],ylim,'black--','linewidth',1);
    plot([ConfidenceInterval_1;ConfidenceInterval_1],ylim,'black--','linewidth',1);
    plot([ConfidenceInterval_01;ConfidenceInterval_01],ylim,'black--','linewidth',1);
    h_putin = plot([AP_putin,AP_putin],ylim,'m--','linewidth',1);
    h_chase = plot([AP_chase,AP_chase],ylim,'r--','linewidth',1);
    h_attack = plot([AP_attack,AP_attack],ylim,'g--','linewidth',1);
    h_eating = plot([AP_eating,AP_eating],ylim,'b--','linewidth',1);
    set(gca,'box','off','linewidth',1,'fontsize',15);
    h_legend = legend([h_putin,h_chase,h_attack,h_eating],'put in'...
        ,'chase','attack','eating','location','eastoutside');
    set(h_legend,'box','off','linewidth',1,'fontsize',15);
    xlabel('mean firingrate');
    subplot(3,1,1);
    barline(SPK,[0 0.8],'black','linewidth',1);hold on;
    plot(dur_putin,[0.9 0.9],'c','linewidth',4);
    plot(dur_chase,[0.9 0.9],'r','linewidth',4);
    plot(dur_attack,[0.9 0.9],'green','linewidth',4);
    plot(dur_eating,[0.9 0.9],'blue','linewidth',4);
    ylim([0 1]);
    set(gca,'ytick',[],'ycolor','w','box','off');
    subplot(3,1,2);
    plot(edges_core,spk_num,'linewidth',2);hold on;
    plot(dur_putin,[-0.1 -0.1],'c','linewidth',4);
    plot(dur_chase,[-0.1 -0.1],'r','linewidth',4);
    plot(dur_attack,[-0.1 -0.1],'green','linewidth',4);
    plot(dur_eating,[-0.1 -0.1],'blue','linewidth',4);
    ylim([-0.2 max(spk_num)]);
    set(gca,'ytick',[],'ycolor','w','box','off');
    pf_name = regexprep(pf_Spk,'wv.mat','cri_hunt_new.mat');
    save(pf_name);
end
