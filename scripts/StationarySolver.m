%% 1. Spatial Discretisation

% Number of spatial grid points and domain size
N = 500;
L = 10;

% Spatial grid and grid spacing
x = linspace(-L,L,N)';
dx = x(2)-x(1);

%% 2. Initial conditions 

% The Bogomony bound solution tells us phi is tanh(x) when its stationary.
phi0 = tanh(x);

% We have theta = d(phi)/dt = 0 initially
theta0 = zeros(N,1);

%% 3. Time parameters 

T = 5;
dt = 0.001;
time = 0:dt:T;

%% 4. Preallocate solution arrays

% For this set up, rows will correspond to the spatial positions
% and the columns to the time levels.
phi = zeros(N,length(time));
theta = zeros(N,length(time));

% Set initial conditions at t=0
phi(:,1) = phi0;
theta(:,1) = theta0;

%% 5. Laplacian Matrix

% We construct the finite difference approximation to the Laplacian using
% the centred difference formula 

one_vec = ones(N,1);
Laplacian = spdiags([one_vec, -2*one_vec, one_vec], [-1,0,1], N,N);
Laplacian = Laplacian/dx^2;

%% 6. First time step, j = 1

% First, we will calculate the initial acceleration using the phi^4
% wave equation 
acceleration0 = Laplacian*phi(:,1) + 2*phi(:,1).*(1 - phi(:,1).^2);

% Using Dirichlet boundary conditions, we have zero as the boundary values. So our calculation 
% only calculates the acceleration at interior grid points
phi_tt0 = zeros(N,1);
phi_tt0(2:end-1) = acceleration0(2:end-1);

% Use a second-order Taylor expansion to approximate phi at t = dt
phi(:,2) = phi(:,1) + dt*theta(:,1) + 0.5*dt^2*phi_tt0;

%Update the velocity using forward difference approximation
theta(:,2) = theta(:,1) + dt*phi_tt0;

%% 7. Boundary conditions 

% We implement the fixed Dirichlet boundary conditions corresponding to the
% two vacuum states of the phi^4 potential. Furthermore, the velocity is
% zero at both boundaries.
phi([1,end],2) = [-1; 1];
theta([1,end],2) = 0;

%% 8. Centred difference time stepping

% We take the solution through time using centred finite differences.
for j = 2:length(time)-1

% First we update phi using centred difference approximation
   phi(:,j+1) = phi(:,j-1) + 2*dt*theta(:,j);

% Next we calculate the acceleration at the current time
   phi_tt = Laplacian*phi(:,j) + 2*phi(:,j).*(1 - phi(:,j).^2);

% The velocity is then updated using a centred difference approximation in
% time.
   theta(2:end-1,j+1) = theta(2:end-1,j-1) + 2*dt*phi_tt(2:end-1);
   
%The fixed boundary conditions are reapplied at every time step
   phi([1,end],j+1) = [-1; 1];
   theta([1,end],j+1) = 0;
end

%% 9. Numerical Errors

% We compare the final numerical solution with the analytical stationary
% kink to assess the accuracy of the numerical method. The velocity and
% deviation are to make sense of the graphs at the end. They show that
% centred finite differences will make errors as it is an approximation

error = max(abs(phi(:,end) - tanh(x)));
max_velocity = max(abs(theta(:,end)));
max_deviation = max(abs(phi(:,end) - phi(:,1)));

fprintf('Maximum error: %.6e\n', error);
fprintf('Maximum velocity: %.6e\n', max_velocity);
fprintf('Maximum deviation: %.6e\n', max_deviation);

%% 10. Plotting Results

% Our first figure plots the numerical solution at the final simulation
% time. We expect this to look like the graph tanh(x) in shape.

fig = figure('Color', 'white', ...
    'Units', 'centimeters', ...
    'Position', [2, 2, 16, 10]);

ax = axes('Parent', fig, ...
    'Color', 'white', ...
    'XColor', 'black', ...
    'YColor', 'black', ...
    'FontSize', 12, ...
    'FontName', 'Arial', ...
    'LineWidth', 1);

hold(ax, 'on');

plot(ax, x,phi(:,end), 'b--', 'LineWidth', 1.5);
plot(ax, x, tanh(x), 'r--', 'LineWidth', 1.5);

xlabel(ax, 'x', 'FontSize', 12);
ylabel(ax, '$\phi(x)$', 'Interpreter', 'latex', 'FontSize', 12);
title(ax, 'Solution at Final Time', 'FontSize', 14);

lgd = legend(ax, 'Numerically Approximated Kink', 'Analytical Kink');
lgd.FontSize = 11;
lgd.FontName = 'Arial';
lgd.Color = 'white';
lgd.TextColor = 'black';
lgd.EdgeColor = [0.3 0.3 0.3];

grid(ax, 'on');
box(ax, 'on');
hold(ax, 'off');

% Our next plot is of the final velocity profile to check whether the kink 
% remains stationary throughout the simulation. 

fig = figure('Color', 'white', ...
    'Units', 'centimeters', ...
    'Position', [2, 2, 16, 10]);

ax = axes('Parent', fig, ...
    'Color', 'white', ...
    'XColor', 'black', ...
    'YColor', 'black', ...
    'FontSize', 12, ...
    'FontName', 'Arial', ...
    'LineWidth', 1);

hold(ax, 'on');

plot(ax, x,theta(:,end), 'g--', 'LineWidth', 1.5);

xlabel(ax, 'x', 'FontSize', 12);
ylabel(ax, '$\theta(x)$', 'Interpreter', 'latex', 'FontSize', 12);
title(ax, 'Final Velocity Profile', 'FontSize', 14);

lgd = legend(ax, 'Velocity');
lgd.FontSize = 11;
lgd.FontName = 'Arial';
lgd.Color = 'white';
lgd.TextColor = 'black';
lgd.EdgeColor = [0.3 0.3 0.3];

grid(ax, 'on');
box(ax, 'on');
hold(ax, 'off');
