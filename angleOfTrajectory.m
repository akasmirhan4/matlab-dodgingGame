function theta = angleOfTrajectory(V,targetZ)
%angleOfTrajectory  Compute the possible pitch angle at a given speed V
%                   and target location targetZ.
% 
%   theta = angleOfTrajectory(V,targetZ)
% 
%   V           -       Initial projectile speed, m/s
%   targetZ     -       Coordinate of target location (x,y), m
%   theta       -       possible pitch angle.
% 
%  There may be two possible values for theta:
%       - low pitch angle (theta1)
%       - high pitch angle(theta2)
% 
%   The program prioritize theta1 over theta2.

%%
g=9.81; %gravitational acceleration

%Calculate both theta
theta = atan((V^2-sqrt(V^4-g*(g*targetZ(1)^2+2*targetZ(2)*V^2)))/(g*targetZ(1)));

%Convert -ve to +ve
if theta < 0
    theta = atan((V^2+sqrt(V^4-g*(g*targetZ(1)^2+2*targetZ(2)*V^2)))/(g*targetZ(1)));
end

if ~isreal(theta)
    theta = NaN;
end
%Change theta relative to the sentry position
if targetZ(1)<0 && targetZ(2)>=0
    theta = pi-theta;
elseif targetZ(1)<0 && targetZ(2)<0
    theta = pi+theta;
elseif targetZ(1)>=0 && targetZ(2)<0
    theta = 2*pi-theta;
end


