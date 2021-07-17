function [C,k] = str2cell(str, delimiters, options)

% Option tells weather to keep leading whitespaces. 
% (Trailing whitespaces are always removed)
if ~exist('options','var')
    options = '';
end

keepdelimiters = false;

if ~strcmp(options, 'keepblanks')
    str = strtrim(str);
end
if strcmp(options, 'keepdelimiters')
    keepdelimiters = true;
end
str = deblank(str);

if ~exist('delimiters','var') || isempty(delimiters)
    delimiters{1} = sprintf('\n');
elseif ~iscell(delimiters)
    foo{1} = delimiters;
    delimiters = foo;
end

% Get indices of all the delimiters
k=[];
for kk=1:length(delimiters)
    k = [k, find(str==delimiters{kk})];
end
j = find(~ismember(1:length(str),k));

% The following line seems to hurt performance a little bit. It was 
% meant to preallocate to speed things up but it does not seem to do that.
% C = repmat({blanks(max(diff([k,length(str)])))}, length(k)+1, 1);
C = {};
ii=1; kk=1; hh=1;
while ii<=length(j)
    if keepdelimiters
        [C, kk, hh] = keepdelimiter(str, C, kk, j, ii, k, hh);
    end
    C{kk} = str(j(ii));
    ii=ii+1;
    jj=2;
    while (ii<=length(j)) && ((j(ii)-j(ii-1))==1)
        C{kk}(jj) = str(j(ii));
        jj=jj+1;
        ii=ii+1;
    end
    C{kk}(jj:end)='';
    C{kk} = deblank(C{kk});
    kk=kk+1;
end
if keepdelimiters
    C = keepdelimiter(str, C, kk, j, ii, k, hh);
end



% --------------------------------------------------------
function [C, kk, hh] = keepdelimiter(str, C, kk, j, ii, k, hh)
if hh>length(k)
    return;
end
if ismember(k(hh), j)
    return;
end
if ii<=length(j) && k(hh)>j(ii)
    return;
end
ll=1;
while 1
    if hh>length(k)
        break;
    end
    if ismember(k(hh), j)
        break;
    end
    C{kk}(ll) = str(k(hh)); %#ok<*AGROW>
    hh=hh+1;
    ll=ll+1;
end
kk=kk+1;


