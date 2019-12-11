close all; clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Connect your robot and run!   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the clock of the board
fSamplingPeriod = 0.01;

% Initialize least square variables
Theta = [0, 0];

% Set the runtime
simTime = 40;

% open the Simulink diagram
open_system('LabB_TuneTheGyro');

% launch the simulation (note that "external mode" does not support the sim command)
set_param('LabB_TuneTheGyro', 'SimulationCommand', 'start');
fprintf('Started the simulation!\n');

% wait for some seconds
iTimeToWait = simTime; % in seconds
for iTime = 1:iTimeToWait;
	fprintf( '%.2f percent done\n', iTime/(iTimeToWait/100) );
	pause(1);
end;%

% stop the simulation
set_param('LabB_TuneTheGyro', 'SimulationCommand', 'stop');
fprintf('Simulation stopped: waiting for receiving the data...\n');

% wait again a little bit, so that the variables get loaded in the workspace
pause(5);

% Run a least square calculation to determine the bias and slope
A_lms=[ones(size(Gyro_Raw.time)),Gyro_Raw.time];
Data_Gyro=reshape(Gyro_Raw.signals(1).values,size(Gyro_Raw.time));
Avg_Gyro=reshape(Gyro_Raw.signals(2).values,size(Gyro_Raw.time));

Theta=A_lms\Data_Gyro;

figure()
plot(Gyro_Raw.time,Data_Gyro, Gyro_Raw.time,Avg_Gyro, Gyro_Raw.time,Gyro_Raw.time*Theta(2)+Theta(1))
legend('Raw data','Running average','Least Square')


fGyroBias = Theta(1)            % Bias
fGyroBias_drift = Theta(2)      % Drift, k  

% save this value in a .mat file
save('GyroBias.mat', 'fGyroBias','fGyroBias_drift');
fprintf('Done! Data received and saved successfully.\n');


%%

% close simulink 
close_system('LabB_TuneTheGyro');

