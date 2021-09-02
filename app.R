# OPEN UCL BETA
# File and Version: Open_UCL_shinyapp_Ver_504.R File
# Last Update:2 Sept 2021
# Open Source R code and Shiny App for calculation of basic stats and 95% UCL's
# for the contaminated land matters.
# Initial Development by Tim Chambers, Alex Mikov, Marc Salmon. (Society of OWLS)
# Feel free to use the code but please give credit and do not monetise.


# LIBRARIES #########################################
#Load all the necessary libraries
library(shinydashboard)
library(shiny)
library(dashboardthemes)
library(readxl)
library(readODS)
library(tidyverse)
library(DT)
library(PerformanceAnalytics)
library(broom)
library(EnvStats)
library(readr)
library(pander)
library(qqplotr)
library(gridExtra)
library(grid)
library(shinycssloaders)
library(knitr)
library(pander)
library(trend)
library(lubridate)
#library(kableExtra)

# FUNCTIONS #########################################
##Define functions

# Geometric mean
gm_mean = function(a){prod(a)^(1/length(a))} # function for geometric mean. Now redundant as EnvStats also does this

# Lands H-UCL number
Land_HUCL <- function(value, conf) {
  if (length(value) < 2 || n_distinct(value) < 2 || any(value <= 0) || length(value) > 200)  return(NA)
  elnormAlt(value, method = "mvue", ci = TRUE, ci.type = "upper", ci.method = "land",
            conf.level = conf, parkin.list = "normal.approx")$interval$limits['UCL']
}

# Zou UCL number
Zou_UCL <- function(value, conf) {
  if (length(value) < 2 || n_distinct(value) < 2 || any(value <= 0))  return(NA)
  elnormAlt(value, method = "mvue", ci = TRUE, ci.type = "upper", ci.method = "zou",
            conf.level = conf, parkin.list = "normal.approx")$interval$limits['UCL']
}


# USER INTERFACE STRUCTURE #########################

# The interface is generally made up of two zones. A sidebar panel and a dashboard body
# The side panel or sidebar panel always appears the same no matter where you are in the
# dashboard.

# The dashboard body of main tabs appear as menu items on the left of the display
# in the sidebar panel.

# Each one of these is referred to as a tabItems in the dashboard body. Each tabItem also has
# or can have a number of sub tabs (listed across the top of the page) these are called tabPanels

# SIDEBAR PANEL. Includes menu options and license information #####

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName = "Introduction", icon = icon("info")),
    menuItem("Basic Stats and UCL.", icon = icon("code"), tabName = "basicstats"),
    menuItem("Trend Analysis", icon = icon("chart-line"), tabName = "trenda"),
    menuItem("Sample Size Calcs", icon = icon("calculator"), tabName = "sampleSize"),
    menuItem("GOF Tests", icon = icon("umbrella"), tabName = "GOFtests"),
    
    # Other fonts at https://fontawesome.com/icons?d=gallery&q=beta
    # Any chance of putting the HTML code into a seperate file?
    HTML('<p style="font-size:11px; margin-left:15px;">
         <br>
         <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />
         <br>
         You are free to use the output of OpenUCL<br>
         for your own purposes, private or<br>
         commercial, without constraint.<br>
         <br>
         The underlying code is publically available<br>
         and this work is considered by the Authors <br>
         to be Open Source [LINK].<br>
         The underlying code is, however, licensed<br>
         under a Creative Commons<br>
         Attribution-NonCommercial-<br>
         ShareAlike 4.0 International License.</a><br>
         <br>
         Under the license terms you are free to:<br>
         <br>
         <b>Share</b> — copy and redistribute the material<br>
         in any medium or format<br>
         <br>
         <b>Adapt</b> — remix, transform, and build upon<br>
         the material<br>
         <br>
         <b>Attribution</b> — You must give appropriate<br>
         credit, provide a link to the license,<br>
         and indicate if changes were made. You<br>
         may do so in any reasonable manner, but<br>
         not in any way that suggests the<br>
         licensor endorses you or your use.<br>
         <br>
         <b>NonCommercial</b> — You may not use the<br>
         material for commercial purposes.<br>
         <br>
         <b>ShareAlike</b> — If you remix, transform, or<br>
         build upon the material, you must distribute<br>
         your contributions under the same license<br>
         as the original.<br>
         <br>
         <b>Feedback? Want to Help?</b><br>
         Contributions, feedback, ideas for additions<br>
         are welcomed. Please feel free to email us<br>
         at <b><a href="mailto:openstatsonline@gmail.com" style="font-size:11px">openstatsonline@gmail.com</a></b>.<br>
         <br>
         <b>Fund Us</b><br>
         We donated our time for free to develop<br>
         Open UCL but the IT bits we use cost $$.<br>
         If you wish to contribute financially<br>
         we will soon have a donorbox page<br>
         or something similar. <br>
         <br>
         Any funds raised will be used to pay for<br>
         server costs and upgrades to Open UCL.<br>
         <br>
         In return, we will list all contributors<br>
         to Open UCL on the Open UCL app page.<br>
         <br>
         <b>Developers & Contributors</b><br>
         T. Chambers, A.Mikov, M. Salmon<br>
         A. Bull
         </p>')
)) # End of sidebar panel



# USER INTERFACE: DASHBOARD BODY ###################################
## Layout for the main body of the site. Consists of the tab items in the left panel and subpanels called tabpanels

body <- dashboardBody(
  # Header information for favicon (currently works on local implementaiton but not via the website)
  tags$head(tags$link(rel = "shortcut icon", href = "favicon.ico")),

  #apply theme
  shinyDashboardThemes(
    theme = "poor_mans_flatly"
  ),

  tabItems( # Menu items in the left panel

    # Basic Statistics (OpenUCL)
    tabItem(
      
      tabName = 'basicstats',
      fluidRow(
        tabBox(
          width = 12,
          id = "tabset1",

          # Basic Stats Tabpanel 1 for OpenUCL: FILE INPUT, OPTIONS SELECTION AND OUTPUT DISPLAY
          tabPanel("Basic Stats and UCL", {
            # Input section
            sidebarLayout(
              sidebarPanel(
                textInput(
                  'title',
                  HTML('<font size = "3"><b>Enter a title in box below:</b></font>'),
                  value = 'eg: Natural Soil Data'
                ),
                HTML('<font size = "3"><b>Data Upload : </b></font>'),

                HTML('<br>Data file must be excel (xls or xlsx), comma separated value (csv) or open document spreadsheet (.ods).
                  <br>Less than symbols are ok. ND is not.<br>The expected layout is:<p>
                  <i>First Row:</i> Column headings/labels. eg: As, Hg, PAH <br>
                  <i>Subsequent Rows:</i> Values. eg: 2.05, 1.10, <0.5 </p>'),

                fileInput("file1", "", accept = c(".xlsx", ".xls", ".csv", ".ods")) , # Input the data file

                HTML('<font size = "3"><b>Non Detect : </b></font>'),
                br(),
                HTML('How do you want to treat non-detect results (choose one only)'),
                radioButtons(
                  "btn1", # could improve variable name for legibility e.g. "nondetect"
                  "",
                  c(
                    "Assume zero" = "zero",
                    "Half of Detection Limit" = "half",
                    "Detection Limit Value" = "same"
                  ),
                  selected = 'same'
                ),
                br(),

                # Slider for confidence interval
                HTML('<font size = "3"><b>Confidence Level : </b></font>'),
                br(),
                HTML('Select the desired level of confidence for UCL calculations. This does not affect the displayed values for the critical value of t, MOE or Z value calculations. These remain at alpha=0.05'),
                sliderInput("confidence", "",
                            min = 50, max = 99,
                            value = 95),
                br(),
                HTML('<font size = "3"><b>Select Sample Group : </b></font>'),
                uiOutput('dropdown1'), # dropdown to pick analyte - could improve variable name

                actionButton("go", "Apply & Calculate"),
                br(),
                br(),
                HTML('<font size = "3"><b>Data Review Panel: </b></font>'),
                withSpinner(dataTableOutput("contents")) # output the data table
              ),

              ## OUTPUT SECTION for OpenUCL Tab 1
              mainPanel(
                #HTML('<font size = 6><b><center style = "text-indent: -300px;">Statistical Analysis Result</center></b></font>'),

                span(textOutput('title'),style = 'font-weight:bold;font-size:20px;text-align: left'),
                div(textOutput('value'),style = 'color:red;font-weight:bold;font-size:20px;text-align: left'),
                fluidRow(
                  column(6, htmlOutput('column1')), # Stats tables
                  column(6, htmlOutput('column2'))
                ),
                br(),
                withSpinner(plotOutput('qq_plot')),
                uiOutput('btn2'),
                uiOutput('click1')
              ) # end Tab 1 main panel
            )# end Tab 1 sidebar layout
          } # end body of tab panel for basic stats
        ), # end Tabpanel 1 tab panel for basic stats

        ## Basic Stats Tabpanel 2 for OpenUCL: HELP AND INSTRUCTIONS
        tabPanel(
          "Instructions and Help", {
            withMathJax(includeMarkdown("Basic_Stats_IH.md"))
          }
        ), # end Tabpanel 2  for Instructions and help

        ## Basic Stats Tabpanel 3
        tabPanel(
          "Which UCL to Use?", {
            withMathJax(includeMarkdown("UCLInterpretation.md"))
          }
        ) #end Tabpanel 3 for Which UCL to Use?
      ) # end tab box
    )# end of fluid row
  ), # end of tab item basic stats

  # Introduction
  tabItem(
    tabName = 'Introduction',
    tabPanel(
      "Instructions and Help", {
        includeMarkdown("Introduction.md")
        }
      )
    ),# End tab item - introduction

    # Sample Size Calculations (to be implemented) has two tabpanels as place holders
    tabItem(
      tabName = 'sampleSize',
      fluidRow(
        tabBox(
          width = 12,
          id = "tabset2",
          tabPanel("Sample Size Calcs", {"Feature to be added"}),
          tabPanel("Instructions and Help", {"No instructions on sample size calcuations yet"})
        ) # end tab box
      )# end fluidRow
    ), # end tab item - sample size calcs

    # Goodness of fit tests (to be implemented) has two tabpanels as place holders
    tabItem(
      tabName = 'GOFtests',
      fluidRow(
        tabBox(
          width = 12,
          id = "tabset3",
          tabPanel("GOF Tests", {"Feature to be added"}),
          tabPanel("Instructions and Help", {"No instructions on Goodness of Fit tests yet"})
        ) # end tab box
      )# end fluid Row
    ),# end tab item - GOF

  # Trend Analysis
    tabItem(
      tabName = 'trenda',
      fluidRow(
        tabBox(
          width = 12,
          id = "tabset4",
          tabPanel("Trend Analysis", {

            sidebarLayout(
              sidebarPanel(
                textInput(
                  'title_trend',
                  HTML('<font size = "3"><b>Enter a title in box below:</b></font>'),
                  value = 'Groundwater Trend Data'
                ),

                HTML('<font size = "3"><b>Data Upload : </b></font>'),

                HTML('<br>Data file must be comma separated value (csv).
                  Less than symbols are ok ND is not.<br>
                  <br>
                  The expected layout:<p>
                  Refer to Instructions and Help tab for details on the data format
                  needed for trend analyses. Only CSV files will work.
                  </p>'),

                fileInput("file1_trend", "", accept = c(".xlsx", ".xls", ".csv", ".ods")) ,

                HTML('<font size = "3"><b>Non Detect : </b></font>'),
                br(),
                radioButtons(
                  "btn1_trend",
                  "",
                  c(
                    "Assume zero" = "zero",
                    "Half of Detection Limit" = "half",
                    "Detection Limit Value" = "same"
                  ),
                  selected = 'same'
                ),
                br(),

              actionButton("go_trend", "Apply & Calculate"),
              br(),
              br(),
              uiOutput('id_trend'),
              uiOutput('analyte_trend'),
              br(),
              br(),
              HTML('<font size = "3"><b>Data Review Panel: </b></font>'),
              withSpinner(dataTableOutput("contents_trend"))

              ), #end sidebarPanel


              mainPanel(
                #HTML('<font size = 6><b><center style = "text-indent: -300px;">Statistical Analysis Result</center></b></font>'),
                span(textOutput('title_trend'),style = 'font-weight:bold;font-size:20px;text-align: left'),
                div(textOutput('value1_trend'),style = 'color:red;font-weight:bold;font-size:20px;text-align: left'),
                div(textOutput('value2_trend'),style = 'color:red;font-weight:bold;font-size:20px;text-align: left'),
                fluidRow(
                  column(6, htmlOutput('column1_trend')), # Stats tables
                  column(6, htmlOutput('column2_trend'))
                ),

                br(),

                withSpinner(plotOutput('plot_trend')),
                br(),
                br(),
                uiOutput('btn2_trend'),
                uiOutput('click1_trend')
              ) #end mainPanel
            ) #end sidebarLayout
          }),
          tabPanel("Instructions and Help", {
            withMathJax(includeMarkdown("Trend_IH.md"))
            })
        ) # end tab box
      )# end fluid Row
    )# end tab item - trend analysis
  ), # end tab items. End of all main tab items
) # End of dashboard body

# SHINY UI AND SERVER ###############################
# This is the UI Component. Not a lot of detail here as most if the UI is handled by
# the dashboard layout detailed above. i.e dashboardPage

shinyApp(
  ui = dashboardPage( # Call to the dashboard/UI section
    title="OpenUCL",
    dashboardHeader(
      title = HTML("<img src='OpenUCL.png' height='50px' align='left'> Ver 5.03")  #include logo in header
    ),
    sidebar,
    body
  ),
  server = function(input, output) { # call to the server section - processing code

    # Keep an eye on the input fields and update if they change. Set to null at the beginning
    values <- reactiveValues(df_data = NULL, df_data_trend = NULL)

    #######TREND ANAlYSIS TAB##########

    # Read in the uploaded data file from trend analysis tab
    observeEvent(input$file1_trend, {
      # Determine File Type and return emptyhanded if not valid for our purposes
      FileType <- tolower(tools::file_ext(input$file1_trend$datapath))
      if(FileType!="ods"&&FileType!="csv"&&FileType!="xls"&&FileType!="xlsx"){
        showNotification("Please upload a data file in xls, xlsx, csv or ods format.", duration = 10, type = "message")
        return()
      }

      #Read in the data using the appropriate tool
      ifelse(
        FileType == "ods",
        values$org_data_trend <- read_ods(input$file1_trend$datapath),
        ifelse(
          FileType == "csv",
          values$org_data_trend <- read_csv(input$file1_trend$datapath),
          ifelse(
            FileType == "xls" || FileType == "xlsx",
            values$org_data_trend <- read_excel(input$file1_trend$datapath),
            showNotification("Please upload a data file in xls, xlsx, csv or ods format.", duration = 10, type = "message")
          )
        )
      )
    })


    output$title_trend <- renderText({
      req(values$filtered_data_trend)
      input$title_trend
    })

    # Calculate all the stats when the "apply and calculate" button is pressed
    observeEvent(input$go_trend, {
      # do nothing except give a message if no file has been loaded yet
      if(
        is.null(input$file1_trend)
      ){
        showNotification("Please upload a data file in xls, xlsx, csv or ods format.", duration = 10, type = "message")
        return()
      }

      # Determine File Type and return emptyhanded if not valid for our purposes - avoids ugly crashes if an unexpected file is selected
      FileType <- tolower(tools::file_ext(input$file1_trend$datapath))
      if(FileType!="ods"&&FileType!="csv"&&FileType!="xls"&&FileType!="xlsx"){
        showNotification("That data file is not of a recognised type. Please upload a data file in xls, xlsx, csv or ods format.", duration = 10, type = "message")
        return()
      }

      # convert values in accordance with the selected method for managing non detects
      if(input$btn1_trend == 'zero') {
        values$data_trend <- values$org_data_trend %>% mutate(across(starts_with('analyte'), ~as.numeric(replace(., grepl('<', .), 0))))
      } else if(input$btn1_trend == 'half') {
        values$data_trend <- values$org_data_trend %>% mutate(across(starts_with('analyte'), ~as.numeric(ifelse(grepl('<', .), parse_number(.)/2, .))))
      } else if(input$btn1_trend == 'same') {
        values$data_trend <- values$org_data_trend %>% mutate(across(starts_with('analyte'), ~parse_number(as.character(.))))
      }

      # Collate the data. Convert submitted format to format that Kendall test likes
      # values$org_data_trend$newdate <- strptime(as.character(values$org_data_trend$date), "%d/%m/%Y") # creates new date column and re arrange date format
      # values$org_data_trend$newdate <-format(values$org_data_trend$newdate, "%Y-%m-%d") # create - instead of / breaks
      # values$org_data_trend = subset(values$org_data_trend, select = -c(date)) # delete old date
      # values$org_data_trend = rename(values$org_data_trend, date = newdate) # rename new date
      # values$org_data_trend = values$org_data_trend %>% relocate(date, .before = id) # relocate date to first column
      # values$org_data_trend$date = as.Date(values$org_data_trend$date, "%Y-%m-%d")
      # values$org_data_trend = values$org_data_trend  %>% mutate(month = date) # replicate date column as a column named month
      # values$org_data_trend$month <- strftime(values$org_data_trend$month, "%m") # convert date to month numerical
      # values$org_data_trend = values$org_data_trend  %>% mutate(year = date) # replicate date column as a column named year 
      # values$org_data_trend$year <- strftime(values$org_data_trend$year, "%Y") # convert date to year numerical
      # values$org_data_trend$sampdate <- paste(values$org_data_trend$year, ".", values$org_data_trend$month) # concatenate year and month that seasonal kendal needs
      # values$org_data_trend = subset(values$org_data_trend, select = -c(month)) # delete old month
      # values$org_data_trend = values$org_data_trend %>% relocate(sampdate, .before = date) # relocate date to first column
      # values$org_data_trend = values$org_data_trend %>% relocate(year, .before = sampdate) # relocate year to first column
      # values$org_data_trend = values$org_data_trend  %>% mutate(month = date) # replicate date column as a month again column for later change to three letter month
      # values$org_data_trend$month <- strftime(values$org_data_trend$month, "%b") # change date to three letter month
      # values$org_data_trend = values$org_data_trend %>% relocate(month, .before = year) # relocate year to first column
      # values$org_data_trend$year = as.integer(values$org_data_trend$year)
      # values$org_data_trend = values$org_data_trend %>% mutate(across(where(is.character), str_remove_all, pattern = fixed(" "))) # takes out white space from all character columns
      # values$org_data_trend$sampdate = as.numeric(values$org_data_trend$sampdate)
      
      
      
      
      values$df_l_trend <- values$data_trend %>%
        mutate(date = dmy(date)) %>%
        pivot_longer(cols = starts_with("analyte"), 
                     names_to = "analyte",
                     names_prefix = "analyte ",
                     values_to = "result",
                     values_drop_na = TRUE)
   
      
    # Make sure results are in date order
    values$df_l_trend <-  values$df_l_trend %>%
      arrange(date)
      
    values$df_l_trend %>%
      group_by(id, analyte) %>%
        summarise(model = list(mk.test(result, alternative = c("two.sided", "greater", "less"), 
                                       continuity = TRUE)), .groups = 'drop', 
                  n = n(), 
                  z = map_dbl(model, ~.x$statistic[['z']]), 
                  p = map_dbl(model, ~.x$p.value),  
                  S = map_dbl(model, ~.x$estimates[['S']]), 
                  varS = map_dbl(model, ~.x$estimates[['varS']]), 
                  tau = map_dbl(model, ~.x$estimates[['tau']]), 
                  mean = mean(result),
                  sd = sd(result),
                  cov = sd/mean, 
                  results = case_when(S >  0 & p < 0.05 ~ "INCREASING",
                                      S <  0 & p < 0.05 ~ "DECREASING",
                                      S >  0 & p < 0.1 ~ "POSSIBLY INCREASING",
                                      S <  0 & p < 0.1 ~ "POSSIBLY DECREASING",
                                      S >  0 & p > 0.1 ~ "NO CLEAR TREND",
                                      S <= 0 & p >0.1 & cov >= 1 ~"NO CLEAR TREND",
                                      p > 0.1 & cov < 1 ~ "STABLE")) %>%
        select(-model) -> values$KTT
      


      # values$df_l_trend %>%
      #   group_by(id, analyte) %>%
      #   summarise(kendal_data = list(kendallTrendTest(result ~ sampdate,
      #                                                 data = cur_data_all(),
      #                                                 alternative = "two.sided", correct = TRUE, ci.slope = TRUE, conf.level = 0.95,
      #                                                 independent.obs = TRUE))) %>%
      #   ungroup %>%
      #   mutate(kendal_data_new = map(kendal_data, tidy)) %>%
      #   unnest_wider(kendal_data_new) %>%
      #   select(-method, -alternative) %>%
      #   mutate(ktt.tau = estimate1,
      #          ktt.slope = estimate2,
      #          ktt.intercept = estimate3,
      #          ktt.z.stat = statistic,
      #          ktt.p.value = p.value,
      #          ktt.sample.size = map_dbl(kendal_data, `[[`, "sample.size")) %>%
      #   select(-estimate1, -estimate2, -estimate3, -statistic) %>%
      #   select(id, analyte, ktt.z.stat,  p.value, ktt.tau, ktt.slope, ktt.intercept, ktt.sample.size) -> values$KTT
      # 
      # 
      # 
      # 
      # values$df_l_trend %>%
      #   group_by(id, analyte) %>%
      #   summarise(kendal_seasonal_data = list(kendallSeasonalTrendTest(result ~ month + year,
      #                                                                  data = cur_data_all(),
      #                                                                  alternative = "two.sided", correct = TRUE, ci.slope = TRUE, conf.level = 0.95,
      #                                                                  independent.obs = TRUE))) %>%
      #   ungroup %>%
      #   transmute(id, analyte,
      #             kstt.stat.chi = map_dbl(kendal_seasonal_data, ~.x[["statistic"]][["Chi-Square (Het)"]]),
      #             kstt.stat.ztrend =  map_dbl(kendal_seasonal_data,~.x[["statistic"]][["z (Trend)"]]),
      #             kstt.deg.freedom =  map_dbl(kendal_seasonal_data,~.x[["parameters"]][["df"]]),
      #             kstt.p.value.chi =  map_dbl(kendal_seasonal_data,~.x[["p.value"]][["Chi-Square (Het)"]]),
      #             kstt.p.value.ztrend =  map_dbl(kendal_seasonal_data,~.x[["p.value"]][["z (Trend)"]]),
      #             kstt.tau =  map_dbl(kendal_seasonal_data,~.x[["estimate"]][["tau"]]),
      #             kstt.slope =  map_dbl(kendal_seasonal_data,~.x[["estimate"]][["slope"]]),
      #             kstt.intercept =  map_dbl(kendal_seasonal_data,~.x[["estimate"]][["intercept"]]),
      #             kstt.sample.size =  map_dbl(kendal_seasonal_data,~.x[["sample.size"]][["Total"]])) -> values$KSTT



      values$df_l_trend %>%
        group_by(id, analyte) %>%
        summarise(plot1 = list(ggplot(cur_data()) +
                                 geom_point(aes(date, result)) +
                                 geom_line(aes(date, result)) +
                                 geom_smooth(aes(date, result), method = "loess", colour = "blue", size = 1, se = FALSE) +
                                 geom_smooth(aes(date, result), method = "lm", colour = "red", size = 1, linetype = "dashed", se = TRUE) +
                                 theme_linedraw() +
                                 labs(title = "Concentration Over Time", subtitle = "LOWESS & Linear Trend Line & 95% Limits", x = "Date", y = "Concentration")
        ),
                                 
                  plot2 = list(ggplot(cur_data()) +
                                 geom_point(aes(date, y=cumsum(result))) +
                                 geom_line(aes(date, y=cumsum(result))) +
                                 geom_smooth(aes(date, y=cumsum(result)), method = "loess", colour = "blue", size = 1, se = FALSE) +
                                 theme_linedraw() +
                                 labs(title = "Cumulative Concentration", subtitle = "LOWESS Trend Line", x = "Date", y = "Concentration")
                  )
        ) -> values$plot_data
    })

    observeEvent(input$id_trend, {
      req(input$id_trend)
      values$display_KTT <- values$KTT %>%
                               filter(id == input$id_trend & analyte == input$analyte_trend) %>%
                                select(-id, -analyte)
      # values$display_KSTT <- values$KSTT %>%
      #                           filter(id == input$id_trend & analyte == input$analyte_trend) %>%
      #                           select(-id, -analyte)

    })

    observeEvent(input$analyte_trend, {
      req(input$id_trend)
      values$display_KTT <- values$KTT %>%
        filter(id == input$id_trend & analyte == input$analyte_trend) %>%
        select(-id, -analyte)
      # values$display_KSTT <- values$KSTT %>%
      #   filter(id == input$id_trend & analyte == input$analyte_trend) %>%
      #   select(-id, -analyte)
    })

    output$plot_trend <- renderPlot({
      req(input$id_trend)
      plot1 <- values$plot_data %>%
                  filter(id == input$id_trend & analyte == input$analyte_trend) %>%
                  pull(plot1) %>%
                  .[[1]]

      plot2 <- values$plot_data %>%
                filter(id == input$id_trend & analyte == input$analyte_trend) %>%
                pull(plot2) %>%
                .[[1]]

      grid.arrange(plot1, plot2, ncol = 2)
    })


    output$contents_trend <- renderDataTable({
      req(input$id_trend)
      filtered_data_trend <- values$df_l_trend %>%
        filter(id == input$id_trend & analyte == input$analyte_trend)
      datatable(
        filtered_data_trend,
        options = list(paging=FALSE, scrollY = "20vh"),
        rownames= TRUE
      )
    })

    output$id_trend <- renderUI({
      req(values$df_l_trend)
      selectInput('id_trend', 'Select Id : ', unique(values$df_l_trend$id))
    })

    output$analyte_trend <- renderUI({
      req(values$df_l_trend)
      selectInput('analyte_trend', 'Select Analyte : ', unique(values$df_l_trend$analyte))
    })


    output$click1_trend <- renderUI({
      req(input$id_trend)
      downloadButton("generate_report_trend", "Click to report")
    })

    output$btn2_trend <- renderUI({
      req(input$id_trend)
      radioButtons('report_trend',
        h3('Generate report', style = "font-weight:bold;"),
        c('The current display' = 'current',
          'All data' = 'data'))
    })

    output$generate_report_trend <- downloadHandler(
      filename = "report_trend.pdf",
      content = function(file) {
        tempReport <- file.path(
          tempdir(),
          "TrendReport.Rmd"
        )
        file.copy(
          "TrendReport.Rmd",
          tempReport,
          overwrite = TRUE
        )

        if(input$report_trend == 'current') {
          KTT_data <- values$KTT %>% filter(id == input$id_trend & analyte == input$analyte_trend)
          #KSTT_data <- values$KSTT %>% filter(id == input$id_trend & analyte == input$analyte_trend)
          plot_data <- values$plot_data %>% filter(id == input$id_trend & analyte == input$analyte_trend)
        } else {
          KTT_data <- values$KTT
          #KSTT_data <- values$KSTT
          plot_data <- values$plot_data
        }

        # Details for printing
        params <- list(
          type = input$report_trend,
          KTT_data = KTT_data,
          #KSTT_data = KSTT_data,
          plot_data = plot_data,
          title = input$title_trend,
          filename = input$file1_trend$name
        )

        rmarkdown::render(
          tempReport,
          output_file = file,
          params = params,
          envir = new.env(parent = globalenv())
        )
      } # end content
    ) # end download handler


    output$column1_trend <- renderText({
      req(values$display_KTT)
      names <- names(values$display_KTT)
      values1 <- c(round(unlist(values$display_KTT[-10]), 2), 
                   values$display_KTT[10])

      # Set up first eleven values: DESCRIPTIVE STATS n through skewness
      text1 <- sprintf(
        '<table class="w3-table-all notranslate">
        <tbody>
        <tr><h4 style = "font-weight : bold;">Kendall Trend Test Results Continuous: </h4></tr>
        %s
        </tbody></table><br/>',
        paste0(
          sprintf(
            '<tr><td style="width:250px;">%s</td><td>%s</td></tr>',
            names,
            values1),
          collapse = '\n'
        )
      )
    })

    # output$column2_trend <- renderText({
    #   req(values$display_KSTT)
    #   names <- names(values$display_KSTT)
    #   values1 <- round(unlist(values$display_KSTT), 2)
    # 
    #   # Set up first eleven values: DESCRIPTIVE STATS n through skewness
    #   text1 <- sprintf(
    #     '<table class="w3-table-all notranslate">
    #     <tbody>
    #     <tr><h4 style = "font-weight : bold;">Kendall Trend Test Results Seasonal : </h4></tr>
    #     %s
    #     </tbody></table><br/>',
    #     paste0(
    #       sprintf(
    #         '<tr><td style="width:250px;">%s</td><td>%s</td></tr>',
    #         names,
    #         values1),
    #       collapse = '\n'
    #     )
    #   )
    # })

    ######## BASIC STATS AND UCL TAB ############
    output$tabset1Selected <- renderText({
      input$tabset1
    })


    output$value1_trend <- renderText({
      req(input$id_trend)
      input$id_trend
    })

    output$value2_trend <- renderText({
      req(input$analyte_trend)
      input$analyte_trend
    })

    # Display the selected analyte
    # "input$state" is the dropdown value for the analyte to display
    # "values$df_l" is the analytical data
    output$title <- renderText({
      req(input$state, values$df_l)
      input$title
    })

    # Set UCL Confidence Intervals based on slider value
    observeEvent(input$confidence, {
        values$conf = input$confidence / 100
        values$alpha = 1 - values$conf
    })

    # Read in the uploaded data file
    observeEvent(input$file1, {
      # Determine File Type and return emptyhanded if not valid for our purposes
      FileType <- tolower(tools::file_ext(input$file1$datapath))
      if(FileType!="ods"&&FileType!="csv"&&FileType!="xls"&&FileType!="xlsx"){
        showNotification("Please upload a data file in xls, xlsx, csv or ods format.", duration = 10, type = "message")
        return()
      }

      #Read in the data using the appropriate tool
      ifelse(
        FileType == "ods",
        values$org_data <- read_ods(input$file1$datapath),
        ifelse(
          FileType == "csv",
          values$org_data <- read_csv(input$file1$datapath),
          ifelse(
            FileType == "xls" || FileType == "xlsx",
            values$org_data <- read_excel(input$file1$datapath),
            showNotification("Please upload a data file in xls, xlsx, csv or ods format.", duration = 10, type = "message")
          )
        )
      )
    })

    # draw the data table (list of analyte values)
    output$contents <- renderDataTable({
      req(values$df_l)
      datatable(
        values$df_l %>% filter(name == input$state), # filter for selected variable (input$state)
        options = list(paging=FALSE, scrollY = "20vh"),
        rownames= TRUE
      )
    })

    # select whether to report for the current analyte or all analytes
    output$btn2 <- renderUI({
      req(values$df_l)
      radioButtons(
        'report',
        h3(
          'Generate report',
          style = "font-weight:bold;"
        ),
        c(
          'The current display' = 'current',
          'All data' = 'data'
        )
      )# end radio buttons
    })# end button 2  output

    # Button for generating the report
    output$click1 <- renderUI({
      req(values$df_l)
      downloadButton(
        "generate_report",
        "Click to report"
      )
    })

    # Code to generate the report PDF
    output$generate_report <- downloadHandler(
      filename = "report.pdf",
      content = function(file) {
        tempReport <- file.path(
          tempdir(),
          "UCLReportRev8.Rmd"
        )
        file.copy(
          "UCLReportRev8.Rmd",
          tempReport,
          overwrite = TRUE
        )
        tmp <- split(values$sum_stats, values$sum_stats$name)

        # Choose one or many analytes
        if(input$report == 'current') {
          names <- input$state
        } else {
          names <- names(tmp)
        }

        # Details for printing
        params <- list(
          type = input$report,
          data = tmp[names],
          title = input$title,
          filename = input$file1$name,
          dropdown = input$state,
          my_qqplot = values$my_qqplot[names],
          my_qqplotlog = values$my_qqplotlog[names],
          my_boxplot = values$my_boxplot[names],
          my_hist = values$my_hist[names]
        )

        rmarkdown::render(
          tempReport,
          output_file = file,
          params = params,
          envir = new.env(parent = globalenv())
        )
      } # end content
    ) # end download handler

    # Calculate all the stats when the "apply and calculate" button is pressed
    observeEvent(input$go, {
      # do nothing except give a message if no file has been loaded yet
      if(
        is.null(input$file1)
      ){
        showNotification("Please upload a data file in xls, xlsx, csv or ods format.", duration = 10, type = "message")
        return()
      }

      # Determine File Type and return emptyhanded if not valid for our purposes - avoids ugly crashes if an unexpected file is selected
      FileType <- tolower(tools::file_ext(input$file1$datapath))
      if(FileType!="ods"&&FileType!="csv"&&FileType!="xls"&&FileType!="xlsx"){
        showNotification("That data file is not of a recognised type. Please upload a data file in xls, xlsx, csv or ods format.", duration = 10, type = "message")
        return()
      }

      # convert values in accordance with the selected method for managing non detects
      if(input$btn1 == 'zero') {
        values$df_data <- values$org_data %>% mutate(across(where(is.character), ~as.numeric(replace(., grepl('<', .), 0))))
      } else if(input$btn1 == 'half') {
        values$df_data <- values$org_data %>% mutate(across(where(is.character), ~as.numeric(ifelse(grepl('<', .), parse_number(.)/2, .))))
      } else if(input$btn1 == 'same') {
        values$df_data <- values$org_data %>% mutate(across(where(is.character), parse_number))
      }

      # Collate the data
      values$df_l = pivot_longer(values$df_data, cols = everything())
      values$df_l = values$df_l[complete.cases(values$df_l), ]
      # Calculate statistical parameters
      values$sum_stats <- values$df_l  %>%
        group_by(name) %>%
        summarise(
          # DESCRIPTIVE STATS
          n = sum(!is.na(value)),
          min = min(value),
          max = max(value),
          range = max - min,
          mean = round(mean(value), 5),
          gm =round((gm_mean(value)),5), # calls created function
          median = median(value),
          `standard deviation (sd)` = round((sd(value)),5),
          `standard error of mean (sem)` = round((sd(value)/sqrt(n())),5),
          `coeficient of variation (cv)` = round((sd(value)/mean(value)),5),
          skewness = round((skewness(value)),5),
          # LOG TRANSFORMED STATS
          `Log min` = round((min(log(value))),5),
          `Log max` = round((max(log(value))),5),
          `Log mean` = round((mean(log(value))),5),
          `Log sd` = round((sd(log(value))),5),
          # NORMALITY TESTS
          `Shapiro-Wilks Value (raw)` = ifelse(range==0,NA,round((shapiro.test(value)$statistic),5)),
          `Shapiro-Wilks p (raw)` =     ifelse(range==0,NA,round((shapiro.test(value)$p.value),5)),
          `Shapiro-Wilks Value (log)` = ifelse(range==0,NA,round((shapiro.test(log(value))$statistic),5)),
          `Shapiro-Wilks p (log)` =     ifelse(range==0,NA,round((shapiro.test(log(value))$p.value),5)),
          # UPPER CONFIDENCE LIMITS
          `Confidence Level (%)` = input$confidence,
          `Students t UCL` =        ifelse(range==0,NA,round((tidy(t.test(value, conf.level = values$conf, alternative = "less"))$conf.high),5)),
          `Lands HUCL` =            ifelse(range==0,NA,Land_HUCL(value, values$conf)),
          `Zou UCL` =               ifelse(range==0,NA,Zou_UCL(value, values$conf))
        ) %>%

        # Some additional mutated calculations
        mutate(
          `Tchebichef (Chebyshev) UCL` = round((mean + (`standard error of mean (sem)` * (sqrt((1/values$alpha)-1)))),5),
          #`Chebychev 95% UCL Skew` = mean + 4.36 * (`standard deviation (sd)`/(sqrt(n))), # method as per NSW SDG nulled
          # MISCELLANEOUS STATS
          `CV High` = `coeficient of variation (cv)` > 1.0,
          `Normality Raw Data` = ifelse(`Shapiro-Wilks p (raw)` <= 0.05, "FALSE", "TRUE"),
          `Normality Log Data` = ifelse(`Shapiro-Wilks p (log)` <= 0.05, "FALSE", "TRUE"),
          `Critical t (95%) 2 Sided` = round(((qt(1-(0.05/2), n-1))),5),
          `Margin of Error (MoE)` = round((`Critical t (95%) 2 Sided` * `standard error of mean (sem)`),5),
          `Z` = round((qnorm(0.05, mean = mean, sd = `standard deviation (sd)`, lower.tail = FALSE)),5),
          `Max Probable Error (MPE%)` = round(((`Margin of Error (MoE)`/mean)*100),5),
          `Relative Standard Deviation (%RSD)` = (100*`standard deviation (sd)`)/abs(mean),
          empty_cell1 = '',
          empty_cell2 = '',
          empty_cell3 = ''
        ) %>%

        # Rounding for presentation
        mutate(across(where(is.numeric), round, 3))

        #Show first analyte by default
        values$show_stats <- values$sum_stats %>%
          filter(name == input$state) %>%
          select(-1)
    }) # End "Apply and Calculate"

    # Change to the newly selected analyte when chosen from the drop down list
    observeEvent(input$state, {
      req(input$state, values$sum_stats)
      values$show_stats <- values$sum_stats %>%
        filter(name == input$state) %>%
        select(-1)
    })

    # Display output table for first column
    output$column1 <- renderText({
      req(values$sum_stats)
      names <- names(values$show_stats)
      values1 <- unlist(values$show_stats)

      # Set up first eleven values: DESCRIPTIVE STATS n through skewness
      text1 <- sprintf(
        '<table class="w3-table-all notranslate">
        <tbody>
        <tr><h4 style = "font-weight : bold;">Descriptive Stats : </h4></tr>
        %s
        </tbody></table><br/>',
        paste0(
          sprintf(
            '<tr><td style="width:250px;">%s</td><td>%s</td></tr>',
            names[1:11],
            values1[1:11]),
            collapse = '\n'
          )
        )

      #Set up values 12 - 15: LOG TRANSFORMED STATS
      text2 <- sprintf(
        '<table class="w3-table-all notranslate">
        <tbody>
        <tr><h4 style = "font-weight : bold;">Log transformed stats : </h4></tr>
        %s
        </tbody></table><br/>',
        paste0(
          sprintf(
            '<tr><td style="width:250px;">%s</td><td>%s</td></tr>',
            names[12:15],
            values1[12:15]),
            collapse = '\n'
          )
        )

      # Set up values 16 - 19: NORMALITY TESTS
      text3 <- sprintf(
        '<table class="w3-table-all notranslate">
        <tbody>
        <tr><h4 style = "font-weight : bold;">Normality Tests : </h4></tr>
        %s
        </tbody></table><br/>',
        paste0(
          sprintf(
            '<tr><td style="width:250px;">%s</td><td>%s</td></tr>',
            names[16:19],
            values1[16:19]),
            collapse = '\n'
          )
        )
      # Output it all in HTML
      HTML(paste0(text1, text2, text3, collapse = '<br/>'))
    })

    # Structure for second column of results
    output$column2 <- renderText({
      req(values$sum_stats)
      names <- names(values$show_stats)
      values1 <- unlist(values$show_stats)

      # Display UCLs
      text1 <- sprintf(
        '<table class="w3-table-all notranslate">
        <tbody>
        <tr><h4 style = "font-weight : bold;">UCLs : </h4></tr>
        %s
        </tbody></table><br/>',
        paste0(
          sprintf(
            '<tr><td style="width:250px;">%s</td><td>%s</td></tr>',
            names[20:24],
            values1[20:24]
          ),
          collapse = '\n'
        )
      )

      # structure for MISCELLANEOUS STATS
      text2 <- sprintf(
        '<table class="w3-table-all notranslate">
        <tbody>
        <tr><h4 style = "font-weight : bold;">Other: </h4></tr>
        %s
        </tbody></table><br/>',
        paste0(
          sprintf(
            '<tr><td style="width:250px;">%s</td><td>%s</td></tr>',
            names[25:32],
            values1[25:32]
          ),
          collapse = '\n'
        )
      )

      HTML(paste0(text1, text2, collapse = '<br/>'))
    }) # end second column of results


    # Analyte selection dropdown.
    output$dropdown1 <- renderUI({
      if(
        is.null(input$file1)
      ) val = ''
      else (
        val = names(values$org_data)
      )
      selectInput("state", "", val)
    })

    output$value <- renderText({
      req(values$sum_stats)
      input$state
    })


    #Plots
    output$qq_plot <- renderPlot({
      req(input$state, values$df_l)
      data <- split(values$df_l,values$df_l$name)
      #data = values$df_l %>% filter(name == input$state)
      #Plot1
      values$my_qqplot <- lapply(
        data,
        function(x) {
          ggplot(x, mapping = aes(sample = value)) +
            stat_qq_band(alpha=0.5) +
            stat_qq_line() +
            stat_qq_point() +
            theme_linedraw() +
            labs(title = "Q-Q Plot Raw Data", x = "Theoretical Quantiles", y = "Sample Quantiles"
          )
        })

      #Plot2
      values$my_qqplotlog <- lapply(data, function(x) {
        ggplot(x, mapping = aes(sample = log(value))) +
          stat_qq_band(alpha=0.5) +
          stat_qq_line() +
          stat_qq_point() +
          theme_linedraw() +
          labs(title = "Q-Q Plot Log Data", x = "Theoretical Quantiles", y = "Sample Quantiles")
      })

      #Plot3
      values$my_boxplot <- lapply(data, function(x) {
        ggplot(data = x, aes(x=name, y=value, group=name)) +
          geom_boxplot(aes(fill=name), width=0.2, outlier.shape = 4, outlier.size = 4, fill="gray") +
          stat_boxplot(geom = "errorbar", width = 0.2) +
          stat_summary(fun=mean, geom="point", shape=23, size=4) +
          theme_linedraw() +
          #geom_dotplot(binaxis='y', stackdir='center', dotsize=1.0, alpha=1.0) +
          labs(title = "Box & Whisker Plot", x = "Analyte", y = "Concentration")
      })

      #Plot4
      values$my_hist <- lapply(data, function(x) {
        ggplot(x, aes(x=value, group=name)) +
          geom_histogram(col="white") +#, aes(y=..density..)) +
          #geom_density() +
          theme_linedraw() +
          #geom_vline(data=values$sum_stats, aes(xintercept=mean), colour="blue", linetype = "dashed", size =.5) +
          labs(title = "Histogram Plot", x = "Concentration", y = "Count")
      })

      grid.arrange(values$my_qqplot[[input$state]], values$my_qqplotlog[[input$state]],
                   values$my_boxplot[[input$state]],values$my_hist[[input$state]],
        ncol = 2,
        top = textGrob(paste0(' '))
        #top = textGrob(paste0('Plots for : ', input$state),gp=gpar(fontsize=20,font=3))
        )
    })


  }
)
