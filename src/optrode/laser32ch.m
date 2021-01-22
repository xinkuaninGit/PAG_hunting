function laser32ch()
    [f, p] = uigetfile('*.events_inp.mat');
    if f==0; return;end
    pf_evt = [p,f];
    [f, p] = uigetfile('*wv.mat');
    pf_spk = [p,f];
    if f==0; return;end
    
    %% 载入数据
    MAT_evt = load(pf_evt);
    MAT_spk = load(pf_spk);
    assert(isfield(MAT_evt, 'I_1'));
    assert(isfield(MAT_spk, 'RawData') && isfield(MAT_spk.RawData, 'iTime'));
    stamp = MAT_evt.I_1;
    iTime = MAT_spk.RawData.iTime;
    %比较波形
    %% 画出Raster数据
    figure;
    subplot(2,1,1);hold on;
    Alg_cell = BF_AlignSg2TgCell(iTime, stamp, -0.5, 0.5);
    BF_plotRasterCell(Alg_cell, 'k');
    hold on
    plot([0 0],ylim,'y',[0.005 0.005],ylim,'y');
    ylabel('trial');
    title('Raster plot');
    subplot(2,1,2);
    Alg_cell = set1y(Alg_cell);
    Alg_mat = cell2mat(Alg_cell);
    [N,edges] = histcounts(Alg_mat, -0.5:0.05:0.5);
    centers = edges(1:end-1) + 0.01* diff(edges([1 2]));
    %FiringRate = N/(length(Alg_cell)*diff(edges([1 2]))); %fire rate;
    FiringRate = N/0.05; %fire rate;

    plot(centers, FiringRate);
    hold on
    plot([0 0],ylim,'y',[0.005 0.005],ylim,'y');
    xlabel('time (sec)');
    ylabel('fire rate(Hz)');
    title('PSTH');
    figure;
    SpikeM=mean(N);Spike_st=std(N);
    Firzscore=(N-SpikeM)/Spike_st;
    plot(centers,Firzscore,'black');
    hold on
    plot([0 0],ylim,'y',[0.005 0.005],ylim,'y');
    title('Zscore');
    xlabel('time');
    ylabel('Firing Z-Score');
    Sname = ['firingrate_',f];
    save(Sname,'FiringRate');
  test1()
end
   