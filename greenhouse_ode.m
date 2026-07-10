function dx = greenhouse_ode(t, x, p)%این فایل بدون هیچی کنترلیه

%استخراج متغیرهای حالت
T = x(1);%دما
H = x(2);%هوا رطوبت 
W = x(3);%رطوبت خاک
C = x(4);%غلظت co2
B = x(5);%رشد گیاه
%استخراج ورودی‌های کنترلی
u = p.u_const;%ورودی‌های ثابت
uT = u(1);
uH = u(2);
uW = u(3);%ورودی آبیاری
uC = u(4);%ورودی تزریق CO2

% 1) Temperature
dT = -p.aT*(T - p.Tout) + p.bT*uT + p.dT;%دما به سمت دمای بیرون میره هیتر زیادش میکنه 

% 2) Humidity (coupled with soil moisture W)
dH = -p.aH*H + p.bH*uH + p.cHW*W + p.dH;

% 3) Soil moisture
dW = -p.aW*W + p.bW*uW + p.dW;

% 4) CO2 (coupled with biomass B)
dC = -p.aC*C + p.bC*uC - p.cCB*B + p.dC;

% 5) Biomass (depends on T,H,C and itself)
dB = p.aB*B + p.kT*T + p.kH*H + p.kC*C + p.dB;%رشد گیاه به دما رطویت و co2 

dx = [dT; dH; dW; dC; dB];%نرخ تغییر همه متغیرها
end