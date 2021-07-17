function [funcHdrs, funcCalls] = CreateCommonFile(filename1, filename2, namespace1, namespace2)

%fid = fopen('./temp.m','wt');

[~, fname1] = fileparts(filename1);
fname = fname1;

[inp1, out1] = getArgNames(filename1);
[inp2, out2] = getArgNames(filename2);

nargin  = max([length(inp1), length(inp2)]);
nargout = max([length(out1), length(out2)]);

funcHdrs{1} = createFuncFormalHdr(fname, '', nargin, nargout);
funcHdrs{2} = createFuncFormalHdr(fname, namespace1, nargin, nargout);
funcHdrs{3} = createFuncFormalHdr(fname, namespace2, nargin, nargout);

funcCalls{1} = createFuncCalls(fname, namespace1, length(inp1), length(out1));
funcCalls{2} = createFuncCalls(fname, namespace2, length(inp2), length(out2));

body = createFuncBody(funcHdrs, funcCalls, namespace1, namespace2);
body = [body; createSubFuncStr(filename1, namespace1)];
body = [body; createSubFuncStr(filename2, namespace2)];

saveCommonFile(fname, body);
pause(.2);

% fid1 = fopen(filename1, 'rt');
% fclose(fid1);
% 
% fid2 = fopen(filename2, 'rt');
% fclose(fid1);


% ------------------------------------------------------------------------------
function funcHdr = createFuncFormalHdr(fname, namespace, nargin, nargout)

if ~isempty(namespace)
    namespace = ['_', namespace];
end

% Create arg in string
argInStr = genArgInStr(nargin);

% Create arg out string
argOutStr = genArgOutStr(nargout);

funcHdr = sprintf('function %s = %s%s%s', argOutStr, fname, namespace, argInStr);



% ------------------------------------------------------------------------------
function fcalls = createFuncCalls(fname, namespace, nargin, nargout)

if ~isempty(namespace)
    namespace = ['_', namespace];
end

% Create arg in string
kk = 1;
for ii = 1:nargin
    for jj = 1:nargout
        argInStr = genArgInStr(ii);
        
        % Create arg out string
        argOutStr = genArgOutStr(jj);
        
        fcalls{kk} = sprintf('%s = %s%s%s;', argOutStr, fname, namespace, argInStr);
        kk = kk+1;
    end
end



% -------------------------------------------------------------------------------
function body = createFuncBody(funcHdrs, funcCalls, namespace1, namespace2)
ii = 1;
body{ii,1} = funcHdrs{1}; ii = ii+1;
body{ii,1} = 'global namespace'; ii = ii+1;
body{ii,1} = sprintf('if strcmp(namespace, ''%s'')', namespace1);  ii = ii+1;
for kk = 1:length(funcCalls{1})
    body{ii,1} = sprintf('    %s', funcCalls{1});  ii = ii+1;
    if kk<length(funcCalls{1})
    end
end
body{ii,1} = sprintf('elseif strcmp(namespace, ''%s'')', namespace2);  ii = ii+1;
body{ii,1} = sprintf('    %s', funcCalls{2});  ii = ii+1;
body{ii,1} = sprintf('end');  ii = ii+1;



% -------------------------------------------------------------------------------
function saveCommonFile(fname, body)

filename = [filesepStandard(pwd), fname, '.m'];
fprintf('##################################\n')
fprintf('Saving file %s\n', filename);

fid = fopen(filename, 'wt');
for ii = 1:length(body)
    fprintf(fid, '%s\n', body{ii});
    fprintf('%s\n', body{ii});
end
fprintf('\n');
fclose(fid);


