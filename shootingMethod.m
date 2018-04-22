function [finalTheta,finalZ,indexIntercept,landX] = shootingMethod(sentryState,dronePath,dt,droneMass,maxError,method)
% shootingMethod    Compute a solution to a BVP problem using the Shooting method
%
%       [finalTheta,finalZ,indexIntercept,zLand] = shootingMethod(sentryState,dronePath,dt,mDrone,maxError,method)
%       The objective of this function is to calculate the shooting angle
%       needed to capture a drone using an anti-drone sentry ;
%
%%      Input:
%
%       sentryState -   consist of the sentry state [V;x0;y0] where V is the initial speed,
%                       x0 and y0 are the coordinate points;
%
%       dronePath   -   contains coordinates of the drone along its path.
%                       Needed to compare each point for interception.
%
%       dt          -   Step time interval
%
%       droneMass   -   mass of drone
%
%       maxError    -   maximum margin of error to accept interception
%                       between the projectile and the drone.
%
%       method      -   IVP solver method (1 - Euler, 2 - RK4)
%
%%      Output:
%
%       finalTheta  -   The solution angle needed to capture the drone
%
%       finalZ      -   Contains the state of the projectile [x;y;Vx;Vy]
%
%       indexIntercept  -   The index of finalZ where the projectile
%                           intercept the drone.
%
%       landX       -   X coordinate point where the captured drone land

%% Initialize

V = sentryState(1);
x0 = sentryState(2);
y0 = sentryState(3);

tEnd = 60;

%% First guess
guessTheta(1) = angleOfTrajectory(V,[dronePath(1,1)-x0,dronePath(2,1)-y0]);
Vx = V*cos(guessTheta(1));
Vy = V*sin(guessTheta(1));


projectileZ = [x0;y0;Vx;Vy];
tempZ = ivpSolver(projectileZ,dronePath,droneMass,dt,tEnd,method);

[error(1),indexMinDistance] = getMinDistance(tempZ(1:2,:),dronePath);
errorY = tempZ(2,indexMinDistance);

if errorY<dronePath(2,indexMinDistance)
    error(1)=error(1)*-1;
end


%% Second guess
guessTheta(2) = guessTheta(1)+0.1;

Vx = V*cos(guessTheta(2));
Vy = V*sin(guessTheta(2));


projectileZ = [x0;y0;Vx;Vy];
tempZ = ivpSolver(projectileZ,dronePath,droneMass,dt,tEnd,method);

[error(2),indexMinDistance] = getMinDistance(tempZ(1:2,:),dronePath);
errorY = tempZ(2,indexMinDistance);

if errorY<dronePath(2,indexMinDistance)
    error(2)=error(2)*-1;
end


%% Loop guesses
n = 2;
while abs(error(n)) >= maxError
    
    if error(n)-error(n-1)==0
        break
    end
    
    guessTheta(n+1)= guessTheta(n)-error(n)*((guessTheta(n)-guessTheta(n-1))/(error(n)-error(n-1)));
    
    Vx = V*cos(guessTheta(n+1));
    Vy = V*sin(guessTheta(n+1));
    
    projectileZ = [x0;y0;Vx;Vy];
    tempZ = ivpSolver(projectileZ,dronePath,droneMass,dt,tEnd,method);
    
    [error(n+1),indexMinDistance] = getMinDistance(tempZ(1:2,:),dronePath);
    errorY = tempZ(2,indexMinDistance);
    
    if errorY<dronePath(2,indexMinDistance)
        error(n+1)=error(n+1)*-1;
    end
    
    n=n+1;
    
    if n>=20
        break
    end
end

indexIntercept = indexMinDistance;

finalZ = tempZ;
landX = find(tempZ(2,:)<=0,1);

finalTheta = guessTheta(end);

end


