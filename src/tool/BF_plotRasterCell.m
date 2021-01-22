function h=BF_plotRasterCell(dat_cell,color_3arr,linebg,linehigh)
%��cell��ʽ�����դ���ݣ��޶�����2016-10-26����꿷�
%function [h]=BF_plotRasterCell(dat_cell,��ѡcolor����ѡlinebottom=0,��ѡlinehigh)	
%hline=BF_plotRasterCell(SweepTicks)
%----Input ����---------
% dat_cell    : ��դ���ݣ�cell_1v of ��ֵ
% color_3arr  : ��դ��ɫ����ѡ
% linebg      ����դ��ʼ��
% linehigh    : ��դ�߶�
%
%----Output ����---------
% h           : ��դ��line���
%% �����������
	if ~exist( 'color_3arr','var')
        color_3arr =[0 0 0];
    end
    if ~exist( 'linebg','var')
        linebg=0;
    end
    if ~exist( 'linehigh','var')
        linehigh = 0.8;
    end

%% plot
    hold on;
	h=matlab.graphics.chart.primitive.Line.empty(1,0);
	for i=1:length(dat_cell)
		dat=repmat(setrow(dat_cell{i}),2,1); %2x
		ytick=repmat([linebg;linehigh]+i-1,1,size(dat,2)); %2x
		htemp=plot(dat,ytick,'color',color_3arr,'LineWidth',1.5);
		h=[h;htemp];  %1y
	end
