#include <cstdio>

extern int foofunc();
extern int barfunc();

int main(int argc, const char** argv)
{
	printf( "%d", barfunc() );
	return 0;
}