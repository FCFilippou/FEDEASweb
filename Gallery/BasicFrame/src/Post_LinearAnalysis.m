%% Post-processing for linear analysis

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;    % X-ratio of plot window to screen size 
WinYr = 0.80;    % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------

% set figure counter to 0, if Fig variable does not exist
if exist('Fig','var'), cfig = length(Fig); else, cfig = 0; end

%% plot deformed shape of structural model
% recover units if not present
if ~exist('Units','var'), Units = Create_Units('US'); end

% open figure window
cfig = cfig+1;
Fig(cfig) = Create_Window(WinXr,WinYr);
PlotOpt.NodSF = 3/4;
Plot_Model(Model,[],PlotOpt);
PlotOpt.MAGF = MAGF;
Plot_DeformedStructure (Model,ElemData,[],Post(end),PlotOpt);

%% plot moment distribution
ScaleM = 1/2;    % scale factor for bending moments
MDigt  = 0;      % number of significant digits for bending moment labels

% open figure window
cfig = cfig+1;
Fig(cfig) = Create_Window(WinXr,WinYr);
Plot_Model(Model);
Plot_2dMomntDistr (Model,ElemData,Post(end),[],ScaleM);
Label_2dMoments (Model,Post(end),[],MDigt,Units.kft);