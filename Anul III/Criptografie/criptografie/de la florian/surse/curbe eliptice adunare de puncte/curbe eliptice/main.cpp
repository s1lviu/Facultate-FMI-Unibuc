
#include <cstdio>
#include <iostream>
using namespace std;
int invers( int b, int n)
{
	// returns the modular inverse of b, modulo n
	if(b == 0) return 0;
	while(b < 0) b += n;
	int n0 = n, b0 = b, t0 = 0, t = 1;
	int q = n0/b0;
	int r = n0 - q * b0;
	while(r > 0)
	{
		int tmp = t0 - q * t;
		if (tmp >= 0) tmp %= n;
		else tmp = n - ((-tmp)%n);
		n0 = b0;
		b0 = r;
		t0 = t;
		t = tmp;
		q = n0/b0;
		r = n0-q*b0;
	}
	if(b0 != 1)
	{
		printf("%d nu are invers modulo %d\n", b, n);
		return -1;
	}
	printf("%d^-1 = %d mod %d\n",b,t, n);  
	return t;
}
void addPoints(int x1, int y1, int x2, int y2, int n, int a)
{
	printf("%d %d %d %d %d %d\n", x1, y1, x2, y2, n, a);
	if (x1 == x2 && y2 == -y1)
	{
		printf("O - punctul de la infinit");
		return;
	}
	int lambda;
	if(x1 != x2 || y1 != y2)
	{
		lambda = (y2 - y1) * invers( x2 - x1, n);
	}
	else lambda = (3 * x1 * x1 + a) * invers( (2 * y1)%n, n);
	lambda %= n;
	while(lambda < 0) lambda += n;
	
	printf("Lambda = %d\n", lambda);

	int x3 = lambda * lambda - x1 - x2;
	x3 %= n;
	while(x3 < 0) x3 += n;
	int y3 = lambda * (x1 - x3) - y1;
	y3 %= n;
	while(y3 < 0) y3 += n;
	printf("Rezultat adunare: (%d, %d)\n", x3, y3);
}
int main()
{
	int a, n, x1, y1, x2, y2;
	do
	{
		printf("a n x1 y1 x2 y2 => ");
		cin >> a >> n >> x1 >> y1 >> x2 >> y2;
		if(n!=0)
			addPoints(x1,y1, x2,y2,n,a);
	}
	while(n != 0);
	return 0;
}