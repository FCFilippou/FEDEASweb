%% Linear elastic analysis of 2-story, 1-bay frame under different load combinations

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

%% Clear memory and close any open windows
CleanStart

%% model geometry, boundary conditions
Model_2St1BayFrame

%% element properties
LinearElemData

%% Sequence of linear analyses for three load cases and superposition
% ------------------------------------------------------------------------------------------

%% Load case 1 : distributed load on girders
% distributed load in elements 5 through 8 in units of kip/ft
for el=5:6, ElemData{el}.w = [ 0; -6  *Units.k_ft ]; end
for el=7:8, ElemData{el}.w = [ 0; -4.2*Units.k_ft ]; end

% there are no nodal forces for first load case
Loading = Create_Loading (Model);

%% Linear Analysis: single linear step
tic
State = LinearStep (Model, ElemData, Loading);
toc

%% generate post-processing information
Post(1) = Structure ('post',Model,ElemData,State);

%% generate graphic output
% magnification factor for deformed shape
MAGF = 80;
Post_LinearAnalysis

% ------------------------------------------------------------------------------------------
%% Load case 2: horizontal forces
% set distributed load in elements 5 through 8 from previous load case to zero
for el=5:8,  ElemData{el}.w = [0;0]; end
% specify nodal forces
Pe(2,1) = 20;   
Pe(3,1) = 40;
Pe(5,1) = 20;
Pe(6,1) = 40;
Loading = Create_Loading (Model,Pe);

%% Linear Analysis: single linear step
tic
State = LinearStep (Model, ElemData, Loading);
toc

%% generate post-processing information
Post(2) = Structure ('post',Model,ElemData,State);

%% generate graphic output
% magnification factor for deformed shape
MAGF = 80;
Post_LinearAnalysis

% ------------------------------------------------------------------------------------------
%% Load case 3: support displacement
% zero nodal forces from previous load case and impose horizontal support displacement
Pe = [];
Ue(1,1) = 0.2;   % horizontal support displacement
Loading = Create_Loading (Model,Pe,Ue);

%% Linear Analysis: single linear step
tic
State = LinearStep (Model, ElemData, Loading);
toc

%% generate post-processing information
Post(3) = Structure ('post',Model,ElemData,State);

%% generate graphic output
% magnification factor for deformed shape
MAGF = 80;
Post_LinearAnalysis

% ------------------------------------------------------------------------------------------
%% Load combination by linear superposition

% plot a new moment distribution for gravity and lateral force combination
% using LRFD load factors and assuming that horizontal forces are due to EQ
LF_Gr = 1.2;
LF_Eq = 1.6;

for el=1:Model.ne
   Post_Combi.Elem{el}.q = LF_Gr.*Post(1).Elem{el}.q + LF_Eq.*Post(2).Elem{el}.q;
end

% include distributed load in elements 5 through 8 for moment diagram
for el=5:6, ElemData{el}.w = LF_Gr.*[ 0; -6  *Units.k_ft ]; end
for el=7:8, ElemData{el}.w = LF_Gr.*[ 0; -4.2*Units.k_ft ]; end

Create_Window(WinXr,WinYr);
Plot_Model(Model);
Plot_2dMomntDistr (Model,ElemData,Post_Combi,[],ScaleM);
Label_2dMoments (Model,Post_Combi,[],MDigt,Units.kft);