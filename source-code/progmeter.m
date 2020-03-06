function progmeter(i,n,w)

%  disp(' ');
if nargin<3,
    w = 1;
end
%if i==1
if(nargin == 1)
  disp(' ');
    fwrite(1,sprintf('process in progress :  \n'));
    return;
elseif ischar(i)
  disp(' ');
    fwrite(1,sprintf('%s\n',i));
    fwrite(1,sprintf('00%%'));
    return;
end

if mod(i,w*n/100) <= mod(i-1,w*n/100),
%  disp(' ');
    fwrite(1,sprintf('\b\b\b'));
    fwrite(1,sprintf('%2d%%', round(100*i/n)));
end

if i==n,
  disp(' ');
  fprintf(1,'\n');
end
