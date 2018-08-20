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
% Content: a goal of a function is to perform an orientation test for a single face of a tetrehedron
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input:
% t - list of 4 nodes descibing a tetrahedron 
% Q - Table required to map nodes of the tetrahedra such as all faces are counter clock-wise ordered
% Nodes - array with nodes of a mesh
% destination_point - a destination point 
% CW_CCW - flag {1,2} dependingly on the clock-wise or counter clock-wise orientation (here should be equals 2) 
% current_teta - index of a tetrahedron 
% face_no - the number of a face for which a orientation test is pefromed 
% verbose

%% output:
% face_orientation - result of a orientation test (sign of a determinant)
% face_value       - result of a orientation test (value of a determinant)

function [face_orientation,face_value] = singleFaceOrientationTest( t, Q, Nodes, destination_point, CW_CCW, current_teta, face_no, verbose)
   
        if (verbose==1)
            str = sprintf('Face Orientation Test (teta=%d)',current_teta);         
            disp(str)
        end


        i = face_no;
    
        face(1).nodeA = t(1,Q(i,1));
        face(1).nodeB = t(1,Q(i,2));
        face(1).nodeC = t(1,Q(i,3));
    
        if (verbose==1)
            str = sprintf('[%d/4] Face: %d -> %d -> %d', i, t(1,Q(i,1)), t(1,Q(i,2)), t(1,Q(i,3))); 
            disp(str)
        end
    
        if (CW_CCW==1)
            face_orientation(1) = orientation3D_CWo( ...
                                       [Nodes(face(1).nodeA,1),Nodes(face(1).nodeA,2),Nodes(face(1).nodeA,3)],...
                                       [Nodes(face(1).nodeB,1),Nodes(face(1).nodeB,2),Nodes(face(1).nodeB,3)],...
                                       [Nodes(face(1).nodeC,1),Nodes(face(1).nodeC,2),Nodes(face(1).nodeC,3)],...
                                        destination_point );
        elseif(CW_CCW==2)
            [face_orientation(1), face_value(1)] = orientation3D_CCWo( ...
                                       [Nodes(face(1).nodeA,1),Nodes(face(1).nodeA,2),Nodes(face(1).nodeA,3)],...
                                       [Nodes(face(1).nodeB,1),Nodes(face(1).nodeB,2),Nodes(face(1).nodeB,3)],...
                                       [Nodes(face(1).nodeC,1),Nodes(face(1).nodeC,2),Nodes(face(1).nodeC,3)],...
                                        destination_point );
    
        else
            str = sprintf('CW_CWW - undefined'); 
            disp(str);
            %break;
        end
            
        if (verbose==1)
            str = sprintf('Orientations of %d face of (teta=%d): [%d] \n', current_teta, face_orientation(1) ); disp(str)

            %sum_orientations = sum(face_orientation)
            %str = sprintf('sum_orientations: %d', sum_orientations); disp(str)
        end
    
end