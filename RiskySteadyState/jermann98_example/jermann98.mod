// This is the Ramsey model with adjustment costs.  Jermann(1998),JME 41, pages 257-275
// Olaf Weeken
// Bank of England, 13 June, 2005
// modified January 20, 2006 by Michel Juillard

//---------------------------------------------------------------------
// 1. Variable declaration
//---------------------------------------------------------------------

var c, d, i, k, r1, rf1, w, y, z, mu, erp1; 
varexo ez;                          

//---------------------------------------------------------------------
// 2. Parameter declaration and calibration
//---------------------------------------------------------------------

parameters alf, chihab, xi, delt, tau, g, rho, a1, a2, betstar, bet, stdez;

alf        = 0.36;    %// capital share in production function
chihab     = 0.819;   %// habit formation parameter
xi         = 1/4.3;   %// capital adjustment cost parameter
delt       = 0.025;   %// quarterly deprecition rate
g          = 1.005;   %//quarterly growth rate (note zero growth =>g=1)
tau        = 5;       %// curvature parameter with respect to c
rho        = 0.95;    %// AR(1) parameter for technology shock
stdez      = 0.01;
a1         = (g-1+delt)^(1/xi);             
a2         = (g-1+delt)-(((g-1+delt)^(1/xi))/(1-(1/xi)))*((g-1+delt)^(1-(1/xi))); 
betstar    = g/1.011138;
bet        = betstar/(g^(1-tau));             

//---------------------------------------------------------------------
// 3. Model declaration
//---------------------------------------------------------------------

model;  
g*k  = (1-delt)*k(-1) + ((a1/(1-1/xi))*(g*i/k(-1))^(1-1/xi)+a2)*k(-1);
d    = y - w - i; 
w    = (1-alf)*y;
y    = z*g^(-alf)*k(-1)^alf;
c    = w + d; 
mu   = (c-chihab*c(-1)/g)^(-tau)-chihab*bet*(c(+1)*g-chihab*c)^(-tau);
mu   = (betstar/g)*mu(+1)*(a1*(g*i/k(-1))^(-1/xi))*(alf*z(+1)*g^(1-alf)*
       (k^(alf-1))+((1-delt+(a1/(1-1/xi))*(g*i(+1)/k)^(1-1/xi)+a2))/
       (a1*(g*i(+1)/k)^(-1/xi))-g*i(+1)/k);
log(z) = rho*log(z(-1)) - 1 * ez;

rf1  = 1/expectation(0)((betstar/g)*mu(+1)/mu);
r1   = (a1*(g*i/k(-1))^(-1/xi))*(alf*z(+1)*g^(1-alf)*(k^(alf-1))+
       (1-delt+(a1/(1-1/xi))*(g*i(+1)/k)^(1-1/xi)+a2)/
       (a1*(g*i(+1)/k)^(-1/xi))-g*i(+1)/k);
erp1 = r1 - rf1;

end;


//---------------------------------------------------------------------
// 4. Initial values and steady state
//---------------------------------------------------------------------


//---------------------------------------------------------------------
// 5. Shock declaration  
//                       
//---------------------------------------------------------------------

shocks;
var ez; stderr stdez;  
end;

M_.risky_steadystate = 1; 
stoch_simul(order=2);
