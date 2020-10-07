library(brms)
library(dplyr)
library(parallel)

df <- read.table('data/MAX_neutral_early_late_offset.txt',header = TRUE,sep = ",")
# Filter out 'early' data
df <-filter(df,Phase=='late')
# Create a new column se (standard error) by taking square root of var
df$se = sqrt(df$var)

# Number of iterations for the MCMC sampling
iterations <- 20000
# Number of chains to run
chains <- 4
SCALE <- 1
ns <- iterations*chains/2

# For analysis only following columns are needed: Subj, ROI, beta, se, TRAIT and STATE. 
# So just select those columns and creata a new dataframe called dataTable
dataTable <- select(df,Subj,ROI,beta,se,cond,TRAIT,STATE)

# Redefine grouping variables (Subj and ROI) as factors 
dataTable$Subj <- factor(dataTable$Subj)
dataTable$ROI <- factor(dataTable$ROI)

# number of ROIs
nR <- nlevels(dataTable$ROI)

print(paste0('Number of ROIs: ',nR))
print(paste0('Number of subjects: ',nlevels(dataTable$Subj)))
print(paste0('Number of cores available: ', detectCores(all.tests = FALSE, logical = TRUE)))

# number of sigfigs to show on the table
nfigs <- 4

head(dataTable)

# Set nuber of cores to use. 
# To run each chain on a single core, set number of core to 4
print(getOption("mc.cores"))
options(mc.cores = parallel::detectCores())
print(getOption("mc.cores"))

mod = '1 + cond + STATE + TRAIT'
modelForm = paste('beta | se(se) ~',
                  mod,'+ (1 + cond | gr(Subj, dist= "student")) +   
                         (',mod,'| gr(ROI, dist="student"))')
priorRBA <- get_prior(formula = modelForm,data=dataTable,family = 'student')
# You can assign prior or your choice to any of the parameter in the table below. 
# For example. If you want to assign a student_t(3,0,10) prior to all parameters of class b, 
# the following line does that for you. Parameters in class b are the population effects (cond, STATE and TRAIT)
priorRBA$prior[1] <- "student_t(3,0,10)"
priorRBA$prior[5] <- "lkj(2)"
priorRBA$prior[8:9] <- "gamma(3.325,0.1)"
priorRBA$prior[11] <- "gamma(3.325,0.1)"

# Print the table with priors
print(priorRBA)

# Create a result directory
if (!dir.exists("results_offset")){dir.create("results_offset")}

# Generate the Stan code for our own reference
stan_code <- make_stancode(modelForm,data=dataTable,chains = chains,family = 'student',prior = priorRBA)
cat(stan_code,file = "results_offset/late_stancode.stan",sep='\n')

# Following run the BML model
fm <- brm(modelForm,
          data=dataTable,
          chains = chains,
          family = 'student',
          prior = priorRBA,
          inits=0, iter=iterations, 
          control = list(adapt_delta = 0.99, max_treedepth = 15))

# Shows the summary of the model
cat(capture.output(summary(fm)),sep = '\n', append=TRUE)

# Save the results as a RData file
save.image(file="results_offset/late.RData")
