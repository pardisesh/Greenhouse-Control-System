function p = init_part4()
% INIT_PART4  Part 4 parameters (extends Part 3)

p = init_part3();  % استفاده ار مقادیر بخش 3

% Water model assumptions
p.irrig_L_per_unit = 10;  % کنترل مصرف واقعی اب
p.tank_capacity_L  = 500; % حداکثر ظرفیت مخزن
p.tank_init_L      = 200; % initial water stored




% Energy model assumptions 
p.heater_kW_per_unit = 1.2;  % kW per heater unit
p.humid_kW_per_unit  = 0.6;  % kW per humidifier unit
p.co2_kW_per_unit    = 0.2;  % kW per CO2 injection unit

% ventilation fan energy when ON
p.vent_kW = 0.3;            % kW when ventilation ON

end