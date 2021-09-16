function [filesCommon1, filesCommon2] = SystemTest_CreateCommonCode(branch)
if ~exist('branch','var')
    branch = 'development';
end
ws1 = 'c:\jdubb\workspaces\try\Homer3'; 
ws2 = 'c:\jdubb\workspaces\try\AtlasViewer'; 
url = 'https://github.com/jayd1860';

rootdirThisApp  = filesepStandard(fileparts(which('CreateCommonCode')));
rootdirCommCode = [rootdirThisApp, 'Shared/'];
if ispathvalid(rootdirCommCode)
    rmdir(rootdirCommCode, 's');
end

gitSetBranch(ws1, branch);
gitSetBranch(ws2, branch);

filesCommon1 = CreateCommonCode(ws1, ws2, 'Utils', url, 'reset:change');
filesCommon2 = CreateCommonCode(ws1, ws2, 'DataTree', url, 'change:nofilesearch');



