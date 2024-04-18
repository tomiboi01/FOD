{14. Se desea modelar la información de una ONG dedicada a la asistencia de personas conLuz
carencias habitacionales. La ONG cuenta conLuz un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua, # viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas conLuz luz, #viviendas
construidas, #viviendas conLuz agua, #viviendas conLuz gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro conLuz los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
● Idem para viviendas sin agua, sin gas y sin sanitarios.
● A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}


program ej14;
const dimf = 10;
type 
    registroD = record 
        codProvincia, codLocalidad, conLuz, conAgua, conGas, sanitarios,construidas : integer;
    end;

    registroM = record
        codProvincia, codLocalidad, sinLuz, sinAgua, sinGas, chapas, sinSanitarios: integer;
        localidad : string[20];
    end;

    archivoM = file of registroM;

    archivoD = file of registroD;

    vectorDet = array[1..dimf] of archivoD;
    vectorReg = array[1..dimf] of registroD;


procedure leer(var a:archivoD; var r:registroD);
begin
    if not eof(a) then 
        read(a,r)
    else 
        r.codProvincia := 9999;

end;

procedure minimo(var vd:vectorDet; var vr:vectorReg; var min:registroD);
var i, indexMin:integer;
begin
    indexMin := 1;
    min.codProvincia := 9999;
    min.codLocalidad := 9999;
    for i:= 1 to dimf do 
        if (vr[i].codProvincia < min.codProvincia) and (vr[i].codLocalidad < min.codLocalidad) then
        begin
            min := vr[i];
            indexMin := i;
        end;
    
    leer(vd[indexMin], vr[indexMin]);
end;


var maestro:archivoM;
    vr:vectorReg;
    vd:vectorDet;
    min:registroD;
    regm:registroM;
    cantidadSinChapas:integer;
begin
    Assign(maestro,'maestro');
    reset(maestro);
    minimo(vd,vr, min);
    while(min.codProvincia <> 9999) do 
    begin
        read(maestro,regm);
        while(regm.codProvincia<>min.codProvincia) and (regm.codLocalidad <> min.codLocalidad) do 
            read(maestro,regm);
        regm.sinLuz := regm.sinLuz - min.conLuz;
        regm.sinAgua := regm.sinAgua - min.conAgua;
        regm.sinGas := regm.sinGas - min.conGas;
        regm.chapas := regm.chapas - min.construidas;
        seek(maestro, filepos(maestro)-1);
        write(maestro,regm)
        if (regm.chapas = 0) then 
            cantidadSinChapas := cantidadSinChapas - 1;
        minimo(vr,vd,min);
    end;
    writeln(cantidadSinChapas);
end.