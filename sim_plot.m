%define the timespan over which to run the model, run the model, plot
%results
clear all;
close all;

time = 0:1:100;
%time between 0 and 18000 inclusive
s = zeros(8, size(time,2));
B_ECEF = zeros(3, size(time,2));
A_true = zeros(3, 3, size(time,2));

for timestep = 1:size(time,2)
    nextS = get_sat_state(time(timestep));
    s(1, timestep) = nextS.time;
    s(2, timestep) = nextS.lat;
    s(3, timestep) = nextS.lon;
    s(4, timestep) = nextS.alt;
    s(5, timestep) = nextS.bx;
    s(6, timestep) = nextS.by;
    s(7, timestep) = nextS.bz;
    B_ECEF(:,timestep) = get_field(time(timestep), nextS.lat,...
                                   nextS.lon, nextS.alt);
    A_true(:,:,timestep) = nextS.A;
end

%time derivatve of magnetic field
dB_ECEF = diff(B_ECEF')' / (time(2) - time(1));
dB_ECEF = [zeros(3,1) dB_ECEF];
dB_SAT = diff(s(5:7,:)')' / (time(2) - time(1));
dB_SAT = [zeros(3,1) dB_SAT];

%TRIAD estimation
k = 20;
B_b = B_ECEF(:,k) / norm(B_ECEF(:,k));
B_n = s(5:7, k) / norm(s(5:7, k));
dB_b = dB_SAT(:,k) / norm(dB_SAT(:,k));
dB_n = dB_SAT(:,k) / norm(dB_SAT(:,k));
A_est = TRIAD(B_b, dB_b, B_n, dB_n);

f1 = figure('Name','Measured Magnetic Field','NumberTitle','off');
orient(f1,'landscape');
sgtitle('Magnetic field in body and ECEF reference frames of ISS satellite orbit');
subplot(4,1,1)
plot(s(1,:),s(2,:));
ylabel('latitude');
subplot(4,1,2)
modLons = mod(s(3,:)+180, 360) - 180;
plot(s(1,:),modLons);
ylabel('longitude');
subplot(4,1,3)
hold on
grid on
plot(s(1,:),s(5,:),'r');
plot(s(1,:),s(6,:),'g');
plot(s(1,:),s(7,:),'b');
ylabel('field component (nT)');
legend('bx sat', 'by sat', 'bz sat');
subplot(4,1,4)
hold on
grid on
plot(s(1,:),B_ECEF(1,:),'r');
plot(s(1,:),B_ECEF(2,:),'g');
plot(s(1,:),B_ECEF(3,:),'b');
ylabel('field component (nT)');
legend('bx ECEF', 'by ECEF', 'bz ECEF');

f2 = figure('Name','Magnetic field derivative','NumberTitle','off');
subplot(2,1,1)
hold on
grid on
plot(s(1,:),dB_ECEF(1,:),'r');
plot(s(1,:),dB_ECEF(2,:),'g');
plot(s(1,:),dB_ECEF(3,:),'b');
xlabel('time (s)')
ylabel('field time derivative (nT/s)');
legend('dbx/dt ECEF', 'dby/dt ECEF', 'dbz/dt ECEF');
subplot(2,1,2)
hold on
grid on
plot(s(1,:),dB_SAT(1,:),'r');
plot(s(1,:),dB_SAT(2,:),'g');
plot(s(1,:),dB_SAT(3,:),'b');
xlabel('time (s)')
ylabel('field time derivative (nT/s)');
legend('dbx/dt SAT', 'dby/dt SAT', 'dbz/dt SAT');

f3 = figure('Name', 'Orientation', 'NumberTitle', 'off');
subplot(2,1,1)
hold on
grid on
plot(s(1,:),A_true(1,:),'r');
plot(s(1,:),A_true(2,:),'g');
plot(s(1,:),A_true(3,:),'b');


% optional: PDF output
% set(gcf, 'PaperSize', [17 11]);
% print('-fillpage','f1','-dpdf')