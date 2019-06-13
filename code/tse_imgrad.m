function [g,gh,gv]=tse_imgrad(f,method,sigma)

if nargin<2, method='sobel';end
if nargin<3, sigma=1;end

% Compute the gradient
if strcmp(method,'sobel')
    gh = imfilter(double(f),fspecial('sobel')' /8,'replicate');
    gv = imfilter(double(f),fspecial('sobel')/8,'replicate');

elseif strcmp(method,'gog')
    width=ceil(4*sigma);
    ssq=sigma^2;
    x=-width:width;
    gau = exp(-(x.*x)/(2*ssq))/(2*pi*ssq);     % the gaussian 1D filter
    dgau = -x.*exp(-(x.*x)/(2*ssq))/ssq;  % the 1D first derivative of gaussian filter
    gh=imfilter(double(f),gau','replicate');
    gh=imfilter(gh,dgau,'replicate');
    gv=imfilter(double(f),gau,'replicate');
    gv=imfilter(gv,dgau','replicate');

else error('incorrect method');
end

% Detect local maxima of the gradient in the direction of the gradient
% vector
g=tse_imdetectmaxgrad(gh,gv);

end