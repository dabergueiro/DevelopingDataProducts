catAge <<- c(0.083, 0.25, 0.5, 0.67, 1, 2, 4, 6, 8, 10, 12, 14, 16)
humanAge <<- c(0.5, 4, 10, 15, 18, 24, 35, 42, 50, 60, 70, 80, 84)
Cats <<- as.data.frame(t(rbind(catAge, humanAge)))

dogAge <<- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
humanAge.SmallBreed <<- c(15, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80)
humanAge.MediumBreed <<- c(15, 24, 28, 32, 36, 42, 47, 51, 56, 60, 65, 69, 74, 78, 83, 87)
humanAge.LargeBreed <<- c(15, 24, 28, 32, 36, 45, 50, 55, 61, 66, 72, 77, 82, 88, 93, 120)
Dogs <<- as.data.frame(t(rbind(dogAge, humanAge.SmallBreed, humanAge.MediumBreed, humanAge.LargeBreed)))

CalculateHumanAge <- function (tmpType, Age) {
  if (tmpType =="cat")
  {
    lm1 <<- lm(Cats$catAge ~ Cats$humanAge)
    tmpAge <- as.numeric((Age - lm1$coefficients[1]) / lm1$coefficients[2])
  }
  else
  {
    if (tmpType == "smallDog")
    {
      lm2 <<- lm(Dogs$dogAge ~ Dogs$humanAge.SmallBreed)
      tmpAge <- as.numeric((Age - lm2$coefficients[1]) / lm2$coefficients[2])
    }
    else
    {
      if (tmpType == "mediumDog")
      {
        lm3 <<- lm(Dogs$dogAge ~ Dogs$humanAge.MediumBreed)
        tmpAge <- as.numeric((Age - lm3$coefficients[1]) / lm3$coefficients[2])
      }
      else
      {
        if (tmpType == "largeDog")
        {
          lm4 <<- lm(Dogs$dogAge ~ Dogs$humanAge.LargeBreed)
          tmpAge <- as.numeric((Age - lm4$coefficients[1]) / lm4$coefficients[2])
        }
        else
        {
          tmpAge <- 0
        }
      }
    }
  }
  return(round(tmpAge, 2))
}

shinyServer(
  function(input, output) {
    output$PetAgeHumanYears <- renderPrint({
                                            input$update
                                            isolate(CalculateHumanAge(input$PetType, input$PetAge+input$HumanAge-input$AgeHumanAcquired))
                                            })
    output$AgePlot <- renderPlot({ageRange <- c(input$AgeHumanAcquired:(input$AgeHumanAcquired+20))
                                  petAgeRange <- ageRange - (ageRange[1] - input$PetAge)
                                  
                                  if (input$PetType =="cat")
                                  {
                                    model <<- lm(Cats$catAge ~ Cats$humanAge)
                                  }
                                  else
                                  {
                                    if (input$PetType == "smallDog")
                                    {
                                      model <<- lm(Dogs$dogAge ~ Dogs$humanAge.SmallBreed)
                                    }
                                    else
                                    {
                                      if (input$PetType == "mediumDog")
                                      {
                                        model <<- lm(Dogs$dogAge ~ Dogs$humanAge.MediumBreed)
                                      }
                                      else
                                      {
                                        if (input$PetType == "largeDog")
                                        {
                                          model <<- lm(Dogs$dogAge ~ Dogs$humanAge.LargeBreed)
                                        }
                                      }
                                    }
                                  }
                                  
                                  HumanAgeRange <- (petAgeRange - model$coefficients[1]) / model$coefficients[2]
                                  pet <- data.frame(cbind(ageRange, HumanAgeRange))
                                  
                                  rm(ageRange, petAgeRange, HumanAgeRange)
                                  
                                  lm0 <- lm(pet$HumanAgeRange ~ pet$ageRange)
                                  
                                  plot(c(1:150), c(1:150), type="n", xlab="Human Age", ylab="Human Age")
                                  abline(0, 1, col="blue", lwd = 3)
                                  abline(lm0, col="red", lwd=2)
                                  abline(v = input$HumanAge, col = "black", lwd=1)
                                  abline(h = pet[pet$ageRange == input$HumanAge,][2], col = "black", lwd=1)})
  }
)