% Open the system ID file needed

%systemIdentification("17eg")

% Export from system ID to workspace the chosen model only to work on

% Select the time start and stop values to cut data 

%17PID is the name of the values file to compare to
load('Vali2Hz10Degrees.mat')

%1) List all the element names to make sure they match what you think:
data.getElementNames
% See 'reference' and 'attitude' in that list.

% 2) Extract the reference (input) signal
refSig = data.get('reference');
u_sim = refSig.Values.Data(:);
t = refSig.Values.Time(:);

% 3) Extract the attitude (output) signal
attSig = data.get('attitude');
y_sim = double(attSig.Values.Data(:));


% Trim data to start after 80 seconds and end at 160 seconds +27 seconds to
% re adjust time frame
start_time = 145;
end_time = 195;
time_mask = (t >= start_time) & (t <= end_time);

% Apply the mask to trim all vectors AND shift time axis
t_trimmed = t(time_mask) - start_time;  % Shift time so 103s becomes 0s
u_trimmed = u_sim(time_mask);
y_trimmed = y_sim(time_mask);


% Create Simulink-compatible variables (time in first column, data in second)
u_sim = [t_trimmed, u_trimmed];  % Format: [time, data]
y_sim = [t_trimmed, y_trimmed];  % Format: [time, data]


% For plotting, use the trimmed variables
t_plot = t_trimmed;
u_plot = u_trimmed;
y_plot = y_trimmed;

% Plot reference and attitude signals
figure;

% Plot reference signal
subplot(2,1,1);
plot(t_plot, u_plot, 'b-', 'LineWidth', 1.5);
title('Reference Signal (Input)');
xlabel('Time (s)');
ylabel('Reference');
grid on;
xlim([0, end_time - start_time]); % Set x-axis to show 0 to 80 seconds

% Plot attitude signal
subplot(2,1,2);
plot(t_plot, y_plot, 'r-', 'LineWidth', 1.5);
title('Attitude Signal (Output)');
xlabel('Time (s)');
ylabel('Attitude');
grid on;
xlim([0, end_time - start_time]); % Set x-axis to show 0 to 80 seconds

linkaxes([subplot(2,1,1), subplot(2,1,2)], 'xy');  % Links both x and y axes

figure;
plot(t_plot, u_plot, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Reference (Input)');
hold on;
plot(t_plot, y_plot, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Attitude (Output)');
title('Reference vs Attitude');
xlabel('Time (s)');
ylabel('Amplitude');
legend('show');
grid on;
xlim([0, end_time - start_time]); 



% do not need a plot since the PID one does it for you

%{

% Create reference_sim and attitude_sim in the same format as u_sim and y_sim
u_sim = [t u];                    % Nx2 matrix: [time, reference]
y_sims = [t y];                     % Nx2 matrix: [time, attitude]

% sim for idplot for whatever is the model name
y_sim = sim(bj33221, u);

% Plot
figure;

% Top plot: y_sim and y
subplot(2,1,1);
plot(t, y_sim, 'b-', 'LineWidth', 1.5); hold on;
plot(t, y,     'r--','LineWidth', 1.5);
hold off;
legend('y\_sim','y','Location','best');
xlabel('Time (s)');
ylabel('Attitude (rad)');
title('Model vs. Measured Output');

% Bottom plot: error
subplot(2,1,2);
plot(t, (y_sim-y), 'k-', 'LineWidth', 1.5);

% Add horizontal boundary lines at +0.5 and –0.5
yline( 0.5, 'r--', '+0.5',  'LabelHorizontalAlignment','right');
yline(-0.5, 'r--', '-0.5',  'LabelHorizontalAlignment','right');

xlabel('Time (s)');
ylabel('y\_sim - y');
title('Simulation Error');


% Plot directly with xlim (doesn't trim data, just viewing window)
figure;
plot(t, u_sim, 'b-', t, y_sim, 'r-', 'LineWidth', 1.5);
xlim([100, max(t)]); % Start at 100 seconds
legend('Reference', 'Attitude');
xlabel('Time (s)');
ylabel('Amplitude');
title('Reference vs Attitude (View from t=100s)');
grid on;


% Link x‑axes for easy zooming
linkaxes(findall(gcf,'Type','axes'),'x');

FitPercent = goodnessOfFit(y_sim, y, 'NRMSE')*100;
RMSE       = sqrt(mean((y_sim-y).^2));

fprintf('Fit = %.2f%%\nRMSE = %.4f\n', FitPercent, RMSE);

%}

