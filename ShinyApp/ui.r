shinyUI(pageWithSidebar(
  headerPanel("Cat / Dog Human Age Calculator & Visual Representer"),
  sidebarPanel(
    numericInput('HumanAge', 'Enter your current age:', 30, min = 1, max = 100, step = 1),
    numericInput('AgeHumanAcquired', 'How old were you when you acquired your pet?', 18, min = 0, max = 100, step = 1),
    numericInput('PetAge', 'How old (in years) was your pet when acquired?', 0.5, min = 0, max = 100, step = 1),
    radioButtons('PetType', 'Please select the type of pet you own(ed):',
                  list('Cat' = 'cat',
                      'Small Dog' = 'smallDog',
                      'Medium-sized Dog' = 'mediumDog',
                      'Large Dog' = 'largeDog')),
    actionButton("update", "Update Age Calculation")
  ),
  mainPanel(
    p('Your pet\'s age in human years:'),
    textOutput('PetAgeHumanYears'),
    p('And here\'s how your pet\'s age relate to yours:'),
    plotOutput('AgePlot')
  )
))