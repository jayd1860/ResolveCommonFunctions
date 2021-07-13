function [filesCommonDifferentUnresolved, filesCommonDifferentResolved, filesCommonSame] = ResolveCommonFunctions(ws1, ws2, ns1, ns2, options)
%
% Syntax:
%   [filesCommonDifferentUnresolved, filesCommonDifferentResolved, filesCommonSame] = ResolveCommonFunctions(ws1, ws2, ns1, ns2)
%   [filesCommonDifferentUnresolved, filesCommonDifferentResolved] = ResolveCommonFunctions(ws1, ws2, ns1, ns2)
%   filesCommonDifferentUnresolved = ResolveCommonFunctions(ws1, ws2, ns1, ns2)
%   [filesCommonDifferentUnresolved, filesCommonDifferentResolved, filesCommonSame] = ResolveCommonFunctions(ws1, ws2)
%   [filesCommonDifferentUnresolved, filesCommonDifferentResolved] = ResolveCommonFunctions(ws1, ws2)
%   filesCommonDifferentUnresolved = ResolveCommonFunctions(ws1, ws2)
%
% Example 1:
%   cd <root folder>/ResolveCommonFunctions; setpaths
%   ws1 = 'f:\jdubb\workspaces\try\AtlasViewer.BUNPC_development';
%   ws2 = 'f:\jdubb\workspaces\try\Homer3.BUNPC_development';
%   ns1 = 'av';
%   ns2 = 'h3';
%   [filesCommonDifferentUnresolved, filesCommonDifferentResolved] = ResolveCommonFunctions(ws1, ws2, ns1, ns2)
%
% Example 2:
%   % Git reset workspaces
%   ws1 = 'f:\jdubb\workspaces\try\AtlasViewer.BUNPC_development';
%   ws2 = 'f:\jdubb\workspaces\try\Homer3.BUNPC_development';
%   ns1 = 'av';
%   ns2 = 'h3';
%   [filesCommonDifferentUnresolved, filesCommonDifferentResolved] = ResolveCommonFunctions(ws1, ws2, ns1, ns2, 'nochange')
%
%
% Example 3:
%   % Git reset workspaces
%   ws1 = 'f:\jdubb\workspaces\try\AtlasViewer.BUNPC_development';
%   ws2 = 'f:\jdubb\workspaces\try\Homer3.BUNPC_development';
%   ns1 = 'av';
%   ns2 = 'h3';
%   [filesCommonDifferentUnresolved, filesCommonDifferentResolved] = ResolveCommonFunctions(ws1, ws2, ns1, ns2, 'reset')
%
%
%
global exclList

exclList = {
    '.git';
    'setpaths.m';
    'UserFunctions';
    };

filesCommonDifferentUnresolved = {};
filesCommonDifferentResolved = {};
filesCommonSame = {};

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
if ~exist('ns1','var')
    [~, ns1] = fileparts(filesepStandard(ws1, 'file:nameonly'));
end
if ~exist('ns2','var')
    [~, ns2] = fileparts(filesepStandard(ws2, 'file:nameonly'));
end
if ~exist('options','var')
    options = 'reset:change';
end

% Reset workspaces
if optionExists(options,'reset')
    gitRevertCmd(ws1);
    gitRevertCmd(ws2);
end


% Find all function in conflict; that is all functions with same name but
% different definitions
[filesCommonDifferentUnresolved, filesCommonDifferentResolved, filesCommonSame] = findCommonFiles(ws1, ws2);
filesCommonDifferent = [filesCommonDifferentUnresolved; filesCommonDifferentResolved];
if isempty(filesCommonDifferent)
    fprintf('There are no potential function conflicts between these 2 workspaces\n')
    return;
end

if ~optionExists(options,'change')
    return;
end
if isempty(filesCommonDifferentUnresolved)
    return;
end

% Create namesspace folders for all conflicting functions
if ~isempty(filesCommonDifferentUnresolved)
    filesCommonDifferentResolved1 = CreateNamespace(filesCommonDifferentUnresolved(:,1), ns1);
    fprintf('\n');
    
    filesCommonDifferentResolved2 = CreateNamespace(filesCommonDifferentUnresolved(:,2), ns2);
    fprintf('\n');
    
    if isempty(filesCommonDifferentResolved1)
        fprintf('All conflicting files in namespace %s for workspace %s\n', ns1, fileparts(ws1));
    else
        fprintf('%d conflicting files in workspace %s moved to namespace %s\n', size(filesCommonDifferentResolved1,1), fileparts(ws1), ns1);
    end
    if isempty(filesCommonDifferentResolved2)
        fprintf('All conflicting files in namespace %s for workspace %s\n', ns2, fileparts(ws2));
    else
        fprintf('%d conflicting files in workspace %s moved to namespace %s\n', size(filesCommonDifferentResolved2,1), fileparts(ws2), ns2);
    end
end
fprintf('\n\n');

% Rosolve all functions calls to namespace functions
N = size(filesCommonDifferent,1);
waitmsg = 'Searching for namespace function calls. Please wait ...';

h = waitbar_improved(0, waitmsg);

for ii = 1:N
    waitbar_improved(ii/(2*N), h, waitmsg);
    [~, funcname] = fileparts(filesCommonDifferent{ii,1});
    FunctionCalls2Namespace(funcname, ws1, ns1)
end
fprintf('\n');

for jj = 1:N
    waitbar_improved((jj+ii)/(2*N), h, waitmsg);
    [~, funcname] = fileparts(filesCommonDifferent{jj,2});
    FunctionCalls2Namespace(funcname, ws2, ns2)
end
fprintf('\n');

close(h);



% --------------------------------------------------------
function namespacePaths = CreateNamespace(files, namespace)
namespacePaths = {};
kk = 1;
for ii = 1:length(files)
    [pname, fname, ext] = fileparts(files{ii});
    namespacefull = generateNamespaceFolder(namespace, pname, fname, ext);
    filenameNew = [namespacefull, fname, ext];
    if ~ispathvalid(filenameNew)
        r = movefile_local(files{ii}, filenameNew);
        if r==0
            namespacePaths{kk,1} = filenameNew; %#ok<AGROW>
            kk = kk+1;
        end
    else
        fprintf('%s already exists.\n', filenameNew)
    end
    
end
fprintf('\n');



