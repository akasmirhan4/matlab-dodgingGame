function [sentryX,sentryY] = getSentryPosition(limitX,limitY)
%getSentryPosition
%   Obtain a position for the sentry using normally distributed rng
%   along the perimeter of the scene
%
%   limitX,limitY       -   The size of the scene
%   sentryX,sentryY     -   The coordinate points generated for the sentry
%                           position

%%
%Generate a random number from 0 to 1
randNum = rand;

% Distribute uniformly the sentry position along the perimeter of the scene
if randNum <= limitX/(2*limitX+2*limitY)
    sentryX = randi([0,limitX]);        % randomize sentry initial horizontal position, m
    sentryY = 0;                        % randomize the sentry initial vertical position, m
    
elseif randNum <= 2*limitX/(2*limitX+2*limitY)
    sentryX = randi([0,limitX]);        % randomize the sentry initial horizontal position, m
    sentryY = limitY;                   % randomize the sentry initial vertical position, m
    
elseif randNum <= (2*limitX+limitY)/(2*limitX+2*limitY)
    sentryX = 0;                        % randomize the sentry initial horizontal position, m
    sentryY = randi([0,limitY]);        % randomize the sentry initial vertical position, m
    
else
    sentryX = limitX;                   % randomize the sentry initial horizontal position, m
    sentryY = randi([0,limitY]);        % randomize the sentry initial vertical position, m
    
end
end

