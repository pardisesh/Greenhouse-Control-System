function run_part4_scenarios()%تحلیل نهایی
p = init_part4();

dt = 1.0;
N  = 72;

% Rain scenarios (liters/hour)
scNames = ["No rain", "Low rain", "High rain"];
scRain  = [0, 5, 15];

results = zeros(numel(scRain), 6);%ماتریس ذخیره نتایج
% cols: rain, total_irrig, recycled, freshwater, energy, biomassYield

outs = cell(numel(scRain),1);

for i=1:numel(scRain)
    p.rain_Lph = scRain(i);%تنظیم میزان بارش
    out = simulate_part4(p, N, dt);
    outs{i} = out;

    results(i,:) = [p.rain_Lph, out.total_irrig_L, out.recycled_L, out.freshwater_L, out.energy_kWh, out.biomass_yield];

    fprintf("\nScenario: %s | rain=%.1f L/h\n", scNames(i), p.rain_Lph);
    fprintf("Total irrigation: %.1f L\n", out.total_irrig_L);
    fprintf("Recycled water : %.1f L (saving=%.1f%%)\n", out.recycled_L, 100*out.water_saving);
    fprintf("Freshwater used: %.1f L\n", out.freshwater_L);
    fprintf("Energy used    : %.2f kWh\n", out.energy_kWh);
    fprintf("Biomass yield  : %.3f kg\n", out.biomass_yield);
    fprintf("Energy efficiency: %.4f kg/kWh\n", out.energy_eff);
end

% ---- Simple plots ----
t = 0:dt:N*dt;

% Tank level comparisonمقدار آب مخزن رو رسم
figure; hold on; grid on;
for i=1:numel(scRain)
    plot(t, outs{i}.tank, 'LineWidth', 1.5);
end
xlabel('Time (h)'); ylabel('Tank water (L)');
title('Rainwater Tank Level (Scenarios)');
legend(scNames, 'Location','best');

% Biomass comparisonبارش روی رشد خیلی تاثیر نداره
figure; hold on; grid on;
for i=1:numel(scRain)
    plot(t, outs{i}.X(:,5), 'LineWidth', 1.5);
end
xlabel('Time (h)'); ylabel('Biomass B (kg)');
title('Biomass Growth (Scenarios)');
legend(scNames, 'Location','best');

% Print a compact table
disp(" ");
disp("Table columns: [rain_Lph  totalIrr_L  recycled_L  freshwater_L  energy_kWh  biomassYield_kg]");
disp(results);

end