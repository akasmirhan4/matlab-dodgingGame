# matlab-dodgingGame
A simple Anti Drone Sentry game written in MATLAB where the player has to nets from an AI bot.
To launch the game, open DodgeGame.m in MATLAB

Objective:
Dodge the projectile and collect as many coins as possible

Controls:
up/down/left/right arrow - control the velocity of drone
esc/q - quit
r - restart

The AI calculates the angle required to shoot using a BVP solver: Shooting method.
The projectile slows down when it detects the player under a close proximity.
This game is an extension to my 2nd year unit project, Modelling Technique, where I had to create the shooting method.


The game is unfinished and has a lot of rooms to improve on and bugs to fix such as:
- The bot does not shoot when the player is north-west relative to the bot.
- The projectile slows down eventhough the player isnt anywhere close to it
- Could improve the graphical look

Amirrul Kasmirhan (09777), University of Bath, 2017
