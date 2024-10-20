#include <stdio.h>
#include <string.h>

//The data structure

// file_present is for error message: Phonebook.csv does not exist
char file_present = 'n';

// modified is to override phonebook.csv with saveCSV() or not
char modified = 'n';

// k is the number of lines in the phonebook
int i, j, k = 0;

struct PHONE_RECORD {
	char name[50];
        char birthdate[12];
        char phone[15];
} phonebook[10];

int loadCSV() {
	FILE *csv = fopen("phonebook.csv","rt");
	if (csv == NULL) return 1;
	
	char buffer[100];

	fgets(buffer, 100, csv);     // do this so that last line in CSV file does not get printed twice

        while (!feof(csv) && k<10)
        {
        for(j=0,i=0;i<999&&buffer[i]!='\0'&&buffer[i]!=',';i++,j++)
                phonebook[k].name[j]=buffer[i];
        phonebook[k].name[j]='\0';
        //printf("%s\n", phonebook[k].name);
        i++;

        for(j=0;i<999&&buffer[i]!='\0'&&buffer[i]!=',';i++,j++)
                phonebook[k].birthdate[j]=buffer[i];
        phonebook[k].birthdate[j]='\0';
        //printf("%s\n", phonebook[k].birthdate);
        i++;

        for(j=0;i<999&&buffer[i]!='\0'&&buffer[i]!='\n';i++,j++)       // last thing is '\n' since it's the last column
                phonebook[k].phone[j]=buffer[i];
        phonebook[k].phone[j]='\0';
        //printf("%s\n", phonebook[k].phone);

        fgets(buffer, 100, csv);
	k++;
        }	
	fclose(csv);

	// update file_present
	file_present = 'y';
}

int saveCSV() {
	if (modified == 'n') return 1;
	
	FILE *csv = fopen("phonebook.csv", "wt");
	for (int m=0; m < k; m++){
		fprintf(csv, "%s,%s,%s\n", phonebook[m].name, phonebook[m].birthdate, phonebook[m].phone);
	}
	fclose(csv);
} 

int addRecord() {
	if (k == 10){
		printf("No more space in the CSV file\n");
		return 2;
	}

	char name[50], birthdate[12], phone[15];
	char garbage;

	printf("Name: ");
	fgets(name,50,stdin);
	if ((strlen(name) > 0) && (name[strlen (name) - 1] == '\n'))
        	name[strlen (name) - 1] = '\0';

	strcpy(phonebook[k].name,name);

	printf("Birth: ");
	scanf("%s", birthdate);
	strcpy(phonebook[k].birthdate,birthdate);

	printf("Phone: ");
	scanf("%s",phone);
	scanf("%c",&garbage);   // garbage collection of CR
	strcpy(phonebook[k].phone,phone);
	
	k++;

	//update modified
	modified = 'y';

	//update file_present
	file_present = 'y';
}
	
int findRecord() {
	if (file_present == 'n'){
		printf("Phonebook.csv does not exist\n");
		return 1;
	}
	char find[50];

	printf("Find name: ");
	
	fgets(find, 50, stdin);

	if ((strlen(find) > 0) && (find[strlen (find) - 1] == '\n'))
                find[strlen (find) - 1] = '\0';

	for(int i=0; i<k; i++){
		if (strcmp(phonebook[i].name,find) == 0){
			printf("------NAME-------------- ------BIRTH------ ------PHONE-------\n");
			printf("%s\t\t%s\t\t%s\n", phonebook[i].name, phonebook[i].birthdate, phonebook[i].phone);
			return i; //return index
		}
	}
	printf("Does not exist\n");
	return 1;
}

int listRecords() {
	if (file_present == 'n'){
		printf("Phonebook.csv does not exist\n");
		return 1;
	}
        
	printf("------NAME-------------- ------BIRTH------ ------PHONE-------\n");
	for(int i=0; i<k; i++){
                printf("%s\t\t%s\t\t%s\n", phonebook[i].name, phonebook[i].birthdate, phonebook[i].phone);
	}
}
