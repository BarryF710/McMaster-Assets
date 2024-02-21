*ChE 4G03 Tutorial 4 SOLUTION 2023

SETS
t    Time points / 0*8 / ;


PARAMETERS
S    Sales in week t
/ 0   0
  1   600
  2   750
  3   1200
  4   2100
  5   2250
  6   180
  7   330
  8   540   /

R    Receivables in week t
/ 0   0
  1   770
  2   1260
  3   1400
  4   1750
  5   2800
  6   4900
  7   5250
  8   420   /

P    Payables in week t
/ 0   0
  1   3200
  2   5600
  3   6000
  4   480
  5   880
  6   1440
  7   1600
  8   2000  /

E    Expenses in week t
/ 0   0
  1   350
  2   400
  3   550
  4   940
  5   990
  6   350
  7   350
  8   410   /  ;


VARIABLES
ntc     Objective function for net total cost ;

POSITIVE VARIABLES
g(t)    Amount of debt borrowed in week t
h(t)    Amount of debt paid off in week t
w(t)    Delayed payments in week t
x(t)    Amount invested in week t
y(t)    Cumulative debt in week t
z(t)    Cash on hand in week t                ;



EQUATIONS
Objective        Objective: minimize net total cost
Balance1         Account balance for periods 4...8
Balance2         Account balance for periods 1...3
UpdateDebt       Debt balance for each period
DebtMax          Maximum line of credit debt
AccountMin1      Reserve 20% of total debt balance
AccountMin2      Reserve $20000 for emergencies
DelayLimit       Maximum payment you can delay
g0               Initial condition for amount borrowed
h0               Initial condition for amount LOC payed off
w0               Initial condition for amount delayed payables
x0               Initial condition for amount invested
y0               Initial condition for cumulative LOC debt
z0               Initial condition for amount cash on hand
;


Objective..   ntc =E= 0.002*SUM(t,y(t)) + 0.02*SUM(t,w(t)) - 0.001*SUM(t,x(t)) ;

*Objective..   ntc =E= z("8");

Balance1(t)$(ord(t) ge 3)..     z(t) =E= z(t-1) + g(t) + 1.001*x(t-1) + S(t) + R(t)
                                                - h(t) - x(t) - 0.002*y(t-1) - E(t) - 0.98*(P(t)-w(t)) - w(t-3) ;

Balance2(t)$(ord(t) lt 3)..     z(t) =E= z(t-1) + g(t) + 1.001*x(t-1)  + S(t) + R(t)
                                                - h(t) - x(t) - 0.002*y(t-1) - E(t) - 0.98*(P(t)-w(t))          ;

UpdateDebt(t)..                 y(t) =E= y(t-1) + g(t) - h(t) ;
DebtMax(t)..                    y(t) =L= 4000                 ;

AccountMin1(t)..                z(t) =G= 0.2*y(t)  ;
AccountMin2(t)$(ord(t) ge 2)..  z(t) =G= 20        ;

DelayLimit(t)..                 w(t) =L= P(t)      ;

g0..    g("0") =E= 0;
h0..    h("0") =E= 0;
w0..    w("0") =E= 0;
x0..    x("0") =E= 0;
y0..    y("0") =E= 0;
z0..    z("0") =E= 0;


MODEL Tutorial05  /ALL/;
OPTION LP = CPLEX;
OPTION optcr = 1E-08;

SOLVE Tutorial05 MINIMIZING ntc USING LP;

ACRONYM ZERO;
g.L(t)$(NOT g.L(t)) = ZERO;
h.L(t)$(NOT h.L(t)) = ZERO;
w.L(t)$(NOT w.L(t)) = ZERO;
x.L(t)$(NOT x.L(t)) = ZERO;
y.L(t)$(NOT y.L(t)) = ZERO;
z.L(t)$(NOT z.L(t)) = ZERO;

OPTIONS g:3:0:1, h:3:0:1, w:3:0:1;
OPTIONS x:3:0:1, y:3:0:1, z:3:0:1;

DISPLAY ntc.L, g.L, h.L, w.L, x.L, y.L, z.L;



