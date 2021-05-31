function k = findstrFileName(s1, s2)
k = [];

if nargin<2
    return;
end

k = findstr(s1, s2); %#ok<*FSTR>
if isempty(k)
    return;
end

idxs = [];
for ii = 1:length(k)
    % Check start of function name
    if k(ii)-1 > 0 
        if ~isFileNameStartDelimiter(s1(k(ii)-1))
            idxs = [idxs, ii]; %#ok<*AGROW>
            continue;
        end
    end
    
    % Check end of function name
    j = k(ii)+length(s2);
    if j > length(s1)
        return;
    end    
    if ~isFileNameEndDelimiter(s1(j))
        idxs = [idxs, ii]; %#ok<*AGROW>        
    end    
end
k(idxs) = [];



% --------------------------------------------------------
function b = isFileNameStartDelimiter(s)
b = (s=='''') || (s=='/') || (s=='\');



% --------------------------------------------------------
function b = isFileNameEndDelimiter(s)
b = (s == sprintf(''''));

