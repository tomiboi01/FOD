{

  5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2
}


program ej6;
type 
    celular = record 
        cod, stockMin, stock : integer;
        marca, desc, nombre : string[20];
        precio : real;
    end;
    
procedure informarCelu(c:celular);
begin
    with c do begin
        writeln('codigo: ', cod );
        writeln('stock mínimo: ', stockMin);
        writeln('stock: ', stock);
        writeln('marca: ', marca);
        writeln('nombre: ', nombre);
        writeln('precio: ', precio);
        writeln('desc: ', desc);
    end;
end;

var
    archivo_celulares : file of celular;
    texto, celulares : text;
    respuesta : integer;
    nombreFisicoCelulares : string[20];
    nombreFisicoTexto : string[20];
    c:celular;
    desc:string[20];
begin
    writeln('Escriba el nombre del archivo de celulares');
    readln(nombreFisicoCelulares);
    Assign(archivo_celulares, nombreFisicoCelulares);
    writeln('Quiere crear un archivo de celulares (1), listar los celulares con stock menor al stock mínimo (2),');
    writeln('Listar en pantalla los celulares del archivo de una descipción(3) o exportar (4)?');
    readln (respuesta);
    case respuesta of
        1:
        begin
            rewrite(archivo_celulares);
            writeln('Escriba el mombre del texto');
            readln(nombreFisicoTexto);
            Assign(texto, nombreFisicoTexto);
            reset(texto);
            while(not eof(texto)) do
            begin
                with c do
                begin
                    readln(texto, cod, stockMin, stock, precio, nombre);
                    readln(texto, desc);
                    readln(texto, marca);
                end;
                write(archivo_celulares, c);
                informarCelu(c);
            end;
            close (archivo_celulares);
            close(texto);
        end;
        2:
        begin
            reset(archivo_celulares);
            while(not eof(archivo_celulares)) do 
            begin
                read(archivo_celulares, c);
                if (c.stock < c.stockMin) then 
                begin    
                    writeln('El celular con codigo ', c.cod, 'tiene stock menor a su mínimo');
                    informarCelu(c);
                end;    
            end;
            close (archivo_celulares);
        end;
        3:
        begin
            reset(archivo_celulares);
            writeln('Ingrese la descripción del celular a buscar');
            readln(desc);
            while(not eof(archivo_celulares)) do 
            begin
                read(archivo_celulares, c);
                if (c.desc = desc) then 
                begin    
                    writeln('El celular con codigo ', c.cod, ' tiene la desc ingresada');
                    informarCelu(c);
                end;    
            end;
            close (archivo_celulares);
        end;
        4:
        begin
            writeln('sdf');
            reset(archivo_celulares);
            Assign(celulares, 'celulares.txt');
            rewrite(celulares);
            while (not eof(archivo_celulares)) do 
            begin
                read(archivo_celulares, c);
                with c do 
                begin
                    writeln(celulares,cod,' ',stockMin,' ',stock,' ',precio,' ',nombre);
                    writeln(celulares,desc);
                    writeln(celulares,marca);
                end;
                informarCelu(c);
            end;
            close(celulares);
            close(archivo_celulares);
        end;
    end;
end.


