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
% Content: a goal of a function  is to verify if a destination point is a node of a mesh. 
%          If it is true, then all tetrahedra which contain such that node are found.
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input:
% destination_teta - index of a teta for which a verifiaction is made
% Teta  - array with tetrahedra
% Nodes - array with nodes
% destination_point - a destination point
% tol - a tolerance used in not obvious cases in which a significantly small determinants are clasified as a zero (see bellow)
% verbose

%% output:
% teta_byNode - a list of tetrahedra which contain a destination point (being a node)


function [teta_byNode] = searchForOtherTetabyNode(destination_teta, Teta, Nodes, destination_point, tol, verbose)

teta_byNode =[];

point_is_node = -1;

%% verify if point is a node:
for i = 1:4
    node = Teta(destination_teta,i);
    %str = sprintf('x: %f vs. %f', destination_point(1,1) , Nodes(node,1)); disp(str)
    %str = sprintf('y: %f vs. %f', destination_point(1,2) , Nodes(node,2)); disp(str)
    %str = sprintf('z: %f vs. %f', destination_point(1,3) , Nodes(node,3)); disp(str)
        
    %abs( (destination_point(1,1) - Nodes(node,1))/Nodes(node,1))
    %abs( (destination_point(1,2) - Nodes(node,2))/Nodes(node,2))
    %abs( (destination_point(1,3) - Nodes(node,3))/Nodes(node,3))
    
    if ( abs( (destination_point(1,1) - Nodes(node,1))) < tol  &&  abs( (destination_point(1,2) - Nodes(node,2))) < tol && abs( (destination_point(1,3) - Nodes(node,3))) < tol)
        point_is_node = node;
        
        if (verbose == 1 )
        str = sprintf('x: %f vs. %f', destination_point(1,1) , Nodes(node,1)); disp(str)
        str = sprintf('y: %f vs. %f', destination_point(1,2) , Nodes(node,2)); disp(str)
        str = sprintf('z: %f vs. %f', destination_point(1,3) , Nodes(node,3)); disp(str)
        end
        
        break;
    end
end
point_is_node;

%% if a destination point is a node of a mesh
if (point_is_node > 0)
    
    %% find all tethrahedra which contains a destination point
    [row_t, col_t] = find(Teta == point_is_node);

    num_neighboursByNode   = size(row_t,1);
    neighboursByNode = row_t';

    %% verify neighbours (through nodes):  
    k = 1;
    for i = 1:num_neighboursByNode
        tid = neighboursByNode (1,i);
        t   = Teta(tid,:);

        if tid == destination_teta
            continue;
        end

        %% verification if destination_point is inside:                                   
        [in_out] = checkPointInsideTetrahedron ( Nodes(t(1,1),1),Nodes(t(1,1),2),Nodes(t(1,1),3),...
                                         Nodes(t(1,2),1),Nodes(t(1,2),2),Nodes(t(1,2),3),...
                                         Nodes(t(1,3),1),Nodes(t(1,3),2),Nodes(t(1,3),3),...
                                         Nodes(t(1,4),1),Nodes(t(1,4),2),Nodes(t(1,4),3),...
                                         destination_point(1), destination_point(2), destination_point(3),...
                                         1e-7,...
                                         verbose);
                                     
        if (in_out==1)
            teta_byNode(k) = tid;
            k=k+1;
            if(verbose==1)
                str = sprintf('Point is ALSO in teta no. %d', tid); disp(str)
            end
        else
            if(verbose==1)
                str = sprintf('Point is not in teta no. %d', tid); disp(str)
            end
        end
    end
end
end