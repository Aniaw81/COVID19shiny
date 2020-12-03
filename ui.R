#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

if (FALSE) {
data <- read.csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", na.strings = "", fileEncoding = "UTF-8-BOM")
covidcases<- data %>%
    dplyr::filter(geoId %in% c("PL","DE","CZ","SK","RU","LT","UA","BY")) %>%
    dplyr::mutate(time=dmy(dateRep), geoId=droplevels(geoId))
save(covidcases,file="covidcases.Rda")
}
load("covidcases.Rda")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Presentation of COVID-19 cases in chosen countries"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel( h3("slider")
            ,sliderInput(inputId="timeRange", label = "Select date range:",
                        min = min(covidcases$time),
                        max = max(covidcases$time),
                        value = c(min(covidcases$time),max(covidcases$time)),timeFormat="%Y-%m-%d")

            # Add Variables selection option from chosen countries :
            ,selectInput("countries", "Select countries", 
                        choices=c("PL","DE","CZ","SK","RU","LT","UA","BY"),
                        multiple=TRUE, selected = "PL"
            ),
      # textInput("timeRange", "Caption", min(covidcases$time)),
        textOutput("slidervalue")
        ),

         #Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(type="tab",
                      tabPanel("Plot",plotlyOutput("mygraph")),
                      tabPanel("Cumultative sum", h4("Sum of COVID-19 cases in given time range for selected countries"), tableOutput("cumsum")),
                      tabPanel("About",p("Please choose time range using slider input and the list of countries with select input."),
                              p("Based on that application prepares data to calculations."))
          )            
        )
    )
))
