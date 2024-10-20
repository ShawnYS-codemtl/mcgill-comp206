#include <stdio.h>
#include <stdlib.h>

int loadCSV();
int saveCSV();
int addRecord();
int findRecord();
int listRecords();

extern char file_present;
extern char modified;
extern int i, j, k;

extern struct PHONE_RECORD phonebook;

int menu() {// to display the prompt and return the input
	int choice;
	char garbage;
	printf("Phonebook Menu: (1)Add, (2)Find, (3)List, (4)Quit>");
	choice = getc(stdin);
	scanf("%c", &garbage);

	return choice;
}

int main() { // loops until 4 selected, call mini6phone.c functions
	int choice;
	loadCSV();
	choice = menu();
	
	while(choice != '4'){	
		if (choice == '1'){
			addRecord();
		}

		if (choice == '2'){
			findRecord();
		}

		if (choice == '3'){
			listRecords();
		}
		choice = menu();
	}
	saveCSV();
	printf("End of phonebook program\n");
	exit(1);
}
