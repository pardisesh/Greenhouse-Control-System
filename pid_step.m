function [u, pid] = pid_step(e, pid, gains, dt, u_lim)
% PID_STEP  Discrete PID controller with saturation
%بخش انتگرال
pid.I = pid.I + e*dt; %جمع کردن خطا در طول زمان
D = (e - pid.e_prev)/dt;%نرخ تغییر خطا

u = gains.Kp*e + gains.Ki*pid.I + gains.Kd*D;

% Saturation
u = max(u_lim(1), min(u_lim(2), u));%خروجی نامحدود تولید نشه
pid.e_prev = e;%ذخیره خطای فعلی
end