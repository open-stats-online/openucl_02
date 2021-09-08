---
output:
  html_document: default
  pdf_document: default
---
<style>
.basic-styling td,
.basic-styling th {
  border: 1px solid #999;
  padding: 0.5rem;
}
</style>


# Trend Analysis: Mann Kendall
The trend component of Open UCL is still in development. This version works but we are not sure if we have worked out all the bugs. If you find any please let us know.  

We also want to expand on this help page. Trend analysis is a deep rabbit hole and there are many pitfalls and we would like to write about them here... when we have time. For now this seems to work and we have for the time being adopted the MAROS: Decision support system to make a determination of the observed trend.

## Data Format for Upload
The Mann Kendall Test is quite particular on the data format it needs and especially the date.

**Data file:**
Must be comma separated value (csv). You can try an excel file but we have had varying levels of success due mostly to the way excel stores dates. We recommend a csv file so you can actually see the final data format.

**The Expected Layout:**
First Row: Column headings MUST be as follows.

Col 1
date: must be entered as dd/mm/yyyy format


Col 2
id: is well or sample location identifier ed: MW1, MW2 etc

Col 3 and onward contain the results. Each analyte name in the header lines must be preceded by the word analyte followed by a space and then the name of the analytes. The app looks for the word "analyte" to determine what to plot.

Example file layout
<div class="ox-hugo-table basic-styling">
<div></div>
<div class="table-caption">Example File Layout
  <span class="table-number"></span>
</div>

</div>

|date        |   |id  |   |analyte benzene |   |analyte ethylbenzene |analyte toluene  |analyte xylene |analyte TRH(F1)  |
|:----------|:-:|:--|:-:|:---------------|:-:|:---------------------|:-----------------|:---------------|:-----------------|
|1/08/2011   |   |MW1 |   |1435            | |0                    |0                |0              |0                |
|1/02/2013   |   |MW1 |   |1234            | |3.7                  | 3.7             | 2             | 2.5             |
|1/09/2013   |   |MW1 |   |1456            | |0.13                 |0.13             |0.11           |0.01             |
|1/12/2013   |   |MW1 |   |1055            | |0.1                  |0.1              | 0.03          |0                |
|1/02/2014   |   |MW1 |   | 908            | | 3.2                 | 3.2              | 1.6          | 0.58            |
|1/03/2014   |   |MW1 |   | 1456           | |4.1                  | 4.1             | 1.9           | 1.5             |
|1/06/2014   |   |MW1 |   | 904            | | 2.2                 | 2.2             | 1.8           | 0.61            |

</div>

## Interpreting the Results.
The Mann Kendall Trend Test (sometimes called the M-K test) is used to analyze data collected over time for consistently increasing or decreasing trends (monotonic).

It is a non-parametric test, which means it works for all distributions (i.e. your data doesn’t have to meet the assumption of normality), but your data should have no serial correlation.

The test can be used to find trends for as few as four samples. However, with only a few data points, the test has a high probability of not finding a trend when one would be present if more points were provided. The more data points you have the more likely the test is going to find a true trend (as opposed to one found by chance). The minimum number of recommended measurements is probably somewhere between 8 and 10.

The Mann-Kendall Trend Test analyzes difference in signs of the difference between earlier and later data points but does not consider the magnitude of the differences. The idea is that if a trend is present, the sign values will tend to increase constantly, or decrease constantly. Every value is compared to every value preceding it in the time series, which gives a total of $\frac{n(n – 1)}{2}$ pairs of data, where “n” is the number of observations in the set.


**Assumptions  **

1. Your data isn’t collected seasonally (e.g. only during the summer and winter months), because the test won’t work if alternating upward and downward trends exist in the data. Another test—the Seasonal Kendall Test—is generally used for seasonally collected data.  We can consider implementing this if there is sufficient demand.
2. Your data does not have any covariates—other factors that could influence your data other than the ones you’re plotting.  
3. You have only one data point per time period. If you have multiple points, use the median value.  
4. Not required to be normal but must not be serially correlated.  

**Automated Trend Interpretation**

An interpretation of the results is provided using the MAROS: Decision support system for Optimising Monitoring Plans, J.J. Aziz, M. Ling,
H.S. Rifai, C.J. Newell and J.R. Gonzales. Groundwater , 41(3): 355-367, 2003. The structure of this interpretation is shown below.

_As always, you should use your own judgement based on graphical interpretation as well as the numerical assessment before relying on any trend interpretation._

Where S is the Mann-Kendall statistic, p is the p-value associated with S and CV is the coefficient of variation:

IF S >  0 and p <0.05 "INCREASING".

IF S <  0 and p <0.05 "DECREASING".

IF S >  0 and p <0.1 "POSSIBLY INCREASING".

IF S <  0 and p <0.1 "POSSIBLY DECREASING".

IF S >  0 AND p >0.1 "NO CLEAR TREND".

IF S <= 0 AND p >0.1 and CV >= 1 "NO CLEAR TREND".

IF p > 0.1 and CV < 1 "STABLE".

### The Statistical Summary

#### n - Number of samples
Displays the number of valid sample entries identified for an analyte in the data set. This number is critical to the determination of most of the other statistical parameters. It is **strongly recommended** to cross-check with your data set to make sure that the expected number of samples have been identified. If there is a mismatch, it may be worth checking for stray non-numerical characters in your data file. We allowed for the data to be viewed on the bottom left of the summary screen to help with this verification.

#### S - the Mann-kendall statistic

This Mann-Kendall analysis relies on determining the difference between each pair of distinct data points in the set and assigning a value of zero, +1 (where the later value is greater than the earlier value) or -1 (where the later value is less than the earlier value). The S value is the sum of these assigned values. Where this value is zero, there is no overall trend. Where the number is positive, there is an overall upwards trend (tendency to increase values over time). Where the number is negative, there is an overall downwards trend (tendency to decrease values over time).

$$ S = \sum_{k=1}^{n-1} \sum_{j=k+1}^{n} sgn (X_j - X_k )$$

where _sgn_ is equal to

$$ sgn(x) =  \left[\begin{array}{cc}
1, {\tt if } x > 0\\
0, {\tt if } x = 0\\
-1, {\tt if } x < 0
\end{array}\right] $$

#### varS - the variance of S

Defined as:
$$ \sigma^2 = \frac { n(n-1)(2n+5) - \sum_{j=1}^{p} t_j (t_j - 1)(2t_j +5) }{18}
$$
where
_p_ is the number of tied groups, and t<sub>j</sub> is the number of points in each group j.

#### tau
Kendall's tau is a measure of correlation between two columns of ranked data. Where C is the number of concordant pairs, and D is the number of discordant pairs, Tau ($\tau$) is calculated as:

$$ \tau = \frac{C-D}{C+D} $$

#### z - critical z value

#### p - the p-value
Expresses the statistical confidence of the identified trend. A smaller number indicates greater certainty.

#### Mean
Numerical average of the provided data set, commonly taken to be a representative value of the overall data set. The mean is prone to distortion due to the effects of small numbers of extreme values.

The mean will also change for any re-sampling events, so a mean value from one sampling event may not be accurately representative of the “real” mean concentration of an analyte at a target site. Accordingly, review of the data distribution and estimation of an appropriate upper confidence limit of the mean is often considered more reliable.

The mean ($\overline{x}$ ) for a data set of *n* values *x<sub>i</sub>* ... *x<sub>n</sub>* is calculated as:

$$\overline{x}= \frac{\sum_{x_{1}}^{x_{n}}}{n}$$

#### Standard Deviation
The standard deviation is calculated by determining the absolute difference between each data point and the mean, then finding the average of those differences. The standard deviation is a fundamental measure of variability in the data set.

The standard deviation ($s$)  for a data set of *n* values *x<sub>i</sub>* ... *x<sub>n</sub>* with a mean ($\overline{x}$ ) as described above, is calculated as:

$$  s = \sqrt{\frac{\sum_{x_{1}}^{x_{n}}{(x_{i} - \overline{x})}}{n -1}}$$

#### Coefficient of Variation
The coefficient of variation is a measure of the relative homogeneity of a distribution (CV = standard deviation / mean).  Low  CV values (≤ 0.5) indicating a fairly homogenous contaminant distribution, and high CV values (> 1) indicating heterogeneous distributions and probably skewed to the right.  Also known as the relative standard deviation (RSD) and expressed as %.

$$  CV = \frac{s}{\overline{x}}$$
