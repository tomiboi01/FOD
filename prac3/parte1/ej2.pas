{
2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de empleados de una empresa aseguradora. Se deberá almacenar:
código de empleado, nombre y apellido, dirección, telefono, D.N.I y fecha
nacimiento. Implementar un algoritmo que, a partir del archivo de datos generado,
elimine de forma lógica todo los empleados con DNI inferior a 5.000.000.
Para ello se podrá utilizar algún carácter especial delante de algún campo String a su
elección. Ejemplo: ‘*Juan’.
}
program ej2;
type 
    persona = record
        dni : longInt;
        nombre, apellido, direccion, fechaNac:string[20];
        telefono,codEmp:integer;
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
        readln(cargar,p.nombre);
        write(maestro,p)
    end;
    
    close (maestro);
    reset(maestro);
    
    leer(maestro,p);
    while (p.dni <> 9999) do 
    begin
        if (p.dni > 50) then
        begin
            p.nombre := '*' + p.nombre;
            seek(maestro, filepos(maestro)-1);
            write(maestro,p);
        end;
        writeln(p.nombre);
        leer(maestro,p);
    end;
end.