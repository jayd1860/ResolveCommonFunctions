function p = unitTest_CreateCommonFile()

fclose all;
f1 = 'F:/jdubb/workspaces/AtlasViewer.BUNPC_development/Utils/points_on_line.m';
f2 = 'F:/jdubb/workspaces/try/Homer3.BUNPC_development/Utils/points_on_line.m';
[funcHdrs, funcCalls] = CreateCommonFile(f1, f2, 'av', 'h3'); %#ok<*ASGLU>

global namespace
namespace = 'h3';
p1 = [4,1,0];   
p2 = [6,0,0];

p = points_on_line(p1, p2, 1);

