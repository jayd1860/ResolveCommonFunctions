function idxs = SearchStringInFile(funcname, filename)
idxs = [];

fid = fopen(filename);
if fid<0
    return
end
idxs = SearchFile(fid, funcname);
fclose(fid);



% -------------------------------------------------------
function idxs = SearchFile(fid, funcname)
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
    k = [];
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

