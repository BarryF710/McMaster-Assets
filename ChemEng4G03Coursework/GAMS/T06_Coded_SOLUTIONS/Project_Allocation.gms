SETS
I  Resources  / Outside, Grad, Pro /;

PARAMETER
C(I)  Hourly Rate ($ per hr)
/ Outside  14.0
  Grad     24.0
  Pro      64.0 /

S(I)  Supervisory Rate (hr per hr)
/ Outside  0.20
  Grad     0.15
  Pro      0.05 /

P(I)  Productivity fraction
/ Outside  0.25
  Grad     0.40
  Pro      1.00 /;

SCALARS
Project_max_span     Full project time (hr)       / 1000.0 /
Graduate_max_time    Max grad student time (hr)   / 480.0  /
Supervisor_max_time  Available time (hr)          / 160.0  / ;

VARIABLES
X(I)  Contracted Time (hr)
Z     Cost ($) ;
POSITIVE VARIABLE X;


EQUATIONS
Cost         Project cost
Work         Required work
Grad_limit   Graduate work limit
Supervise    Supervisor availability ;

Cost..        Z =E= SUM(I, C(I)*X(I));
Work..        SUM(I, P(I)*X(I)) =G= Project_max_span;
Grad_limit..          X('Grad') =L= Graduate_max_time;
Supervise..   SUM(I, S(I)*X(I)) =L= Supervisor_max_time;

MODEL Project / ALL /;


Project.OPTFILE=1;
*objrng = all;

SOLVE Project USING LP minimizing Z;
