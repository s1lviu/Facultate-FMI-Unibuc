#include<stdio.h>
#include<math.h>
 
long long int a,b,c;
 
 
long long int modulo(long long int a,long long int b,long long int c)
{
long long int x=0;
 
if(b==1) return a%c;
 else{
 if(b%2==1) return (modulo(a,b-1,c)*(a%c))%c;
             else
              {
               x=modulo(a,b/2,c)%c;
               return ((x%c)*(x%c))%c;
              }
 }
}
 
 
int main()
{
	do
	{
		scanf("%lld %lld %lld",&a,&b,&c); 
		if(a != 0)
			printf("%lld\n",modulo(a,b,c));
	}
	while(a != 0);
 
//fcloseall();
return 0;
}