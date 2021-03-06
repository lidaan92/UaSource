function  [UserVar,F,l,Kuv,Ruv,RunInfo,L]=SSTREAM2dNR(UserVar,CtrlVar,MUA,BCs,F,l,RunInfo)


nargoutchk(7,7)
narginchk(7,7)

tStart=tic;
RunInfo.Forward.Converged=1; RunInfo.Forward.Iterations=NaN;  RunInfo.Forward.Residual=NaN;

MLC=BCs2MLC(MUA,BCs);
L=MLC.ubvbL;
cuv=MLC.ubvbRhs;



if isempty(cuv)
    l.ubvb=[];
elseif numel(l.ubvb)~=numel(cuv)
    l.ubvb=zeros(numel(cuv),1) ;
end

if any(isnan(F.C)) ; save TestSave ; error( ' C nan ') ; end
if any(isnan(F.AGlen)) ; save TestSave ;error( ' AGlen nan ') ; end
if any(isnan(F.S)) ; save TestSave ; error( ' S nan ') ; end
if any(isnan(F.h)) ; save TestSave error( ' h nan ') ; end
if any(isnan(F.ub)) ; save TestSave ; error( ' ub nan ') ; end
if any(isnan(F.vb)) ; save TestSave ; error( ' vb nan ') ; end
if any(isnan(l.ubvb)) ; save TestSave ; error( ' ubvbLambda nan ') ; end
if any(isnan(F.rho)) ; save TestSave  ; error( ' rho nan ') ; end
if any(F.h<0) ; warning('MATLAB:SSTREAM2dNR:hnegative',' thickness negative ') ; end



%%


% Solves the SSTREAM equations in 2D (sparse and vectorized version) using Newton-Raphson iteration

% lambda are the Lagrange parameters used to enfore the boundary conditions

% Newton-Raphson is:
% K \Delta x_i = -R ; x_{i+1}= x_{i}+ \Delta x_i
% R=T-F
% T : internal nodal forces
% F : external nodal forces
% K : tangent matrix, where K is the directional derivative of R in the direction (Delta u, \Delta v)

% I need to solve
%
% [Kxu Kxv Luv'] [du]        =  [ -Ru ] - Luv' lambdauv
% [Kyu Kyv     ] [dv]        =  [ -Rv ]
% [  Luv      0] [dlambdauv]    [ Lrhsuv-Luv [u ;v ]
%
% All matrices are Nnodes x Nnodes, apart from:
% Luv is #uv constraints x 2 Nnodes
%

% I write the system as
% [Kuv  Luv^T ]  [duv]  =  [ -R(uv) - Luv^T l]
% [Luv   0    ]  [dl]      [cuv-Luv uv]
%






dub=zeros(MUA.Nnodes,1) ; dvb=zeros(MUA.Nnodes,1) ; dl=zeros(numel(l.ubvb),1);
RunInfo.CPU.solution=0 ; RunInfo.CPU.Assembly=0;

tAssembly=tic;
F0=KRTFgeneralBCs(CtrlVar,MUA,F,true);


Ruv=KRTFgeneralBCs(CtrlVar,MUA,F);
RunInfo.CPU.Assembly=toc(tAssembly);
RunInfo.CPU.Solution=0;

if ~isempty(L)
    frhs=-Ruv-L'*l.ubvb;
    grhs=cuv-L*[F.ub;F.vb];
else
    frhs=-Ruv;
    grhs=[];
end

r=ResidualCostFunction(frhs,grhs,F0,MUA.Nnodes);
% 
% if r< CtrlVar.NLtol
%     
%     RunInfo.Forward.Iterations=0;  RunInfo.Forward.Residual=r; RunInfo.CPU.Assembly=0; RunInfo.CPU.Solution=0; 
%     Kuv=[];
%     return
%     
% end




diffDu=0; 

iteration=0;  ResidualReduction=1e10; RunInfo.CPU.solution=0 ; RunInfo.CPU.Assembly=0;
while ((r> CtrlVar.NLtol  || diffDu > CtrlVar.du  )&& iteration <= CtrlVar.NRitmax  )  || (iteration < CtrlVar.NRitmin)
    
    
    iteration=iteration+1;
    
    %RunInfo.CPU.Assembly=0  ; RunInfo.CPU.Solution=0; % Do I want cumulative
    %numbers?
    
    
    if rem(iteration-1,CtrlVar.ModifiedNRuvIntervalCriterion)==0  || ResidualReduction> CtrlVar.ModifiedNRuvReductionCriterion
        
        tAssembly=tic;
        [Ruv,Kuv]=KRTFgeneralBCs(CtrlVar,MUA,F);
        RunInfo.CPU.Assembly=toc(tAssembly)+RunInfo.CPU.Assembly;
        NRincomplete=0;
    else
        tAssembly=tic;
        Ruv=KRTFgeneralBCs(CtrlVar,MUA,F);
        RunInfo.CPU.Assembly=toc(tAssembly)+RunInfo.CPU.Assembly;
        NRincomplete=1;
    end
    
    %
    %     if iteration==1
    %         F0=R0 ; % F0 is used as a normalisation factor when calculating the residual, do not change this normalisation factor in the course of the iteration.
    %         % As it happens, due to the way it is defined, F only depends on the right-hand side, so F could be updated in the course of the non-linear iteration
    %         % without affecting its value.
    %     end
    %
    %
    
    
    if CtrlVar.TestForRealValues
        if ~isreal(Kuv) ; save TestSave Kuv ; error('SSTREAM2dNR: K not real') ;  end
        if ~isreal(L) ; save TestSave L ; error('SSTREAM2dNR: L not real') ;  end
    end
    
    if any(isnan(Kuv)) ; save TestSave Kuv ; error('SSTREAM2dNR: K nan') ;  end
    if any(isnan(L)) ; save TestSave L ; error('SSTREAM2dNR: L nan') ;  end
    
    CtrlVar.Solver.isUpperLeftBlockMatrixSymmetrical=issymmetric(Kuv) ;
    
    
    
    % [Kuv  Luv' ]  [duv]  =  [ -R(uv) - Luv' l]
    % [Luv   0    ]  [dl]      [ cuv-Luv uv      ]
    
    if ~isempty(L)
        frhs=-Ruv-L'*l.ubvb;
        grhs=cuv-L*[F.ub;F.vb];
    else
        frhs=-Ruv;
        grhs=[];
    end
    
    r0=ResidualCostFunction(frhs,grhs,F0,MUA.Nnodes);
    
    tSolution=tic;
    
    
    if CtrlVar.Solver.isUpperLeftBlockMatrixSymmetrical
        [sol,dl]=solveKApeSymmetric(Kuv,L,frhs,grhs,[dub;dvb],dl,CtrlVar);
    else
        [sol,dl]=solveKApe(Kuv,L,frhs,grhs,[dub;dvb],dl,CtrlVar);
    end
    
    RunInfo.CPU.Solution=toc(tSolution)+RunInfo.CPU.Solution;
    
    
    if CtrlVar.TestForRealValues
        dub=real(sol(1:MUA.Nnodes)) ; dvb=real(sol(MUA.Nnodes+1:2*MUA.Nnodes));
    else
        dub=sol(1:MUA.Nnodes) ; dvb=sol(MUA.Nnodes+1:2*MUA.Nnodes);
    end
    
    % Evaluate force residual at full Newton step
    
    gamma=1;
    [UserVar,r1] =  CalcCostFunctionNR(UserVar,CtrlVar,MUA,gamma,F,F0,L,l,cuv,dub,dvb,dl);
    
    %[UserVar,r1] = CalcCostFunctionNR(UserVar,CtrlVar,MUA,1,s,S,B,h,ub,dub,vb,dvb,uo,vo,AGlen,n,C,m,alpha,rho,rhow,g,F0,L,l.ubvb,dl,cuv);
    
    [UserVar,r,gamma,infovector,BacktrackInfo] = FindBestGamma2Dbacktracking(UserVar,CtrlVar,MUA,F,F0,r0,r1,L,l,cuv,dub,dvb,dl);
    %[UserVar,r,gamma,infovector,BacktrackInfo] = FindBestGamma2Dbacktracking(UserVar,CtrlVar,MUA,F0,r0,r1,s,S,B,h,ub,dub,vb,dvb,uo,vo,AGlen,n,C,m,alpha,rho,rhow,g,L,l.ubvb,dl,cuv);
    
    if BacktrackInfo.Converged==0
        fprintf(CtrlVar.fidlog,' SSTREAM2dNR backtracking step did not converge \n ') ;
        warning('SSTREAM2NR:didnotconverge',' SSTREAM2dNR backtracking step did not converge \n ')
        fprintf(CtrlVar.fidlog,' saving variables in SSTREAM2dNRDump \n ') ;
        save SSTREAM2dNRDump
        
    end
    
    %% If requested, plot residual as function of steplength
    if CtrlVar.InfoLevelNonLinIt>=10 && CtrlVar.doplots==1
        nnn=10;
        gammaTestVector=zeros(nnn,1) ; rTestvector=zeros(nnn,1);
        
        Up=2.2;
        if gamma>0.7*Up ; Up=2*gamma; end
        parfor I=1:nnn
            gammaTest=Up*(I-1)/(nnn-1)+gamma/250;
            [~,rTest] = CalcCostFunctionNR(UserVar,CtrlVar,MUA,gammaTest,F,F0,L,l,cuv,dub,dvb,dl)
            %[~,rTest]=CalcCostFunctionNR(UserVar,CtrlVar,MUA,gammaTest,s,S,B,h,ub,dub,vb,dvb,uo,vo,AGlen,n,C,m,alpha,rho,rhow,g,F0,L,l.ubvb,dl,cuv);
            gammaTestVector(I)=gammaTest ; rTestvector(I)=rTest;
        end
        
        gammaTestVector=[gammaTestVector(:);infovector(:,1)];
        rTestvector=[rTestvector(:);infovector(:,2)];
        [gammaTestVector,ind]=unique(gammaTestVector) ; rTestvector=rTestvector(ind) ;
        [gammaTestVector,ind]=sort(gammaTestVector) ; rTestvector=rTestvector(ind) ;
        
        
        
        FigName='SSTREAM backtracking';
        fig=findobj(0,'name',FigName);
        if isempty(fig)
            fig=figure('name',FigName);
            fig.Position=[20,620,600,600] ;
        else
            fig=figure(fig);
            hold off
        end
        
        plot(gammaTestVector,rTestvector,'o-r') ; hold on ;
        
        plot(gamma,r,'Marker','h','MarkerEdgeColor','k','MarkerFaceColor','g')
        
        slope=-2*r0;
        plot([gammaTestVector(1) gammaTestVector(2)],[rTestvector(1) rTestvector(1)+(gammaTestVector(2)-gammaTestVector(1))*slope],'g')
        title(sprintf('iteration %i ',iteration)) ; hold off
        
        %input('press return to continue')
    end
    
    D=mean(sqrt(F.ub.*F.ub+F.vb.*F.vb));
    diffDu=full(max(abs(gamma*dub))+max(abs(gamma*dvb)))/D; % sum of max change in du and dv normalized by mean speed
    diffDlambda=full(max(abs(gamma*dl))/mean(abs(l.ubvb)));
    diffVector(iteration)=r0;   % override last value, because it was just a (very accurate) estimate
    diffVector(iteration+1)=r;
    
    F.ub=F.ub+gamma*dub ;
    F.vb=F.vb+gamma*dvb;
    l.ubvb=l.ubvb+gamma*dl;
    
    ResidualReduction=r/r0;
    
    if CtrlVar.InfoLevelNonLinIt>100  && CtrlVar.doplots==1
        PlotForceResidualVectors('uv',Ruv,L,l.ubvb,MUA.coordinates,CtrlVar) ; axis equal tight
    end
    if CtrlVar.InfoLevelNonLinIt>=1
        if NRincomplete
            stri='i';
        else
            stri=[];
        end
        fprintf(CtrlVar.fidlog,'%sNRuv:%3u/%-2u g=%-14.7g , r/r0=%-14.7g ,  r0=%-14.7g , r=%-14.7g , du=%-14.7g , dl=%-14.7g , Assembly=%f sec. Solution=%f sec.\n ',...
            stri,iteration,BacktrackInfo.iarm,gamma,r/r0,r0,r,diffDu,diffDlambda,RunInfo.CPU.Assembly,RunInfo.CPU.Solution);
    end
    
end

tEnd=toc(tStart);

if CtrlVar.InfoLevelNonLinIt>3 && iteration >= 2
    
    N=max([1,iteration-5]);
    
    [~,~,a1]=detrend_xt(log10(diffVector(N:iteration)),N:iteration);
    fprintf(CtrlVar.fidlog,' slope NR : %14.7g \n',a1);
    if CtrlVar.doplots==1
        figure ; semilogy(0:iteration,diffVector(1:iteration+1),'x-r') ;
        title('r^2 residual (NR uv diagnostic step)') ; xlabel('Iteration') ; ylabel('r^2 (Residual)')
    end
    
end

if isnan(r)
    fprintf(CtrlVar.fidlog,' SSTREAM2dNR returns NAN as residual!!! \n') ;
    warning('uvSSTREAM:didnotconverge',' SSTREAM2dNR did not converge to a solution. Saving all variables in TestSaveNR.mat \n ')
    save TestSaveNR
elseif r>CtrlVar.NLtol
    fprintf(CtrlVar.fidlog,' SSTREAM2dNR did NOT converge to given tolerance of %-g with r=%-g in %-i iterations and in %-g  sec \n',CtrlVar.NLtol,r,iteration,tEnd);
    RunInfo.Forward.Converged=0;
    warning('uvSSTREAM:didnotconverge',' SSTREAM2dNR did not converge to a solution. Saving all variables in TestSaveNR.mat \n ')
    save TestSaveNR
else
    if CtrlVar.InfoLevel>0
        if CtrlVar.InfoLevelNonLinIt>0
            fprintf(CtrlVar.fidlog,' SSTREAM2dNR converged to given tolerance of %-g with r=%-g in %-i iterations.\n',CtrlVar.NLtol,r,iteration) ;
        end
        if CtrlVar.InfoLevelCPU>0  % if 1 then some info on CPU time usage is given
            fprintf(CtrlVar.fidlog,' CPU-uvSSTREAM: total time=%g \t Assembly=%g \t Solution=%g \n',tEnd,RunInfo.CPU.Assembly,RunInfo.CPU.Solution) ;
        end
    end
    
end


if iteration > CtrlVar.NRitmax
    fprintf(CtrlVar.fidlog,'Maximum number of NR iterations %-i reached in uv-SSTREAM loop with r=%-g \n',CtrlVar.NRitmax,r);
    warning('SSTREAM2dNR:MaxIterationReached','uv-SSTREAM exits because maximum number of iterations %-i reached with r=%-g \n',CtrlVar.NRitmax,r)
end

RunInfo.Forward.Iterations=iteration;  RunInfo.Forward.Residual=r;

if any(isnan(F.ub)) || any(isnan(F.vb))  ; save TestSaveNR  ;  error(' nan in ub vb ') ; end



end

