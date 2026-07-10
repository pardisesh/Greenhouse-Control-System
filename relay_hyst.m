function r = relay_hyst(value, r_prev, low, high)
% RELAY_HYST  Relay with hysteresis
%از هیسترزن استفاده کردم برای جلوگیری از سریع خاموش روشن شدن
r = r_prev;
if value < low
    r = 1;%ابیاری روشن
elseif value > high
    r = 0;
end
end