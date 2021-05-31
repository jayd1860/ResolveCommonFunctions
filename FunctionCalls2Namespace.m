function FunctionCalls2Namespace(funcname, ws, namespace)

% fclose all; FunctionCalls2Namespace('getAppDir_av', 'F:/jdubb/workspaces/try2/AtlasViewer.BUNPC_development', 'ns1')

% figure out if 2nd arg is a workspace or a list of files
if ~exist('namespace','var')
    namespace = '';
end
if isempty(ws)
    return;
end
if ~isdir_private(ws)
    if iscell(ws) && ~isfile_private(ws{1})
        return;
    elseif ischar(ws) && ~isfile_private(ws)
        return;
    elseif iscell(ws) && isfile_private(ws{1})
        filenames = ws;
    elseif ischar(ws) && isfile_private(ws)
        filenames = {ws};
    end
else
    filenames = findDotMFiles(ws, '.git');
end

% Now that we have out list of .m files to looks through, we start the work
% of looking for and changing the calls to funcname
N = length(filenames);
nfiles = 0;
noccurr = 0;
for ii = 1:N
    
    % Find occurrences of function call
    idxs = SearchStringInFile(funcname, filenames{ii});
    if isempty(idxs)
        continue;
    end
    
    % Occurrences of function call exist in filename{ii}
    nfiles = nfiles+1;
    noccurr = noccurr+length(idxs);

    % Change function call in file to references namespace
    FunctionCalls2NamespaceInFile(funcname, filenames{ii}, namespace);
end
fprintf('Found %d occurrences of %s in %d files of workspace %s\n', noccurr, funcname, nfiles, ws);




% ----------------------------------------------------------
function FunctionCalls2NamespaceInFile(funcname, filename, namespace)
DEBUG = 0;
if ~exist('namespace','var')
    namespace = '';
end

p = fileparts(filename);
if isempty(namespace)
    temp = fileparts(p);
    if isempty(temp)
        return;
    end
    if temp(1)~='+'
        return;
    end
end

filenameTemp  = [filesepStandard(p), 'temp.m'];
copyfile(filename, filenameTemp, 'f');
fid_src = fopen(filenameTemp);
if ~DEBUG
    fid_dst = fopen(filename, 'w');
else
    fid_dst = 0;
end
ilinestr = 0;
while ~feof(fid_src)
    linestr = fgetl(fid_src);
    ilinestr = ilinestr+1;
    
    k1 = findstrFunctionName(linestr, funcname);
    if ~isempty(k1)
        FunctionCalls2NamespaceInLine(fid_dst, funcname, linestr, k1, namespace);
    end
    
    k2 = findstrFileName(linestr, [funcname, '.m']);
    if ~isempty(k2)
        FileRef2NamespaceInLine(fid_dst, [funcname, '.m'], linestr, k2, namespace);
    end
    
    if isempty(k1) && isempty(k2)
        if fid_dst>0
            fprintf(fid_dst, '%s\n', linestr);
        end
    end
end
fclose(fid_src);
if fid_dst>0
    fclose(fid_dst);
end
try
    delete(filenameTemp);
catch
end




% ----------------------------------------------------------
function FunctionCalls2NamespaceInLine(fid, funcname, linestr, k, namespace)
if isempty(k)
    return;
end
linestrNew = '';
k = [1, k, length(linestr)];
for jj = 1:length(k)-1
    if jj==1
        linestrNew = sprintf('%s', linestr(k(jj) : k(jj+1)-1));
    elseif jj < length(k)-1
        linestrNew = sprintf('%s%s.%s%s', linestrNew, namespace, funcname, linestr(k(jj)+length(funcname) : k(jj+1)-1));
    else
        linestrNew = sprintf('%s%s.%s%s', linestrNew, namespace, funcname, linestr(k(jj)+length(funcname) : k(jj+1)));
    end
end
if fid>0
    fprintf(fid, '%s\n', linestrNew);
end



% ----------------------------------------------------------
function FileRef2NamespaceInLine(fid, filename, linestr, k, namespace)
if isempty(k)
    return;
end
linestrNew = '';
k = [1, k, length(linestr)];
for jj = 1:length(k)-1
    if jj==1
        linestrNew = sprintf('%s', linestr(k(jj) : k(jj+1)-1));
    elseif jj < length(k)-1
        linestrNew = sprintf('%s+%s/%s%s', linestrNew, namespace, filename, linestr(k(jj)+length(filename) : k(jj+1)-1));
    else
        linestrNew = sprintf('%s+%s/%s%s', linestrNew, namespace, filename, linestr(k(jj)+length(filename) : k(jj+1)));
    end
end
if fid>0
    fprintf(fid, '%s\n', linestrNew);
else
end

