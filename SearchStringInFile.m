function idxs = SearchStringInFile(funcname, filename)
idxs = [];

[~, filenamePartial] = fileparts(filename);

if strcmp(funcname, filenamePartial)
    return;
end

fid = fopen(filename);
if fid<0
    return
end
idxs = SearchFile2(fid, funcname);
fclose(fid);




% -------------------------------------------------------
function idxs = SearchFile1(fid, funcname)
idxs = [];
nbytesread = 0;
l = [];
while ~feof(fid)
    l = fgetl(fid);
    if isempty(l)
        nbytesread = nbytesread+length(l);
        continue;
    end
    
    k1 = findstrFunctionName(l, funcname);
    k2 = findstrFileName(l, [funcname, '.m']);
    k = [k1,k2];
    if isempty(k)
        nbytesread = nbytesread+length(l);
        continue;
    end
    
    idxs = [idxs, nbytesread+k]; %#ok<*AGROW>
    nbytesread = nbytesread+length(l);
end



% -------------------------------------------------------
function idxs = SearchFile2(fid, funcname)
idxs = [];
chunksize = 512;
chunkPrev = '';
ichunk = 0;
while ~feof(fid)
    ichunk = ichunk+1;

    chunkCurr = fread(fid, chunksize, 'uint8');
    if isempty(chunkCurr)
        continue;
    end
    
    % We do this, that is, concatenate previous chunck with current
    % one read in order to not miss an occurrence of the search string
    % s when a chunk falls in the middle of our search string
    chunks = [char(chunkPrev(:)'), char(chunkCurr(:)')];

    k11 = findstrFunctionName(char(chunkPrev(:)'), funcname);
    k12 = findstrFunctionName(char(chunkCurr(:)'), funcname); 
    k13 = findstrFunctionName(chunks, funcname); 

    k21 = findstrFileName(char(chunkPrev(:)'), funcname);
    k22 = findstrFileName(char(chunkCurr(:)'), funcname); 
    k23 = findstrFileName(chunks, funcname); 

    k1 = [k11, k21];
    k2 = [k12, k22];
    k3 = [k13, k23];

    chunkPrev = chunkCurr;

    % Cases:
    if isempty([k1, k2, k3])
        continue;
    end
    if ~isempty(k1) && isempty(k2) && ~isempty(k3)
        continue;
    end
    if ~isempty(k1) && ~isempty(k2) && isempty(k3)
        continue;
    end
    if ~isempty(k2) && ~isempty(k3)
        k = ((ichunk-1)*chunksize) + k2;
    end
    if isempty(k1) && isempty(k2) && ~isempty(k3)
        k = ((ichunk-2)*chunksize) + k3;
    end
    if isempty(k1) && ~isempty(k2) && ~isempty(k3)
        k = ((ichunk-1)*chunksize) + k2;
    end
    
    if isempty(k)
        continue;
    end
    
    idxs = [idxs, k]; %#ok<*AGROW>
    
end
