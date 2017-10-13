function figstruct = OpenMatlabFigureInOctave(filename)
% figstruct = OpenMatlabFigureInOctave(filename);
% input: filename to a MATLAB fig file.
% output: structure loaded from the Fig file
%  and
% a Plot that reproduces most interesting features of most MATLAB figs. 
% 
% by Peter Adamczyk, 2013-05-10
% inspired by OCTread_Fig.m from Cibby Pulikkaseril
% 


figstruct = load(filename,'-mat');

mainfield = fieldnames(figstruct); 
figstruct = figstruct.(mainfield{1});

for ii = 1:length(figstruct)
    hfig(ii) = figure(figstruct(ii).handle);

    figprops = fieldnames(figstruct(ii).properties);
    for jj = 1:length(figprops)
        try
            set(hfig(ii),  (figprops{jj}), figstruct(ii).properties.(figprops{jj})) ;
        catch
        end
    end

    for jj = 1:length(figstruct(ii).children)

        switch figstruct(ii).children(jj).type
        case {'axes', 'scribe.scribeaxes'}
            hax(ii,jj) = axes(); hold on; %Create Axes
            % apply Axis Properties
            axprops = fieldnames(figstruct(ii).children(jj).properties);
            for kk = 1:length(axprops)
                try
                    set(hax(ii,jj), (axprops{kk}), figstruct(ii).children(jj).properties.(axprops{kk}) ); 
                catch
                end
            end

            for kk = 1:length(figstruct(ii).children(jj).children)
                hkidoriginal(ii,jj,kk) = figstruct(ii).children(jj).children(kk).handle; % original figure's handle to this object

                switch figstruct(ii).children(jj).children(kk).type
                    case 'graph2d.lineseries'
                        hkid(ii,jj,kk) = line(0,0);
                    case 'graph3d.lineseries'
                        hkid(ii,jj,kk) = line(0,0,0);
                    case 'specgraph.scattergroup'
                        % handle 3D and 2D differently, so if they happen
                        % to be mixed on the same plot they will still
                        % behave correctly. MarkerSize is reduced because scaling
                        % is different in Octave for Scatter plots. 
                        if ~isempty(figstruct(ii).children(jj).children(kk).properties.ZData)
                            hkid(ii,jj,kk) = scatter3(figstruct(ii).children(jj).children(kk).properties.XData,figstruct(ii).children(jj).children(kk).properties.YData,figstruct(ii).children(jj).children(kk).properties.ZData,figstruct(ii).children(jj).children(kk).properties.SizeData/5,figstruct(ii).children(jj).children(kk).properties.CData);
                        else
                            hkid(ii,jj,kk) = scatter3(figstruct(ii).children(jj).children(kk).properties.XData,figstruct(ii).children(jj).children(kk).properties.YData, 0*figstruct(ii).children(jj).children(kk).properties.YData, figstruct(ii).children(jj).children(kk).properties.SizeData/5,figstruct(ii).children(jj).children(kk).properties.CData);
                        end
                        continue
                    case 'specgraph.contourgroup'
                        if ~isempty(figstruct(ii).children(jj).children(kk).properties.ZData)
                            [_c, hkid(ii,jj,kk)] = contour(figstruct(ii).children(jj).children(kk).properties.XData, figstruct(ii).children(jj).children(kk).properties.YData, figstruct(ii).children(jj).children(kk).properties.ZData);
                        else
                            [_c, hkid(ii,jj,kk)] = contour(figstruct(ii).children(jj).children(kk).properties.XData,figstruct(ii).children(jj).children(kk).properties.YData, 0*figstruct(ii).children(jj).children(kk).properties.YData);
                        end
                        continue
                    case 'graph3d.surfaceplot'
                        hkid(ii,jj,kk) = surf(zeros(2,2),zeros(2,2),zeros(2,2),zeros(2,2));
                    case 'patch'
                        hkid(ii,jj,kk) = patch(zeros(3,1), zeros(3,1), zeros(3,1), zeros(3,1));
                    case 'text'
                        % if this index (kk) is listed in the Axes'
                        % 'special' list, then it is either Title, Xlabel, YLabel, or ZYLabel. 
                        kidind = find(figstruct(ii).children(jj).special == kk) ;
                        if isempty(kidind)
                            hkid(ii,jj,kk) = text(0, 0, 0, '');
                        else
                            switch kidind
                                case 1
                                    hkid(ii,jj,kk) = title(figstruct(ii).children(jj).children(kk).properties.String, 'interpreter', figstruct(ii).children(jj).children(kk).properties.Interpreter);
                                case 2
                                    hkid(ii,jj,kk) = xlabel(figstruct(ii).children(jj).children(kk).properties.String, 'interpreter', figstruct(ii).children(jj).children(kk).properties.Interpreter);
                                case 3
                                    hkid(ii,jj,kk) = ylabel(figstruct(ii).children(jj).children(kk).properties.String, 'interpreter', figstruct(ii).children(jj).children(kk).properties.Interpreter);
                                case 4
                                    hkid(ii,jj,kk) = zlabel(figstruct(ii).children(jj).children(kk).properties.String, 'interpreter', figstruct(ii).children(jj).children(kk).properties.Interpreter);
                            end
                        end

                        continue % Maybe don't set properties for the Xlabel, Ylabel, Zlabel, Title. They don't need it, and some of the properties mess things up. 
                end

                kidprops = fieldnames(figstruct(ii).children(jj).children(kk).properties);
                for ll = 1:length(kidprops)
                    try
                        if strcmp(kidprops{ll}, 'DeleteFcn') % DeleteFcn causes problems if there is a legend. Just skip it, Octave already knows what to do. This came up with Text properties, but these are skipped now anyway with the "continue" above in the "text" case. 
                            continue
                        else
                            set(hkid(ii,jj,kk), (kidprops{ll}), figstruct(ii).children(jj).children(kk).properties.(kidprops{ll}) );
                        end
                    catch
                    end
                end

            end % end loop over Axes children


        case 'scribe.legend'
            hlegoriginal = figstruct(ii).children(jj).properties.UserData.handles;
            for kk = 1:length(hlegoriginal)
                hleg(kk) = hkid(find(hkidoriginal(:)==hlegoriginal(kk), 1));
            end
            leg = figstruct(ii).children(jj).properties.UserData.lstrings;
            hlegend(ii,:) = legend(hleg, leg);

            otherwise % not Axes or Legend. 
            continue
        end


    end


end
