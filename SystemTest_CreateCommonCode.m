function filesCommon = SystemTest_CreateCommonCode(options)
if ~exist('options','var')
    options = 'reset:change';
end
ws1 = 'c:\jdubb\workspaces\try2\AtlasViewer'; 
ws2 = 'c:\jdubb\workspaces\try2\Homer3'; 
url = 'https://github.com/jayd1860';

filesCommon = CreateCommonCode(ws1, ws2, 'Utils', url, options);
filesCommon = CreateCommonCode(ws1, ws2, 'DataTree', url, 'reset:change:nofilesearch');


