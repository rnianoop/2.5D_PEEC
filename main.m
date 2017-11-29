%%%%%%% This script will not work for only caps %%%%%%%%%%

freqRange = 10e6:40e6:8e9;
%freqRange = 100e6;
% load('lhs_perturb');
numFreqMain = size(freqRange,2);
setFlags_sensitivity
multiLayerPostProcess
save([path,'\nodelist_D0.txt'],'newNodeList','-ascii');
load('patchlist.txt');

load('nodelist_D0.txt');
nodelistD0 = nodelist_D0;

newNodeList = nodelistD0;
calculate_quad_RLGC

for  freqindmain = 1:numFreqMain
    freq = freqRange(freqindmain);
    
    solve_spice
    
    % zFreq_list(freqindmain) = zFreq(1,2);             % For two port
    zFreq_list(freqindmain) = zFreq;                    % For one port
 
%%%%%%%%%%% Freeing up memory %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     clear tempinv spice_list rhs_list premult_list patchList1 ...
%         nodelist nodelist_D1 nodelist_D2 nodeList nodeList1...
%         kxDiffs kyDiffs lxDiffs lyDiffs delVByDelKx delVByDelKy delVByDelLx delVByDelLy...
%         deltaFByDelKx deltaFByDelKy deltaFByDelLx deltaFByDelLy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end


for freqind = 1:numFreqMain
    zF_D0(freqind) = zFreq_list(freqind);
end
figure,
plot(freqRange,abs(zF_D0),'-r');
