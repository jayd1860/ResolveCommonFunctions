function [r, cmd] = gitCmdRename(srcname, dstname)

% Change current folder to destination folder name. Looks like 
% 'git mv' command needs that to work correctly
currdir = pwd;
rootdir = fileparts(dstname);
cd(rootdir)
cmd = sprintf('git mv %s %s', srcname, dstname);
r = system(cmd);
cd (currdir)

