function distances = calcdist(data,center)
% !! code modified slight to work with column vector data
%  input: vector of data points, single center or multiple centers
% output: vector of distances

[dim,n] = size(data);
[n2,dim2] = size(center);

% Using repmat is slower than using ones(n,1)
%   delta = data - repmat(center,n,1);
%   delta = data - center(ones(n,1),:);
% The following is fastest: not duplicating the center at all

if n2 == 1
    distances = sum(data.^2, 1) - 2*center*data + center*center';
    distances = distances';
elseif n2 == n
    distances = sum( (data' - center).^2 ,2);
else
    error('bad number of centers');
end

% Euclidean 2-norm distance:
distances = sqrt(distances);

% Inf-norm distance:
% distances = max(abs(distances),[],2);
