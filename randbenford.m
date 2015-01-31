function numbers = randbenford(length, max, min, prob_method)

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

if min == 0
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
distribution = [0.3010 0.4771 0.6020 0.6980 0.7772 0.8441 0.9021 0.9533 1.0];
over_rand_threshold = find(rand(1) < distribution);
digit = over_rand_threshold(1);
end

function number = addnextdigit(number, stopper, max)
if stopper == 1
    return;
end
addnext = 1;
while addnext == 1
    digit = floor(10*rand(1));
    if number*10 + digit <= max
        number = number*10 + digit;
        addnext = 0;
    end
end
end

function stopper = shallstop(number, stopper, min, max, prob_stop)
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
probabilities = zeros(1, num_of_digits);
min_num_of_digits = floor(log10(min) + 1);
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