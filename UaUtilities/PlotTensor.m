function PlotTensor(x,y,txx,txy,tyy,scale,LineWidth)

% Plots a 2x2 symmetrical tensor quantity.
% PlotTensor(x,y,txx,txy,tyy,scale,LineWidth)
%
% Tensor T=[txx  txy]
%          [txy  tyy]
%
% Compression is plotted in red, extension in blue.
%




    headscale=0.3;
    sharp=0.3;
    
    if nargin<7 ; LineWidth=1; end
    
    for k=1:length(x)
        
        if ~isnan(txx(k))
            D=[txx(k) txy(k) ; txy(k) tyy(k)];
            [pAxis,pStrains]=eig(D); l1=pStrains(1,1) ; l2=pStrains(2,2);
            
            
            p1x=l1*pAxis(1,1) ; p1y=l1*pAxis(2,1) ;
            p2x=l2*pAxis(1,2) ; p2y=l2*pAxis(2,2) ;
            
            
            if l1 < 0
                head=-1;
                col=[1 0 0 ];
            else
                head=1;
                col=[0 0 1];
            end
            
            
            ghg_arrow(x(k),y(k),p1x,p1y,scale,headscale,sharp,head,col,LineWidth);
            ghg_arrow(x(k),y(k),-p1x,-p1y,scale,headscale,sharp,head,col,LineWidth);
            
            if l2 < 0
                head=-1;
                col=[1 0 0 ];
            else
                head=1;
                col=[0 0 1];
            end
            ghg_arrow(x(k),y(k),p2x,p2y,scale,headscale,sharp,head,col,LineWidth);
            ghg_arrow(x(k),y(k),-p2x,-p2y,scale,headscale,sharp,head,col,LineWidth);
        end
    end
    
    
    return
    
end
