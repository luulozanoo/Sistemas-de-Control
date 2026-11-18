function [IAE] = Calculo_IAE_competicion_simu(Ref_Vel_S,Vel_S,ref_dn_S,distancia_S)

format compact

Ref_Vel=Ref_Vel_S;
Vel=Vel_S;
ref_dn=ref_dn_S;
distancia=distancia_S;

%% IAE velocidad

aux1=find((Ref_Vel(:,1)>5)&(Ref_Vel(:,2)<(0.12-0.01)));
xini_V=aux1(1);
tini_V=Ref_Vel(xini_V,1)
tfin_V=tini_V+4
xfin_V=find(Vel(:,1)>(tfin_V)); xfin_V=xfin_V(1);

IAE_V=[Ref_Vel(:,1) Ref_Vel(:,2) Vel(:,2) Vel(:,2)*0];

for ii=xini_V:xfin_V
    IAE_V(ii,4)=IAE_V(ii-1,4)+abs(Ref_Vel(ii,2)-Vel(ii,2))*(Ref_Vel(ii,1)-Ref_Vel(ii-1));
end

IAE_V_x_1e4=round(IAE_V(xfin_V,4)*1e4);


%% IAE distancia

aux2=find((ref_dn(:,1)>3)&(ref_dn(:,2)>0.21));
xini_d=aux2(1);
tini_d=ref_dn(xini_d,1)
tfin_d=tini_d+8
xfin_d=find(ref_dn(:,1)>(tfin_d)); xfin_d=xfin_d(1);

IAE_d=[ref_dn(:,1) ref_dn(:,2) distancia(:,2) distancia(:,2)*0];

for ii=xini_d:xfin_d
    IAE_d(ii,4)=IAE_d(ii-1,4)+abs(ref_dn(ii,2)-distancia(ii,2))*(ref_dn(ii,1)-ref_dn(ii-1));
end

IAE_d_x_1e4=round(IAE_d(xfin_d,4)*1e4);


%% IAE curvas

tini_c1=14
tfin_c1=28
tini_c2=38
tfin_c2=52
xini_c1=find(ref_dn(:,1)>(tini_c1)); xini_c1=xini_c1(1);
xini_c2=find(ref_dn(:,1)>(tini_c2)); xini_c2=xini_c2(1);
xfin_c1=find(ref_dn(:,1)>(tfin_c1)); xfin_c1=xfin_c1(1);
xfin_c2=find(ref_dn(:,1)>(tfin_c2)); xfin_c2=xfin_c2(1);

IAE_c=[ref_dn(:,1) ref_dn(:,2) distancia(:,2) distancia(:,2)*0];

for ii=xini_c1:xfin_c1
    IAE_c(ii,4)=IAE_c(ii-1,4)+abs(ref_dn(ii,2)-distancia(ii,2))*(ref_dn(ii,1)-ref_dn(ii-1));
end
for ii=xfin_c1+1:xini_c2-1
    IAE_c(ii,4)=IAE_c(ii-1,4);
end
for ii=xini_c2:xfin_c2
    IAE_c(ii,4)=IAE_c(ii-1,4)+abs(ref_dn(ii,2)-distancia(ii,2))*(ref_dn(ii,1)-ref_dn(ii-1));
end


IAE_c_x_1e4=round(IAE_c(xfin_c2,4)*1e4);


%% Total
IAE_V_completo=IAE_V; IAE_V_completo(xfin_V+1:end,4)=IAE_V_completo(xfin_V,4);
IAE_d_completo=IAE_d; IAE_d_completo(xfin_d+1:end,4)=IAE_d_completo(xfin_d,4);
IAE_c_completo=IAE_c; IAE_c_completo(xfin_c2+1:end,4)=IAE_c_completo(xfin_c2,4);
IAE_suma_x=IAE_V_completo(:,1); IAE_suma_y=IAE_V_completo(:,4)*1e4+IAE_d_completo(:,4)*1e4+IAE_c_completo(:,4)*1e4;
IAE_total=IAE_V_x_1e4+IAE_d_x_1e4+IAE_c_x_1e4;
IAE=[IAE_V_x_1e4 IAE_d_x_1e4 IAE_c_x_1e4 IAE_total];

%% Figuras

Figure_IAE=figure(30);

% Velocidad
subplot(421)
plot(Ref_Vel(:,1),[Ref_Vel(:,2) Vel(:,2)])
title('Velocidad')
grid
subplot(423)
plot(IAE_V(1:xfin_V,1),IAE_V(1:xfin_V,4)*1e4) % Se multiplica por 1e4 por comodidad
grid
title(['IAE_V x 1e4 = ',num2str(IAE_V_x_1e4)])
xlabel('Tiempo (s)')

% Distancia
subplot(422)
plot(ref_dn(:,1),[ref_dn(:,2) distancia(:,2)])
title('Distancia')
grid
subplot(424)
plot(IAE_d(1:xfin_d,1),IAE_d(1:xfin_d,4)*1e4) % Se multiplica por 1e4 por comodidad
grid
title(['IAE_d x 1e4 = ',num2str(IAE_d_x_1e4)])
xlabel('Tiempo (s)')

% Curvas
subplot(425)
plot(ref_dn(:,1),[ref_dn(:,2) distancia(:,2)])
title('Curvas')
grid
subplot(427)
plot(IAE_c(1:xfin_c2,1),IAE_c(1:xfin_c2,4)*1e4) % Se multiplica por 1e4 por comodidad
grid
title(['IAE_c x 1e4 = ',num2str(IAE_c_x_1e4)])
xlabel('Tiempo (s)')

% Total
subplot(426)
title('IAE total')
subplot(428)
plot(IAE_suma_x,IAE_suma_y)
title(['IAE total = ',num2str(round(IAE_suma_y(end)))])
grid
xlabel('Tiempo (s)')

all_ha = findobj(Figure_IAE, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );

end