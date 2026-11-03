function [IAE_x_1e4] = Calculo_IAE_mod_velocidad(Ref_Vel,Vel)

aux1=find((Ref_Vel(:,1)>6)&(Ref_Vel(:,2)<0.13));
x1=aux1(1);
aux2=find((Ref_Vel(:,1)>13)&(Ref_Vel(:,2)>0.13));
x2=aux2(1);

t1=Ref_Vel(x1,1)
t2=Ref_Vel(x2,1)

%t1=10; t2=20;

% x1=find(Vel(:,1)>t1); x1=x1(1);
% x1fin=find(Vel(:,1)>(t1+1.5)); x1fin=x1fin(1);
% x2=find(Vel(:,1)>t2); x2=x2(1);
% x2fin=find(Vel(:,1)>(t2+1.5)); x2fin=x2fin(1);
% xfin=length(Vel(:,1));

x1fin=find(Vel(:,1)>(t1+1.5)); x1fin=x1fin(1);
x2fin=find(Vel(:,1)>(t2+1.5)); x2fin=x2fin(1);
xfin=length(Vel(:,1));

IAE=[Ref_Vel(:,1) Ref_Vel(:,2) Vel(:,2) Vel(:,2)*0];

for ii=x1:x1fin
    IAE(ii,4)=IAE(ii-1,4)+abs(Ref_Vel(ii,2)-Vel(ii,2))*(Ref_Vel(ii,1)-Ref_Vel(ii-1));
end
for ii=x1fin+1:x2-1
    IAE(ii,4)=IAE(ii-1,4);
end
for ii=x2:x2fin
    IAE(ii,4)=IAE(ii-1,4)+abs(Ref_Vel(ii,2)-Vel(ii,2))*(Ref_Vel(ii,1)-Ref_Vel(ii-1));
end
for ii=x2fin+1:xfin
    IAE(ii,4)=IAE(ii-1,4);
end

IAE_x_1e4=round(IAE(xfin,4)*1e4)

Figure_IAE=figure(30);
subplot(211)
plot(Ref_Vel(:,1),[Ref_Vel(:,2) Vel(:,2)])
title('Velocidad')
grid
subplot(212)
plot(IAE(1:xfin,1),IAE(1:xfin,4)*1e4) % Se multiplica por 1000 por comodidad
grid
title(['IAE x 1e4 = ',num2str(IAE_x_1e4)])
xlabel('Tiempo (s)')
all_ha = findobj(Figure_IAE, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );

end