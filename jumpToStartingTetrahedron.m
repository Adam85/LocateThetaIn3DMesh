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
% Content: a goal of the function is to select a starting tetrahedron for a walk phase. 
%          [this is an implementation of a JUMP phase in a jump-and-walk algorithm]
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input:
% Teta  - array with tetrahedra of mesh
% Nodes - array with nodes of mesh
% destination_point - a destination point 
% nTeta - a number of tetrahedra in mesh
% TetaJump - a number of randomly selected tetrahedra

% output:
% starting point

function [starting_teta] = jumpToStartingTetrahedron(Teta, Nodes, destination_point, nTeta,  TetaJump)    
     
    N1 = nTeta;
    
    % a set of tetrahedra from which a tetrahedron of the smallest distance to a destination point is selected 
    sTeta  = randi([1 N1],1,TetaJump);
    
    min_distance = 10e8;
    min_index    = 1;
    
    for i=1:TetaJump
        tid = sTeta(i);
           
        [xi,yi,zi] = centerOfTetrahedron ( Teta(tid,:), Nodes );
        
        nodepoint = [xi,yi,zi];
        distance = sqrt ( (destination_point(1,1)  - nodepoint (1,1))^2 + (destination_point(1,2)  - nodepoint (1,2))^2 + (destination_point(1,3)  - nodepoint (1,3))^2);

        if (distance < min_distance)
            min_distance = distance;
            min_index = tid;
        end
    end
    
    starting_teta = min_index;
    
    
end