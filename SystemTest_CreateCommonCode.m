function filesCommon = SystemTest_CreateCommonCode(options)
if ~exist('options','var')
    options = 'reset:change';
end
ws1 = 'c:\jdubb\workspaces\try\Homer3'; 
ws2 = 'c:\jdubb\workspaces\try\AtlasViewer'; 
url = 'https://github.com/jayd1860';

rootdirThisApp  = filesepStandard(fileparts(which('CreateCommonCode')));
rootdirCommCode = [rootdirThisApp, 'Shared/'];
if ispathvalid(rootdirCommCode)
    rmdir(rootdirCommCode, 's');
end


filesCommon = CreateCommonCode(ws1, ws2, 'Utils', url, options);
filesCommon = CreateCommonCode(ws1, ws2, 'DataTree', url, 'reset:change:nofilesearch');


