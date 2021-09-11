%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 4 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function fh = splot(x,y,z,offset,numyticks,linespec)
% Function performs traditional stacked plot
%   x is x-axis vector that annotates x-axis, required.
%   y is y-axis vector that annotates y-axis, required.
%   z, 2D data array with x along columns and y along rows, required.
%   offset, 1 or 2 element vector specifying total offset along x & y directions.
%       Value represents fraction of axis range that is devoted for incrementing
%       along the axis, (default [0.1,0.8]). 
%       The default x and y increment is determined by dividing the total 
%       value by the number of plots. 
%   linespec, a string constant setting the line property, see Matlab help on "plot".
%       Default is 'b'.
%   numyticks, number of y ticks, (default = 4).
%   Copyright 2009-2020 Mirtech, Inc.
%   created 05/30/2009  MIH
%   Modified 05/23/2012 so that x and y do not have to be monotonically increasing
%       Only first two x values determine x increment.
def_yticks = 15;             % default number of y ticks
def_linespec = 'b';
def_offset = [0.1,0.8];
switch nargin
    case 6
    case 5
        linespec = [];
    case 4
        numyticks = [];     linespec = [];
    case 3
        offset = [];        numyticks = [];     linespec = [];      
end
if isempty(numyticks),  numyticks = def_yticks;     end
if isempty(linespec),   linespec = def_linespec;    end
if isempty(offset),     offset = def_offset;        end
if numel(offset)==1
    offset(2) = offset(1);
end
xpts = size(z,1);
if numel(x)~=xpts,  error('  X vector does not match 2D array!'),   end
ypts = size(z,2);
if numel(y)~=ypts,  error('  Y vector does not match 2D array!'),   end
zrange = max(z(:));
delta_y = offset(2)*zrange/(ypts-1);
incx = x(2)-x(1);               % calc increment from difference of adj. pts.
delta_x = floor(offset(1)*xpts/(ypts-1));   % calc x offset in pts.
xall = x(1) + ((1:(xpts+delta_x*(ypts-1)))-1)*incx;
yplt = zeros(size(xall));
yplt(fix(xpts/2)) = zrange*(1+offset(2));
fh2 = plot(xall,yplt,'w');       % setup length and height of plot with a white plot
set(gca,'YAxisLocation','right');
xlim([min(xall(1),xall(end)),max(xall(1),xall(end))]);
hold on
ylast = z(:,1)';
plot(x,ylast,linespec)          % plot first column
ytickvec = zeros(1,ypts);       % setup y ticks location holder
ytickvec(1) = ylast(end);       % save first y tick location
for n = 2:ypts
    yplt = z(:,n)' + delta_y*(n-1);             % add y offset to selected column
    ytickvec(n) = yplt(end);                    % save y tick location
    ylast(1:delta_x) = 0;                       % set offsetted points along x to zero
    ylast = circshift(ylast,[0,-delta_x]);      % move those points to end
    ylast = max(yplt,ylast);                    % create new ylast
    plot(x+delta_x*(n-1)*incx,ylast,linespec)   % plot ylast
end
hold off
xtickvec = get(gca,'XTick');
if x(1)<x(end)
    xtickvec(xtickvec>x(end)) = [];
else
    xtickvec(xtickvec<x(end)) = [];
end
set(gca,'XTick',xtickvec);      % setup x ticks for only the first plot
ytickspacing = floor(ypts/(numyticks-1));
yspacing = (y(2) - y(1));
yptvec = 1:ytickspacing:ypts;
if numel(yptvec) < numyticks
    yptvec = [yptvec,ypts];
else
    yptvec(end) = ypts; 
end
set(gca,'YTick',ytickvec(yptvec));      % setup y ticks
yvec = y(1) + (yptvec - 1)*yspacing;
sclfac = floor(max(log10(abs(yvec))));  % find the largest power of ten
if sclfac<0
    dec = floor(abs(sclfac));
    field = dec + 2;
else
    field = floor(abs(sclfac));
    dec = [];
end
% setup y tick labels
set(gca,'YTickLabel',cellstr(num2str(yvec',...
    ['%',num2str(field),'.',num2str(dec),'f'])));
if nargout==1
    fh = fh2;
end
end
% ------------- splot end --------------  

