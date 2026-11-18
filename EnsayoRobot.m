function EnsayoRobot(DOMAIN_ID)

clc

% Señal de referencia velocidad
upper_value = 0.1;
lower_value = 0.1;
period = 10.0;      % en tiempo
phase_delay = 5.0;  % en tiempo
duty_cycle = 50.0;  % en % del periodo

% Señal de referencia distancia a pared
upper_value_dn = 0.22;
lower_value_dn = 0.2;
period_dn = 60.0;      % en tiempo
phase_delay_dn = 10.0;  % en tiempo
duty_cycle_dn = 50.0;  % en % del periodo

% Configuración general del ensayo
test_duration = 70.0;
publish_rate = 50.0;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % REFERENCIAS PARA LA COMPETICIÓN FINAL %%%%%%%%%%
% % Señal de referencia velocidad
% upper_value = 0.1;
% lower_value = 0.13;
% period = 200.0;      % en tiempo
% phase_delay = 30.0;  % en tiempo
% duty_cycle = 1.0;  % en % del periodo
% 
% % Señal de referencia distancia a pared
% upper_value_dn = 0.22;
% lower_value_dn = 0.2;
% period_dn = 400.0;      % en tiempo
% phase_delay_dn = 5.0;  % en tiempo
% duty_cycle_dn = 1.0;  % en % del periodo
% 
% % Configuración general del ensayo
% test_duration = 55.0;
% publish_rate = 50.0;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Definir aquí los parámetros del control de velocidad. 
%¡Muy importante poner los decimales en todos!

K = 190;
Ti = 0.054;
Td = 0.012;   % Td=0.0 si no se usa acción diferencial
b = 1.0;    % b=1.0 si no se usa ponderación de la referencia
N = 3.0;
DS = 0.0;   % DS=1 diferencial a la salida / DS=0 diferencial al error
K= K/30.3;  % Conversión de rad/s a m/s

%Definir aquí los parámetros del control de seguimiento de pared. 
%¡Muy importante poner los decimales en todos!

%Control interno
Kinterno = 100;   % <0 si avance con ruedas delante
Tiinterno = inf;    % Ti=inf si no se usa acción integral
Tdinterno = 0.0;    % Td=0.0 si no se usa acción diferencial
binterno = 1.0;     % b=1.0 si no se usa ponderación de la referencia
Ninterno = 8.0;
DSinterno = 1.0;    % DS=1 diferencial a la salida / DS=0 diferencial al error

% Control externo
Kexterno = 20.0;    % avance con ruedas delante
Tiexterno = inf;    %Ti=inf si no se usa acción integral
Tdexterno = 0.0;    % Td=0.0 si no se usa acción diferencial
bexterno = 1;     % b=1.0 si no se usa ponderación de la referencia
Nexterno = 8.0;
DSexterno = 1.0;    % DS=1 diferencial a la salida / DS=0 diferencial al error


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf("Inicio de configuración\n")

ip = char("192.168.0." + string(DOMAIN_ID));
% Buscar si empieza en el valor bajo o alto
double integral_ini;
if (1.0 - phase_delay_dn / period_dn) > (duty_cycle_dn / 100.0)
    integral_ini = (1-bexterno) * lower_value_dn * Kexterno;
else
    integral_ini = (1-bexterno) * upper_value_dn * Kexterno;
end


% [no_error, device] = ConexionControlInterno(ip, DOMAIN_ID);
% if(no_error == 0)
%     return
% end

% nodeParams.Kinterno = double(Kinterno);
% nodeParams.Tiinterno = double(Tiinterno);
% nodeParams.Tdinterno = double(Tdinterno);
% nodeParams.binterno = double(binterno);
% nodeParams.Ninterno = double(Ninterno);
% nodeParams.DSinterno = double(DSinterno);
% nodeParams.Kexterno = double(Kexterno);
% nodeParams.Tiexterno = double(Tiexterno);
% nodeParams.Tdexterno = double(Tdexterno);
% nodeParams.bexterno = double(bexterno);
% nodeParams.Nexterno = double(Nexterno);
% nodeParams.DSexterno = double(DSexterno);
% 
% nodeParams.K = double(K);
% nodeParams.Ti = double(Ti);
% nodeParams.Td = double(Td);
% nodeParams.b = double(b);
% nodeParams.N = double(N);
% nodeParams.DS = double(DS);
% 
% NodeList = ros2("node","list");
% NodoControl = NodeList{find(contains(NodeList,'/ControlCombinadoNode'))};
% ControlNode = ros2node(NodoControl,DOMAIN_ID,Parameters=nodeParams);

%Para cerrar todo correctamente en caso de ctrl+c y fin de ensayo normal
%cleanupObj = onCleanup(@()cleanMeUp(device, ControlNode));

paramObjVel = ros2param('velocity_controller',DomainID=DOMAIN_ID);
paramObjWF = ros2param('wf_controller',DomainID=DOMAIN_ID);
paramObj2 = ros2param('reference_generator',DomainID=DOMAIN_ID);

fprintf("Envío de parámetros\n")
pause(5);

set(paramObjWF, "pid_angle.Kp", double(Kinterno));
set(paramObjWF, "pid_angle.Ti", double(Tiinterno));
set(paramObjWF, "pid_angle.Td", double(Tdinterno));
set(paramObjWF, "pid_angle.b", double(binterno));
set(paramObjWF, "pid_angle.N", double(Ninterno));
set(paramObjWF, "pid_angle.td_to_error", not(boolean(DSinterno)));
set(paramObjWF, "pid_distance.Kp", double(Kexterno));
set(paramObjWF, "pid_distance.Ti", double(Tiexterno));
set(paramObjWF, "pid_distance.Td", double(Tdexterno));
set(paramObjWF, "pid_distance.b", double(bexterno));
set(paramObjWF, "pid_distance.N", double(Nexterno));
set(paramObjWF, "pid_distance.td_to_error", not(boolean(DSexterno)));
set(paramObjWF, "pid_distance.initial_integral", double(integral_ini));
set(paramObjVel, "pid.Kp", double(K));
set(paramObjVel, "pid.Ti", double(Ti));
set(paramObjVel, "pid.Td", double(Td));
set(paramObjVel, "pid.b", double(b));
set(paramObjVel, "pid.N", double(N));
set(paramObjVel, "pid.td_to_error", not(boolean(DS)));
pause(2);

set(paramObj2, "upper_value", double(upper_value));
set(paramObj2, "lower_value", double(lower_value));
set(paramObj2, "period", double(period));
set(paramObj2, "phase_delay", double(phase_delay));
set(paramObj2, "duty_cycle", double(duty_cycle));
set(paramObj2, "upper_value_dn", double(upper_value_dn));
set(paramObj2, "lower_value_dn", double(lower_value_dn));
set(paramObj2, "period_dn", double(period_dn));
set(paramObj2, "phase_delay_dn", double(phase_delay_dn));
set(paramObj2, "duty_cycle_dn", double(duty_cycle_dn));
set(paramObj2, "test_duration", double(test_duration));
set(paramObj2, "publish_rate", double(publish_rate));
pause(2)

fprintf("Inicio del ensayo:\n")
start_node=ros2node("start_node",DOMAIN_ID);
start_cli=ros2svcclient(start_node,"start_on","std_srvs/Trigger");
pause(1)
response = call(start_cli);
disp(response.message);
if not(response.success)
    fprintf("Ensayo cancelado")
    return
end

    
    pause(test_duration + 3);
    
    addr = char("http://" + ip + ":8080/datos_ensayo.mat");
    websave('datos_ensayo.mat', addr);

    % Verificar que se descargó correctamente
    if exist('datos_ensayo.mat', 'file')
        fprintf('Archivo descargado exitosamente\n');
    else
        error('Error descargando el archivo');
    end
end