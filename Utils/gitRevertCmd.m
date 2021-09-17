function r = gitRevertCmd(ws)
if ~exist('ws','var')
    ws = filesepStandard(pwd);
end
cd(ws)

fprintf('Revert changes in %s\n', ws)

cmd = sprintf('git reset --hard');
[r1, msg] = system(cmd);
fprintf('%s', msg)


cmd = sprintf('git clean -fd');
[r2, msg] = system(cmd);
fprintf('%s', msg)

r = ~(r1==0 && r2==0);

fprintf('\n');

% git clean doesn't seem to work to remove ALL untracked files so we
% followup with our own cleanup 
cleanup(ws);

pause(1);




% ------------------------------------------------------
function cleanup(ws)
% This function is used to clean up when git cleanup DOES NOT WORK
% and untracked .git files are left over from previous modules
dirs = dir(ws);
for ii = 1:length(dirs)
    if strcmp(dirs(ii).name, '.')
        continue
    end
    if strcmp(dirs(ii).name, '.git')
        continue
    end
    if strcmp(dirs(ii).name, '..')
        continue
    end
    if ~dirs(ii).isdir
        continue
    end
    dirname = filesepStandard([ws, '/', dirs(ii).name, '/.git']);
    if ispathvalid(dirname)
        fprintf('Removing file %s\n', dirname);
        delete(dirname);
    else
        cleanup([ws, '/', dirs(ii).name])
    end
end
