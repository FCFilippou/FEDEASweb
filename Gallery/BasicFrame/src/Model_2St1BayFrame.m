%% Simple two-story, one-bay frame

% Department of Civil and Environmental Engineering
% University of California, Berkeley
% Professor Filip C. Filippou

% unless script is called by another script clear memory and close open windows
if length(dbstack)==1,  CleanStart,  end

% create data structure for units
Units = Create_Units('US');

%% Node coordinates (in feet!)
XYZ(1,:) = [ 0     0];  % first node
XYZ(2,:) = [ 0    12];  % second node, etc
XYZ(3,:) = [ 0    24];  % 
XYZ(4,:) = [25     0];  %
XYZ(5,:) = [25    12];  %
XYZ(6,:) = [25    24];  %
XYZ(7,:) = [12.5  12];  %
XYZ(8,:) = [12.5  24];  % 
% convert coordinates to inches
XYZ = XYZ.*Units.ft;

%% Connectivity array
CON {1} = [  1   2];   % first story columns
CON {2} = [  4   5];
CON {3} = [  2   3];   % second story columns   
CON {4} = [  5   6];
CON {5} = [  2   7];   % first floor girders
CON {6} = [  7   5];   % keep this connectivity for easier definition of element load
CON {7} = [  3   8];   % second floor girders
CON {8} = [  8   6];   % keep this connectivity for easier definition of element load

%% Boundary conditions

% (specify only restrained dof's)
BOUN(1,1:3) = [1 1 1];  % (1 = restrained,  0 = free)
BOUN(4,1:3) = [1 1 1];

%% Element type

% Note:  any 2 node 3dof/node element can be used at this point!
[ElemName{1:8}] = deal('2dFrm');    % 2d frame element

%% Create model data structure
Model = Create_SimpleModel(XYZ,CON,BOUN,ElemName);

% plot parameters
% -------------------------------------------------------------------------
WinXr = 0.40;    % X-ratio of plot window to screen size 
WinYr = 0.80;    % Y-ratio of plot window to screen size
% -------------------------------------------------------------------------

Create_Window(WinXr,WinYr);
PlotOpt.PlNod = 'yes';
PlotOpt.PlBnd = 'yes';
PlotOpt.LnWth = 1.5;
PlotOpt.NodSF = 0.7;
Plot_Model  (Model,[],PlotOpt);    % plot model
PlotOpt.FntSF = 0.4;
Label_Model (Model,PlotOpt);       % label model

clear PlotOpt