function run_part3_control()%اضافه کردن کنترل و سیستم خودش تصمیم میگیره چیکار کنه
p = init_part3();

dt = 1.0;   % hour
N  = 72;    % 72 hours

% Initial state [T H W C B]
x = [20; 55; 50; 420; 1.0];

% PID states
pidT = struct('I',0,'e_prev',0);
pidH = struct('I',0,'e_prev',0);
pidC = struct('I',0,'e_prev',0);

% Relay states
irrig = 0;   
vent  = 0;   

% Logsذخیره نتایج
X = zeros(N+1,5); X(1,:) = x.';%حالت ها
U = zeros(N,4);%کنترل ها
V = zeros(N,1);%تهویه

for k = 1:N
    T = x(1); H = x(2); W = x(3); C = x(4);

    % PID control 
    [uT, pidT] = pid_step(p.Tsp - T, pidT, p.pidT, dt, p.uT_lim);%
    [uH, pidH] = pid_step(p.Hsp - H, pidH, p.pidH, dt, p.uH_lim);
    [uC, pidC] = pid_step(p.Csp - C, pidC, p.pidC, dt, p.uC_lim);

    % Relay irrigation 
    irrig = relay_hyst(W, irrig, p.W_low, p.W_high);
    uW = irrig * p.uW_lim(2);%تبدیل ON/OFF به مقدار واقعی آبیاری

    % Relay ventilation 
    if C > p.C_high%اگر co2 زیاد تهویه روشن
        vent = 1;
    elseif C < p.C_low
        vent = 0;
    end

    u = [uT; uH; uW; uC];

    % Discrete update
    dx = greenhouse_ode_part3(0, x, p, u, vent);
    x  = x + dt*dx;%آپدیت Euler

    % Logs
    X(k+1,:) = x.';
    U(k,:) = u.';
    V(k) = vent;
end

t = 0:dt:N*dt;

% ===== Plots: states =====
labels = ["T (°C)","H (%)","W","C (ppm)","B (kg)"];
for i=1:5
    figure; plot(t, X(:,i),'LineWidth',1.5); grid on;%سیستم به هدف رسیده یا نه
    xlabel('Time (h)'); ylabel(labels(i));
    title("Closed-loop state: " + labels(i));
end

% ===== Plots: controls =====
tu = (1:N)*dt;
figure; plot(tu,U(:,1),'LineWidth',1.5); grid on; title('Heater uT');
figure; plot(tu,U(:,2),'LineWidth',1.5); grid on; title('Humidifier uH');
figure; plot(tu,U(:,4),'LineWidth',1.5); grid on; title('CO2 Injection uC');
figure; stairs(tu,U(:,3),'LineWidth',1.5); grid on; title('Irrigation uW (Relay)');
figure; stairs(tu,V,'LineWidth',1.5); grid on; title('Ventilation (Relay)');

end