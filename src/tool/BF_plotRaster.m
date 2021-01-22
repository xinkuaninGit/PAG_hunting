function [h]=BF_plotRaster(dat_6000y10x, xtick_6000xor2x,color_3arr,linebg,linehigh)
%function [h]=BF_plotRaster(dat_6000y10x, xtick_6000xor2x,��ѡcolor����ѡlinebottom=0,��ѡlinehigh)	
%
%h1=BF_plotRaster(Alg2Tone, [-20:0.001:39.999])
%(Alg2Tone, [-20:0.001:40]),(Alg2Tone, [-20,40]) �����ڲ�������������ȷ��
%--�͵����ȳ��֣��ߵ��к���֡� trial=1 ��y=1;trial =100 ��y=100;
%--�������׷��"axis xy" 
%������dat_6000y10xֵΪ[0,1]��"1"��ʾ����դ
%2015-8-23 ��꿷� BaseFrame

%2015-9-10 ���ӿ�ѡ������ѡcolor����ѡlinebg,��ѡlinehigh

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

%% �����׳����xtick_6000
	[y6000,~] = size(dat_6000y10x);
	if nargin>=2
        xtick1=xtick_6000xor2x;
        if length(xtick1) > y6000; %��[-20:0.1:40] ����6001
            xtick1(y6000 +1 :end) = [];
        elseif length(xtick1) == 2; %������[-20,40] ����2
            %linspace(-20,40,6000) ��ʽ�Ǵ���ģ���Ϊ������40����㣬Ӧ��39.999
            xtick1(2)=xtick1(2) - ( xtick1(2)-xtick1(1) )/y6000;
            xtick1 = linspace(xtick1(1),xtick1(2), y6000);
        else
        end
    end
%% ��դͼ����
	[yid,xid] = find(dat_6000y10x' ==1);%��Ϊ������
	xid2 = [xid,xid]'; %����չ����6000x 2y
	if nargin>=2
		xid3 = xtick1(xid2); %����������
    elseif nargin==1
		xid3 = xid2;
	end
	yid2 = [yid,yid-linehigh]'+linebg;
	yid3 = yid2;

%%
    
	h = plot(xid3,yid3,'color',color_3arr,'LineWidth',1.5);