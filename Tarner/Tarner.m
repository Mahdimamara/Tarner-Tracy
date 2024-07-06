% Tarner Method, By: Mehdi Hosseini 93134029

clc
clear
Pi=input('Enter the initial pressure (MAX:2100):  ');
Pf=input('Enter the final pressure that you want to have your data there (min:1500) : ');
Cf=4.9e-6;
Cw=3.6e-6;
Swc=input('Enter Swc: ');
N=input('Enter N in MSTB: (Ex: 15000) ');
disp(' ');
disp('In every step, pressure fall 100 psi' );

% dadehaee ke baraye bedast avardan ravabet Bo, Rs , ... estefade shode:
%     P     Bo   Rs  Bg         MUo/MUg
%PVT=[2925 1.429 1340 0          0;
%     2100 1.48  1340 0.001283 34.1;
%     1800 1.468 1280 0.001518 38.3;
%     1500 1.44  1150 0.001853 42.4];
 
 %    So      Krg/Kro
 %Kr=[0.81       0.018;
 %    0.76       0.063;
 %    0.6        0.85;
 %    0.5        3.35;
 %    0.4        10.2];
 
 i=0;
 P=Pi;
 R2=1340;
 Np2=0.01*N;
 
 while P>Pf
     i=i+1;
     P=P-100;
     
     %By fitting data using Excel we have:
     Bo=-9e-8*P^2+0.0004*P+1.06;
     Rs=-0.0004*P^2 + 1.7167*P - 550;
     Bg=6e-10*P^2-3e-06*P+0.005;
     FMU=-6e-07*P^2-0.0118*P+61.4;
     er=500;
     
     while er>1
         Np1=Np2;
         %Gp=(N(Bo+(Rsi-Rs)*Bg-Bob)-Np*(Bo-Rs*Bg))/Bg;
         Gp1=(N*(Bo+(1340-Rs)*Bg-1.429)-Np1*(Bo-Rs*Bg))/Bg;
         Rp=Gp1/Np1;
         So=(1-Np1/N)*Bo/1.429*(1-Swc);
         FKr=6301.9*exp(-15.36*So);
         R1=R2;
         R2=Bo*FKr*FMU/Bg+Rs;
         Gp2=(R1+R2)*Np1/2;
         %Np2=(N*((Bo+(1340-Rs)*Bg-1.429)-Gp2*Bg))/(Bo-Rs*Bg)
         %Np2=Gp2*2/(R1+R2);
         Np2=Np1+(0.0001*N);
         GP1=Gp1/N;
         GP2=Gp2/N;
         er=abs(GP2-GP1);
        
     end
    
     disp(['the ', num2str(i), 'th step oil production would be: ' ,num2str(Np2)]);
     disp(['the ', num2str(i), 'th step gas production would be: ' ,num2str(GP1)]);
    
     np(i)=Np2;
     gp(i)=GP1;
     Np=sum(np);
     gP=sum(gp);
 end
 
 disp(['the cumulative Oil production would be: ' , num2str(Np), ' MSTB']);
 disp(['the cumulative Gas production would be: ' , num2str(gP), 'MMSCF']);