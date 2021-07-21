function [funcHdr, funcCalls] = CreateCommonFile(filename1, filename2, namespace1, namespace2)

%fid = fopen('./temp.m','wt');

[~, fname1] = fileparts(filename1);
fname = fname1;

[inp1, out1] = getArgNames(filename1);
[inp2, out2] = getArgNames(filename2);

nargin  = max([length(inp1), length(inp2)]);
nargout = max([length(out1), length(out2)]);

funcHdr = createFuncFormalHdr(fname, '', nargin, nargout);

funcCalls{1} = createFuncCalls(fname, namespace1, length(inp1), length(out1));
funcCalls{2} = createFuncCalls(fname, namespace2, length(inp2), length(out2));

body = createFuncBody(funcHdr, funcCalls, namespace1, namespace2);
body = [body; createSubFuncStr(filename1, namespace1)];
body = [body; createSubFuncStr(filename2, namespace2)];

saveCommonFile(fname, body);
pause(.2);



% ------------------------------------------------------------------------------
function funcHdr = createFuncFormalHdr(fname, namespace, nargin, nargout)
if ~isempty(namespace)
    namespace = ['_', namespace];
end

% Create arg in string
argInStr = genArgInStr(nargin);

% Create arg out string
argOutStr = genArgOutStr(nargout);

if isempty(argOutStr)
    funcHdr = sprintf('function %s%s%s', fname, namespace, argInStr);
else
    funcHdr = sprintf('function %s = %s%s%s', argOutStr, fname, namespace, argInStr);
end



% ------------------------------------------------------------------------------
function fcalls = createFuncCalls(fname, namespace, nargin, nargout)
if ~isempty(namespace)
    namespace = ['_', namespace];
end

% Create arg out string
argOutStr = genArgOutStr(nargout);

% Create arg in string
for ii = 0:nargin
    if isempty(argOutStr)
        prefix = '';
    else
        prefix = sprintf('%s = ', argOutStr);
    end
    fcalls{ii+1} = sprintf('%s%s%s%s;', prefix, fname, namespace, genArgInStr(ii)); %#ok<AGROW>
end



% ------------------------------------------------------------------------------
function s = genFcallIfElse(funcCall)
s = sprintf('    if nargin == 0\n');
for kk = 1:length(funcCall)
    s = sprintf('%s        %s\n', s, funcCall{kk});
    if kk<length(funcCall)
        s = sprintf('%s    elseif nargin == %d\n', s, kk);
    end
end
s = sprintf('%s    end', s);




% -------------------------------------------------------------------------------
function body = createFuncBody(funcHdr, funcCalls, namespace1, namespace2)
p = parseFuncHeader(funcHdr);
ii = 1;
body{ii,1} = funcHdr; ii = ii+1;
for jj = 1:length(p.argOut)
    body{ii,1} = sprintf('out%d = [];', jj); ii = ii+1;
end
body{ii,1} = 'ns = getNamespace();'; ii = ii+1;
body{ii,1} = 'if isempty(ns)'; ii = ii+1;
body{ii,1} = '    return;'; ii = ii+1;
body{ii,1} = 'end'; ii = ii+1;
body{ii,1} = sprintf('if strcmp(ns, ''%s'')', namespace1);  ii = ii+1;
body{ii,1} = genFcallIfElse(funcCalls{1});  ii = ii+1;
body{ii,1} = sprintf('elseif strcmp(ns, ''%s'')', namespace2);  ii = ii+1;
body{ii,1} = genFcallIfElse(funcCalls{2});  ii = ii+1;
body{ii,1} = sprintf('end');



% -------------------------------------------------------------------------------
function saveCommonFile(fname, body)
global resolve
if ~ispathvalid(resolve.outputDir)
    mkdir(resolve.outputDir);
end
filename = [filesepStandard(resolve.outputDir), fname, '.m'];
fprintf('##################################\n')
fprintf('Saving file %s\n', filename);

fid = fopen(filename, 'wt');
for ii = 1:length(body)
    fprintf(fid, '%s\n', body{ii});
    fprintf('%s\n', body{ii});
end
fprintf('\n');
fclose(fid);


