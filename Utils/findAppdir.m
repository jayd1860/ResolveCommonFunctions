function [pname, rootdir] = findAppdir(rootdir, appname)
    pname = '';

    % fprintf('Searching in  %s\n', rootdir);
    
    if ~ispathvalid(rootdir, 'dir')
        return;
    end
    
    rootdir = filesepStandard(rootdir);    
    if ispathvalid([rootdir, appname])
        pname = filesepStandard([rootdir, appname]);
        return
    end
    dirs = dir([rootdir, '*']);
    for ii = 1:length(dirs)
        if ~dirs(ii).isdir
            continue;
        end
        if strcmp(dirs(ii).name, '.')
            continue;
        end
        if strcmp(dirs(ii).name, '.git')
            continue;
        end
        if strcmp(dirs(ii).name, '..')
            continue;
        end
        pname = findAppdir([rootdir, dirs(ii).name], appname);
        if ~isempty(pname)
            rootdir = filesepStandard(fileparts(pname(1:end-1)));
            return
        end
    end
end


