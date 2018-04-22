function [z,indexChuteOpen] = ivpSolver(z0,zDrone,droneMass,dt,tEnd,method)
% ivpSolver    Solve an initial value problem (IVP) and plot the result
%
%       [T,Z] = ivpSolver(t0,z0,dt,tend) computes the IVP solution
%       z0 - initial state [x0,y0,Vx0,Vy0]
%       zDrone - Drone state [Dronex0,Droney0,DroneVx,DroneVy]
%       dt - step size
%       tEnd - final time.
%       The solution is output as a time vector t and a matrix of state vectors z (x;y;Vx;Vy).
%%

%Physical Properties%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chuteDrag = 0.9;
chuteArea = 1.5;
projectileDrag = 0.1;
projectileMass = 0.5;
projectileArea = 5e-4;
safeDistance = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Set initial conditions
t0 = 0;
z = z0;
boolChuteOpen = 0;
n=1;
t = t0:dt:tEnd;

%%
% Continue stepping until the end time is exceeded
while t(n) < tEnd && z(2,n)>= 0
    
    %if the chute is not opened yet
    if ~boolChuteOpen
        
        % if the distance between the drone and projectile is <= 1 or
        % projectile is falling (Vy = -ve) beyond the safe distance
        if (distanceBetween(z(1:2,n),zDrone(1:2,n))<=1) || (z(2,n) <=safeDistance && z(4,n)<0)
            boolChuteOpen = 1;                 %Open chute
            Cd = chuteDrag;                    %Replace the drag coefficient 
            Ar = chuteArea;                    %and reference area to be the parachute
            indexChuteOpen = n;                %retrieve the position index of where the chute is opened
            %(assume the parachute to be weightless and drone is caught straight away)
            
            M = droneMass;                     %change the total mass to be the mass of the drone
            

        else
            Cd = projectileDrag;
            Ar = projectileArea;
            M = projectileMass;
        end
    end

    if method == 1
        z(:,n+1) = stepEuler(z(:,n),M, Cd,Ar, dt);
    elseif method == 2
        z(:,n+1) = stepRungeKutta(z(:,n),M, Cd,Ar,dt);
    end
    
    n = n+1;
end
