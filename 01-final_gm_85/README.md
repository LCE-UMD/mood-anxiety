# BML: Threat vs. Safe (85 ROIs)

## Data
```
    |-- data
        |-- neutral_runs_conditionLevel_FNSandFNT
            | -- MAX???.txt                                 <- Beta weigths of FNS and FNT from first level 
                                                                analysis for each subject
        |-- MAX_neutral_offset_agg_response.txt             <- Data table for BML analysis
    |-- 01-data_preprocessing.ipynb                         <- Extraction, visualization of min. shifted
                                                                response estimates for the 85 ROIS.
                                                                It creates the data table used in BML
                                                                analysis (check data/README.md)
    |-- 02a-MAX-early.r                                     <- BML analysis script for early phase.
                                                                (input: data/MAX_neutral_offset_agg_response.txt)
    |-- 02b-MAX-late.r                                      <- BML analysis script for late phase
                                                                (input: data/MAX_neutral_offset_agg_response.txt)
    |-- 03a-MAX-early_results.ipynb                         <- Plots posteriors for early phase. Also 
                                                                exports posteriors to .txt file (check results_offset/)
    |-- 03b-MAX-late_results.ipynb                          <- Plots posteriors for late phase. Also 
                                                                exports posteriors to .txt file (check results_offset/)
    |-- 04-rendering-85.ipynb                               <- Renders P+ values to standard brain surface.
                                                                Requires ROI mask
```

The 85 ROIs mask: `/data/bswift-1/Pessoa_Lab/MAX/ROI_masks/MAX_ROIs_final_gm_85.nii.gz`