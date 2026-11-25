%% Velocidad
% Modelo
Km=2.0745e-03;
Tm=6.1095e-02;
D_vel=7.4118e-02;

% Control
K_vel=190;
Ti_vel=0.054;

%% Modelo de distancia y configuración de la simulación

% Modelo planta interna P1(s)

K1=2.8057e-02;
T1=0;       
D=1.5772e-01;


% Modelo planta externa P2(s)

Ref_Vo=0.16
Vo=Ref_Vo; 
  
% Duración de la simulación
tfin=50;
tfin=floor(tfin*0.1/Ref_Vo)

% Referencia
tiempo_step_d=10;    % Instante en el que se produce el escalón de distancia
periodo=60;

tiempo_step_d=floor(tiempo_step_d*0.1/Ref_Vo)
periodo=floor(periodo*0.1/Ref_Vo)

% Perturbación d1: asimetría de los motores
d1=0;

% Curva (perturbación d2)

flag_curva=1    % 0: NO curva / 1: Sí curva

d=0.22;     % consigna de distancia
x1=2;    % distancia hasta la curva, empezando en la junta antes de la de bajada
r=0.52;     % radio de la curva
x2=pi*(r-d);    % distancia recorrida en la curva
t_ini_curva=x1/Ref_Vo;   % tiempo hasta llegar a la curva
t_fin_curva=t_ini_curva+x2/Ref_Vo;  % tiempo en el que termina la curva


%% Control del lazo interno

Kint=80;    

%% Control del lazo externo

Kext=18;
Ti=5;
Td=0.0;
b=0.75;   
N=8;


%% Pintar simulación
ts=0.02;
sim('simula_distancia2026')

Figure_Simu_d = figure(1);
subplot(3,1,1)
plot(ref_dn_S(:,1),ref_dn_S(:,2),'b', distancia_S(:,1),distancia_S(:,2), 'r')
    xlabel('Tiempo (s)')
    legend('Ref distancia', 'Distancia simulada')
    grid
subplot(3,1,2)
plot(ref_ang_S_sin_limite(:,1),ref_ang_S_sin_limite(:,2)*180/pi,'k',ref_angulo_S(:,1),ref_angulo_S(:,2),'b', angulo_S(:,1),angulo_S(:,2), 'r')
    xlabel('Tiempo (s)')
    title('Control en lazo cerrado')
    legend('Ref angulo sin saturar', 'Ref angulo', 'Ángulo simulado')
    grid
subplot(3,1,3)
plot(ud_S(:,1),ud_S_sin_limite(:,2),'k', ud_S(:,1),ud_S(:,2), 'r')
    xlabel('Tiempo (s)')
    legend('Ud simulada sin límite','Ud simulada')
    grid
all_ha = findobj(Figure_Simu_d, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );