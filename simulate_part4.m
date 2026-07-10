function out = simulate_part4(p, N, dt)
%کل سیستم رو شبیه‌سازی می‌کنه + مصرف آب و انرژی رو حساب می‌کنه


x = [20; 55; 50; 420; 1.0]; % [T H W C B]

pidT = struct('I',0,'e_prev',0);
pidH = struct('I',0,'e_prev',0);
pidC = struct('I',0,'e_prev',0);

irrig = 0;
vent  = 0;
%ذخیره حالت‌ها، کنترل‌ها و تهویه
X = zeros(N+1,5); X(1,:) = x.';
U = zeros(N,4);
V = zeros(N,1);

tank = p.tank_init_L;
tank_log = zeros(N+1,1); tank_log(1)=tank;

total_irrig_L = 0;
recycled_L    = 0;

energy_kWh = 0;

for k = 1:N%حرکت در زمان
    T = x(1); H = x(2); W = x(3); C = x(4);%استخراج حالت

    % PIDکنترل هیتر.رطوبت ساز.تزریق
    [uT, pidT] = pid_step(p.Tsp - T, pidT, p.pidT, dt, p.uT_lim);
    [uH, pidH] = pid_step(p.Hsp - H, pidH, p.pidH, dt, p.uH_lim);
    [uC, pidC] = pid_step(p.Csp - C, pidC, p.pidC, dt, p.uC_lim);

    % Relay irrigation
    irrig = relay_hyst(W, irrig, p.W_low, p.W_high);
    uW = irrig * p.uW_lim(2);%اگر روشن باشه حداکثر ابیاری

    % Relay ventilation (CO2 high)
    if C > p.C_high%اگز CO2 زیاد باشه روشن
        vent = 1;
    elseif C < p.C_low
        vent = 0;
    end

    u = [uT; uH; uW; uC];

    % ===== Water accounting =====
    % Rain goes into tank
    tank = min(p.tank_capacity_L, tank + p.rain_Lph * dt);

    irrigDemand_L = uW * p.irrig_L_per_unit * dt; % تبدیل خروجی کنترل به لیتر
    total_irrig_L = total_irrig_L + irrigDemand_L;

    fromTank = min(tank, irrigDemand_L);
    tank = tank - fromTank;
    recycled_L = recycled_L + fromTank;

    % Remaining comes from freshwater
    % freshwater = irrigDemand_L - fromTank 

    % ===== Energy accounting (kWh) =====
    PkW = uT*p.heater_kW_per_unit + uH*p.humid_kW_per_unit + uC*p.co2_kW_per_unit + vent*p.vent_kW;
    energy_kWh = energy_kWh + PkW * dt;

    % ===== State update =====
    dx = greenhouse_ode_part3(0, x, p, u, vent);
    x  = x + dt*dx;%اویلر حالت جدید رو حساب میکنه

    % logs
    X(k+1,:) = x.';
    U(k,:) = u.';
    V(k) = vent;
    tank_log(k+1)=tank;
end

B0 = X(1,5);
Bf = X(end,5);
biomass_yield = max(0, Bf - B0); % میزان رشد

water_saving = recycled_L / max(total_irrig_L, eps);
energy_eff   = biomass_yield / max(energy_kWh, eps);

out.X = X; out.U = U; out.V = V;
out.tank = tank_log;
out.total_irrig_L = total_irrig_L;
out.recycled_L = recycled_L;
out.freshwater_L = total_irrig_L - recycled_L;
out.energy_kWh = energy_kWh;
out.biomass_yield = biomass_yield;
out.water_saving = water_saving;
out.energy_eff = energy_eff;
end