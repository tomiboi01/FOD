{

   7. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas)
}


program Hello;
const dimF = 2;
type
    infoMaestro = record
        nombreLoc, nombreCepa : string[20];
        codigoLoc, codigoCepa, activos, nuevos,recuperados, fallecidos : integer;
    end;
    infoDetalle = record 
        nombreCepa : string[20];
        codigoCepa,codigoLoc, activos, nuevos,recuperados, fallecidos : integer;
    end;
    
    archivoMaestro = file of infoMaestro;
    archivoDetalle = file of infoDetalle;
    
    vectorDetalles = array[1..dimF] of archivoDetalle;
    vectorRegistros = array[1..dimf] of infoDetalle;

procedure leer(var a:archivoDetalle; var r:infoDetalle);
begin
    if (not eof(a)) then
        read(a,r)
    else 
        r.codigoLoc := 9999; 
end;

procedure minimo (var vDet:vectorDetalles; var vReg:vectorRegistros; var min : infoDetalle);
var i,indexMin : integer;    
begin
    indexMin := 1;
    min.codigoLoc := 9999;
    min.codigoCepa := 9999;
    for i := 1 to dimf do 
    begin
        if (vReg[i].codigoLoc <= min.codigoLoc) and(vReg[i].codigoCepa <= min.codigoCepa)  then 
        begin
            indexMin := i;
            min := vReg[i];
            writeln('min, cepa y loc: ', min.codigoCepa, ' ', min.codigoLoc);
        end;
    end;
    if (min.codigoLoc <> 9999) then
        leer(vDet[indexMin], vReg[indexMin]);
end;

var 
    maestro : archivoMaestro;
    vDet : vectorDetalles;
    vReg : vectorRegistros;
    infoM,m : infoMaestro;
    min, cargar: infoDetalle;
    nombreMaestro,nombreFisico : string[20];
    locActual, cepaActual,i : integer;
    texto : text;
begin
    Writeln('Ingrese nombre del archivo maestro');
    readln(nombreMaestro);
    Assign(maestro, nombreMaestro);
    reset(maestro);
    Assign(texto, 'pap.txt');
    reset (texto);
    for i := 1 to dimf do 
    begin
        writeln('Ingrese nombre del archivo detalle ', i);
        readln(nombreFisico);
        Assign(vDet[i], nombreFisico);
        reset(vDet[i]);
        leer(vDet[i], vReg[i]);
    end;
   
   
    minimo(vDet, vReg, min);
    while(min.codigoLoc <> 9999) do 
        minimo(vDet,vReg,min);
    {while (min.codigoLoc <> 9999) do 
    begin
        read(maestro, infoM);
        while (infoM.codigoCepa <> min.codigoCepa) and (infoM.codigoLoc <> min.codigoLoc) do
            read(maestro, infoM);
        

        while (infoM.codigoloc = min.codigoLoc) do 
        begin
            while (infoM.codigoCepa = min.codigoCepa) and (infoM.codigoLoc = min.codigoLoc) do 
            begin
                infoM.fallecidos := infoM.fallecidos + min.fallecidos;
                infoM.recuperados := infoM.recuperados + min.recuperados;
                infoM.nuevos := min.nuevos;
                infoM.activos := min.activos;
                for i:=1 to dimf do 
                    write(vReg[i].codigoCepa, ' ');
                minimo(vDet,vReg,min);
                writeln(min.codigoLoc);
            end;
           { with infoM do 
                writeln(nombreLoc, nombreCepa, codigoLoc, codigoCepa, nuevos,activos, fallecidos, recuperados);
  }
            seek(maestro, filepos(maestro)-1);
            write(maestro, infoM);
            if (min.codigoLoc <> -1) then
                while (infoM.codigoCepa <> min.codigoCepa) and (infoM.codigoLoc <> min.codigoLoc) do
                    read(maestro, infoM);
        end;
    end;}
    for i:= 1 to dimf do 
    begin
        close(vDet[i]);
    end;
    close(maestro);
end.
