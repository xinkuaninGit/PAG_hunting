function Alg_cell = BF_AlignSg2TgCell(Lick, Trgger, wds_L,wds_R)
%对齐触发周围的事件，警告：不检查左右窗口越界
%function Alg_ms = BF_AlignSg2TgCell(Lick, Trgger, wds_L,wds_R)
%  ----Input 参数---------
%   Lick        : 周围事件的timestamp，1v
%   Trgger      : 触发事件的timestamp，1v
%   wds_L       ：窗口左侧，如 [-2]
%   wds_R       : 窗口右侧，如 [2]
%  
%  ----Output 参数---------
%   Alg_cell    : 周围时间沿触发的对齐，1x cell of 1y nums

assert(isvector(Lick)&&isvector(Trgger), 'Input数据格式必须为1维向量');
assert(wds_L < wds_R, '窗口大小错位！');
ntrial = length(Trgger);
Alg_cell = cell(1, ntrial);
for i=1:ntrial
    tick_now = Trgger(i);
    dtick = Lick - tick_now;
    ttick = dtick(dtick>wds_L & dtick<wds_R);
    Alg_cell{i} = reshape(ttick, [],1);
end