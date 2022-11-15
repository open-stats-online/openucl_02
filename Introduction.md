# Open UCL
**This is a Beta version of Open UCL, so some things may not work perfectly or may change without much notice as we make improvements**

## 1 Overview
Open UCL is a free online tool developed to provide a concise statistical summary of analytical data sets for contaminated land assessment and remediation projects. However, Open UCL may be used for any data set. Open UCL is an open-source project. The code is available on a <b><a href="https://github.com/open-stats-online/openucl_02/">Github repository</a></b>. You can use this repository to submit bug reports directly to us if you wish.

Open UCL is a Web-based application using R and Shiny to enable platform-independent access. It has the advantage of not requiring a particular operating system, hardware, or other software. All you need is internet access, a browser and a spreadsheet. Currently, recognised data formats for spreadsheets are Microsoft Excel (.xls or .xlsx), Open Document (.ods) and Comma Separated Value (.csv) files. The output is presented on the screen or downloaded in Portable Document Format (.pdf), so a PDF reader is also useful.

The website will timeout and disconnect if idle for a while. This feature is to reduce the overheads of running the website. Simply reload the page if this happens to continue.

If you are working on a project with contractual restrictions on data storage locations, you may want to avoid using Open UCL through the web interface as the data processing is conducted on international servers. **Note, however, that no data is stored once the web interface is closed.**

An alternative would be to download the R code and run it locally. Note there is nothing to stop you from anonymising your data to a set of numbers and generic labels.

Open UCL has been established as a free tool for industry professionals to use. If you like it, there will be an option to contribute to the running costs to pay for Web hosting, but this is not required.

Suggestions, comments and bug reports can be emailed to <b><a href="mailto:openstatsonline@gmail.com">openstatsonline@gmail.com</a></b>.

As noted, Open UCL is written in a language called R and Shiny, both of which are open source and free. There are numerous youtube videos on installing and using R and R studio, and it would not take long to learn the basics and enable you to run the Open UCL script locally.

### References for R and Shiny
R Core Team (2017). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/.

Winston Chang, Joe Cheng, JJ Allaire, Yihui Xie and Jonathan McPherson (2020). shiny: Web Application Framework for R. https://CRAN.R-project.org/package=shiny

## 2 What it does do
* Open UCL provides you with a concise graphical and numerical summary of your data to support your data sets' statistical interpretation.
* The numerical summary includes descriptive statistics estimates of normality and calculations of the 95%UCL for normal, lognormal and undefined data distributions.
* The summary is (intended to be) clear, focused, and limited to a handful of pages, regardless of the number of analytes provided.

## 3 What it does not do
* Open UCL does not keep your data, and any uploads are purged when the application closes.
* Open UCL does not track you or your location, but it does keep track of how often it is used. This helps with planning for hosting needs.
* Open UCL does not interpret your data for you. We have resisted the temptation to “spoon-feed” users to encourage users to learn about the stats they use and what they mean.
* Open UCL does not do Trend analysis. Although we have been playing with Mann Kendal Trend analysis functionality and it is likely to appear as a feature soon.

## 4 What makes it different from Pro UCL
<a href="https://www.epa.gov/land-research/proucl-software">Pro UCL</a> is a software package released by the USEPA which has a wide range of capabilities in the statistical analysis of environmental/contaminated sites data. Pro UCL is very popular and can determine UCL values for a wide range of statistical data distributions. Pro UCL includes a range of graphing and trend analysis tools as well.

However, Pro UCL requires the Windows operating system, and the output for each analyte can run to several pages, resulting in awkward data presentation and difficulty incorporating the results into reports. Graphical interpretation is separated from the statistical analysis by the structure of the software. The code is proprietary and is not easy to review or alter if so desired.

We aim to make a more straightforward tool that is readily accessible, provides a more concise output, and is focused on our industry's needs.

## 5 How to use it
There is a separate detailed instruction tab in each of the menu items on the left-hand panel. However, generally, the steps for use are as follows:

1. Prepare a data file. Analyte headings in the top row with columns of data below.
2. Input an optional title.
3. Browse for and upload your data file (browse or drag and drop). Accepted file types include Microsoft Excel (xls or xlsx), comma-separated value (csv) and open document spreadsheet (.ods).
4. Select how you want non detect values to be treated. Currently, there are only three options.

   * As a zero (some stats are not calculated with this option);
   * As a half value of the detection limit; or
   * As the detection limit.

5. Select your desired confidence level for UCL calculations. A default of 95% is automatically set, but you can choose a value from 50 to 99 using the slider bar.
6. Press *Apply and Calculate* to start the calculations, or to reprocess after changing the settings or uploading new data.

Open UCL will process the data and return results to the screen for review. It will read the first row of data and use the information in that row as a menu selector for each data column. The different analytes uploaded into Open UCL can be selected, and it will re-calculate the stats, and a revised statistical summary display is updated.

A report button allows for preparing a PDF document for the current display or all analytes in the data set and downloaded.

## Known Bugs

Currently, the functions used to derive the Lands H UCL calculation become unstable with data sets of over 200 data points, and you may not get a result in this situation. Unfortunately, these functions use code that is not under our control. A short term workaround has been implemented, which means that this calculation is not performed for data sets with over 200 data points, and we currently recommend the use of the Zou UCL, which tends to be virtually the same as Lands H UCL at high values of n (e.g.,>200).

Attempting to load an excel spreadsheet with multiple sheets may cause a crash.

Loading an ODS file with multiple sheets will result in only the first sheet being read.

Ultimately, OpenUCL will read all relevant data from all sheets of a spreadsheet, but this is yet to be implemented.

## Upcoming Improvements

**PDF Report:** The PDF report is functional but rudimentary. Anyone with a flair for R markdown is welcome to have shot at making this look a bit more upmarket.

## Authors
Open UCL was developed initially by Tim Chambers, Alex Mikov and Marc Salmon. However, we welcome contributions, comments, issues, notes on bugs, feature requests and help. If you are a whiz at R and want to have shot at developing or improving Open UCL, you can use Github to clone and branch the code and edit it and request that it be merged with the main files.

While we can't stop people from taking the current code and developing it on their own, we hope that this won't happen and that any developments made will be shared for all to benefit.
