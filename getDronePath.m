function [t,droneZ] = getDronePath(t0,initDroneZ,dt,tEnd,elasticWall,Scenelimits,maxSpeed)
% getDronePath    Obtain path of drone
%
%       [t,droneZ] = getDronePath(t0,z0,dt,tEnd,elasticWall,limits)
%       computes the path of a drone using Euler's method
%
%       t0 - initial time
%       initDroneZ - initial state [x0,y0,Vx0,Vy0,Ax0,Ay0]
%       dt - step size
%       tEnd - final time.
%
%       The solution is output as a time vector t and a matrix of
%       state vectors droneZ (x;y;Vx;Vy).
%
%% Set initial conditions

t = t0:dt:tEnd;
droneZ = initDroneZ(1:4);
droneAx = initDroneZ(5);
droneAy = initDroneZ(6);
limitX = Scenelimits(1);
limitY = Scenelimits(2);
n=1;

%% Continue stepping until the end time is exceeded
while t(n) < tEnd
    
    %Update next state
    droneZ(1,n+1) = droneZ(1,n)+ droneZ(3,n)*dt;
    droneZ(2,n+1) = droneZ(2,n)+ droneZ(4,n)*dt;
    droneZ(3,n+1) = droneZ(3,n)+ droneAx*dt;
    droneZ(4,n+1) = droneZ(4,n)+ droneAy*dt;
    
    
    %Cap drone velocity within speed limit
    if abs(droneZ(3,n+1)) >= maxSpeed
        droneZ(3,n+1) = maxSpeed*sign(droneZ(3,n+1));
    end
    if abs(droneZ(4,n+1)) >= maxSpeed
        droneZ(4,n+1) = maxSpeed*sign(droneZ(4,n+1));
    end
    
    %Bounce drone off wall
    if elasticWall
        if droneZ(1,n+1) <= 0
            droneZ(3,n+1) = -droneZ(3,n+1);
            droneZ(1,n+1) = 0;
        elseif droneZ(1,n+1) >= limitX
            droneZ(3,n+1) = -droneZ(3,n+1);
            droneZ(1,n+1) = limitX;
        end
        if droneZ(2,n+1) <= 0
            droneZ(4,n+1) = -droneZ(4,n+1);
            droneZ(2,n+1) = 0;
        elseif droneZ(2,n+1) >= limitY
            droneZ(4,n+1) = -droneZ(4,n+1);
            droneZ(2,n+1) = limitY;
        end
    else
        if droneZ(1,n+1) <= 0
            droneZ(3,n+1) = 0;
            droneZ(1,n+1) = 0;
        elseif droneZ(1,n+1) >= limitX
            droneZ(3,n+1) = 0;
            droneZ(1,n+1) = limitX;
        end
        if droneZ(2,n+1) <= 0
            droneZ(4,n+1) = 0;
            droneZ(2,n+1) = 0;
        elseif droneZ(2,n+1) >= limitY
            droneZ(4,n+1) = 0;
            droneZ(2,n+1) = limitY;
        end
    end
    
    n = n+1;
end
