function [ECEF] = NED2ECEF(Xn, Yn, Zn, lat, lon)
%input: vector in NED reference frame
%latitude in degress, longitude in degrees
%output: vector in ECEF reference frame
lat = deg2rad(lat);
lon = deg2rad(lon);

ECEF = [-sin(lon), -sin(lat)*cos(lon), cos(lat)*cos(lon);...
                cos(lon), -sin(lat)*sin(lon), cos(lat)*sin(lon);...
                0, cos(lat), sin(lat)]*[0 1 0; 1 0 0; 0 0 -1]*...
                [Xn; Yn; Zn]; %ENU to NED
end