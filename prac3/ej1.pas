program ej1;
type 
    persona = record
        dni : integer;
    end;
    
    archivo = file of persona;
    
procedure leer(var a:archivo; var p:persona);
begin
    if not eof(a) then 
        read (a,p)
    else p.dni := 9999;
end;

var
    P:persona;
    maestro,maestroNuevo:archivo;
    cargar:text;
    i,posBorrar,dni:integer;
    hola:string;
begin
    Assign(cargar,'maestro.txt');
    reset(cargar);
    Assign(maestro, 'maestro');
    rewrite(maestro);
    Assign(maestroNuevo, 'maestroNuevo');
    rewrite(maestroNuevo);
    while not eof(cargar) do 
    begin
        readln(cargar, p.dni);
        write(maestro,p)
    end;
    
    close (maestro);
    reset(maestro);
    
    readln(dni);
    leer(maestro,p);
    while (p.dni <> 9999) and (p.dni <> dni) do
        leer(maestro,p);
    
    if (p.dni = dni) then
    begin
        posBorrar := filepos(maestro) - 1;
        seek(maestro,filesize(maestro)-1);
        read(maestro,p);
        seek(maestro, posBorrar);
        write(maestro,p);
        seek(maestro, 0);
        for i:= 1 to filesize(maestro)-1 do 
        begin
            read(maestro, p);
            write(maestroNuevo, p);
            writeln(p.dni);
        end;
    end
    else
        writeln('No se encuentra esa persona');
    close(maestro);
    close(maestroNuevo);
    close(cargar);
end.