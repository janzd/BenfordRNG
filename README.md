## BenfordRNG

This function generates arrays of pseudo-random numbers which conform to Benford's Law.  
Benford's Law refers to the frequency of first digits in numerical datasets from natural real-life sources, such as populations of cities and heights of mountains. According to this law, 1 is the first digit in about 30% of the time and 9 is the first digit only in about 5% of the dataset values. The values from real-life datasets have to spread across multiple, preferrably at least 3 orders of magnitude to fit the distribution well.

The frequency of each digit d is proportional to the interval between d and d+1 on logarithmic scale.

You can read more about Benford's Law on [Wikipedia](http://en.wikipedia.org/wiki/Benford%27s_law).

#### Usage

The function takes several parameters. All of them are optional, but you probably want to specify at least the number of values you want to generate.

`length`
> The length of the array to be generated. 

`min`
> The minimum possible value to be generated. The value cannot be negative.

`max`
> The maximum possible value to be generated.

`prob_method`
> The method to be used for distribution of generated values over the whole range defined by min and max values.
> > 0 -- Probability of each order of magnitude is the same.  
> >          Ex.: 
> > > min = 10, max = 50000  
      p(10 <= x <= 99) = p(100 <= x <= 999) = p(1000 <= x <= 50000) = 1/3
      
> >  1 --    Probability of each value in the range is the same.  
> >  Ex.: 
> > > min = 100, max = 50000  
      p(10) = p(11) = .. = p(50000) = 1/49901
                                
`artificial`
> The method to be used for number generation if min = 0. If min > 0, the method is always artificial.
> > 0 --    Natural method, randomly generated numbers in the range from 0 to 1 are used to create log-uniform distribution.
> > 1 --    Artificial method, randomly generated numbers are used to select one of the bins whose sizes match the percentages of occurrences according to Benford's Law.

#### Notes

If you generate only a small array of numbers, for example an array of 50 numbers, it won't fit the distribution very much. The more values you generate, the more the distribution matches the occurrence frequencies described by Benford's Law.
