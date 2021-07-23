#!/usr/bin/env python

from tqdm import tqdm

import nilearn as nil
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from os import makedirs
from os.path import dirname, basename, exists, isdir
import glob as glob

# Load the left and right insula/amygdala masks
from nilearn import image

left_mask = image.load_img('data/left_17ROIs.nii.gz')
right_mask = image.load_img('data/right_16ROIs.nii.gz')

# List of paths to the first level output
bucket_path = sorted(glob.glob("/data/bswift-1/Pessoa_Lab/MAX/dataset/first_level/voxelwise/neutral_runs_conditionLevel_FNSandFNT/MAX???/MAX???_Main_block_Deconv_bucket.nii.gz"))

# good voxels mask
clean_mask = sorted(glob.glob('/data/bswift-1/Pessoa_Lab/MAX/dataset/preproc/masksAndCensors/MAX???/MNI152_T1_2mm_brain_GM_02182017_goodVoxels.nii.gz'))

print('Number of subjects: \n',len(bucket_path))

# Functions to get good voxel only
def get_good_voxel(data, filtering):
    '''
    filtering set: contains 1s for good voxels and 0s for bad voxels for each subject;
        bad voxels will be replaced by Nan
    '''
    res = np.empty_like(data)
    
    for i, x in np.ndenumerate(filtering):
        if x == 0:
            res[i] = np.nan
        else:
            res[i] = data[i]
            
    return res

# Functions to get dataframe
def make_df(data, hem, roi):
    '''
    make dataframe for given subj, hem and roi
    '''
    temp = pd.DataFrame(data).reset_index()
    temp.rename(columns = {"index": "VOX"}, inplace = True)
    
    temp_safe = temp[["VOX"] + list(range(1, 15))]
    temp_threat = temp[["VOX"] + list(range(16, 30))]
    
    def make_long(df, cond):
        df =  pd.melt(df, id_vars=["VOX"], var_name="Time", value_name="response")
        if cond == "safe":
            df["Time"] = (df["Time"] - 1)* 1.25
        else:
            df["Time"] = (df["Time"] - 16)* 1.25
        df["VOX"] = df["VOX"].apply(lambda vox: '{hem}_roi{roi:02d}_{vox:03d}'.format(hem = hem, roi = int(roi), vox = vox + 1))
        df["Type"] = cond
        
        return df
    
    df = pd.concat([make_long(temp_safe, "safe"), 
                    make_long(temp_threat, "threat")])
    
    return df

# Functions to get final dataset
def make_dataset():
    '''
    make final dataset
    '''
    subj_list = []
    for bucket in tqdm(bucket_path):
        subj = basename(dirname(bucket))
        print('Loading {}...'.format(basename(bucket)))
        raw = image.load_img(bucket)
        filtering = image.load_img([i for i in clean_mask if subj in i][0])

        print('Extracting stats...')

        hem_list = []
        for hem, mask in zip(['left','right'], [left_mask, right_mask]):
            roi_list = []
            for roi in np.unique(mask.get_fdata())[1:]:
                idx = np.where(mask.get_fdata() == roi)
                raw_sub = np.squeeze(raw.get_fdata()[idx])
                filtering_sub = filtering.get_fdata()[idx]

                data = get_good_voxel(raw_sub, filtering_sub)

                temp = make_df(data, hem = hem, roi = roi)
                temp["Hem"] = hem
                temp["ROI"] = '{hem}_roi{roi:02d}'.format(hem = hem, roi = int(roi))
                temp["Subj"] = subj

                roi_list.append(temp)
            res_roi = pd.concat(roi_list)
            hem_list.append(res_roi)
            
        res_hem = pd.concat(hem_list)
        subj_list.append(res_hem)
        
        print('Done with {}.'.format(dirname(bucket)))
        
    res = pd.concat(subj_list)
    res = res[["Subj", "Type", "Hem", "ROI", "VOX", "Time", "response"]]
    return res

filepath = 'data/threat_v_safe_insula_amygdala.txt' 
if exists(filepath):
    df = pd.read_csv(filepath)
else:
    if not isdir('data/'):
        makedirs('data/',exist_ok=True)
    df = make_dataset()
    df.to_csv(filepath, sep=',', float_format='%.7f', index=False)