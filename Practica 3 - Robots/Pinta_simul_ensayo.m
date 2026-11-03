% Cargar un ensayo
% Hacer una simulación con los mismos parámetros de control


Figure_Ensayo_v = figure(2);
subplot(2,1,1)
plot(Ref_Vel(:,1),Ref_Vel(:,2),'k', Vel(:,1),Vel(:,2), 'b', Ref_Vel_S(:,1),Ref_Vel_S(:,2), 'r',Vel_S(:,1),Vel_S(:,2), 'r')
    xlabel('Tiempo (s)')
    title('Control en lazo cerrado')
    legend('Ref velocidad', 'Velocidad medida','Velocidad simulada')
    grid
subplot(2,1,2)
plot(uc(:,1),uc(:,2),'b',uc_S(:,1),uc_S(:,2), 'r')
    xlabel('Tiempo (s)')
    legend('Uc','Uc simulado')
    grid
all_ha = findobj(Figure_Ensayo_v, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );