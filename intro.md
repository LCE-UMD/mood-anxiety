# Mood-Anxiety (MAX)

The fMRI session was phases, mood induction and main phase. During the mood induction phase, participants were presented simultaneously with like-category pictures and music segments for 4 minutes ({numref}`exp-design`).

During fMRI experiment, participants were presented with two conditions: threat and safe. Each condition was presented as a block of length 16.25 seoncds. Brain regions of interest (ROI) were selected to analyze temporal evolution of the responses during both conditions. ROI analysis performed on each subject's fMRI data. Evolution of the response for the two conditions was estimated by specifying a series of csplin regressors over a window of 20 seconds (from the onset of the condition until 20 seconds after). Estimation window was kept a little longer (20s) than the block length (16.25s) to observe the decay in the response.

## Experiment Design
```{figure} paradigm.png
---
scale: 50%
align: center
name: exp-design
---
Experiment Design
````
