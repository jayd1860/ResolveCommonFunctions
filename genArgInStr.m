function argInStr = genArgInStr(nargin)
if ~iscell(nargin)
    for ii = 1:nargin
        argNames{ii} = sprintf('inp%d', ii);
    end
else
    argNames = nargin;
    nargin = length(argNames);
end
argInStr = '(';
for ii = 1:nargin
    argInStr = sprintf('%s%s', argInStr, argNames{ii});
    if ii<nargin
        argInStr = [argInStr, ', ']; %#ok<*AGROW>
    end
end
argInStr = [argInStr, ')'];

