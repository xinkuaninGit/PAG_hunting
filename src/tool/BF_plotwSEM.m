function [h,h_patch]=BF_plotwSEM(x,y,yerr)
%function [h,h_patch]=BF_plotwSEM(x,y_1xy,yerr_1xy)
%
%[h1,h_patch1]=BF_plotwSEM([1:100],GCampatTone_mean,GCampatTone_errbar)
%就像普通的plot函数,y yerror为1x、1y向量
%2015-8-22 陈昕枫 BaseFrame
    hold on;
	y=reshape(y,1,length(y));
    yerr=reshape(yerr,1,length(yerr));
    x = reshape(x, 1,[]); %1x
    y = reshape(y, 1,[]); %1x
	xerror = [x,fliplr(x)];
	yerror = [ (y + yerr) , fliplr(y -yerr) ];
	h_patch=patch(xerror, yerror, 'y','FaceAlpha',0.4,...
		'LineStyle','none', 'HandleVisibility', 'off');
    h=plot(x,y);
    set(h_patch, 'FaceColor', get(h, 'Color'));
end
