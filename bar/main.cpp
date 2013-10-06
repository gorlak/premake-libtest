extern int foofunc();

int barfunc()
{
	return foofunc() + 1;
}