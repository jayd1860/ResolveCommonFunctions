function [name, cmds, errs, msgs] = gitGetBranch(repo, quiet)
name = '';
cmds = {};

if ~exist('repo','var') || isempty(repo)
    repo = [pwd, '/'];
end
if ~exist('quiet','var') || isempty(quiet)
    quiet = 1;
end

currdir = pwd;

repoFull = filesepStandard(repo,'full');

ii = 1;
kk = 1;
cmds{ii,1} = sprintf('cd %s', repoFull); ii = ii+1;
cmds{ii,1} = sprintf('git branch');
kk = ii;

[errs, msgs] = exeShellCmds(cmds, false, quiet);

if all(errs==0)
    branches = str2cell(msgs{kk});
    for jj = 1:length(branches)
        if branches{jj}(1)=='*'
            break;
        end
    end
    name = strtrim(deblank(branches{jj}(2:end)));
end

cd(currdir);

