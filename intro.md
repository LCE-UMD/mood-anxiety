# Mood-Anxiety (MAX)

The fMRI session was composed of two phases, mood induction and main phase. During the mood induction phase, participants were presented simultaneously with like-category pictures and music segments for 4 minutes ({numref}`moodInduction`). Participants reported their mood states in terms of valence and arousal (using the common 1-9 scale) prior to and after mood induction.

```{figure} images/moodInduction.png
---
scale: 50%
align: center
name: moodInduction
---
A schematic representation of the presentation timing of mood induction phase.
```

The main phase began immediately after mood induction ({numref}`main`). Experimenters informed participants that a yellow circle on the screen indicated that they were in a “threat” block and electric stimulations would be delivered randomly to their left hand, whereas a circle of another color,blue, indicated that they were in a “safe” block and only “minimal” stimulation would be delivered. “Minimal” stimulation was perceptible but not uncomfortable in any way. Blocks lasted 16.25 seconds and were followed by a 500ms fixation cross. After the fixation cross, participants were asked to rate how anxious they felt: 1 = not anxious, 2 = moderately anxious, and 3 = very anxious, within 2 seconds. A second fixation cross was displayed for 7500 ms. Threat blocks contained 0-3 unpleasant shocks and safe blockscontained 0-3 stimulations. The entire experiment involved 96 blocks in total: 6 segments (three positive and three neutral segments) each with 8 safe and 8 threat blocks administered in a pseudorandomized order (and the order of the 6 segments was counterbalanced across participants). Among the 96 blocks, 32 (16 safe and 16 threat) had electrical stimulation and the remaining 64 (32 safe and 32 threat) had no electrical stimulation shocks.


```{figure} images/main.png
---
scale: 50%
align: center
name: main
---
A schematic representation of the presentation timing of mood induction phase.
```

Data only from the main phase which were collected following neutral mood induction phase are inculded in the current analysis.

Brain regions of interest (ROI) were selected for ROI analysis performed on every participant's fMRI data. Evolution of the brain response for the two conditions (threat and safe) was estimated by specifying a series of csplin regressors over a window of 20 seconds from the condition onset in a GLM. Estimation window was kept longer than the block length of 16.25 seconds to observe the decay in the response.