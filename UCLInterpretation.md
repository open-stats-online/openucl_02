---
output:
  html_document: default
  pdf_document: default
---
# Guidance on Interpretation of Open UCL Results

This page aims to provide some guidance on the interpretation of results presented in the Open UCL output. This is not intended to be a detailed on-size-fits-all set of instructions for interpreting the data, but is intended to illustrate some concepts for which questions have been raised by users and may not be widely understood.

## Which UCL value should I use?
Unlike some other software packages, Open UCL does not provide a definitive specification for which of the several UCL values calculated is the one which applies to the data set.

There are a wide range of formulae for calculating confidence limits, including Upper Confidence Limits, or UCLs, which are a focus here. Most versions rely on knowing the statistical distribution of the underlying data, and using that knowledge to select and calculate an appropriate confidence interval. We have limited the UCL calculations to three data distributions, which is consistent with the approach in the current draft NSW EPA sampling design guideline:

1. Normal data distribution (Students t-test),
2. Lognormal data distribution (Lands H, and for large data sets, Zou), and
3. Neither Normal nor Lognormal distribution (Chebychev, which does not assume any underlying data distribution).

A statistical comparison of the data distribution to a normal distribution is made by Open UCL using the Shapiro-Wilks method. This gives two values, a Shapiro-Wilks Value, and a Shapiro-Wilks p-value. Where the p-value is greater than 0.05, the data is said to meet a normal distribution with 95% confidence. These values are listed for the data set in the output as the *Shapiro-Wilks Value (raw)* and *Shapiro-Wilks p (raw)* respectively.

In order to determine whether or not a data set has a lognormal distribution, Open UCL log transforms the data and runs the Shapiro-Wilks test on the transformed data. In this case, if the Shapiro-Wilks p-value is greater than 0.05, the data is said to be a lognormal distribution with greater than 95% confidence. The Shapiro-Wilks calculation values are listed for the data set in the output as the *Shapiro-Wilks Value (log)* and *Shapiro-Wilks p (log)* respectively.

To save having to remember this, there are two outputs listed by Open UCL; *Normality Raw Data* and *Normality Log Data*. These items are shown as *TRUE* if the relevant p-value exceeds 0.05, and *FALSE* otherwise.

However, it is strongly recommended not to rely on the numerical interpretation of data distribution alone, as some data sets may give unexpected results. You should always examine the QQ plots and the Histogram to confirm the statistical interpretation. The reading of QQ plots is discussed below.

To select an appropriate UCL value for the data set, examine the *Normality Raw Data* and *Normality Log Data* values in conjunction with examining the QQ plots and apply the following logic:

1. If your data is neither *normal* nor *lognormal* (i.e. neither value is *TRUE*), then it may best to use the Chebychev UCL.
2. If your data is statistically *normal* (i.e. *Normality Raw Data* is *TRUE*), use the Students t-test UCL.
3. If your data is statistically *lognormal* (i.e. *Normality Log Data* is *TRUE*), use the Lands H, or Zhou, UCL.

For some statistically small data sets, they will meet both the *normal* and *lognormal* distributions with 95% confidence. This is possibly an artefact of applying the formulae to small data sets, and it is not really possible to distinguish between them with confidence. In this case we consider the data distribution to not be clearly defined and recommend using the Chebychev UCL or collecting more data.

## Introduction to Reading a QQ Plot

The *Q* in QQ plot stands for *quartile*, and the plot is a graph of the calculated theoretical quartiles (in this case for a normal distribution) against the actual quartile values. For an ideal *normal* (or *normally distributed*) data set, this will result in the data plotting on a straight line. For a real world data set, the fit is never perfect, but the data will plot reasonably close to a straight line.

The further the data deviates from the ideal line, the worse the fit to that distribution. On the QQ plots provided in the Open UCL output, a theoretical straight line is provided for reference, and a shaded area representing a 95% confidence of fit is also displayed. Generally you would like to see most of the data points fit into the shaded area

It is common for data points at the extreme ends to lie some distance from the line, and this does not necessarily invalidate an otherwise good fit.

The Open UCL output includes a QQ plot for the raw data, and one for the log transformed data. This corresponds directly to the two versions of the Shapiro-Wilks assessment provided in the tabulated data.

We strongly recommend cross checking the QQ plot results against the Shapiro-Wilks numerical indicators of distribution before relying on a particular interpretation.

## Introduction to the Open UCL Box and Whisker Plot

The box and whisker plot provided in the Open UCL output includes the following features:

* A shaded box between the 25th and 75th percentiles (50% of the data values lie within this zone).
* A diamond shape marks the mean concentration.
* A horizontal line marks the median (50th percentile). Half the data lie above, and half below this value.
* An upper whisker (or hinge) and a lower whisker (vertical line terminating in a horizontal line). This line extends to 1.5 times the interquartile range (the 75th percentile minus the 25th percentile) beyond the upper or lower bound of the shaded box.
* Any values above or below the extent of the whiskers are plotted as an asterix. These are the statistically extreme values in the data set. We loath to call them outliers as such data points are often the most interesting values in a data set.

## Histogram

Histograms give a good indication of the spread of data within grouped "bins", or data ranges. Most people are familiar with using data presented as a histogram and we have not provided much detail here for that reason.

