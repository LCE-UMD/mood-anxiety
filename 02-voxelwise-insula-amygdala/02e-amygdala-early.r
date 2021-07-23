library(brms)
library(dplyr)
library(parallel)
library(cmdstanr)

set_cmdstan_path("/home/songtao/.cmdstanr/cmdstan-2.26.1")

project <- "amygdala_early"

df <- read.table('data/threat_v_safe_insula_amygdala_agg_diff.txt', header = TRUE, sep = ",")

df <- df %>% filter(Phase == "early", Mask == "amygdala")

df$Subj <- factor(df$Subj)
df$Hem <- factor(df$Hem)
df$ROI <- factor(df$ROI)
df$VOX <- factor(df$VOX)

print(paste0('Number of ROIs: ',nlevels(df$ROI)))
print(paste0('Number of voxels: ',nlevels(df$VOX)))
print(paste0('Number of subjects: ',nlevels(df$Subj)))
print(paste0('Length of dataset: ', dim(df)[1]))

# filter data as early response only and select used columns
dataTable <- df %>% select(Subj, Hem, ROI, VOX, diff)

dataTable %>% head()

# Number of iterations for the MCMC sampling
iterations <- 30000
# Number of chains to run
chains <- 4
SCALE <- 1
ns <- iterations*chains/2

# number of sigfigs to show on the table
nfigs <- 4

# Set nuber of cores to use. 
# To run each chain on a single core, set number of core to 4
print(getOption("mc.cores"))
options(mc.cores = parallel::detectCores())
print(getOption("mc.cores"))

# Set the Bayesian model
mod <- '1'
modelForm <- paste0('diff ~ ', mod, ' + (1 | gr(Subj, dist = "student")) + (',
                    mod, ' | gr(Hem, dist = "student")) + (',
                    mod, ' | gr(ROI, dist = "student")) + (',
                    mod, ' | gr(VOX, dist = "student"))')

priorRBA <- get_prior(formula = modelForm, data = dataTable, family = "student")
# You can assign prior or your choice to any of the parameter in the table below. 
# For example. If you want to assign a student_t(3,0,2.5) prior to all parameters of class b, 
# the following line does that for you. Parameters in class b are the population effects (STATE and TRAIT)

priorRBA$prior[1:4] <- "gamma(3.325, 0.5)"
priorRBA$prior[6] <- "gamma(3.325, 0.5)"

print(priorRBA)

# Create a result directory
file_path <- paste0("results_offset/", project)
if (!dir.exists(file_path)){dir.create(file_path)}

# Generate the Stan code for our own reference
stan_code <- make_stancode(modelForm, data = dataTable,chains = chains, family = 'student', prior = priorRBA)
cat(stan_code, file = paste0(file_path, "/", project, "_only_stancode.stan"), sep='\n')

# Following run the BML model
# The number in threading() means the cores used for with-in chain parallelization,
# for example, here threading(12) means for each chain, there are 12 cores used.
# Thus, 12*4=48 cores were used for BML; you can change it according to your own computation power.
fm <- brm(modelForm,
          data = dataTable,
          chains = chains,
          family = 'student',
          prior = priorRBA,
          inits = 0, iter = iterations, warmup = 20000,
          control = list(adapt_delta = 0.99, max_treedepth = 15), 
          backend = 'cmdstanr',
          threads = threading(12))

# Save the results as a RData file
save.image(file = paste0(file_path, "/", project, ".RData"))

# Shows the summary of the model
cat(capture.output(summary(fm)), sep = '\n', append = TRUE)