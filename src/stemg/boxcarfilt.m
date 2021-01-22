function STemg = boxcarfilt(Alg_sXtrail)
overall_iSA = zeros(801,size(Alg_sXtrail,2));
for i=1:size(Alg_sXtrail,2)
    iSTA = Alg_sXtrail(:,i);
    aiSTA = zeros(51,801);
    for j=1:801
        aiSTA(:,j) = iSTA(j+50:j+100);
    end
    overall_iSA(:,i) = mean(aiSTA,1);
%     STemg(:,i) = iSTA(100:900,1) - iSA';
end
STemg = mean(Alg_sXtrail(100:900,1),2) - mean(overall_iSA,2);