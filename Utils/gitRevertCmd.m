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

pause(1);