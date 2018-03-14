function ax = showCameraForWebots(cameraParams, camera_list, varargin)

[offset, wpConvexHull, ~, highlightIndex, numBoards, hAxes] = parseInputs(cameraParams, varargin{:});

% colormap for board highlighting
boardColorLookup = im2double(label2rgb(1:numBoards, 'lines','c','shuffle'));
patternCentric;
setAxesProperties();

if nargout == 1
    ax = hAxes;
end

%--------------------------------------------------------------------------
    function setAxesProperties
        rotate3d(hAxes,'on');
        grid(hAxes, 'on');
        axis(hAxes, 'equal');        
    end

%--------------------------------------------------------------------------
    function [offset, wpConvHull, extView, highlightIndex, numBoards, hAxes] = parseInputs(camParams, varargin)

        validateattributes(camParams, {'cameraParameters', 'stereoParameters'}, {}, mfilename, 'cameraParams');        
        
        numBoards = camParams.NumPatterns;
        
        % Parse the P-V pairs
        parser = inputParser;
        
        parser.addOptional('View', 'CameraCentric', @checkView);
        parser.addParameter('HighlightIndex', [], @checkIndex);
        parser.addParameter('Parent', [], @vision.internal.inputValidation.validateAxesHandle);
        
        parser.parse(varargin{:});
        
        % re-parse one more time to expand partial strings
        extView = validatestring(parser.Results.View, {'PatternCentric','CameraCentric'}, mfilename, 'View');
        
        if any(parser.Results.HighlightIndex > numBoards)
            error(message('vision:calibrate:invalidHighlightIndex'));
        end

        % turn the highlight index into a logical vector
        highlightIndex = false(1,numBoards);
        highlightIndex(unique(parser.Results.HighlightIndex)) = true;        
        hAxes = newplot(parser.Results.Parent);        
        [wpConvHull, offset] = computeConvexHull(camParams);
    end

%--------------------------------------------------------------------------
    function r = checkView(in)
        validatestring(in, {'PatternCentric','CameraCentric'}, mfilename, 'View');
        r = true;
    end
%--------------------------------------------------------------------------
    function r = checkIndex(in)
        if ~isempty(in) % permit any kind of empty including []
            validateattributes(in, {'numeric'},{'integer','vector'});
        end
        r = true;
    end

%--------------------------------------------------------------------------
    function ret = addUnits(in)
        units = cameraParams.WorldUnits;
        ret = [in, ' (', units, ')'];
    end

%--------------------------------------------------------------------------
    function [wpConvHull, offset] = computeConvexHull(camParams)
        x = camParams.WorldPoints(:,1);
        y = camParams.WorldPoints(:,2);
        
        k = convhull(x, y, 'simplify',true);
                
        % pad with zeros so that Z = 0;
        wpConvHull = [x(k), y(k), zeros(length(k),1)]';        

        % compute the longest side of a convex hull enclosing points
        % collected from the calibration pattern
        maxDist = 0;
        for i = 1:length(k)-1
            % compute distances between all vertices of the convex hull
            d = norm(wpConvHull(1:2,i) - wpConvHull(1:2,i+1));
            if d > maxDist
                maxDist = d;
            end
        end
        offset = maxDist/6;
    end

%--------------------------------------------------------------------------
    function patternCentric
        
        plotPatternCentricBoard(hAxes, wpConvexHull, offset);

        % Record the current 'hold' state so that we can restore it later
        holdState = get(hAxes,'NextPlot');
        
        set(hAxes, 'NextPlot', 'add'); % hold on
        
        [rotationMatrices, translationVectors] = getRotationAndTranslation(cameraParams);

        % Draw the camera
        for cam_num = 1 : 2
            rotation = rotationMatrices(:, :, camera_list(cam_num))';
            translation = translationVectors(camera_list(cam_num), :)';
            [camColor, alpha] = getColor(camera_list(cam_num), boardColorLookup, highlightIndex);

            % plot the camera
            label = num2str(cam_num);
            plotMovingCam(rotation, translation, camColor, alpha, camera_list(cam_num), highlightIndex, label);
            hold on
        end
        set(hAxes, 'NextPlot', holdState); % restore the hold state       
        labelPlotAxesPatternCentric(hAxes);    
        
        % draw ground plane
        hold on
        x_min = -1000;
        y_min = -500;
        x_max = 1500;
        y_max = 1000;
        z = 200;
        S.Vertices = [x_min,y_min,z; x_min,y_max, z; x_max,y_max, z; x_max,y_min, z];
        S.Faces = [1,2,3,4];
        S.FaceColor = [0 206 209]/255;
        S.EdgeColor = [0 206 209]/255;
        h_plane = patch(S);
        %axis([x_min,x_max,y_min,y_max,-1000,200]);
        plot3(0,0,-1000, 'w.');
        set(h_plane,'FaceAlpha', 0.3,'HitTest', 'off');
        
    end

%--------------------------------------------------------------------------
    function plotPatternCentricBoard(hAxes, wpConvexHull, offset)
        wX = wpConvexHull(1,:);
        wY = wpConvexHull(2,:);
        wZ = wpConvexHull(3,:);
        
        % Draw a small axis in the corner of the board. BTW. Invoking plot3
        % first, sets up good default for azimuth and elevation.
        %plot3(hAxes, 3*offset*[1 0 0 0 0],3*offset*[0 0 1 0 0], 3*offset*[0 0 0 0 1],'r-','linewidth',2);

        set(hAxes,'XAxisLocation','top','YAxisLocation', 'left','YDir','reverse');
        
        % Draw the board
%         h = patch(wX,wY,wZ, 'Parent', hAxes);
%         set(h,'FaceColor', [0.4 0.4 0.4]);
%         set(h,'EdgeColor', 'black','linewidth',1);
    end        

%--------------------------------------------------------------------------
    function labelPlotAxesPatternCentric(hAxes)
        xlabel(hAxes, addUnits('X'));
        ylabel(hAxes, addUnits('Y'));
        zlabel(hAxes, addUnits('Z'));
        
        % Z goes into the board. Reversing Z direction to display the
        % cameras above the board.
        set(hAxes, 'ZDir', 'reverse');
    end

%--------------------------------------------------------------------------
    function [camColor, alpha] = getColor(idx, colorLookup, highlightIndex)
        camColor = squeeze(colorLookup(1, idx, :))';
        
        % transparency values for board highlighting
        normalAlpha = 0.2;
        highlightAlpha = 0.8;
        
        if highlightIndex(idx)
            alpha = highlightAlpha;
        else
            alpha = normalAlpha;
        end
    end

%--------------------------------------------------------------------------
    function [rotationMatrices, translationVectors] =  getRotationAndTranslation(cameraParams)
        rotationMatrices = cameraParams.RotationMatrices;
        translationVectors = cameraParams.TranslationVectors;
    end

%--------------------------------------------------------------------------
    function [camPts, camAxis] = rotateAndShiftCam(camPts, camAxis, rot, tran)        
        rot = rot';  
        camAxis = rot*bsxfun(@minus, camAxis, tran);
        camPts  = rot*bsxfun(@minus, camPts, tran);    
        
        angle = deg2rad(90);
        rotation_X = [1,0,0;0,cos(angle),sin(angle);0,-sin(angle),cos(angle)];
    
        camAxis = (camAxis'*rotation_X)';
        camPts = (camPts'*rotation_X)';
    end

%--------------------------------------------------------------------------
    function [camPts, camAxis] = getCamPts(factor)
        
        cu = offset*factor;
        ln = cu+cu;  % cam length        
        % back
        camPts = [0  0   cu  cu 0;...
                  0  cu  cu  0  0;...
                  0  0   0   0  0];
        % sides
        camPts = [camPts, ... 
                    [0   0  0  0  cu cu cu cu cu cu 0; ...
                     0   cu cu cu cu cu cu 0  0  0  0; ...
                     ln  ln 0  ln ln 0  ln ln 0  ln ln]]; 
              
        ro = cu/2;    % rim offset
        rm = ln+2*ro; % rim z offset (extent)        
        % lens
        camPts = [camPts, ...
                   [ -ro  -ro     cu+ro   cu+ro  -ro; ...
                     -ro   cu+ro  cu+ro  -ro     -ro; ...
                      rm   rm     rm      rm      rm] ];              
        % rim around the lens
        camPts = [camPts, ...
                   [0   0  -ro    0  cu  cu+ro cu cu  cu+ro cu  0 ;...
                    0   cu  cu+ro cu cu  cu+ro cu 0  -ro    0   0 ;...
                    ln  ln  rm    ln ln  rm    ln ln  rm    ln  ln] ];        
        camPts = bsxfun(@minus, camPts, [cu/2; cu/2; cu]);        
        % cam axis
        camAxis = 2*factor*offset*([0 1 0 0 0 0;
                                    0 0 0 1 0 0;
                                    0 0 0 0 0 1]);  
    end

%--------------------------------------------------------------------------
    function [center, hHggroup] = plotMovingCam(rotationMat, translation, camColor, alpha, idx, highlightIndex, label)
        
        [camPts, camAxis] = getCamPts(1.3);
        [camPts, camAxis] = rotateAndShiftCam(camPts, camAxis, rotationMat, translation);
        
        % Create a hggroup for each camera
        if highlightIndex(idx)
            hHggroup = hggroup('Parent',hAxes,'Tag',['HighlightedExtrinsicsObj' num2str(idx)]);
        else 
            hHggroup = hggroup('Parent',hAxes,'Tag',['ExtrinsicsObj' num2str(idx)]);
        end
        
        % draw camera wire frame        
        if alpha == 0
            plot3(hHggroup, camPts(1,:),camPts(2,:),camPts(3,:),'w-','linewidth',1, 'HitTest', 'off');
        end
                        
        % cam 'lens'
        lensPatch = struct('vertices', camPts', 'faces', 17:21);
        h = patch(lensPatch, 'Parent', hHggroup);
        set(h,'FaceColor', [0 0.8 1], 'FaceAlpha', alpha, 'EdgeColor', camColor, 'HitTest', 'off');        
        % cam back
        rimPatch = struct('vertices', camPts', 'faces', 1:5);
        h = patch(rimPatch, 'Parent', hHggroup);
        set(h,'FaceColor', camColor, 'FaceAlpha', alpha, 'EdgeColor', camColor, 'HitTest', 'off');
        % cam sides
        sidePatch = struct('vertices', camPts', 'faces', [5 6 7 8 5; 8 9 10 11 8; 11 12 13 14 11; 14 5 6 13 14]);
        h = patch(sidePatch, 'Parent', hHggroup);
        set(h,'FaceColor', camColor, 'FaceAlpha', alpha, 'EdgeColor', camColor, 'HitTest', 'off');        
        % cam rim
        rimPatch = struct('vertices', camPts', 'faces', [21 22 23 24  21; 24 25 26  27 24; 27 28 29 30 27; 30 31 32 21 30]);        
        h = patch(rimPatch, 'Parent', hHggroup);
        set(h,'FaceColor', camColor, 'FaceAlpha', alpha, 'EdgeColor', camColor, 'HitTest', 'off');
        
        if nargin > 6
            % positions of camera labels (offset from the camera axis)
            camLabelLoc = [camAxis(1,2), camAxis(2,4), 2*camAxis(3,1)-camAxis(3,6) + offset/5];                       
            % label each camera with a number
            text(camLabelLoc(1),camLabelLoc(2),camLabelLoc(3),label,...
                'FontSize',11,'Color',camColor,'FontWeight','bold', ...
                'Parent', hHggroup, 'HitTest', 'off');
        end
        center = camAxis(:, 1);
        
    end
end


