%% 1. Spatial Discretisation

% Number of spatial grid points and domain size and kink location.

N = 500;
L = 10;

% Spatial grid and grid spacing. For moving kinks and kink interactions, it
% will be useful to define x0 here as we will have to use two kinks.

x0=0;
x = linspace(-L,L,N)';
dx = x(2)-x(1);

%% 2. Initial conditions 

% The analytical solution tells us phi when stationary is tanh(x-x0). We must
% therefore perform a Lorentz Transform for our initial condition. It is
% here that we take c=1 to simplify equations (as said on Kink Sheet).

c = 1;
v = 0.5;
lorentz_factor = 1/sqrt(1-v^2);
phi0 = tanh(lorentz_factor*(x-x0));

% We have theta = d(phi)/dt. Since the kink is moving, the velocity is
% going to be our Lorentz Transformed value differentiated.

theta0 = -lorentz_factor*v*sech(lorentz_factor*(x-x0)).^2;

%% 3. Time parameters 

T = 5;
dt = 0.001;
time = 0:dt:T;

%% 4. Preallocate solution arrays

% Our numerical scheme will store solutions at every spatial and temporal
% grid point. For our set up, rows will correspond to the spatial positions
% and the columns to the time levels.

phi = zeros(N,length(time));
theta = zeros(N,length(time));

% Set initial conditions at t=0

phi(:,1) = phi0;
theta(:,1) = theta0;

%% 5. Laplacian Operator

% We construct the finite difference approximation to the Laplacian using
% the centred difference formula

one_vec = ones(N,1);
Laplacian = spdiags([one_vec, -2*one_vec, one_vec], [-1,0,1], N,N);
Laplacian = Laplacian/dx^2;

%% 6. First time step

% First, we will calculate the initial acceleration using the phi^4
% wave equation 

acceleration = Laplacian*phi(:,1) + 2*phi(:,1).*(1 - phi(:,1).^2);

% Using Dirichlet conditions, we have  the boundary values. So our calculation 
% only calculates the acceleration at interior grid points

phi_tt0 = zeros(N,1);
phi_tt0(2:end-1) = acceleration(2:end-1);

% Use a second-order Taylor expansion to approximate phi at t = dt

phi(:,2) = phi(:,1) + dt*theta(:,1) + 0.5*dt^2*phi_tt0;

%Update the velocity using forward difference approximation

theta(:,2) = theta(:,1) + dt*phi_tt0;

%% 7. Boundary conditions 

% We implement the fixed Dirichlet boundary conditions corresponding to the
% two vacuum states of the phi^4 potential. Furthermore, the velocity is
% zero at both boundaries and this does not change as the kink is moving.

phi([1,end],2) = [-1; 1];
theta([1,end],2) = 0;


%% 8. Centred difference time stepping

% We take the solution through time using centred finite differences.

for j = 2:length(time)-1

% First we update phi using centred difference approximation

   phi(:,j+1) = phi(:,j-1) + 2*dt*theta(:,j);

% Next we calculate the acceleration at the current time
   
   acceleration = Laplacian*phi(:,j) + 2*phi(:,j).*(1 - phi(:,j).^2);

% The velocity is then updated using a centred difference approximation in
% time.
   theta(2:end-1,j+1) = theta(2:end-1,j-1) + 2*dt*acceleration(2:end-1);
   
%The fixed boundary conditions are reapplied at every time step

   phi([1,end],j+1) = [-1; 1];
   theta([1,end],j+1) = 0;
end

%% 9. Numerical Errors

% We compare the final numerical solution with the analytical moving
% kink to assess the accuracy of the numerical method. Now we have an
% analytical expression for velocity, we want to compute this difference as
% well and plot it.

analytical_final = tanh(lorentz_factor*(x-x0-v*T));
analytical_velocity = -lorentz_factor*v*sech(lorentz_factor*(x-x0-v*T)).^2;

error = max(abs(phi(:,end) - analytical_final));
velocity_error = max(abs(theta(:,end) - analytical_velocity));
max_deviation = max(abs(phi(:,end) - phi(:,1)));

fprintf('Maximum error: %.6e\n', error);
fprintf('Maximum error in velocity: %.6e\n', velocity_error);
fprintf('Maximum deviation: %.6e\n', max_deviation);

%% 10. Plotting Results

% Our first figure plots the numerical solution at the final simulation
% time.

fig = figure('Units', 'centimeters','Position', [2, 2, 16, 10]);

ax = axes('FontSize', 16, 'LineWidth', 1);

hold(ax, 'on');

plot(ax, x,phi(:,end), 'b', 'LineWidth', 2.5);
plot(ax, x, analytical_final, 'c--', 'LineWidth', 2);

xlabel(ax, 'x', 'FontSize', 16);
ylabel(ax, '$\phi(x,t)$', 'Interpreter', 'latex', 'FontSize', 16);
title(ax, 'Solution at Final Time', 'FontSize', 16);

lgd = legend(ax, 'Numerically Approximated Kink', 'Analytical Kink');
lgd.FontSize = 16;

grid(ax, 'on');
box(ax, 'on');
hold(ax, 'off');

% Our next plot is of the final velocity 

fig = figure('Units', 'centimeters', ...
    'Position', [2, 2, 16, 10]);

ax = axes('FontSize',16,'LineWidth', 1);

hold(ax, 'on');

plot(ax, x,theta(:,end), 'b', 'LineWidth', 2.5);
plot(ax, x,analytical_velocity, 'c--', 'LineWidth', 2);


xlabel(ax, 'x', 'FontSize', 16);
ylabel(ax, '$\theta(x,t)$', 'Interpreter', 'latex', 'FontSize', 16);
title(ax, 'Final Velocity Profile', 'FontSize', 16);

lgd = legend(ax, 'Velocity','Analytical Velocity');
lgd.FontSize = 16;

grid(ax, 'on');
box(ax, 'on')

hold(ax, 'off');
