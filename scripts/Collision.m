%% 1. Spatial Discretisation

% Number of spatial grid points and domain size and kink location.

N = 500;
L = 10;

% Spatial grid and grid spacing. For moving kinks and kink interactions, it
% will be useful to define x0 here as we will have to use two kinks.

x0_kink = -5;
x0_antikink = 5;

x = linspace(-L,L,N)';
dx = x(2)-x(1);

%% 2. Initial conditions 

% The analytical solution tells us phi when stationary is tanh(x-x0). We must
% therefore perform a Lorentz Transform for our initial condition. It is
% here that we take c=1 to simplify equations (as said on Kink Sheet).

c = 1;
v = 0.5;
lorentz_factor = 1/sqrt(1-v^2);

% First we build each kink's initial value separately
kink0 = tanh(lorentz_factor*(x - x0_kink));
antikink0 = -tanh(lorentz_factor*(x - x0_antikink));

% Now construct overall phi0
phi0 = kink0 + antikink0 -1;

% We have theta = d(phi)/dt. Since the kink is moving, the velocity is
% going to be our Lorentz Transformed value differentiated.

theta_kink0 = -lorentz_factor*v*sech(lorentz_factor*(x-x0_kink)).^2;
theta_antikink0 = -lorentz_factor*v*sech(lorentz_factor*(x-x0_antikink)).^2; %antikink being -tanh & having -ve velocity makes 2 -ves so no overall sign change

theta0 = theta_kink0 +theta_antikink0;

%% 3. Time parameters 

T = 75;
dt = 0.005;
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

% kink + antikink goes from -1 to +1 back to -1 so boundaries are both -1
phi([1,end],2) = -1;
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

    phi([1,end],j+1) = -1;
    theta([1,end],j+1) = 0;
end

%% 9. Numerical Errors
% Now won't work easily as the collision makes it hard to get the analytical
% values

%% 10. Animation

% Create video
video = VideoWriter('kink_antikink_v05.avi', 'Motion JPEG AVI');
video.FrameRate = 30;
open(video);

figure

for j = 1:50:length(time)

    plot(x, phi(:,j), 'b', 'LineWidth', 2)

    xlabel('x')
    ylabel('\phi(x,t)')
    title(['Kink-Antikink Collision, v = ', num2str(v),', t = ', num2str(time(j),'%.2f')])

    xlim([-L L])
    ylim([-1.5 1.5])

    yline(1, 'k:')
    yline(-1, 'k:')

    grid on
    drawnow

    % Capture this frame
    frame = getframe(gcf);

    % Add frame to video
    writeVideo(video, frame);

end

% Finish and save the video
close(video);
