function filesCommonDifferent = SystemTest(options)
if ~exist('options','var')
    options = 'reset:change';
end
ws1 = 'f:/jdubb/workspaces/try/apptry1';
ws2 = 'f:/jdubb/workspaces/try/apptry2';
ns1 = 'apptry1';
ns2 = 'apptry2';

if optionExists('nochange',options)
    return
end

filesCommonDifferent = ResolveCommonFunctions(ws1, ws2, ns1, ns2, options);

