function filesCommonDifferent = SystemTest(options)
if ~exist('options','var')
    options = 'reset:change';
end
ws1 = 'F:\jdubb\workspaces\try\AtlasViewer.BUNPC_development';
ws2 = 'F:\jdubb\workspaces\try\Homer3.BUNPC_development';
ns1 = 'AtlasViewerGUI';
ns2 = 'Homer3';

if optionExists('nochange',options)
    return
end

filesCommonDifferent = ResolveCommonFunctions(ws1, ws2, ns1, ns2, options);

