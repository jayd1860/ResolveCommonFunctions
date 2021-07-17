function k = findstrFunctionName(s1, s2)
k = [];

if nargin<2
    return;
end

k = findstr(s1, s2); %#ok<*FSTR>
if isempty(k)
    return;
end
idxsExcl = [];
for jj = 1:length(k)
    kS = k(jj);
    kE = k(jj)+length(s1)-1;
    if kE > length(s2)
        break;
    end
    if (kE-kS) > length(s1)
        break;
    end
    
    % Check end of function name
    if ~isFuncNameStart(s2, kS)
        idxsExcl = [idxsExcl, jj];    
    elseif ~isFuncNameEnd(s2, kE)
        % Check end of function name
        idxsExcl = [idxsExcl, jj];
    end    
end
k(idxsExcl) = [];



% --------------------------------------------------------
function b = isFuncNameStart(s, j)
b = false;
j = j-1;
if j<1
    b = true;
    return
end
if j>length(s)
    return
end
b = ~isalnum(s(j));



% --------------------------------------------------------
function b = isFuncNameEnd(s, j)
b = false;
j = j+1;
if j>length(s)
    b = true;
    return
end
if j<1
    return
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

