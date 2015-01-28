function numbers = randbenford(length, max, min)

if nargin < 3
    min = 0;
end
if nargin < 2
    max = 1000;
end
if nargin < 1
    length = 100;
end

if min == 0
    numbers = floor(exp(log(max) * rand(1, length)));
else
end