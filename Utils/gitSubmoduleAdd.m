function [err, msg] = gitSubmoduleAdd(repo, url, appname, appdir)
if nargin<2
    return;
end
if isempty(repo) || isempty(url)
    return
end
if ~exist('appdir','var') || isempty(appdir)
    appdir = appname;
end

currdir = pwd;
cd(repo);

if ispathvalid([repo, '.git/modules/', appname])
    rmdir([repo, '.git/modules/', appname], 's');
end

cmd = sprintf('git submodule add -b development %s/%s %s\n', url, appname, appdir);
fprintf(cmd);
[err, msg] = system(cmd);


cd(currdir);
