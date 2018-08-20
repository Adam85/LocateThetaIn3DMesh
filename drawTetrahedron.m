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
% Content: a goal of a function is to draw a single tetrahedron
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Teta  - array with tetrahedra of mesh
% Nodes - array with nodes of  mesh
% edgeColor - a color of edges of tetrahedron, 
% faceColor - a color of faces of tetrahedron,
% transparency - value <0,1> which determines a transparency of a tetrahedron
% showNodes - a flag which determines if nodes of a tetrahedron are visible in figure

function [] = drawTetrahedron( Teta, Nodes, edgeColor, faceColor, transparency, showNodes )

    %Teta;
    for i = 1:4
           
        %% vertices:
        FV.vertices ( i,1) =  Nodes(Teta(i),1); %x
        FV.vertices ( i,2) =  Nodes(Teta(i),2); %y
        FV.vertices ( i,3) =  Nodes(Teta(i),3); %z

        if showNodes == 1
            text(FV.vertices ( i,1), FV.vertices ( i,2), FV.vertices ( i,3), ['   ' num2str(Teta(i))],'HorizontalAlignment','left','FontSize',8);
        end
         
        FV.faces = [ 1     2     3;
                     2     3     4;
                     3     4     1;
                     4     1     2];
        
    end
    
    FV.vertices;
    FV.faces;
            
    FV.facevertexcdata=FV.vertices;
       
    s = patch(FV,'EdgeColor',edgeColor,'FaceColor',faceColor,'LineWidth',1,'LineStyle','-','FaceAlpha', transparency);
    
    hold on

grid on

