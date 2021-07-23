## BML: Threat vs. Safe (Insula and Amygdala, voxelwise)

## Data
```
    |-- data
        |-- left_insula_11ROIs.nii.gz                       <- Left insula mask.
        |-- right _insula_10ROIs.nii.gz                     <- Right insula mask.
        |-- left_17ROIs.nii.gz                              <- Left insula and amygdala mask.
        |-- right_16ROIs.nii.gz                             <- Right insula and amygdala mask.
        |-- threat_v_safe_insula_amygdala_agg_diff.txt      <- Data table for BML analysis.
    |-- 00-amygdala-partition.ipynb                         <- Create amygdala sub-ROIs mask, combine with insula
                                                                sub-ROIs mask.
    |-- 01a-extract-raw-data.py                             <- Extracts the voxelwise estimates 
                                                                and saves them into a data table
                                                                (data/threat_v_safe_insula_amygdala.txt).
    |-- 01b-data-preprocessing.ipynb                        <- Aggregation and differerce coding of response
                                                                estimates for voxels of insula and amygdala.
                                                                It created data table used in BML analysis
                                                                (check data/README.md).
    |-- 02a-insula-left-early.r                             <- Left insula BML analysis script for early phase.
    |-- 02b-insula-right-early-.r                           <- Right insula BML analysis script for early phase.
    |-- 02c-insula-left-late.r                              <- left insula BML analysis script for late phase.
    |-- 02d-insula-right-late.r                             <- Right insula BML analysis script for late phase
    |-- 02e-amygdala-early.r                                <- Amygdala BML analysis script for early phase.
    |-- 02f-amygdala-late.r                                 <- Amygdala BML analysis script for late phase
    |-- 03a-extract-insula-posteriors.ipynb                 <- Reads the BML output of insula (.RData file),
                                                                exports fixed and random effect posteriors
                                                                as .txt files (check results_offset/).
    |-- 03b-extract-amygdala-posteriors.ipynb               <- Reads the BML output of amygdala (.RData file),
                                                                exports fixed and random effect posteriors
                                                                as .txt files (check results_offset/).
    |-- 04a-rendering-insula.ipynb                          <- Combines random and fixed effect posteriors
                                                                and renders the P+ values on the brain template
                                                                using the insula mask.
    |-- 04b-rendering-amygdala.ipynb                        <- Combines random and fixed effect posteriors
                                                                and renders the P+ values on the brain template
                                                                using the amygdala mask.
```

The 85 ROIs mask: `/data/bswift-1/Pessoa_Lab/MAX/ROI_masks/MAX_ROIs_final_gm_85.nii.gz`