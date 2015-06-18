# ui.R

shinyUI(fluidPage(
        navbarPage("",
                   tabPanel("Predict Species",
                            titlePanel("Iris Prediction App:"),
                            sidebarLayout(
                                    sidebarPanel(
                                            helpText("Enter parameters to predict the 
                                                     percent chance flower belongs to species. 
                                                     Click 'Predict Species' when done."),
                                            
                                            numericInput("sepLen",
                                                         label = h3("Sepal Length"),
                                                         value = 1,
                                                         min = 4.3,
                                                         max = 7.9,
                                                         step = 0.01),
                                            numericInput("sepWid",
                                                         label = h3("Sepal Width"),
                                                         value = 1,
                                                         min = 2,
                                                         max = 4.4,
                                                         step = 0.01),
                                            numericInput("pedLen",
                                                         label = h3("Petal Length"),
                                                         value = 2,
                                                         min = 1,
                                                         max = 6.9,
                                                         step = 0.01),
                                            numericInput("pedWid",
                                                         label = h3("Petal Width"),
                                                         value = 3,
                                                         min = 0.1,
                                                         max = 2.5,
                                                         step = 0.01),
                                            submitButton("Predict Species", icon("refresh"))
                                            ),
                                    
                                    mainPanel(
                                            h3("Percent likelihood by Species"),
                                            plotOutput("plot1"),
                                            tags$hr(),
                                            h3(textOutput("resultsText")),
                                            fluidRow(
                                                    column(4,
                                                           h4("Full results:"),
                                                           tableOutput("table") 
                                                    ),
                                                    column(4,
                                                           imageOutput("picture",width = 181,height = 181)
                                                    )
                                            ),
                                            tags$hr(),
                                            h4("Min/Max values table:"),
                                            p("The table below shows the range of values for each variable in the iris dataset by species."),
                                            tableOutput("minMax")
                                    )
                                    )
        ),
        tabPanel("Plots",
                 h3("Iris Plots:"),
                 p("Plots of the relationships between variables in the iris dataset by species."),
                 p("Notice that there is a marked separation of Setosa from the other two species. 
                   This often results in predictions of 100% for Setosa. The species Versicolor and 
                   Virginica have some overlap, this often results in the prediction being split 
                   between these two species while Setosa will show zero percent."),
                 p("There are some combinations of predictors will result in the prediction being split
                   between all three species. (The default settings are selected so you can see a three way
                   split."),
                 p("A look at the Min/Max table on the 'Predict Species' tab will be useful for finding different
                   combinations of predictions to try."),
                 
                 fluidRow(
                         column(6,
                                plotOutput("splot1")
                         ),
                         column(6,
                                plotOutput("splot3")
                         )
                 ),
                 fluidRow(
                         column(6,
                                plotOutput("splot2")
                         ),
                         column(6,
                                plotOutput("splot4")
                         )
                 )
                 ),
        tabPanel("Documentation",
                 h3("How do I use the Iris Prediction App?"),
                 p("Using the Iris Prediction App is simple."),
                 p("Enter data for the four predictor values 
                   and then click on the 'Predict Species' button. The app will then display the results 
                   in the main plot and the table below."),
                 p("By changing only one of the predictor values you can experiment and see how the 
                   model results change as a result."),
                 p("Take a look at the 'Plots' tab to get an idea of which values will be most useful 
                   for each species of iris."),
                 p("Also take a look at the min/max table on the main page to get a feel for the range 
                   of values for each predictor by species.")
                 ),
        tabPanel("Model",
                 h3("The Model"),
                 verbatimTextOutput("model"),
                 p('The model for this app was created using the caret package and the "knn3" function.'),
                 p('"knn3" is a k-nearest neighbor classification model that returns "vote" information for each 
                   of the available classes in the dataset.'),
                 p('The "vote" information is the percentage that the model predicts a set of predictor variables 
                   belongs to each of the classes.  When the user enters a set of predictors and clicks the 
                   "Predict Species" button the data is first pre-processed using the "centerScale" object and then 
                   the predict function is used to get a prediction from the model.'),
                 p('The model is not created in the app itself, but has been saved and loaded into the app so 
                   the predict function can be used. Similarly, the "centerScale" object was also saved and loaded 
                   into the app. This was done to increase the speed and performance of the app.')
                 )
                 )
                 ))