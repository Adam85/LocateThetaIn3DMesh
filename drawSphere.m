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
% Content: a goal of the function is to draw a sphere which represents a point (x,y,z) with radious and colorx
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = drawSphere( x, y, z, radious, colorx)
    hold on
    CMap = parula(10);
    A = [x y z radious];
    [X, Y, Z] = sphere(10);
    for k = 1:1
      XX = X * A(k, 4) + A(k, 1);
      YY = Y * A(k, 4) + A(k, 2);
      ZZ = Z * A(k, 4) + A(k, 3);
      surface(XX, YY, ZZ, 'FaceAlpha', 1, 'FaceColor', colorx , ... %CMap(k, :), ...
              'EdgeColor', colorx);
    end
    hold on
    
end

