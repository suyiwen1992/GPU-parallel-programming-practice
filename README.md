# GPU-parallel-programming-practice
Implement the Tiled Matrix	Multiplication.There	are	three	modes	of	operation	for	the	application.	Check	main()	for	a	
description	of	the	modes	(repeated	below). You	will	support	each	of these	modes	using	a	Tiled	matrix	multiplication	implementation.
a)	No	arguments:	The	application	will	create	two	randomly	initialized	matrices	to	multiply	size	(1000x1000).	After	the	device	multiplication	is	invoked,	it	will	compute	the	correct	solution	matrix	using	the	CPU,	and	compare	that	solution	with	the	device-computed	solution.	If	it	matches	(within	a	certain	tolerance),	if	will	print	out	"Test	PASSED"	to	the	screen	before	exiting.
b)	One	argument:	The	application	will	use	the	random	initialization	to	create	the	input	matrices	(size	mxm,	where	m	is the	argument).	
c)	Three	arguments	m,	k,	and	n:	The	application	will	initialize	the	two	input	matrices	with	random	values.	A	matrix	will	be	of	size	m	x	k	while	the	B	matrix	will	be	of	size	k	x	n,	producing	a	C	matrix	of	size	m	x	n.
