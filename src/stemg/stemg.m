clear;
[f,p] = uigetfile('*daq.mat','daq');
daq_mat = load([p,f]);
[f,p] = uigetfile('*inp.mat','daq');
inp_mat = load([p,f]);
SPK_ttl = inp_mat.I_0';
[DAQ_ttl, ~] = detectTTL(daq_mat.data(:,2), 'up-up', 20);
DAQ_ttl = DAQ_ttl/1000;
deltT = mean(SPK_ttl - DAQ_ttl);
pfs = uigetfilemult('*hunt_new.mat','spk');
opentime = 42359700/30000; %% 每个session都要�?
%%
n=5; % n为模板长度，值可以改�?
STemg_attack = zeros(length(pfs),801);
STemg_eating = zeros(length(pfs),801);
for i=1:length(pfs)
    spk_mat = load(pfs{i});
    spk = spk_mat.mat_Spk.RawData.iTime - deltT ;% change spk time to daq time
    EMG = abs(daq_mat.data(:,1));
    attack = spk_mat.dur_attack + opentime- deltT;
    attack_spk = spk(spk>attack(1)&spk<attack(2));
    Alg_sXtrail = BF_AlignWave2Tg(EMG, attack_spk*daq_mat.Fs, -400, 400,1);
    eating = spk_mat.dur_eating+ opentime- deltT;    
    eating_spk = spk(spk>eating(1)&spk<eating(2));
    Alg_sXtrail_eating_spk = BF_AlignWave2Tg(EMG, eating_spk*daq_mat.Fs, -400, 400,1);
    baseline = [2 spk_mat.dur_putin(1) ]+ opentime - deltT;
    baseline_spk = spk(spk>baseline(1)&spk<baseline(2));
    Alg_sXtrail_bl = BF_AlignWave2Tg(EMG, baseline_spk*daq_mat.Fs, -500, 500,1);
    Alg_mean_bl_filter = conv(mean(Alg_sXtrail_bl,2),ones(1,100)./100);
    Alg_mean_bl_filter = Alg_mean_bl_filter(148:952);
    Alg_mean_filter_att = conv( mean(Alg_sXtrail,2),ones(1,n)./n) - Alg_mean_bl_filter;
    Alg_mean_filter_eat = conv(mean(Alg_sXtrail_eating_spk,2),ones(1,n)./n)- Alg_mean_bl_filter;
    Alg_mean_filter_att = Alg_mean_filter_att(3:end-2);
    Alg_mean_filter_eat = Alg_mean_filter_eat(3:end-2);
    STemg_eating(i,:) = (Alg_mean_filter_att - mean(Alg_mean_filter_att))/std(Alg_mean_filter_att);    
    STemg_attack(i,:) = (Alg_mean_filter_eat - mean(Alg_mean_filter_eat))/std(Alg_mean_filter_eat);
end
%%
Alg_baseline = cell(length(pfs),1);
Alg_putin = cell(length(pfs),1);
Alg_att = cell(length(pfs),1);
Alg_chase = cell(length(pfs),1);
Alg_eat = cell(length(pfs),1);
for i=1:length(pfs)
    mat = load(pfs{i});
    spk_behavior = mat.mat_Spk.RawData.iTime - opentime;
    Alg_baseline{i} = spk_behavior(spk_behavior>mat.dur_putin(1)-30&spk_behavior<mat.dur_putin(1)-10)-mat.dur_putin(1)+20;
    Alg_putin{i} = spk_behavior(spk_behavior>mat.dur_putin(1)-5&spk_behavior<mat.dur_putin(1)+5)-mat.dur_putin(1);
    Alg_chase{i} = spk_behavior(spk_behavior>mat.dur_chase(1)-5&spk_behavior<mat.dur_chase(1)+5)-mat.dur_chase(1);
    Alg_att{i} = spk_behavior(spk_behavior>mat.dur_attack(1)-5&spk_behavior<mat.dur_attack(1)+5)-mat.dur_attack(1);
    Alg_eat{i} = spk_behavior(spk_behavior>mat.dur_eating(1)-5&spk_behavior<mat.dur_eating(1)+5)-mat.dur_eating(1);
end
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
    Spk_zs_baseline(i,:) = (baseline(25:74)-baseline_m)/baseline_std;
    Spk_zs_putin(i,:) = (histcounts(Alg_putin{i},edges)-baseline_m)/baseline_std;
    Spk_zs_chase(i,:) = (histcounts(Alg_chase{i},edges)-baseline_m)/baseline_std;
    Spk_zs_att(i,:) = (histcounts(Alg_att{i},edges)-baseline_m)/baseline_std;
    Spk_zs_eat(i,:) = (histcounts(Alg_eat{i},edges)-baseline_m)/baseline_std;
end
matname = inputdlg('文件');
save([matname{1},'.mat']);
return;
%%
figure;subplot(151);
imagesc(STemg_attack,[-2,3]);
colormap('hot')
hold on;
plot([340 340],ylim,'w--');
plot([460 460],ylim,'w--');
subplot(152);
imagesc(STemg_eating,[-2,3]);
colormap('hot')
hold on;
plot([340 340],ylim,'w--');
plot([460 460],ylim,'w--');

subplot(153);
imagesc(edges_core,1:size(Spk_zs_chase,1),Spk_zs_chase,[-2 6]);
hold on;plot([0 0],ylim,'white--','linewidth',1);
set(gca,'ytick',[],'ycolor','w');xlabel('Chase');colormap('hot');
subplot(154);
imagesc(edges_core,1:size(Spk_zs_att,1),Spk_zs_att,[-2 6]);
hold on;plot([0 0],ylim,'white--','linewidth',1);
set(gca,'ytick',[],'ycolor','w');xlabel('Attack');colormap('hot');
subplot(155);
imagesc(edges_core,1:size(Spk_zs_eat,1),Spk_zs_eat,[-2 6]);
hold on;plot([0 0],ylim,'white--','linewidth',1);
set(gca,'ytick',[],'ycolor','w');xlabel('Eating');colormap('hot');
