clc;
close all;
clear all;

%%
%Hint 1: Use plotSettings and createPlotLayout to generate plots that
%        are exactly the size you need in your publication.
%%

legendLineLength=0.25; %Makes the lines 25% the original length

plotSettings.columns = 3;
plotSettings.rows    = 2;
plotSettings.width   = 4.;             
plotSettings.height  = 4.;             
plotSettings.horizontalMargin = 1.5;  
plotSettings.verticalMargin   = 1.5;  
plotSettings.units  ='centimeters';

plotSettings.interpreter = 'latex';
plotSettings.baseFontSize = 6;
plotSettings.axesTitleFontSizeMultiplier = 8/6;
plotSettings.axesTickFontSizeMultiplier  = 1;

[subPlotPositions,pageWidth,pageHeight] = createPlotLayout(plotSettings);

fprintf('%1.1fcm\t page width (standard 1 column is 18.0 cm)\n',pageWidth);
fprintf('%1.1fcm\t page height (standard 1 page is 25.0 cm)\n',pageHeight);

subPlotTitleIndices = {'A','B','C','D','E','F'};

subPlotSettings(6)=struct('xlim',[],'ylim',[],...
                          'xticks',[],'yticks',[],'xtickLabels',[]);
for i=1:1:length(subPlotSettings)
    subPlotSettings(i).xlim=[0,2*pi];
    subPlotSettings(i).ylim=[-1.1,1.35];
    subPlotSettings(i).xticks=[0:0.25:1].*(2*pi);

    %Just to be fancy we'll replace the xticks with our own labels that
    %make use of the \pi symbol in latex
    subPlotSettings(i).xtickLabels = ...
        {'0','$$0.5\pi$$','$$\pi$$','$$1.5\pi$$','$$2\pi$$'};

    subPlotSettings(i).yticks=[-1,0,1];    
end

figExample=figure;
idx=1;


for i=1:1:plotSettings.rows
    for j=1:1:plotSettings.columns
        figure(figExample);
        subplot('Position',reshape(subPlotPositions(i,j,:),1,4));

        %Plot some dummy data
        npts=100;
        omega = [0:(1/(npts-1)):1]'.*(2*pi);
               
        %%
        %Hint 2: Use 'DisplayName' to set legend entries. 
        %        Use 'HandleVisibility','off' to remove legend entries
        %%
        
        %Example experimental data
        plot(omega, sin(omega)+rand(length(omega),1).*0.3-0.15,...
            '-k','DisplayName','Exp: Force')
        hold on;

        %A background line to enhance the contrast of the model
        %This line should NOT be in the legend so 'HandleVisibility' is 
        % set to 'off'
        plot(omega, sin(omega),...
            '-w','LineWidth',2,'HandleVisibility','off');                
        hold on;

        %The example model data
        plot(omega, sin(omega),...
            '-b','DisplayName','Model');                
        hold on;

        ylabel('Norm. Force');
        xlabel('Time (s)');
        title(sprintf('%s. Treatment %i Model %i',...
            subPlotTitleIndices{idx},i,j));

        xlim(subPlotSettings(idx).xlim);
        ylim(subPlotSettings(idx).ylim);
        xticks(subPlotSettings(idx).xticks);
        yticks(subPlotSettings(idx).yticks);
        xticklabels(subPlotSettings(idx).xtickLabels);
        
        box off;

        %Matlab legend entries have huge lines. To reduce the line length
        %use the function 'scaleLegendLines' which I've coded up. This
        %will work for points and fill entries as well.
        [lgdH, lgdIcons, lgdPlots, lgdTxt]=legend('Location','NorthEast');


        %%
        %Hint 3: Use scaleLegendLines and the code below to make the 
        %        legend generated by Matlab smaller.
        %%        
        %Scale the legend lines
        [lgdH, lgdIcons, lgdPlots, lgdTxt,xDataOrig,xDataUpd] = ...
            scaleLegendLines(legendLineLength,lgdH, lgdIcons, lgdPlots, lgdTxt);

        %Adjust the legend box position. Note the units used are normalized
        %so 0.12 means 12% of the page width and 0.025 means 2.5% of the 
        %page height.
        pos=get(lgdH,'Position');
        pos(1)=pos(1)-(xDataUpd(1)-xDataOrig(1))*pos(3) + 0.01;
        pos(1)=pos(1)+0.12;
        pos(2)=pos(2)+0.025;
        set(lgdH,'Position',pos);
     
        

        legend boxoff;


        idx=idx+1;
    end
end


%%
%Hint 4: Save to pdf for your latex documents: this is a vector graphic
%        so you can edit it/annotate it easily later. Save a fig version
%        so that you can use matlab to explore the data without having
%        to re-generate the plot.
%%     

figExample = configPlotExporter(figExample,pageWidth,pageHeight);
fileName = 'fig_exampleSingleColumnPlot';
print('-dpdf', [fileName,'.pdf']);
 saveas(figExample,fileName,'fig');



