function magnitude = getMagnitude(Z)
nLength = length(Z);

magnitude = 0;

for n=1:nLength

magnitude = magnitude + Z(n)^2;

end

magnitude = sqrt(magnitude);
end