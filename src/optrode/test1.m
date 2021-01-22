waveform = MAT_spk.RawData.waveform;
twin = [0.000, 0.005]; %时间内

ind_in = false(size(iTime));
for i=1:length(stamp)
    dt = iTime-stamp(i);
    ind = dt>twin(1) & dt<twin(2);
    ind_in = ind_in | ind;
end
ind_out = ~ind_in;

% w = squeeze(mean(waveform, 1));
% d = max(w, [], 2);
% [~, ind_ch] = max(d);
waveform_in = squeeze(waveform(ind_in,1, :));
waveform_out = squeeze(waveform(ind_out, 1, :));
waveform_in_m = mean(waveform_in, 1);
waveform_out_m = mean(waveform_out, 1);
figure;
subplot(1,2,1);hold on;
plotHz(40, waveform_out', 'k');
plotHz(40, waveform_in',  'r');
legend('OUT', 't=[0 0.005]');
r = corr(waveform_in_m', waveform_out_m');
title(sprintf('相关系数r=%.3f', r));
xlabel('Time (ms)')
ylabel('Amp.');
subplot(1,2,2);hold on;
plotHz(40, waveform_out_m', 'k');
plotHz(40, waveform_in_m',  'r');
xlabel('Time (ms)')
ylabel('Amp.');
