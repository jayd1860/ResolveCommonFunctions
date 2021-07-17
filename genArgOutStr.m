function argOutStr = genArgOutStr(nargout)
argOutStr = '';
if ~iscell(nargout)
    for ii = 1:nargout
        argNames{ii} = sprintf('out%d', ii); %#ok<AGROW>
    end
else
    argNames = nargout;
    nargout = length(argNames);
end
if nargout==0
    return;
end
argOutStr = '[';
for ii = 1:nargout
    argOutStr = sprintf('%s%s', argOutStr, argNames{ii});
    if ii<nargout
        argOutStr = [argOutStr, ', ']; %#ok<AGROW>
    end
end
argOutStr = [argOutStr, ']'];

