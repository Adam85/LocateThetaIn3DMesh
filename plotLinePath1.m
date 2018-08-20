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
% Content: a goal of a function is to plot a line between centers of tetrahedra
% Author: Adam Dziekonski
% Generated August 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = plotLinePath1(history, colorx, texton)
    h_len = size(history.onPath,2);
    for h=1:h_len-1
        p1 = [history.centers(h  ,1), history.centers(h  ,2), history.centers(h  ,3) ];
        p2 = [history.centers(h+1,1), history.centers(h+1,2), history.centers(h+1,3) ];
        dp = p2-p1;
        hold on
        quiver3(p1(1),p1(2),p1(3),dp(1),dp(2),dp(3),0,'color',colorx,'LineWidth',2);

        if(texton==1)
            text( p2 (1,1), p2(1,2), p2(1,3) , ['   ' num2str(h)],'HorizontalAlignment','left','FontSize',8,'color',colorx);
        end

        hold on
    end
    hold off

end