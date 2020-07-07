clear; clc; close all;

%Constants
c=343; %Sound speed, m/s
R=287; %Specific gas constant, J/Kg K
T=298; %Temperature, K
Pref=20e-6; %Reference pressure, Pa
rho_amb=1.2; %Ambient density, Kg/m3
P_amb=103500;
gamma=1.4;

%Parameters of the Schlieren apparatus
lambda=532e-9; %Wavelength of light, m
a=1e-3; %size of the focal point, m
f2=80*25.4/1000; %Focal length of the mirror close to the knife-edge (m)
L=0.1; %Length of the schlieren object to be visualized

%Camera parameters
nBits=12; %Camera bit depth
Nlv=5; %Number of digitization levels accepted in the sine wave

%%
%Simple Calculations
G=2.2244e-4 * (1+(6.37132e-8 ./ lambda).^2);
n0=1+G*rho_amb; %Baseline index of refraction

F=logspace(0,5,500);
SPLmin=20*log10(((c*R*T)/(2*pi*Pref)) * (1/G) * (1./F) * (a/f2) * (n0/L) * Nlv) - 6.02*(nBits-1); %SPL as a function of frequency

%%
%Compressible calculations
Cmin=Nlv/(2^(nBits-1));
EpsilonMin=Cmin*a/f2;
dndxMin=EpsilonMin*n0/L;
dRhodxMin=dndxMin/G;

SPL=linspace(100,194,100);
PoPa=(10.^(SPL/20))*Pref/P_amb;
%NonlinearityFunctionPkPk=PoPa.*((1+PoPa).^(1+1/gamma)-(1-PoPa).^(1+1/gamma))./(1-PoPa.^2); wrong for some reason
NonlinearityFunctionPkPk=((1+PoPa).^(1+1/gamma)-(1-PoPa).^(1+1/gamma))./(1-PoPa.^2);

FudgeFactor=sqrt(gamma);
k_nonlinear=FudgeFactor*dRhodxMin*2*gamma./(rho_amb.*NonlinearityFunctionPkPk);
f_nonlinear=k_nonlinear*c/(2*pi);


%%
%Plotting
figure('Color','w')
semilogx(F,SPLmin,'k-','linewidth',2);
hold on;
semilogx(f_nonlinear,SPL,'b--','linewidth',2);

xlabel('F [Hz]');
ylabel('SPL_{min} ref 20\mu Pa','interpreter','tex')
ylim([100 200])
legend('Linear relation','Non-linear correction');

