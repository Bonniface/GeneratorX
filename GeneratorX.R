library(shiny)

library(shinyjs)
library(tidyverse)
# Define UI for app
# Define UI
ui <- fluidPage(
  titlePanel("GeneratorX"),
  sidebarLayout(
    sidebarPanel(
      actionButton("select_var", "Select input variables:"),
      uiOutput("input_vars_ui")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Head", dataTableOutput("head")),
        tabPanel("Summary", verbatimTextOutput("summary")),
        tabPanel("Table", dataTableOutput("table"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Show input variable select input when button is clicked
  output$input_vars_ui <- renderUI({
    if (input$select_var == 0) {
      div(id = "input_vars_div", style = "display: none;",
          selectInput("input_vars", "Select input variables:", choices = names(mtcars), multiple = TRUE)
      )
    } else {
      div(id = "input_vars_div",
          selectInput("input_vars", "Select input variables:", choices = names(mtcars), multiple = TRUE)
      )
    }
  })
  
  # Toggle visibility of input variable select input when button is clicked
  observeEvent(input$select_var, {
    jscode <- 'if ($("#input_vars_div").is(":visible")) {
                  $("#input_vars_div").hide();
               } else {
                  $("#input_vars_div").show();
               }'
    runjs(jscode)
  })
  
  # Generate table based on user inputs
  output$table <- renderDataTable({
    req(input$input_vars)
    mtcars[, input$input_vars, drop = FALSE]
  })
  
  # Generate head based on user inputs
  output$head <- renderDataTable({
    req(input$input_vars)
    head(mtcars[, input$input_vars, drop = FALSE])
  })
  
  # Generate summary based on user inputs
  output$summary <- renderPrint({
    req(input$input_vars)
    summary(mtcars[, input$input_vars, drop = FALSE])
  })
}

# Run the application
shinyApp(ui = ui, server = server)
