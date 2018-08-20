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
% Content: (Example-1, cubeandspheres) a goal of this function is to load a setup of a test
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% input: a mesh with 68k tetrahedra and destination points are first noToFind nodes of a very coarse mesh 

%% output:
% Nodes - array with nodes of fine mesh
% Teta  - array with tetrahedra of fine mesh
% Nodes_coarse - array with nodes of a coarse mesh
% Teta_coarse  - array with tetrahedra of a coarse
% DestinationPoints - list of destination points
% structurename - name of a structure (used in saving outputs and profiling)
% radious - radious of a sphere which  represents a destination point/s in figures

%% [!!!] Teta_coarse, Nodes_coarse are also used in figures since it is sometimes preferable to use a coarse mesh to present a walking path, destination point, tetrahedra in a coarser mesh.

function [Nodes, Teta, Nodes_coarse, Teta_coarse, DestinationPoints, structname, radious] = readExamples_cubandspheres_few(noToFind)
 
    %% read netgen mesh:
    [Nodes, Teta, Faces]                      = read_netgen_mesh_file('mesh\cubeandspheres_68k.mesh' );
    [Nodes_coarse, Teta_coarse, Faces_coarse] = read_netgen_mesh_file('mesh\cubeandspheres_98.mesh' );
    structname = 'cas68k'; 
    
    %% Destination Points:
    DestinationPoints = [];
    DestinationPoints = Nodes_coarse(1:noToFind,:);
    
    radious = 0.001;

end


