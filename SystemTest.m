function filesCommonDifferent = SystemTest(options)
if ~exist('options','var')
    options = 'reset:change';
end
ws1 = 'f:\jdubb\workspaces\AtlasViewer.BUNPC_development';
ws2 = 'f:\jdubb\workspaces\try\Homer3.BUNPC_development';
ns1 = 'av';
ns2 = 'h3';
filesCommonDifferent = ResolveCommonFunctions(ws1, ws2, ns1, ns2, options);

