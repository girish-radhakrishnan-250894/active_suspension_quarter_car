function [Zdot, O_simulator, O_model] = active_suspension_quarter_car(t, z, input)
%active_suspension_quarter_car Simulator function that runs vehicle simulations
%   This is a wrapping function that is called by the numerical integrator.
%   It knows the current time-step and using it, it interpolates all the
%   inputs to be tracked. It also calculates the control action and interpolates
%   road inputs and it passes these as scalar values to the vehicle model.

%% Initialization : Augmented state variables

q = [z(1), z(2), z(3), z(4)]';

Z_cont_qcar = [z(5:end)']';

z_s = z(1);

%% Initialization : Road Input

z_r = interp1(input.time, input.z_r, t, 'pchip');

%% Initialization : Controll Matrices

% Sprung Mass Position Controller
% -- A -- Controller Cannonical State Matrix 
Ac_zs = input.cA_F;

% -- B -- Controller Cannonical Input Matrix
Bc_zs = input.cB_F;

% -- C -- Controller Cannonical Output Matrix
Cc_zs = input.cC_F;

% -- D -- Controller Cannonical Outpu<> Input Matrix
Dc_zs = input.cD_F;

%% Reference Signal to be tracked

% Here we will create the reference signal that the controller must track
% In our case, this implies the position of the sprung mass that must be
% tracked
% Since our goal is to keep the sprung mass as level as possible, the
% displacement of the sprung mass must be 0
% The displacement being 0 implies that the position of the sprung mass
% must not change which implies the position is equal to the steady-state
% value calculated
z_s_ref = 0;

%% Error 

e_zs = z_s_ref - (z_s - input.zs_steady_state);

%% Controller Action 

y_cont = Cc_zs*Z_cont_qcar + Dc_zs*e_zs;
F_a = input.controller_switch * y_cont;

%% Quarter car system dynamics

[Qdot, ~, ~, O_model] = quarter_car_model_linear(q, input, F_a, z_r);

%% Controller Dynamics

Z_dot_cont_qcar = Ac_zs*Z_cont_qcar + Bc_zs*e_zs;

%% Augmented system dynamics

Zdot = [Qdot;
        Z_dot_cont_qcar
        ];


%% Outputs

O_simulator = [e_zs;
               Qdot(3);
               F_a]';



























































































end