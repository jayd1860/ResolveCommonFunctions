function [err, msg] = gitSubmoduleAdd(wspath, url, appname, appdir)
if nargin<2
    return;
end
if isempty(wspath) || isempty(url)
    return
end
if ~exist('appdir','var') || isempty(appdir)
    appdir = appname;
end

currdir = pwd;
cd(wspath);

cmd = sprintf('git submodule add %s/%s %s\n', url, appname, appname);
fprintf(cmd);
[err, msg] = system(cmd);

cd(currdir);
