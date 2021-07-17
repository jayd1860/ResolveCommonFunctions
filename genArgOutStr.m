function argOutStr = genArgOutStr(nargout)
if ~iscell(nargout)
    for ii = 1:nargout
        argNames{ii} = sprintf('out%d', ii); %#ok<AGROW>
    end
else
    argNames = nargout;
    nargout = length(argNames);
end
argOutStr = '[';
for ii = 1:nargout
    argOutStr = sprintf('%s%s', argOutStr, argNames{ii});
    if ii<nargout
        argOutStr = [argOutStr, ', ']; %#ok<AGROW>
    end
end
argOutStr = [argOutStr, ']'];

