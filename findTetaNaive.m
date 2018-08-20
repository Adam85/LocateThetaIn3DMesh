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
% Content: a goal of this function is to find in a naive way a tetrahedron which contains a destination points
%          loop does not break when a tetrahedron is found, since there may be other tetrahedra which contain 
%          a destination point through a common node or a common face.
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input: 
% Teta  - array with tetrahedra
% Nodes - array with nodes
% destination_point - a destination point
% Teta_neighbours  - array with neighbours of each tetrahedra
% verbose - a flag

%% output:
% teta_list - an uniqe list of tetrahedra that contain a destination point
% timer - time taken by a function findTetaSimpleLoop

function [teta_naive, time_naive] = findTetaNaive(Teta,Nodes,destination_point,verbose)
teta_naive = zeros(4,1);
ti = 1;
tic
for k=1:size(Teta,1)
    t = Teta(k,:);
    
    [in_out, D0,D1,D2,D3,D4] = checkPointInsideTetrahedron ( Nodes(t(1,1),1),Nodes(t(1,1),2),Nodes(t(1,1),3),...
                                     Nodes(t(1,2),1),Nodes(t(1,2),2),Nodes(t(1,2),3),...
                                     Nodes(t(1,3),1),Nodes(t(1,3),2),Nodes(t(1,3),3),...
                                     Nodes(t(1,4),1),Nodes(t(1,4),2),Nodes(t(1,4),3),...
                                     destination_point(1), destination_point(2), destination_point(3),...
                                     1e-7,...
                                     verbose);
                                
    if (in_out==1)
        
        if (verbose==1)
            str = sprintf('[NAIVE TEST] Point is in teta no. %d', k); disp(str)
        end
        
        teta_naive(ti) = k;
        ti=ti+1;
        
    end
    
    
    
end
time_naive=toc;
teta_naive(ti:end)=[];
teta_naive = teta_naive';
end