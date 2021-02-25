%% Modal analysis (mode superposition) of 2-story, 1-bay frame

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

%% Clear memory and close any open windows
CleanStart

%% model geometry, boundary conditions
Model_2St1BayFrame

%% element properties
LinearElemData

%% specify lumped mass
% define mass value m to be assigned to X-direction at all nodes
m = 0.6;
Me([2 3 5:8],1) = m.*ones(6,1);
% create nodal mass vector and stored it in Model
Model = Add_Mass2Model(Model,Me);

%% form stiffness matrix
State = Initialize_State (Model,ElemData);
State = Structure ('stif',Model,ElemData,State);
% free dof stifness matrix
Kf    = State.Kf;
Ml    = Model.M;

%% solve dynamic eigenvalue problem with FEDEASLab function EigenMode
[omega,Ueig] = EigenMode (State.Kf,Ml,3);
% echo eigenmode periods
disp('The three lowest eigenmode periods are');
T = 2*pi./omega;
disp(T(1:3));

%% Loading
% create loading data structure
Loading = Create_Loading(Model);

% %% select earthquake record from file or PEER database
% run('..\EQ Records\Select_EQRecord')

% or, use text file with pair of time-acceleration values (select the folder of EQ record)
run('..\EQ Records\Read_TimeAccArray')

%% Transient analysis under ground acceleration with modal analysis
if ~exist('Units','var'), Units = Create_Units('US'); end
% specify modal damping ratios
zeta = [ 0.02 0.02 ];   % 2% for first and second mode
% perform modal analysis
tic
%% scale factor for ground acceleration
Factor = 1.0;
Loading.AccHst.Time  = AccHst.Time;
Loading.AccHst.Value = Factor.*AccHst.Value.*Units.g;
Deltat = AccHst.Deltat;

%% influence vector for free dof accerelations (vector of ones)
Loading.Uddref = zeros(Model.nf,1);
HdofIdx = Model.DOF((find(Model.DOF(:,1)<=Model.nf)),1);
Loading.Uddref(HdofIdx,1) = ones(length(HdofIdx),1);

[omega,Veig,Y_t,Ydot_t,Yddot_t] = ModalAnalysis ('eig',Kf,Ml,Loading,Deltat,zeta);
toc

%% POST PROCESSING
tic
Post_ModalAnalysis
toc