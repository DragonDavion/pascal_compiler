program ex7_1;

type
	arr = array[1..50] of integer;
	date = record
		year:1900..1999;
		month:1..12;
		day:1..31;
	end;
	days = (sun,mon,tue,wed,thu,fri,sat);
	colors = (red,yellow,blue,white,black,green);
	age = 1..150;

var
	i,a,b : integer;
	inta, intb, intc, intd : integer;
	t : boolean;
	aa:arr;
	dt:date;
	color:colors;
	weekday:days;
	aage:age;
	achar:char;

function testfunc(x,y:integer):integer;
var
	k,sum : integer;
begin
	sum := 1;
	for k:=2 to x div 2 do begin
		if x mod k=0 then begin
			sum := sum + k;
		end;
	end;
	testfunc := x + y; 
end;

function t1(x:integer):boolean;
begin
	write('x=');
	writeln(x);
	t1 := x > 0;
end;

function perfect(x:integer):boolean;
var
	k, sum : integer;
begin
	sum := 1;
	for k:=2 to x div 2 do begin
		if (x mod k) = 0 then begin
			sum := sum + k;
		end;
	end;
	perfect := x=sum;
end;

begin
	a := 20 + 8;
	b := 30 + 700;
	i := (a + b) + 2 * (a + b);

	i := i - 3;
	write('i = ');
	writeln(i);

	i := b div 2;
	write('i = ');
	writeln(i);

	a := 3;
	i := (a + b);
	inta := intb + intc;
	intb := 2;
	intd := intb + intc;

	i := -3;
	
	if (i > 0) then writeln('i > 0')
	else if (i = 0) then writeln('i = 0')
	else writeln('i < 0');

	t := perfect(12);

	write('t = ');
	writeln(t);

	i := 3;
	write('i = ');
	writeln(i);

	i := testfunc(a, b);

	write('i = ');
	writeln(i);

	a := 30;
	b := 40;
	
	repeat
		write('a = ');
		writeln(a);
		write('b = ');
		writeln(b);
		a := a + 1;
	until (a > b);

	for a := 30 to 40 do
	begin
		write('a = ');
		writeln(a);
		a := a + 1;
	end;

	write('a = ');
	writeln(a);

	for a := 40 downto 30 do
	begin
		write('a = ');
		writeln(a);
		b := a + 1;
	end;

	writeln('please input a and b');
	repeat 
			readln(a);
			write('you input a =');
			writeln(a);
			readln(b);
			write('you input b =');
			writeln(b);
	until (a > 0) and (b > 0) and(a < b);


	writeln('List of all perfect numbers:');

	for i:=a to b do
		if perfect(i) then writeln(i);

	a := 2;
	b := 3;

	case a of
		2: i := 3;
		5: i := 4;
		6:
			case b of
				3: i := 6;
				4: i := 7;
			end;
	end;

	write('i = ');
	writeln(i);

	a := 0;
	b := 10;


	while a <= 10 do begin
		b := b + 1;
		write('b =');
		writeln(b);
		a := a + 1;
	end;
	write('b =');
	writeln(b);

	
	for i:=1 to 50 do
		aa[i] := -i;

	writeln(aa[40]);

	for i := 50 downto aa[40] do begin
		write(aa[i]);
		write(' ');
	end;

	dt.year := 2007;
	dt.month := 11;

	write('dt.year=');
	writeln(dt.year);
	write('dt.month=');
	writeln(dt.month);
	weekday := sun;
	if weekday = sun then writeln('sun')
	else writeln('not sun');
	aage := 23;
	aage := 500;
	write('age=');
	writeln(aage);

	i := -3;

	write('i = ');
	writeln(i);

	achar := 'a';
	achar := achar + 1;

	write('achar =');
	write(achar);

end.

