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

program ej13;
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
        min := c1;
        leer(d1,c1);
    end
    else 
    begin
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
begin
    l:= nil;
    Assign(vuelos, 'maestro');
    reset(vuelos);
    Assign(d1, 'd1');
    Assign(d2, 'd2');
    reset(d1);
    reset(d2);
    leer(d1,c1);
    leer(d2,c2);
    minimo(c1,c2,d1,d2,min);
    if (min.destino <> 'zzzzz') then 
    begin
        read(vuelos, v);
        while(v.destino <> min.destino) and (v.fecha <> min.fecha) and (v.hora <> min.hora) do 
            read(vuelos, v);
    end;

    while(min.destino <> 'zzzzz') do
    begin
        while(min.destino=v.destino) do 
        begin
            while (min.destino=v.destino) and (min.fecha=v.fecha) do 
            begin
                while (min.destino=v.destino) and (min.fecha=v.fecha) and (min.hora=v.hora) do 
                begin 
                    v.asientosDisp := v.asientosDisp - min.asientosComprados;
                    minimo(c1,c2,d1,d2,min);
                end;
                seek(vuelos, filepos(vuelos)-1);
                writeln(v.destino, ' ', v.fecha, ' ', v.hora,' ', v.asientosDisp);
                write(vuelos, v);
                if (v.asientosDisp < 10) then 
                    agregaradelante(l, v);
                    
                if (min.destino <> 'zzzzz') then 
                begin
                    read (vuelos,v);
                    while(v.destino <> min.destino) and (v.fecha <> min.fecha) and (v.hora <> min.hora) do 
                        read(vuelos, v);
                end;
            end;
        end;
    end;
end.
