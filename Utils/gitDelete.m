function r = gitDelete(fname)
r = -1;
if ~ispathvalid(fname)
    return
end

currdir = pwd;

[p,f,e] = fileparts(fname);
if isempty(p)
    return;
end
cd(p)

cmd = sprintf('git rm ./%s', [f, e]);
[r, msg] = system(cmd);
% fprintf('%s', msg)
fprintf('  git rm %s\n', fname)

cd(currdir)
pause(.1);
