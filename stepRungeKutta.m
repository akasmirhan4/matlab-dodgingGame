function znext = stepRungeKutta(z,M,Cd,Ar,dt)
% stepEuler    Compute one step using the Euler method
% 
%     ZNEXT = stepEuler(T,Z,DT) computes the state vector ZNEXT at the next
%     time step T+DT

% Calculate the state derivative from the current state

A = dt * stateDeriv(z,M,Cd,Ar);
B = dt * stateDeriv(z + A/2,M,Cd,Ar);
C = dt * stateDeriv(z + B/2,M,Cd,Ar);
D = dt * stateDeriv(z + C,M,Cd,Ar);

% Calculate the next state vector from the previous one using Euler's
% update equation
znext = z + ( A +2* B +2* C + D ) /6;