pkgs <- c("dplyr", "tidyr", "magrittr", "purrr", "here", "readr", "skimr", "tidytext", "data.table")
for (i in pkgs) {
    if (!i %in% rownames(installed.packages())) {
        install.packages(i)
        library(i, character.only = TRUE)
    } else {
        (library(i, character.only = TRUE))
    }
}

participant_info <- read_csv(here::here("data", "study_three", "participant_info.csv")) %>%
    mutate(
        gender = fifelse(
            gender == "Non binary",
            "Non-binary",
            gender
        )
    )

participant_info %>% skim()

participant_info %>%
    group_by(gender) %>%
    skim()






# Coding free response questions

performance_regex <- paste0(
    "performance|speed|accuracy",
    "|efficiency|effectiveness",
    "|control|precision",
    "|skill|expertise",
    "|motor learning|practice",
    "|better|faster|easier|more accurate",
    "|metrics|goal(?:-|\\s)oriented",
    "|target(?:-|\\s)directed",
    "|execution|timing|coordination",
    "|quality|optimization|learning curve|task difficulty",
    "|improv(?:e|ing|ement).*perform",
    "|perform.*improv(?:e|ing|ement)",
    "|learning(?:-|\\s)curve|task difficulty"
)

tool_embodiment_regex <- paste0(
    "(?:tool|grabber).*(?:became|feel|felt|sense|thought|part).*(?:body|arm)",
    "|(?:incorporat|merg|extend).*(?:body|arm|tool|grabber).*(?:tool|grabber|body|arm)",
    "|(?:tool|grabber|body|arm).*(?:regard|merge|connect|change|incorporate|blurred|extended).*(?:body|arm|tool|grabber)",
    "|(?:body|arm|tool).*(?:became|feel|felt|sense|thought|part).*(?:tool|body)",
    "|(?:body|arm|perception|tool).*(?:merge|connect|change|incorporate|blurred|exten(?:sion|ded)).*(tool|body|arm)",
    "|longer.*tool",
    "|tool.*longer"
)

avatar_embodiment_regex <- paste0(
    "(?:virtual body|avatar).*(?:became|feel|felt|sense|thought|part).*(?:body|arm|avatar|virtual body)",
    "|(?:incorporat|merg|extend).*(?:virtual body|body|arm|avatar).*(?:virtual body|body|arm|avatar)",
    "|(?:body|arm|avatar|avatar arm|virtual body).*(?:merge|connect|incorporate|blurred|extended).*(?:body|avatar arm|arm|avatar|virtual body)",
    "|(?:body|arm|avatar|avatar arm|virtual body).*(?:became|feel|felt|sense|thought|part).*(?:body|avatar arm|arm|avatar|virtual body)",
    "|(?:body|arm|avatar|avatar arm|virtual body).*(?:merge|connect|change|incorporate|blurred|exten(?:sion|ded)).*(?:body|avatar arm|arm|avatar|virtual body)",
    "|(?:avatar|virtual body|virtual arm|avatar arm|arm|body).*(?:one|was|perc(?:eived|eption)).*(?:avatar|virtual body|virtual arm|avatar arm|arm|body)",
    "|(?:avatar|virtual body|virtual arm|avatar arm|arm|body).*(?:avatar|virtual body|virtual arm|avatar arm|arm|body).*(?:one|same|merged|blurred|connected|extended|incorporated|changed|became|felt|thought|sense|part)",
    "|(?:virtual|physical).*(?:physical|virtual)"
)

tracking_accuracy_regex <- paste0(
    "calibra(?:te|tion|ting|tor|tions)",
    "|track(er|ing|ed|ers)",
    "|alignment",
    "|visual feedback|tracking",
    "|movement tracking",
    "|accuracy*.equipment",
    "|accura(?:te|cy|tely)*.(?:depi(?:ct|ction)|representation|feedback)"
)

hypothesis_guess_1_words <- participant_info %>%
    dplyr::select(ppid, hypothesis_guess_1) %>%
    mutate(
        performance = grepl(
            performance_regex, 
            hypothesis_guess_1, 
            ignore.case = TRUE),
        tool_embodiment = grepl(
            tool_embodiment_regex, 
            hypothesis_guess_1, 
            ignore.case = TRUE),
        avatar_embodiment = grepl(
            avatar_embodiment_regex, 
            hypothesis_guess_1, 
            ignore.case = TRUE),
        tracking_accuracy = grepl(
            tracking_accuracy_regex,
            hypothesis_guess_1,
            ignore.case = TRUE
        )
         ) %>%
  group_by(ppid) %>%
  summarize(
    time = "Pre",
    performance_count = sum(performance),
    tool_embodiment_count = sum(tool_embodiment),
    avatar_embodiment_count = sum(avatar_embodiment),
    tracking_accuracy_count = sum(tracking_accuracy)
  )
hypothesis_guess_2_words <- participant_info %>%
    dplyr::select(ppid, hypothesis_guess_2) %>%
    mutate(
        performance = grepl(
            performance_regex, 
            hypothesis_guess_2, 
            ignore.case = TRUE),
        tool_embodiment = grepl(
            tool_embodiment_regex, 
            hypothesis_guess_2, 
            ignore.case = TRUE),
        avatar_embodiment = grepl(
            avatar_embodiment_regex, 
            hypothesis_guess_2, 
            ignore.case = TRUE),
        tracking_accuracy = grepl(
            tracking_accuracy_regex,
            hypothesis_guess_2,
            ignore.case = TRUE
        )
         )%>%
  group_by(ppid) %>%
  summarize(
    time = "Pre",
    performance_count = sum(performance),
    tool_embodiment_count = sum(tool_embodiment),
    avatar_embodiment_count = sum(avatar_embodiment),
    tracking_accuracy_count = sum(tracking_accuracy)
  )
hypothesis_guess_3_words <- participant_info %>%
    dplyr::select(ppid, hypothesis_guess_1_post) %>%
        mutate(
        performance = grepl(
            performance_regex, 
            hypothesis_guess_1_post, 
            ignore.case = TRUE),
        tool_embodiment = grepl(
            tool_embodiment_regex, 
            hypothesis_guess_1_post, 
            ignore.case = TRUE),
        avatar_embodiment = grepl(
            avatar_embodiment_regex, 
            hypothesis_guess_1_post, 
            ignore.case = TRUE),
        tracking_accuracy = grepl(
            tracking_accuracy_regex,
            hypothesis_guess_1_post,
            ignore.case = TRUE
        )
         ) %>%
  group_by(ppid) %>%
      summarize(
          time = "Post",
          performance_count = sum(performance),
          tool_embodiment_count = sum(tool_embodiment),
          avatar_embodiment_count = sum(avatar_embodiment),
          tracking_accuracy_count = sum(tracking_accuracy)
      )

hypothesis_guess_4_words <- participant_info %>%
    dplyr::select(ppid, hypothesis_guess_2_post) %>%
    mutate(
        performance = grepl(
            performance_regex,
            hypothesis_guess_2_post,
            ignore.case = TRUE),
        tool_embodiment = grepl(
            tool_embodiment_regex,
            hypothesis_guess_2_post,
            ignore.case = TRUE),
        avatar_embodiment = grepl(
            avatar_embodiment_regex,
            hypothesis_guess_2_post,
            ignore.case = TRUE),
        tracking_accuracy = grepl(
            tracking_accuracy_regex,
            hypothesis_guess_2_post,
            ignore.case = TRUE
        )
    ) %>%
  group_by(ppid) %>%
      summarize(
            time = "Post",
          performance_count = sum(performance),
          tool_embodiment_count = sum(tool_embodiment),
    avatar_embodiment_count = sum(avatar_embodiment),
    tracking_accuracy_count = sum(tracking_accuracy)
      )
  
combined_hypothesis_guess_words_pre <- bind_rows(
    hypothesis_guess_1_words,
    hypothesis_guess_2_words) %>%
    group_by(ppid, time) %>%
    summarize(
        performance_count = sum(performance_count),
        tool_embodiment_count = sum(tool_embodiment_count),
        avatar_embodiment_count = sum(avatar_embodiment_count),
        tracking_accuracy_count = sum(tracking_accuracy_count)
    )
combined_hypothesis_guess_words_post <- bind_rows(
    hypothesis_guess_3_words,
    hypothesis_guess_4_words) %>%
    group_by(ppid, time) %>%
    summarize(
        performance_count = sum(performance_count),
        tool_embodiment_count = sum(tool_embodiment_count),
        avatar_embodiment_count = sum(avatar_embodiment_count),
        tracking_accuracy_count = sum(tracking_accuracy_count)
    )

embodiment_after_inventory <- combined_hypothesis_guess_words %>%
    mutate(
        performance_hypothesis = performance_count > 0,
        tool_embodiment_hypothesis = tool_embodiment_count > 0,
        avatar_embodiment_hypothesis = avatar_embodiment_count > 0,
        tracking_accuracy_hypothesis = tracking_accuracy_count > 0
    ) %>%
    group_by(time) %>%
        summarize(
            num_performance_hypothesis = sum(performance_hypothesis),
            num_tool_embodiment_hypothesis = sum(tool_embodiment_hypothesis),
            num_avatar_embodiment_hypothesis = sum(avatar_embodiment_hypothesis),
            num_tracking_accuracy_hypothesis = sum(tracking_accuracy_hypothesis)
        )
    

participant_hypotheses <- combined_hypothesis_guess_words %>%
    dplyr::filter(time == "Pre") %>%
    group_by(ppid) %>%
    summarize(
        performance_hypothesis = sum(performance_count)>0,
        tool_embodiment_hypothesis = sum(tool_embodiment_count)>0,
        avatar_embodiment_hypothesis = sum(avatar_embodiment_count)>0,
        tracking_accuracy_hypothesis = sum(tracking_accuracy_count)>0
    )

fatigue_regex <- paste0(
    "fatig(?:ue|ued|ues|uing)",
    "|grip strength",
    "|strain(?:ed|ing)",
    "|tir(?:ed|ing|edness|esome)?",
    "|tax(?:ing|ed)?",
    "|sore",
    "|exhaust(?:ed|ion)",
    "|(?:hurt|shaking)"
)

fatigue_freeresponse <- participant_info %>%
    dplyr::select(ppid, challenge) %>%
    mutate(
        fatigue_yn = grepl(
            fatigue_regex, 
            challenge, 
            ignore.case = TRUE)
    ) %>%
    group_by(ppid) %>%
        summarize(
            fatigue_yn = sum(fatigue_yn) > 0
        )
    
avatar_embodiment <- participant_info %>%
    mutate(
        dplyr::across(
            avatar_embodiment_1:avatar_embodiment_16,
            ~ ifelse(.x < 0, NA, .x)
        )
    )

# Impute missing values
avatar_embodiment_inventory <- avatar_embodiment %>%
    filter(ppid != "d3-007") %>% # did not complete the survey
    group_by(ppid) %>%
    summarize(
        appearance_subscale = mean(
            c(
                avatar_embodiment_1,
                avatar_embodiment_2,
                avatar_embodiment_3,
                avatar_embodiment_4,
                avatar_embodiment_5,
                avatar_embodiment_6,
                avatar_embodiment_9,
                avatar_embodiment_16
            ),
            na.rm = TRUE
        ),
        response_subscale = mean(
            c(
                avatar_embodiment_4,
                avatar_embodiment_6,
                avatar_embodiment_7,
                avatar_embodiment_8,
                avatar_embodiment_9,
                avatar_embodiment_15
            ),
            na.rm = TRUE
        ),
        ownership_subscale = mean(
            c(
                avatar_embodiment_5,
                avatar_embodiment_10,
                avatar_embodiment_11,
                avatar_embodiment_12,
                avatar_embodiment_13,
                avatar_embodiment_14
            ),
            na.rm = TRUE
        ),
        multisensory_subscale = mean(
            c(
                avatar_embodiment_3,
                avatar_embodiment_12,
                avatar_embodiment_13,
                avatar_embodiment_14,
                avatar_embodiment_15,
                avatar_embodiment_16
            ),
            na.rm = TRUE
        ),
        avatar_embodiment_total = mean(
            appearance_subscale,
            response_subscale,
            ownership_subscale,
            multisensory_subscale
        )
    )

tool_embodiment <- participant_info %>%
    mutate(
        dplyr::across(
            tool_embodiment_1:tool_embodiment_11,
            ~ ifelse(.x < 0, NA, .x)
        )
    )

# Tool Embodiment Inventory
# Adapted from Avatar Embodiment Inventory
# avatar_embodiment_2 -> tool_embodiment_1
# avatar_embodiment_5 -> tool_embodiment_2
# avatar_embodiment_7 -> tool_embodiment_3
# avatar_embodiment_16 -> tool_embodiment_4
# avatar_embodiment_8 -> tool_embodiment_5
# avatar_embodiment_10 -> tool_embodiment_6
# avatar_embodiment_12 -> tool_embodiment_7
# avatar_embodiment_13 -> tool_embodiment_8
# avatar_embodiment_14 -> tool_embodiment_9
# avatar_embodiment_15 -> tool_embodiment_10
# avatar_embodiment_16 -> tool_embodiment_11

# For now, just use the mean of the items

tool_embodiment_inventory <- tool_embodiment %>%
    dplyr::filter(ppid != "d3-007") %>% # did not complete the survey
    group_by(ppid) %>%
    summarize(
        tool_embodiment = mean(
            c(
                tool_embodiment_1,
                tool_embodiment_2,
                tool_embodiment_3,
                tool_embodiment_4,
                tool_embodiment_5,
                tool_embodiment_6,
                tool_embodiment_7,
                tool_embodiment_8,
                tool_embodiment_9,
                tool_embodiment_10,
                tool_embodiment_11
            ),
            na.rm = TRUE
        )
    )




participant_info <- participant_info %>%
    left_join(participant_hypotheses, by = "ppid") %>%
    left_join(fatigue_freeresponse, by = "ppid") %>%
    left_join(avatar_embodiment_inventory, by = "ppid") %>%
    left_join(tool_embodiment_inventory, by = "ppid")

fwrite(
    participant_info,
    here::here("data", "3_avatartooluse", "participant_info_coded.csv")
)
