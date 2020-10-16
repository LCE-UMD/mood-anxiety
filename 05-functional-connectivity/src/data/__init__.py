# Extraction of Trial-by-trial betas

import pandas as pd
import numpy as np

from os import makedirs
from os.path import exists, basename
import glob as glob

def extract_TBT_betas():
    # List of ROIs
    filepath = "data/MAX_threat_vs_safe.txt"
    if not exists(filepath):
        makedirs('data/',exist_ok=True)

        # List of paths to the first level output
        bucket_path = sorted(glob.glob('/data/bswift-1/Pessoa_Lab/MAX/dataset/neutral_runs/MAX???/deconLSS/MAX???_Main_block_deconLSS.1D'))

        print('Number of subjects: ',len(bucket_path))

        # Load text with ROI info as a dataframe
        roi_df = pd.read_csv('/data/bswift-1/Pessoa_Lab/MAX/ROI_masks/README_MAX_ROIs_final_gm.txt',
                             sep='\t',index_col = 'Index')

        roi_df['name'] = roi_df[['Hemi','ROI']].apply(lambda x: ' '.join(x),axis=1)

        rois = roi_df.name
        print('ROIs: ', rois.values)

        # Start extracting TBT betas
        df = pd.DataFrame(columns=['Subj','ROI','cond','Trial','beta'])
        for path in bucket_path:
            subj = basename(path).split('_')[0]

            beta = np.loadtxt(path)

            num_trials = int(float(beta.shape[0])/2.)

            index = ['safe{:02d}'.format(t) for t in range(num_trials)]\
                    + ['threat{:02d}'.format(t) for t in range(num_trials)]

            subj_df = pd.DataFrame(beta,columns=rois, index=index)
            subj_df.index.name = 'cond'
            subj_df.reset_index(inplace=True)
            subj_df = subj_df.melt(id_vars='cond',var_name='ROI',value_name='beta')
            subj_df['Subj'] = subj
            subj_df['Trial'] = subj_df.cond.str[-2:].astype(int)
            subj_df['cond'] = subj_df.cond.str[:-2]

            df = pd.concat([df,subj_df],axis=0,ignore_index = True)
        df.to_csv(filepath,sep=',',index=False,float_format='%.4f')
        print('Saved '+filepath)
    else:
        print(filepath+' already exists')
        
if __name__ == '__main__':
    extract_TBT_betas()