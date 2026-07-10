function run_part2_discrete()%تست مدل گسسته
p = init();

% Initial conditions (same as part 1)
x0 = [20; 55; 50; 420; 1.0];
%x0=[tempteture,humidity,soil humidity,co2,biomass]
dt = 1.0;          % 1 hour
N  = 72;           % 72 steps = 72 hours
t_disc = (0:N) * dt;
%ذخیره نتایج گسسته
Xdisc = zeros(N+1, 5);%ماتریس ذخیره حالت‌های گسسته
Xdisc(1,:) = x0.';

% Euler simulation 
x = x0;
for k = 1:N
    x = greenhouse_step_euler(x, p, dt);
    Xdisc(k+1,:) = x.';
end

% ---- Continuous simulation (ode45) for comparison ----
tspan = [0 N*dt];
[t_cont, Xcont] = ode45(@(t,x) greenhouse_ode(t,x,p), tspan, x0);

% ---- Plot comparisons 
names = ["Temperature T (°C)", "Humidity H (%)", "Soil Moisture W", "CO2 C (ppm)", "Biomass B (kg)"];
ylabs = ["T", "H", "W", "C", "B"];

for i = 1:5
    figure;
    plot(t_cont, Xcont(:,i), '-', 'LineWidth', 1.5); hold on;%پیوسته
    plot(t_disc, Xdisc(:,i), 'o', 'LineWidth', 1.0);%گسسته
    grid on;
    xlabel('Time (h)');
    ylabel(ylabs(i));
    title("Continuous vs Euler (dt=1h): " + names(i));
    legend('ode45 (continuous)', 'Euler (discrete)', 'Location', 'best');
end

% ---- Simple numeric consistency check at final time ----
final_cont = interp1(t_cont, Xcont, N*dt);   % continuous value at 72h
final_disc = Xdisc(end,:);%آخرین مقدار Euler
err = final_disc - final_cont;%اختلاف واقعی رو حساب می‌کنه

disp("Final state at 72h (Euler)    : " + mat2str(final_disc,4));
disp("Final state at 72h (ode45)    : " + mat2str(final_cont,4));
disp("Difference (Euler - ode45)    : " + mat2str(err,4));
%اگر خطا کم باشد اویلر خوب کار کرده و با کوچک کردن dt خطا کمتر میشه
end