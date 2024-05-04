{3.Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. 
De cada novela se registra: código, género, nombre, duración, director y precio.

El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
	i. Dar de alta una novela leyendo la información desde teclado. Para
	esta operación, en caso de ser posible, deberá recuperarse el
	espacio libre. Es decir, si en el campo correspondiente al código de
	novela del registro cabecera hay un valor negativo, por ejemplo -5,
	se debe leer el registro en la posición 5, copiarlo en la posición 0
	(actualizar la lista de espacio libre) y grabar el nuevo registro en la
	posición 5. Con el valor 0 (cero) en el registro cabecera se indica
	que no hay espacio libre.

	ii. Modificar los datos de una novela leyendo la información desde
	teclado. El código de novela no puede ser modificado.

	iii. Eliminar una novela cuyo código es ingresado por teclado. Por
	ejemplo, si se da de baja un registro en la posición 8, en el campo
	código de novela del registro cabecera deberá figurar -8, y en el
	registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}

program WeLiveInABeautifulWorld;

type
	cadena = string[20];
	novela = record
		cod, duracion : integer;
		director, genero, nombre: cadena;
		precio : real;
	end;

	archivo = file of novela;



procedure leer(var a:archivo; var n:novela);
begin
	if not eof(a) then
		read(a,n)
	else n.cod := 9999;
end;
procedure eliminar(var a:archivo; c:integer);
var aux,cabecera:novela; pos:integer;
begin
	reset(a);
	leer(a,cabecera);
	leer(a,aux);
	while (aux.cod <> 9999) and (aux.cod <> c) do 
		leer(a,aux);
	if (aux.cod <> 9999) then
	begin
		seek(a,filepos(a)-1);
		pos := filepos(a) * (-1);
		write(a,cabecera);
		seek(a,0);
		cabecera.cod := pos;
		write(a,cabecera);
	end
	else writeln('No existe la novela con codigo ', c);
	close(a);
end;

procedure insertar (var a:archivo; n:novela);
var cabecera, aux:novela;
begin
    reset(a);
	read(a,cabecera);
	if (cabecera.cod <> 0) then 
	begin
		seek(a, cabecera.cod*(-1));
		read(a,cabecera);
		seek(a,filepos(a)-1);
		write(a,n);
		seek(a,0);
		write(a,cabecera);
	end
	else
	begin
		seek(a,filesize(a));
		write(a,n);
	end;
	close(a);
end;

procedure modificar(var a:archivo; modif:novela);
var n:novela;
begin
	reset(a);
	leer(a,n);
	while (n.cod <> 9999) and (n.cod <> modif.cod) do
		leer (a,n);
	if (n.cod <> 9999) then
	begin
		n.nombre := modif.nombre;
		n.director := modif.director;
		n.genero := modif.genero;
		n.precio := modif.precio;
		seek(a,filepos(a)-1);
		write(a,n);
	end
	else writeln('No existe la novela con codigo ', modif.cod);
	close(a);
end;

procedure cargar(var maestro:archivo; var carga:text);
var n:novela;
begin
	reset(carga);
	while not eof(carga) do 
	begin
		with n do begin
			readln(carga, cod, duracion, precio);
			readln(carga, director);
			readln(carga, genero);
			readln(carga, nombre);
		end;
		write(maestro, n);
	end;
	close (maestro);
	close(carga);
end;

procedure informar (var a:archivo);
var n:novela; pos:integer;
begin
    pos := 0;
	reset(a);
	while not eof(a) do 
	begin
		read(a,n);
		writeln('pos: ', pos, ' y codigo: ',n.cod,', nombre ', n.nombre);
		pos := pos +1;
	end;
	writeln('-------');
	close(a);
end;

procedure leernovela(var n:novela);
begin
    with n do begin
        writeln('Ingrese codigo');
        readln(cod);
        writeln('Ingrese nombre');
        readln(nombre);
        writeln('Ingrese director');
        readln(director);
        writeln('Ingrese genero');
        readln(genero);
        writeln('Ingrese precio');
        readln(precio);
    end;
end;

var 
	n:novela;
	maestro:archivo;
	nombreFisico: cadena;
	carga:text;
	i:integer;

begin
	writeln('Ingrese nombre del archivo');
	readln(nombreFisico);
	Assign(maestro,nombreFisico);
	rewrite(maestro);
	n.cod := 0;
	n.genero := '';
	n.director := '';
	n.precio := 0;
	n.nombre := '';
	
	write(maestro, n);
	Assign(carga, 'novelas.txt');
	cargar(maestro,carga);
	informar(maestro);
	
	writeln('Ingrese nombre del archivo');
	readln(nombreFisico);
	Assign(maestro,nombreFisico);
	eliminar(maestro, 90);
	informar(maestro);
	
	writeln('Ingrese nombre del archivo');
	readln(nombreFisico);
	Assign(maestro,nombreFisico);
	eliminar(maestro, 15);
	informar(maestro);
	
	leernovela(n);
	writeln('Ingrese nombre del archivo');
	readln(nombreFisico);
	Assign(maestro,nombreFisico);
	insertar(maestro,n);
	informar(maestro);
	
	leernovela(n);
	writeln('Ingrese nombre del archivo');
	readln(nombreFisico);
	Assign(maestro,nombreFisico);
	insertar(maestro,n);
	informar(maestro);
	
	leernovela(n);
	writeln('Ingrese nombre del archivo');
	readln(nombreFisico);
	Assign(maestro,nombreFisico);
	insertar(maestro,n);
	informar(maestro);
	
	leernovela(n);
	writeln('Ingrese nombre del archivo');
	readln(nombreFisico);
	Assign(maestro,nombreFisico);
	modificar(maestro, n);
	informar(maestro);

end.