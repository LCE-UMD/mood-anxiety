## BML: Threat vs. Safe (Right vento-anterior Insula, voxelwise)

## Data
```
    |-- data
        |-- threat_v_safe_insula_min_shifted_agg.txt        <- Data table for BML analysis.
    |-- 00-ROI-viewer.ipynb                                 <- Visualization of the insula masks.
    |-- 01-preproc.py                                       <- Extracts the voxelwise estimates 
                                                                and saves them into a data table
                                                                for BML analysis. 
                                                                (data/threat_v_safe_insula_min_shifted_agg.txt).
    |-- 02a-MAX-early.r                                     <- Left insula BML analysis script for early phase.
    |-- 02b-MAX-late.r                                      <- Left insula BML analysis script for late phase.
    |-- 03-extract_posterior.ipynb                          <- Reads the BML output (.RData file),
                                                                exports fixed and random effect posteriors
                                                                as .txt files.
    |-- 04-rendering.ipynb                                  <- Combines random and fixed effect posteriors
                                                                and renders the P+ values on the brain template
                                                                using the insula mask.
    |-- left_insula_11ROIs.nii.gz                           <- Left insula mask.
    |-- right _insula_10ROIs.nii.gz                         <- Right insula mask.
```