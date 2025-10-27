This repository contains all the material used to identify and simulate the pitch attitude of the MS.G quadcopter.
It includes experimental data, videos, MATLAB scripts, and Simulink models that show how the system was modelled, validated, and tested.

FOLDER STRUCTURE:

1.) VIDEOS FOLDER
This folder contains short videos that visually show how the quadcopter behaved during two experiments.
Each video also has its corresponding data file in case deeper analysis is needed.

Square Wave Response:
This is a simple test that shows how the system reacts to a square input signal.
It is mainly for display and understanding basic system behavior.

Chirp Signal Response:
This test uses a chirp signal input that changes frequency over time.
It helps to study how the system behaves across different frequencies.




2.)DATA FOLDER

This folder contains all MATLAB scripts, Simulink models, and both raw and processed data used for system identification and simulation.

Below is the workflow and purpose of each file.

========================================================================================================================================================

STEP 0: DATA GENERATION USING THE QUADCOPTER
File: Chirp.slx

This Simulink file is used to generate the first experimental data on the actual quadcopter hardware.
It sends a chirp input signal (which sweeps through frequencies) to excite the system and collect useful response data.

Before running this file:

Adjust or modify the input signal parameters in this Chirp model if you want to change the type of excitation.

Once ready, use the "Monitor and Tune" command in Simulink to deploy and run it on the quadcopter.

The data collected from this step becomes the basis for later modelling and analysis.

========================================================================================================================================================

STEP 1: RAW AND PROCESSED DATA FILES
Files: Est_Vali_Run.mldatx ; Est2Hz10Degrees.mat ; Vali2Hz10Degrees.mat

The raw run files contain all the signals recorded during experiments.

These were later exported from the "Run" file to extract all the signals (such as the PID command, reference input and the attitude output in the .mat files).

========================================================================================================================================================

STEP 2: DATA PREPARATION FOR SYSTEM IDENTIFICATION
File: system_id_set_up.m

This MATLAB script converts the processed data into "iddata" objects.
These are required for the System Identification Toolbox in MATLAB to create mathematical models of the system.

After running this script, the data can be directly loaded into the System Identification app.

========================================================================================================================================================

STEP 3: SYSTEM IDENTIFICATION SESSION
File: PitchSystemID.sid

This file is a saved session from MATLAB’s System Identification Toolbox.
It already contains:

Two datasets (one for estimation and one for validation)

Example identified models

The selected data ranges used for estimation

Opening this session in MATLAB allows users to review or modify the model fitting and directly compare model performance.

========================================================================================================================================================

STEP 4: MODEL VALIDATION
File: RefModelPIDValidation.m

Once a model is selected and exported from the System Identification app (along with the validation dataset),
this script can be run to test how well the model performs.

The script:

Uses the identified model to recreate the system’s response.

Compares the recreated response to the real measured validation data.

Calculates and plots the error step by step.

This confirms whether the model accurately represents the real system.

========================================================================================================================================================

STEP 5: SIMULINK PREPARATION
File: ReferenceSimulinkPrep.m

This script extracts the reference signal and attitude response from an existing MATLAB data file.
It stores them as workspace variables that will be used by the simulation model.

Important:
The identified system model must already exist in the MATLAB workspace before running this script or the next simulation step.
========================================================================================================================================================

STEP 6: SIMULATION AND COMPARISON
File: Simulation.slx

This Simulink model uses the identified system model and stored input signals to simulate the quadcopter’s response.
It compares the simulated output to the actual measured output and quantifies the difference (error).

The simulation can be run in both open-loop and closed-loop configurations to show how the model behaves under different control setups.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                             WORKFLOW SUMMARY

Run Chirp.slx to excite the quadcopter and generate raw data.

Export raw data into .m files containing the signals.

Run system_id_set_up.m to convert data into identification-ready format.

Open PitchSystemID.sid in MATLAB to review or refine model estimation.

Export your chosen model and validation dataset to the workspace.

Run RefModelPIDValidation.m to test and visualize model accuracy.

Run ReferenceSimulinkPrep.m to prepare data for simulation.

Open Simulation.slx to compare the model’s simulated response to the real system’s behavior.
