function filesCommonDifferent = SystemTest(options)
if ~exist('options','var')
    options = 'reset:change';
end
ws1 = 'c:/jdubb/workspaces/apptry1';
ws2 = 'c:/jdubb/workspaces/apptry2';
ns1 = 'Apptry1GUI';
ns2 = 'Apptry2GUI';

if optionExists('nochange',options)
    return
end

filesCommonDifferent = ResolveCommonFunctions(ws1, ws2, ns1, ns2, options);
