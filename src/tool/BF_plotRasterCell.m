function h=BF_plotRasterCell(dat_cell,color_3arr,linebg,linehigh)
%用cell格式储存光栅数据，修订日期2016-10-26，陈昕枫
%function [h]=BF_plotRasterCell(dat_cell,可选color，可选linebottom=0,可选linehigh)	
%hline=BF_plotRasterCell(SweepTicks)
%----Input 参数---------
% dat_cell    : 光栅数据，cell_1v of 数值
% color_3arr  : 光栅颜色，可选
% linebg      ：光栅起始点
% linehigh    : 光栅高度
%
%----Output 参数---------
% h           : 光栅的line句柄
%% 处理输入参数
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
