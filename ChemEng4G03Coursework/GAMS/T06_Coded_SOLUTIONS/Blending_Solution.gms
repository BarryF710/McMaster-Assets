*ChE 4G03 GAS BLENDING SOLUTION
SETS
I components /rft,nph,but,gas,alk/
Q quality properties /oct,rvp,vlt/
;

PARAMETERS
B blended fuel sale price ($ per bbl) /66/

A(I) availability of component I (bbl per h)
/
rft      12000
nph       6500
but       3000
gas       4500
alk       7000
/

C(I) cost of component I (dollars per bbl)
/
rft      68.00
nph      52.00
but      20.60
gas      63.60
alk      69.00
/

QHI(Q) maximum quality specs
/
oct       100
rvp      10.8
vlt        48
/

QLO(Q) minimum quality specs
/
oct      88.5
rvp       4.5
vlt         0
/

T total volume to blend /7000/
;

TABLE P(I,Q) quality measure Q for component I
         oct     rvp     vlt
rft      90.5      4      17
nph      68.0     10      96
but      92.5    138     128
gas      80.0      6      22
alk      95.0      7      34
;

VARIABLES
Z objective value;

POSITIVE VARIABLES
X(I) volume of component I in blend (bbl per h);

EQUATIONS
OBJ objective
TOT total production
AVL availability
QUHI quality max limit
QULO quality min limit
;

OBJ.. Z =E= SUM(I,(B - C(I))*X(I));
TOT.. SUM(I,X(I)) =E= T;
AVL(I).. X(I) =L= A(I);
QUHI(Q).. SUM(I,P(I,Q)*X(I)) =L= QHI(Q)*SUM(I,X(I));
QULO(Q).. SUM(I,P(I,Q)*X(I)) =G= QLO(Q)*SUM(I,X(I));
;

MODEL BLEND /ALL/;
OPTION LP = CPLEX;
BLEND.OPTFILE = 1;
SOLVE BLEND using LP MAXIMIZING Z;
DISPLAY Z.L, X.L;

PARAMETERS
TX blend volume
QACT(Q) actual qualities
;
TX = SUM(I,X.L(I));
QACT(Q) = SUM(I,P(I,Q)*X.L(I))/SUM(I,X.L(I));
DISPLAY TX, QACT;
