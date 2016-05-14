#include <cstdio>
#include <cstring>
#include <conio.h>
#include <iostream>
using namespace std;
int main()
{
	freopen("file.in", "r", stdin);
	freopen("file.out", "w", stdout);
	char s[1024];
	scanf("%s", s);
	int n = strlen(s);
	for(int k = 1; k < 26; ++k)
	{
		printf("K = %d\n", k);
		for(int i = 0; i < n; ++i)
		{
			int c = s[i] - 'A';
			c -= k;
			c %= 26;
			if (c < 0) c += 26;
			c += 'A';
			printf("%c", c);
		}
		printf("\n");
	}
	system("pause");
//	while(true);
	return 0;
}