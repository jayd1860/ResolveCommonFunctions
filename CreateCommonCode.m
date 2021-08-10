function filesCommon = CreateCommonCode(ws1, ws2, appname, options)
%
% Syntax:
%   filesCommon = CreateCommonCode(ws1, ws2, appname)
%
% Example 1:
%   cd <root folder>/ResolveCommonFunctions; setpaths
%   ws1 = 'f:\jdubb\workspaces\try2\AtlasViewer.BUNPC_development';
%   ws2 = 'f:\jdubb\workspaces\try2\Homer3.BUNPC_development';
%   filesCommon = CreateCommonCode(ws1, ws2, 'DataTree')
%
%
global resolve

resolve.exclList = {
    '.git';
    'setpaths.m';
    'UserFunctions';
    'Install';
    };

filesCommon = {};

% Parse args
if nargin < 2
    return;
end
if ~ispathvalid(ws1, 'dir')
    return;
else
    ws1 = filesepStandard(ws1);
end
if ~ispathvalid(ws2, 'dir')
    return;
else
    ws2 = filesepStandard(ws2);
end
if ~exist('options','var')
    options = 'reset';
end

% Reset workspaces
if optionExists(options,'reset')
    gitRevertCmd(ws1);    
    gitRevertCmd(ws2);
end

% Set root folder of common code
rootdirThisApp  = filesepStandard(fileparts(which('CreateCommonCode')));
rootdirCommCode = [rootdirThisApp, 'CommonCode/', appname];
if ispathvalid(rootdirCommCode)
    rmdir(rootdirCommCode, 's');
end

% Chec that the application is in both codes
[~, appDir1] = findAppdir(ws1, appname);
[~, appDir2] = findAppdir(ws2, appname);
if isempty(appDir1) || isempty(appDir2)
    return
end

% Find all common code files
[~, filesCommonSame] = findCommonFiles(ws1, ws2);
kk = 1;
for ii = 1:length(filesCommonSame)
    pname = getRelativePath(filesCommonSame{ii,1}, filesCommonSame{ii,2}, appname);
    if ~isempty(pname)
        filesCommon{kk,1} = pname;
        kk = kk+1;
    end    
end

% Create common code
for ii = 1:length(filesCommon)
    p = fileparts([rootdirThisApp, 'CommonCode/', filesCommon{ii}]);    
    if ~ispathvalid(p)
        mkdir(p)
    end
    fprintf('%d. Copying %s to %s\n', ii, [appDir1, filesCommon{ii}], p);
    copyfile([appDir1, filesCommon{ii}], p);

    gitDelete([appDir1, filesCommon{ii}]);
    gitDelete([appDir2, filesCommon{ii}]);

    fprintf('\n');
end

fprintf('Added %d files to common code project %s\n\n', ii, appname);





% ---------------------------------------------------------
function pnameCommon = getRelativePath(pname1, pname2, appname)
pnameCommon = '';
k1 = strfind(pname1, appname);
k2 = strfind(pname2, appname);
if isempty(k1) || isempty(k2)
    return
end
p1 = pname1(k1:end);
p2 = pname2(k2:end);
if pathscompare(p1, p2, 'nameonly')
    pnameCommon = p1;
end

