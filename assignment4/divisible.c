#include<stdio.h>


int main(){
	int a,b,c;
	printf("Please input three numbers: ");
	scanf("%d %d %d", &a, &b, &c);

	printf("a is %d, b is %d, c is %d\n", a, b,c);
	printf("This is b mod a: %d\n",b%a);

	if (a == 0 && a<b && b<c){                       // dividing by 0 and increasing
                printf("Not divisible & Increasing\n");
                return 1;
        }

	if (a == 0 &&((a>=b)||(b>=c))){                  // dividing by 0 and not increasing
		printf("Not divisible & Not increasing\n");
		return 3;
        }

	if ((b%a == 0 && c%a == 0)&&(a<b)&&(b<c)){
		printf("Divisible & Increasing\n");
		return 0;
	}
	
	if ((b%a != 0 || c%a != 0)&&(a<b)&&(b<c)){
		printf("Not divisible & Increasing\n");
		return 1;
	}

	if ((b%a == 0 && c%a == 0)&&((a>=b)||(b>=c))){
		printf("Divisible & Not increasing\n");
		return 2;
	}

	if ((b%a != 0 || c%a != 0)&&((a>=b)||(b>=c))){
		printf("Not divisible & Not increasing\n");
		return 3;
	}
}
