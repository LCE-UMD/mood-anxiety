#!/usr/bin/env python
from tqdm import tqdm
import pandas as pd
import numpy as np

from nilearn import plotting
import nilearn as nil
from nilearn.masking import apply_mask, unmask

from os import makedirs
from os.path import dirname, basename, exists, isdir
import glob as glob

import matplotlib.pyplot as plt
import seaborn as sns


# List of paths to the first level output
bucket_path = sorted(glob.glob('/data/bswift-1/Pessoa_Lab/MAX/dataset/neutral_runs/MAX???/MAX???_Main_block_Deconv.nii.gz'))

print('Number of subjects: ',len(bucket_path))

# Load the left and right insula masks
left_mask = nil.image.load_img('left_insula_11ROIs.nii.gz')
right_mask = nil.image.load_img('right_insula_10ROIs.nii.gz')
# Index values in the mask
print('Right insula ROI indices: ', np.unique(right_mask.get_data())[1:])
print('Left insula ROI indices: ', np.unique(left_mask.get_data())[1:])


def getSubMask(indx,mask):
    '''
    Takes in the mask and ROI index, and outputs a binary (0s and 1s) 
    mask with only that ROI.
    '''
    mask_idx = np.where(mask.get_data() == indx)
    sub_mask = np.zeros_like(mask.get_data())
    sub_mask[mask_idx] = 1
    sub_mask_img = nil.image.new_img_like(mask,sub_mask)
    return sub_mask_img

def make_df(subj,indx,vals,hem):
    '''
    Parameters
    ----------
    subj: string, Subject ID
    indx: scalar, sub-roi index
    vals: numpy.ndarray, betas (or tstat) values
    hem: string, "left" or "right"
    
    Return
    ------
    tmp_df: pd.DataFrame
    '''
    t = np.arange(17)*1.25
    columns = [hem+'_roi{indx:02d}_{vox:03d}'.format(indx=int(indx), vox=vox) for vox in range(vals.shape[1])]
    safe = pd.DataFrame(vals[:17,:],index=t,columns=columns)
    safe['Type'] = 'safe'
    threat = pd.DataFrame(vals[17:34,:],index=t,columns=columns)
    threat['Type'] = 'threat'
    tmp_df = pd.concat([threat,safe])
    tmp_df['Subj'] = subj
    tmp_df.index.name = 'Time'
    tmp_df.reset_index(inplace=True)
    return tmp_df



filepath = 'data/threat_v_safe_insula.txt' 
if exists(filepath):
    df = pd.read_csv(filepath)
else:
    if not isdir('data/'):
        makedirs('data/',exist_ok=True)
        
    df = pd.DataFrame(columns = ['Subj','Type','Time','HEM','ROI','VOX','beta','var'])
    for bucket in tqdm(bucket_path):
        subj = basename(dirname(bucket))
        print('Loading {}...'.format(basename(bucket)))
        cbucket = nil.image.load_img(bucket)
        
        print('Extracting stats...')
        for hem, mask in zip(['right','left'],[right_mask,left_mask]):
            for indx in np.unique(mask.get_fdata())[1:]:
                submask = getSubMask(indx,mask)
                beta = np.squeeze(apply_mask(cbucket,submask))[1::2,:]
                tstat = np.squeeze(apply_mask(cbucket,submask))[2::2,:]

                var = (beta/tstat)**2
                tmp_df_beta = make_df(subj,indx,beta,hem)
                tmp_df_beta = pd.melt(tmp_df_beta,
                                      id_vars=['Subj','Type','Time'],
                                      var_name='VOX',
                                      value_name='beta')
                tmp_df_var = make_df(subj,indx,var,hem)
                tmp_df_var = pd.melt(tmp_df_var,
                                     id_vars=['Subj','Type','Time'],
                                     var_name='VOX',
                                     value_name='var')
                tmp_df = pd.merge(tmp_df_beta,tmp_df_var)
                tmp_df['ROI'] = tmp_df.VOX.str[:-4]
                tmp_df['HEM'] = tmp_df.ROI.str[:-6]
                df = pd.concat([df,tmp_df],ignore_index=True)
                
        print('Done with {}.'.format(dirname(bucket)))
    df.to_csv(filepath,sep=',',float_format='%.4f',index=False)

