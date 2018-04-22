function [minDistance,indexMinDistance] = getMinDistance(z,ztarget)

% minDistance   obtain the minimum distance between a projectile motion and
%               a target
%
%   minDistance = getMinDistance(z,ztarget)
% 
%   z                   -   position matrix of a projectile motion with 
%                           syntax [x1,x2...;y1,y2,...]
%   ztarget             -   target position matrix [x1,x2...;y1,y2,...]
%   minDistance         -   minimum distance found between z and ztarget
%   indexMinDistance    -   the index number of z where minDistance is found
% 
%% 
nCounter = length(z);

% initialise minDistance to be the first distance between z and ztarget
minDistance=distanceBetween(z(:,1),ztarget(:,1)) ;

% initialise indexMinDistance
indexMinDistance = 1;

% loop throughout all positions of z
for n=2:nCounter
    
    % find the distance between the current z position and ztarget
    distance=distanceBetween(z(:,n),ztarget(:,n)) ;
    
    % replace minDistance if distance is lower than the stored minDistance
    if distance < minDistance
        minDistance = distance;
        indexMinDistance = n;
    end
end











