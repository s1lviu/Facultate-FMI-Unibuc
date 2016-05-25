#include <iostream>
#include <vector>
#include <cmath>
#include <set>
#include <map>
using namespace std;

vector<int> numarul_in_binar;
void binary(int number) {
	int remainder;

	if(number <= 1) {
		numarul_in_binar.push_back(number);
		printf("%d", number);
		return;
	}

	remainder = number%2;
	binary(number >> 1); 
	numarul_in_binar.push_back(remainder);
	printf("%d", remainder);
}

long long int ridicare_la_putere_logaritmica(long long int base, long long int exponent, int modulo){

	printf("exponentul in binar este: ");
	binary(exponent);
	printf("\n\n");

	long long int z = 1;
	int contor = 0;
	int nr_biti = numarul_in_binar.size() -1;
	printf("      nr_bit (i)       |       valoare_bit (c_i)      |       rezultat_curent (z)");
	printf("\n-----------------------------------------------------------------------------------------\n");

	for(int i=0; i<= nr_biti; ++i){

		printf("       %d		       |", nr_biti - i);
		printf("        %d                     |", numarul_in_binar[i]);
		
		printf("  %d ^ 2 ", z, z);
		z = (z * z) % modulo;
		
		if(numarul_in_binar[i] == 1){
			printf(" * %d ", base);
			z = (z * base) % modulo;
			
		}
		printf(" = %d ", z % modulo);
		printf("\n-----------------------------------------------------------------------------------------\n");
	}
	
	return z;
}

void resturi_patratice(int p, int a, int b){
	map<int,vector<int>> multimea_resturilor_patratice;
	int rest_patratic;
	
	printf("Resturi patratice: \n");

	printf("  x    |");
	for(int i=0;i<=p-1;++i){
		printf(" %d     |",i);
	}

	printf("\n--------------------------------------------------------------------------------------------------------------------------------\n");
	printf("  x^2  |");
	for(int i=0;i<=p-1;++i){
		rest_patratic = (i*i) % p;
		printf("   %d   |", rest_patratic);
		
		if(multimea_resturilor_patratice.count(rest_patratic) > 0){
			map<int,vector<int>>::iterator it;
			it = multimea_resturilor_patratice.find(rest_patratic);
			it->second.push_back(i);
		}
		else{
			vector<int> v;
			v.push_back(i);
			pair<int, vector<int>> aux(rest_patratic,v);
			multimea_resturilor_patratice.insert(aux);
		}
	}
	
	printf("\n\n\n");
	printf("PUNCTELE CURBEI: \n\n");
	//tabelul cu punctele de pe curba
	printf("|   x    |   x^3 + %d*x + %d  |    y    |", a, b);
	printf("\n---------------------------------------\n");
	for(int x = 0; x<p; ++x){
		printf("|   %d    |", x);
		int valoarea_functiei_in_x = (  (int)(pow((double)x,3) + a * x + b ) ) % p;
		printf("         %d        |", valoarea_functiei_in_x);
		
		if(multimea_resturilor_patratice.count(valoarea_functiei_in_x) > 0){
			map<int,vector<int>>::iterator it;
			it = multimea_resturilor_patratice.find(valoarea_functiei_in_x);
			vector<int>::iterator it2;
			for(it2 = it->second.begin(); it2 != it->second.end(); ++it2){
				printf(",%d ", *it2);
			}
			
		}
		else{
			printf("     -");
		}
		printf("\n---------------------------------------\n");
	}

}

void invers_modular(long int n_input, long int b_input){
	long int n, b, q, r, t_i, t_i1, t_i2;
	n = n_input;
	b = b_input;
	r = n % b;
	t_i = 0;
	t_i1 = 1;

	printf("     n     |    b    |    q    |   r    |   t_i   |     t_i1    |      t_i2      |");
	printf("\n---------------------------------------------------------------------------------\n");
	while(r != 1){
		q = n / b;
		r = n % b;
		t_i2 = t_i - q * t_i1;
		printf("     %d     |    %d    |    %d    |   %d    |   %d   |     %d    |      %d      |", n, b, q, r, t_i, t_i1, t_i2);
		printf("\n---------------------------------------------------------------------------------\n");
		n = b;
		b = r;
		t_i = t_i1;
		t_i1= t_i2;
		
	}
}
/*
long long int algoritmul_shanks_pt_log_discret(long long int p, long long int alfa, long long int beta, long long int modulo){
	long long int m = ceil(sqrt(p-1));
	set<pair<long long int, long long int>> L1, L2;
	//calculate alfa la minus 1
	for(long long int i=0; i<= m-1; ++i){
		pair<long long int, long long int> p1(i, ridicare_la_putere_logaritmica(alfa, i, modulo));
		pair<long long int, long long int> p2(i, ( beta * ridicare_la_putere_logaritmica(invers_alfa, i, modulo)) % modulo);
		L1.insert(p1);
		L2.insert(p2);
	}

}*/

int main(){
	freopen("date.out","w",stdout);
	printf("Rezultat: %d", ridicare_la_putere_logaritmica(9726, 3533, 11413));
	//resturi_patratice(17,1,3);
	//invers_modular(40,17);
	return 0;
}