%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2018 Gdañsk University of Technology
% 
% Unless otherwise indicated, Source Code is licensed under MIT license.
% See further explanation attached in License Statement (distributed in the file LICENSE).
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the "Software"), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
% BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
% ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocateThetaIn3DMesh: Locate Tetrahedra in 3D Mesh
% Content: In this file the jump-and-walk algorithm is run
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all


%% Teta 
Teta  = [];

%% Nodes
Nodes = [];

%% Array in which the i-th row contains neighbours of i-th tetrahedron
Teta_neighbours = [];

%% Index of the starting teta (default equals to 1, but the JUMP phase selects better starting points):
starting_teta = 1;

%% Destination Point
%destination_point = [0.0, 0.0, 0.0];

%% vs_walk: type of walk, 0 - visibility walk, 1 - statistic walk
vs_walk = 2;

%% jump in to the first tetrahedron: jump = 0 (no jump), jump = 1 (selection of starting tetrahedron)
jump = 1;

%% maximal # of steps to terminate:
max_steps = 200;

%% Verbose walk: 
verbose = 0; % 1 - more data displayed during execution
             % 0 - less data displayed during execution

%% strategy: what should algorithm do in case the walk has looped
strategy = 1;     % 1 - go to the random neighbour
                  % 2 - go to the first neighbour
                  % 3 - go to the neighbour with minimal face_value (taken in orienation  test)
                  % 4 - break;

%% reference (naive) test                  
referenceTest = 1;
                  
%% Table required to map nodes of the tetrahedra such as all faces are counter clock-wise ordered:
Q = [1 2 3;  ... 
     1 3 4;  ...
     1 4 2; 
     2 4 3];

%% Load mesh:
pathSource=pwd; 
path_readExamples = [pathSource,'\mesh\','readExamples.m'];
path_plotJandW    = [pathSource,'\','plotJandW.m'];

%% Example-1:
% mesh of 68k tetrahedra with 3 destination points which are nodes of a mesh
[Nodes, Teta, Nodes_coarse, Teta_coarse, DestinationPoints, structname, radious] = readExamples_cubandspheres_few(3);

%% Example-2:
% mesh of 68k tetrahedra with 66 destination points which are nodes of a mesh
%[Nodes, Teta, Nodes_coarse, Teta_coarse, DestinationPoints, structname, radious] = readExamples_cubandspheres();

%% Example-3:
% mesh of 51k tetrahedra with 324 destination points which are nodes of a mesh
%[Nodes, Teta, Nodes_coarse, Teta_coarse, DestinationPoints, structname, radious] = readExamples_shaft(0,1);

% mesh of 51k tetrahedra with 324 destination points which are not nodes of a mesh
%[Nodes, Teta, Nodes_coarse, Teta_coarse, DestinationPoints, structname, radious] = readExamples_shaft(0,0);

% mesh of 409k tetrahedra with 324 destination points which are nodes of a mesh
%[Nodes, Teta, Nodes_coarse, Teta_coarse, DestinationPoints, structname, radious] = readExamples_shaft(1,1);

% mesh of 409k tetrahedra with 324 destination points which are not nodes of a mesh
%[Nodes, Teta, Nodes_coarse, Teta_coarse, DestinationPoints, structname, radious] = readExamples_shaft(1,0);


%% Collect neighbours for each tetrahedron based on Teta and Nodes
[Teta_neighbours,time_collectNeighbours] = collectNeighbours( Teta, Nodes );

%% No. of destination points:
NoOfPoints = size(DestinationPoints,1);
%NoOfPoints = 2;

%% Loop over different # of tetrahedra in a jump phase:
% nTests = 8;
% startingTetaPercTab = [5 1 0.5 0.1 0.05 0.01 0.005 0.001];

%% Single call for one setup of a jump phase:
nTests = 1;
startingTetaPercTab = 0.1;  
%startingTetaPercTab = 0.5;  
%startingTetaPercTab = 0.001; 

%% Profiling:
profile_on = 0; % 1 - Matlab profiler on
save_on    = 1; % 1 - save Matlab workspace in *.mat
log_on     = 1; % 1 - save Matlab comand window output

%% Draw /or not walking paths
plot_on = 0; % not draw walking paths 
% plot_on = 1; % draw walking paths (USE FOR coarse meshes)
% plot_on > 1; % draw more about walks (USE FOR coarse meshes)

%% OUTPUT structures of a JUMP-AND-WALK:
OUT_history=[];
OUT_teta_walking      = zeros(NoOfPoints,1,  nTests);
OUT_teta_byNodes      = zeros(NoOfPoints,10, nTests);
OUT_teta_byNeighbours = zeros(NoOfPoints,10, nTests);
OUT_teta_unique       = zeros(NoOfPoints,10, nTests);

OUT_naive_unique      = zeros(NoOfPoints,10, nTests);

OUT_starting_teta     = zeros(NoOfPoints,nTests);
OUT_ref_success       = zeros(NoOfPoints,nTests);

[nTeta, mTeta] = size(Teta);

%% Timers:
time_naive_all         = zeros(nTests,1);
time_jump_and_walk_all = zeros(nTests,1);
time_walk_all          = zeros(nTests,1);
time_jump_all          = zeros(nTests,1);
time_walk_stat_all     = zeros(nTests,5);
time_extra_jump        = zeros(nTests,1);

time_jump_and_walk_all_it = zeros(NoOfPoints, nTests);

speedup1 = zeros(NoOfPoints,nTests);
speedup2 = zeros(NoOfPoints,nTests);


%%  looped jump-and-walk algorithm (if extra_runs > 1: in case a walk did not found a destination point, then new jump is done and walk is repeated)
extra_runs   = 2;
rerun        = zeros(NoOfPoints,extra_runs);
if (extra_runs > 1)
    max_steps = 50;
end

for nt = 1:nTests

    %% profiling setup:
    walktype = 'none';
                
    if vs_walk == 1
           walktype = 'visibility_walk';            
    elseif vs_walk == 2
           walktype = 'stochastic_walk';
    else
        ;    
    end
       
    if (log_on==1)
        structname2log  = ['output\', structname,'_',walktype,'_p', num2str(startingTetaPercTab(nt)), '.log']
        diary off;
        diary(structname2log)
    end
    
    if (save_on==1)
        structname2mat  = ['output\', structname,'_',walktype,'_p', num2str(startingTetaPercTab(nt)), '.mat']
    end

    if (profile_on==1)
        structname2prof = ['output\', structname,'_',walktype,'_p', num2str(startingTetaPercTab(nt)) ]
        profile on
    end
    
    for n = 1:NoOfPoints
        str = sprintf('********** DESTINATION POINT %3d/%3d **********', n, NoOfPoints); disp(str);

        %% selection of a destination point
        destination_point = DestinationPoints(n,:);

        tjump = tic;
        if (jump == 1)
            
            startingTetaPerc = startingTetaPercTab(nt)/100; % in percentage

            startingTetaNum = ceil(nTeta*startingTetaPerc);
            [starting_teta] = jumpToStartingTetrahedron(Teta,Nodes,destination_point, nTeta, startingTetaNum);
            OUT_starting_teta(n,1) = starting_teta;
        else
            OUT_starting_teta(n,1) = starting_teta;
        end
        time_jump = toc(tjump);
        

        if verbose == 1
            %% Tetrahedra path (displayed during walk)
            figure(n*10+1)
            view(3)

            % destination point:
            drawSphere( destination_point(1,1), destination_point(1,2), destination_point(1,3), radious, [1 1 0]); hold on

            tetramesh(Teta, Nodes,'FaceAlpha',0.01,'EdgeColor',[0.9 0.9 0.9]); hold on
            axis([-0.1+min(Nodes(:,1))  0.1+max(Nodes(:,1)) -0.1+min(Nodes(:,2))  0.1+max(Nodes(:,2)) -0.1+min(Nodes(:,3))  0.1+max(Nodes(:,3))   ])

        end
     
        %% A WALK PHASE:
        twalk = tic;
            
        run = 1;

        startingTetaPercnew = startingTetaPercTab;
        max_steps_new = max_steps;
        while (run <= extra_runs )

                if vs_walk == 1
                    [t_exit, history, success ] = visibility_walk_3D( Teta, Nodes, Teta_neighbours, starting_teta, destination_point, max_steps,  strategy, verbose);
                elseif vs_walk == 2
                    [t_exit, history, success ] = stochastic_walk_3D( Teta, Nodes, Teta_neighbours, starting_teta, destination_point, max_steps,  strategy, verbose) ;                         
                else
                    str = sprintf('Walk type is undefined!'); disp(str);
                end


                if (success==1)
                    break;
                else
                    textrajump = tic;
                    rerun (n,run) = -1;

                    if (1) 
                        if (nTeta < 100000)
                            startingTetaPercnew = 0.5/100; %max_steps_new = 100;
                        else
                            startingTetaPercnew = 0.1/100; %max_steps_new = 100;
                        end
                        startingTetaNum = ceil(nTeta*startingTetaPercnew);
                    end

                    [starting_teta] = jumpToStartingTetrahedron (Teta,Nodes,destination_point, nTeta, startingTetaNum);
                    OUT_starting_teta(n,1) = starting_teta; 

                    time_extra_jump(nt) = time_extra_jump(nt)+toc(textrajump);

                end
                run = run+1;

        end
        time_walking_only = toc(twalk);

        tbynodes=tic;
        [teta_byNode]       = searchForOtherTetabyNode(history.onPath(end),Teta,Nodes,destination_point,1e-7,verbose);
        time_walking_byNode = toc(tbynodes);

        tbyneighb=tic;
        [teta_byNeighbours] = searchForOtherTetabyNeighbours(history.onPath(end),Teta,Teta_neighbours,Nodes,destination_point,1e-2,verbose);    
        time_walking_byNeighbours = toc(tbyneighb);

        tunique=tic;
        teta_walking = unique([history.onPath(end), teta_byNode, teta_byNeighbours]);
        time_walking_unique = toc(tunique);

        time_walking = time_walking_only + time_walking_byNode + time_walking_byNeighbours + time_walking_unique;

        OUT_history(n,nt).history = history;
        OUT_teta_walking(n,1,nt)                                = history.onPath(end);
        OUT_teta_byNodes(n,1:size(teta_byNode,2),nt)            = teta_byNode;
        OUT_teta_byNeighbours(n,1:size(teta_byNeighbours,2),nt) = teta_byNeighbours;
        OUT_teta_unique(n,1:size(teta_walking,2),nt)            = teta_walking;
        OUT_teta_success(n,1,nt)                                = success;

        time_jump_and_walk_all(nt) = time_jump_and_walk_all(nt) + ( time_jump + time_walking);   

        time_jump_and_walk_all_it(n,nt) = time_jump + time_walking;
        
        time_walk_stat_all(nt,2)   = time_walk_stat_all(nt,2)          + (time_walking_only);
        time_walk_stat_all(nt,3)   = time_walk_stat_all(nt,3)          + (time_walking_byNode);
        time_walk_stat_all(nt,4)   = time_walk_stat_all(nt,4)          + (time_walking_byNeighbours);
        time_walk_stat_all(nt,5)   = time_walk_stat_all(nt,5)          + (time_walking_unique);

        time_walk_all(nt)          = time_walk_all(nt)          + (time_walking);
        time_jump_all(nt)          = time_jump_all(nt)          + (time_jump) ;

                
        % reference naive test:
        if (referenceTest==1)
            %[teta_naive, time_naive] = findTetaNaive (Teta,Nodes,destination_point,  verbose);
            [teta_naive, time_naive] = findTetaSimpleLoop (Teta,Nodes,destination_point,Teta_neighbours,   verbose);
            
            OUT_naive_unique(n,1:size(teta_naive,2),nt)            = teta_naive;

            speedup1(n,nt) = time_naive/(time_jump+time_walking);
            speedup2(n,nt) = time_naive/time_walking;

            time_naive_all(nt)         = time_naive_all(nt)         + (time_naive);
            
                        
            if(1)
                %figure(n*10+6)
                %drawTetaNaive(teta_naive, Teta,  Nodes, destination_point, radious)
 
                if (nnz (sort(teta_walking) - teta_naive) == 0)
                    str = sprintf('[CORRECT] Reference and walking algorithm found the same tetas'); disp(str);
                    tetas = [teta_walking', teta_naive'];
                    OUT_ref_success (n,nt) = 1;
                else
                    str = sprintf('[ERROR]    Reference and walking algorithm did not find the same tetas'); disp(str);
                    OUT_ref_success (n,nt) = -1;
                end
            end    
        end
        
        if(plot_on==1)     
            t1=tic;
            plotpath (Teta, Nodes, Teta_coarse, Nodes_coarse, OUT_history(n,nt).history, destination_point, radious, 100+n);
            t1e=toc(t1);
        end
        
    end

if (profile_on==1)
    disp('save profile...')
    profile off
    profsave(profile('info'),structname2prof)
end

if (plot_on > 1)    

    t1=tic;
    drawTetaList            (OUT_teta_walking(:,:,nt), starting_teta, DestinationPoints, Teta,  Teta_coarse, Nodes,  Nodes_coarse, radious, NoOfPoints,1000*nt+1)
    t1a=toc(t1)
     
    t1=tic;
    drawTetaListAll         (OUT_teta_unique(:,:,nt),  starting_teta, DestinationPoints, Teta,  Teta_coarse, Nodes,  Nodes_coarse, radious, NoOfPoints,1000*nt+2)
    t1b=toc(t1)
    
    t1=tic;
    drawStraigthLineToTeta (OUT_teta_walking(:,:,nt), DestinationPoints, OUT_starting_teta, Teta,  Nodes,  Teta_coarse,  Nodes_coarse, radious, NoOfPoints,1000*nt+3)
    t1c=toc(t1)
    
end

%global_success = [ nnz(find(OUT_teta_success(:,:,nt)==1)) nnz(find(OUT_teta_success(:,:,nt)==-1))]

%% Statistics:
str = sprintf('\nNo. of tetrahedra = %d\nNo. of DestinationPoints = %d \n', nTeta, NoOfPoints ); disp(str)

str = sprintf('| Success: %d | Failed: %d | All: %d |\n', nnz(find(OUT_teta_success(:,:,nt)==1)), nnz(find(OUT_teta_success(:,:,nt)==-1)), size(OUT_teta_success(:,:,nt),1)); disp(str)


if (0) %tetrahedra
    disp('OUT_teta_walking:')
    OUT_teta_walking(n,1,nt)  
    disp('OUT_teta_byNodes:')
    OUT_teta_byNodes(n,1:size(teta_byNode,2),nt)            
    disp('OUT_teta_byNeighbours:')
    OUT_teta_byNeighbours(n,1:size(teta_byNeighbours,2),nt) 
    disp('OUT_teta_unique:')
    OUT_teta_unique(n,1:size(teta_walking,2),nt)     
end

%% time correction (in case there were reruns): 
time_jump_all(nt) = time_jump_all(nt)+time_extra_jump(nt);
time_walk_all(nt) = time_walk_all(nt)-time_extra_jump(nt);
time_walk_stat_all(nt,2) = time_walk_stat_all(nt,2) - time_extra_jump(nt);

%% time overhead due to calculation of neighbours:
time_walk_all(nt)          = time_walk_all(nt) + time_collectNeighbours;
time_walk_stat_all(nt,1)   = time_walk_stat_all(nt,1) + time_collectNeighbours;
time_jump_and_walk_all(nt) = time_jump_and_walk_all(nt) + time_collectNeighbours;

str = sprintf('\n*** Teta(in)Jump = %1.3f %% ****', startingTetaPercTab(nt) ); disp(str);

if (referenceTest==1)
    str = sprintf('Time naive = %1.3f s', time_naive_all(nt)); disp(str)
end

str = sprintf('Time jump-and-walk   = %1.3f s\n', time_jump_and_walk_all(nt)); disp(str)

disp('JUMP&WALK stats:')
str = sprintf('Time of jump  = %1.3f s [%1.1f%%]', time_jump_all(nt), 100*time_jump_all(nt)/(time_jump_and_walk_all(nt)) ); disp(str)
str = sprintf('Time of walk  = %1.3f s [%1.1f%%]\n', time_walk_all(nt), 100*time_walk_all(nt)/(time_jump_and_walk_all(nt)) ); disp(str)

disp('JUMP stats:')
str = sprintf('Time jump  = %1.3f s >>>\n jump(random)  = %1.3f\n rerun(random) = %1.3f\n', time_jump_all(nt), time_jump_all(nt)-time_extra_jump(nt), time_extra_jump(nt) ); disp(str)

disp('WALK stats:')
str = sprintf('Time walk  = %1.3f s >>>\n (Init) collect Neighbours             = %1.3f s [%1.1f%%]\n WALK (%s)                = %1.3f s [%1.1f%%]\n (Post) Tetrahedra-by-Node             = %1.3f s [%1.1f%%]\n (Post) Tetrahedra-by-Neighbours(Face) = %1.3f s [%1.1f%%]\n (Post) Unique tetrahedra              = %1.3f s [%1.1f%%]\n', sum(time_walk_stat_all(nt,:)), ...
                                                                                                                                   time_walk_stat_all(nt,1), 100*time_walk_stat_all(nt,1)/(sum(time_walk_stat_all(nt,:))), walktype, ...
                                                                                                                                   time_walk_stat_all(nt,2), 100*time_walk_stat_all(nt,2)/(sum(time_walk_stat_all(nt,:))),...
                                                                                                                                   time_walk_stat_all(nt,3), 100*time_walk_stat_all(nt,3)/(sum(time_walk_stat_all(nt,:))),...
                                                                                                                                   time_walk_stat_all(nt,4), 100*time_walk_stat_all(nt,4)/(sum(time_walk_stat_all(nt,:))),...
                                                                                                                                   time_walk_stat_all(nt,5), 100*time_walk_stat_all(nt,5)/(sum(time_walk_stat_all(nt,:))) ); disp(str)
if (referenceTest==1)
    str = sprintf('Speedup jump-and-walk vs. Reference  = %1.1f', time_naive_all(nt)/time_jump_and_walk_all(nt)); disp(str)
    str = sprintf('Speedup walk(only)    vs. Reference  = %1.1f\n', time_naive_all(nt)/time_walk_all(nt)); disp(str)
end

str = sprintf('*** *** ****'); disp(str);




%% Statistics of the walking path:
str = sprintf('Statistics of the walking path:\n');disp(str);
OnPath_Wrong = zeros(NoOfPoints, 2);
for i = 1:NoOfPoints
    OnPath_Wrong(i,1) = nnz(OUT_history(i,nt).history.onPath);
    OnPath_Wrong(i,2) = nnz(OUT_history(i,nt).history.wrong);
end
AveragePath = [mean(OnPath_Wrong(:,1)) mean(OnPath_Wrong(:,2))];
SumPath = [ sum(OnPath_Wrong(:,1)) sum(OnPath_Wrong(:,2))];
str = sprintf('Average: onPath = %1.1f wrong = %1.1f', AveragePath(1,1), AveragePath(1,2)); disp(str)
str = sprintf('Summary: onPath = %d wrong = %d\n', SumPath(1,1), SumPath(1,2)); disp(str)

TetaFound = zeros(NoOfPoints, 4);
for i = 1:NoOfPoints
    % walking:
    TetaFound(i,1) = nnz(OUT_teta_walking(i,:,nt));
    % unique:
    TetaFound(i,2) = nnz(OUT_teta_unique(i,:,nt));
    % by Nodes:
    TetaFound(i,3) = nnz(OUT_teta_byNodes(i,:,nt));
    % by Neighbours:
    TetaFound(i,4) = nnz(OUT_teta_byNeighbours(i,:,nt));   
end
str = sprintf('[walking] [unique] [byNodes] [byNeigh]'); disp(str);
TetaFound;
AverageTetaFound = [mean(TetaFound(:,1)) mean(TetaFound(:,2)) mean(TetaFound(:,3)) mean(TetaFound(:,4))];
SumTetaFound     = [ sum(TetaFound(:,1)) sum(TetaFound(:,2)) sum(TetaFound(:,3)) sum(TetaFound(:,4))];
str = sprintf('Average: walking = %1.1f unique = %1.1f byNodes = %1.1f byNeigh = %1.1f', AverageTetaFound(1,1), AverageTetaFound(1,2), AverageTetaFound(1,3), AverageTetaFound(1,4)); disp(str)
str = sprintf('Summary: walking = %d unique = %d byNodes = %d byNeigh = %d\n', SumTetaFound(1,1), SumTetaFound(1,2), SumTetaFound(1,3), SumTetaFound(1,4)); disp(str)

str = sprintf('*** *** ****'); disp(str);


end

if (referenceTest==1)
    idx_success = find(OUT_ref_success==-1);
    if (length(idx_success) == 0 )
        str = sprintf('REFERENCE loop and Jump-and-Walk have found THE SAME  tetrahedra' ); disp(str)
    else
        str = sprintf('REFERENCE loop and Jump-and-Walk have found %d of %d different tetrahedra', nnz(idx_success), nnz(OUT_teta_unique) ); disp(str)
    end
    
    str = sprintf('*** *** ****'); disp(str);
end

if (log_on==1)
    diary off
end
if (save_on==1)
    save(structname2mat)
end

