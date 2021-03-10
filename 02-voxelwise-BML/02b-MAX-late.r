library(brms)
library(dplyr)
library(parallel)

df <- read.table('data/threat_v_safe_insula_min_shifted_agg.txt',header = TRUE,sep = ",")
# Filter out 'early' data
df <-filter(df,Phase=='late',HEM=='left')

# Number of iterations for the MCMC sampling
iterations <- 20000
# Number of chains to run
chains <- 4
SCALE <- 1
ns <- iterations*chains/2

# For analysis only following columns are needed: Subj, ROI, beta, se, TRAIT and STATE. 
# So just select those columns and creata a new dataframe called dataTable
dataTable <- select(df,Subj,ROI,VOX,beta,cond)

# Redefine grouping variables (Subj and ROI) as factors 
dataTable$Subj <- factor(dataTable$Subj)
dataTable$ROI <- factor(dataTable$ROI)
dataTable$VOX <- factor(dataTable$VOX)

print(paste0('Number of VOXs: ',nlevels(dataTable$VOX)))
print(paste0('Number of ROIs: ',nlevels(dataTable$ROI)))
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

mod = '1 + cond'
modelForm = paste('beta ~ ',mod,' + (',mod,' | gr(Subj, dist= "student")) + (',mod,' | gr(ROI , dist="student")) + (',mod,'| gr(VOX, dist="student"))')


priorRBA <- get_prior(formula = modelForm,data=dataTable,family = 'student')
# You can assign prior or your choice to any of the parameter in the table below. 
# For example. If you want to assign a student_t(3,0,10) prior to all parameters of class b, 
# the following line does that for you. Parameters in class b are the population effects (cond, STATE and TRAIT)
priorRBA$prior[1] <- "student_t(3,0,10)"
priorRBA$prior[3] <- "lkj(2)"
priorRBA$prior[7:9] <- "gamma(3.325,0.1)"
priorRBA$prior[10] <- "student_t(3,0,10)"
priorRBA$prior[11] <- "gamma(3.325,0.1)"
priorRBA$prior[12] <- "student_t(3,0,10)"
priorRBA$prior[22] <- "student_t(3,0,10)"
# Print the table with priors
print(priorRBA)

# Create a result directory
if (!dir.exists("results_offset")){dir.create("results_offset")}

# Generate the Stan code for our own reference
stan_code <- make_stancode(modelForm,data=dataTable,chains = chains,family = 'student',prior = priorRBA)
cat(stan_code,file = "results_offset/left_insula_late_stancode.stan",sep='\n')

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
save.image(file="results_offset/left_insula_late.RData")
