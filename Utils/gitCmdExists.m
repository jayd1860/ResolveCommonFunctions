function [b, m] = gitCmdExists()
b = false;
[r, m] = system('git --version');
if r==0
    b = true;
end