# Mood-Anxiety (MAX)

In the MAX experiment participants were presented with two conditions: threat and safe. Each condition was presented as a block of length 16.25 seoncds. Evolution of the response during presentation of the two conditions was estimated by specifying an estimation window from the onset of the block until 20 seconds after. Estimation window is kept a little longer (20s) than the block length (which is 16.25s) to observe decay in the response.

## Data
__Raw fMRI data:__ `/data/bswift-1/Pessoa_Lab/MAX/dataset/raw/MAX???`  
__Preprocessed fMRI data:__
- All runs
    - smooth: `/data/bswift-1/Pessoa_Lab/MAX/dataset/preproc/MAX???/func2/ICA_AROMA/MAX???_EP_Main_TR_MNI_2mm_SI_denoised.nii.gz`
    - unsmooth: `/data/bswift-1/Pessoa_Lab/NAX/dataset/preproc/MAX???/func2/ICA_AROMA/MAX???_EP_Main_TR_MNI_2mm_I_denoised.nii.gz`
- Neutral runs
    - smooth: `/data/bswift-1/Pessoa_Lab/MAX/dataset/preproc/MAX???/func_neutral/MAX???_EP_Main_TR_MNI_2mm_SI_denoised.nii.gz`
    - unsmooth: `/data/bswift-1/Pessoa_Lab/MAX/dataset/preproc/MAX???/func_neutral/MAX???_EP_Main_TR_MNI_2mm_I_denoised.nii.gz`
- Positive runs
    - smooth: `/data/bswift-1/Pessoa_Lab/MAX/dataset/preproc/MAX???/func_positive/MAX???_EP_Main_TR_MNI_2mm_SI_denoised.nii.gz`
    - unsmooth: `/data/bswift-1/Pessoa_Lab/MAX/dataset/preproc/MAX???/func_positive/MAX???_EP_Main_TR_MNI_2mm_I_denoised.nii.gz`
 
Note: smooth data for voxelwise analysis; unsmooth data for ROI analysis.

__Behavioral data path:__ `/data/bswift-1/Pessoa_Lab/MAX/dataset/behavioral/`
- State and trait anxiety scores: `STAI_sums`

## Scripts
__Preprocessing:__ `/data/bswift-1/Pessoa_Lab/MAX/scripts/all_preproc.sh`  
__To create neutral runs dataset:__ `/data/bswift-1/Pessoa_Lab/MAX/scripts/neutral_runs.sh`  
__To create positive runs dataset:__ `/data/bswift-1/Pessoa_Lab/MAX/scripts/positive_runs.sh`  

__First level analysis:__ 
- Voxelwise analysis
    - All runs
       - Assumed shape: `/data/bswift-1/Pessoa_Lab/MAX/scripts/voxelwise_analysis/MAX_fMRI_Analysis_all_MR.sh`
    - Neutral runs
       - Assumed shape: `/data/bswift-1/Pessoa_Lab/MAX/scripts/voxelwise_analysis/MAX_fMRI_Analysis_neutral_MR.sh`
       - Unassumed shape: `/data/bswift-1/Pessoa_Lab/MAX/scripts/voxelwise_analysis/MAX_fMRI_Analysis_neutral_deconv.sh`
- ROI analysis
    - Neutral runs
       - Unassumed shape: `/data/bswift-1/Pessoa_Lab/MAX/scripts/ROI_analysis/MAX_fMRI_Analysis_neutral_deconv.sh`
       - Individually modulated: `/data/bswift-1/Pessoa_Lab/MAX/scripts/ROI_analysis/MAX_fMRI_Analysis_neutral_deconLSS.sh`
- Positive analysis
    - Unassumed shape: `/data/bswift-1/Pessoa_Lab/MAX/scripts/ROI_analysis/MAX_fMRI_Analysis_positive_deconv.sh`
  
__First level estimate extraction:__  
Voxelwise response estimates for threat and safe blocks, produced by first level analysis, can be extracted using the following script: `/data/bswift-1/Pessoa_Lab/MAX/scripts/voxelwise_analysis/MAX_3dcalc_minShifting_ThreatvsSafe.sh`. This script also shifts the response such that minimum response is 0.


__Motion check:__
- Python notebook that identifies runs with high motion: `/data/bswift-1/Pessoa_Lab/MAX/scripts/FD_motion_check.ipynb`  
    It creates a list (`runs_to_exclude.txt`) of runs with high motion
- Script to remove bad runs from the processed data: `/data/bswift-1/Pessoa_Lab/MAX/scripts/exclude_runs.sh`

__Notebook to check correlation and VIFs:__ `/data/bswift-1/Pessoa_Lab/MAX/scripts/correlation_VIF.ipynb`

## Stimulus timing files
- All runs: `/data/bswift-1/Pessoa_Lab/MAX/stim_times/`
- Neutral runs: `/data/bswift-1/Pessoa_Lab/MAX/stim_times_neutral/`
- Positive runs: `/data/bswift-1/Pessoa_Lab/MAX/stim_times_positive/`

## BML Analysis
Refer to the current repo: https://github.com/LCE-UMD/mood-anxiety

[01-final_gm_85](https://github.com/LCE-UMD/mood-anxiety/tree/main/01-final_gm_85): BML analysis on response estimates from ROI analysis  
[02-voxelwise-insula-amygdala](https://github.com/LCE-UMD/mood-anxiety/tree/main/02-voxelwise-insula-amygdala): BML analysis on response estimates from voxelwise analysis  
