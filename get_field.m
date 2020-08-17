function[B_ECEF] = get_field(time, lat, lon, alt)
%returns the magnetic field in ECEF frame for given time, lat, lon, alt
%time in seconds
%alt is km above Earth's surface
%BX, BY, BZ in nT
%BX Northward
%BY Eastward
%BZ Radially inward
TIME = datenum([2019 01 01 0 0 time]); %yr mo day hr min sec
COORD = 'geodetic'; %geodetic or geocentric
[BX_NED, BY_NED, BZ_NED] = igrf(TIME, lat, lon, alt, COORD);
B_ECEF = NED2ECEF(BX_NED, BY_NED, BZ_NED, lat, lon);
%plot(lon, BX, lon, BY, lon, BZ);
end