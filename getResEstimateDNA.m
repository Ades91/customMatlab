function h = getResEstimateDNA(trace)

[Ny,Nx] = size(trace);

if (Ny > Nx) % flip the trace to always have the DNA horizontal
    trace = trace';
    [Ny,Nx] = size(trace);
end

c = [Ny+1]/2; 

% identify local maxima in the c-1:c+1 position
locMax = [];
for yy = c-1:c+1
    for xx = 1:Nx
        nei = getNeighborhood(trace,[yy xx],3,'0');
        nei(5) = []; test = nei >  trace(yy,xx);
        if  sum(test) == 0 
            locMax(end+1,1) = yy;
            locMax(end,2) = xx;
        end
    end
end


for k = 1:size(locMax,1)
    h(k) = getFWHM(trace(:,locMax(k,2)));
end

h(end+1) = getFWHM(sum(trace,2));
