% Tracy Method + calculating rate and time , By: Mehdi Hosseini 93134029


clc
clear
Pi=input('Enter the initial pressure (MAX:4350):  ');
Pf=input('Enter the final pressure that you want to have your data there (min:3350) : ');
Swc=input('Enter Swc: ');
N=input('Enter N in MMSTB: (ex:15) ');
K=input('Enter the Permeability in md: (Ex:10) : ');
h=input('Enter Reservoir Thickness in ft: (Ex:200):   ');
Re=input('Enter Outer Radius of Reservoir in ft:  (Ex:1500) :  ');
Rw=input('Enter Inner Radius of Reservoir in ft:  (Ex:0.4) :   ');

disp(' ');
disp('In every step, pressure fall 200 psi' );

Boi=1.43; 
Rsi=840;
MUo=1.7;
MUg=0.023;

i=0;
P=Pi;

Gor3=840;
Gor2=840;
Np1=0;
Gp1=0;
while P>=Pf
    er=1000;
    i=i+1;
    P=P-200;
%By fitting data using Excel we have:
Bo = 9e-05*P + 1.0473;
Bg = (-0.0016*P + 13.903)*10^(-4);
Rs = 0.2086*P - 56.333;
Den=(Bo-Boi)+(Rsi-Rs)*Bg;
Phio=(Bo-Rs*Bg)/Den;
Phig=Bg/Den;
Np2=Np1;
Gp2=Gp1;
PP(i)=P;
Boo(i)=Bo;

    while er>50
        Gor2=Gor2+1;
        Gor1=Gor3;
        Gorav=(Gor1+Gor2)/2;
        
        DelNp=(1-(Np2*Phio+Gp2*Phig))/(Phio+Gorav*Phig);
        Np1=Np2+DelNp;
        So=(1-Np1/N)*Bo/1.43*(1-Swc);
        Kro = 0.5013*exp(-10.71*(1-So-Swc));
        Kroo(i)=Kro;
        Sg=1-Swc-So;
        Kro = 0.51*exp(-10.74*Sg);
        Krg = 0.6757*Sg^(1.8513);
        FKr=Krg/Kro;
        Gor3=Rs+FKr*MUo*Bo/(MUg*Bg);
        er=abs(Gor2-Gor3);
        DelGp=DelNp*Gorav;
        Gp1=Np1*Gorav;
        Np=N*Np1;
        Gp=N*Gp1;
    end
    np(i)=Np;
    gp(i)=Gp;
    Npp(i)=Np;
    SNp=sum(np);
    SGp=sum(gp);
     counter=i;
     Npp2(i)=Np;
     Gpp1(i)=Gp;
end
 % determining Q at every step

      J1=7.08*10^-3*K*h/(1.5*Boo(1)*(log(Re/Rw)-0.75));
      Qmo=J1*Pi/(1+0.8*Pf/Pi);
      Jstar1=1.8*Qmo/Pi;
      time=0;
      Qi=0;
for i=2:counter
    Qo1=Qi;
    Jstar2=Jstar1*(Kroo(i)/(1.5*Boo(i)))/((Kroo(i-1))/(1.5*Boo(i-1)));
    Qmo=Jstar2*PP(i)/1.8;
    Qo2=Qmo*(1-0.2*(PP(i)/PP(i-1))-0.8*(PP(i)/PP(i-1))^2);
    Qo=(Qo1+Qo2)/2;
    time=Npp(i-1)*1000000/Qo+time;
    Qi=Qo2;
    
    disp(' ');
     disp(['the ', num2str(i-1), 'th step oil production would be: ' ,num2str(Npp2(i-1)), ' MMSTB']);
     disp(['the ', num2str(i-1), 'th step gas production would be: ' ,num2str(Gpp1(i-1)), 'MMSCF']);
     disp(['the ', num2str(i-1), 'th step oil rate would be:       ' ,num2str(Qo), ' STB/Day']);
     disp(['Total elapsed time would be:          ' ,num2str(time), ' Day']);
    disp(' ');
end
 
 NPPP=SNp-np(counter-1);
 GPPP=SGp-gp(counter-1);
 disp(['the cumulative Oil production would be: ' , num2str(NPPP), ' MMSTB']);
 disp(['the cumulative Gas production would be: ' , num2str(GPPP), ' MMSCF']);


