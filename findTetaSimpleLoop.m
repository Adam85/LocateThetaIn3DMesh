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
% Content: a goal of this function is to find in a simple  way a tetrahedron which contains a destination points
%          loop breaks when a tetrahedron is found, and additinal verifications are made to check if there are other
%          tetrahedra which contain a destination point  through a common node or a common face.
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

function [teta_list, timer] = findTetaSimpleLoop(Teta,Nodes,destination_point,Teta_neighbours, verbose)

    timer_start = tic;

    teta_list = [];
    time_walking_byNode = 0;
    time_walking_byNeighbours = 0;

    for k=1:size(Teta,1)

        t = Teta(k,:);

        [in_out, D0,D1,D2,D3,D4] = checkPointInsideTetrahedron ( Nodes(t(1,1),1),Nodes(t(1,1),2),Nodes(t(1,1),3),...
                                         Nodes(t(1,2),1),Nodes(t(1,2),2),Nodes(t(1,2),3),...
                                         Nodes(t(1,3),1),Nodes(t(1,3),2),Nodes(t(1,3),3),...
                                         Nodes(t(1,4),1),Nodes(t(1,4),2),Nodes(t(1,4),3),...
                                         destination_point(1), destination_point(2), destination_point(3),...
                                         1e-7,...
                                         verbose);

        if (in_out==1) %% tetrahedron t contains a destination point

            if (verbose == 1)
                str = sprintf('[NAIVE TEST] Point is in teta no. %d', k); disp(str)
            end

            %% verification if a destination_point is a Node and as a result a destination_point belongs to more than one tetrahedron
            tbynodes=tic;
            [teta_byNode]       = searchForOtherTetabyNode(k,Teta,Nodes,destination_point,1e-7,verbose);
            time_walking_byNode = time_walking_byNode + toc(tbynodes);

            %% verification if a destination_point lies on a face of a tetrahedron and as a result a destination_point belongs to more than one tetrahedron
            tbyneighb=tic;
            [teta_byNeighbours] = searchForOtherTetabyNeighbours(k,Teta,Teta_neighbours,Nodes,destination_point,1e-2,verbose);    
            time_walking_byNeighbours = time_walking_byNeighbours + toc(tbyneighb);

            %% an uniqe list of tetrahedra that contain a destination point
            teta_list = unique( [k, teta_byNode, teta_byNeighbours]);

            break;
        end
    end
    timer=toc(timer_start);

end