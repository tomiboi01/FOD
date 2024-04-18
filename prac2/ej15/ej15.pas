{ La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo}

program ej15;
const dimf = 100;
type 
    registroM = record
        fecha,semanario,descripcion : string[20];
        codSemanario,ejemplares, ejemplaresVendidos : integer;
        precio : real;
    end;

    registroD = record
        fecha : string[20];
        codSemanario, ejemplaresVendidos : integer;
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
        r.fecha := 'zzzzz';

end;

procedure minimo(var vd:vectorDet; var vr:vectorReg; var min:registroD);
var i, indexMin:integer;
begin
    indexMin := 1;
    min.fecha := 'zzzzz';
    min.codSemanario := 9999;
    for i:= 1 to dimf do 
        if (vr[i].fecha < min.fecha) and (vr[i].codSemanario < min.codSemanario) then
        begin
            min := vr[i];
            indexMin := i;
        end;
    
    leer(vd[indexMin], vr[indexMin]);
end;

var 
    min : registroD;
    regm : registroM;
    maestro : archivoM;
    vr : vectorReg;
    vd : vectorDet;
    i,semanarioMax, semanarioActual, cantidadSemMax,semanarioMin, cantidadSemMin,cantidadFechaMax:integer;
    fechaMax, fechaActual : string[20];
begin
    Assign(maestro, 'maestro');
    reset (maestro);
    for i := 1 to dimf do 
    begin
        Assign(vd[i], 'det', i);
        reset(vd[i]);
        leer(vd[i],vr[i]);
    end;
    minimo(vd,vr,min)
    if (min.fecha <> 'zzzzz') then 
    begin
        read(maestro, regm);
        while(min.fecha <> regm.fecha) and (min.codSemanario <> regm.codSemanario) do 
            read(maestro,regm);

    end;
    while(min.fecha <> 'zzzzz') do 
    begin
        while(min.fecha = regm.fecha) do 
        begin
            fechaActual := min.fecha;
            fechaMax := '';
            vendidos := 0;
            while(min.fecha = fechaActual) and (min.codSemanario = regm.codSemanario) do 
            begin
                if ((regm.ejemplares - min.ejemplaresVendidos) < 0) then
                    writeln('No se puede realizar la venta')
                else
                begin
                    regm.ejemplares := regm.ejemplares - min.ejemplaresVendidos;
                    regm.ejemplaresVendidos := regm.ejemplaresVendidos - min.ejemplaresVendidos;
                    vendidos := vendidos + min.ejemplaresVendidos;
                    if (min.ejemplaresVendidos > cantidadSemMax) then 
                    begin
                        semanarioMax := min.codSemanario;
                        cantidadSemMax := min.ejemplaresVendidos;
                    end;
                    if (min.ejemplaresVendidos > cantidadSemMin) then 
                    begin
                        semanarioMin := min.codSemanario;
                        cantidadSemMin := min.ejemplaresVendidos;
                    end;
                end;
                minimo(vd,vr,min);
                seek(maestro, filepos(maestro)-1);
                write(maestro, regm);
                if ( min.fecha <> 'zzzzz')
                    while(min.fecha <> regm.fecha) and (min.codSemanario <> regm.codSemanario) do 
                        read(maestro,regm);
            end;
            if (vendidos > cantidadFechaMax) then
            begin
                cantidadFechaMax := vendidos;
                fechaMax := fechaActual;
            end;
        end;
    end;
end;