function r = movefile_local(src, dst)

if gitCmdExists()
    [r, cmd] = gitCmdRename(src, dst);
    if r==0
        fprintf('%s\n', cmd);
    end
else
    try 
        r = ~movefile(src, dst);
        fprintf('movefile(%s, %s)\n', src, dst);
    catch
        fprintf('ERROR: could not move %s to %s\n', src, dst);
    end
end

