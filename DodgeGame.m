function DodgeGame()
% A simple Anti Drone Sentry game
%
% Objective:
% Dodge the projectile and collect as many coins as possible
%
% % Controls:
% up/down/left/right arrow - control the velocity of drone
% esc/q key - quit
%  r - restart
%
% Amirrul Kasmirhan (09777), University of Bath, 2017

close all


%% Game parameters

% Scene
limitX = 200; %Width limit of the scene limit
limitY = 100; %Height limit of the scene
sceneLimit = [0 limitX 0 limitY]; %Scene size

% Game settings
framePeriod = 0.01; % Time between game updates, s
interceptCoinMargin = 5; % Margin of error for drone to intercept coin
interceptProjectileMargin = 2.5; % Margin of error for projectile to intercept drone
elasticWall = true; % Set the scene perimeter to an elastic wall
tEnd = 60; % Total time for IVP calculation
method = 2; % IVP solver method (1 - Euler, 2 - RK4)

shootingInterval = 4;

% Controller mapping
thrustRatio = 10; % Ratio of maximum thrust used when not vectoring
maxSpeed = 15; % Maximum speed of drone, m/s
ProjectileSpeed = 50;

% Drone initial conditions
droneX = randi([0,limitX]); % randomize the drone initial horizontal position, m
droneY = randi([0,limitY]);% randomize the drone initial vertical position, m
droneVx = 0; % Initial drone horizontal velocity, m/s
droneVy = 0; % Initial drone vertical velocity, m/s

droneMass = 0.5;

% Sentry initial conditions
[sentryX,sentryY] = getSentryPosition(limitX,limitY);
sentry = [sentryX;sentryY];

while distanceBetween([droneX;droneY],sentry)<=100
    [sentryX,sentryY] = getSentryPosition(limitX,limitY);
    sentry = [sentryX;sentryY];
    
end

% Set projectile initially in sentry
projectileX = sentryX;
projectileY = sentryY;


% Coin initial conditions
coinX = randi([0,limitX]); % randomize coin horizontal position, m
coinY = randi([0,limitY]);% randomize coin vertical position, m

coin = [coinX;coinY];
totalScore = 0;


%% Physical parameters
nTime = 0;
time = 0;

% Modelling step size
dt = framePeriod;

%% Keyboard callback functions

% When a key is pressed
    function keyPressCallback(~,event)
        switch event.Key
            case 'q' % Quit game
                quitGame = true;
            case 'escape' % Quit game
                quitGame = true;
            case 'r' % restart game
                restartGame = true;
            case 'uparrow' % Thrust up
                keyUp = true;
            case 'downarrow' % Thrust down
                keyDown = true;
            case 'leftarrow' % Thrust left
                keyLeft = true;
            case 'rightarrow' % Thrust right
                keyRight = true;
        end
    end

% When a key is released
    function keyReleaseCallback(~,event)
        switch  event.Key
            case 'uparrow'
                keyUp = false;
            case 'downarrow'
                keyDown = false;
            case 'leftarrow'
                keyLeft = false;
            case 'rightarrow'
                keyRight = false;
        end
    end


%% Initialisation

% Initialise game flags
keyUp = false;
keyDown = false;
keyLeft = false;
keyRight = false;
quitGame = false;
gameStart = false;
gameOver = false;
restartGame = false;

% Open game window
h = figure(1);
set(gcf, 'Position', get(0, 'Screensize'));
hold on
set(gca,'Color',[0.1 0.1 0.1]);

% Assign keyboard callback functions
set(h,'KeyPressFcn',@keyPressCallback)
set(h,'KeyReleaseFcn',@keyReleaseCallback)

% Drone
hDrone = plot(droneX,droneY,'ws');
hold on

% Coin
hCoin = plot(coinX,coinY,'y*','markers',12);
hold on

% Sentry
hSentry = plot(sentryX,sentryY,'rd','markers',12);

% Projectile
hProjectile = plot(projectileX,projectileY,'rs');

hold off

axis(sceneLimit)

% Status text
hStatus  = text(limitX+2,limitY/2,'');
hMessage = text(limitX/2,limitY/2,'');


%% Run the game
% Loop until a successful landing
while ~quitGame      
    tic
    if restartGame
        keyUp = false;
        keyDown = false;
        keyLeft = false;
        keyRight = false;
        gameStart = false;
        gameOver = false;
        restartGame = false;
        
        time = 0;
        nTime = 0;
        set(hDrone,'Visible','on')
        
        droneX = randi([0,limitX]); % randomize the drone initial horizontal position, m
        droneY = randi([0,limitY]);% randomize the drone initial vertical position, m
        droneVx = 0; % Initial drone horizontal velocity, m/s
        droneVy = 0; % Initial drone vertical velocity, m/s
        
        
        % Sentry initial conditions
        [sentryX,sentryY] = getSentryPosition(limitX,limitY);
        sentry = [sentryX;sentryY];
        
        while distanceBetween([droneX;droneY],sentry)<=100
            [sentryX,sentryY] = getSentryPosition(limitX,limitY);
            sentry = [sentryX;sentryY];
            
        end
        
        % Set projectile initially in sentry
        projectileX = sentryX;
        projectileY = sentryY;
        set(hProjectile,'XData',projectileX,'YData',projectileY);
        
        % Coin initial conditions
        coinX = randi([0,limitX]); % randomize coin horizontal position, m
        coinY = randi([0,limitY]);% randomize coin vertical position, m
        
        coin = [coinX;coinY];
        totalScore = 0;
    end
    %% Apply controls
    % No thrust by default
    droneAx = 0;
    droneAy = 0;
    
    % Apply thrust
    if any([keyUp keyDown keyLeft keyRight])
        
        %start game
        gameStart = true;
        
        if keyLeft
            droneAx = -thrustRatio;
        elseif keyRight
            droneAx = thrustRatio;
        end
        if keyUp
            droneAy = thrustRatio;
        elseif keyDown
            droneAy = -thrustRatio;
        end
    end
    
    
    %% Update state
    if gameStart
        if ~gameOver
            set(hMessage,'String','')
            %Obtain drone path
            [~,droneZ] = getDronePath(0,[droneX;droneY;droneVx;droneVy;droneAx;droneAy],dt,tEnd,elasticWall,[limitX;limitY],maxSpeed);
            
            %Update drone
            droneX = droneZ(1,2);
            droneY = droneZ(2,2);
            droneVx = droneZ(3,2);
            droneVy = droneZ(4,2);
            
            %shoot every shootingInterval time
            if mod(nTime,shootingInterval/dt) == 0
                timeIndex = 1;
                %Insert drone path to shooting method
                [~,finalZ,~,~] = shootingMethod([ProjectileSpeed;sentry],droneZ(1:2,:),dt,droneMass,interceptProjectileMargin,method);
                
                %Obtain a new sentry location
                [sentryX,sentryY] = getSentryPosition(limitX,limitY);
                sentry = [sentryX;sentryY];
            end
        end
    try    
        if timeIndex <= length(finalZ)
            projectileX = finalZ(1,timeIndex);
            projectileY = finalZ(2,timeIndex);
            timeIndex = timeIndex+1;
        end
    catch
        
    end
        
        %% Check coin intercept
        if(distanceBetween([droneX;droneY],coin)<=interceptCoinMargin)
            totalScore = totalScore + 1; % increase totalscore
            coinX = randi([0,limitX]); % randomize the coin horizontal position, m
            coinY = randi([0,limitY]);% randomize the coin vertical position, m
            coin = [coinX;coinY];
        end
        
        %% Check for projectile intercept
        if (distanceBetween([droneX;droneY],[projectileX;projectileY])<=interceptProjectileMargin)
            set(hMessage,'String',['You Lose' newline 'Score: ' num2str(totalScore) newline 'Press r key to restart'] )
            set(hDrone,'Visible','off')
            gameOver = true;
        end
        
        time = nTime*framePeriod;
        nTime= nTime + 1;
        
    else
        set(hMessage,'String',['Press any arrow keys to start' newline ...
                               'Press q or ESC key to quit' newline])
        set(hMessage,'FontSize',20)
        set(hMessage,'Color',[1 1 1])
        set(hMessage,'HorizontalAlignment','center')
        
    end
    %% Update drawings
    
    % Drone
    set(hDrone,'XData',droneX,'YData',droneY);
    % Coin
    set(hCoin,'XData',coinX,'YData',coinY);
    % Sentry
    set(hSentry,'XData',sentryX,'YData',sentryY);
    % Projectile
    set(hProjectile,'XData',projectileX,'YData',projectileY);
    
    % Status text
    set(hStatus,'String', ...
        ['score:    ' num2str(totalScore) newline ...
         'x:           ' num2str(round(droneX,1)) ' m' newline ...
         'y:           ' num2str(round(droneY,1)) ' m' newline ...
         'Vx:         ' num2str(round(droneVx,1)) ' m/s' newline ...
         'Vy:         ' num2str(round(droneVy,1)) ' m/s' newline ...
         'Ax:         ' num2str(round(droneAx,1)) ' m/s' newline ...
         'Ay:         ' num2str(round(droneAy,1)) ' m/s' newline ...
         'time:      ' num2str(time) ' s' newline ...
         'fps:      ' num2str(1/toc) 
        ])
    set(hStatus,'FontSize',15)
    
    %% Wait for next frame
    pause(framePeriod);
    
    
end

close all

end
