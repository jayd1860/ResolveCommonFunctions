function [filesCommonDifferent, filesCommonSame] = findCommonFiles(ws1, ws2)
global resolve

filesCommonDifferent = {};
filesCommonSame = {};

if nargin<2
    return
end

files1 = findDotMFiles(ws1, resolve.exclList);
files2 = findDotMFiles(ws2, resolve.exclList);

N = length(files1);

waitmsg = 'Searching for conflicting functions. Please wait...';
h = waitbar_improved(0, waitmsg);

kk = 1;
ll = 1;
for ii = 1:N
    [p1, f1, e1] = fileparts(files1{ii});
    for jj = 1:length(files2)
        [p2, f2, e2] = fileparts(files2{jj});
        
        % Check for functions with same names and both in namesspaces
        if strcmp([f1, e1], [f2, e2])           
            % Check for unequal contents
            if ~filesEqual(files1{ii}, files2{jj})
                filesCommonDifferent{kk,1}  = [filesepStandard(p1), f1, e1]; %#ok<*AGROW>
                filesCommonDifferent{kk,2}  = [filesepStandard(p2), f2, e2];
                kk = kk+1;
            else
                filesCommonSame{ll,1}  = [filesepStandard(p1), f1, e1]; %#ok<*AGROW>
                filesCommonSame{ll,2}  = [filesepStandard(p2), f2, e2];
                ll = ll+1;
            end            
        end
    end
    waitbar_improved(ii/N, h, waitmsg);
end
close(h);

