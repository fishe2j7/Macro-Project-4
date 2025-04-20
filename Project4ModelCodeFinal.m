addpath C:\dynare\6.3\matlab
cd 'C:\Users\fishe\OneDrive\Documents\MACRO THEORY\Project 4'
dynare DYNACODE
vars_to_plot = {'c', 'y', 'k', 'l'};

% Time axis
T = size(oo_.endo_simul, 2);
t = 1:T;

% Loop and plot each variable
for i = 1:length(vars_to_plot)
    varname = vars_to_plot{i};
    
    % Clean match for variable name
    var_idx = find(strcmp(strtrim(varname), strtrim(cellstr(M_.endo_names))));
    
    if isempty(var_idx)
        warning('Variable "%s" not found in M_.endo_names', varname);
        continue;
    end
    
    figure;
    plot(t, oo_.endo_simul(var_idx, :), 'LineWidth', 2);
    title(['Path of ', varname], 'Interpreter', 'none');
    xlabel('Time');
    ylabel(varname);
    grid on;
end

%Seeing How IRF's change when we increase disutility of labor (Increasing
%psi from 1.75 to 2.75)

dynare DYNACODE2

vars_to_plot2 = {'c', 'y', 'k', 'l'};

% Time axis
T = size(oo_.endo_simul, 2);
t = 1:T;

% Loop and plot each variable
for i = 1:length(vars_to_plot2)
    varname = vars_to_plot2{i};
    
    % Clean match for variable name
    var_idx = find(strcmp(strtrim(varname), strtrim(cellstr(M_.endo_names))));
    
    if isempty(var_idx)
        warning('Variable "%s" not found in M_.endo_names', varname);
        continue;
    end
    
    figure;
    plot(t, oo_.endo_simul(var_idx, :), 'LineWidth', 2);
    title(['Path of ', varname], 'Interpreter', 'none');
    xlabel('Time');
    ylabel(varname);
    grid on;
end