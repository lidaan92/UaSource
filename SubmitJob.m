
locdir=pwd; indsGHG=strfind(upper(locdir),'GHG'); 
D=[locdir(1:indsGHG+2),'/ssa/FEicestream2dDevelopment'];


%job=batch('SSS2dTest','matlabpool',0,'CaptureDiary',true,'configuration','local','PathDependencies',D)

jobSci=batch('SSS2dTest','matlabpool',0,'CaptureDiary',true,'configuration','SciHub','PathDependencies',D)

