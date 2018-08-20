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
% Content: a goal of this function is to check is a destination point (x,y,z) is 
%          inside a tetrahedron described with for nodes (xi,yi,zi) 
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input: 
% (x1,y1,z1), (x2,y2,z2), (x3,y3,z3), (x4,y4,z4) - four nodes of a tetrahedron
% (x,y,z) - coordinates that descibe a destination point
% tolerance - a tolerance used in not obvious cases in which a significantly small determinants are clasified as a zero (see bellow)
% verbose - a flag

%% output:
% in_out - {0} a tetrahedron does not contain a destination point, 
%          {1} a tetrahedron contains a destination point


function [in_out, D0,D1,D2,D3,D4] = checkPointInsideTetrahedron( x1, y1, z1,...
                                          x2, y2, z2,...
                                          x3, y3, z3,...
                                          x4, y4, z4,...
                                          x, y, z,...
                                          tolerance,...
                                          verbose)

%% Point under test: 
% P = (x, y, z).

%% Nodes of a tetrahedron:
% Node1 = (x1, y1, z1)
% Node2 = (x2, y2, z2)
% Node3 = (x3, y3, z3)
% Node4 = (x4, y4, z4)
% 
% P is in the tetrahedron if all the following determinants have the same sign.


D0 = det( [x1 y1 z1 1;
           x2 y2 z2 1;
           x3 y3 z3 1;
           x4 y4 z4 1 ]);
      
D1 = det([ x  y  z  1;
           x2 y2 z2 1;
           x3 y3 z3 1;
           x4 y4 z4 1]);

D2 = det([ x1 y1 z1 1;
           x  y  z  1;
           x3 y3 z3 1;
           x4 y4 z4 1]);

D3 = det([ x1 y1 z1 1;
           x2 y2 z2 1;
           x  y  z  1;
           x4 y4 z4 1]);

D4 = det([ x1 y1 z1 1;
           x2 y2 z2 1;
           x3 y3 z3 1;
           x  y  z  1]);

% if (verbose==1)
%     str = sprintf('[checkPointInsideTeta] %d,%d,%d,%d,%d', sign(D0) , sign(D1) , sign(D2) , sign(D3) , sign(D4)); 
%     disp(str);
% end

%[D0;D1;D2;D3;D4]

%% point is out:
in_out = -1;
D = [D0, D1, D2, D3, D4];

% if D(:) is close to 0 it means that a destination point lies in node or a face of a tetrahedron,
% below such situations are catched and a value of D(:) is set to 0 and
% test is based on a non-zero determinants 
idx = find( abs(D)<tolerance );
nidx = nnz(idx);

if ( isempty(idx) )
    sumd = sum(sign(D0)+sign(D1)+sign(D2)+sign(D3)+sign(D4));
    if sumd == -5 | sumd == 5
        %% point is in:
        in_out = 1;
    end
else
    Dn = D;
    
    Dn(idx) = [];
    N = size(Dn,2);
    sumdn = sum(sign(Dn));
    
    if (N==1 & (sumdn==-1 | sumdn==1))
        %% point is in:
        in_out = 1;
    elseif (N==2 & (sumdn==-2 | sumdn==2))
        %% point is in:
        in_out = 1;
    elseif (N==3 & (sumdn==-3 | sumdn==3))
        %% point is in:
        in_out = 1; 
    elseif (N==4 & (sumdn==-4 | sumdn==4))
        %% point is in:
        in_out = 1;
    else
        in_out = -100;
    end
end

end
