{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo}

program HopeYoureNotDissapointed;
const df = 30;
var i:integer;
type
    Alimento = record
        nombre, descripcion:string[20];
        cod, stockMin, stock : integer;
        precio: real;
    end;

    archivoAlimentos = file of alimento;

    Info = record 
        cod, cantVendida:integer;
    end;

    archivoDetalle = file of Info;
    vectorDetalles = array[1..df] of archivoDetalle;
    vectorRegActuales = array[1..df] of info;
    vectorNombres = array[1..df] of string[20];

procedure leerDet(var a:archivoDetalle; var inf:info);
begin
    if (not eof(a)) then
        read(a,inf)
    else inf.cod := 9999;
end;

procedure abrirArchivos(var v:vectorDetalles);
begin
    for i:= 1 to df do
    begin
        reset(v[i]);
    end;
end;

procedure cerrarArchivos(var v:vectorDetalles);
begin
    for i:= 1 to df do
    begin
        close(v[i]);
    end;
end;

procedure minimoVector(var v:vectorDetalles; var infoMin :info; var vecAc : vectorRegActuales);
var  indexMin : integer;
begin
    infoMin.cod := 9999;
    for i:= 1 to 30 do 
    begin
        if (vecAc[i].cod < infoMin.cod) then 
        begin 
            infoMin := vecAc[i];
            indexMin := i;
        end;
    end;
    if (infoMin.cod <> 9999) then
        leerDet(v[indexMin], vecAc[indexMin]);
end;

var 
    vector : vectorDetalles;
    vecInfo : vectorRegActuales;
    arch : archivoAlimentos;
    infoMin : info;
    al: alimento;
    vNombres : vectorNombres;
begin
    for i := 1 to df do 
    begin   
        readln(vNombres[i]);
        Assign(vector[i], vNombres[i]);
        reset(vector[i]);
        leerDet(vector[i], vecInfo[i]);
    end;

    abrirArchivos(vector);
    Assign(arch, 'maestro');
    reset(arch1);

    minimoVector(vector,infoMin, vecInfo);
    while (infoMin.cod <> 9999) do
    begin
        read(arch,al);
        while(al.cod <> infoMin.cod) do 
            read(arch, al);
        while (al.cod = infoMin.cod) do
        begin
            al.stock := al.stock - infoMin.cantVendida;
            minimoVector(vector, infoMin,vecInfo);
        end;
        seek(arch, filepos(arch)-1);
        write(arch, al);
    end;
    cerrarArchivos(vector);
    close(arch);
end.
