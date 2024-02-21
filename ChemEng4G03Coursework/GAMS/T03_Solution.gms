* First, the sets that define the problem. For every indexed quantity, we want to define this in GAMS as a set.
* Our sets here are i (I1...I7) and j (J1...J3)
SETS
AREA 'Analysis Area in Question'   /I1*I7/
PRES 'Prescription of forest area' /J1*J3/;

TABLE
NPV(AREA,PRES) 'NPV of prescribing one acre in region I to prescription J'

         J1      J2      J3

I1       503     140     203
I2       675     100     45
I3       630     105     40
I4       330     40      295
I5       105     460     120
I6       490     55      180
I7       705     60      400        ;

TABLE
T(AREA,PRES) 'Timber yield in feet of one acre in region I to prescription J'

         J1      J2      J3

I1       310     50      0
I2       198     46      0
I3       210     57      0
I4       112     30      0
I5       40      32      0
I6       105     25      0
I7       213     40      0 ;

TABLE
G(AREA,PRES) 'Grazing yield in animal months of one acre in region I to prescription J'

         J1      J2      J3

I1       0.01    0.04    0
I2       0.03    0.06    0
I3       0.04    0.07    0
I4       0.01    0.02    0
I5       0.05    0.08    0
I6       0.02    0.03    0
I7       0.02    0.04    0   ;

TABLE
W(AREA,PRES) 'Wilderness index of one acre in region I to prescription J'

         J1      J2      J3

I1       40      80      95
I2       55      60      65
I3       45      55      60
I4       30      35      90
I5       60      60      70
I6       35      50      75
I7       40      45      95
   ;

PARAMETER

S(AREA) 'Number of acres available in each analysis area'
/
I1       75000
I2       90000
I3       140000
I4       60000
I5       212000
I6       98000
I7       113000
/                      ;


VARIABLES
X(AREA,PRES)       'Number of acreas allocated from area I to prescriptin J'
OBJ                'Objective function attempting to maximize total NPV'
;

POSITIVE VARIABLE
X(AREA,PRES)
;

EQUATIONS
TOT_NPV                  'Defines the total NPV according to the allocation scheme'
TOT_ALLOCATION(AREA)     'Total allocaiton available for each area'
TIMBER                   'Ensure our timber requirements are met'
GRAZING                  'Ensure our grazing requirements are met'
WILDERNESS               'Ensure our minimum average wilderness index is met'
;

TOT_NPV..                OBJ =E= SUM(AREA,SUM(PRES,X(AREA,PRES)*NPV(AREA,PRES)))                 ;
TOT_ALLOCATION(AREA)..   SUM(PRES,X(AREA,PRES)) =E= S(AREA)                                      ;
TIMBER..                 SUM(AREA,SUM(PRES,X(AREA,PRES)*T(AREA,PRES))) =G= 40e6                  ;
GRAZING..                SUM(AREA,SUM(PRES,X(AREA,PRES)*G(AREA,PRES))) =G= 5000                  ;
WILDERNESS..             SUM(AREA,SUM(PRES,X(AREA,PRES)*W(AREA,PRES))) =G= 70*SUM(AREA,S(AREA))  ;

model FORESTRY /all/;

FORESTRY.OPTFILE = 1;
solve FORESTRY using LP maximizing OBJ;

