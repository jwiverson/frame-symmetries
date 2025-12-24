function gapify(A)
    %Input:     A matrix A with integer or rational symbolic entries
    %Output:    This prints A in a format suitable for GAP input


    %open with a left bracket
    str=string('[');

    %find the size of A
    [m,n]=size(A);

    for j=1:m
        %start each row with a left bracket
        str=str+string('[');
       for k=1:n
           str=str+string(A(j,k));
           if k<n
               %include a comma if there is more to come
              str=str+string(','); 
           end
       end
       %close the row with a right bracket
       str=str+string(']');
       if j<m
           %add a comma if there are more rows coming
          str=str+string(',')+newline; 
       end
    end

    %close the whole thing with a right bracket
    str=str+string(']');

    %show the string
    disp(str)
end