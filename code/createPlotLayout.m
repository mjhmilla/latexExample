function [subPlotPositions,pageWidth,pageHeight] = ...
    createPlotLayout(plotSettings)



pageWidth = plotSettings.columns*(...
                plotSettings.width+plotSettings.horizontalMargin)...
                +plotSettings.horizontalMargin;
pageHeight= plotSettings.rows*(...
                plotSettings.height+plotSettings.verticalMargin)...
                +plotSettings.verticalMargin;

subPlotPositions = zeros(plotSettings.rows,plotSettings.columns,4);

topLeft = [0, pageHeight];



for i=1:1:plotSettings.rows
    for j=1:1:plotSettings.columns        
          if(j==1)
              %coordinates of the left bottom corner
              subPlotPositions(i,j,1) = ...
                  topLeft(1,1)+plotSettings.horizontalMargin; 
              subPlotPositions(i,j,2) = topLeft(1,2)...
                    -(plotSettings.height+plotSettings.verticalMargin)*i;
          else
              %coordinates of the left bottom corner using the previous
              %subplot as a reference
              subPlotPositions(i,j,1) = subPlotPositions(i,j-1,1)...
                  + plotSettings.width+plotSettings.horizontalMargin;                 
              subPlotPositions(i,j,2) = subPlotPositions(i,j-1,2);
          end
          subPlotPositions(i,j,3) = plotSettings.width;
          subPlotPositions(i,j,4) = plotSettings.height;    
    end
end

%Normalize the units by pageWidth and pageHeight
pageNormalization = [pageWidth,pageHeight,pageWidth,pageHeight];
for i=1:1:plotSettings.rows
    for j=1:1:plotSettings.columns  
        for k=1:1:4
          subPlotPositions(i,j,k) = ...
              subPlotPositions(i,j,k)./pageNormalization(1,k);
        end
    end
end


set(groot, 'defaultAxesFontSize',plotSettings.baseFontSize);
set(groot, 'defaultTextFontSize',plotSettings.baseFontSize);
set(groot, 'defaultAxesLabelFontSizeMultiplier',1.1);
set(groot, 'defaultAxesTitleFontSizeMultiplier',1.1);
set(groot, 'defaultAxesTickLabelInterpreter',plotSettings.interpreter);
set(groot, 'defaultLegendInterpreter',plotSettings.interpreter);
set(groot, 'defaultTextInterpreter',plotSettings.interpreter);
set(groot, 'defaultAxesTitleFontWeight','normal');  
set(groot, 'defaultFigurePaperUnits',plotSettings.units);
set(groot, 'defaultFigurePaperSize',[pageWidth pageHeight]);
%set(groot,'defaultFigurePaperType','A4');

