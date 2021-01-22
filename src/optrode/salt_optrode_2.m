%% 两秒一个laser baseline为laser前1s
[f, p] = uigetfile('*.events_inp.mat');
if f==0; return;end
pf_evt = [p,f];
[fa, pa] = uigetfile('*wv.mat');
pf_spk = [pa,fa];
if f==0; return;end
load(pf_evt);
load(pf_spk);

laser = ceil(I_1'*1000);
iTime = ceil(RawData.iTime*1000);
lasers_bg = laser(:,1); %ms
t_dur = iTime(end); %ms
%%
iTime_bool = false(t_dur, 1);
iTime_bool(iTime) = true;
t_laser_seg = 10; %细的, ms  ~=10
nlaser = 50; %细的, ms
spt_test = false(nlaser, t_laser_seg);
spt_baseline = false(nlaser, t_laser_seg);
for i=1:nlaser
    spt_baseline(i,:) = iTime_bool(lasers_bg(i)+[-t_laser_seg:-1]);
    spt_test(i,:) = iTime_bool(lasers_bg(i)+[1:t_laser_seg]);
end

%% 计算
dt = 1;wn = 5;
[pvalue I] = salt(spt_baseline,spt_test,dt,wn);
%% Latency & Jitter
laser = ceil(I_1'*10000);
iTime = ceil(RawData.iTime*10000);
lasers_bg = laser(:,1); %ms
t_dur = iTime(end); %ms
iTime_bool = false(t_dur, 1);
iTime_bool(iTime) = true;
t_laser_seg = 10000; %细的, ms  ~=10
nlaser = 50; %细的, ms
spt_test = false(nlaser, t_laser_seg+1);
for i=1:nlaser
    spt_test(i,:) = iTime_bool(lasers_bg(i)+[0:t_laser_seg]);
end
spt = spt_test(:,1:50);
latency = [];
for i=1:nlaser
    if find(spt(i,:)==1,1)
    latency(end+1) = find(spt(i,:)==1,1);
    end
end
Latency_mean = mean(latency)/10;
Latency_sem = std(latency)/length(latency);
jitter = latency - mean(latency);
Jitter_mean = mean(abs(jitter))/10;
Jitter_sem = std(jitter)/length(jitter);
Field=length(latency)/50;
mat.P = pvalue;
mat.Latency_mean = Latency_mean;
mat.Jitter_mean = Jitter_mean;
mat.Field = Field;
matname = regexprep(fa,'.mat','_salt.mat');
save(matname,'-struct','mat');

