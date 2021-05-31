function [filesCommonDifferent, filesCommonDifferentResolved] = findCommonFiles(ws1, ws2)
global exclList

filesCommonDifferent = {};
filesCommonDifferentResolved = {};

if nargin<2
    return
end

files1 = findDotMFiles(ws1, exclList);
files2 = findDotMFiles(ws2, exclList);

N = length(files1);

waitmsg = 'Searching for conflicting functions. Please wait...';
h = waitbar_improved(0, waitmsg);

hh = 1;
kk = 1;
for ii = 1:N
    [p1, f1, e1] = fileparts(files1{ii});
    for jj = 1:length(files2)
        [p2, f2, e2] = fileparts(files2{jj});
        
        % Check for functions with same names and both in namesspaces
        if compareFuncNames(p1, f1, e1, p2, f2, e2)
            
            % Check for unequal contents
            if ~filesEqual(files1{ii}, files2{jj})
                filesCommonDifferent{kk,1}  = [filesepStandard(p1), f1, e1]; %#ok<*AGROW>
                filesCommonDifferent{kk,2}  = [filesepStandard(p2), f2, e2];
                kk = kk+1;
            end
            
        % Check for functions with same names ONLY
        elseif strcmp([f1, e1], [f2, e2])

            % Check for unequal contents
            if ~filesEqual(files1{ii}, files2{jj})
                filesCommonDifferentResolved{hh,1}  = [filesepStandard(p1), f1, e1]; %#ok<*AGROW>
                filesCommonDifferentResolved{hh,2}  = [filesepStandard(p2), f2, e2];
                hh = hh+1;
            end
            
        end
    end
    waitbar_improved(ii/N, h, waitmsg);
end
close(h);



% ---------------------------------------------------------------------------
function b = compareFuncNames(p1, f1, e1, p2, f2, e2)
b = false;
[~, namespace1] = fileparts(p1);
[~, namespace2] = fileparts(p2);

% If file is in a package then 
if ~strcmp(namespace1, namespace2)
    if ~isempty(namespace1) && ~isempty(namespace2)
        if namespace1(1) == '+' && namespace2(1) == '+'
            return;
        end
    end
end
b = strcmp([f1, e1], [f2, e2]);

