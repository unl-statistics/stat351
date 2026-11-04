#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(plotly)
library(tidyverse)

shades <- seq(0, 255, by = 10)

rgb_df <- data.frame(expand.grid(r = shades, g = shades, b = shades)) |>
  mutate(hex = rgb(r, g, b, maxColorValue = 255))
hcl <- farver::decode_colour(rgb_df$hex, to ="hcl")

rgb_plus <- data.frame(rgb_df, hcl)


# Define UI for application that draws a histogram
ui <- page_fluid(

    # Application title
    titlePanel("Visualizing the xkcd Color Survey"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(

        sidebarPanel(
          input_dark_mode(id = "mode"),
          HTML(text="Hello World, this is completely unremarkable text to explain some of the functionality.<br><br>"),
          sliderInput(
            "range", "Range of hue",
            min = 0, max = 360,
            value = c(35, 65)
          )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("chromaPlot"),
           plotOutput("mountainPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$chromaPlot <- renderPlot({
      rgb_plus |> filter(h >= input$range[1], h <= input$range[2]) |>
        ggplot(aes(x = c, y = l)) + geom_point(aes(colour=hex), size = 2) +
        scale_color_identity() + coord_equal() + theme_bw()
    })
    output$mountainPlot <- renderPlot({
      rgb_plus |> #filter(h >= input$range[1], h <= input$range[2]) |>
        ggplot(aes(x = h, y = c)) +
        annotate(geom="rect", xmin = input$range[1], xmax = input$range[2],
                 ymin = -Inf, ymax = Inf, fill = "grey40", alpha = 0.5) +
        geom_point(aes(colour=hex)) +
        scale_color_identity()+ theme_bw()
    })
}

# Run the application
shinyApp(ui = ui, server = server)
