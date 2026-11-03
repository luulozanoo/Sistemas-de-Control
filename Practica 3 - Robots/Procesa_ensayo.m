% Pedir nombre nuevo del fichero con los datos procesados
nombre_fichero=input('Nuevo nombre del fichero ',"s");

% Cargar el fichero sin procesar
load datos_ensayo

AE=0.04;
Vel(:,1)=Vel(:,1)+AE;
Ref_Vel(:,1)=Ref_Vel(:,1)+AE;
uc(:,1)=uc(:,1)+AE;

% Quita saltos hacia atrás en el tiempo (si los hay)

aux = find(diff(Vel(:,1))<0);
for i=1:size(aux,1)
    valor_malo = Vel(aux+1,1);
    ref_anterior = Vel(aux,1);
    Ref_Vel(Vel(:,1)==valor_malo(i),1) = ref_anterior(i) + 0.02;
    uc(Vel(:,1)==valor_malo(i),1) = ref_anterior(i) + 0.02;
    

    ref_angulo(Vel(:,1)==valor_malo(i),1) = ref_anterior(i) + 0.02;
    ud(Vel(:,1)==valor_malo(i),1) = ref_anterior(i) + 0.02;
    ref_dn(Vel(:,1)==valor_malo(i),1) = ref_anterior(i) + 0.02;
    distancia(Vel(:,1)==valor_malo(i),1) = ref_anterior(i) + 0.02;
    angulo(Vel(:,1)==valor_malo(i),1) = ref_anterior(i) + 0.02;

    Vel(Vel(:,1)==valor_malo(i),1) = ref_anterior(i) + 0.02;
end

% Guardar también como time series (TS)
Vel_TS = timeseries(Vel(:,2),Vel(:,1),"Name","Vel_TS");
Ref_Vel_TS = timeseries(Ref_Vel(:,2),Ref_Vel(:,1),"Name","Ref_Vel_TS");
uc_TS = timeseries(uc(:,2),uc(:,1),"Name","uc_TS");
Ref_Vel_TS = timeseries(Ref_Vel(:,2),Ref_Vel(:,1),"Name","Ref_Vel_TS");
uc_TS = timeseries(uc(:,2),uc(:,1),"Name","uc_TS");
ref_dn_TS = timeseries(ref_dn(:,2),ref_dn(:,1),"Name","ref_dn_TS");
distancia_TS = timeseries(distancia(:,2),distancia(:,1),"Name","distancia_TS");
ud_TS = timeseries(ud(:,2),ud(:,1),"Name","ud_TS");
ref_angulo_TS = timeseries(ref_angulo(:,2),ref_angulo(:,1),"Name","ref_angulo_TS");
angulo_TS = timeseries(angulo(:,2),angulo(:,1),"Name","angulo_TS");

% Salva el fichero con nuevo nombre
save(nombre_fichero)

% Figuras con los resultados del ensayo

Plot_ensayo