function hh = triplotfull(tri,varargin)

narginchk(1,inf);

start = 1;

if isa(tri, 'TriRep')
     if tri.size(1) == 0
        error(message('MATLAB:triplot:EmptyTri'));
     elseif tri.size(2) ~= 3
        error(message('MATLAB:triplot:NonTriangles'));
     end
    x = tri.X(:,1);
    y = tri.X(:,2);
    edges = tri.edges();
    if (nargin == 1) || (mod(nargin-1,2) == 0)
      c = 'blue';
    else
      c = varargin{1};
      start = 2;
    end
elseif isa(tri, 'triangulation')
     if tri.size(1) == 0
        error(message('MATLAB:triplot:EmptyTri'));
     elseif tri.size(2) ~= 3
        error(message('MATLAB:triplot:NonTriangles'));
     end
    x = tri.Points(:,1);
    y = tri.Points(:,2);
    edges = tri.edges();
    if (nargin == 1) || (mod(nargin-1,2) == 0)
      c = 'blue';
    else
      c = varargin{1};
      start = 2;
    end     
else
    x = varargin{1};
    y = varargin{2};
    warnState = warning('off','MATLAB:triangulation:PtsNotInTriWarnId');
    tr = triangulation(tri,x(:),y(:));
    warning(warnState);
    edges = tr.edges();
    if (nargin == 3) || (mod(nargin-3,2) == 0)
      c = 'blue';
      start = 3;
    else 
      c = varargin{3};
      start = 4;
    end
end

x = x(edges)';
y = y(edges)';
nedges = size(x,2);
x = [x; NaN(1,nedges)];
y = [y; NaN(1,nedges)];
x = x(:);
y = y(:);
h = fill(x,y,'r',varargin{start:end});
if nargout == 1, hh = h; end
