/*
Same Code as DYNACODE.mod except psi=2.75 instead of 1.75 (Increasing the weight of disutility of labor
*/
//Variables and Parameters
var y c k i l y_l w r ;
varexo z;
parameters beta psi delta alpha sigma epsilon;
alpha = 0.33;
beta = 0.99;
psi = 2.75;
delta = 0.025;
sigma = (0.007/(1-alpha));
epsilon = 10;

//RBC Model Specification
model;
(1/c) = beta*(1/c(+1))*(1+r(+1)-delta);
psi*c/(1-l) = w;
c+i = y;
y = (k(-1)^alpha)*(exp(z)*l)^(1-alpha);
w = y*((epsilon-1)/epsilon)*(1-alpha)/l;
r = y*((epsilon-1)/epsilon)*alpha/k(-1);
i = k-(1-delta)*k(-1);
y_l = y/l;
end;

//Initial Values
initval;
k = 9;
c = 0.76;
l = 0.3;
w = 2.07;
r = 0.03;
z = 0;
end;

steady;
check;

//Technology Shocks: zt = .1 for periods 1-5
shocks;
var z;
periods 1:5;
values 0.1;
end;

//Simulate for 100 periods
perfect_foresight_setup(periods=100);
perfect_foresight_solver;