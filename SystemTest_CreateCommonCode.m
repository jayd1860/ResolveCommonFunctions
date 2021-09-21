function [filesCommon1, filesCommon2] = SystemTest_CreateCommonCode(branch)
if ~exist('branch','var')
    branch = 'development';
end
ws1 = 'c:\jdubb\workspaces\try5\Homer3'; 
ws2 = 'c:\jdubb\workspaces\try5\AtlasViewer'; 
url = 'https://github.com/jayd1860';

rootdirThisApp  = filesepStandard(fileparts(which('CreateCommonCode')));
rootdirCommCode = [rootdirThisApp, 'Shared/'];
if ispathvalid(rootdirCommCode)
    rmdir(rootdirCommCode, 's');
end

if ~ispathvalid(ws1, 'dir')
    [~, reponame] = fileparts(ws1);
    cmd = sprintf('git clone %s/%s %s', url, reponame, ws1);
    system(cmd)
end
if ~ispathvalid(ws2, 'dir')
    [~, reponame] = fileparts(ws2);
    cmd = sprintf('git clone %s/%s %s', url, reponame, ws2);
    system(cmd)
end

gitSetBranch(ws1, branch);
gitSetBranch(ws2, branch);

filesCommon1 = CreateCommonCode(ws1, ws2, 'Utils', url, 'reset:change');
filesCommon2 = CreateCommonCode(ws1, ws2, 'DataTree', url, 'change:nofilesearch');
