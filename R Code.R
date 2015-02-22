library(ggplot2)

#myName <- "Diego"
myAge <- 30
myAgeWhenAcquired <- 18
petAgeWhenAcquired <- 0.5

catAge <- c(0.083, 0.25, 0.5, 0.67, 1, 2, 4, 6, 8, 10, 12, 14, 16)
humanAge <- c(0.5, 4, 10, 15, 18, 24, 35, 42, 50, 60, 70, 80, 84)
Cats <- as.data.frame(t(rbind(catAge, humanAge)))

dogAge <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
humanAge.SmallBreed <- c(15, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80)
humanAge.MediumBreed <- c(15, 24, 28, 32, 36, 42, 47, 51, 56, 60, 65, 69, 74, 78, 83, 87)
humanAge.LargeBreed <- c(15, 24, 28, 32, 36, 45, 50, 55, 61, 66, 72, 77, 82, 88, 93, 120)
Dogs <- as.data.frame(t(rbind(dogAge, humanAge.SmallBreed, humanAge.MediumBreed, humanAge.LargeBreed)))

rm(catAge, humanAge, dogAge, humanAge.SmallBreed, humanAge.MediumBreed, humanAge.LargeBreed)

#Build models
lm1 <- lm(Cats$catAge ~ Cats$humanAge)
lm2 <- lm(Dogs$dogAge ~ Dogs$humanAge.SmallBreed)
lm3 <- lm(Dogs$dogAge ~ Dogs$humanAge.MediumBreed)
lm4 <- lm(Dogs$dogAge ~ Dogs$humanAge.LargeBreed)

summary(lm(Dogs$dogAge ~ Dogs$humanAge.LargeBreed))
summary(glm(Dogs$dogAge ~ Dogs$humanAge.SmallBreed, family= exponential))

plot(lm(Dogs$dogAge ~ Dogs$humanAge.SmallBreed), which=1)


#Plot model fits
par(mfrow=c(2, 2))

plot(Cats$humanAge, Cats$catAge)
abline(lm1, col="red", lwd=3)

plot(Dogs$humanAge.SmallBreed, Dogs$dogAge)
abline(lm2, col="red", lwd=3)

plot(Dogs$humanAge.MediumBreed, Dogs$dogAge)
abline(lm3, col="red", lwd=3)

plot(Dogs$humanAge.LargeBreed, Dogs$dogAge)
abline(lm4, col="red", lwd=3)



#Calculate human age: (<pet age> - lm<#>$coefficients[1]) / lm<#>$coefficients[2]

#plot age timeline
ageRange <- c(myAgeWhenAcquired:(myAgeWhenAcquired+20))
petAgeRange <- ageRange - (ageRange[1] - petAgeWhenAcquired)
#requires conditional:
HumanAgeRange <- (petAgeRange - lm4$coefficients[1]) / lm4$coefficients[2]
pet <- data.frame(cbind(ageRange, HumanAgeRange))

rm(ageRange, petAgeRange, HumanAgeRange)

lm0 <- lm(pet$HumanAgeRange ~ pet$ageRange)

par(mfrow=c(1, 1))
plot(c(1:100), c(1:100), type="n", xlab="Human Age", ylab="Human Age")
abline(0, 1, col="blue", lwd = 3)
abline(lm0, col="red", lwd=2)
abline(v = myAge, col = "black", lwd=1)
abline(h = pet[pet$ageRange == myAge,][2], col = "black", lwd=1)

#dogAgeCoef <- 
#catAgeCoef <- 
  

#http://www.calculatorcat.com/cats/cat-years.phtml
#http://pets.webmd.com/dogs/how-to-calculate-your-dogs-age