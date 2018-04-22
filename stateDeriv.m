function dz = stateDeriv(z,M,Cd,Ar)
% stateDeriv    Calculate the state derivative dz for state vector z. This 
%               function is applicable for projectile motion with applied 
%               drag force at a given total mass M, drag coefficient Cd 
%               and reference area A.
%               
%   dz = stateDeriv(t,z,Cd,Ar) 
% 
%   z   -   state vector with syntax [x;y;Vx;Vy], where:
%           x   -   horizontal displacement, m
%           y   -   vertical displacement, m
%           Vx  -   horizontal velocity, m/s
%           Vy  -   vertical velocity, m/s
%
%	Cd  -   drag coefficient of projectile,
%	A   -   reference area of projectile.
%	M   -   total mass of projectile.
%   dz  -   state derivative of state vector z with syntax [dVx;dVy;dx;dy]

airDensity = 1.225; % Density of air
g = 9.81; % Gravitational acceleration

%% derivation of x and y is Vx and Vy respectively.

dx = z(3);
dy = z(4);

%% Note
% Since drag force is always opposing velocity, direction of velocity
% matters. However, the velocity in drag force equation is squared; hence,
% direction of velocity is removed.
% 
% Therefore, the sign of velocity needs to be obtained.
% function sign() is used where it returns the direction of an element.

%% derivation of Vx and Vy is the horizontal and vertical acceleration respectively.
 
    dVx = (0.5*airDensity*z(3)^2*sign(z(3))*-1*Cd*Ar)/M;
    dVy = (0.5*airDensity*z(4)^2*sign(z(4))*-1*Cd*Ar-M*g)/M;

%% Return dz
dz = [dx;dy;dVx;dVy];

end