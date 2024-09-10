ui <- dashboardPage(
  
  # ----- Dashboard Header -----
  dashboardHeader(
    title = h3(
      strong("WorldfootballR Data Downloader"),
      align = "center")
    ),
  
  # ----- Dashboard Sidebar -----
  dashboardSidebar(
    width = 400,
    sidebarMenu(
      id = "sidebarMenu",
                
      # Menu item for FBref Stats
      menuItem(
        "FBref Data",
        tabName = "fbref", 
        icon = icon("dungeon", lib = "font-awesome"),
        style = "font-size: 800px;",
        selected = TRUE,
        # Menu item for FBref Player Stats
        menuSubItem(
          "Player Stats",
          tabName = "fbref_player",
          icon = icon("chess-knight", lib = "font-awesome")
        ),
        # Menu item for FBref Team Match Results
        menuSubItem(
          "Team Match Results",
          tabName = "fbref_matches",
          icon = icon("chess-board", lib = "font-awesome")
        )
      ),
      
      
      menuItem(
        "Transfermarkt Data",
        tabName = "transfermarkt", 
        icon = icon("grain", lib = "glyphicon"),
        selected = TRUE,
        menuSubItem(
          "Player Stats",
          tabName = "transfermarkt_player",
          icon = icon("chess-knight", lib = "font-awesome")
        ),
        menuSubItem(
          "Team Match Results",
          tabName = "transfermarkt_matches",
          icon = icon("chess-board", lib = "font-awesome")
          )
      ),
      
      menuItem(
        "Understat Data",
        tabName = "understat", 
        icon = icon("snowflake", lib = "font-awesome"),
        selected = TRUE,
        menuSubItem(
          "Player Stats", 
          tabName = "understat_player",
          icon = icon("chess-knight", lib = "font-awesome")
        ),
        menuSubItem(
          "Team Match Results",
          tabName = "understat_matches",
          icon = icon("chess-board", lib = "font-awesome")
        )
      ),
      
      menuItem(
        "Extra Data",
        tabName = "extra", 
        icon = icon("dragon", lib = "font-awesome"),
        selected = TRUE,
        menuSubItem(
          "International Matches",
          tabName = "international",
          icon = icon("jedi", lib = "font-awesome")
        ),
        menuSubItem(
          "Preloaded Data",
          tabName = "preloaded",
          icon = icon("shield-halved", lib = "font-awesome")
        )
      ),
      
      menuItem(
        "Creator",
        tabName = "creator",
        icon = icon("hat-wizard", lib = "font-awesome")
      )
      
    )
  ),
  
  # ----- Dashboard Body -----
  dashboardBody(
    
    # Custom CSS
    includeCSS("themes/mytheme.css"),
    
    tabItems(
      
      # Tab for Fbref Player Stats
      tabItem(
        tabName = "fbref_player",
        
        tabBox(id = "tabset1", width = 12,
          tabPanel(
            "Player Data", 
            fluidRow(
              box(
                title = "Player Stats Input", 
                width = 5, 
                status = "primary",
                solidHeader = TRUE,
                textInput(
                  "player_url", 
                  "Player URL",
                  value = "https://fbref.com/en/jugadores/36a3ff67/Marco-Reus"
                ),
                selectInput(
                  "stat_type",
                  "Statistic Type",
                  choices = c(
                    "standard", "shooting", "passing", "passing_types", 
                    "gca", "defense", "possession", "playing_time", 
                    "misc", "keeper", "keeper_adv"
                  ), 
                  selected = 'standard'
                ),
                actionButton(
                  "download_player_stats",
                  "Download Player Stats", 
                  icon = icon("cloud-download")
                )
              )
            ),
            fluidRow(
              box(
                title = "Player Stats Output Table", 
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                DT::dataTableOutput("player_stats_table"),
                downloadButton(
                  "download_player_csv",
                  "Download as CSV",
                  icon = icon("file-csv", lib = "font-awesome")
                ),
                downloadButton(
                  "download_player_xlsx",
                  "Download as XLSX",
                  icon = icon("file-excel", lib = "font-awesome")
                )
              )
            )
          ),
          tabPanel(
            "Summary",
            fluidRow(
              box(
                title = "Player Stats Output Summary", 
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                verbatimTextOutput("skim_player_stats_table")
              )
            )
          )
        )
        
      ),
      
      # Tab for Fbref Team Match Results
      tabItem(
        tabName = "fbref_matches",
        
        tabBox(
          id = "tabset1", width = 12,
          tabPanel(
                 "Matches Data",
                 fluidRow(
                   box(
                     title = "Team Match Results Input",
                     width = 5, status = "primary",
                     solidHeader = TRUE,
                     # Input to select country
                     selectInput(
                        "fbref_country",
                        "Select Country",
                        choices = c(
                          "England" = "ENG",
                          "Italy" = "ITA", 
                          "Spain" = "ESP", 
                          "Germany" = "GER", 
                          "France" = "FRA"
                        ),
                        selected = "ENG" # , multiple = TRUE
                      ),
                      
                      # Input to select gender
                      selectInput(
                        "fbref_gender",
                        "Select Gender",
                        choices = c(
                          "Men's" = "M", 
                          "Women's" = "F"
                          ),
                        selected = "M"
                      ),
                      # Input to select the season
                      selectInput(
                        "fbref_season_end_year",
                        "Select Season(s)",
                        choices = c(
                          2012, 2013, 2014, 2015, 2016, 2017,
                          2018, 2019, 2020, 2021, 2022, 2023
                          ),
                        selected = 2022 # , multiple = TRUE
                      ),
                      
                      # Input to select division 
                      selectInput(
                        "fbref_tier",
                        "Select Division",
                        choices = c("1st", "2nd", "3rd", "4th"),
                        selected = "1st"
                      ),
                      actionButton(
                        "fbref_download_team_results", 
                        "Download Team Results", 
                        icon = icon("fire-flame-curved")
                      )
                    )
                ),
                fluidRow(
                  box(
                    title = "Team Match Results Output",
                    width = 12,
                    status = "primary",
                    solidHeader = TRUE,
                    DT::dataTableOutput("fbref_team_results_table"),
                    downloadButton(
                      "fbref_download_team_csv",
                      "Download as CSV", 
                      icon = icon("file-csv")
                    ),
                    downloadButton(
                      "fbref_download_team_xlsx",
                      "Download as XLSX",
                      icon = icon("file-excel", lib = "font-awesome")
                    )
                  )
                )
              ),
          
        tabPanel(
          "Summary",
          fluidRow(
            box(
              title = "Player Stats Output Summary", 
              width = 12,
              status = "primary",
              solidHeader = TRUE,
              verbatimTextOutput("skim_matches_stats_table")
              )
            )
          )
        )
      ),
      
      
      
      # Tab for Transfermarkt Player Stats
      tabItem(
        tabName = "transfermarkt_player",
        
        tabBox(id = "tabset1_tf", width = 12,
               tabPanel(
                 "Player Data", 
                 fluidRow(
                   box(
                     title = "Player Bios Input", 
                     width = 5, 
                     status = "primary",
                     solidHeader = TRUE,
                     textInput(
                       "player_url_transfermarkt", 
                       "Player URL",
                       value = "https://www.transfermarkt.es/marco-reus/profil/spieler/35207"
                     ),
                     actionButton(
                       "download_player_bios_transfermarkt",
                       "Download Player Bios", 
                       icon = icon("cloud-download")
                     )
                   )
                 ),
                 fluidRow(
                   uiOutput("player_info")
                 )
               )
               # , tabPanel(
               #   "Summary",
               #   fluidRow(
               #     box(
               #       title = "Player Stats Output Summary", 
               #       width = 12,
               #       status = "primary",
               #       solidHeader = TRUE,
               #       verbatimTextOutput("skim_player_stats_table")
               #     )
               #   )
               # )
        )
        
      ),
      

      # CREATOR
      tabItem(
        tabName = "creator",
        fluidRow(
          # Primera fila para la descripción del creador
          box(
            title = "About the Creator",
            width = 12,
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            p("I am [Creator's Name], a software developer with experience in creating Shiny applications, data analysis, and R package development.")
          )
        ),
        
        fluidRow(
          # Segunda fila para enlaces a redes sociales
          box(
            title = "Connect Links",
            width = 12,
            status = "danger",
            solidHeader = TRUE,
            collapsible = TRUE,
            p(tags$a(href = "https://twitter.com/angnar7", target = "_blank", 
                     icon("twitter"), " Twitter")),
            p(tags$a(href = "https://www.linkedin.com/in/tu_usuario", target = "_blank", 
                     icon("linkedin"), " LinkedIn")),
            p(tags$a(href = "https://github.com/tu_usuario", target = "_blank", 
                     icon("github"), " GitHub"))
          )
        )
      )
    )
  )
)