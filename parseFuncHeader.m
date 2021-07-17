function p = parseFuncHeader(ln, funcName, p)
if nargin<2
    funcName = '';
    p = getFuncProperties();
end
if nargin<3
    p = getFuncProperties();
end

keys = {};
temp = str2cell(ln, {' ',',','[',']','(',')'});
kk = 1;
for jj = 1:length(temp)
    temp2 = str2cell(temp{jj},'=','keepdelimiters');
    for ii = 1:length(temp2)
        keys{kk} = temp2{ii}; %#ok<AGROW>
        kk = kk+1;
    end
end

kFunctionKeyword = searchKeyword(keys, 'function');
if kFunctionKeyword==0
    return
end
kEqualSign = searchKeyword(keys, '=', 'onechar');
if kEqualSign>0
    p.keysymbolEqualSign = true;
    if isempty(funcName)
        funcName = keys{kEqualSign+1};
    end
elseif isempty(funcName)
    funcName = keys{kFunctionKeyword+1};
end
kFuncName = searchKeyword(keys, funcName);
if kFuncName==0
    return;
end
p.funcName = funcName;

kComment = searchKeyword(keys, '%', 'onechar');
if kComment>0
    if kComment<kFunctionKeyword || kComment<kFuncName
        return;
    end
end
for ii = kFunctionKeyword+1:kEqualSign-1
    if ii<1
        break
    end
    p.argOut{ii-kFunctionKeyword} = keys{ii};
end
for ii = kFuncName+1:length(keys)
    if ii<1
        break
    end
    p.argIn{ii-kFuncName} = keys{ii};
end



% ------------------------------------------------------------------
function k = searchKeyword(keys, keyword, options)
if nargin<3
    options='string';
end
onechar = false;
if optionExists(options,'onechar')
    onechar = true;
end

k = 0;
for ii = 1:length(keys)
    if onechar
        k = find(keys{ii}==keyword);
    else
        k = strcmp(keys{ii}, keyword);
        if k==0
            k = [];
        end
    end
    if isempty(k)
        k = 0;
        continue;
    end
    k = ii;
    break;
end



% ------------------------------------------------------------------
function p = getFuncProperties()
p = struct(...
    'keywordFunc',false, ...
    'keysymbolOpenBracket',false, ...
    'argOut',{{}}, ...
    'keysymbolCloseBracket',false, ...
    'keysymbolEqualSign',false, ...
    'funcName','', ...
    'keysymbolOpenParen',false, ...
    'argIn',{{}}, ...
    'keysymbolCloseParen',false ...
);


