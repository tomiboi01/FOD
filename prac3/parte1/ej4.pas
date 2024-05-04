{4. Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
end;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}


program sdf;
type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;

    tArchFlores = file of reg_flor;

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var cabecera,f:reg_flor; pos : integer;
begin
    reset(a);
    read(a,cabecera);
    if (cabecera.codigo <> 0) then
    begin
        seek(a,cabecera.codigo*(-1));
        read(a,cabecera);
        f.codigo := codigo;
        f.nombre := nombre;
        seek(a, filepos(a)-1);
        write(a,f);
        seek(a,0);
        write(a,cabecera);    
    end;
    close(a);

procedure leer(var a:tArchFlores; flor:reg_flor);
begin
    if not eof(a) then
        read(a,flor)
    else flor.codigo := 9999;
end;

procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var cabecera, aux :reg_flor; pos:integer;
begin
    reset(a);
    read(a, cabecera);
    leer(a,aux);
    while(aux.codigo <> 9999) and (aux.codigo <> flor.codigo) or (aux.nombre <> flor.nombre) do
        leer(a,aux);
    if (aux.codigo <> 9999) then
    begin
        seek(a,filepos(a)-1);
        pos := filepos(a) * (-1);
        write(a,cabecera);
        seek(a,0);
        cabecera.codigo := pos;
        write(a,cabecera);
    end
    else writeln('No existe esa flor')

end;



procedure listar (var a:tArchFlores);
var f:reg_flor;
begin
    while not eof(a) do 
    begin
        read(a,f);
        if (f.codigo > 0) then
        begin
            writeln('Nombre: ', f.nombre);
            writeln('Codigo: ', f.codigo);
        end;
    end;
end;