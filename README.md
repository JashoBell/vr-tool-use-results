# Virtual tool-use: Exploring tool embodiment in virtual reality (Results Repository) 

This is a data repository for my dissertation work, including two studies on tool-use/tool embodiment (three samples of participants). The studies were pre-registered on the Open Science Framework (OSF) and the data, analysis and results are available here.

The source code for the studies will be released on Github once I figure out which assets need removal due 
to licensing. The link will be added here once it is available.

The papers will be posted as preprints once I have passed my defense, and revised them to the point of being ready to submit. The links will be added here once they are available.

## Study 1: Do Tool-use Effects Extend to Virtual Reality? A Pre-registered Extension of Cardinali et al. (2009) to Virtual Reality

- [OSF Pre-Registration](https://osf.io/c6xs5)

This study is an extension of Cardinali et al. (2009) to a virtual environment. This original study was conducted in a physical environment, and the extension was conducted in virtual reality. Participants completed a series of tasks, including a reaching task, a landmark localization task, and a tool-use task. The reaching and landmark localization tasks occurred on either side of tool-use (a pre-post design).

- Raw data in `data/1_tooluseinVR`
- Processed data in `data/study_one`
- Analysis code in `scripts/vr-tool-use`
- Rendered analyses in `quarto_outputs/vr-tool-use`

## Study 2: Just a Tool, After All? No Evidence for Tool Embodiment in Virtual or Real Environments

- [OSF Pre-Registration](https://osf.io/rw9c2)

This study extends the first study by adding an avatar to the virtual environment, with accurate hand-tracking via Manus Quantum gloves. There was also a separately run real-world condition. Due to hardware-related delays, chronologically speaking, the real-world condition was run first, on essentially the same code as the first study, followed by the virtual environment condition, which was based on a revised codebase.

*Virtual with Avatar condition:*
- Raw data in `data/3_avatartooluse`
- Processed data in `data/study_three`
- Analysis code in `scripts/vr-tool-use-avatar`
- Rendered analyses in `quarto_outputs/vr-tool-use-avatar`

*Real-world condition:*
- Raw data in `data/2_toolusenotinVR` (consistent naming schemes are my greatest strength)
- Processed data in `data/study_two`
- Analysis code in `scripts/real-tool-use`
- Rendered analyses in `quarto_outputs/real-tool-use`

## Cumulative Meta-Analysis

After collecting the data from these studies, I conducted a meta-analysis of my own and other studies on tool-use and tool embodiment. These can be found in the folders named `cumulative` or `cumulative-analyses`

# Media

There are images and videos of the studies and results in the `figures` and `videos` folders. The material images are in PNG format, while plots are .svg. The videos are in MP4 format.

# Analysis

## Data

In all studies, we collected kinematic data from infrared trackers during the reaching tasks, landmark localization estimates from the landmarks task, and post-experiment questionnaires. 

The data is available in the `data` folder. The data is in CSV format and organized by study. The data is available in processed form, as well as raw. 

The raw data is in the individual participant folders (1_tooluseinVR/d1-001/trackers, etc.) while the processed data is in the folders study_one, study_two, and study_three. 

The processed data is in a format that is ready to be analyzed in R. The data used to plot the individual reaching trials must be acquired by processing the raw data because the files end up being too large to be stored in the repository. Alternatively, I would be happy to send them over.

## Analysis Code/Output Documents

All analyses used R, and are available as Quarto markdown files in the "scripts" folder. The analysis code is organized by study. The results of running the analysis code can be found in the "quarto_outputs" folder, as HTML files.

There are data "keys" available in the "data" folder. These are documents that contain descriptive information about the data.

There are individual folders for each study, and each folder contains files for:
- Data cleaning & processing (beginning with 00)
- Trial-level data visualizations (beginning with 01)
- Descriptive statistics and visualizations (beginning with 02)
- Preregistered Bayesian mixed-effects models (beginning with 03)
- Model checks (beginning with 04)
- Supplementary/exploratory analyses (beginning with 05)

# Contact

- [e-mail](mailto:joshua.bell@oregonstate.edu)  
- [Twitter](https://twitter.com/jashodb)

Feel free to shoot me any questions. I am happy to help.  

Feel free also to criticize my organization, code, or conclusions, both privately and in public. You are right, I don't know what I'm doing. I don't know how I ended up here. I just keep slipping through the cracks and now I'm in way over my head. Please send help.

# License

The data and analysis code are licensed under the MIT license.
