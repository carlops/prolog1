INCLUDE 'iolib.h'

leer(PA,Nfilas,Ncolumnas):-
	write('Nombre Archivo: '),
	read(Archivo),
	open(Archivo,read,Fd),
	close(Fd).
        
	% readdevice(keyboard),
	% readln(Archivo),
	% openread(F,Archivo),
	% readdevice(f),
	% readln(Ncolumnas),
	% leerLaberinto(PA,Nfilas,Ncolumnas),
	% clodsefile(f).

leerLaberinto(PA,Nf,Nc):-
	readLn(Linea),
	length(Linea,Nf).

