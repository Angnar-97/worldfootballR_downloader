server <- function(input, output, session) {
  
  # -------- FB REF ---------------
  
  # Reactive expression to store player stats data
  player_stats_data <- eventReactive(input$download_player_stats, {
    cat("Button was pressed. Starting to fetch data...\n")
    isolate({
      # Validate if the URL provided is valid
      valid_url <- tryCatch({
        httr::GET(input$player_url)
        TRUE  # If the URL is valid
      }, error = function(e) {
        FALSE  # If error occurs, the URL is invalid
      })
      
      if (!valid_url) {
        shinyalert(
          title = "Invalid URL",
          text = "The provided URL is not valid. Please check the URL and try again.",
          type = "error"
        )
        return(NULL)
      }
      
      worldfootballR::fb_player_season_stats(
        player_url = input$player_url,
        stat_type = input$stat_type
      )
    })
  })
  
  # Render the player stats data table
  output$player_stats_table <- renderDT({
    req(player_stats_data())
    datatable(player_stats_data(), options = list(scrollX = TRUE))
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
  
  # Generate skimr summary and return it as a table
  output$skim_player_stats_table <- renderPrint({
    data <- player_stats_data()
    if (!is.null(data)) {
      skimr::skim(data)
    } else {
      "No data available."
    }
  })
    
    
    
  # Reactive expression to store team match results data
  team_results_data <- eventReactive(input$fbref_download_team_results, {
    cat("Button was pressed. Starting to fetch data...\n")
    isolate({
      tryCatch({
        results <- fb_match_results(
          country = input$fbref_country, 
          season_end_year = as.numeric(input$fbref_season_end_year),  
          gender = input$fbref_gender, 
          tier = input$fbref_tier
        )
        print(results)
        
        if (is.null(results) || nrow(results) == 0) {
          shinyalert(
            title = "No Results Found",
            text = "The function did not return any match results. Please check your inputs and try again",
            type = "warning"
          )
          return(NULL)
        }
        
        return(results)
        
      }, error = function(e) {
        shinyalert(
          title = "Error",
          text = paste("An error occurred while fetching the match results:", e$message),
          type = "error"
        )
        return(NULL)
      })
    })
  })
  
  # Render the team match results table
  output$fbref_team_results_table <- renderDT({
    req(team_results_data())
    if (is.null(data)) {
      print("No data to render in fbref_team_results_table")
      return(NULL)
    }
    datatable(team_results_data(), options = list(scrollX = TRUE))
  })
  
  # Allow users to download team match results data as CSV
  output$fbref_download_team_csv <- downloadHandler(
    filename = function() {
      paste("team_results_", formatted_date, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(team_results_data(), file, row.names = FALSE)
    }
  )
  
  # Allow users to download team match results data as XLSX
  output$fbref_download_team_xlsx <- downloadHandler(
    filename = function() {
      paste("team_results_", formatted_date, ".xlsx", sep = "")
    },
    content = function(file) {
      write.xlsx(team_results_data(), file, row.names = FALSE)
    }
  )
  
  # Generate skimr summary and return it as a table
  output$skim_matches_stats_table <- renderPrint({
    data <- team_results_data()
    if (!is.null(data)) {
      skimr::skim(data)
    } else {
      "No data available."
    }
  })
  
  # -------- TRANSFERMARKT ---------------
  
  # Reactive expression to store player stats data
  player_bios_transfermarkt <- eventReactive(input$download_player_bios_transfermarkt, {
    cat("Button was pressed. Starting to fetch data...\n")
    isolate({
      # Validate if the URL provided is valid
      valid_url <- tryCatch({
        httr::GET(input$player_url_transfermarkt)
        TRUE  # If the URL is valid
      }, error = function(e) {
        FALSE  # If error occurs, the URL is invalid
      })
      
      if (!valid_url) {
        shinyalert(
          title = "Invalid URL",
          text = "The provided URL is not valid. Please check the URL and try again.",
          type = "error"
        )
        return(NULL)
      }
      
      worldfootballR::tm_player_bio(
        player_url = input$player_url_transfermarkt
      )
    })
  })
  
  output$player_info <- renderUI({
    # Verificar si player_bios_transfermarkt() devuelve NULL
    if (!is.null(player_bios_transfermarkt())) {
      fluidRow(
        box(
          title = "Player Bios Information", 
          width = 12, 
          status = "danger", 
          solidHeader = TRUE,
          column(4, p(strong("Nombre del Jugador: "), player_bios_transfermarkt()$player_name)),
          column(4, p(strong("Fecha de Nacimiento y Edad: "), player_bios_transfermarkt()$f_nacim_edad)),
          column(4, p(strong("Lugar de Nacimiento: "), player_bios_transfermarkt()$lugar_de_nac)),
          column(4, p(strong("Altura: "), player_bios_transfermarkt()$altura)),
          column(4, p(strong("Nacionalidad: "), player_bios_transfermarkt()$nacionalidad)),
          column(4, p(strong("Posición: "), player_bios_transfermarkt()$posicion)),
          column(4, p(strong("Pie Dominante: "), player_bios_transfermarkt()$pie)),
          column(4, p(strong("Agente: "), player_bios_transfermarkt()$agente)),
          column(4, p(strong("Club Actual: "), player_bios_transfermarkt()$club_actual)),
          column(4, p(strong("Fichado: "), player_bios_transfermarkt()$fichado)),
          column(4, p(strong("Proveedor: "), player_bios_transfermarkt()$proveedor)),
          column(4, p(strong("Twitter: "), a(href = player_bios_transfermarkt()$twitter, "Twitter"))),
          column(4, p(strong("Facebook: "), a(href = player_bios_transfermarkt()$facebook, "Facebook"))),
          column(4, p(strong("Instagram: "), a(href = player_bios_transfermarkt()$instagram, "Instagram"))),
          column(4, p(strong("Página Web Oficial: "), a(href = player_bios_transfermarkt()$pagina_web_oficial, "Web Oficial"))),
          column(4, p(strong("Valoración del Jugador: "), player_bios_transfermarkt()$player_valuation)),
          column(4, p(strong("Máxima Valoración del Jugador: "), player_bios_transfermarkt()$max_player_valuation)),
          column(4, p(strong("Fecha Máxima Valoración: "), player_bios_transfermarkt()$max_player_valuation_date)),
          downloadButton(
            "download_player_bios_csv_transfermarkt",
            "Download as CSV",
            icon = icon("file-csv", lib = "font-awesome")
          ),
          downloadButton(
            "download_player_bios_xlsx_transfermarkt",
            "Download as XLSX",
            icon = icon("file-excel", lib = "font-awesome")
          )
        )
      )
    } else {
      fluidRow(
        column(12, p("Información del jugador no disponible."))
      )
    }
  })
  
  
  # Render the player stats data table
  output$player_bios_table_transfermarkt <- renderDT({
    req(player_bios_transfermarkt())
    datatable(player_bios_transfermarkt(), options = list(scrollX = TRUE))
  })
  
  # Allow users to download player stats data as CSV
  output$download_player_bios_csv_transfermarkt <- downloadHandler(
    filename = function() {
      paste("player_bios_", formatted_date, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(player_bios_transfermarkt(), file, row.names = FALSE)
    }
  )
  
  # Allow users to download player stats data as XLSX
  output$download_player_bios_xlsx_transfermarkt <- downloadHandler(
    filename = function() {
      paste("player_bios_", formatted_date, ".xlsx", sep = "")
    },
    content = function(file) {
      write.xlsx(player_bios_transfermarkt(), file, row.names = FALSE)
    }
  )
  
  
}