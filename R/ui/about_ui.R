about_panel_ui <- function(){
  nav_panel(
    title="About", value="About", uiOutput("2D_GAIM_IG_version"),
    card(
    p("The SOCR AI Image Generator uses existing ",
      a("SOCR/DSPA computational libraries",
        href = "https://dspa2.predictive.space/", target = "_blank"),
      " and Generative artificial intelligence models (GAIMs), such as ",
      a("OpenAI's", href = "https://openai.com/", target = "_blank"),
      " powerful ",
      # language_model,
      "language model, ",
      " to translate natural language (human text/audio commands) to 
                     synthetically generate R code, draft text, simulate 2D images,
                     as well as, model, visualize, and analyze data.",
      "You can request specific types of data analysis, or
                     use thematic text prompts to generate synthetic images or text.",
      "Upload a data file (CSV, TSV/tab-delimited text files, and Excel) 
                     and just analyze it using plain human commands.
                     The results can be quickly downloaded as Rmd source-code or HTML reports."
    ),
    p("Some of the synthetic image generation GAIMs are free-of-charge, and some
                      require users to input their private KEYs (in \"SETTINGS\") for external generative AI model (GAIM)
                      services, such as OpenAI, PaLM, etc. Without importing their private keys
                      these functions will not work, although the remaining SOCR image-genetaiton functions
                      will be fully operational even without AI service keys."),
    p("The SOCR Synth Image Generator comes with absolutely NO WARRANTY! Some scripts may yield incorrect results.
                      Please use the auto-generated code as a starting 
                      point for further refinement and validation.
                      The SOCR website and the 
                      source code (extending DSPA, OpenAI API, RTutor, and other CRAN libraries) 
                      is CC BY-NC 3.0 licensed and freely available for academic and 
                      non-profit organizations only. 
                      For commercial use beyond testing please contact ",
      a("statistics@umich.edu.", 
        href = "mailto:statistics@umich.edu?Subject=SOCR 2D GAIM Image Generator")
    ),
    
    hr(),
    p("The SOCR 2D Image Generating GAIM is trained and the app developed by the ",
      a("SOCR Team", href = "https://socr.umich.edu/people/",
        target = "_blank"),
      " using existing open-science community-supported resources. 
                     All user feedback is valuable, please contact us via ",
      a("SOCR Contact.", target = "_blank", 
        href = "http://www.socr.umich.edu/html/SOCR_Contact.html"),
      "The SOCR Image Generator source code is available at ",
      a("GitHub, ", href = "https://github.com/SOCR"),
      a(" RTutor ", target = "_blank",
        href = "https://github.com/gexijin/RTutor"), " and ",
      a("CRAN.", href = "https://cran.r-project.org/", target="_blank")
    ),
    
    bslib::accordion(
      # open = c("Bill Length", "About","jhk"),
      bslib::accordion_panel(
        "Frequently Asked Questions",
        tags$ul(
          tags$li(HTML(paste("<b>What is the ",
                             tags$a(href="https://rcompute.nursing.umich.edu/SOCR_AI_Bot/",
                                    "SOCR 2D Image Generator"), "?</b>", "<br /> &emsp;",
                             "A generative artificial intelligence model (GAIM) built as an
                                            RShiny app with human-machine interactions, data-interrogation,
                                            modeling and analytics.",
                             sep = ""))),
          tags$li(HTML(paste("<b>How does the 2D Synth Image Generator work?</b>", "<br /> &emsp;",
                             "User requests are sent to SOCR RShiny server, which includes
                                  a pre-trained GAIM that is invoked to simulate 2D images.
                                  Multiple requests are logged to produce (on-demand) an R Markdown file, which can be
                                  knitted into an HTML report. This enables record keeping, scientific
                                  reproducibility, and independent validation.",
                             sep = ""))),
          tags$li(HTML(paste("<b>Can people without R coding experience use SOCR App?</b>",
                             "<br /> &emsp;",
                             "Some prior coding experience may be helpful, but
                                            no prior generative-AI or foundational large language model
                                            experience is required.",
                             sep = ""))),
          tags$li(HTML(paste("<b>Who is this App for?</b>",
                             "<br /> &emsp;",
                             "The primary goal is to help learners understand
                                            the utility of GAIMs and to supply free and accessible
                                            data generator for training prospective large-scale AI models.",
                             sep = ""))),
          tags$li(HTML(paste("<b>How do you make sure the results are correct?</b>",
                             "<br /> &emsp;",
                             "All generated images are non-human data. These
                                            images provide human-guided approximate representations
                                            of normal and pathological medical images.",
                             sep = ""))),
          tags$li(HTML(paste("<b>Can for-profit organizations and private companies use SOCR GAIM Image Generator?</b>",
                             "<br /> &emsp;",
                             "No. It can be tried as a demo. the SOCR Apps, website,
                                            and source code are freely available for non-profit organizations
                                            only and distributed using the CC NC 3.0 license.",
                             sep = ""))),
          tags$li(HTML(paste("<b>Can you run the GAIM App locally?</b>",
                             "<br /> &emsp;",
                             "Yes, download the R code and run the RShiny app locally.
                                            You will not need to obtain any API keys.",
                             sep = ""))),
          tags$li(HTML(paste("<b>Why do I get different results with the same request?</b>",
                             "<br /> &emsp;",
                             "Just like two human experts often generate different predictions,
                                    AI systems generate stochastic results with natural variability,
                                    the extent of the variation is controlled by hyper-parameters,
                                    e.g.,  \"temperature\" defined in the \"Settings\".",
                             sep = ""))),
          tags$li(HTML(paste("<b>Are there costs associated with this SOCR App use?</b>",
                             "<br /> &emsp;",
                             "No! This service is free!",
                             sep = ""))),
          tags$li(HTML(paste("<b>Can AI replace human experts?</b>",
                             "<br /> &emsp;",
                             "No. This GAIM intends to complement experts and optimize efficiency. ",
                             sep = ""))),
          tags$li(HTML(paste("<b>How to write effectively AI prompts to solicit rational generative responses?</b>",
                             "<br /> &emsp;",
                             "Write brief, concise, informative, and to the point queries.",
                             sep = ""))),
          tags$li(HTML(paste("<b>Is there a limit on the max size of the GAIM data-generation requests?</b>",
                             "<br /> &emsp;",
                             "Yes, limit all data generation requests to 10 each minute.
                                            Otherwise, the app may lock you out. ",
                             sep = ""))),
          tags$li(HTML(paste("<b>Wht to do ehne encountering errors, busy server notices, or unresponsive website reports?</b>",
                             "<br /> &emsp;",
                             "Try starting the AI Image Generator in a new browser window or restart the
                                            entire browser. Periodically, the app is updated!",
                             sep = "")))
        ),
        
      ),
      bslib::accordion_panel(
        "Update_log",
        tags$ul(
          tags$li("V1.6 6/10/2024. 3D volume generator models added"),
          tags$li("V1.4 4/30/2024. User Interface updates"),
          tags$li("V1.3 4/28/2024. New conditional models added"),
          tags$li("V1.2 3/26/2024. simplified installation process, using python virtual env instead of  anaconda"),
          tags$li("V1.1 3/16/2024. updated help-functionality and about-tab"),
          tags$li("V1.0 3/15/2024. initial deployment")
        )
      ),
      bslib::accordion_panel(
        "Session_info",
        tags$ul(
          tags$li(uiOutput("session_info"))
        )
      )
    ),
    
    
  )
  )
}