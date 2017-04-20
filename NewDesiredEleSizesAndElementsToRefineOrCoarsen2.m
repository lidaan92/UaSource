function  [UserVar,RunInfo,F,xNod,yNod,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened]=...
    NewDesiredEleSizesAndElementsToRefineOrCoarsen2(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l,GF,Ruv,Lubvb)

%
% Estimates optimal element sizes based on number of explicit error estimators
% The estimates are given at the nodal points of the current FE mesh
%
% Scales element sizes to fit within the range of CtrlVar.MeshSizeMin to CtrlVar.MeshSizeMax
%





% Calculate current element sizes
EleArea=TriAreaFE(MUA.coordinates,MUA.connectivity);
M= Ele2Nodes(MUA.connectivity,MUA.Nnodes);
EleSizeCurrent=sqrt(M*EleArea);  % Elesizes around nodes


xNod=MUA.coordinates(:,1) ; yNod=MUA.coordinates(:,2);

EleSizeDesired=zeros(numel(xNod),1)+CtrlVar.MeshSizeMax ;
EleSizeIndicator =zeros(numel(xNod),1)+CtrlVar.MeshSizeMax ;

NodalErrorIndicators=[];
Kfig=0;
isCalculated=false;

%CalcVel=any(arrayfun(@(x) strcmpi(x,'effective strain rates'),CtrlVar.RefineCriteria) | arrayfun(@(x) strcmpi(x,'residuals'),CtrlVar.RefineCriteria));

for I=1:numel(CtrlVar.ExplicitMeshRefinementCriteria)
    
    ErrorIndicatorUsefull=1;
    
    if isempty(CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin)
        CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin=CtrlVar.MeshSizeMin;
    end
    if isempty(CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax)
        CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax=CtrlVar.MeshSizeMax;
    end
    
    if ~CtrlVar.ExplicitMeshRefinementCriteria(I).Use
        continue
    end
    
    
    
    %% calculations specific to error criterion start
    switch lower(CtrlVar.ExplicitMeshRefinementCriteria(I).Name)
        
        case 'effective strain rates'
            
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            u=F.ub+F.ud ; v=F.vb+F.vd;
            
            if (RunInfo.MeshAdapt.isChanged  && ~isCalculated) || (all(u==0) && all(v==0))
                [UserVar,RunInfo,F,l,~,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);
                isCalculated=true;
            end
            
            u=F.ub+F.ud ; v=F.vb+F.vd;
            [~,~,~,ErrorProxy]=CalcNodalStrainRates(CtrlVar,MUA,u,v);
            
        case 'effective strain rates gradient'
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            u=F.ub+F.ud ; v=F.vb+F.vd;
            
            if (RunInfo.MeshAdapt.isChanged  && ~isCalculated) || (all(u==0) && all(v==0))
                [UserVar,RunInfo,F,l,~,Ruv,Lubvb]= uv(UserVar,RunInfo,CtrlVar,MUA,BCs,F,l);
                isCalculated=true;
            end
            
            u=F.ub+F.ud ; v=F.vb+F.vd;
            [~,~,~,ErrorProxy]=CalcNodalStrainRates(CtrlVar,MUA,u,v);
            [dfdx,dfdy]=calcFEderivativesMUA(ErrorProxy,MUA,CtrlVar);
            [dfdx,dfdy]=ProjectFintOntoNodes(MUA,dfdx,dfdy);
            ErrorProxy=sqrt(dfdx.*dfdx+dfdy.*dfdy);
            
            
        case 'flotation'
            
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            hf=(F.S-F.B)*F.rhow./F.rho ;
            ErrorProxy = DiracDelta(1/CtrlVar.RefineDiracDeltaWidth,F.h-hf,CtrlVar.RefineDiracDeltaOffset);
            
        case 'thickness gradient'
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            [dfdx,dfdy]=calcFEderivativesMUA(F.h,MUA,CtrlVar);
            [dfdx,dfdy]=ProjectFintOntoNodes(MUA,dfdx,dfdy);
            ErrorProxy=sqrt(dfdx.*dfdx+dfdy.*dfdy);
            
        case 'upper surface gradient'
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            [dfdx,dfdy]=calcFEderivativesMUA(F.s,MUA,CtrlVar);
            [dfdx,dfdy]=ProjectFintOntoNodes(MUA,dfdx,dfdy);
            ErrorProxy=sqrt(dfdx.*dfdx+dfdy.*dfdy);
            
        case 'lower surface gradient'
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            [dfdx,dfdy]=calcFEderivativesMUA(F.b,MUA,CtrlVar);
            [dfdx,dfdy]=ProjectFintOntoNodes(MUA,dfdx,dfdy);
            ErrorProxy=sqrt(dfdx.*dfdx+dfdy.*dfdy);
            
        case 'dhdt gradient'
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            
            ErrorProxy=abs(F.dhdt);
            if all(ErrorProxy<100*eps)
                ErrorIndicatorUsefull=0;
                fprintf(CtrlVar.fidlog,' remeshing criterion %s too small to be of use and discarded. \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            else
                
                [dfdx,dfdy]=calcFEderivativesMUA(F.dhdt,MUA,CtrlVar);
                [dfdx,dfdy]=ProjectFintOntoNodes(MUA,dfdx,dfdy);
                ErrorProxy=sqrt(dfdx.*dfdx+dfdy.*dfdy);
            end
            
        case '|dhdt|'
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name);
            ErrorProxy=abs(F.dhdt);
            if all(ErrorProxy<1e-5)
                ErrorIndicatorUsefull=0;
            end
            
        otherwise
            
            fprintf(CtrlVar.fidlog,' remeshing criterion is : %s \n ',CtrlVar.RefineCriteria{I});
            error(' what case? ')
            
    end
    
    
    %% calculations specific to error criterion done
    
    EleSizeIndicator=Error2EleSize(CtrlVar,ErrorProxy,CtrlVar.ExplicitMeshRefinementCriteria(I).Scale,...
        CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin,...
        CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax,...
        CtrlVar.ExplicitMeshRefinementCriteria(I).p);
    % take the minimum of each error indicator as measure for ele size
    EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);
    
    
    
    %% Plots
    if   CtrlVar.doplots==1 && CtrlVar.doAdaptMeshPlots && CtrlVar.InfoLevelAdaptiveMeshing>=10
        
        FigName=['Explicit Mesh Refinement ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name];
        fig=findobj(0,'name',FigName);
        if isempty(fig)
            fig=figure('name',FigName);
            fig.Position=[200+20*Kfig,200,1600,600] ;
            Kfig=Kfig+1;
        else
            figure(fig);
            hold off
        end
        
        subplot(1,3,1) ; hold off
        %plot(ErrorProxy,EleSizeIndicator,'.r') ;
        semilogy(ErrorProxy,EleSizeIndicator,'.r') ;
        title('Desired element sizes as a function of error proxy')
        xlabel(['Error proxy: ',CtrlVar.ExplicitMeshRefinementCriteria(I).Name])
        ylabel('Ele Size Estimate')

        hold on
        plot([CtrlVar.ExplicitMeshRefinementCriteria(I).Scale CtrlVar.ExplicitMeshRefinementCriteria(I).Scale],...
            [CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin,CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax],'g');
        
        subplot(1,3,2) ; hold off
        histogram(EleSizeIndicator) ;  xlabel('EleSizeIndicator') ; ylabel('# Elements')
        title(sprintf('Scale=%g hMin=%g hMax=%g',...
            CtrlVar.ExplicitMeshRefinementCriteria(I).Scale,...
            CtrlVar.ExplicitMeshRefinementCriteria(I).EleMin,...
            CtrlVar.ExplicitMeshRefinementCriteria(I).EleMax))
        
        subplot(1,3,3) ; hold off
        histogram(EleSizeIndicator./EleSizeCurrent) ;
        xlabel('EleSizeIndicator./EleSizeCurrent') ;
        ylabel('# Elements')
    end
    
    
    %%
    
    
end


if all(EleSizeDesired==CtrlVar.MeshSizeMax)
    fprintf(' After using relative error criteria, all desired ele sizes are equal to CtrlVar.MeshSizeMax=%g.\n',CtrlVar.MeshSizeMax)
    fprintf(' This most likely happened because either no relative error criteria were specified, or none were applicable. \n')
    fprintf(' Will now set all ele sizes equal to CtrlVar.MeshSize=%g \n ',CtrlVar.MeshSize);
    
    EleSizeDesired=zeros(MUA.Nnodes,1)+CtrlVar.MeshSize;
end


% do not allow EleSize to change too much and take a weighted average of
% the previous and the new EleSize:
%EleSizeDesired=0.95*EleSizeDesired+0.05*EleSizeCurrent;
W=0.5;
EleSizeDesired=W*EleSizeDesired+(1-W)*EleSizeCurrent;

% and also put strickt limits on change in EleSize:
EleSizeRatio=EleSizeDesired./EleSizeCurrent;

I=EleSizeRatio>CtrlVar.MaxRatioOfChangeInEleSizeDuringAdaptMeshing;
EleSizeDesired(I)=CtrlVar.MaxRatioOfChangeInEleSizeDuringAdaptMeshing*EleSizeCurrent(I);

I=EleSizeRatio<CtrlVar.MinRatioOfChangeInEleSizeDuringAdaptMeshing ;
EleSizeDesired(I)=CtrlVar.MinRatioOfChangeInEleSizeDuringAdaptMeshing*EleSizeCurrent(I);

%%
% Set elesizes around GL to a specific value


if isfield(CtrlVar,'MeshAdapt') && isfield(CtrlVar.MeshAdapt,'GLrange')
    
    %fprintf('Remeshing based on distance of nodes from grounding line.\n')
    
    KdTree=[];
    CtrlVar.PlotGLs=0;
    CtrlVar.GLsubdivide=1;
    [xGL,yGL]=PlotGroundingLines(CtrlVar,MUA,GF);
    
    
    for I=1:size(CtrlVar.MeshAdapt.GLrange,1)
        
        ds=CtrlVar.MeshAdapt.GLrange(I,1);
        dh=CtrlVar.MeshAdapt.GLrange(I,2);
        if dh<CtrlVar.MeshSizeMin
            fprintf('---> Warning: CtrlVar.MeshAdapt.GLrange(%i,2)=%g<CtrlVar.MeshSizeMin=%g \n',I,dh,CtrlVar.MeshSizeMin)
            fprintf('              Setting CtrlVar.MeshAdapt.GLrange(%i,2)=%g \n',I,CtrlVar.MeshSizeMin)
            dh=CtrlVar.MeshSizeMin;
        end
        fprintf('Nodes within the distance of %g from the grounding line are given the target element size %g \n',ds,dh)
        
        ID=FindAllNodesWithinGivenRangeFromGroundingLine(CtrlVar,MUA,xGL,yGL,ds,KdTree);
        
        EleSizeIndicator(ID)=dh;
        EleSizeDesired=min(EleSizeDesired,EleSizeIndicator);
    end
    
    
end
%%



% No further user defined modifications to EleSizeDesired

%% now create a (logical) list of elements to be locally refined

% switch CtrlVar.RefinementCriteria
%
%     case 'residuals'
%
%         EleResiduals=Nodes2EleMean(MUA.connectivity,NodalErrorIndicators.Residuals);
%         EleResidualsSorted=sort(EleResiduals);
%         ElementsToBeRefined=EleResiduals>EleResidualsSorted(end-CtrlVar.LocalAdaptMeshMaxNrOfElementsToBeRefined);
%         ElementsToBeCoarsened=false(MUA.Nele,1);
%
%     otherwise

eRatio=EleSizeDesired./EleSizeCurrent;
eRatio=Nodes2EleMean(MUA.connectivity,eRatio);

% do not refine a greater number of elements than CtrlVar.MeshRefinementRatio*CurrentNumberOfElements
% at any given refinement step

test=sort(eRatio);
ElementsToBeRefined=eRatio<=test(ceil(numel(eRatio)*CtrlVar.LocalAdaptMeshRatio)) & eRatio<0.75;

% have to make sure that if an element has just been refined that it will not
% then afterwards be a candidate for coarsening. If an element was refined, the
% size decreased by about a factor of 2 so if the ratio was 1+eps it is now
% 0.5+eps and I must set eRatio>2 at the very least, for coarsening

ElementsToBeCoarsened=eRatio>=test(floor(numel(eRatio)*CtrlVar.LocalAdaptMeshRatio)) & eRatio>3;

%end



%% Now finally a user modification to EleSizeDesired and ElementsToBeRefined



[UserVar,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened]=GetDesiredEleSize(UserVar,CtrlVar,MUA,F,GF,xNod,yNod,EleSizeDesired,ElementsToBeRefined,ElementsToBeCoarsened,NodalErrorIndicators);

assert(numel(xNod)==numel(yNod) && numel(xNod)==numel(EleSizeDesired),' Number of elements in x, y, and EleSize must be equal')


if   CtrlVar.doplots==1 && CtrlVar.doAdaptMeshPlots && CtrlVar.InfoLevelAdaptiveMeshing>=10

    
    if contains(lower(CtrlVar.MeshRefinementMethod),'global')
        
        fig=findobj(0,'name','Global mesh refinement');
        
        if isempty(fig)
            figure('name','Global mesh refinement')
        else
            figure(fig)
            hold off
        end
        
        subplot(1,2,1,'replace')
        hold off
        PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,EleSizeDesired,CtrlVar);
        title(' final desired ele sizes after user modification ');
        
        subplot(1,2,2,'replace')
        PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,EleSizeCurrent,CtrlVar);
        title(' current ele sizes  ');
        hold off
        drawnow
        
        
        
    elseif contains(lower(CtrlVar.MeshRefinementMethod),'local')
        
        fig=findobj(0,'name','Local mesh refinement');
        
        if isempty(fig)
            fig=figure('name','Local mesh refinement');
            fig.Position=[1100,100,1000,1000] ;
        else
            fig=figure(fig);
            hold off
        end
        
        CtrlVar.WhenPlottingMesh_PlotMeshBoundaryCoordinatesToo=0;
        
        PlotMuaMesh(CtrlVar,MUA,[],'k');
        hold on
        PlotMuaMesh(CtrlVar,MUA,ElementsToBeRefined,'b');
        PlotMuaMesh(CtrlVar,MUA,ElementsToBeCoarsened,'r');
        axis tight
        drawnow
        nR=numel(find(ElementsToBeRefined));
        nC=numel(find(ElementsToBeCoarsened));
        title(sprintf('Elements to be refined(%i)/coarsened(%i) in blue/red',nR,nC))
        fprintf('  Number of elements to be refined: %i \n',numel(find(ElementsToBeRefined)))
        fprintf('Number of elements to be coarsened: %i \n',numel(find(ElementsToBeCoarsened)))
        
    end
    
    
    
end





