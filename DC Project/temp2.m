function b = temp2()
t = 0:pi/8:4*pi;
b = 2*t;
%p = plotting(t,b);
end

function pt=plotting(t,b)
pt=1;
subplot(2,1,1);
plot(t,b);
end

