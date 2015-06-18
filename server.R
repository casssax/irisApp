# load model to use in predict function
# knnFit <- load("data/knnFit.RData")
# centerScale <- load("data/irisCenterScale.RData")
library(caret)
library(datasets)
library(gridExtra)
library(plyr)
library(dplyr)


shinyServer(
        function(input, output) {
                data(iris)
                load("data/irisMinMax.RData")
                load("data/knnFit.RData")
                load("data/irisCenterScale.RData")
                
                #                 pics <- reactive({
                #                         data.frame(Species = c("Setosa","Versicolor","Verginica"),
                #                                    picture = c("Setosa.jpg","daVersicolor.jpg","Verginica.jpg"))
                #                 })
                
                dims <- reactive({
                        dimensions <- data.frame(Sepal.Length = input$sepLen,
                                                 Sepal.Width = input$sepWid,
                                                 Petal.Length = input$pedLen,
                                                 Petal.Width = input$pedWid)
                })
                
                
                plt <- reactive({
                        testing <- predict(centerScale,dims())
                        result <- predict(knnFit, testing, type = "prob")
                        print("result: ")
                        print(result)
                        result[1,]
                })
                
                outFrame <- reactive({
                        data.frame(Species = c('Setosa',
                                               'Versicolor',
                                               'Virginica'),
                                   Percent = round(plt() * 100,2),row.names = NULL)
                        
                })
                
                output$plot1 <- renderPlot({
                        Species <- c("Setosa","Versicolor","Virginica")
                        percentage <- plt()
                        print("percentage: ")
                        print(class(percentage))
                        plotResult <- data.frame(Species,percentage)
                        print("df: ")
                        print(plotResult)
                        ggplot(plotResult, 
                               aes(x = factor(Species), 
                                   y = percentage,
                                   fill = factor(Species)
                               )) + 
                                geom_bar(stat="identity") + 
                                coord_flip() +
                                scale_x_discrete(limits=c("Virginica","Versicolor","Setosa")) +
                                scale_fill_discrete(breaks=c("Setosa","Versicolor","Virginica")) +
                                theme(legend.title=element_blank()) +
                                theme(axis.title.y=element_text(vjust=1)) +
                                theme(axis.title.x=element_text(vjust=-0.5)) +
                                xlab("Species") 
                        
                })
                output$resultsText <- renderText({
                        predictions <- outFrame()
                        winner <- predictions[predictions$Percent == max(predictions$Percent),]
                        
                        paste("The model predicts ", winner$Species, "with ", winner$Percent, "% likelihood.")
                })
                output$table <- renderTable(
                        outFrame()
                )
                output$picture <- renderImage({
                        predictions <- outFrame()
                        winner <- predictions[predictions$Percent == max(predictions$Percent),]
                        # When input$n is 3, filename is ./images/image3.jpeg
                        filename <- normalizePath(file.path('./www',
                                                            paste(winner$Species, '.jpg', sep='')))
                        
                        # Return a list containing the filename and alt text
                        list(src = filename,
                             alt = paste("Species", winner$Species))
                        
                }, deleteFile = FALSE)
                
                output$minMax <- renderTable(
                        irisMinMax
                )
                output$splot1 <- renderPlot(
                        qplot(Sepal.Length, Petal.Length, data = iris,color = Species)
                )
                output$splot2 <- renderPlot(
                        qplot(Sepal.Width, Petal.Width, data = iris,color = Species)
                )
                output$splot3 <- renderPlot(
                        qplot(Sepal.Width, Petal.Length, data = iris,color = Species)
                )
                output$splot4 <- renderPlot(
                        qplot(Sepal.Length, Petal.Width, data = iris,color = Species)
                )
                output$model <- renderText(
                        '
                        data(iris)
                        library(caret)
                        set.seed(808)
                        
                        inTrain <- createDataPartition(iris$Species, p = 2/3, list = FALSE)
                        
                        irisTrain <- iris[ inTrain, -ncol(iris)]
                        irisTest  <- iris[-inTrain, -ncol(iris)]
                        
                        trainClass <- iris[ inTrain, "Species"]
                        testClass  <- iris[-inTrain, "Species"]
                        
                        centerScale <- preProcess(irisTrain)
                        
                        training <- predict(centerScale, irisTrain)
                        testing <- predict(centerScale, irisTest)
                        
                        knnFit <- knn3(training, trainClass, k = 11)
                        
                        predict(knnFit, testing, type = "prob")'
                )
        }
                )