%----------------------------------
% June 2010
% Sajad Saeedi
% University of New Brunswick (UNB)
% Fredericton, NB, Canada
% email: sajad.saeedi.g@gmail.com
% website: http://www.sajad-saeedi.ca/
% ----------------------------------
% Particle Swarm Optimization (PSO)
%
% Description:
%
% This is a simple implementation of the PSO algorithm.
% It finds the minimum of a single-input function. 
% Here the following function is used: f(x) = x sin(x).
%
% Simply press 'Run' or hit F5 to see the demo, or 
% type pso() in the command window and hit Enter.
%
% A video file, deomnstaring the optimization, is generated at the end.
%
% Change the parameters to tune the optimization.
%
% This code has been updated and tested in MATLAB R2016b
%
% For more information about PSO, see online resources such as
% 'Particle Swarm Optimization: A Tutorial', James Blondin, 2009
% ----------------------------------
%% 
function pso()
clc; 
clear all; 
close all;

% The goal is to find the minimum of the the following function: y = -x sin(x)
x = linspace(0,10,500);
y = -x.*sin(x);

%% initialize particles
nParticle = 10;         % nuber of particles
bUP = 10;               % upper range of function f          
bLO = 0;                % lower range of function f
vUP = (bUP-bLO)/10;     % upper range of velocity          
vLO = -(bUP-bLO)/10;    % lower range of velocity
g = inline('-x*sin(x)');% the optimization function
c0 = 0.8;               % update coefficien0 ( 0 < c0 < 1.2)
c1 = 1.8;               % update coefficien1 ( 0 < c0 < 2)
c2 = 1.8;               % update coefficien2 ( 0 < c0 < 2)

nItr = 100;             % number of iterations

max_x = max(x);         % maximum value for x
min_x = min(x);         % minimum value for x

p = [];                 % particles 
gbest = [];             % best particle
id = -1;                % id of the best particle
fit_variance = 10;      % variance of particles

for i=1:nParticle
    p(i).x = bLO + (bUP-bLO).*rand;    % particle position
    p(i).pbest = p(i).x;               % particle's best fit so far
    p(i).v = vLO + (vUP-vLO).*rand;    % particle velocity
    p(i).fit = g(p(i).x);              % the value of the the best fit
    p(i).f   = g(p(i).x);              % current value of the fit (just used for the plot)
end
[gbest id] = min([p(i).fit]);          % p(id) is the gbest

% to make a video of the optimzation
vidObj = VideoWriter('pso.avi');
vidObj.FrameRate = 10;
open(vidObj);

%% run the algorithm for maximum 100 iterations
for j=1:nItr      
    % plotting results
    plot(x,y);hold on
    for i=1:nParticle
        plot(p(i).x, p(i).f, 'ro');    
    end
    title('Particle Swarm Optimization');
    xlabel('x');
    ylabel('f(x) = x sin(x)');
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);
    pause(0.1);hold off
       
    
    % you may stop the algorithm when the variance of the particles is low
    % warning: this may cause the algorithm to converge to a local minima
    fit_variance = var([p(:).fit]);   
    if (fit_variance < 0.100)      
        break
    end
   
    % Updateing velocities and positions
    for i=1:nParticle
        p(i).v = c0*p(i).v + c1*rand*(p(i).pbest - p(i).x) + c2*rand*(p(id).x - p(i).x);
        if (p(i).v > vUP); p(i).v = vUP; end  
        if (p(i).v < vLO); p(i).v = vLO; end        
        p(i).x = p(i).x + p(i).v;
        if (p(i).x > max_x) p(i).x = max_x; end  % clip x by max_x
        if (p(i).x < min_x) p(i).x = min_x; end  % clip x by min_x
    end    
    
    % Evaluate all particles with the fitness function
    for i=1:nParticle
        fitness = g(p(i).x);
        p(i).f  = fitness;          % keep for plot
        if (fitness < p(i).pbest)   % if the new position is better
            p(i).pbest = p(i).x;
            p(i).fit = fitness; 
        end
    end
     
   % find the best global
   [gbest id] = min([p(:).fit]); % p(id) is the gbest  
end

%% gbest
fprintf('variance of particles is %3.3f\n', fit_variance);
fprintf('number of iterations is %d\n', j);
fprintf('The minimum point (gbest) is at: \nx = %f, f(x)= %f\n', p(id).x, p(id).fit );

% close the movie file
close(vidObj);