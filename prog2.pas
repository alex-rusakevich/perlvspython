program perevertysh;

var s1,s2:string;
    i:integer;

begin
    readln(s1); s2:='';
    for i:=length(s1) downto 1 do begin
       s2:=s2+s1[i];
    end;
    if s1=s2 then writeln(s1, ' - перевертыш')
        else  writeln(s1, ' - не перевертыш');
end.