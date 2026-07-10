function p = init_part3()
% INIT_PART3  Parameters for Part 3: Control Design

% ===== Setpoints =====
p.Tsp = 24;     
p.Hsp = 65;     
p.Wsp = 60;     
p.Csp = 800;    

% ===== Outside conditions =====
p.Tout = 18;
p.Hout = 50;
p.Cout = 420;

% ===== Linear model parameters =====
p.aT = 0.20;  p.bT = 0.50;  p.dT = 0.10;
p.aH = 0.15;  p.bH = 0.40;  p.cHW = 0.05;  p.dH = 0.0;
p.aW = 0.10;  p.bW = 1.00;  p.dW = 0.0;
p.aC = 0.12;  p.bC = 20.0;  p.cCB = 1.0;   p.dC = p.aC*p.Cout;
p.aB = 0.02;  p.kT = 0.001; p.kH = 0.0003; p.kC = 0.00001; p.dB = 0.0;

% ===== PID gains =====
p.pidT = struct('Kp',0.8,'Ki',0.10,'Kd',0.0);%کنترل‌کننده دما رو تنظیم می‌کنه
p.pidH = struct('Kp',0.6,'Ki',0.08,'Kd',0.0);%کاهش نوسان.حذف خطای ماندگار.واکنش سریع
p.pidC = struct('Kp',0.05,'Ki',0.01,'Kd',0.0);

% ===== Actuator limits =====
p.uT_lim = [0 5];
p.uH_lim = [0 5];
p.uC_lim = [0 10];
p.uW_lim = [0 5];

% ===== Relay thresholds (hysteresis) =====
p.W_low  = 55;%زیر 55 ابیاری روشن
p.W_high = 65;%بالای 65 ابیاری خاموش
p.C_low  = 900;%حدهای تهویه برای CO2
p.C_high = 1200;

% ===== Ventilation effect =====هرچی بیشتر تهویه قوی تر
p.kVentH = 0.20;
p.kVentC = 0.30;

end