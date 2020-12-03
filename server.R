#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

load("covidcases.Rda")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {



    myFinalData <- reactive({
        cat(file=stderr(),input$timeRange[2])
        # Get data rows for selected year
        covidcases %>%
            dplyr::filter(geoId %in% input$countries) %>%
            dplyr::filter(time >= as.Date(input$timeRange[1])) %>% 
            dplyr::filter(time <= as.Date(input$timeRange[2]))
#            
    })
    
    output$slidervalue <- reactive({
        input$timeRange[1]
    })
    
    output$mygraph <- renderPlotly({
        plot_ly(myFinalData(),x = ~time,y = ~cases,color = ~geoId, mode="lines")
    })
    
    # preparing data for cumultative sum plot
    sumdata<- reactive({
        aggregate(myFinalData()$cases,by = list(Country = myFinalData()$geoId), FUN = sum) %>%
            rename(`sum of cases` = x)
        })
    
    
    
    
    output$cumsum <- renderTable({
        sumdata()
       
    })

    
    
    
   

})
