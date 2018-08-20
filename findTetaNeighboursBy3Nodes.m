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
% Content: a goal of a function is to find a neighbour of a current_teta with common face 
%          descibed by 3 nodes (node1,node2,node3)
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% input:
% Teta - array of tetrahedra
% Teta_neigbours - an array of nieghbours
% node1, node2, node3 - nodes of a face
% current_teta - index of a current tetreahedon

%% output:
% idx - index of the selected neighbour

function [idx] = findTetaNeighboursBy3Nodes( Teta, Teta_neigbours, node1, node2, node3, current_teta, verbose )

    
    % No. of neighbours of current_teta:
    [N] = nnz(Teta_neigbours(current_teta,:));

    
    if (verbose==1)
        disp('List of neighbours:')
        for i=1:N
            str = sprintf('%d\t', Teta_neigbours(current_teta,i) ); disp(str);
        end
    end
    
    idx = current_teta;
    
    for i=1:N % loop over neighbours of current_teta
        
        tidx = Teta_neigbours(current_teta,i);
        
        %if (verbose==1)
        %    str = sprintf('Teta neighbour: %3d', tidx); disp(str);
        %end
        
        neighbour = Teta(tidx,:);
                 
        noOfNodes = 0;
        if (isempty(find(neighbour==node1))==false)
            noOfNodes = noOfNodes+1;
        end
        
        if (isempty(find(neighbour==node2))==false)
            noOfNodes = noOfNodes+1;  
        end

        if (isempty(find(neighbour==node3))==false)
            noOfNodes = noOfNodes+1;  
        end
                
        %str = sprintf('Teta: %3d/%3d [current=%d], noOfNodes = %d', tidx, N, current_teta, noOfNodes ); disp(str);
          
        %% neighbour contains the same 3 nodes as the face found by faceOrientationTest (face_orientation(i)>1)
        if (noOfNodes==3)
            idx = tidx;
            if (verbose==1)
                str = sprintf('Neighbour (%d) selected', idx); disp(str)        
            end
            break;  
        else
            if (verbose==1)
                str = sprintf('Neighbour (%d) rejected', tidx); disp(str)        
            end
        end
          
    end
    
end