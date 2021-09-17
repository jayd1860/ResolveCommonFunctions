function cd_safe(dirname)

if dirname(end) == ':'
    dirname(end+1) = '/';
end

if exist(dirname, 'dir') == 7
    try
        cd(dirname);
    catch
        ;
    end
end