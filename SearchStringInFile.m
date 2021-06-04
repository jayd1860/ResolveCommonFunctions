function idxs = SearchStringInFile(funcname, filename)
idxs = cell(1,2);

fid = fopen(filename);
if fid<0
    return
end
idxs = SearchFile(fid, funcname);
fclose(fid);



% -------------------------------------------------------
function idxs = SearchFile(fid, funcname)
idxs = cell(1,2);
k = cell(3,2);

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

    k{1,1} = findstrFunctionName(char(chunkPrev(:)'), funcname);
    k{2,1} = findstrFunctionName(char(chunkCurr(:)'), funcname); 
    k{3,1} = findstrFunctionName(chunks, funcname); 

    k{1,2} = findstrFileName(char(chunkPrev(:)'), funcname);
    k{2,2} = findstrFileName(char(chunkCurr(:)'), funcname); 
    k{3,2} = findstrFileName(chunks, funcname); 

    chunkPrev = chunkCurr;

    % Cases:
    j = [];
    for ii = 1:2
        if ~isempty(k{1,ii}) && isempty(k{2,ii}) && ~isempty(k{3,ii})
            break;
        end
        if ~isempty(k{1,ii}) && ~isempty(k{2,ii}) && isempty(k{3,ii})
            break;
        end
        if ~isempty(k{2,ii}) && ~isempty(k{3,ii})
            j = ((ichunk-1)*chunksize) + k{2,ii};
        end
        if isempty(k{1,ii}) && isempty(k{2,ii}) && ~isempty(k{3,ii})
            j = ((ichunk-2)*chunksize) + k{3,ii};
        end
        if isempty(k{1,ii}) && ~isempty(k{2,ii}) && ~isempty(k{3,ii})
            j = ((ichunk-1)*chunksize) + k{2,ii};
        end
        idxs{ii} = [idxs{ii}, j]; %#ok<*AGROW>
    end
end

