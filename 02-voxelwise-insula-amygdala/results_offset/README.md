BML results stored at: `/data/bswift-1/Pessoa_Lab/dataset/BML/02-voxelwise-BML/results_offset` with structure:

## Results

hem = left, right; 
phase = early, late

```
    |-- amygdala_[phase]
        |-- amygdala_[phase].RData                          <- Amygdala BML results .RData file
        |-- POP.txt                                         <- Fixed intercept
        |-- HEM_Intercept.txt                               <- Random intercept for each hemisphere
        |-- ROI_Intercept.txt                               <- Random intercept for each ROI
        |-- VOX_Intercept.txt                               <- Random intercept for each voxel
        |-- amygdala_[hem]_[phase]_Pmap.nii.gz              <- Rendered brain map with P+ values of 
                                                               [hem] amgydala at [phase]
    |-- insula_[hem]_[phase]
        |-- insula_[hem]_[phase].RData                      <- Insula BML results .RData file
        |-- POP.txt                                         <- Fixed intercept
        |-- HEM_Intercept.txt                               <- Random intercept for each hemisphere
        |-- ROI_Intercept.txt                               <- Random intercept for each ROI
        |-- VOX_Intercept.txt                               <- Random intercept for each voxel
        |-- insula_[hem]_[phase]_Pmap.nii.gz                <- Rendered brain map with P+ values of 
                                                               [hem] insula at [phase]
    |-- amygdala_[phase]_Pmap.nii.gz                        <- Combined brain map of amygdala at [phase]
    |-- insula_[phase]_Pmap.nii.gz                          <- Combined brain map of insula at [phase]
```