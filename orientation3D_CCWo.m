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
% Content: a core of an orientation test
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input:
%% alfa, beta, gamma - three points of a face of a tetrahedron
%% delta - a destination point

%% output:
%out_sign  - result of a orientation test (sign of a determinant) 
%out_value - result of a orientation test (value of a determinant)

function [out_sign,out_value] = orientation3D_CCWo( alfa, beta, gamma, delta )

    alfax = alfa(1,1);
    alfay = alfa(1,2);
    alfaz = alfa(1,3);

    betax = beta(1,1);
    betay = beta(1,2);
    betaz = beta(1,3);

    gammax = gamma(1,1);
    gammay = gamma(1,2);
    gammaz = gamma(1,3);

    deltax = delta(1,1);
    deltay = delta(1,2);
    deltaz = delta(1,3);


    out_value = det( [betax - alfax, gammax - alfax, deltax - alfax;
                betay - alfay, gammay - alfay, deltay - alfay;
                betaz - alfaz, gammaz - alfaz, deltaz - alfaz]); 


    out_sign = sign(out_value);

end