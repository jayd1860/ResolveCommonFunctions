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

if isfile_private([f, e])
    cmd = sprintf('git rm ./%s', [f, e]);
else
    cmd = sprintf('git rm -r ./%s', [f, e]);
end
[r, msg] = system(cmd); %#ok<ASGLU>
fprintf('  %s\n', cmd)
fprintf('  %s\n', msg)

cd(currdir)
pause(.1);
