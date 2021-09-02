---
output:
  html_document: default
  pdf_document: default
---
# Basic Stats and Upper Confidence Limits (UCLs)
**This text is DRAFT and is yet to be completed. Full references are yet to be provided and checked.**

## Select Your Preferred Analysis

Currently, OpenUCL has one type of analysis available, which presents a basic graphical and numerical summary of the data set(s) provided to it. To use this analysis, select the "Basic Stats and UCL" link from the menu on the left of the main page. If the menu is not apparent, click on the three horizontal bar "hamburger menu" icon at the top of the page, and the menu should appear.

In future, other types of statistical analyses will be incorporated and will be selectable from the same menu.

## Input your Data

To have OpenUCL perform statistical analysis on a set of data, the data must be uploaded through the web interface. Note that not data is retained and no identifying information is required.
Data is expected to be in a spreadsheet in Microsoft Excel format (.xls or .xlsx), comma separated value (csv) or open document spreadsheet (.ods).

To input and analyse your data, navigate to the *Basic Stats and UCL* page.

There are four input fields:

1. *Title* - this allows you to enter an identifier for your data set  
e.g. "Soil data for stockpile 1", or "Project XYZ: In-situ fill data"
2. *Data file* - this allows you to select the data file from your local device to be uploaded for analysis. The data file requirements are explained more below this list. The file will upload once selected.
3. *Non Detect* - Three methods to handle non-detect data (values less than the laboratory limit of reporting) are available. You can treat all non-detects as zero, as half the detection limit value, or as equal to the detection limit value.
4. *Sample Group* - This drop-down list displays the analytes identified from the top row of your input file. You can select each analyte to examine, and the analysis for that analyte's data will appear on the right of the page. Note that in the bottom left is a listing of the individual values in the data set. This can be used to examine unexpected values on the fly.

Once you have selected the options you are interested in, click on the "Apply and Calculate" button at the bottom of the input section of the page.

You can change the options and re-calculate at any time.

## Input File Format

Data is expected to be presented  in one column per analyte. There is no limit on the number of analytes.
The cells of your spreadsheet along the top row should list the name of the analyte represented by the data in that column. It is not necessary to have equal numbers of analyses for each analyte. Blank cells will be ignored.

If you have values which are below the laboratory limit of reporting, they should be included as a "less than" symbol and the number. OpenUCL will then recognise them and handle them as you have chosen in the non-detect analysis option.

Example:

| Arsenic          | Cadmium      | Chromium      | TRH F1 |
|:-----------------|:-------------|:--------------|:-------|
| 10               |5000          | 62             | 250   |
| <1               |              | 15             | 127  |
| 25               | 200          | 34             | 748   |
|<5                |53            |57              |84     |

## Keeping the Output for Inclusion in Reports

OpenUCL can generate a PDF report some or all of your analytes. The report is presented with one page per analyte, and each page is a replication of on-screen analysis with tabulated statistical data and graphical analysis.

To obtain a report for your data, go the *Generate Report* section beneath the graphs on your output.

Here you can choose from either the current analyte (for a report based on the current display) or all your analytes (all data).

Choose the option you want, and press *Click to Report*. A PDF file will be generated and returned to your browser. You can save and use this file as you wish.

The report includes a cover page listing the version of OpenUCL, date and time of processing, name of the data file and the title you entered on the input page to reference the purpose of the data set. The title page also includes the licencing information (open source licence) for the OpenUCL code base.



## Statistical Terms in the Output
### Descriptive Statistics
#### Number of samples
Displays the number of valid sample entries identified for an analyte in the data set. This number is critical to the determination of most of the other statistical parameters. It is **strongly recommended** to cross-check with your data set to make sure that the expected number of samples have been identified. If there is a mismatch, it may be worth checking for stray non-numerical characters in your data file. We allowed for the data to be viewed on the bottom left of the summary screen to help with this verification.

#### Min
The minimum value reported for each analyte.

#### Max
The maximum value reported for each analyte.

#### Range
The difference between the minimum and maximum values in the data set.

#### Mean
Numerical average of the provided data set, commonly taken to be a representative value of the overall data set. The mean is prone to distortion due to the effects of small numbers of extreme values.

The mean will also change for any re-sampling events, so a mean value from one sampling event may not be accurately representative of the “real” mean concentration of an analyte at a target site. Accordingly, review of the data distribution and estimation of an appropriate upper confidence limit of the mean is often considered more reliable.

The mean ($\overline{x}$ ) for a data set of *n* values *x<sub>i</sub>* ... *x<sub>n</sub>* is calculated as:

$$\overline{x}= \frac{\sum_{x_{1}}^{x_{n}}}{n}$$

#### Geometric Mean
The geometric mean is calculated as the *n*<sup>th</sup> root of *n* numbers, and presents a representative metric of the data set as an alternative to the arithmetic mean value based on the sum of the numbers, and will be equal to or less than the arithmetic mean when the data set includes only positive numbers. The geometric mean (*GM*)is calculated as:

$$GM = \sqrt[n]{x_{1}, x_{2}, \dots, x_{n}}     $$

#### Median
The median value (50th percentile) of reported values for each analyte. Half the values in the data set are higher and half lower than this value.

The median can be a better approximation of “typical” values than the mean as it is less prone to distortion by extreme values.

The median  for a data set of *n* values *x<sub>i</sub>* $\dots$ *x<sub>n</sub>* is calculated as:

$$ MEDIAN = \frac{x_{(n/2)}+x_{(n/2) + 1}}{2}$$

#### Standard Deviation
The standard deviation is calculated by determining the absolute difference between each data point and the mean, then finding the average of those differences. The standard deviation is a fundamental measure of variability in the data set.

The standard deviation ($s$)  for a data set of *n* values *x<sub>i</sub>* ... *x<sub>n</sub>* with a mean ($\overline{x}$ ) as described above, is calculated as:

$$  s = \sqrt{\frac{\sum_{x_{1}}^{x_{n}}{(x_{i} - \overline{x})}}{n -1}}$$

#### Standard Error of Mean (SEM)
The Standard Error of the Mean, sometimes referred to as just Standard Error, is calculated by dividing the standard deviation by the square root of the mean. This provides a measure of variability normalised to the size of the dataset and is useful for comparing variability between data sets of different sizes. It provides a measure of the dispersion of sample means around the population mean.

$$ SEM = \frac{s}{\sqrt{\overline{x}}}$$

#### Coefficient of Variation
The coefficient of variation is a measure of the relative homogeneity of a distribution (CV = standard deviation / mean).  Low  CV values (≤ 0.5) indicating a fairly homogenous contaminant distribution, and high CV values (> 1) indicating heterogeneous distributions and probably skewed to the right.  Also known as the relative standard deviation (RSD) and expressed as %.

$$  CV = \frac{s}{\overline{x}}$$


#### Skewness
Skewness is a  measure of the asymmetry of the data set. A normal data set is symmetrical with a zero skewness. Skewness indicates the direction and relative magnitude of a distribution's deviation from the normal distribution.

Where a  data set is skewed sufficiently, assumptions of normality in the data set are no longer valid and determination of other statistical parameters such as confidence intervals, must be conducted with appropriate methods which reflect the underlying data distribution. The basic single sided t-test method of calculating confidence intervals is not applicable to skewed data sets and may highly provide inaccurate results.

Examination of the histogram, Q-Q plots and data distribution statistics is recommended in conjunction with use of the skewness measure.

$$   \gamma1 =  \frac{\frac{1}{n}\sum_{i=1}^{n}(x_{i}-\overline{x})^3}{\left(\frac{1}{n}\sum_{i=1}^n(x_i-\overline{x})^2 \right)^{3/2}} $$

### Data Distribution Evaluation Statistics
The issue of evaluating if a data set is normal or not is a significant one as many statistical procedures rely very strongly on the assumption that the data is normally distributed.

There are no hard and fast rules on this and deciding on how your data is distributed is a bit of an art form, and the authors have included a number of them to guide you. Some things to note:

1. While tests and calculations are provided for log-transformed data, it should not be assumed that just because the tests of normality fail that the data set is log normal. It is true that it is probably the most common transformation used to force data to appear normal, but there are others, and in time Open UCL hope to provide tools to allow you to quickly apply alternate data transformations and review the revised plotted data outcomes.

2. We would argue that a review of the plots will give the user better insight on how their data is distributed and QQ plots, in particular, are very useful for this task. The sections below discuss each of the stats produced and provide some guidance on the interpretation of QQ plots.

#### Shapiro Wilk Test
P values for a Shapiro Wilk test are calculated for both **RAW** and **LOG** transformed data. P-values > 0.05 imply that the distribution of the data is not significantly different from a normal distribution at a 95% confidence level. In other words, you can assume normality. Where the log transformed data set has a Shapiro Wilk p-value > 0.05, the data can be assumed to fit a log-normal distribution.

You can use these values, in conjunction with examination of the QQ' and Log QQ' plots, to determine which UCL calculation method is applicable to the data set.

### Upper Confidence Limits
Three methods are used to calculate the 95% UCL (upper confidence limit of the arithmetic mean, at a 95% confidence level). These methods have been selected to be consistent with the upcoming NSW EPA guidance on sampling design (<a href="https://yoursay.epa.nsw.gov.au/sampling-design-guidelines">NSW EPA (2020) *Contaminated Land Guidelines, Sampling Design Part 1 - Application DRAFT FOR CONSULTATION*</a> and <a href="https://yoursay.epa.nsw.gov.au/sampling-design-guidelines">NSW EPA (2020) *Contaminated Land Guidelines, Sampling Design Part 2 - Interpretation DRAFT FOR CONSULTATION*</a>).

Both the *Students T-test* method on raw data and the *Lands H-UCL* method are calculated as a single-sided test as we are only interested in the Upper Confidence Interval.

The Chebychev UCL does not rely on knowing the data distribution.

This version of Open UCL reports the 95% UCL only.

Future versions of Open UCL will allow for varying of the confidence level for testing.

#### Student's t-test

This is the basic UCL method determined using a single sided t-test, applicable to data sets with a normal distribution.

$$ UCL_{t-test} = \overline{x} - t_{\frac{\alpha}{2},n - 1} \frac{s}{\sqrt{n}} $$

#### Land's H

This is a UCL calculation applicable to data sets with a lognormal distribution, and is based on descriptive statistics calculated from the log transformed data set.

The UCL is calculated using the formula below. $H_{1 - \alpha}$ is the *H-statistic*, determined based on the confidence level and ($s_{y}$). Note that $\overline{y}$ is the mean of the log transformed data set and $s_{y}$ is the standard deviation of the log transformed data.

$$ UCL_{Lands H} = exp \left(\overline{y} + \frac{s_{y}^2}{2} + \frac{s_{y}H_{1 - \alpha}}{\sqrt{n-1}} \right)$$

#### Zou UCL

Like Land's UCL, the Zou UCL (Zou 1979) is also provided and is applicable to data sets with a lognormal distribution. You will note that the UCL value they both provide are very similar particularly as the the value of n increases. We have provided it here as addition to the Land statistic as the R function that calculates the Land value falls over at n values greater than 264. Open UCL will not calculate Lands H for n > 200 and the Zou value should be used for Lognormal distributed data.

The following text is abridged from R documentation for the package EnvStats function *elnormALT*. Zou et al. (2009) proposed the following approximation for the two-sided (1-α)100% confidence intervals for θ.

The lower limit LL is given by:

$$ LL = \hat{θ}_{qmle} exp \left( - \left[\frac{z^2_{1-α/2}s^2}{n} + \left(\frac{s^2}{2} - \frac{(n-1)s^2}{2χ^2_{1-α/2, n-1}}\right)^2\right]^{1/2} \right) \;\;\;\; $$
and the upper limit UL is given by:

$$UL = \hat{θ}_{qmle} exp\left( \left[\frac{z^2_{1-α/2}s^2}{n} + \left(\frac{(n-1)s^2}{2χ^2_{α/2, n-1}} - \frac{s^2}{2}\right)^2\right]^{1/2}\right) \;\;\;\; $$

where $z_p$ denotes the p'th quantile of the standard normal distribuiton, and $χ_{p, ν}$ denotes the p'th quantile of the chi-square distribution with $ν$ degrees of freedom. The (1-α)100% one-sided lower confidence limit and one-sided upper confidence limit are given by equations (34) and (35), respectively, with $α/2$ replaced by $α$.


#### Chebychev

This is a UCL value determined without reliance on an underlying data distribution and can be used for data sets which are neither normal nor lognormal. For 95% confidence, $\alpha$ is set to 0.05, or 5%. Note that this method can substantially underestimate the UCL of the mean for highly skewed data sets. A modification of this method to allow for skewed data sets is also included and should be used for skewed data sets.

$$ UCL_{Chebychev} = \overline{x} - k_{(1 - \alpha)} \frac{s}{\sqrt{n}}$$

where
$$ k = \sqrt{\frac{1}{\alpha} - 1} $$

#### Chebychev for Skewed Datasets

*[details pending]*

### Other Results

#### Critical Value of T
The t value is provided as it is used for the calculation of MPE and MOE. Note that the T value provided assumed a two-sided test and is only used in the calculation of MOE and MPE

#### Critical Value of Z
insert description and how calculated

#### MOE
The Margin of Error (MOE) can be defined as the radius, or half the width, of a confidence interval for a particular statistic. It is calculated as the standard error of the mean multiplied by the critical value (i.e. t value):

$$ MOE  = \frac{s}{\sqrt{\overline{x}}} \times t_{(\frac{\alpha}{2}), n-1}$$

#### MPE%
The maximum probable error (MPE) can be used to specify the required statistical precision for data collection. The MPE is calculated by dividing the MOE by the mean ($\overline{x}$) of the data set.

$$ MPE\% = \frac{MOE \times 100}{\overline{x}}$$

#### RSD
The Relative Standard Deviation (RSD) is another term for the Coefficient of Variaiton (CV, described above), but is expressed here as a percentage for convenience.

# References

Gilbert, R.O. (1987). Statistical Methods for Environmental Pollution Monitoring. Van Nostrand Reinhold, New York, NY.

Land, C.E. (1972). An Evaluation of Approximate Confidence Interval Estimation Methods for Lognormal Means. Technometrics 14(1), 145–158.

Land, C.E. (1973). Standard Confidence Limits for Linear Functions of the Normal Mean and Variance.  Journal of the American Statistical Association 68(344), 960–963.

Shapiro, S. S.; Wilk, M. B. (1965). "An analysis of variance test for normality (complete samples)". Biometrika.

Zou, G.Y., C.Y. Huo, and J. Taleban. (2009). Simple Confidence Intervals for Lognormal Means and their Differences with Environmental Applications. Environmetrics 20, 172–180.
