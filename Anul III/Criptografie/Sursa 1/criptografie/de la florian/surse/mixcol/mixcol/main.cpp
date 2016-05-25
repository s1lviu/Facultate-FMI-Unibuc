#include <cstdio>
#include <cstring>
using namespace std;
#define res_only false

struct vec
{
	int v[8];
	vec()
	{
		memset(v, 0, sizeof(v));
	}
};
char hex[16] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
char A[4][4][3] = {{"02", "03", "01", "01"},
	{"01", "02", "03", "01"},
	{"01", "01", "02", "03"},
	{"03", "01", "01", "02"}};

char key[4][4][3];
char B[4][4][3];
char R[4][4][3];
vec add(vec A, vec B)
{
	vec res;
	for(int i = 0; i < 8; ++i)
		res.v[i] = A.v[i] ^ B.v[i];
	return res;
}
vec mul02(vec A)
{
	vec res;
	int i;
	for(i = 0; i < 7; ++i)
		res.v[i] = A.v[i+1];
	if(A.v[0] == 1)
	{
		//xor with 00011011
		res.v[7] ^= 1;
		res.v[6] ^= 1;
		res.v[4] ^= 1;
		res.v[3] ^= 1;
	}
	return res;
}
vec mul03(vec A)
{
	vec tmp = mul02(A);
	return add( tmp, A );
}
vec convert(char a, char b)
{
	// convert ab to binary
	int A, B, i;
	for(i = 0; i < 16; ++i)
	{
		if(hex[i] == a) A = i;
		if(hex[i] == b) B = i;
	}
	vec res;
	for(i = 0; i < 4; ++i)
	{
		if ( B & (1<<i))
			res.v[7 - i] = 1;
		else res.v[7 - i] = 0;

		if( A & (1<<i))
			res.v[3 - i] = 1;
		else res.v[3-i] = 0;
	}
	if(res_only != true) printf("%c%c (", a, b);
	for(i = 0; i < 8; ++i)
		if(res_only != true) printf("%d", res.v[i]);
	if(res_only != true) printf(")");
	return res;
}
char* convert(vec V)
{
	// convert to hex
	char res[2];
	int i, A = 0, B = 0, p = 1;
	for(i = 3; i >= 0; --i)
	{
		A += V.v[i] * p;
		p *= 2;
	}
	res[0] = hex[A];
	
	p = 1;
	for(i = 7; i >= 4; --i)
	{
		B += V.v[i] * p;
		p *= 2;
	}
	res[1] = hex[B];
	return res;
}
void printR()
{
	printf("\n");
	for(int i = 0; i < 4; ++i)
	{
		for(int j = 0; j < 4; ++j)
			printf("%c%c ", R[i][j][0], R[i][j][1]);
		printf("\n");
	}
	printf("\n");
}
void mixCol()
{
	char* r;
	int i, j, k;
	for(i = 0; i < 4; ++i)
	{
		for(j = 0; j < 4; ++j)
		{
			vec res;
			for(k  = 0; k < 4; ++k)
			{
				if(res_only != true) printf("%c%c x ", A[i][k][0], A[i][k][1]);
				if (A[i][k][1] == '1')
					res = add (res, convert(B[k][j][0], B[k][j][1]));
				else if (A[i][k][1] == '2')
					res = add (res, mul02( convert(B[k][j][0], B[k][j][1])));
				else if (A[i][k][1] == '3')
					res = add (res, mul03( convert(B[k][j][0], B[k][j][1])));
				if(res_only != true) printf(" + ");
			}
			r = convert(res);
			R[i][j][0] = r[0];
			R[i][j][1] = r[1];
			if(res_only != true) printf("= %c%c\n", r[0], r[1]);
		}
	}
	printR();
}
void addRoundKey()
{
	int i,j;
	for(i = 0; i < 4; ++i)
	{
		for(j = 0; j < 4; ++j)
		{
			vec r = add( convert(R[i][j][0], R[i][j][1]), convert(key[i][j][0], key[i][j][1]) );
			char *t = convert(r);
			R[i][j][0] = t[0];
			R[i][j][1] = t[1];
		}
	}
	printR();
}
int main()
{
	freopen("file.in", "r", stdin);
		freopen("file.out", "w", stdout);
	// se citeste matricea pt care se aplica mixColumn, apoi cheia de runda
	for(int i = 0; i < 4; ++i)
	{
		for(int j = 0; j < 4; ++j) {
			scanf("%c", &B[i][j][0]);
			scanf("%c", &B[i][j][1]);
			if( j < 3 ) scanf(" ");
		}
		scanf("\n");
	}
	for(int i = 0; i < 4; ++i)
	{
		for(int j = 0; j < 4; ++j) {
			scanf("%c", &key[i][j][0]);
			scanf("%c", &key[i][j][1]);
			if( j < 3 ) scanf(" ");
		}
		scanf("\n");
	}

	mixCol();
	addRoundKey();
	return 0;
}
