function g=tse_imdetectmaxgrad(gh,gv)

module=sqrt(gh.*gh+gv.*gv);
[m,n]=size(gh);
g=zeros(m,n,'double');

for i=2:m-1
    for j=2:n-1
        drap=true;
        if gh(i,j)~=0, rap=-gv(i,j)/gh(i,j);
        elseif gv(i,j)~=0, rap=1.5;
        else drap=false;
        end
        if drap==true
            if rap>0
                if rap<1 %cas 1 et 5
                    temp_x=abs(gh(i,j)); temp_y=abs(gv(i,j));
                    Gr1=temp_y/temp_x*module(i-1,j+1)+(temp_x-temp_y)/temp_x*module(i,j+1);
                    Gr2=temp_y/temp_x*module(i+1,j-1)+(temp_x-temp_y)/temp_x*module(i,j-1);
                    if gh(i,j)<0, temp=Gr1; Gr1=Gr2; Gr2=temp;end

                else %cas 2 et 6
                    temp_x=abs(gh(i,j)); temp_y=abs(gv(i,j));
                    Gr1=temp_x/temp_y*module(i-1,j+1)+(temp_y-temp_x)/temp_y*module(i-1,j);
                    Gr2=temp_x/temp_y*module(i+1,j-1)+(temp_y-temp_x)/temp_y*module(i+1,j);
                    if gh(i,j)<0, temp=Gr1; Gr1=Gr2; Gr2=temp;end
                end
            else
                if -rap>1 % cas 3 et 7
                    temp_x=abs(gh(i,j)); temp_y=abs(gv(i,j));
                    Gr1=temp_x/temp_y*module(i-1,j-1)+(temp_y-temp_x)/temp_y*module(i-1,j);
                    Gr2=temp_x/temp_y*module(i+1,j+1)+(temp_y-temp_x)/temp_y*module(i+1,j);
                    if gh(i,j)>0, temp=Gr1; Gr1=Gr2; Gr2=temp;end

                else % cas 4 et 8
                    temp_x=abs(gh(i,j)); temp_y=abs(gv(i,j));
                    Gr1=temp_y/temp_x*module(i-1,j-1)+(temp_x-temp_y)/temp_x*module(i,j-1);
                    Gr2=temp_y/temp_x*module(i+1,j+1)+(temp_x-temp_y)/temp_x*module(i,j+1);
                    if gh(i,j)>0, temp=Gr1; Gr1=Gr2; Gr2=temp;end
                end
            end
        end
        if (drap==true) && (module(i,j)>Gr1) && (module(i,j)>=Gr2)
            g(i,j)=module(i,j);
        else
            g(i,j)=0;
        end

    end
end

end
