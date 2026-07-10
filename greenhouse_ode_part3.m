function dx = greenhouse_ode_part3(~, x, p, u, v)

% x = [T; H; W; C; B]حالت سیستم
% u = [uT; uH; uW; uC]خروجی کنترلر (PID)
% v = ventilation relay (0 or 1)

T = x(1); H = x(2); W = x(3); C = x(4); B = x(5);
uT = u(1); uH = u(2); uW = u(3); uC = u(4);

% Temperatureنرخ تغییر دما
dT = -p.aT*(T - p.Tout) + p.bT*uT + p.dT;%دما به تهویه وابسته نشده

% Humidity
dH = -p.aH*H + p.bH*uH + p.cHW*W ...
     - v*p.kVentH*(H - p.Hout);%اگر تهویه روشن باشه رطویت به بیرون میره

% Soil moisture
dW = -p.aW*W + p.bW*uW + p.dW;

% CO2
dC = -p.aC*C + p.bC*uC - p.cCB*B + p.dC ...
     - v*p.kVentC*(C - p.Cout);%اگر تهویه روشن باشه co2 خارج میشه

% Biomass
dB = p.aB*B + p.kT*T + p.kH*H + p.kC*C + p.dB;%رشد به شرایط محیطی وابسته

dx = [dT; dH; dW; dC; dB];
end