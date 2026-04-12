# include <stdio.h>
# include <dlfcn.h> //  the dynamic linking library 
# include <string.h>


int main(){
    

    char lib_n[6]="./lib";
    char so[4]=".so";

    int(*operation)(int, int); // function pointer to a function that takes 2 ints as input 
                               // returns int as output

    while(1){
    char lib[50]="";
    char op[10];
    scanf("%s",op); // operation type input by user 
    if(strcmp(op,"exit")==0)
    {
         break;
    } // dummy exit prompt: user prompt 
    int n,m;
    scanf("%d %d",&n,&m); // integer inputs by user
    
    strcat(lib,lib_n);
    strcat(lib,op);
    strcat(lib,so); // lib="./lib<op>.so" ./ symbolises that it is in the current working directory

    void * ptr = dlopen(lib,RTLD_LAZY); // loads only that library that is required 
     
    // if no such operation-file exists 
    if (ptr == NULL) {
    printf("Such an operation does not exist!\n");
    continue;
    }

    operation=dlsym(ptr,op); // finds the function with the name <op>, operation contains addr of the 
                             // req function 
    

    printf("%d\n",operation(n,m)); // function call 

    dlclose(ptr);
    }
    // NOTE : function ptrs vs functions

    // Prompt to stop the calculator app ? 

    // To run :
    
}