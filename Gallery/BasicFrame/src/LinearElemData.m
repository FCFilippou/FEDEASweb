%% linear element properties

%% Element name: 2d linear elastic frame element
[Model.ElemName{1:8}] = deal('LE2dFrm');    

%% Material properties
if ~exist('Units','var'), Units = Create_Units('US'); end
inch = Units.in;
in2  = Units.in2;
in4  = Units.in4;
ksi  = Units.ksi;

E  = 29000*ksi;   % elastic modulus
fy = 50*ksi;      % yield     strength

%% Section properties
% AISC database properties are in in, in2, in3, in4

%% Columns of first story W14x193
SecProp = AISC_Section('W14x193');
for el=1:2
   ElemData{el}.E  = E;
   ElemData{el}.A  = SecProp.A *in2;
   ElemData{el}.I  = SecProp.Ix*in4;
end
%% Columns of second story W14x145
SecProp = AISC_Section('W14x145');
for el=3:4
   ElemData{el}.E  = E;
   ElemData{el}.A  = SecProp.A *in2;
   ElemData{el}.I  = SecProp.Ix*in4;
end
%% Girders on first floor W27x94
SecProp = AISC_Section('W27x94');
for el=5:6
   ElemData{el}.E  = E;
   ElemData{el}.A  = SecProp.A *in2;
   ElemData{el}.I  = SecProp.Ix*in4;
end
%% Girders on second floor W24x68
SecProp = AISC_Section('W24x68');
for el=7:8
   ElemData{el}.E  = E;
   ElemData{el}.A  = SecProp.A *in2;
   ElemData{el}.I  = SecProp.Ix*in4;
end

%% default values for optional element properties
ElemData = Structure ('chec',Model,ElemData);