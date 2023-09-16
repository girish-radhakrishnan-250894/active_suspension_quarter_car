% Quarter Car Component Inputs
input.d_s = 1240;       % Ns/m
input.m_s = 510;       % kg
input.m_a = 60;        % kg
input.k_s = 52500;     % N/m
input.k_t = 200000;    % N/m
input.d_t = 100;

% Load controller
load('c_F_qc_controller_IT5.mat')

% Convert controller transfer function to state-space
[cA_ay,cB_ay,cC_ay,cD_ay] = tf2ss(cell2mat(shapeit_data.C_tf.Numerator),cell2mat(shapeit_data.C_tf.Denominator));

input.cA_F = cA_ay;
input.cB_F = cB_ay;
input.cC_F = cC_ay;
input.cD_F = cD_ay;

input.controller_switch = 1;
input.gravity_switch = 0;


% Calculate steady-state values
input.zs_steady_state = -input.gravity_switch*0.219744;
input.zu_steady_state = -input.gravity_switch*0.0235437;