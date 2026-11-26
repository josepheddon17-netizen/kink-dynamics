filename = fullfile('animations','moving_kink_animation.mp4');

video = VideoWriter(filename, 'MPEG-4');
video.FrameRate = 60;
video.Quality = 100;

open(video);

v = 0.9;
x = linspace(-10,10, 500);
t = linspace(0,5,300);
lorentz_factor = 1/sqrt(1-v^2);

fig = figure('Color', 'white', ...
    'Units', 'centimeters', ...
    'Position', [2, 2, 20, 12.5]);

xlim([-5,5]);
ylim([-1.5,1.5]);
grid on;

h = plot(x,zeros(size(x)),'LineWidth',2);

hold on;

p = plot(0,0,'ro', ...
    'MarkerFaceColor','r', ...
    'MarkerSize',8);


d = plot([0,0],[0,0],'r-', ...
    'LineWidth',2);


x0Text = text(0,-0.2,'', ...
    'Color','r', ...
    'HorizontalAlignment','center', ...
    'FontSize',10, ...
    'Interpreter','latex');

xlabel('$x$','Interpreter','latex');
ylabel('$\phi(x,t)$','Interpreter','latex');
title('Moving $\phi^4$ Kink', 'Interpreter','latex');

timeText = text(-9,1.1,'');

for n = 1:length(t)
  
x0 = v*t(n);
phi = tanh(lorentz_factor*(x-x0));

set(h,'YData',phi);
set(p,'XData',x0,'YData',0);
set(d,'XData',[0,x0],'YData',[0,0]);
set(x0Text,'Position',[x0-1,0.3,0], 'String',sprintf('$x_0 = %.2f$',x0));
set(timeText,'String',sprintf('t = %.2f',t(n)));

drawnow;

frame = getframe(fig);
writeVideo(video,frame);

end

close(video);