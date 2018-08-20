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
% Content: a goal of a function  is to verify if a destination point lies on a face of a tetrahedra. 
%          If it is true, then all neighbours of a tetrahedron are verified if they also contain a destination point.
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input:
% destination_teta - index of a teta for which a verifiaction is made
% Teta  - array with tetrahedra
% Nodes - array with nodes
% Teta_neighbours  - array with neighbours of each tetrahedra
% destination_point - a destination point
% tol - a tolerance used in not obvious cases in which a significantly small determinants are clasified as a zero (see bellow)
% verbose

%% output:
% teta_byNeighbours - a list of tetrahedra which contain a destination point (which lies on a face of a tetrahedron)

function [teta_byNeighbours] = searchForOtherTetabyNeighbours (destination_teta, Teta, Teta_neigbours, Nodes, destination_point, tol, verbose )    
    % mapping nodes of a tetrahedra to have all faces counter clock wise 
    Q =[     1     2     3;
             1     3     4;
             1     4     2;
             2     4     3];
     
    teta_byNeighbours = [];
    
    %teta = Teta(destination_teta,:);
    
    num_neighbours = nnz(Teta_neigbours(destination_teta,:));
    neighbours     = Teta_neigbours(destination_teta,:);

    %% verify neighbours (through faces):
    k=1;
    for i = 1:num_neighbours
        tid = neighbours(1,i);
        t   = Teta(tid,:);
        %% verification if destination_point is inside neighbours of current_teta:
        [in_out, D0,D1,D2,D3,D4] = checkPointInsideTetrahedron( Nodes(t(1,1),1),Nodes(t(1,1),2),Nodes(t(1,1),3),...
                                                         Nodes(t(1,2),1),Nodes(t(1,2),2),Nodes(t(1,2),3),...
                                                         Nodes(t(1,3),1),Nodes(t(1,3),2),Nodes(t(1,3),3),...
                                                         Nodes(t(1,4),1),Nodes(t(1,4),2),Nodes(t(1,4),3),...
                                                         destination_point(1), destination_point(2), destination_point(3),...
                                                         1e-7,...
                                                         verbose );
        
        if (in_out==1)
            teta_byNeighbours(k) = tid;
            k=k+1;
            
            if(verbose==1)
                str = sprintf('[searchForOtherTetabyNeighbours] Point is ALSO in teta no. %d', tid); disp(str)
            end
        else
            if(verbose==1)
                
                str = sprintf('[searchForOtherTetabyNeighbours] Point is not in teta no. %d', tid); disp(str)
                
            end
        end
    end

end