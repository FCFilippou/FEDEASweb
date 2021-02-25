%% Fundamental periods and mode shapes of 2-story, 1-bay frame

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
tic
[omega,Ueig] = EigenMode (Kf,Ml,3);
toc
% echo eigenmode periods
disp ('The three lowest eigenmode periods are');
T = 2*pi./omega;
disp (T(1:3));

%% plot 3 mode shapes with lowest eigenvalues
% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;    % X-ratio of plot window to screen size 
WinYr = 0.80;    % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------
% magnification factor for mode shapes
MAGF = 50;

PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = 3/4;
Plot_Model(Model,[],PlotOpt);

U = zeros(Model.nt,1);
for i=1:min(3,length(omega))
   Fig(i) = Create_Window(WinXr,WinYr);
   Plot_Model (Model,[],PlotOpt);
   U(1:Model.nf,1) = Ueig(:,i);
   % select mode magnification factor so that maximum lateral translation is 10% of height 
   RefTrans  = max(abs((U(Model.DOF(:,1)))));
   sgn = sign(U(Model.DOF(Model.nn,1))); 
   PlotOpt.MAGF = MAGF;
   % for the horizontal roof translation of each mode in the plot to be positive use sgn*U
   Plot_DeformedStructure(Model,[],sgn*U,[],PlotOpt);
end

%% horizontal translation distribution for first mode
% used for lateral load distribution in push-over analysis
HorDOFi = Model.DOF(Model.DOF(:,1)<=Model.nf);
% horizontal translation distribution for first mode
Pdis = abs(Ueig(HorDOFi,1));
Pdis = Pdis./max(Pdis);
disp('The horizontal floor translations for the first mode are')
disp(Pdis(1:2))