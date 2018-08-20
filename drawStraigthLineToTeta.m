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
% Content: a goal of this function is to draw a mesh (fine or a coarse)
%          and present a straigth line from a starting tetrahedron to a tetrahedron
%          which contains a destination point.
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input:
% teta_list - an array with all found tetrahedra
% DestinationPoints -  an array with of all destination points
% Starting_teta - an array with starting tetrahera (selected by a jump phase)
% Nodes - array with nodes of fine mesh
% Teta  - array with tetrahedra of fine mesh
% Nodes_coarse - array with nodes of a coarse mesh
% Teta_coarse  - array with tetrahedra of a coarse
% radious - radious of a sphere which  represents a destination point/s in figures
% K - number of destination points to be drawn
% figno - number of a figure

function [] = drawStraigthLineToTeta(teta_list, DestinationPoints, Starting_teta, Teta,  Nodes, Teta_coarse,  Nodes_coarse, radious, K, figno1)

figure(figno1)

tetramesh(Teta_coarse, Nodes_coarse,'FaceAlpha',0.001,'edgecolor',[ 0.05 0.05 0.05]); hold on

N = K;
M = K;

for n=1:N
    tid = teta_list(n);
    drawTetrahedron( Teta(tid,:), Nodes, [0 0 1], [0 0 1], 0.2, 0 ); hold on
    
    [dest_x, dest_y, dest_z] = centerOfTetrahedron ( Teta(tid,:), Nodes );
    p2 = [dest_x, dest_y, dest_z] ;
    tids = Starting_teta(n,1);
    
    
    [start_x, start_y, start_z] = centerOfTetrahedron ( Teta(tids,:), Nodes );
    p1 = [start_x, start_y, start_z];
    
    %drawTetrahedron( Teta(tids,:), Nodes, [255/255 105/255 0], [255/255 105/255 0], 0.1, 0 ); hold on
    drawSphere( start_x, start_y, start_z, radious, [0 1 0 ]); hold on
    
    dp = p2-p1;
    quiver3(p1(1),p1(2),p1(3),dp(1),dp(2),dp(3),0,'color',[1 0 0],'LineWidth',1);
    

end

for m=1:M
    drawSphere( DestinationPoints(m,1), DestinationPoints(m,2), DestinationPoints(m,3), radious, [1 0 0]); hold on
end

caption = sprintf('Tetrahedra (blue) found during walk. Center of starting tetrahedron (green point).\nDistance from start to end of walk (red).\n');
title(caption, 'FontSize', 20);

xlabel({'x'}); ylabel({'y'}); zlabel({'z'});

%% Modify a view:
%view(3)
az = 30;    el = 30;    view(az, el);
%az = 5;    el = 30;    view(az, el);
%az = 0;    el = 0;    view(az, el);
hold off

end