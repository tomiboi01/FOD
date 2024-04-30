{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”}

program ejercicio8;
type 
    distribucion = record
        nombre: string;
        anioLanzamiento: integer;
        versionKernel: integer;
        cantidadDesarrolladores: integer;
        descripcion: string;
    end;

    archivo = file of distribucion;

procedure leerDistribucion(var d: distribucion);
begin
    writeln('Ingrese el nombre de la distribucion');
    readln(d.nombre);
    writeln('Ingrese el año de lanzamiento de la distribucion');
    readln(d.anioLanzamiento);
    writeln('Ingrese la version del kernel de la distribucion');
    readln(d.versionKernel);
    writeln('Ingrese la cantidad de desarrolladores de la distribucion');
    readln(d.cantidadDesarrolladores);
    writeln('Ingrese la descripcion de la distribucion');
    readln(d.descripcion);
end;

procedure escribirDistribucion(d: distribucion);
begin
    writeln('Nombre: ', d.nombre);
    writeln('Anio de lanzamiento: ', d.anioLanzamiento);
    writeln('Version del kernel: ', d.versionKernel);
    writeln('Cantidad de desarrolladores: ', d.cantidadDesarrolladores);
    writeln('Descripcion: ', d.descripcion);
end;
procedure leer(var a: archivo; var d: distribucion);
begin
    if(not eof(a)) then
        read(a, d)
    else
        d.nombre := 'zzz';
end;

function ExisteDistribucion(nombre: string; var a: archivo):boolean;
var d:distribucion; existe:boolean;
begin 
    reset(a);
    leer(a,d);
    existe := false;
    while(d.nombre <> 'zzz') and (d.nombre <> nombre) do
        leer(a,d);
    if (d.nombre = nombre) and (d.cantidadDesarrolladores > 0) then
        existe:= true;
    close(a);
    ExisteDistribucion:= existe;
end;

procedure AltaDistribucion(var a: archivo; d: distribucion);
var aux:distribucion; cabeza:distribucion;
begin
    if (ExisteDistribucion(d.nombre, a)) then
        writeln('Ya existe la distribucion')
    else
    begin
        reset(a);
        read(a,cabeza);
        if (cabeza.cantidadDesarrolladores < 0) then
        begin
            seek(a, cabeza.cantidadDesarrolladores*(-1));
            leer(a,cabeza);
            seek(a, filepos(a)-1);
            write(a,d);
            seek(a,0);
            write(a,cabeza);
        end
        else 
        begin
            seek(a, filesize(a));
            write(a,d);
            writeln('Se agrego la distribucion al final');
        end;
        close(a);
    end;
end;

procedure BajaDistribucion(var a: archivo; nombre: string);
var cabeza:distribucion; d:distribucion; pos:integer;
begin
    if (ExisteDistribucion(nombre, a)) then
    begin
        reset(a);
        read(a,cabeza);
        read(a,d);
        while(d.nombre <> nombre) do
            read(a,d);

        seek(a,filepos(a)-1);
        pos:= filepos(a)*(-1);
        write(a,cabeza);
        seek(a,0);
        d.cantidadDesarrolladores:= pos;
        write(a,d);
          
    end
    else
        writeln('Distribucion no existente');

end;

var a: archivo; d:distribucion; nombre: string;
begin
    assign(a, 'archivo');
    rewrite(a);
    d.cantidadDesarrolladores:= 0;
    d.nombre := ' ';
    d.anioLanzamiento:= 0;
    d.versionKernel:= 0;
    d.descripcion:= ' ';
    write(a,d);

    leerDistribucion(d);
    while (d.nombre <> 'zzz') do
    begin
        AltaDistribucion(a,d);
        escribirDistribucion(d);
        leerDistribucion(d);
    end;

    writeln('Ingrese el nombre de la distribucion a dar de baja');
    readln(nombre);
    BajaDistribucion(a,nombre);
    writeln('Ingrese el nombre de la distribucion a dar de baja');
    readln(nombre);
    BajaDistribucion(a,nombre);
    close(a);
    reset(a);
    while(not eof(a)) do
    begin
        read(a,d);
        escribirDistribucion(d);
    end;
    close(a);
    leerDistribucion(d);
    altaDistribucion(a,d);

end.