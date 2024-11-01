# setup.R

sidebar_content <-
  list(
    selectInput("industries",
                "Select industries",
                choices = industries,
                selected = "",
                multiple  = TRUE),
    selectInput("propensities",
                "Select propensities to buy",
                choices = propensities,
                selected = "",
                multiple  = TRUE),
    selectInput("contracts",
                "Select contract types",
                choices = contracts,
                selected = "",
                multiple  = TRUE),
    "This app compares the effectiveness of two types of free trials at converting users into customers, A (30-days) and B (100-days)."
  )