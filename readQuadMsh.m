function [fileInfo, nodeList, patchList, elmType, numTags, phyTag, geoTag] = readQuadMsh(filePath) %%%% Presently valid for quadrilateral meshes only %%%

fid = fopen(filePath,'r');
fileInfo = struct([]); nodeList = []; patchList = []; elmType = []; numTags = []; phyTag = []; geoTag = [];

while(~feof(fid)) %%% Until the file ends
    tline = fgetl(fid) ;%%% Read each individual line
    
    if(isempty(tline)) %%% Ignore all empty lines %%% 
        %disp('Tline is empty');
        continue;
    end
   
    if(numel(tline) >= 4 )
        if(strcmp(tline(1:4), '$End')) %%%% Ignore all Section Ends %%
            %disp('$End encountered\n');
        end
    end
    
    if(strcmp(tline, '$MeshFormat')) %%%% Read Mesh Format %%%%
        tline = fgetl(fid);
        fileInfo = cellstr(tline);
    end
    
    if(strcmp(tline, '$Nodes'))
       tline = fgetl(fid);
       numNodes = str2double(char(cellstr(tline)));
       for i = 1:numNodes
           tline = fgetl(fid);
           temp = str2num(tline);
           nodeList = [nodeList;temp(2:end)];
       end
    end
    
    if(strcmp(tline, '$Elements'))
       tline = fgetl(fid);
       numPatches = str2double(char(cellstr(tline)));
       for i = 1:numPatches
           tline = fgetl(fid);
           temp = str2num(tline);
           elmType = [elmType;temp(2)];
           numTags = [numTags;temp(3)];
           phyTag = [phyTag;temp(4)];
           geoTag = [geoTag;temp(5)];
           patchList = [patchList;temp(6:end)];
       end
    end   
end


%-- Anoop --%
% To create figure use the following command
%patch('Vertices', nodeList, 'Faces', patchList, 'FaceAlpha', 0.4, 'FaceColor', 'r');
%-- Anoop --%

% nodeList = nodeList.*1e-3;
% patch('Vertices',nodeList,'Faces',patchList,'FaceAlpha',0.4,'FaceColor','r'), hold on 
%text(nodeList(492,1),nodeList(492,2),nodeList(492,3),['N',num2str(492)]), hold on;
% % text(nodeList(8,1),nodeList(8,2),nodeList(8,3),['N',num2str(8)]), hold off;
% 
% for i = 1:numNodes
% %   text(nodeList(i,1),nodeList(i,2),nodeList(i,3),['N',num2str(i)]), hold on;
% %     if(abs(nodeList(i,1) - 20e-3)<1e-4)
% %        if(abs(nodeList(i,2) - 5e-3)<1e-4)
% %             n1 = i;
% %             text(nodeList(i,1),nodeList(i,2),nodeList(i,3),['N',num2str(i)]), hold on;
% %         end
% %      end
% %     if(abs(nodeList(i,1) - 90e-3)<1e-5)
% %         if(abs(nodeList(i,2) - 30e-3)<1e-5)
% %            n2 = i;
% %             text(nodeList(i,1),nodeList(i,2),nodeList(i,3),['N',num2str(i)]), hold on;
% %         end
% %     end
%     
% end
fclose(fid);