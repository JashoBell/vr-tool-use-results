# Martel et al. (2019) data available at
# Martel et al. (2021) data available at https://osf.io/3g9mz/

################# Import data
################# Martel et al. (2019): Turn to long-form for analysis, plotting

s <-  read_csv("path/to/Martel2019.csv") %>%
  mutate(SUBJECTS = ifelse(GROUP == 2, SUBJECTS + 22, SUBJECTS)) %>%
  mutate(SUBJECTS = factor(SUBJECTS, levels = c(1:41)),
         GROUP = factor(GROUP, levels = c(1:2), labels = c("Front", "Side"))) %>%
  pivot_longer(!c(SUBJECTS, GROUP, ARMLENGTH, FOREARMLENGTH), 
               names_to = c("Kinematic", "Time"), 
               names_pattern = "(^[[:upper:]]+)(PRE$|POST$)",
               values_to = "Outcome") %>%
  mutate(Time = factor(Time, levels = c("PRE", "POST")))
write_csv(s, "martel_long.csv")

#Second format, more appropriate to replicate the MANOVA-esque permutation analysis
#Reread for analyses
s_2 <- read_csv("path/to/Martel2019.csv") %>%
  #Subject and Group as factors. Add 22 to subject numbers in group 2 to prevent analyses from thinking both sets are the same participant.
  mutate(SUBJECTS = ifelse(GROUP == 2, SUBJECTS + 22, SUBJECTS)) %>%
  mutate(SUBJECTS = factor(SUBJECTS, levels = c(1:41)),
         GROUP = factor(GROUP, levels = c(1:2), labels = c("Front", "Side"))) %>%
  #Pivot data to analysis-friendly form (I am bad at this, yes)
  pivot_longer(!c(SUBJECTS, GROUP, ARMLENGTH, FOREARMLENGTH), 
               names_to = c("Kinematic", "Time"), 
               names_pattern = "(^[[:upper:]]+)(PRE$|POST$)",
               values_to = "Outcome") %>%
  pivot_wider(names_from = "Kinematic", values_from = "Outcome")
write_csv(s_2, "martel_manova_long.csv")
##############Martel et al. (2021)
#Martel 2021: Replace empties, NA and NC with actual NA values to fill in later.
d <- read_csv("path/to/Martel2021.csv", 
              na = c("", "NA", "NC"),
              col_types = "cfcnnnnnnnnnnnnnnniffinn") %>%
  # Blocks missing values in pre- and post-test. Replace those with session so imputation works, turn into factor ordered sensibly.
  mutate(block = ifelse(is.na(block), session, block)) %>%
  mutate(block = factor(block, levels = c("PRE", "1-FIRST", "2-SECOND", "3-THIRD", "4-LAST", "POST")))



# Determine number of missing measurements for each kinematic outcome.
d %>%
  filter(AGE >= 18) %>%
  select(block, TPACC:MT) %>%
  group_by(block) %>%
  skimr::skim() %>%
  select(1:4)


#Filter by subject, "order" session sensibly and ensure subject-specific Arm Length is present in all rows for analysis.
d_18up <- d %>%
  filter(AGE >= 18) %>%
  mutate(session = factor(session, levels = c("PRE", "TOOL", "POST"), ordered = FALSE)) %>%
  mutate(trials_reaching = as.numeric(trials_reaching)) %>%
  impute_median(ArmLength+ForearmLength~subjects) 


################ There are subjects with dropped trials. identify to shift trial numbers down accordingly.
pretrialshift <- d_18up %>% filter(trials_reaching == 19, block == "PRE") 
pretrialmissing <- d_18up %>% filter(subjects %in% pretrialshift$subjects, block == "PRE")%>% select(subjects, trials_reaching)
misstrialpre = list()
for(i in pretrialmissing$subjects)
{
  misstrialpre[i] = data.frame(pretrialmissing = (1:18)[!(1:18) %in% filter(pretrialmissing, subjects %in% i)$trials_reaching])
}
#s16 & s35 missing trial 2, s21 & 28 missing trial 1

posttrialshift <- d_18up %>% filter(trials_reaching == 19, block == "POST") %>% select(subjects, trials_reaching)


tooltrialsshift <- d_18up %>% filter(trials_reaching == 49) %>% select(subjects)
# tool trials complicated: Number not always first. 
missingtrials <- d_18up %>% filter(subjects %in% tooltrialsshift$subjects, 
                                   block %in% c("1-FIRST", "2-SECOND", "3-THIRD", "4-LAST")) %>% select(subjects, trials_reaching)

misstrialstool = list()
for(i in missingtrials$subjects)
{
  misstrialstool[i] = data.frame(missingtrials = (1:48)[!(1:48) %in% filter(missingtrials, subjects %in% i)$trials_reaching])
}
misstrialstool

# Shift pre-test values
d_18upfix <- d_18up
for(i in names(misstrialpre)){
  d_18upfix <- d_18upfix %>% mutate(trials_reaching =
                                      if_else(subjects %in% i & block %in% "PRE" & trials_reaching > max(misstrialpre[i][[1]]),
                                              trials_reaching - 1,
                                              trials_reaching))
}


# Check pre-test again:
pretrialmissing <- d_18upfix %>% filter(subjects %in% pretrialshift$subjects, block == "PRE")%>% select(subjects, trials_reaching)
misstrialpre = list()
for(i in pretrialmissing$subjects)
{
  misstrialpre[i] = data.frame(pretrialmissing = (1:18)[!(1:18) %in% filter(pretrialmissing, subjects %in% i)$trials_reaching])
}
misstrialpre

#Shift tool-use values
for(i in names(misstrialstool)){
  d_18upfix<- d_18upfix %>% mutate(trials_reaching =
                                     if_else(subjects %in% i & block %in% c("1-FIRST", "2-SECOND", "3-THIRD", "4-LAST") & trials_reaching > max(misstrialstool[i][[1]]),
                                             trials_reaching - 1,
                                             trials_reaching))
}

tooltrialsshift <- d_18up %>% filter(trials_reaching == 49) %>% select(subjects)
missingtrials <- d_18upfix %>% filter(subjects %in% tooltrialsshift$subjects, 
                                      block %in% c("1-FIRST", "2-SECOND", "3-THIRD", "4-LAST")) %>% select(subjects, trials_reaching)
misstrialstool = list()
for(i in missingtrials$subjects)
{
  misstrialstool[i] = data.frame(missingtrials = (1:48)[!(1:48) %in% filter(missingtrials, subjects %in% i)$trials_reaching])
}
misstrialstool
# Manually do last fix
d_18upfix<- d_18upfix %>% mutate(trials_reaching =
                                   if_else(subjects %in% "s25" & block %in%c("1-FIRST", "2-SECOND", "3-THIRD", "4-LAST") & trials_reaching > 13,
                                           trials_reaching - 1,
                                           trials_reaching))


# Shift post-test values
d_18upfix<- d_18upfix %>% mutate(trials_reaching =
                                   if_else(subjects %in% "s21" & block %in%c("POST") & trials_reaching > 1,
                                           trials_reaching - 1,
                                           trials_reaching))


# Participant s58 is missing a trial with no replacement. Can't impute scores for this missing row.

#Factorize subjects with new sample subset acting as levels (imputation method doesn't accept full sample)
d_18upfix <- mutate(d_18upfix, subjects = factor(d_18upfix$subjects),
                    block = factor(block, levels = c("PRE", "1-FIRST", "2-SECOND", "3-THIRD", "4-LAST", "POST")),
                    session = factor(session, levels = c("PRE", "TOOL", "POST"), ordered = FALSE))


########Impute missing data with a random forest imputation. Leverage multiple cores if available. Martel et al. (2021) mean impute.
if(parallel::detectCores() > 2){
  nc <- parallel::detectCores()
  cl <- parallel::makeCluster(rep("localhost", nc))
  doParallel::registerDoParallel(cores = parallel::detectCores())}
set.seed(1337)
d_18upmfimpute <-missForest(as.data.frame(d_18upfix), parallelize = "forests")$ximp

parallel::stopCluster(cl)