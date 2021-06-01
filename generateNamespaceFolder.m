function namespacefull = generateNamespaceFolder(namespace, pname, fname, ext)

[~,pname2] = fileparts(pname);
if strcmp(pname2, ['+',namespace])
    return
end

namespacefull = filesepStandard([filesepStandard(pname), '+', namespace], 'nameonly:dir');

% Find out if the file is a class file
fid = fopen([pname, '/', fname, ext], 'r');
if fid < 0
    return;
end
funcname = fname;
classfolder = '';
linenum = 1;
while ~feof(fid)
    l = fgetl(fid);
    if isempty(l)
        continue;
    end   
    k1 = findstr(l, 'classdef'); %#ok<*FSTR>
    k2 = findstr(l, funcname);
    
    if ~isempty(k1) && ~isempty(k2)
        classfolder = filesepStandard(['@', funcname], 'nameonly:dir');
        break;
    end
    
    % Limit how far down the file we look for classdef keyword - it is
    % supposed to be at the top of the file, if it is a class definition
    % file.
    linenum = linenum+1;
    if linenum>100
        break;
    end
end
fclose(fid);

namespacefull = [namespacefull, classfolder];
if ~ispathvalid(namespacefull)
    mkdir(namespacefull);
end


