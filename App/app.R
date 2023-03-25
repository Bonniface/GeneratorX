library(shiny)
library(shinyjs)
library(tidyverse)

# Hide input variable selection on click
observeEvent(input$ok_button, {
  toggle("input_vars")
})

# Define UI for app
ui <- fluidPage(
  
  # Add a customized navbar with links to each section
  tags$head(
    tags$style(
      HTML("
        .navbar {
          background-color: #333333;
        }
        .navbar-default .navbar-nav > li > a:hover, 
        .navbar-default .navbar-nav > li > a:focus {
          background-color: #555555;
        }
        .navbar-default .navbar-nav > .active > a, 
        .navbar-default .navbar-nav > .active > a:hover, 
        .navbar-default .navbar-nav > .active > a:focus {
          background-color: #777777;
        }
      ")
    )
  ),
  navbarPage("My RShiny App",
             tabPanel("Import Data",
                      fluidRow(
                        # Add an "Input" column with a button to show/hide variable selection
                        column(width = 4,
                               style = "background-color: #f5f5f5; padding: 20px;",
                               h4("Input"),
                               fileInput("file1", "Choose CSV File", accept = c(".csv")),
                               h5("Select Input Variables:"),
                               uiOutput("input_vars_ui"),
                               actionButton("select_var", "Select"),
                        ),
                        # Add an "Output" column with a navbar to switch between different outputs
                        column(width = 8,
                               navbarPage("Data Output",
                                          tabPanel("Head",
                                                   dataTableOutput("head")),
                                          tabPanel("Table",
                                                   dataTableOutput("table")),
                                          tabPanel("Summary",
                                                   verbatimTextOutput("summary"))
                               )
                        )
                      )
             ),
             tabPanel("Preprocessor"),
             tabPanel("Model"),
             tabPanel("Model Evaluation")
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Read in data from file input
  data <- reactive({
    file <- input$file1
    if(is.null(file)) {
      return(NULL)
    }
    read.csv(file$datapath)
  })
  
  # Generate a list of variable names for the dataset
  variable_names <- reactive({
    if(is.null(data())) {
      return(NULL)
    }
    names(data())
  })
  
  # Show input variable select input when button is clicked
  output$input_vars_ui <- renderUI({
    if (input$select_var == 0) {
      div(id = "input_vars_div", style = "display: none;",
          selectInput("input_vars", "Select input variables:", choices = variable_names(), multiple = TRUE)
      )
    } else {
      div(id = "input_vars_div",
          selectInput("input_vars", "Select input variables:", choices = variable_names(), multiple = TRUE)
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
    data()[, input$input_vars, drop = FALSE]
  })
  
  # Generate head based on user inputs
  output$head <- renderDataTable({
    req(input$input_vars)
    head(data()[, input$input_vars, drop = FALSE])
  })
  
 
  
  # Generate summary based on user inputs
  output$summary <- renderPrint({
    req(input$input_vars, data())
    summary(data()[, input$input_vars, drop = FALSE])
  })
}

# Define JavaScript function to toggle visibility
toggle <- function(input_id) {
  shinyjs::toggle(id = input_id)
}

# Run the app
shinyApp(ui = ui, server = server)