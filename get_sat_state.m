function [sat] = get_sat_state(time)
%returns struct of satellite's position, orientation, and the magnetic
%field at given time in seconds.
A_0 = [1 0 0; 0 1 0; 0 0 1]; %initial rotation from ECEF to satellite frame
k = [1; 0; 0]; %rotation axis
k = k/norm(k);
theta = 2*pi*time/60; %rotation angle, radians
%e.g. to rotate 1/minute: theta = 2*pi*time/60;
MAGNETOMETER_NOISE = 8 * randn; %nanoTeslas
sat.A = rodrigues(k, theta) * A_0;
sat.time = time;
[sat.lat, sat.lon, sat.alt] = get_interp_pos(time, 'ISS_ephemeris.mat');
B_ecef = get_field(time, sat.lat, sat.lon, sat.alt);
B_sat = sat.A * B_ecef;
sat.bx = B_sat(1,:) + MAGNETOMETER_NOISE;
sat.by = B_sat(2,:) + MAGNETOMETER_NOISE;
sat.bz = B_sat(3,:) + MAGNETOMETER_NOISE;
end

function [A] = rodrigues(k, theta)
%theta in radians 
assert(size(k,1) == 3, 'size of k');
K = [0 -k(3) k(2); k(3) 0 -k(1); -k(2) k(1) 0];
A = eye(3) + sin(theta)*K + (1 - cos(theta))*K^2;
end