%% Post-processing for Plastic Analysis

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;    % X-ratio of plot window to screen size 
WinYr = 0.80;    % Y-ratio of plot window to screen size
NodSF = 3/4;     % relative size for node symbol
HngSF = 1;       % relative size for plastic hinge
OffSF = 1;       % relative size for plastic hinge offset
% -------------------------------------------------------------------------

% set figure counter to 0, if Fig variable does not exist
if exist('Fig','var'), cfig = length(Fig); else, cfig = 0; end

%% plot nodal forces for lateral loading 
% open figure window
cfig = cfig+1;
Fig(cfig) = Create_Window(WinXr,WinYr);
PlotOpt.PlNod = 'no';
PlotOpt.LnWth = 1;
PlotOpt.PlJnt = 'no';
PlotOpt.PlBnd = 'yes';
PlotOpt.NodSF = NodSF;
Plot_Model (Model,[],PlotOpt);
PlotOpt.FrcSF =  1.5;
PlotOpt.LnWth  = 2;
PlotOpt.TipSF  = 1.2;
Plot_NodalForces (Model,Loading,PlotOpt);
% -------------------------------------------------------------------------

%% plot moment distribution and plastic hinge locations at incipient collapse 
% open figure window
cfig = cfig+1;
Fig(cfig) = Create_Window(WinXr,WinYr);
PlotOpt.LnWth = 0.1;
PlotOpt.LnClr = 'w';
PlotOpt.PlJnt = 'yes';
PlotOpt.PlBnd = 'no';
Plot_Model(Model,[],PlotOpt);
Plot_2dMomntDistr (Model,[],Qc,[],1/2);
% Label_2dMoments (Model,Qc,[],0,kipft)
PlotOpt.LnWth = 0.5;
PlotOpt.LnClr = 'k';
Plot_Model(Model,[],PlotOpt);
PlotOpt.HngSF = HngSF;
PlotOpt.OffSF = OffSF;
Plot_PlasticHinges (Model,ElemData,[],Qc,PlotOpt);
% -------------------------------------------------------------------------

%% plot collapse mechanism
% select magnification factor so that max lateral roof translation = 15% of frame height
RoofTrans = DUf(Model.DOF(6,1));
MAGF = 0.15*max(XYZ(:,2))/abs(RoofTrans);
% open figure window
cfig = cfig+1;
Fig(cfig) = Create_Window(WinXr,WinYr);
PlotOpt.LnWth = 0.1;
PlotOpt.LnClr = [0.8 0.8 0.8];
PlotOpt.PlJnt = 'no';
PlotOpt.PlBnd = 'yes';
Plot_Model (Model,[],PlotOpt);
PlotOpt.LnWth = 2;
PlotOpt.LnStl = '-.';
PlotOpt.LnClr = 'k';
PlotOpt.MAGF  = MAGF;
PlotOpt.PlJnt = 'yes';
Plot_Model (Model,DUf,PlotOpt);
PlotOpt.HngSF = HngSF;
PlotOpt.OffSF = OffSF;
Plot_PlasticHinges (Model,[],DUf,DVpl,PlotOpt);

clear PlotOpt