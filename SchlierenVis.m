clear; clc; close all;

%Constants
c=343; %Sound speed, m/s
R=287; %Specific gas constant, J/Kg K
T=298; %Temperature, K
Pref=20e-6; %Reference pressure, Pa
rho_amb=1.2; %Ambient density, Kg/m3

%Parameters of the Schlieren apparatus
lambda=532e-9; %Wavelength of light, m
a=1e-3; %size of the focal point, m
f2=80*25.4/1000; %Focal length of the mirror close to the knife-edge (m)
L=0.1; %Length of the schlieren object to be visualized

%Camera parameters
nBits=12; %Camera bit depth
Nlv=5; %Number of digitization levels accepted in the sine wave

%%
%Calculations
G=2.2244e-4 * (1+(6.37132e-8 ./ lambda).^2);
n0=1+G*rho_amb; %Baseline index of refraction

F=logspace(2,5,300);
SPLmin=20*log10(((c*R*T)/(2*pi*Pref)) * (1/G) * (1./F) * (a/f2) * (n0/L) * Nlv) - 6.02*(nBits-1); %SPL as a function of frequency

%%
%Plotting
figure('Color','w')
semilogx(F,SPLmin,'k-','linewidth',2);
xlabel('F [Hz]');
ylabel('SPL_{min} ref 20\mu Pa','interpreter','tex')



