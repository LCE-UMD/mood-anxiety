# BML: Threat vs. Safe (70 ROIs)

## Data
```
    |-- data
        |-- MAX_neutral_early_late_offset_agg.txt           <- Data table for BML analysis
    |-- 00-ROI-info.ipynb                                   <- Information, visualization of the 70 ROIs
    |-- 01-preproc.ipynb                                    <- Extraction, visualization of min. shifted 
                                                                response estimates for the 70 ROIs. 
                                                                It creates the data table used in BML 
                                                                analysis (check data/README.md)
    |-- 02a-MAX-early.r                                     <- BML analysis script for early phase.
                                                                (input: data/MAX_neutral_early_late_offset_agg.txt)
    |-- 02b-MAX-late.r                                      <- BML analysis script for late phase
                                                                (input: data/MAX_neutral_early_late_offset_agg.txt)
    |-- 03a-MAX-early_results.ipynb                         <- Plots posteriors for early phase. Also 
                                                                exports posteriors to .txt file (check results/)
    |-- 03b-MAX-late_results.ipynb                          <- Plots posteriors for late phase. Also 
                                                                exports posteriors to .txt file (check results/)
    |-- 04-rendering                                        <- Renders P+ values to standard brain surface.
                                                                Requires ROI mask
```

The 70 ROI mask: `/data/bswift-1/Pessoa_Lab/MAX/ROI_masks/MAX_ROIs_final_gm_70.nii.gz`