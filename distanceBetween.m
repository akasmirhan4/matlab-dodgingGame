function distance = distanceBetween(Z1,Z2)
%Z1 - [Z1.x,Z1.y]
%Z2 - [Z2.x,Z2.y]

distance = sqrt((Z1(1)-Z2(1))^2+(Z1(2)-Z2(2))^2);
end
