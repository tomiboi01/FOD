{13. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

program ImAlwaysByYourSide;
type 
    vuelo = record
        destino,fecha, hora:string[20];
        asientosDisp:integer;
    end;
    compra = record
        destino,fecha,hora:string[20];
        asientosComprados:integer;
    end;
    maestro = file of vuelo;
    detalle = file of compra;
    lista = ^nodo;
    nodo = record
        sig : lista;
        dato : vuelo;
    end;

procedure leer(var d:detalle; var c:compra);
begin
    if (not eof(d)) then 
        read(d,c)
    else 
        c.destino := 'zzzzz';
end;

procedure minimo(var c1, c2:compra; var d1,d2: detalle; var min:compra);
begin
    if (c1.destino <= c2.destino) and (c1.fecha <= c2.fecha) and (c1.hora <= c2.hora) then 
    begin
        writeln('d1', c1.destino,' ', c1.fecha,' ', c1.hora);
        min := c1;
        leer(d1,c1);
    end
    else 
    begin
        writeln('d2', c2.destino,' ', c2.fecha,' ', c2.hora);
        min := c2;
        leer(d2,c2);
    end;
end;
    
procedure agregaradelante(var l:lista; v:vuelo);
var n: lista;
begin
    new(n);
    n^.dato := v;
    n^.sig := l;
    l := n;
end;
    
var v:vuelo;
    vuelos:maestro;
    d1,d2 : detalle;
    c1,c2,min : compra;
    a,destinoActual, fechaActual, horaActual : string[20];
    l : lista;
    carga,texto:text;
begin
    Assign(vuelos, 'maestro');
    rewrite(vuelos);
    Assign(texto, 'texto.txt');
    reset(texto);
    while not eof(texto) do 
    begin
        with v do 
        begin
            readln(texto,destino);
            readln(texto, fecha);
            readln(texto,hora);
            asientosDisp := 20;
            writeln(destino, ' ', fecha, ' ', hora, ' ', asientosDisp);
            write(vuelos, v);
        end; 
    end;
    close(vuelos);
    Assign(carga, 'carga.txt');
    reset(carga);
    Assign(d1, 'd1');
    rewrite(d1);
    Assign(d2, 'd2');
    rewrite(d2);
    while not eof(carga) do 
    begin
        with c1 do 
        begin
            readln(carga,destino);
            readln(carga, fecha);
            readln(carga,hora);
            readln(carga, asientosComprados);
            writeln(destino, ' ', fecha, ' ', hora, ' ', asientosComprados);
            write(d1, c1);
            write(d2,c1);
        end;
    end;
    close(d1); close(d2);
    close(texto); close(carga);
end.
