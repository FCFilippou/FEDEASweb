%% Determination of collapse load factor of multi-story frame
%  with the plastic analysis function of FEDEASLab (linear programming)

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

%% Clear memory and close any open windows
CleanStart

%% model geometry, boundary conditions
Model_2St1BayFrame

%% element properties
LEPPElemData

%% specify N-M interaction option for the column elements ('None','Dmnd','AISC')
NMOpt = 'None';
for el = 1:4, ElemData{el}.NMOpt = NMOpt; end

%% Loading
% horizontal nodal forces
Pe(2,1) = 20;   
Pe(3,1) = 40;
Pe(5,1) = 20;
Pe(6,1) = 40;
LatLoading = Create_Loading (Model,Pe);

clear Pe

Pe(7,2) = -80;
Pe(8,2) = -50;
GravLoading = Create_Loading (Model,Pe);

% % both sets to be factored
% Loading.Pref = LatLoading.Pref + GravLoading.Pref;

% lateral forces to be factored, gravity forces to remain constant
Loading.Pref = LatLoading.Pref;
Loading.Pcf  = GravLoading.Pref;

%% plastic analysis
tic
[lambdac,Qc,DUf,DVpl] = PlasticAnalysis (Model,ElemData,Loading);
toc

%% post-processing
Post_PlasticAnalysis