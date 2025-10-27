% Script to make a data ID for System ID toolbox

% 16PIDE is the name of the values file you exported
load('Vali2Hz10Degrees.mat')

% 1) List all the element names to make sure they match what you think:
data.getElementNames
% See 'PID_cmd' and 'attitude' in that list.

% 2) Extract the reference (input) signal
refSig = data.get('reference');
u = refSig.Values.Data(:);
t = refSig.Values.Time(:);

% 3) Extract the attitude (output) signal
attSig = data.get('attitude');
y = double(attSig.Values.Data(:));

% 4) Compute sample time
Ts = t(2) - t(1);

% 5) Remove NaN rows (ensure both input and output have valid data)
idx = all(~isnan([u, y]), 2);   % keep only rows with no NaNs
u_clean = u(idx, :);
y_clean = y(idx, :);

% Optionally adjust time vector (if needed)
t_clean = t(idx);

% 6) Build the iddata object
values2 = iddata(y_clean, u_clean, Ts);

% 7) Inspect
whos values2
plot(values2);


%{
4.0663rad/sec to 0.6366 Hz thus 0.9549 Hz max
 % 1) Estimate the nonparametric transfer (FRD) from your data:
G_est = etfe(values);       % etfe returns an frd model

% 2) Form the closed‐loop transfer with unity feedback:
L = feedback(G_est, 1);     % feedback(sys,1) closes the loop sys/(1+sys)

% 3) Plot the closed‐loop Bode (optional):
bode(L), grid on

% 4) Compute the –3 dB bandwidth:
bw = bandwidth(L);

%}