function [err, msg] = gitSubmoduleAdd(wspath, url, appname)
if nargin<2
    return;
end
if isempty(wspath) || isempty(url)
    return
end

currdir = pwd;
cd(wspath);

if ispathvalid([wspath, appname])
    cmd = sprintf('git submodule add %s/%s %s/Shared\n', url, appname, appname);
else
    cmd = sprintf('git submodule add %s/%s %s\n', url, appname, appname);
end
fprintf(cmd);
[err, msg] = system(cmd);

cd(currdir);
