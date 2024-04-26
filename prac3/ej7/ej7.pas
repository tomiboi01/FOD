{7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}

program ButYouCanAlwaysCallMe;
type 
	cadena=string[20];
	especieAve = record
		cod:longInt;
		nombre, familiaAve, descripcion, zona:cadena;
	end;

	archivo = file of especieAve;

procedure leer(var a:archivo; var e:especieAve);
begin
	if not eof(a) then
		read (a,e)
	else 
		e.cod := 9999;
end;

procedure borradoLogico(var a:archivos);
var e:especieAve; cod:longint; nombre:string[20];
begin
	reset(a);
	readln(cod);
	while(cod <> 500000) do 
	begin
		readln(nombre);
		seek(a,0);
		leer(a,e);
		while (e.cod <> 9999) and (e.nombre <> nombre) do 
			leer(a,e);
		if (e.cod <> 9999)then
		begin
			e.cod := e.cod * (-1);
		end
		else 
			writeln('No existe esa especie');
		readln(cod);
	end;
	close(a);
end;

procedure compactar(var a:archivo; regBorrados : integer);
var cabez, ult,e : especieAve; ultPos, pos:integer;
begin
	reset(a);
    ultPos := filesize(a)-1;
    pos := 0;
    if not eof(a) then
    begin
        read(a,e)
        while (pos <> ultPos) and (e.cod > 0) do 
        begin
            pos := pos + 1;
            read(a,e);
        end;
        seek(a,ultPos);
        read(a,ult);
        while(pos <> ultPos) and (ult.cod > 0) do 
        begin
            ultPos := ultPos - 1; 
            seek(a,ultPos);
            read(a,ult);
        end;
        seek(a,pos);
        write(a,ult);
        pos := pos + 1;
        ultPos := ultPos - 1;
        seek(a,pos);

    seek(a,ultPos);
	truncate(a);
	close(a);}
    
    end;
	
end;

procedure informar(var a:archivo);
var e:especieAve;
begin
    while not eof(a) do 
    begin
        read(a,e);
        writeln(e.cod,' ', e.nombre);
    end;

end;

var maestro:archivo;
	e:especieAve;
	regBorrados:integer;
	codigo:longInt;
	nombre,nombreFisico:cadena;
BEGIN
	readln(nombreFisico);
	assign(maestro,nombreFisico);
	rewrite(maestro);
	e.cod := 0;
	write(maestro,e);
	writeln('codigo y nombre');
	readln(e.cod);
	while(e.cod <> 500000) do
	begin
	    readln(e.nombre);
		write(maestro,e);
		writeln('codigo y nombre');
		readln(e.cod);
	end;
	close(maestro);

	informar(maestro);

	borradologico(maestro);
	informar(maestro);

	compactar(maestro);

    informar(a);
end.