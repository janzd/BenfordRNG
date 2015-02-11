function numbers = randbenford(length, max, min, prob_method, artificial)
% Generates an array of numbers which conforms to Benford's Law,
% which refers to the distribution of first digits in natural real-life
% datasets.
% INPUT:        
%   length:         The length of the array to be generated.
%   min:            The minimum possible value to be generated. The value
%                   cannot be negative.
%   max:            The maximum possible value to be generated.
%   prob_method:    The method to be used for distribution of
%                   generated values over the whole range defined by min
%                   and max values.
%                   0 --    Probability of each order of magnitude is the same.
%                           Ex.: min = 10, max = 50000
%                                p(10 <= x <= 99) = p(100 <= x <= 999) =
%                                p(1000 <= x <= 50000) = 1/3
%                   1 --    Probability of each value in the range is the
%                           same.
%                           Ex.: min = 100, max = 50000
%                                p(10) = p(11) = .. = p(50000) = 1/49901
%   artificial:     The method to be used for number generation if min = 0.
%                   If min > 0, the method is always artificial.
%                   0 --    Natural method, randomly generated numbers in
%                           the range from 0 to 1 are used to create
%                           log-uniform distribution.
%                   1 --    Artificial method, randomly generated numbers
%                           are used to select one of the bins whose sizes
%                           match the percentages of occurrences according
%                           to Benford's Law.
%
% OUTPUT:
%   numbers:        Array of generated numbers.

if nargin < 5
    if min == 0
        artificial = 0;
    else
        artificial = 1;
    end
end
if nargin < 4
    prob_method = 0;
end
if nargin < 3
    min = 0;
end
if nargin < 2
    max = 1000;
end
if nargin < 1
    length = 100;
end

if artificial == 0 && min > 0
    disp('Minimum possible value is higher than 0. Using the artificial method instead.');
    artificial = 1;
end

if prob_method > 1
    disp('Wrong probability method selection. Use help command to see supported methods.');
    disp('Using method #0');
    prob_method = 0;
end

if artificial == 0
    % Generates the numbers in a natural way.
    numbers = floor(exp(log(max) * rand(1, length)));
else
    stoppers = zeros(1, length);
    prob_stops = getprobs(floor(log10(max) + 1), min, max, prob_method);
    i = 1;
    numbers = arrayfun(@(x) setfirstdigit(), stoppers);
    while prod(stoppers) == 0
        stoppers = arrayfun(@(n, s) shallstop(n, s, min, max, prob_stops(i)), numbers, stoppers);
        numbers = arrayfun(@(s, n) addnextdigit(n, s, max), stoppers, numbers);
        i = i+1;
    end
end
end

function digit = setfirstdigit()
% Creates the first digit of a number with the probabilities defined by
% Benford's Law.
distribution = [0.3010 0.4771 0.6020 0.6980 0.7772 0.8441 0.9021 0.9533 1.0];
over_rand_threshold = find(rand(1) < distribution);
digit = over_rand_threshold(1);
end

function number = addnextdigit(number, stopper, max)
% Adds another digit to the number unless the generation of the number has
% been terminated.
if stopper == 1
    return;
end
addnext = 1;
while addnext == 1
    digit = floor(10*rand(1));
    if number*10 + digit <= max % Makes sure that the new number doesn't exceed max value
        number = number*10 + digit;
        addnext = 0;
    end
end
end

function stopper = shallstop(number, stopper, min, max, prob_stop)
% Determines whether the generation of the number will be stopped or not.
% The number must exceed min value and must not exceed max value, and its
% generation can be terminated with a certain probability.
if stopper == 1
    return;
end
if number < min
    stopper = 0;
elseif number * 10 >= max
    stopper = 1;
else
    if rand(1) < prob_stop
        stopper = 1;
    else
        stopper = 0;
    end
end
end

function probabilities = getprobs(num_of_digits, min, max, prob_method)
% Creates an array of probabilities of termination of generation process
% for each order of magnitude.
probabilities = zeros(1, num_of_digits);
if min == 0
    min_num_of_digits = 1;
else
    min_num_of_digits = floor(log10(min) + 1);
end
for i = min_num_of_digits:num_of_digits
    if prob_method == 0
        probabilities(i) =  (1 / (num_of_digits - min_num_of_digits + 1));
    elseif prob_method == 1
        if i == min_num_of_digits
            probabilities(i) = (10^(i) - min) / (max - min + 1);
        elseif i == num_of_digits
            probabilities(i) = ((9 * 10^(i-1)) - (10^i - max)) / (max - min + 1);
        else
            probabilities(i) =  (9 * 10^(i-1)) / (max - min + 1);
        end
    else
    end
end
end