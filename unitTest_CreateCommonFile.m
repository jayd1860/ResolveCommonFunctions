function p = unitTest_CreateCommonFile()

fclose all;
f1 = 'c:/jdubb/workspaces/AtlasViewer/Utils/points_on_line.m';
f2 = 'c:/jdubb/workspaces/Homer3/Utils/points_on_line.m';
[funcHdrs, funcCalls] = CreateCommonFile(f1, f2, 'av', 'h3'); %#ok<*ASGLU>

global namespace
namespace = 'av';
p1 = [4,1,0];   
p2 = [6,0,0];

p = points_on_line(p1, p2, 1);

