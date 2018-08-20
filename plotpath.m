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
%          and present a path (through centers of tetrahedra) from starting
%          tetrahedron to a tetrahedron which contains a destination point
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% input:
% Teta  - array with tetrahedra of fine mesh
% Nodes - array with nodes of fine mesh
% Teta_coarse  - array with tetrahedra of a coarse
% Nodes_coarse - array with nodes of a coarse mesh
% history - a structure with information of a walk (visibility or stochastic)
% radious - radious of a sphere which  represents a destination point/s in figures
% figno - number of a figure

function [] = plotpath (Teta, Nodes, Teta_coarse, Nodes_coarse, history, destination_point, radious, figno)

    t=tic;
    %% Tetrahedra mesh with starting (green) and end (red) tetrahedra
    figure(figno)
    
    drawTetrahedron( Teta(history.onPath(1,1),:) , Nodes, [0 1 0], [0 1 0], 1.0, 0 ), hold on

    drawTetrahedron( Teta(history.onPath(1,end),:), Nodes, [1 0 0], [1 0 0], 1.0, 0 ), hold on 
    drawSphere( destination_point(1,1), destination_point(1,2), destination_point(1,3), radious, [0 1 0]); hold on

    %orginal mesh: 
    %tetramesh(Teta, Nodes,'FaceAlpha',0.001,'edgecolor',[ 0.5 0.5 0.5]); hold on
    
    %coarse mesh: 
    tetramesh(Teta_coarse, Nodes_coarse,'FaceAlpha',0.001,'edgecolor',[ 0.5 0.5 0.5]); hold on
    
    
    plotLinePath1(history, [0 0 1], 0)
    xlabel({'x'}); ylabel({'y'}); zlabel({'z'});
    set(gca,'fontsize',20)
    grid on
    %view(3)
    %az = 20;    el = 30;    view(az, el);
    %az = 0;    el = 30;    view(az, el);
    az = -75;    el = 30;    view(az, el);
    
    %title('Path through centers of tetrahedra visited during walk','fontsize',20);
    title('Tetrahedra mesh with: starting (green), visited (blue) and last (red) tetrahedra','fontsize',20);
    
    hold off
    timer = toc(t);
        
end