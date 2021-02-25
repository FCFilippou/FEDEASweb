%% Post-processing for Modal Analysis

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;    % X-ratio of plot window to screen size 
WinYr = 0.80;    % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------

% time scale
t = Deltat*(0:length(Loading.AccHst.Value));

RoofDOF = Model.DOF(6,1);
% global dof response history
nstep = size(Y_t,1);
U = zeros(nstep,Model.nt);
% free DOF displacement response history by mode superposition
U(:,1:Model.nf) = Y_t*Veig';
Hgt = max(XYZ(:,2));               % building height 
Rdt = [ 0 ; U(:,RoofDOF)./Hgt ];

% set figure counter to 0, if Fig variable does not exist
if exist('Fig','var'), cfig = length(Fig); else, cfig = 0; end

%% plot average roof drift history
% open figure window
cfig = cfig+1;
Fig(cfig) = Create_Window(WinXr,WinYr);

PlotOpt.XLbl   = 'Time (sec)';
PlotOpt.YLbl   = 'Average roof drift';
PlotOpt.MrkTyp = {'none'};
AxHndl = Plot_XYData (t,Rdt,PlotOpt);

%% determine the modal contributions to the average roof drift history
U1(:,1:Model.nf) = Y_t(:,1)*Veig(:,1)';
U2(:,1:Model.nf) = Y_t(:,2)*Veig(:,2)';
U3(:,1:Model.nf) = Y_t(:,3)*Veig(:,3)';

% average roof drift contribution of modes 1, 2 and 3
Rd1t = [ 0 ; U1(:,RoofDOF)./Hgt ];
Rd2t = [ 0 ; U2(:,RoofDOF)./Hgt ];
Rd3t = [ 0 ; U3(:,RoofDOF)./Hgt ];
% open figure window
cfig = cfig+1;
Fig(cfig) = Create_Window(WinXr,WinYr);

PlotOpt.XLbl   = 'Time (sec)';
PlotOpt.YLbl   = 'Average roof drift';
PlotOpt.MrkTyp = {'none'};
PlotOpt.Legnd = {'1. Mode' '2. Mode' '3. Mode'};
PlotOpt.ShwLg = true;
% display modal contributions for first 3 modes
Plot_XYData (t,[Rd1t Rd2t Rd3t],PlotOpt);

clear PlotOpt

%% base shear time history by summation of support reactions (KU response)
nstep   = size(U,1);
% index for horizontal support DOFs HsupDOF
HsupDOF = Model.DOF([1 4],1);
% initialize base shear history
BaseV   = zeros(nstep,1);
for k = 1:nstep
   State.U = zeros(Model.nt,1);
   % substitute the DOF displacements at time step k into State
   State.U = U(k,:)';
   % state determination for resisting forces Pr under U
   State = Structure('forc',Model,ElemData,State);
   % the sum of the resisting forces at the support DOFs is the base shear at time k
   BaseV(k) = -sum(State.Pr(HsupDOF));
end
% building weight 
Weight = sum(Model.M)*Units.g;
%----------------------
cfig = cfig+1;
Fig(cfig) = Create_Window(WinXr,WinYr);

PlotOpt.XLbl   = 'Time (sec)';
PlotOpt.YLbl   = 'Base shear/Weight';
PlotOpt.MrkTyp = {'none'};
Yp = [ 0;BaseV(1:end)./Weight];
Plot_XYData (t,Yp,PlotOpt);

clear PlotOpt