function b = isdir_private(dirname0)
%
% isdir_private() is a backward compatible version of matlab's isdir()
% function.
%
% isdir() is a new matlab function that is an improvment over exist() to
% tell if a pathname is a directory or not. But it didn't exist prior to R2017.
% Therefore we use try/catch to still be able to use isdir when it exists

if ~iscell(dirname0)
    dirname0 = {dirname0};
end
for ii = 1:length(dirname0)
    dirname = dirname0{ii};
    try
        b(1) = isfolder(dirname);
    catch
        try
            b(1) = isdir(dirname);
        catch
            b(1) = (exist(dirname,'dir') == 7);
        end
    end
end
