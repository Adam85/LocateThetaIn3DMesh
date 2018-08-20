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
%          and present tetrahedra found during walks which contain  destination points
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% input:
% teta_list - an array with tetrahedra found in a walk (visibility or stochastic)
% teta_start - a single tetrahedron selected by a jump phase from which a walk starts 
% DestinationPoints -  an array with of all destination points
% Nodes - array with nodes of fine mesh
% Teta  - array with tetrahedra of fine mesh
% Nodes_coarse - array with nodes of a coarse mesh
% Teta_coarse  - array with tetrahedra of a coarse
% radious - radious of a sphere which  represents a destination point/s in figures
% K - number of destination points to be drawn
% figno - number of a figure

function [] = drawTetaList(teta_list, teta_start, DestinationPoints, Teta,  Teta_corse, Nodes,  Nodes_corse, radious, K, figno1) %,figno2)

figure(figno1)
subplot(1,2,1)
tetramesh(Teta_corse, Nodes_corse,'FaceAlpha',0.001,'edgecolor',[ 0.05 0.05 0.05]); hold on
N = K;
M = K;

tid = teta_start(1);
%drawTetrahedron( Teta(tid,:), Nodes, [1 0 1], [1 0 1], 1, 0 ); hold on

for n=1:N
    tid = teta_list(n);
    drawTetrahedron( Teta(tid,:), Nodes, [0 0 1], [0 0 1], 1, 0 ); hold on
end

for m=1:M
    drawSphere( DestinationPoints(m,1), DestinationPoints(m,2), DestinationPoints(m,3), radious, [1 0 0]); hold on
end

title('[CORSE MESH] Tetrahedra found from corse mesh');

xlabel({'x'}); ylabel({'y'}); zlabel({'z'});
%view(3)
az = 0;    el = 30;    view(az, el);
hold off


subplot(1,2,2)
tetramesh(Teta, Nodes,'FaceAlpha',0.001,'edgecolor',[ 0.05 0.05 0.05]); hold on
N = K;
M = K;

tid = teta_start(1);
drawTetrahedron( Teta(tid,:), Nodes, [1 0 1], [1 0 1], 1, 0 ); hold on

for n=1:N
    tid = teta_list(n);
    drawTetrahedron( Teta(tid,:), Nodes, [0 0 1], [0 0 1], 1, 0 ); hold on
end

for m=1:M
    drawSphere( DestinationPoints(m,1), DestinationPoints(m,2), DestinationPoints(m,3), radious, [1 0 0]); hold on
end

title('[DENSE MESH] Tetrahedra found from corse mesh');

xlabel({'x'}); ylabel({'y'}); zlabel({'z'});
%view(3)
az = 0;    el = 30;    view(az, el);

hold off
end