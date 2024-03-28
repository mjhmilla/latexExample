function [lgdH, lgdIcons, lgdPlots, lgdTxt,xDataOrig,xDataUpd] = ...
    scaleLegendLines(scale,lgdH, lgdIcons, lgdPlots, lgdTxt)

xDataOrig =[];
xDataUpd =[];

%Go and get the line length
idxIcon =1;
found = 0;
while idxIcon < length(lgdIcons) && found == 0
    objClass=class(lgdIcons(idxIcon));
    if(contains(objClass,'matlab.graphics.primitive.Line')==1)
        if(contains(lgdIcons(idxIcon).Marker,'none'))
            found=1;
            xDataOrig = lgdIcons(idxIcon).XData;
        end
    end
    if(contains(objClass,'matlab.graphics.primitive.Patch')==1)
        xDataOrig = [lgdIcons(idxIcon).Vertices(1,1),...
                     lgdIcons(idxIcon).Vertices(3,1)];
        found=1;
    end
    if(found==0)
        idxIcon = idxIcon+1;
    end
end

if(found==1)
    lineLength = diff(xDataOrig);
    xDataUpd = [xDataOrig(1)+lineLength*(1-scale), xDataOrig(2)];
    
    for idxIcon = 1:1:length(lgdIcons)
        objClass=class(lgdIcons(idxIcon));    
        if(contains(objClass,'matlab.graphics.primitive.Line')==1)        
            if(contains(lgdIcons(idxIcon).Marker,'none'))
                lgdIcons(idxIcon).XData = xDataUpd;
            else
                lgdIcons(idxIcon).XData = mean(xDataUpd);
            end
        end
        if(contains(objClass,'matlab.graphics.primitive.Patch')==1)  
            vertices = lgdIcons(idxIcon).Vertices;
            vertices(1,1)= vertices(1,1)+ (1-scale)*(vertices(3,1)-vertices(1,1));
            vertices(2,1)= vertices(2,1)+ (1-scale)*(vertices(4,1)-vertices(2,1));
            lgdIcons(idxIcon).Vertices=vertices;
        end
    end
    
    
    pos = get(lgdH,'Position');
    dx = xDataUpd(1)-xDataOrig(1);
    dxN = dx*pos(3);
    pos(1) = pos(1) - dxN;
    set(lgdH,'Position',pos);
    here=1;
end