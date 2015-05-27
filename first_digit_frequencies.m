function frequencies = first_digit_frequencies(data)
% Returns the frequencies of first digits in numerical data and
% plots the result.
% INPUT:
%   data -          numerical data
% OUTPUT:
%   frequencies -   frequencies of first digits in data

datastr = arrayfun(@(x) num2str(x), data, 'UniformOutput', false);
[n, ~] = hist(cellfun(@(x) str2double(x(1)), datastr), 9);
frequencies = n ./ sum(n);
bar(1:9, n);

end

