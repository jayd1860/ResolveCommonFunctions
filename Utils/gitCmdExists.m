function b = gitCmdExists()
b = false;
[r, ~] = system('git --version');
if r==0
    b = true;
end