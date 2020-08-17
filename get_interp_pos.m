function[LAT, LON, ALT] = get_interp_pos(time, filename)
%returns lat, lon, alt of the ISS, interpolated from .mat file, at given
%time
%alt in km above sea level
%lat from -90 to 90
%lon from -180 to 180
if sum(time < 0) > 0 || sum(time > 18000) > 0
    error('all times must be between 0 and 18000 seconds');
end
ephemeris = load(filename);
LAT = spline(ephemeris.t, ephemeris.lats, time);
LON = spline(ephemeris.t, ephemeris.lons, time);
ALT = spline(ephemeris.t, ephemeris.alt, time);
end