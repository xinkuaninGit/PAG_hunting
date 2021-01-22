function [h]=BF_plotRaster(dat_6000y10x, xtick_6000xor2x,color_3arr,linebg,linehigh)
%function [h]=BF_plotRaster(dat_6000y10x, xtick_6000xor2x,可选color，可选linebottom=0,可选linehigh)	
%
%h1=BF_plotRaster(Alg2Tone, [-20:0.001:39.999])
%(Alg2Tone, [-20:0.001:40]),(Alg2Tone, [-20,40]) 经过内部纠正，都是正确的
%--低的行先出现，高的行后出现。 trial=1 ，y=1;trial =100 ，y=100;
%--建议后面追加"axis xy" 
%参数：dat_6000y10x值为[0,1]，"1"表示做光栅
%2015-8-23 陈昕枫 BaseFrame

%2015-9-10 增加可选参数可选color，可选linebg,可选linehigh

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

%% 纠正易出错的xtick_6000
	[y6000,~] = size(dat_6000y10x);
	if nargin>=2
        xtick1=xtick_6000xor2x;
        if length(xtick1) > y6000; %如[-20:0.1:40] 个数6001
            xtick1(y6000 +1 :end) = [];
        elseif length(xtick1) == 2; %如输入[-20,40] 个数2
            %linspace(-20,40,6000) 方式是错误的，因为不包含40这个点，应是39.999
            xtick1(2)=xtick1(2) - ( xtick1(2)-xtick1(1) )/y6000;
            xtick1 = linspace(xtick1(1),xtick1(2), y6000);
        else
        end
    end
%% 光栅图制作
	[yid,xid] = find(dat_6000y10x' ==1);%均为列向量
	xid2 = [xid,xid]'; %横向展开，6000x 2y
	if nargin>=2
		xid3 = xtick1(xid2); %更改坐标轴
    elseif nargin==1
		xid3 = xid2;
	end
	yid2 = [yid,yid-linehigh]'+linebg;
	yid3 = yid2;

%%
    
	h = plot(xid3,yid3,'color',color_3arr,'LineWidth',1.5);