library(shiny)
library(bslib)
library(tidyverse)

survey <- read.csv("data/survey.csv") |> 
  slice_sample(n = 5000, by = region)  

ui <- page_sidebar(
  
  sidebar = sidebar(
    selectInput(
      inputId = "region",
      label = "Seleccione region",
      choices = discard(unique(survey$region), is.na)
    ),
    sliderInput(
      inputId = "age",
      label = "Seleccione edad máxima",
      min = 10,
      max = 100,
      value = 100,
      step = 10
    )
  ),
  
  useBusyIndicators(),
  
  card(
    max_height = "50%",
    tableOutput("table")
  ),
  
  layout_columns(
    col_widths = c(4, 4, 4),
    
    card(
      plotOutput("histogram")
    ),
    card(
      full_screen = TRUE,
      plotOutput("by_transport")
    ),
    card(
      full_screen = TRUE,
      plotOutput("by_type")
    )
    
  )
  
)

server <- function(input, output, session) {
  output$table <- renderTable({
    survey |> 
      filter(region == input$region) |> 
      filter(age <= input$age)
  })
  
  output$histogram <- renderPlot({
    survey |> 
      filter(region == input$region) |> 
      filter(age <= input$age) |> 
      ggplot(aes(temps_trajet_en_heures)) +
      geom_histogram(bins = 20) +
      theme_light()
  })
  
  output$by_transport <- renderPlot({
    survey |> 
      filter(region == input$region) |> 
      filter(age <= input$age) |> 
      ggplot(aes(temps_trajet_en_heures)) +
      geom_histogram(bins = 20) +
      facet_wrap(~transport) +
      theme_light()
  })
  
  output$by_type <- renderPlot({
    survey |> 
      filter(region == input$region) |> 
      filter(age <= input$age) |> 
      ggplot(aes(temps_trajet_en_heures)) +
      geom_histogram(bins = 20) +
      facet_wrap(~type) +
      theme_light()
  })
}

shinyApp(ui, server)
