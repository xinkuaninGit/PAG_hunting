function Alg_cell = BF_AlignSg2TgCell(Lick, Trgger, wds_L,wds_R)
%���봥����Χ���¼������棺��������Ҵ���Խ��
%function Alg_ms = BF_AlignSg2TgCell(Lick, Trgger, wds_L,wds_R)
%  ----Input ����---------
%   Lick        : ��Χ�¼���timestamp��1v
%   Trgger      : �����¼���timestamp��1v
%   wds_L       ��������࣬�� [-2]
%   wds_R       : �����Ҳ࣬�� [2]
%  
%  ----Output ����---------
%   Alg_cell    : ��Χʱ���ش����Ķ��룬1x cell of 1y nums

assert(isvector(Lick)&&isvector(Trgger), 'Input���ݸ�ʽ����Ϊ1ά����');
assert(wds_L < wds_R, '���ڴ�С��λ��');
ntrial = length(Trgger);
Alg_cell = cell(1, ntrial);
for i=1:ntrial
    tick_now = Trgger(i);
    dtick = Lick - tick_now;
    ttick = dtick(dtick>wds_L & dtick<wds_R);
    Alg_cell{i} = reshape(ttick, [],1);
end