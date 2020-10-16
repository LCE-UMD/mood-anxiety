from src.data import extract_TBT_betas
from scipy.stats import spearmanr
from os.path import isfile
import pandas as pd
import numpy as np
    
def get_corr_df(seed,df):
    columns=['Subj','cond','ROI','spearmanr','pval']
    seed_df = pd.DataFrame(columns=columns)
    for subj in Subj:
        subj_df = df[df['Subj']==subj]
        for cond in Cond:
            cond_df = subj_df[subj_df['cond']==cond]
            for tar in [roi for roi in rois if seed not in roi]:
                coeff, pval = spearmanr(cond_df[cond_df['ROI']==tar].beta, 
                                        cond_df[cond_df['ROI']==seed].beta)
                tmp_df = pd.DataFrame([subj,cond,tar,np.float(coeff),
                                       np.float(pval)],index=columns).T
                seed_df = pd.concat([seed_df,tmp_df],axis=0,ignore_index=True)

    seed_df['spearmanr'] = seed_df['spearmanr'].astype(np.float)
    seed_df['pval'] = seed_df['pval'].astype(np.float)
    seed_df['cond'] = seed_df['cond'].map({'threat':0.5,'safe':-0.5})
    return seed_df

def table_BML(seed):
    global rois
    global Subj 
    global Cond
    
    main_filepath = "data/MAX_threat_vs_safe.txt"

    if not isfile(main_filepath):
        extract_TBT_betas()
        
    df = pd.read_csv(main_filepath)
    rois = df.ROI.unique()
    Subj = df.Subj.unique()
    Cond = 'threat safe'.split()
    print('Number of ROIs:', len(rois))
    print('Number of subjects:', len(Subj))
    print(df.head())
    seed_df = get_corr_df(seed=seed,df=df)
    cols = ['Subj','ROI','cond','spearmanr']
    filepath = 'data/MAX_threat_v_safe_{}_FC.txt'.format('_'.join(seed.split()))
    seed_df[cols].to_csv(filepath,sep=',',index=False,float_format='%.4f')
    print('Saved '+filepath)
    
    