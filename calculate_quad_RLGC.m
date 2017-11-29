%%%%%%%%%%%%%%%%% Get all the geometry and source information %%%%%%%%%%%%%
% global res ind cap con cres cind ccon ccap numQuads numNodes volts cvolts numIndBranches

%%%%%%%%%%%%%%% Calculate quad wise RLGC parameters %%%%%%%%%%%%%%%%%%%%%%
res = struct([]);ind =struct([]);cap = struct([]);con = struct([]);
numQuads = size(newPatchList,1); numLayers = size(layers,1);
layer = [];newNodes = []; shortNodes = [];
count = 1;
%%%%% Temporary identification of ground node %%%%%
% gndnode = currentSources(1,2);
for i = 1:numQuads
    tempNodes = [newNodeList(newPatchList(i,1),:);...
                 newNodeList(newPatchList(i,2),:);...
                 newNodeList(newPatchList(i,3),:);...
                 newNodeList(newPatchList(i,4),:)];
   
   midn1n2 = 0.5.*(newNodeList(newPatchList(i,1),:) + newNodeList(newPatchList(i,2),:));
   midn2n3 = 0.5.*(newNodeList(newPatchList(i,2),:) + newNodeList(newPatchList(i,3),:));
   midn3n4 = 0.5.*(newNodeList(newPatchList(i,3),:) + newNodeList(newPatchList(i,4),:));
   midn1n4 = 0.5.*(newNodeList(newPatchList(i,1),:) + newNodeList(newPatchList(i,4),:));
   
   tempCentroid = getQuadCentroid([midn1n2;midn2n3;midn3n4;midn1n4]);
   tempArea = getQuadArea(tempNodes);
   
   subQuad1 = [tempNodes(1,:);midn1n2;tempCentroid;midn1n4];
   subArea1 = getAreaA(rule,subQuad1,-1,1,-1,1);
   
   subQuad2 = [midn1n2;tempNodes(2,:);midn2n3;tempCentroid];
   subArea2 = getAreaA(rule,subQuad2,-1,1,-1,1);
   
   subQuad3 = [tempCentroid;midn2n3;tempNodes(3,:);midn3n4];
   subArea3 = getAreaA(rule,subQuad3,-1,1,-1,1);
   
   subQuad4 = [midn1n4;tempCentroid;midn3n4;tempNodes(4,:)];
   subArea4 =getAreaA(rule,subQuad4,-1,1,-1,1);
   
   origPatchIndex = newPatchInfo(i,1);  presLayer = newPatchInfo(i,2);
   n1 = newPatchList(i,1);n2 = newPatchList(i,2);n3 = newPatchList(i,3);n4 = newPatchList(i,4);
   
   %%%%%%%%% shift nodes to accomodate ground node %%%%%%%%%%%%%%%%%%
   if((Lon == 1)||(Ron == 1))                                               % Anoop - Understand from here till end
%        if(Con == 0)  
%            if(gndnode == 0)
%                disp('W/o Capacitor & Ground Node is 0');
%            end
        if(gndnode == 0)
        
        else
               if(n1 == gndnode)
                   n1 = 0;
               else if(n1 > gndnode)
                       n1 = n1 - 1;
                   end
               end
               if(n2 == gndnode)
                   n2 = 0;
               else if(n2 > gndnode)
                       n2 = n2 - 1;
                   end
               end
               if(n3 == gndnode)
                   n3 = 0;
               else if(n3 > gndnode)
                       n3 = n3 - 1;
                   end
               end
               if(n4 == gndnode)
                   n4 = 0;
               else if(n4 > gndnode)
                       n4 = n4 - 1;
                   end
               end
        end
   else
       n1 = 1; n2 = 1; n3 = 1; n4 = 1;
   end

  %%%%%%%% Calculate R L/M G C values and termination nodes %%%%%%%%%%%%%% 
   
   n1b = -1; n2b = -1; n3b = -1; n4b = -1; nextLayer = -1;
   La1b = []; La2b = []; Lb1b = []; Lb2b = [];
   tempi = [];   nextPatchIndex = -1;
    if(presLayer == 1)
        
       La1 = (miu*miu0*heights(presLayer))*getInductanceA(rule,tempNodes,-1,1,-1,0);
       Ca1 = (eps*eps0*subArea1)/(heights(presLayer));

       La2 = (miu*miu0*heights(presLayer))*getInductanceA(rule,tempNodes,-1,1,0,1);
       Ca2 = (eps*eps0*subArea2)/(heights(presLayer));
       
       Lb1 = (miu*miu0*heights(presLayer))*getInductanceB(rule,tempNodes,-1,0,-1, 1);
       Cb1 = (eps*eps0*subArea3)/(heights(presLayer));

       Lb2 = (miu*miu0*heights(presLayer))*getInductanceB(rule,tempNodes,0,1,-1, 1);
       Cb2 = (eps*eps0*subArea4)/(heights(presLayer));

       n1b = 0; n2b = 0; n3b = 0; n4b = 0;
    else
      for j = presLayer - 1:-1:0
          tempi = find((newPatchInfo(:,1) == origPatchIndex)&(newPatchInfo(:,2) == j));
          
          if(isempty(tempi))
              if(j == 0)
                  nextLayer = 0;
                  La1 = (miu*miu0*heights(presLayer))*getInductanceA(rule,tempNodes,-1,1,-1,0);
                  Ca1 = (eps*eps0*subArea1)/(heights(presLayer));

                  La2 = (miu*miu0*heights(presLayer))*getInductanceA(rule,tempNodes,-1,1,0,1);
                  Ca2 = (eps*eps0*subArea2)/(heights(presLayer));

                  Lb1 = (miu*miu0*heights(presLayer))*getInductanceB(rule,tempNodes,-1,0,-1, 1);
                  Cb1 = (eps*eps0*subArea3)/(heights(presLayer));

                  Lb2 = (miu*miu0*heights(presLayer))*getInductanceB(rule,tempNodes,0,1,-1, 1);
                  Cb2 = (eps*eps0*subArea4)/(heights(presLayer));

                  n1b = 0; n2b = 0; n3b = 0; n4b = 0;
              end
          else
              nextLayer = newPatchInfo(tempi,2);nextPatchIndex = tempi;
              
              La1 = (miu*miu0*heights(presLayer))*getInductanceA(rule,tempNodes,-1,1,-1,0);
              La1b = (miu*miu0*heights(nextLayer))*getInductanceA(rule,tempNodes,-1,1,-1,0);
              Ca1 = (eps*eps0*subArea1)/(heights(presLayer) - heights(nextLayer));
              
              La2 = (miu*miu0*heights(presLayer))*getInductanceA(rule,tempNodes,-1,1,0,1);
              La2b = (miu*miu0*heights(nextLayer))*getInductanceA(rule,tempNodes,-1,1,0,1);
              Ca2 = (eps*eps0*subArea2)/(heights(presLayer)- heights(nextLayer));
              
              Lb1 = (miu*miu0*heights(presLayer))*getInductanceB(rule,tempNodes,-1,0,-1, 1);
              Lb1b = (miu*miu0*heights(nextLayer))*getInductanceB(rule,tempNodes,-1,0,-1, 1);
              Cb1 = (eps*eps0*subArea3)/(heights(presLayer)- heights(nextLayer));
              
              Lb2 = (miu*miu0*heights(presLayer))*getInductanceB(rule,tempNodes,0,1,-1, 1);
              Lb2b = (miu*miu0*heights(nextLayer))*getInductanceB(rule,tempNodes,0,1,-1, 1);
              Cb2 = (eps*eps0*subArea4)/(heights(presLayer)- heights(nextLayer));
              
              n1b = newPatchList(nextPatchIndex,1); n2b = newPatchList(nextPatchIndex,2); n3b = newPatchList(nextPatchIndex,3); n4b = newPatchList(nextPatchIndex,4); 
              
              break;
          end
      end
    end
   layer = [layer;presLayer,nextLayer];
   
   Ra1 = (2/(sigma*thickness))*getResistanceA(rule,tempNodes,-1,1,-1,0);
   Ra2 = (2/(sigma*thickness))*getResistanceA(rule,tempNodes,-1,1,0,1);   
   Rb1 = (2/(sigma*thickness))*getResistanceB(rule,tempNodes,-1,0,-1, 1);
   Rb2 = (2/(sigma*thickness))*getResistanceB(rule,tempNodes,0,1,-1, 1);
   
   Ga1 = (Ca1*tanD); 
   Ga2 = (Ca2*tanD);
   Gb1 = (Cb1*tanD);
   Gb2 = (Cb2*tanD); 
   
   res(count  ).name = 'Ra1';res(count  ).node1 = n1;res(count  ).node2 = n2;res(count  ).val = Ra1;
   res(count+1).name = 'Ra2';res(count+1).node1 = n4;res(count+1).node2 = n3;res(count+1).val = Ra2;
   res(count+2).name = 'Rb1';res(count+2).node1 = n1;res(count+2).node2 = n4;res(count+2).val = Rb1;
   res(count+3).name = 'Rb2';res(count+3).node1 = n2;res(count+3).node2 = n3;res(count+3).val = Rb2;

   ind(count  ).name = 'La1';ind(count  ).node1 = n1;ind(count  ).node2 = n2;ind(count  ).branch = count;ind(count  ).val = La1;
   ind(count+1).name = 'La2';ind(count+1).node1 = n4;ind(count+1).node2 = n3;ind(count+1).branch = count + 1;ind(count+1).val = La2;
   ind(count+2).name = 'Lb1';ind(count+2).node1 = n1;ind(count+2).node2 = n4;ind(count+2).branch = count + 2;ind(count+2).val = Lb1;
   ind(count+3).name = 'Lb2';ind(count+3).node1 = n2;ind(count+3).node2 = n3;ind(count+3).branch = count + 3;ind(count+3).val = Lb2;
  
   if(isempty(tempi))
       ind(count  ).mutual = '';ind(count  ).node1b = n1b;ind(count  ).node2b = n2b;ind(count  ).mbranch = 0;ind(count  ).mval = -1;
       ind(count+1).mutual = '';ind(count+1).node1b = n4b;ind(count+1).node2b = n3b;ind(count+1).mbranch = 0;ind(count+1).mval = -1;
       ind(count+2).mutual = '';ind(count+2).node1b = n1b;ind(count+2).node2b = n4b;ind(count+2).mbranch = 0;ind(count+2).mval = -1;
       ind(count+3).mutual = '';ind(count+3).node1b = n2b;ind(count+3).node2b = n3b;ind(count+3).mbranch = 0;ind(count+3).mval = -1;
   else
       ind(count  ).mutual = 'La1b';ind(count  ).node1b = n1b;ind(count  ).node2b = n2b;ind(count  ).mbranch = ind(4*(nextPatchIndex-1) + 1).branch;ind(count  ).mval = La1b;
       ind(count+1).mutual = 'La2b';ind(count+1).node1b = n4b;ind(count+1).node2b = n3b;ind(count+1).mbranch = ind(4*(nextPatchIndex-1) + 2).branch;ind(count+1).mval = La2b;
       ind(count+2).mutual = 'Lb1b';ind(count+2).node1b = n1b;ind(count+2).node2b = n4b;ind(count+2).mbranch = ind(4*(nextPatchIndex-1) + 3).branch;ind(count+2).mval = Lb1b;
       ind(count+3).mutual = 'Lb2b';ind(count+3).node1b = n2b;ind(count+3).node2b = n3b;ind(count+3).mbranch = ind(4*(nextPatchIndex-1) + 4).branch;ind(count+3).mval = Lb2b;      
   end

   cap(count  ).name = 'Ca1';cap(count  ).node1 = n1;cap(count  ).node2 = n1b;cap(count  ).val = Ca1;
   cap(count+1).name = 'Ca2';cap(count+1).node1 = n2;cap(count+1).node2 = n2b;cap(count+1).val = Ca2;
   cap(count+2).name = 'Cb1';cap(count+2).node1 = n3;cap(count+2).node2 = n3b;cap(count+2).val = Cb1;
   cap(count+3).name = 'Cb2';cap(count+3).node1 = n4;cap(count+3).node2 = n4b;cap(count+3).val = Cb2;

   con(count  ).name = 'Ga1';con(count  ).node1 = n1;con(count  ).node2 = n1b;con(count  ).val = Ga1;
   con(count+1).name = 'Ga2';con(count+1).node1 = n2;con(count+1).node2 = n2b;con(count+1).val = Ga2;
   con(count+2).name = 'Gb1';con(count+2).node1 = n3;con(count+2).node2 = n3b;con(count+2).val = Gb1;
   con(count+3).name = 'Gb2';con(count+3).node1 = n4;con(count+3).node2 = n4b;con(count+3).val = Gb2;
   
   count = count + 4;
end


cres = size(res,2);cind = size(ind,2);ccap = size(cap,2); ccon = size(con,2);
nodes = [];indBranches = [];volts = struct([]);
cvolts = size(currentSources,1);
if((Lon == 1)||(Ron == 1))                                                  % Anoop - Understand
    for j = 1:cvolts
        volts(j).node1 = currentSources(j,1);
        volts(j).node2 = currentSources(j,2);
        volts(j).val = currentSources(j,3);
        volts(j).branch = j;
    end
else
    volts(1).node1 = 1;
    volts(1).node2 = 0;
    volts(1).val = 1;
    volts(1).branch = 1;
    indBranches = []; numIndBranches = 0;
end

for j = 1:cres
    nodes = [nodes,res(j).node1,res(j).node2];
end
for j = 1:cind
    nodes = [nodes,ind(j).node1,ind(j).node2,ind(j).node1b,ind(j).node2b];
    indBranches = [indBranches,ind(j).branch];
end
for j = 1:ccap
    nodes = [nodes,cap(j).node1,cap(j).node2];
end
for j = 1:ccon
    nodes = [nodes,con(j).node1,con(j).node2];
end
if(Con == 0)
    for j = 1:cvolts 
        nodes = [nodes,volts(j).node1,0];
    end
else    
    for j = 1:cvolts 
        nodes = [nodes,volts(j).node1,volts(j).node2];
    end
end

nodes = unique(nodes);[nr,nc] = find(nodes);nodes = nodes(1,nc);            % Anoop - Understand
numNodes = size(nodes,2);
if(isempty(indBranches))
else
    indBranches = unique(indBranches);
    [nr,nc] = find(indBranches);indBranches = indBranches(1,nc);
    numIndBranches = size(indBranches,2);   
end