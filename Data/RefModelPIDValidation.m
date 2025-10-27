% Open the system ID file needed
%systemIdentification("PitchSystemID")

% Export from system ID to workspace the chosen model to work on

% Export validation data as well to run comparison

% Extract u & y from the iddata
u = validatecut.InputData;         % N×1
y = validatecut.OutputData;        % N×1

% Recreate time vector
N  = length(y);
Ts = validatecut.Ts;
t  = (0:N-1)' * Ts;

% simulation method for idploy
% change to the model name
y_sim = sim(bj33331_1, u);


% Plot
figure;

% Top plot: y_sim and y
subplot(2,1,1);
plot(t, y_sim,  'b-', 'LineWidth',1.5); hold on;
plot(t, y,      'r--','LineWidth',1.5);
%plot(t, y_pred, 'g-.','LineWidth',1.5);
hold off;
legend('y\_sim','y (measured)','Location','best');
xlabel('Time (s)');
ylabel('Attitude (rad)');
title('Model vs. Actual Pitch using PID cmd as Input');

% Bottom: two error traces
subplot(2,1,2);
plot(t, y_sim-y,  'k-', 'LineWidth',1.5); hold on;
%plot(t, y_pred-y, 'g-.','LineWidth',1.5);
yline( 0.20, 'r--','+0.20','LabelHorizontalAlignment','right');
yline(-0.20,'r--','-0.20','LabelHorizontalAlignment','right');

hold off;
legend('y\_sim - y','±0.20 bounds','Location','best');
xlabel('Time (s)');
ylabel('Error (rad)');
title('Simulation Error');

% Link x‑axes for easy zooming
linkaxes(findall(gcf,'Type','axes'),'x');

FitPercent = goodnessOfFit(y_sim, y, 'NRMSE')*100;
RMSE       = sqrt(mean((y_sim-y).^2));

fprintf('Fit = %.2f%%\nRMSE = %.4f\n', FitPercent, RMSE);

N = length(u);                    
t = (0:N-1)' * Ts;                % time vector, column format
u_sim = [t u];                    % Nx2 matrix for Simulink
y_sim = [ t y];