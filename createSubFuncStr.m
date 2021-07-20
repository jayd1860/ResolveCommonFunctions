function s = createSubFuncStr(filePath, namespace, fidD)

s = '';
if nargin==0
    return;
end
if nargin==1
    namespace = 'nm1';
    fidD = -1;
end
if nargin==2
    fidD = -1;
end

[pname, fname, ext] = fileparts(filePath);
if isempty(ext)
    ext = '.m';
end
filePath = [filesepStandard(pname), fname, ext];
if ~ispathvalid(filePath)
    return;
end
fidS = fopen(filePath, 'rt');
if fidS<1
    return
end

% Look for all function definitions
fcalls = {};
kk = 1;
while 1
    ln = fgetl(fidS);
    if ln == -1
        break;
    end
    p = parseFuncHeader(ln);
    if ~isempty(p.funcName)
        fcalls{kk} = p.funcName; %#ok<AGROW>
        kk = kk+1;
    end
end

% Rewind to beginning of file for a second pass
fseek(fidS, 0, 'bof');

s = sprintf('\n\n%% ---------------------------------------------------------\n');
while 1
    ln = fgetl(fidS);
    if ln == -1
        break;
    end
    p = parseFuncHeader(ln);
    if ~isempty(p.funcName)
        if isempty(p.argOut)
            ln = sprintf('function %s_%s%s', p.funcName, namespace, genArgInStr(p.argIn));
        else
            ln = sprintf('function %s = %s_%s%s', genArgOutStr(p.argOut), p.funcName, namespace, genArgInStr(p.argIn));
        end
    else
        for ii = 1:length(fcalls)
            k = findstrFunctionName(ln, fcalls{ii});
            for jj = 1:length(k)
                ln = sprintf('%s%s_%s%s', ln(1:k-1), fcalls{ii}, namespace, ln(k+length(fcalls{ii}):end) );
            end
        end
    end
    if fidD>0
        fprintf(fid, '%s\n', ln);
        fprintf('%s\n', ln);
    else
        s = sprintf('%s%s\n', s, ln);
    end
end

fclose(fidS);


