library(brms)
library(dplyr)
library(parallel)
library(psych)
library(cmdstanr)
#install_cmdstan(cores = 2)

set_cmdstan_path("/home/climbach/.cmdstanr/cmdstan-2.24.1")

log = 'results/MAX_threat_v_safe_L_BST_FC_log.txt'
if (!dir.exists("results")){dir.create("results")}
cat("Created results/",file = log, sep='\n', append=FALSE)

# load the dataset
dataset <- read.csv("data/MAX_threat_v_safe_L_BST_FC.txt", header = TRUE)
cat(paste('Total number of rows before filtering: ',nrow(dataset)), file = log, sep = '\n', append=TRUE)
cat("Filtering out rows that have r = 1",file = log, sep = '\n', append=TRUE)

# Transform r to z
#dataset <- filter(dataset,spearmanr!=1.0)
dataset <- filter(dataset,Subj!="MAX116")
cat(paste('Total number of rows after filtering: ',nrow(dataset)),file = log, sep = '\n', append=TRUE)
dataset$r_z <- apply(dataset['spearmanr'],1,fisherz)
cat(paste("Min r: ",min(dataset$spearmanr)),file = log, sep = '\n', append=TRUE)
cat(paste("Max r: ",max(dataset$spearmanr)),file = log, sep = '\n', append=TRUE)

head(dataset)

# Convert ROI and Subj columns into factors
dataset$ROI <- factor(dataset$ROI)
dataset$Subj <- factor(dataset$Subj)

# Print number of levels in each grouping variable
cat(paste("Number of Subjects: ",nlevels(dataset$Subj)),file = log, sep = '\n', append=TRUE)
cat(paste("Number of ROIs: ",nlevels(dataset$ROI)),file = log, sep = '\n', append=TRUE)
# Print number of cores allocated
cat(paste0('Number of cores available: ', detectCores(all.tests = FALSE, logical = TRUE)),file = log, sep = '\n', append=TRUE)

# Set nuber of cores to use. 
# To run each chain on a single core, set number of core to 4
#cat(getOption("mc.cores"),file = log, sep = '\n', append=TRUE)
options(mc.cores = parallel::detectCores())
cat(paste0('Number of cores allocated ',getOption("mc.cores")),file = log, sep = '\n', append=TRUE)

# Number of iterations for the MCMC sampling
iterations <- 10000
# Number of chains to run
chains <- 4
SCALE <- 1
ns <- iterations*chains/2
# number of sigfigs to show on the table
nfigs <- 4

mod = '1 + cond'
modelForm = paste('r_z ~', mod,'+ (',mod,' | gr(Subj, dist= "student")) + (',mod,'| gr(ROI, dist="student"))')
cat('Model Formula:',file = log, sep = '\n', append=TRUE)
cat(modelForm,file = log, sep = '\n', append=TRUE)

# get dafualt priors for data and model
priorRBA <- get_prior(formula = modelForm,data=dataset,family = 'student')
# You can assign prior or your choice to any of the parameter in the table below. 
# For example. If you want to assign a student_t(3,0,10) prior to all parameters of class b, 
# the following line does that for you. Parameters in class b are the population effects (cond, STATE and TRAIT)
priorRBA$prior[1] <- "student_t(3, 0, 10)"
priorRBA$prior[3] <- "lkj(2)"
priorRBA$prior[6:7] <- "gamma(3.325,0.1)"
priorRBA$prior[8] <- "student_t(3, 0, 10)"
priorRBA$prior[9] <- "gamma(3.325,0.1)"
priorRBA$prior[10] <- "student_t(3, 0, 10)"
# Print the table with priors
print(priorRBA)

# Generate the Stan code for our own reference
stan_code <- make_stancode(modelForm,data=dataset,chains = chains,family = 'student',prior = priorRBA)
cat(stan_code,file = "results/MAX_threat_v_safe_L_BST_FC_stancode.stan",sep='\n')

# Following run the BML model
fm <- brm(modelForm,
          data=dataset,
          chains = chains,
          cores = 8,
          family = 'student',
          prior = priorRBA,
          inits=0, iter=iterations, 
          backend = "cmdstanr",
          threads = threading(2),
          control = list(adapt_delta = 0.99, max_treedepth = 15))

# Shows the summary of the model
cat(capture.output(summary(fm)),sep = '\n', append=TRUE)

# Save the results as a RData file
save.image(file="results/MAX_threat_v_safe_L_BST_FC.RData")
