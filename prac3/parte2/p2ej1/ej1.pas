{1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:
a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:
i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.
b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?}

program ejercicio1;
type
    producto = record
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;

    regDetalle = record
        codigo: integer;
        cantidad: integer;
    end;

    lista = ^nodo;
    nodo = record
        dato: integer;
        sig: lista;
    end;

    maestro = file of producto;
    detalle = file of regDetalle;

procedure agregarAdelante(var l: lista; i:integer);
var
    aux: lista;
begin
    new(aux);
    aux^.dato := i;
    aux^.sig := l;
    l := aux;
end;


procedure leer(var archivo: detalle; var d: regDetalle);
begin
    if not eof(archivo) then
        read(archivo, d)
    else
        d.codigo := 9999;
end;

function EstaEnLista (l:lista; codigo:integer):boolean;
begin
    while (l <> nil) and (l^.dato <> codigo) do 
        l := l^.sig;
    EstaEnLista := l <> nil;
end;

procedure buscarMaestro(var m:maestro; codigo:integer; var regm:producto);
begin
    read(m,regm);
    while(regm.codigo <> codigo) do 
        read(m,regm);
end;

procedure actualizarMaestro(var m: maestro; var d: detalle);
var
    regm: producto;
    regd: regDetalle;
    pos:integer;
    l:lista;
begin
    l:=nil;
    reset(m);
    reset(d);
    pos := 0;
    leer(d,regd);
    while (regd.codigo <> 9999) do
    begin
        agregarAdelante(l,regd.codigo);
        buscarMaestro(m,regd.codigo, regm);
        writeln('asdf');
       
        repeat
            if (regd.codigo = regm.codigo) then
                regm.stockActual := regm.stockActual - regd.cantidad;
            leer(d,regd);
        until( (regd.codigo = 9999));

        seek(m, filepos(m)-1);
        write(m,regm);
        writeln(regm.codigo,' ',regm.stockActual);

        pos := pos + 1;
        seek(d,pos);

        read(d, regd);
        while (regd.codigo <> 9999) and (EstaEnLista(l,regd.codigo)) do 
            leer(d,regd);
        writeln('codigo regd ',regd.codigo);
    end;
    close(m);
    close(d);
end;

var 
    m:maestro;
    d:detalle;
    reg:producto;
    regD : regDetalle;
    i:integer;
begin
    Assign(m,'productosMaestro');
    Assign(d,'productosDetalle');
    rewrite(m);

    for i:=1 to 10 do
    begin
        reg.codigo := i;
        reg.nombre := 'nombre';
        reg.precio := 10;
        reg.stockActual := 100;
        reg.stockMinimo := 10;
        write(m,reg);
    end;
    close(m);
    rewrite(d);
    for i:=1 to 10 do
    begin
        regD.codigo := i;
        regD.cantidad := 10;
        write(d,regd);
        regD.codigo := i;
        regD.cantidad := 10;
        write(d,regd);
    end;
    for i:=1 to 10 do
    begin
        regD.codigo := i;
        regD.cantidad := 10;
        write(d,regd);
    end;
    close(d);
    
    actualizarMaestro(m,d);
    
    reset(m);
    while not eof(m) do
    begin
        read(m,reg);
        writeln('Codigo: ',reg.codigo);
        writeln('Nombre: ',reg.nombre);
        writeln('Precio: ',reg.precio:2:2);
        writeln('Stock Actual: ',reg.stockActual);
        writeln('Stock Minimo: ',reg.stockMinimo);
        writeln('---------------------------------');
    end;
    close(m);

end.