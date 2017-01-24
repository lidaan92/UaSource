function [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,varargin)



%% Plots grounding lines
%
% [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,varargin)
%
% Examples:
%
%
%    PlotGroundingLines(CtrlVar,MUA,GF);
%
%    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,[],[],[],'r') % plot GL in
%                                                                    % red
%
%
%    GLgeo=[] ; xGL=[], yGL=[]; % repeated use
%    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
%    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);
%
%    [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL,'r','LineWidth',2);
%
% To plot grounding lines for higher-order elements with sub-element resolution
% set CtrlVar.GLsubdivide=1. Doing so causes higher-order elements to be split
% into sub-elements allowing for more accurate representation of the grounding
% line within an element.
%
% To plot individual grounding lines in different colours set
% CtrlVar.PlotIndividualGLs=1
%
% To not create any plots set CtrlVar.PlotGLs=0;
%
% If xGL and yGL are empty on input, they are calculated from MUA and GLgeo.
%
% If GLgeo, xGL and yGL are all empty on input, then GLgeo is first calculated
% from from GF and MUA, and then xGL and yGL are calculated from GLgeo.
%
% If GLgeo, xGL and yGL are all empty, then MUA and GF can not be empty.
%
% If xGL and yGL are not empty, then all other fields can be left empty.
%
% varagin is passed on to plot
%
% Note: If MUA and GF have not changed from a previous call to
% PlotGroundingLines, always give xGL and yGL from the previous call as inputs
% to all following calls as doing so saves (lots of) time when plotting complicated
% grounding lines. In an initial call, where MUA and GF are available, do for
% example:
%
%   GLgeo=[] ; xGL=[] ; yGL=[];
%   [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL); % here GLgeo, xGL and yGL are all empty
%   [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL); % here GLgeo, xGL and yGL are known from
%                                                                     % the previous call (they will not be
%
% Hint: Once xGL and yGL have been calculated, for example through a previous call to
% PlotGroundingLines, one can also simply plot the grounding lines as:
% plot(xGL,yGL)
%
%
% See also: PlotMuaBoundary
%

narginchk(3,inf)

if isempty(CtrlVar)
    CtrlVar.XYscale=1;
    CtrlVar.PlotIndividualGLs=0;
    CtrlVar.PlotGLs=1;
end

if ~isfield(CtrlVar,'PlotXYscale') ; CtrlVar.PlotXYscale=1 ; end
if ~isfield(CtrlVar,'PlotGLs') ; CtrlVar.PlotGLs=1 ; end
if ~isfield(CtrlVar,'PlotIndividualGLs') ; CtrlVar.PlotIndividualGLs=0 ; end


if nargin<4 || isempty(GLgeo)
    
    GLgeo=GLgeometry(MUA.connectivity,MUA.coordinates,GF,CtrlVar);
    
end

if nargin<6 || ( isempty(xGL) || isempty(yGL))
    xa=GLgeo(:,3) ;  xb=GLgeo(:,4) ; ya=GLgeo(:,5) ;  yb=GLgeo(:,6) ;
    [xGL,yGL]=LineUpEdges2([],xa,xb,ya,yb);
end



if CtrlVar.PlotGLs
    
    if ~CtrlVar.PlotIndividualGLs
        
        plot(xGL/CtrlVar.PlotXYscale,yGL/CtrlVar.PlotXYscale,varargin{:}) ;
        ax=gca; ax.DataAspectRatio=[1 1 1];
        
    else
        
        i=0;
        I=find(isnan(xGL)) ;
        I=[1;I(:)];
        col=['b','r','c','g','k','m'];
        %col=['b','r'];
        for ii=1:numel(I)-1
            i=i+1;
            plot(xGL(I(ii):I(ii+1)),yGL(I(ii):I(ii+1)),col(i)) ; axis equal ; hold on ;
            if i==numel(col) ; i=0 ; end
        end
        ax=gca; ax.DataAspectRatio=[1 1 1];
    end
end



end