function [fs,high]=tse_imhysthreshold(f,high,low)

if nargin<2, high=find_threshold(f); end
if nargin<3, low=0.4*high; end

fs=imreconstruct(f>high,f>low);
end

function t=find_threshold(f)
% The threshold is chosen according to the curve giving the number of
% selected points in function of the theshold value. It is two times the
% abscissa of the inflection point of this curve.
tmax=max(f(:));
dt=tmax/100;
t=dt;
n1=numel(f);
dn1=0;          
stop=false;
k=1;
while (~stop) && (t<tmax)
    fs=imreconstruct(f>t,f>0.4*t);
    n2=sum(fs(:));  % number of selected points
    dn2=n1-n2;      % derivative of the number of selected points
    if (k>2) && (dn2<dn1), stop=true; end
    n1=n2;
    dn1=dn2;
    t=t+dt;
    k=k+1;
end
t=2*t;
end