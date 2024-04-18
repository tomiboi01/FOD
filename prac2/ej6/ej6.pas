{6. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.

    }
program HowYourScarsGotScars;
const  ult=1;
type 
   
    reg_servidor = record
        cod_usuario : integer;
        fecha : string[20];
        tiempo_sesion : real;
    end;

    reg_maestro = record
        cod_usuario : integer;
        fecha : string[20];
        tiempo_total_de_sesiones_abiertas : real;
    end;

    archivo_servidor = file of reg_servidor;
    archivo_maestro = file of reg_maestro;

    vector_servidores = array[0..ult] of archivo_servidor;
    vector_registros = array[0..ult] of reg_servidor;
 
procedure leer(var a:archivo_servidor; var r:reg_servidor);
begin
    if (not eof(a)) then 
        read(a, r)
    else r.cod_usuario := 9999;
end;

procedure minimoVector(var vreg:vector_registros;var vdata:vector_servidores; var min:reg_servidor);
var indexMinimo,i:integer;
begin
    min.cod_usuario := 9999;
    for i:= 0 to ult do 
    begin
        if (vreg[i].cod_usuario < min.cod_usuario) then
            begin
                min := vreg[i];
                indexMinimo := i;
            end;
    end; 
        leer(vdata[indexMinimo], vreg[indexMinimo]);
end;

var 
    vreg:vector_registros;
    vdata: vector_servidores;
    min: reg_servidor;
    nombreFisico : string[20];
    i:integer;
    maestro: archivo_maestro;
    regm : reg_maestro;
begin
    for i:= 0 to ult do 
    begin
        readln(nombreFisico);
        Assign(vdata[i], nombreFisico);
        reset(vdata[i]);
        leer(vdata[i], vreg[i]);
    end;
    Assign(maestro, 'c:\var\log\maestro');
    rewrite(maestro);
    minimoVector(vreg,vdata, min);
    while(min.cod_usuario <> 9999) do 
    begin
        regm.fecha := min.fecha;
        regm.cod_usuario := min.cod_usuario;
        regm.tiempo_total_de_sesiones_abiertas := 0;
        while(regm.cod_usuario = min.cod_usuario) do 
        begin
            regm.tiempo_total_de_sesiones_abiertas := regm.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
            minimoVector(vreg,vdata, min);
        end;
        write(maestro, regm);
    end;
end.