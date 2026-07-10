function run_part1_continuous()%تست معادلات
p = init();
%تست رفتار مدل بدون کنترل
% Initial conditions (example)
T0 = 20;   
H0 = 55;   
W0 = 50;  
C0 = 420;  
B0 = 1.0;  

x0 = [T0; H0; W0; C0; B0];


tspan = [0 72]; 

[t, X] = ode45(@(t,x) greenhouse_ode(t,x,p), tspan, x0);%معادلات دیفرانسیل رو حل می‌کنه

% Plot
figure; plot(t, X(:,1)); grid on; xlabel('Time (h)'); ylabel('T (°C)'); title('Temperature');
figure; plot(t, X(:,2)); grid on; xlabel('Time (h)'); ylabel('H (%)'); title('Humidity');
figure; plot(t, X(:,3)); grid on; xlabel('Time (h)'); ylabel('W'); title('Soil Moisture');
figure; plot(t, X(:,4)); grid on; xlabel('Time (h)'); ylabel('C (ppm)'); title('CO2');
figure; plot(t, X(:,5)); grid on; xlabel('Time (h)'); ylabel('B (kg)'); title('Biomass');

end