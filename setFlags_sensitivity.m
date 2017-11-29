% global Ron Lon Con Gon senseRule rule sigma tanD miu miu0 eps eps0
Ron = 1;
Lon = 1;
Con = 1;
Gon = 1;
rule = 3;
sigma = 5.8e7; 
tanD = 0.02;
miu = 1;
miu0 = 4*pi*1e-7;
eps = 4; 
eps0 = 8.854e-12;
if(Ron == 0)
    sigma = Inf;
end
if(Lon == 0)
    miu = 0;
end
if(Con == 0)
    eps = 0;
else
    if(Gon == 0)
        tanD = 0;
    end
end

% path = 'C:\Users\Anoop\Downloads\Nikita-11-Feb\oneQuad\';
% filePath = [path,'bar.msh'];

% For two port analysis
% path = 'C:\Users\Anoop\Downloads\Nikita-11-Feb\sensitivityC11_hm_bar_2\';
% filePath = [path,'bar.msh'];

% For one port analysis
    % path = 'C:\Users\Anoop\Downloads\Nikita-11-Feb\sensitivityC11_hm_bar\';
    % filePath = [path,'bar.msh'];

 path = 'C:\Users\Anoop\Downloads\Nikita-11-Feb\Multilayer TestCases\enginMultilayerPlateCase\';
 filePath = [path,'enginPlateWithHole_400nodes.msh'];
 
% path = 'E:\Ph.D\Research\2.5D\NikitaRdc\enginMultilayerPlateCase\';
% filePath = [path,'enginPlateWithHole_400nodes.msh'];

% path = 'E:\Ph.D\Research\2.5D\NikitaRdc\sensitivityC7_1quad\';
% filePath = [path,'mesh.msh'];

% path = 'E:\Ph.D\Research\2.5D\NikitaRdc\sensitivityC10_hm\';
% filePath = [path,'rectangular_plate_hole_D0.msh'];

% path = 'E:\Ph.D\Research\2.5D\NikitaRdc\sensitivity_C12_bosch_case1\';
% filePath = [path,'3v_supply_bosch.msh'];

% path = 'E:\Ph.D\Research\2.5D\NikitaRdc\sensitivityC8_hm\';
% filePath = [path,'rectangular_plate.msh'];

% path ='E:\Ph.D\Research\2.5D\NikitaRdc\sensitivity_C13_pg_plane\';
% filePath = [path,'pg_plane_j3_2.msh'];
 
% path = 'E:\Ph.D\Research\2.5D\NikitaRdc\sensitivityC11_hm_bar\';
% filePath = [path,'bar.msh'];

% path = 'E:\Ph.D\Research\2.5D\NikitaRdc\sensitivity_C14_loop_inductance_swiss_cheese\';
% filePath = [path,'loop_inductance_j3_0.msh'];


addpath(path);