function      [UserVar,MUA,BCs,F,l,GF,InvStartValues,Priors,Meas,BCsAdjoint,RunInfo]=...
    GetInputsForInverseRestartRun(UserVar,CtrlVar)


fprintf(CtrlVar.fidlog,' Inverse run: loading restart file: %s \t ',CtrlVar.Inverse.NameOfRestartInputFile);

load(CtrlVar.Inverse.NameOfRestartInputFile,...
    'CtrlVarInRestartFile','UserVarInRestartFile','MUA','BCs','F','GF','l','RunInfo',...
    'InvStartValues','Priors','Meas','BCsAdjoint','InvFinalValues');

fprintf(CtrlVar.fidlog,' done \n ');


if isempty(RunInfo.CPU)
    RunInfo.CPU.Solution=0;
    RunInfo.CPU.Assembly=0;
end
% Set start values to last estimates
InvStartValues=InvFinalValues;


[InvStartValues.AGlen,InvStartValues.n]=TestAGlenInputValues(CtrlVar,MUA,InvStartValues.AGlen,InvStartValues.n);
[Priors.AGlen,Priors.n]=TestAGlenInputValues(CtrlVar,MUA,Priors.AGlen,Priors.n);

[InvStartValues.C,InvStartValues.m]=TestSlipperinessInputValues(CtrlVar,MUA,InvStartValues.C,InvStartValues.m);
[Priors.C,Priors.m]=TestSlipperinessInputValues(CtrlVar,MUA,Priors.C,Priors.m);

[Priors.rho,Priors.rhow]=TestDensityInputValues(CtrlVar,MUA,Priors.rho,Priors.rhow);

isCorrectDimensions=DoPriorsHaveCorrectDimensions(CtrlVar,MUA,Priors);


if ~isCorrectDimensions
    
    [UserVar,~,Priors,~,~]=DefineInputsForInverseRun(UserVar,CtrlVar,MUA,BCs,InvStartValues,Priors,Meas,BCsAdjoint,CtrlVar.time,AGlen,C,n,m,s,b,S,B,rho,rhow,GF);
    
end

isCorrectDimensions=DoPriorsHaveCorrectDimensions(CtrlVar,MUA,Priors);
if ~ isCorrectDimensions
    fprintf(' Priors do not have right dimensions at restart. \n')
    fprintf(' Modify DefineInputsForInverseRun to ensure that dimensions are correct.\n')
    error('Ua:GetInputForInverseRestartRun:incorrectdimensions','incorrect dimensions')
    
end

end