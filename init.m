function p = init()
% این فایل پارامترهای مدل خطی گلخانه را تعریف می‌کند.

% Setpoints (example)
p.Tsp = 24;    
p.Hsp = 65;    
p.Wsp = 60;   
p.Csp = 800;   

% Outside / baseline conditions (disturbance references) 
p.Tout = 18;   
p.Hout = 50;   
p.Cout = 420;  

% Linear dynamics coefficients (tunable placeholders) 
% Temperature: dT = -aT*(T - Tout) + bT*uT + dT
p.aT = 0.20;   % اتلاف حرارت
p.bT = 0.50;   %اثر هیتر
p.dT = 0.10;   %اثر بیرونی

% Humidity: dH = -aH*H + bH*uH + cHW*W + dH
p.aH  = 0.15;  %کاهش طبیعی رطوبت
p.bH  = 0.40;  % اثر humidifier
p.cHW = 0.05;  % رطوبت خاک روی رطوبت هوا اثر داره
p.dH  = 0.00;  % اغتشاش رطوبت

% Soil moisture: dW = -aW*W + bW*uW + dW
p.aW = 0.10;   %خشک شدن طبیعی خاک
p.bW = 1.00;   % اثر آبیاری
p.dW = 0.00;   %اغتشاش خاک

% CO2: dC = -aC*C + bC*uC - cCB*B + dC
p.aC  = 0.12;%کاهش طبیعی CO2
p.bC  = 20.0;%اثر تزریق CO2
p.cCB = 1.00;%مصرف CO2 توسط گیاه
p.dC  = p.aC * p.Cout;  % اگه co2 کنترل نشه به بیرون برمیگرده

% Biomass: dB = aB*B + kT*T + kH*H + kC*C + dB
% (All linear; you can tune to match expected growth speed.)
p.aB = 0.02;   %رشد طبیعی گیاه
p.kT = 0.001;  % اثر دما روی رشد
p.kH = 0.0003; % اثر رطوبت روی رشد
p.kC = 0.00001;% اثر CO2 روی رشد
p.dB = 0.0;    % اغتشاش رشد

% ----- Control inputs (for Part 1 we can keep them constant) -----
% u = [uT uH uW uC]
p.u_const = [1.0; 0.5; 0.3; 0.8];

end