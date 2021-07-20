function [filesCommonDifferent, filesCommonSame] = ResolveCommonFunctions(ws1, ws2, ns1, ns2, options)
%
% Syntax:
%   [filesCommonDifferent, filesCommonSame] = ResolveCommonFunctions(ws1, ws2, ns1, ns2)
%   [filesCommonDifferent] = ResolveCommonFunctions(ws1, ws2, ns1, ns2)
%   filesCommonDifferent = ResolveCommonFunctions(ws1, ws2, ns1, ns2)
%   [filesCommonDifferent, filesCommonSame] = ResolveCommonFunctions(ws1, ws2)
%   [filesCommonDifferent] = ResolveCommonFunctions(ws1, ws2)
%   filesCommonDifferent = ResolveCommonFunctions(ws1, ws2)
%
% Example 1:
%   cd <root folder>/ResolveCommonFunctions; setpaths
%   ws1 = 'f:\jdubb\workspaces\try\AtlasViewer.BUNPC_development';
%   ws2 = 'f:\jdubb\workspaces\try\Homer3.BUNPC_development';
%   ns1 = 'av';
%   ns2 = 'h3';
%   [filesCommonDifferent] = ResolveCommonFunctions(ws1, ws2, ns1, ns2)
%
% Example 2:
%   % Git reset workspaces
%   ws1 = 'f:\jdubb\workspaces\try\AtlasViewer.BUNPC_development';
%   ws2 = 'f:\jdubb\workspaces\try\Homer3.BUNPC_development';
%   ns1 = 'av';
%   ns2 = 'h3';
%   [filesCommonDifferent] = ResolveCommonFunctions(ws1, ws2, ns1, ns2, 'nochange')
%
%
% Example 3:
%   % Git reset workspaces
%   ws1 = 'f:\jdubb\workspaces\try\AtlasViewer.BUNPC_development';
%   ws2 = 'f:\jdubb\workspaces\try\Homer3.BUNPC_development';
%   ns1 = 'av';
%   ns2 = 'h3';
%   [filesCommonDifferent] = ResolveCommonFunctions(ws1, ws2, ns1, ns2, 'reset')
%
%
%
global resolve

resolve.exclList = {
    '.git';
    'setpaths.m';
    'UserFunctions';
    };
pname = which('ResolveCommonFunctions');
resolve.outputDir = [filesepStandard(fileparts(pname)), 'output/'];
fclose all;
delete([resolve.outputDir, '*']);

filesCommonDifferent = {};
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
[filesCommonDifferent, filesCommonSame] = findCommonFiles(ws1, ws2);
if isempty(filesCommonDifferent)
    fprintf('There are no potential function conflicts between these 2 workspaces\n')
    return;
end

if ~optionExists(options,'change')
    return;
end
if isempty(filesCommonDifferent)
    return;
end

% Rosolve all functions calls to namespace functions
N = size(filesCommonDifferent,1);
waitmsg = 'Resolving conflicting function. Please wait ...';
h = waitbar_improved(0, waitmsg);
for ii = 1:N
    % Create new common file out of the 2 files with common name but
    % different contents
    waitbar_improved(ii/(2*N), h, waitmsg);
    CreateCommonFile(filesCommonDifferent{ii,1}, filesCommonDifferent{ii,2}, ns1, ns2); 
end
fprintf('\n');
close(h);


fprintf('Copying resolved files to the 2 projects\n');
for ii = 1:N
    [~, f, e] = fileparts(filesCommonDifferent{ii,1});
    
    fprintf('Copying %s to %s\n', [resolve.outputDir, f, e], filesCommonDifferent{ii,1});
    copyfile([resolve.outputDir, f, e], filesCommonDifferent{ii,1});

    fprintf('Copying %s to %s\n', [resolve.outputDir, f, e], filesCommonDifferent{ii,2});
    copyfile([resolve.outputDir, f, e], filesCommonDifferent{ii,2});
    
    fprintf('\n');    
end


