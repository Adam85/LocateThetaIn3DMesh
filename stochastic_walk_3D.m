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
% Content: a goal of this function is to find a tetrahedron which contains a destination point
%          [this is an implementation of a WALK phase in a jump-and-walk algorithm]
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% intput:
% Teta  - an array of tetrahedra 
% Nodes - an array of nodes 
% Teta_neigbours - an array of neighbours of each tetrahedra
% current_teta - at the beggining it is a starting tetrahedron
% destination_point -  a destination points
% max_steps - maximal number of steps that can be made by a walk
% strategy  - strategy used in case a walk is looped
% verbose

%% output:
% t_exit  - index of a tetrahedron
% history - structure that contains details of a walk 
% success - a flag equals to 1 if a tethrahedron that contains a destination point has been found



function [t_exit, history, success] = stochastic_walk_3D( Teta, Nodes, Teta_neigbours, current_teta, destination_point, max_steps, strategy, verbose)
%% Table required to map nodes of the tetrahedra such as all faces are counter clock-wise ordered:
Q = [1 2 3;  ... 
     1 3 4;  ...
     1 4 2; 
     2 4 3];
%% Counter Clock-wise oder of face nodes:
CW_CCW = 2;

% t - array with current_teta nodes:
t      = Teta(current_teta,:);

% t_exit - array with nodes of teta that includes destination_point:
t_exit = NaN;

%% history is a structure with information about:
% history.teta_i  - index of current teta
% history.centers - [3x1] array with x,y,z, coordinates of each teta centers on path from starting to destinetion teta ?
% history.onPath  - indices of tetas visited on path from starting to destinetion teta
% history.wrong   - indices of tetas visited on path but verified as wrong and omitted 

history.teta_i = 1;
history.centers = zeros(max_steps,3);

[xi,yi,zi] = centerOfTetrahedron( t, Nodes );
history.centers(history.teta_i,1) = xi;
history.centers(history.teta_i,2) = yi;
history.centers(history.teta_i,3) = zi;

if (verbose == 1)
    text(xi,yi,zi,['   ' num2str(current_teta)],'HorizontalAlignment','left','FontSize',8,'Color',[1 0 0]);
end

history.onPath = zeros(1,max_steps);
history.wrong  = zeros(1,max_steps);

%% initialization:
history.onPath(1) = current_teta;

%% sum of signs from orientation test:
sumOfOrientations = 0; % if during waking sumOfOrientations==-4 it means that there is no other teta that we can move to.

%% current iteration/step
step = 1;

%% counter of tetas that verified as wrong and omitted
wrong_step = 1;

%% index of teta from previous step:
previous_teta = -1;



while (sumOfOrientations ~= -4  & history.teta_i < max_steps)
    if (verbose==1)
        str = sprintf('---------------------------------------------------------------\n'); disp(str);

        str = sprintf('[STOCHASTIC WALK v12] Current_iteration = %d, current_teta = %d NODES of teta: (%1.1f,%1.1f);(%1.1f,%1.1f);(%1.1f,%1.1f)', ...
                        history.teta_i, current_teta, ...
                        Nodes(t(1,1),1), Nodes(t(1,1),2), Nodes(t(1,2),1), Nodes(t(1,2),2), Nodes(t(1,3),1), Nodes(t(1,3),2)); 
        disp(str)
    end
           
    %% verification if destination_point is inside a current_teta:  
    [success] = checkPointInsideTetrahedron( Nodes(t(1,1),1),Nodes(t(1,1),2),Nodes(t(1,1),3),...
                                     Nodes(t(1,2),1),Nodes(t(1,2),2),Nodes(t(1,2),3),...
                                     Nodes(t(1,3),1),Nodes(t(1,3),2),Nodes(t(1,3),3),...
                                     Nodes(t(1,4),1),Nodes(t(1,4),2),Nodes(t(1,4),3),...
                                     destination_point(1), destination_point(2), destination_point(3),...
                                     1e-7,...
                                     verbose);
    if (success==1)
        t_exit = current_teta;
            if (verbose==1)
            str = sprintf('Point is in teta no. %d\n', current_teta); disp(str)
            end
        
        break;
    else
        if (verbose==1)
            str = sprintf('Point is not in teta no. %d\n', current_teta); disp(str)
        end
    end
    
    
    %% orientation test for 4 faces of current_teta
    %[face_orientation, face_value] = faceOrientationTest( t, Q, Nodes, destination_point, CW_CCW, current_teta, verbose);
    %sumOfOrientations = sum(face_orientation);
    face_orientation = zeros(4,1);
    face_value       = zeros(4,1);
    
    %% index of previous teta
    previous_teta = current_teta;
    
    %% search for the next teta
        
    %if (sumOfOrientations ~= -4)
    if (success ~= 1)
        if (verbose==1)
            disp('Select a new teta:')
        end
    
         
    
        history.teta_i = history.teta_i+1;
                
        %% random ordering of 4 faces:       
        face_order = randperm(4);
        
        for jj=1:4 %% loop over 4 faces (directions) 
            
            i = face_order(jj);  
         
            [face_orientation(i), face_value(i)] = singleFaceOrientationTest( t, Q, Nodes, destination_point, CW_CCW, current_teta, i, verbose);
            sumOfOrientations = sum(face_orientation);
            
            if (verbose==1)
                if (face_orientation(i) > 0)
                    str = sprintf('[POSITIVE ORIENTATION] [%d/%d] Face: %d -> %d -> %d', i, 4, t(1,Q(i,1)), t(1,Q(i,2)), t(1,Q(i,3)) ); disp(str);
                else
                    str = sprintf('[WRONG ORIENTATION   ] [%d/%d] Face: %d -> %d -> %d', i, 4, t(1,Q(i,1)), t(1,Q(i,2)), t(1,Q(i,3)) ); disp(str);
                end    
            end
            
            if (face_orientation(i) > 0)
                % current_tetai - copy of current_teta:
                current_tetai = current_teta;
                
                %% Find a new teta by the same 3 nodes
                current_teta = findTetaNeighboursBy3Nodes( Teta, Teta_neigbours, t(1,Q(i,1)), t(1,Q(i,2)), t(1,Q(i,3)), current_teta, verbose );
                
                
                %% verification if the selected new teta was not visited before:
                if (current_teta>0 & isempty(find(history.onPath==current_teta))==1 )
                    
                    %str = sprintf('step = %d, IF\n', step); disp(str)
                    if (verbose==1)
                        str = sprintf('[step = %d], current_teta=%d (from %d face) NOT visited before.\n', step, current_teta, i); disp(str)
                    end
                    
                    t = Teta(current_teta,:);
                    
                    step=step+1;
                    
                    history.onPath(step) = current_teta;
                    
                    [xi,yi,zi] = centerOfTetrahedron( t, Nodes );
                    history.centers(history.teta_i,1) = xi;
                    history.centers(history.teta_i,2) = yi;
                    history.centers(history.teta_i,3) = zi;
                    
                    t_exit = t;
                    if verbose==1
                        text(xi,yi,zi,['   ' num2str(current_teta)],'HorizontalAlignment','left','FontSize',4,'Color',[1 0 0]);
                        
                        drawTetrahedron( Teta(current_teta,:) , Nodes, [0 0  1], [0 0 1], 1.0, 1 );
                        
                        %pause(0.05)
                    end
                
                    %% break the loop over 4 faces
                    break;
                else
                    %str = sprintf('step = %d, ELSE\n', step); disp(str)
                    if (verbose==1)
                        str = sprintf('[step = %d], current_teta=%d visited before.\n', step, current_teta); disp(str)
                    end
                    
                    %% recover current_teta from a backup:
                    current_teta = current_tetai;
                    t_exit = current_teta;
                end
                
            end % end of if with positive oriented faces            
        end % end of loop over faces
        
        % The following condition is fired in case the former loop over
        % faces did not selected a new teta due to:
        % - wrong (negative) oreintation
        % - selected a new teta that was visited before
        % In such a case a current_teta is written in history.wrong array
        % and one randomly/other selects a new teta to visit from
        % neighbours of current_teta.
        
     
        if (step > 1 && previous_teta == current_teta)
            
            %break;
            
            if (verbose==1)
            str = sprintf('\n>>> >>> >>> >>> >>> >>> >>> >>> >>> >>> >>> >>> >>> >>> >>> >>>\n'); disp(str);          
            str = sprintf('WARRINIG!!! Walk has looped but we try to move!'); disp(str)
            end
            
            
            history.wrong(wrong_step) = current_teta;
            wrong_step = wrong_step+1;
                      
            %history.wrong
            
            
            ii = 0;
            
            %% random neighbour:
            if strategy==1
                neighb_order = randperm(nnz(Teta_neigbours(current_teta,:)));      
                ii = neighb_order(1);
            end
            
            %% first neighbour from list:
            if strategy==2
                ii = 1;
            end
            
            %% neighbour of minimal face_value:
            if strategy==3
                %ii = find(min( face_value ));
                if (0) % no remebering
                    ii = find(min( face_value ))
                    current_teta = Teta_neigbours(current_teta, ii)
                end
                
                if (1) % no remebering
                    %Teta_neigbours(current_teta,:)
                    %face_value
                    
                    [sort_val, sort_list] = sort(face_value,  'ascend')
                    
                    
                    ii = sort_list(1)
                    
                    new_teta = findTetaNeighboursBy3Nodes( Teta, Teta_neigbours, t(1,Q(ii,1)), t(1,Q(ii,2)), t(1,Q(ii,3)), current_teta, verbose )
                    
                    %current_teta = Teta_neigbours(current_teta, ii)
                    current_teta = new_teta
                end
                
                if (0) % no remebering
                    %Teta_neigbours(current_teta,:)
                    %face_value
                    
                    [sort_val, sort_list] = sort(face_value, 'descend')
                    
                    
                    ii = sort_list(1)
                    
                    new_teta = findTetaNeighboursBy3Nodes( Teta, Teta_neigbours, t(1,Q(ii,1)), t(1,Q(ii,2)), t(1,Q(ii,3)), current_teta, verbose )
                    
                    %current_teta = Teta_neigbours(current_teta, ii)
                    current_teta = new_teta
                end
                
            end
            
            if strategy==4
                break;
            end 
            
            
            current_teta_neighbours = Teta_neigbours(current_teta,:);
           
            if (verbose==1)
                disp('List of neighbours:')
                for in=1:nnz(current_teta_neighbours)
                    str = sprintf('%d\t', current_teta_neighbours(1,in) ); disp(str);
                end
            end
            
            %middle_t = current_teta;
            if strategy==1 | strategy==2  
                current_teta = Teta_neigbours(current_teta, ii);
            end
           
            %str = sprintf('Next teta selected from neighbours is %d\n', current_teta ); disp(str);
            
            if (1)
                t = Teta(current_teta,:);
                step=step+1;
                history.onPath(step) = current_teta;

                [xi,yi,zi] = centerOfTetrahedron( t, Nodes );
                history.centers(history.teta_i,1) = xi;
                history.centers(history.teta_i,2) = yi;
                history.centers(history.teta_i,3) = zi;
                
                t_exit = t;
                
                if verbose==1
                    text(xi,yi,zi,['   ' num2str(current_teta)],'HorizontalAlignment','left','FontSize',4,'Color',[1 0 0]);
                    
                    drawTetrahedron( Teta(current_teta,:) , Nodes, [0 0  1], [0 0 1], 1.0, 1 );
                    
                    %pause(0.05)
                    
                end
            end
            
            str_help = '';
            
            if (strategy==1)
                str_help = 'random';
            elseif(strategy==2)
                str_help = 'first neighbour';
            elseif(strategy==1)
                str_help = 'min(face_value) neighbour';
            else
                str_help = 'break';
            end
             
            if (verbose==1)
                str = sprintf('[step = %d], due to [%s] variant current_teta=%d was selected! (no of wrong_steps = %d of %d all steps) \n', step, str_help, current_teta, wrong_step, step); disp(str)
                str = sprintf('<<< <<< <<< <<< <<< <<< <<< <<< <<< <<< <<< <<< <<< <<< <<< <<<\n'); disp(str);
            end
        end
    
    else
        disp('Found the teta that includes testination point:')
        t_exit = Teta(current_teta,:)
        history.centers(history.teta_i+1:end,:) = [];
        
        [xi,yi,zi] = centerOfTeta( t_exit, Nodes );
        history.centers(history.teta_i,1) = xi;
        history.centers(history.teta_i,2) = yi;
        history.centers(history.teta_i,3) = zi;
        
        if (verbose==1)
            text(xi,yi,zi,['   ' num2str(current_teta)],'HorizontalAlignment','left','FontSize',8,'Color',[1 0 0]);     
                        
            drawTetrahedron( Teta(current_teta,:) , Nodes, [1 0  0], [1 0 0], 1.0, 1 );
            
        end
        
    end    
end % end of walk

K = nnz(history.onPath);
history.onPath((K+1):max_steps)  = [];
K = nnz(history.wrong);
history.wrong(K+1:end) = [];

end % end of function