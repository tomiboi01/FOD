{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
}

program IWillHelpYouSwim;

type 
	cadena = string[20];
	registroM = record
		cod_prenda, stock, colores : integer;
		precio_unitario:real;
		tipo_prenda, descripcion : cadena;
	end;
	archivo = file of registroM;

	archivoBorrar = file of integer;

procedure leer(var a:archivo; var r:registroM);
begin
	if not eof(a) then
		read (a,r)
	else
		r.cod_prenda := 9999;
end;

procedure eliminarLogico (var a:archivo; var a2:archivoBorrar);
var r:registroM; codigo:integer;
begin
	reset(a);
	reset(a2);
	while not eof(a2) do
	begin
		read(a2,codigo);
		leer(a,r);
		while(r.cod_prenda <> 9999) and (r.cod_prenda <> codigo) do 
			leer(a,r);
		if (r.cod_prenda <> 9999) then
		begin
			r.cod_prenda := r.cod_prenda * (-1);
			seek(a, filepos(a)-1);
			write(a,r);
		end
		else writeln('La prenda con codigo ', codigo, ' no existe');
		seek(a,0);
	end;
	close(a); close(a2);
end;

procedure copiar(var a:archivo; var nuevo:archivo);
var r:registroM;
begin
	rewrite(nuevo);
	reset(a);
	while not eof(a) do 
	begin
		read(a,r);
		if (r.cod_prenda > 0) then
			write(nuevo,r);
	end;
	close(a); close(nuevo);
end;

var r:registroM;
begin
end.