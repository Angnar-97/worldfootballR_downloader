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
          "International Matches - World Cup",
          tabName = "international_wc",
          icon = icon("jedi", lib = "font-awesome")
        ),
        menuSubItem(
          "International Matches - Euro",
          tabName = "international_euro",
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
      
      # ------- TAB FBREF -------
      
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
          id = "tabset2", width = 12,
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
      
      
      # ------- TAB TRANSFERMARKT -------
      
      # Tab for Transfermarkt Player Stats
      tabItem(
        tabName = "transfermarkt_player",
        
        tabBox(id = "tabset3", width = 12,
               tabPanel(
                 "Player Bios", 
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
               ),
               # tabPanel(
               #   "Player Injury History", 
               #   fluidRow(
               #     box(
               #       title = "Player Injury History", 
               #       width = 5, 
               #       status = "primary",
               #       solidHeader = TRUE,
               #       textInput(
               #         "player_url_inj_transfermarkt", 
               #         "Player URL",
               #         value = "https://www.transfermarkt.es/marco-reus/profil/spieler/35207"
               #       ),
               #       actionButton(
               #         "download_player_inj_transfermarkt",
               #         "Download Player Injury History", 
               #         icon = icon("cloud-download")
               #       )
               #     )
               #   ),
               #   fluidRow(
               #     uiOutput("player_inj")
               #   )
               # )
        )
        
      ),
      
      # Tab for Transfermarkt Player Matches
      tabItem(
        tabName = "transfermarkt_matches", 
        fluidRow(
          box(
            title = "Team Match Results Input",
            width = 6,
            status = "primary",
            solidHeader = TRUE,
            # Input to select country
            selectInput(
              "transfermarkt_country",
              "Select Country",
              choices = c(
                "England",
                "Italy", 
                "Spain", 
                "Germany", 
                "France"
              ),
              selected = "England"
            ),
            # Input to select the season
            selectInput(
              "transfermarkt_season_end_year",
              "Select Season",
              choices = c(
                2012, 2013, 2014, 2015, 2016, 2017,
                2018, 2019, 2020, 2021, 2022, 2023,
                2024
              ),
              selected = 2022 
            ),
            selectInput(
              "transfermarkt_week",
              "Select Matchweek number(s)",
              choices = c(
                1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
                20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,
                36,37,38
              ),
              selected = 1, multiple = TRUE 
            ),
            actionButton(
              "download_matchday_transfermarkt", 
              "Download Team Results", 
              icon = icon("fire-flame-curved")
            )
          )
        ),
        fluidRow(
          box(
            title = "Match-Day Results Output",
            width = 12, status = "danger",
            solidHeader = TRUE,
            DT::dataTableOutput("transfermarkt_matchday_results_table"),
            downloadButton(
              "transfermarkt_download_team_csv",
              "Download as CSV", 
              icon = icon("file-csv")
            ),
            downloadButton(
              "transfermarkt_download_team_xlsx",
              "Download as XLSX",
              icon = icon("file-excel", lib = "font-awesome")
            )
          )
        )
      ),
      
      # ------ TAB UNDERSTAT -------
      
      # Tab for Understat Squad Stats
      tabItem(
        tabName = "understat_player",
        tabBox(
          id = "tabset4", width = 12,
          tabPanel(
            "Squad Data", 
            fluidRow(
              box(
                title = "Squad Stats Input", 
                width = 5, 
                status = "primary",
                solidHeader = TRUE,
                textInput(
                  "squad_undertsat_url", 
                  "Squad URL",
                  value = "https://understat.com/team/Borussia_Dortmund/2014"
                ),
                actionButton(
                  "download_squad_undertsat_stats",
                  "Download Squad Stats", 
                  icon = icon("cloud-download")
                )
              )
            ),
            fluidRow(
              box(
                title = "Squad Output Table", 
                width = 12,
                status = "info",
                solidHeader = TRUE,
                DT::dataTableOutput("squad_undertsat_table"),
                downloadButton(
                  "download_squad_undertsat_csv",
                  "Download as CSV",
                  icon = icon("file-csv", lib = "font-awesome")
                ),
                downloadButton(
                  "download_squad_undertsat_xlsx",
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
                title = "Player Squad Output Summary", 
                width = 12,
                status = "primary",
                solidHeader = TRUE,
                verbatimTextOutput("skim_squad_understat_table")
              )
            )
          )
        )
      ),
      
      
      # Tab for Understat Matches Results
      tabItem(
        tabName = "understat_matches", 
        fluidRow(
          box(
            title = "Team Match Results Input",
            width = 4, 
            status = "primary",
            solidHeader = TRUE,
            selectInput(
              "understat_country",
              "Select Country",
              choices = c(
                "England" = "EPL",
                "Italy" = "Serie A", 
                "Spain" = "La liga", 
                "Germany" = "Bundesliga", 
                "France" = "Ligue 1",
                "Russia" = "RFPL"
              ),
              selected = "England" # , multiple = TRUE
            ),
            # Input to select the season
            selectInput(
              "understat_season_start_year",
              "Select Season",
              choices = c(
                2012, 2013, 2014, 2015, 2016, 2017,
                2018, 2019, 2020, 2021, 2022, 2023,
                2024
              ),
              selected = 2022 
            ),
            actionButton(
              "download_understat_team_results", 
              "Download Team Results", 
              icon = icon("fire-flame-curved")
            )
          )
        ),
        fluidRow(
          box(
            title = "Team Match Results Output",
            width = 12, 
            status = "info",
            solidHeader = TRUE,
            DT::dataTableOutput("understat_team_results_table"),
            downloadButton(
              "download_understat_team_csv",
              "Download as CSV", 
              icon = icon("file-csv")
            ),
            downloadButton(
              "download_understat_team_xlsx",
              "Download as XLSX",
              icon = icon("file-excel", lib = "font-awesome")
            )
          )
        )
      ),
      
      
      
      # Tab for International World Cup Matches Results
      tabItem(
        tabName = "international_wc", 
        fluidRow(
          box(
            title = "World Cup Input",
            width = 4, 
            status = "primary",
            solidHeader = TRUE,
            # Input to select the season
            selectInput(
              "wc_year",
              "Select World Cup Year",
              choices = c(
                2022, 2018, 2014, 2010, 2006, 2002, 1998, 1994, 1990, 1986, 
                1982, 1978, 1974, 1970, 1966, 1962, 1958, 1954, 1950, 1938, 
                1934, 1930
              ),
              selected = 2010 
            ),
            actionButton(
              "download_wc_results", 
              "Download World Cup Results", 
              icon = icon("fire-flame-curved")
            )
          )
        ),
        fluidRow(
          box(
            title = "World Cup Results Output",
            width = 12, 
            status = "success",
            solidHeader = TRUE,
            DT::dataTableOutput("wc_results_table"),
            downloadButton(
              "download_wc_csv",
              "Download as CSV", 
              icon = icon("file-csv")
            ),
            downloadButton(
              "download_wc_xlsx",
              "Download as XLSX",
              icon = icon("file-excel", lib = "font-awesome")
            )
          )
        )
      ),
      
      # Tab for International World Cup Matches Results
      tabItem(
        tabName = "international_euro", 
        fluidRow(
          box(
            title = "World Cup Input",
            width = 4, 
            status = "primary",
            solidHeader = TRUE,
            # Input to select the season
            selectInput(
              "euro_year",
              "Select Euro Year",
              choices = c(
                2024, 2020, 2016, 2012, 2008, 2004, 2000
              ),
              selected = 2008 
            ),
            actionButton(
              "download_euro_results", 
              "Download Euro Results", 
              icon = icon("fire-flame-curved")
            )
          )
        ),
        fluidRow(
          box(
            title = "Euro Results Output",
            width = 12, 
            status = "success",
            solidHeader = TRUE,
            DT::dataTableOutput("euro_results_table"),
            downloadButton(
              "download_euro_csv",
              "Download as CSV", 
              icon = icon("file-csv")
            ),
            downloadButton(
              "download_euro_xlsx",
              "Download as XLSX",
              icon = icon("file-excel", lib = "font-awesome")
            )
          )
        )
      ),
      

      # ------- TAB CREATOR -------
      tabItem(
        tabName = "creator",
        fluidRow(
          # First row for the creator's description
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
          # Second row for links to social networks
          box(
            title = "Connect Links",
            width = 12,
            status = "danger",
            solidHeader = TRUE,
            collapsible = TRUE,
            p(
              tags$a(
                href = "https://twitter.com/angnar7", 
                icon("twitter"), " Twitter"
                )
              ),
            p(
              tags$a(
                href = "https://www.linkedin.com/in/alexngs1997", 
                icon("linkedin"), " LinkedIn"
                )
            ),
            p(
              tags$a(
              href = "https://github.com/Weimar45", 
              icon("github"), " GitHub"
              )
            )
          )
        )
      )
    )
  )
)