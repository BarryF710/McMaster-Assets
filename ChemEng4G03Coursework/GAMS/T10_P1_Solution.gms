* I have decided to do this one without using sets. It is easier this way!

PARAMETERS
d1 /2.5/
d2 /40/
t1 /0.6/
t2 /1/
p0 /200/
;

POSITIVE VARIABLES
X1
X2
X3
X4;

VARIABLE
PHI;

EQUATIONS
OBJ 'Objective'
DEM 'Demand constraint'
PRESSURE 'pressure balance constraint'
POWERVSPRESSURE 'Power required based on pressure'
VOLVSPRESSURE 'Volume based on pressure'
;

$ontext
Note that I have modified some of the equations below in an attempt to make things easier for the solver.
For example, I have elevated the variables in the denominator for the powervspressure and volvspressure equations.
This helps avoid dividing by zero a lot of the time, and will assist in convergence by making some of the terms bilinear (multiplied together).
If you are ever having trouble with solvers in GAMS, I would encourage you to consider re-arranging your equations to a more "straightforward" form mathematically
You should still always formulate the problem so YOU understand it, but sometimes multiplying out denominators will result in an easier time for the solver, even if it is not great to look at from a human-perspective.
$offtext


OBJ.. PHI =e= 61.8 + 5.72*X1 + 0.0175*(X3**0.85) + 0.0094*(X4**0.75) + 0.006*t1*X3;
DEM.. t2*X1 =g= d1*t1 + d2*t2 - d2*t1;
PRESSURE.. X2 =g= p0;
POWERVSPRESSURE.. 36.25*d2*(t2-t1)/t1*log(X2/p0) - 36.25*X1*(t2-t1)/t1*log(X2/p0) =e= X3;
VOLVSPRESSURE.. X4*X2 =e= 348300*d2*(t2-t1) - 348300*x1*(t2-t1);

* I HAVE to set an initial guess here - if I don't, I get ln(0). based on the problem, these numbers are reasonable
* In industry, it would be up to you to decide what a reasonable initial guess is based on process knowledge and/or experience
x1.l = 20;
x2.l = 500;
x3.l = 500;
x4.l = 6000;

MODEL powerplant/all/;
option optcr = 0.00001;
solve powerplant using NLP minimizing PHI;
