server <- function(input, output, session) {
  
  # Reactive expression to store player stats data
  player_stats_data <- reactive({
    req(input$download_player_stats)
    isolate({ 
      worldfootballR::fb_player_season_stats(
        player_url = input$player_url,
        stat_type = input$stat_type
          )
      # fb_player_stats(input$player_league, input$player_season)
    })
  })
  
  # Reactive expression to store team match results data
  team_results_data <- reactive({
    req(input$download_team_results)
    isolate({
      fb_team_match_results(input$team_league, input$team_season)
    })
  })
  
  # Render the player stats data table
  output$player_stats_table <- renderDT({
    req(player_stats_data())
    datatable(player_stats_data(), options = list(scrollX = TRUE))
  })
  
  # Render the team match results data table
  output$team_results_table <- renderDT({
    req(team_results_data())
    datatable(team_results_data(), options = list(scrollX = TRUE))
  })
  
  # Allow users to download player stats data as CSV
  output$download_player_csv <- downloadHandler(
    filename = function() {
      paste("player_stats_", formatted_date, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(player_stats_data(), file, row.names = FALSE)
    }
  )
  
  # Allow users to download player stats data as XLSX
  output$download_player_xlsx <- downloadHandler(
    filename = function() {
      paste("player_stats_", formatted_date, ".xlsx", sep = "")
    },
    content = function(file) {
      write.xlsx(player_stats_data(), file, row.names = FALSE)
    }
  )
  
  
  # Allow users to download team match results data as CSV
  output$download_team_csv <- downloadHandler(
    filename = function() {
      paste("team_results_", formatted_date, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(team_results_data(), file, row.names = FALSE)
    }
  )
}