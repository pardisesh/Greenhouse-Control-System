function x_next = greenhouse_step_euler(x, p, dt)
% سیستم در گام بعدی چه حالتی داره

dx = greenhouse_ode(0, x, p); % محاسبه نرخ تغییرات با استفاده از مدل دینامیکی
x_next = x + dt * dx;%به‌روزرسانی حالت‌ها با روش اویلر

end 