{Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.

b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
c. Listar el contenido del archivo maestro en un archivo de texto llamado
“reporteAlumnos.txt”.
d. Listar el contenido del archivo detalle en un archivo de texto llamado
“reporteDetalle.txt”.
e. Actualizar el archivo maestro de la siguiente manera:
i. Si aprobó el final se incrementa en uno la cantidad de materias con final
aprobado.
ii. Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas
sin final.
f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.}

program ej2;

type
    alumno = record
        cod,materiasAprobadasSinFinal,materiasAprobadasConFinal : integer;
        apellido, nombre : string[20]
    end;

    materia = record
        cod: integer;
        aprobadaConFinal:integer;
    end;
    archivo = file of alumno;
    archivoMaT = file of materia;

procedure leerDet(var a:archivoMaT; var m:materia);
begin
    if not(eof(a)) then
         read(a,m)
    else m.cod := -1;
end;

procedure leerMas(var a:archivo; var m:alumno);
begin
    if not(eof(a)) then
        read(a,m)
    else m.cod := -1;
end;

var 
    archivoMaestro : archivo;
    archivoDetalle : archivoMaT;
    nombreDetalle, nombreMaestro : string[20];
    alumnos,detalletext,arch4aprobados : Text;
    a:alumno;
    m:materia;
    apConFinal, apSinFinal : integer;

begin
    writeln('Como se llama el archivo maestro?');
    readln(nombreMaestro);
    Assign(archivoMaestro, nombreMaestro);
    writeln('Como se llama el archivo detalle?');
    readln(nombreDetalle);
    Assign(archivoDetalle, nombreDetalle);

    rewrite(archivoDetalle);
    rewrite(archivoMaestro);

    // Cargar archivo maestro
    Assign(alumnos,'alumnos.txt');
    reset(alumnos);
    while (not(eof(alumnos))) do 
    begin
        with a do
        begin
            read(alumnos, cod, materiasAprobadasConFinal, materiasAprobadasSinFinal);
            readln(alumnos,nombre);
            readln(alumnos, apellido);
            writeln(cod, materiasAprobadasConFinal, materiasAprobadasSinFinal, nombre, apellido);
        end;
        write(archivoMaestro, a);
    end;
    close(archivoMaestro);
    close(alumnos);
    

 // Cargar archivo detalle
    Assign(detalletext, 'detalle.txt');
    reset(detalletext);
    while (not(eof(detalletext))) do
    begin
        with m do 
        begin
            read(detalletext,cod, aprobadaConFinal);
            write(archivoDetalle,m);
            writeln('cod: ', cod,' A: ', aprobadaConFinal);
        end;
    end;
    close(archivoDetalle);
    close(detalletext);

    reset(archivoMaestro);
    reset(archivoDetalle);
    
    leerDet(archivoDetalle, m);
    read(archivoMaestro, a);
    
    while(m.cod <> -1) do 
    begin
        while(m.cod <> a.cod) do 
            read(archivoMaestro,a);
        
        while(m.cod = a.cod) do 
        begin
            if (m.aprobadaConFinal = 1) then
                a.materiasAprobadasConFinal :=  a.materiasAprobadasConFinal + 1
            else a.materiasAprobadasSinFinal := a.materiasAprobadasSinFinal + 1;
            leerDet(archivoDetalle, m);
        end;
        seek(archivoMaestro, filepos(archivoMaestro)-1);
        write(archivoMaestro, a);
        with a do  writeln(cod, materiasAprobadasConFinal, materiasAprobadasSinFinal, nombre, apellido);
        if not(eof(archivoMaestro)) then 
            read(archivoMaestro,a);
        if (eof(archivoDetalle)) then writeln(m.cod);
    end;

    close(archivoDetalle);
    close(archivoMaestro);

    reset(archivoMaestro);
    Assign(arch4aprobados, '4aprobados.txt');
    rewrite(arch4aprobados);
    while(not eof(archivoMaestro)) do
    begin
        read(archivoMaestro,a);
        if ((a.materiasAprobadasConFinal - a.materiasAprobadasSinFinal) >= 4) then
        begin
            with a do begin
                writeln(arch4aprobados, cod,' ', materiasAprobadasConFinal,' ', materiasAprobadasSinFinal,' ', nombre);
                writeln(arch4aprobados, apellido);
            end;
        end;
    end;
    close(arch4aprobados);
    close(archivoMaestro);
end.