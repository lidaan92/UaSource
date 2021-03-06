function MLC=BCs2MLC(MUA,BCs)

%
% this only works if MUA has not changed either, if MUA has changed, but BCs
% have not, this will results in an error!
% persistent LastMLC LastBCs
% 
% if isequal(BCs,LastBCs)
%     MLC=LastMLC;
%     return
% end
%
%

MLC=MultiLinearConstraints;

%% input tests

if numel(BCs.ubTiedNodeA) ~= numel(BCs.ubTiedNodeB) ; save TestSave ; error(' number of elements  in BCs.uTiedNodeA and BCs.uTiedNodeB  not the same ') ; end
if numel(BCs.vbTiedNodeA) ~= numel(BCs.vbTiedNodeB) ; save TestSave ; error(' number of elements  in BCs.uTiedNodeA and BCs.uTiedNodeB not the same ') ; end

% get rid of duplicate boundary conditions and just ignore extra BCs
[ubFixedNodet,itemp]=unique(BCs.ubFixedNode) ; BCs.ubFixedValue=BCs.ubFixedValue(itemp);
[vbFixedNodet,itemp]=unique(BCs.vbFixedNode) ; BCs.vbFixedValue=BCs.vbFixedValue(itemp);
% 
% if numel(ubFixedNodet) ~= numel(BCs.ubFixedNode)  ; disp(' Duplicate Dirichlet BCs for u') ; end
% if numel(vbFixedNodet) ~= numel(BCs.vbFixedNode)  ; disp(' Duplicate Dirichlet BCs for v') ; end

BCs.ubFixedNode=ubFixedNodet; BCs.vbFixedNode=vbFixedNodet;

%% now set up Lagrange matrices
% velocity
[ubvbL,ubvbRhs]=CreateLuv(MUA,BCs.ubFixedNode,BCs.ubFixedValue,BCs.vbFixedNode,BCs.vbFixedValue,BCs.ubTiedNodeA,BCs.ubTiedNodeB,BCs.vbTiedNodeA,BCs.vbTiedNodeB,BCs.ubvbFixedNormalNode,BCs.ubvbFixedNormalValue);
[udvdL,udvdRhs]=CreateLuv(MUA,BCs.udFixedNode,BCs.udFixedValue,BCs.vdFixedNode,BCs.vdFixedValue,BCs.udTiedNodeA,BCs.udTiedNodeB,BCs.vdTiedNodeA,BCs.vdTiedNodeB,BCs.udvdFixedNormalNode,BCs.udvdFixedNormalValue);

% thickness
% here add pos. thickness constraints

[hL,hRhs]=createLh(MUA.Nnodes,[BCs.hFixedNode;BCs.hPosNode],[BCs.hFixedValue;BCs.hPosValue],BCs.hTiedNodeA,BCs.hTiedNodeB);


MLC.ubvbL=ubvbL ; MLC.ubvbRhs=ubvbRhs ;
MLC.udvdL=udvdL ; MLC.udvdRhs=udvdRhs ;
MLC.hL=hL; MLC.hRhs=hRhs; 

%LastBCs=BCs ; LastMLC=MLC;


end


