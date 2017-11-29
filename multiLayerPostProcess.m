% path = 'E:\Ph.D\Research\2.5D\NikitaRdc\epeps_case2_ml_hole\D2\';
% filePath = [path,'D2.msh'];
% global newNodeList newPatchList gndnode

thresh1 = 1e-1; thresh2 = 1e-1; thresh3 = 1e-4;         % Anoop - Why different for x, y and z?
load([path,'\region2Layer.txt']);
load([path,'\layer2Height.txt']);
load([path,'\currentSources.txt']);
load([path,'\portLocations.txt']);
load([path,'\thickness.txt']);
[fileInfo, nodeList, patchList, elmType, numTags, phyTag, geoTag] = readQuadMsh(filePath);

%%%%%%%%%%%%%%%%%%%% Ensure gndnode is set %%%%%%%%%%%%%%%%%%%%%%%%
gndnode = currentSources(1,2);
currentSources(1,2) = 0;                                % Anoop - ?                       

% gndnode = 0;
%%%%%%%%%%% Temp %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phyTag = phyTag + 1;
% phyTag = 3 - phyTag; %% For ML case
% nodeList = nodeList.*1e-2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Modified for Nas files %%%%%%%%%%%%%
% phyTag = geoTag - 2;
% nodeList = nodeList.*1e-3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


regions = region2Layer(:,1);                            
layers = layer2Height(:,1);
heights = layer2Height(:,2);
numNodes = size(nodeList,1);
numPatches = size(patchList,1);
newNodeList = []; newPatchList = [];newPatchInfo = [];countNodes = 0;countPatches = 1;
for i = 1:numPatches
    tempPatch = patchList(i,:);
    tempRegion = phyTag(i);
    temp1 = region2Layer(tempRegion,2:end);
    ind1 = find(temp1 > 0);
    tempLayers = temp1(ind1);
    num1 = numel(tempLayers);
    for j = 1:num1                                                                                          % Anoop - ?
        for k = 1:4
            node = nodeList(tempPatch(k),:);
            newNode = node; 
            newNode(3) = heights(tempLayers(j));
            newNodeIndex  = -1;
            if(isempty(newNodeList))
                newNodeList = [newNodeList;newNode];
                countNodes = countNodes + 1;
                newNodeIndex = countNodes;
            else
                tempi = find(   (newNodeList(:,1) == newNode(1))& ...
                                (newNodeList(:,2) == newNode(2))& ...
                                (newNodeList(:,3) == newNode(3))        );
                if(isempty(tempi))
                    newNodeList = [newNodeList;newNode];
                    countNodes = countNodes + 1;
                    newNodeIndex = countNodes;
                else
                    if(size(tempi,1) >1)
                        disp('Multiple nodes');
                    else
                        newNodeIndex = tempi;
                    end
                end
            end
            newPatchList(countPatches,k) = newNodeIndex;
        end
        newPatchInfo = [newPatchInfo;i,tempLayers(j)];
        countPatches = countPatches + 1;
    end
end
[sortedPatchInfo, ind1] = sort(newPatchInfo(:,2),1);                                                        % Anoop - ?
newPatchList = newPatchList(ind1,:); 
newPatchInfo = newPatchInfo(ind1,:);
numPortNodes = size(portLocations,1);
portNode = -1*ones(numPortNodes,1);
close all

% newNodeList = newNodeList.*1e-3;

figure,patch('Vertices', newNodeList,'Faces',newPatchList,'FaceAlpha',0.4,'FaceColor','k'), hold on 
for i = 1                                                                                                   % Anoop - Only one iteration?
    if(portLocations(i,3) == 0)                                                                             % Anoop - ?
        portNode(i) = 0;
    else
        for j = 1:size(newNodeList,1)
            if(abs(portLocations(i,1) -  newNodeList(j,1))<thresh1)                                         % Why not do this in a single line?
                if(abs(portLocations(i,2) -  newNodeList(j,2))<thresh2)
                    if(abs(portLocations(i,3) -  newNodeList(j,3))<thresh3)
                        portNode(i) = j;
                        text(newNodeList(j,1),newNodeList(j,2),newNodeList(j,3),['N',num2str(j)]), hold on;
                        plot3(newNodeList(j,1),newNodeList(j,2),newNodeList(j,3),'*'),hold on                % What does this star signify?
                        %break;
                    end
                end
            end
        end
    end
end

save([path,'\patchlist.txt'],'newPatchList','-ascii');
save([path,'\nodelist.txt'],'newNodeList','-ascii');
save([path,'\newPatchInfo.txt'],'newPatchInfo','-ascii');
load([path,'\patchlist.txt']); load([path,'\nodelist.txt']);
