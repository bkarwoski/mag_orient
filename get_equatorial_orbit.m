function [lat, long, time] = get_equatorial_orbit(t0, tspan)
    %very simplified circular equatorial orbit calculator
    %tspan in seconds, column vector
    %t0 = output of datenum (serialized date)
    %alt, above sea level (6372 km), in km
    %starting at long = 0
    %for 6978km radius, period = 01:36:41.24 (HH:MM:SS) 
    time = zeros(size(tspan,2),1);
    lat = zeros(size(tspan,2),1);
    long = zeros(size(tspan,2),1);
    time(:) = t0;
    period = 1*3600 + 36*60 +41.24;
    for i = 1:numel(tspan)
        orbit_fraction = (tspan(i) - tspan(1))/period;
        long(i) = mod(orbit_fraction,1)*360 - 180;
        time(i) = time(i) + (tspan(i)-tspan(1))/86400;
    end
    
    
end