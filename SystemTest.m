function filesCommonDifferent = SystemTest(options)
if ~exist('options','var')
    options = 'reset:change';
end
ws1 = 'c:/jdubb/workspaces/AtlasViewer';
ws2 = 'c:/jdubb/workspaces/Homer3';
ns1 = 'av';
ns2 = 'h3';
filesCommonDifferent = ResolveCommonFunctions(ws1, ws2, ns1, ns2, options);

