function k = findstrFunctionName(s1, s2)
k = [];

if nargin<2
    return;
end

i = findstr(s1, 'function '); %#ok<*FSTR>
j = findstr(s1, 'classdef '); %#ok<*FSTR>
k = findstr(s1, s2); %#ok<*FSTR>
if isempty(k)
    return;
end

% Compile list of indices to remove from k
idxs = [];
for ii = 1:length(k)
    kS = k(ii)-1;
    kE = k(ii)+length(s2);
    
    
    if kE > length(s1)
        break;
    end
    
    % If funcname surrounded by quotes then we found function reference
    if kS>0 && kE<length(s1)
        if s1(kS)==sprintf('''') && s1(kE)==sprintf('''')
            continue;
        end
    end
    
    % Check start of function name
    if 0<kS && kS<length(s1)  && ~isFuncNameStartDelimiter(s1, kS)
        idxs = [idxs, ii]; %#ok<*AGROW>
        continue;
    end
    
    % Check end of function name
    if 0<kE && kE<length(s1) && ~isFuncNameEndDelimiter(s1, kE)
        idxs = [idxs, ii]; %#ok<*AGROW>
        continue;
    end
    
    % Check for function declaration which does not qualify as a function
    % call or function reference, so add it to the remove list
    if isFuncNameDeclaration(s1, i, k(ii), s2)
        idxs = [idxs, ii]; %#ok<*AGROW>
        continue;
    end
    
    % Check for function declaration which does not qualify as a function
    % call or function reference, so add it to the remove list
    if isFuncNameClassdef(s1, j, k(ii))
        idxs = [idxs, ii]; %#ok<*AGROW>
        continue;
    end
    
end

k(idxs) = [];



% --------------------------------------------------------
function b = isFuncNameStartDelimiter(s, j)
b = (~isalnum(s(j))) || isspace(s(j));



% --------------------------------------------------------
function b = isFuncNameEndDelimiter(s, j)
b = false;
if (s(j) == '.') 
    if j+1 <= length(s)
        if strcmp(s(j:j+1), '.m')
            if j+2 >= length(s)
                return;                
            end
            if ~isalnum(s(j+2))
                return
            end
        end
    end
end
b = (s(j) == '(') || (s(j) == ';') || (s(j) == ',') || (s(j) == '.') || (s(j) < 33);



% --------------------------------------------------------
function b = isFuncNameDeclaration(s, j, k, funcname)
b = false;

% Find last occurence of 'function' keyword before occurrence of 
% function name (index by k)
jS = find(j<k-1);
if isempty(jS)
    return;
end

% Get portion of string s starting with keyword 'function' and ending with 
% start of function name
iS = j(jS(end));
iE = k-1;
if iS<1 || iS>length(s)
    return;
end
if iE<1 || iE>length(s)
    return;
end
s2 = s(iS:iE);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rules for eliminating possibility of this occurrence of function name (indexed by k)
% being a function declaration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If there is a newline separating keyword 'function' and the function name
% then this is not a function declaration involving that function name
m = find(s2==sprintf('\n')); %#ok<*EFIND>
if ~isempty(m)
    return;
end

% If there is NO newline then we check for existence of ONLY white spaces.
% If not ONLY whitespaces then we expect to see '=' sign for return value. 
% If no '=' sign then this is NOT a function declaration
if ~strcmp(strtrim(s2), 'function')
    m1 = find(s2 == '='); %#ok<*EFIND>
    if isempty(m1)
        return;
    end
    m2 = findstr(s2, funcname); %#ok<*EFIND>
    if ~isempty(m2)
        return;
    end
    
    if m1+2<=length(s2)
        if isalnum(strtrim(s2(m1+1:m1+2)))
            return
        end
    end
    
    
end

b = true;




% --------------------------------------------------------
function b = isFuncNameClassdef(s, j, k)
b = false;

% Find last occurence of 'classdef' keyword before occurrence of 
% function name (index by k)
jS = find(j<k-1);
if isempty(jS)
    return;
end

% Get portion of string s starting with keyword 'classdef' and ending with 
% start of function name
iS = j(jS(end));
iE = k-1;
if iS<1 || iS>length(s)
    return;
end
if iE<1 || iE>length(s)
    return;
end
s2 = s(iS:iE);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rules for eliminating possibility of this occurrence of function name (indexed by k)
% being a function classdef
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If there is a newline separating keyword 'function' and the function name
% then this is not a classdef involving that function name
m = find(s2==sprintf('\n')); %#ok<*EFIND>
if ~isempty(m)
    return;
end

% If there is NO newline then we check for existence of ONLY white spaces.
% If not ONLY whitespaces then this is not a classdef involving that 
% function name
if ~strcmp(strtrim(s2), 'classdef')
    return;
end

b = true;

