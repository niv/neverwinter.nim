//
// This test script generates all instructions except the STORE_IP instruction
// that is never emitted by the compiler anymore.
// See end of file for disassembly.
//

struct TestStruct { int x; int y; int z; };
struct TestStruct teststruct;
int g;

// SAVE_BASE_POINTER
// JSR
// RESTORE_BASE_POINTER
// MODIFY_STACK_POINTER
void main()
{
    // RUNSTACK_ADD
    // ASSIGNMENT
    // CONSTANT
    int a = 1;
    int b = 2;

    // RUNSTACK_COPY
    int op1  = a || b; Assert(op1 == 1);    // LOGICAL_OR
    int op2  = a && b; Assert(op2 == 1);    // LOGICAL_AND
    int op3  = a |  b; Assert(op3 == 3);    // INCLUSIVE_OR
    int op4  = a ^  b; Assert(op4 == 3);    // EXCLUSIVE_OR
    int op5  = a &  b; Assert(op5 == 0);    // BOOLEAN_AND
    int op6  = a == b; Assert(!op6);        // CONDITION_EQUAL
    int op7  = a != b; Assert(op7);         // CONDITION_NOT_EQUAL
    int op8  = a >= b; Assert(!op8);        // CONDITION_GEQ
    int op9  = a >  b; Assert(!op8);        // CONDITION_GT
    int op10 = a <  b; Assert(op10);        // CONDITION_LT
    int op11 = a <= b; Assert(op11);        // CONDITION_LEQ
    int op12 = a << b; Assert(op12 == 4);   // SHIFT_LEFT
    int op13 = a >> b; Assert(op13 == 0);   // SHIFT_RIGHT
    int op14 = a >>> b; Assert(op14 == 0);  // USHIFT_RIGHT
    int op15 = a +  b; Assert(op15 == 3);   // ADD
    int op16 = a -  b; Assert(op16 == -1);  // SUBTRACT
    int op17 = a *  b; Assert(op17 == 2);   // MULTIPLY
    int op18 = a /  b; Assert(op18 == 0);   // DIVIDE
    int op19 = a %  b; Assert(op19 == 1);   // MODULUS
    int op20 = -a; Assert(op20 == -1);      // NEGATION
    int op21 = ~a; Assert(op21 == -2);      // ONES_COMPLEMENT
    int op22 = !a; Assert(op22 == 0);       // BOOLEAN_NOT
    int op23 = ++a; Assert(op23 == 2);      // INCREMENT_BASE
    int op24 = --a; Assert(op24 == 1);      // DECREMENT_BASE

    // TODO: also test float, string, engst, etc.

    if (a) {}                               // JZ
    else { Assert(FALSE); }                 // JMP, NO_OPERATION
    if (a != b) {}                          // JZ

    teststruct.x = 5;

    // RUNSTACK_COPY_BASE
    // RUNSTACK_COPY
    teststruct.y = teststruct.x;            // DE_STRUCT
    Assert(teststruct.y == 5, "?");
    Assert(teststruct.x == 5);

    g = 3; Assert(g == 3);                  // ASSIGNMENT_BASE

    g++; Assert(g == 4);                    // INCREMENT_BASE
    g--; Assert(g == 3);                    // DECREMENT_BASE

    switch(a)
    {
        case 0: break; // JNZ
    }

    // EXECUTE_COMMAND
    Random(1);
    // STORE_STATE
    TakeClosure(TakeInt(1));
    // RET
}



/*
     0  JSR, 8                                  
     6  RET                                     
     8  RUNSTACK_ADD, TYPE_INTEGER              
    10  RUNSTACK_ADD, TYPE_INTEGER              
    12  RUNSTACK_ADD, TYPE_INTEGER              
    14  RUNSTACK_ADD, TYPE_INTEGER              
    16  SAVE_BASE_POINTER                       
    18  JSR, 16                                 
    24  RESTORE_BASE_POINTER                    
    26  MODIFY_STACK_POINTER, -16               
    32  RET                                     
    34  RUNSTACK_ADD, TYPE_INTEGER              
    36  CONSTANT, TYPE_INTEGER, 1               
    42  ASSIGNMENT, TYPE_VOID, -8, 4            
    50  MODIFY_STACK_POINTER, -4                
    56  RUNSTACK_ADD, TYPE_INTEGER              
    58  CONSTANT, TYPE_INTEGER, 2               
    64  ASSIGNMENT, TYPE_VOID, -8, 4            
    72  MODIFY_STACK_POINTER, -4                
    78  RUNSTACK_ADD, TYPE_INTEGER              
    80  RUNSTACK_COPY, TYPE_VOID, -12           
    88  RUNSTACK_COPY, TYPE_VOID, -4            
    96  JZ, 20                                  
   102  RUNSTACK_COPY, TYPE_VOID, -4            
   110  JMP, 14                                 
   116  RUNSTACK_COPY, TYPE_VOID, -12           
   124  LOGICAL_OR, TYPETYPE_INTEGER_INTEGER    
   126  ASSIGNMENT, TYPE_VOID, -8, 4            
   134  MODIFY_STACK_POINTER, -4                
   140  RUNSTACK_ADD, TYPE_INTEGER              
   142  RUNSTACK_COPY, TYPE_VOID, -16           
   150  RUNSTACK_COPY, TYPE_VOID, -4            
   158  JZ, 16                                  
   164  RUNSTACK_COPY, TYPE_VOID, -16           
   172  LOGICAL_AND, TYPETYPE_INTEGER_INTEGER   
   174  ASSIGNMENT, TYPE_VOID, -8, 4            
   182  MODIFY_STACK_POINTER, -4                
   188  RUNSTACK_ADD, TYPE_INTEGER              
   190  RUNSTACK_COPY, TYPE_VOID, -20           
   198  RUNSTACK_COPY, TYPE_VOID, -20           
   206  INCLUSIVE_OR, TYPETYPE_INTEGER_INTEGER  
   208  ASSIGNMENT, TYPE_VOID, -8, 4            
   216  MODIFY_STACK_POINTER, -4                
   222  RUNSTACK_ADD, TYPE_INTEGER              
   224  RUNSTACK_COPY, TYPE_VOID, -24           
   232  RUNSTACK_COPY, TYPE_VOID, -24           
   240  EXCLUSIVE_OR, TYPETYPE_INTEGER_INTEGER  
   242  ASSIGNMENT, TYPE_VOID, -8, 4            
   250  MODIFY_STACK_POINTER, -4                
   256  RUNSTACK_ADD, TYPE_INTEGER              
   258  RUNSTACK_COPY, TYPE_VOID, -28           
   266  RUNSTACK_COPY, TYPE_VOID, -28           
   274  BOOLEAN_AND, TYPETYPE_INTEGER_INTEGER   
   276  ASSIGNMENT, TYPE_VOID, -8, 4            
   284  MODIFY_STACK_POINTER, -4                
   290  RUNSTACK_ADD, TYPE_INTEGER              
   292  RUNSTACK_COPY, TYPE_VOID, -32           
   300  RUNSTACK_COPY, TYPE_VOID, -32           
   308  EQUAL, TYPETYPE_INTEGER_INTEGER         
   310  ASSIGNMENT, TYPE_VOID, -8, 4            
   318  MODIFY_STACK_POINTER, -4                
   324  RUNSTACK_ADD, TYPE_INTEGER              
   326  RUNSTACK_COPY, TYPE_VOID, -36           
   334  RUNSTACK_COPY, TYPE_VOID, -36           
   342  NOT_EQUAL, TYPETYPE_INTEGER_INTEGER     
   344  ASSIGNMENT, TYPE_VOID, -8, 4            
   352  MODIFY_STACK_POINTER, -4                
   358  RUNSTACK_ADD, TYPE_INTEGER              
   360  RUNSTACK_COPY, TYPE_VOID, -40           
   368  RUNSTACK_COPY, TYPE_VOID, -40           
   376  GEQ, TYPETYPE_INTEGER_INTEGER           
   378  ASSIGNMENT, TYPE_VOID, -8, 4            
   386  MODIFY_STACK_POINTER, -4                
   392  RUNSTACK_ADD, TYPE_INTEGER              
   394  RUNSTACK_COPY, TYPE_VOID, -44           
   402  RUNSTACK_COPY, TYPE_VOID, -44           
   410  GT, TYPETYPE_INTEGER_INTEGER            
   412  ASSIGNMENT, TYPE_VOID, -8, 4            
   420  MODIFY_STACK_POINTER, -4                
   426  RUNSTACK_ADD, TYPE_INTEGER              
   428  RUNSTACK_COPY, TYPE_VOID, -48           
   436  RUNSTACK_COPY, TYPE_VOID, -48           
   444  LT, TYPETYPE_INTEGER_INTEGER            
   446  ASSIGNMENT, TYPE_VOID, -8, 4            
   454  MODIFY_STACK_POINTER, -4                
   460  RUNSTACK_ADD, TYPE_INTEGER              
   462  RUNSTACK_COPY, TYPE_VOID, -52           
   470  RUNSTACK_COPY, TYPE_VOID, -52           
   478  LEQ, TYPETYPE_INTEGER_INTEGER           
   480  ASSIGNMENT, TYPE_VOID, -8, 4            
   488  MODIFY_STACK_POINTER, -4                
   494  RUNSTACK_ADD, TYPE_INTEGER              
   496  RUNSTACK_COPY, TYPE_VOID, -56           
   504  RUNSTACK_COPY, TYPE_VOID, -56           
   512  SHIFT_LEFT, TYPETYPE_INTEGER_INTEGER    
   514  ASSIGNMENT, TYPE_VOID, -8, 4            
   522  MODIFY_STACK_POINTER, -4                
   528  RUNSTACK_ADD, TYPE_INTEGER              
   530  RUNSTACK_COPY, TYPE_VOID, -60           
   538  RUNSTACK_COPY, TYPE_VOID, -60           
   546  SHIFT_RIGHT, TYPETYPE_INTEGER_INTEGER   
   548  ASSIGNMENT, TYPE_VOID, -8, 4            
   556  MODIFY_STACK_POINTER, -4                
   562  RUNSTACK_ADD, TYPE_INTEGER              
   564  RUNSTACK_COPY, TYPE_VOID, -64           
   572  RUNSTACK_COPY, TYPE_VOID, -64           
   580  USHIFT_RIGHT, TYPETYPE_INTEGER_INTEGER  
   582  ASSIGNMENT, TYPE_VOID, -8, 4            
   590  MODIFY_STACK_POINTER, -4                
   596  RUNSTACK_ADD, TYPE_INTEGER              
   598  RUNSTACK_COPY, TYPE_VOID, -68           
   606  RUNSTACK_COPY, TYPE_VOID, -68           
   614  ADD, TYPETYPE_INTEGER_INTEGER           
   616  ASSIGNMENT, TYPE_VOID, -8, 4            
   624  MODIFY_STACK_POINTER, -4                
   630  RUNSTACK_ADD, TYPE_INTEGER              
   632  RUNSTACK_COPY, TYPE_VOID, -72           
   640  RUNSTACK_COPY, TYPE_VOID, -72           
   648  SUB, TYPETYPE_INTEGER_INTEGER           
   650  ASSIGNMENT, TYPE_VOID, -8, 4            
   658  MODIFY_STACK_POINTER, -4                
   664  RUNSTACK_ADD, TYPE_INTEGER              
   666  RUNSTACK_COPY, TYPE_VOID, -76           
   674  RUNSTACK_COPY, TYPE_VOID, -76           
   682  MUL, TYPETYPE_INTEGER_INTEGER           
   684  ASSIGNMENT, TYPE_VOID, -8, 4            
   692  MODIFY_STACK_POINTER, -4                
   698  RUNSTACK_ADD, TYPE_INTEGER              
   700  RUNSTACK_COPY, TYPE_VOID, -80           
   708  RUNSTACK_COPY, TYPE_VOID, -80           
   716  DIV, TYPETYPE_INTEGER_INTEGER           
   718  ASSIGNMENT, TYPE_VOID, -8, 4            
   726  MODIFY_STACK_POINTER, -4                
   732  RUNSTACK_ADD, TYPE_INTEGER              
   734  RUNSTACK_COPY, TYPE_VOID, -84           
   742  RUNSTACK_COPY, TYPE_VOID, -84           
   750  MODULUS, TYPETYPE_INTEGER_INTEGER       
   752  ASSIGNMENT, TYPE_VOID, -8, 4            
   760  MODIFY_STACK_POINTER, -4                
   766  RUNSTACK_ADD, TYPE_INTEGER              
   768  RUNSTACK_COPY, TYPE_VOID, -88           
   776  NEGATION, TYPE_INTEGER                  
   778  ASSIGNMENT, TYPE_VOID, -8, 4            
   786  MODIFY_STACK_POINTER, -4                
   792  RUNSTACK_ADD, TYPE_INTEGER              
   794  RUNSTACK_COPY, TYPE_VOID, -92           
   802  ONES_COMPLEMENT, TYPE_INTEGER           
   804  ASSIGNMENT, TYPE_VOID, -8, 4            
   812  MODIFY_STACK_POINTER, -4                
   818  RUNSTACK_ADD, TYPE_INTEGER              
   820  RUNSTACK_COPY, TYPE_VOID, -96           
   828  BOOLEAN_NOT, TYPE_INTEGER               
   830  ASSIGNMENT, TYPE_VOID, -8, 4            
   838  MODIFY_STACK_POINTER, -4                
   844  RUNSTACK_ADD, TYPE_INTEGER              
   846  INCREMENT, TYPE_INTEGER, -100           
   852  RUNSTACK_COPY, TYPE_VOID, -100          
   860  ASSIGNMENT, TYPE_VOID, -8, 4            
   868  MODIFY_STACK_POINTER, -4                
   874  RUNSTACK_ADD, TYPE_INTEGER              
   876  DECREMENT, TYPE_INTEGER, -104           
   882  RUNSTACK_COPY, TYPE_VOID, -104          
   890  ASSIGNMENT, TYPE_VOID, -8, 4            
   898  MODIFY_STACK_POINTER, -4                
   904  RUNSTACK_COPY, TYPE_VOID, -104          
   912  JZ, 12                                  
   918  JMP, 8                                  
   924  NO_OPERATION                            
   926  RUNSTACK_COPY, TYPE_VOID, -104          
   934  RUNSTACK_COPY, TYPE_VOID, -104          
   942  NOT_EQUAL, TYPETYPE_INTEGER_INTEGER     
   944  JZ, 12                                  
   950  JMP, 6                                  
   956  RUNSTACK_COPY_BASE, TYPE_VOID, -16      
   964  DE_STRUCT, TYPE_VOID, 12, 4, 4          
   972  ASSIGNMENT_BASE, TYPE_VOID, -16, 4      
   980  MODIFY_STACK_POINTER, -4                
   986  CONSTANT, TYPE_INTEGER, 3               
   992  ASSIGNMENT_BASE, TYPE_VOID, -4, 4       
  1000  MODIFY_STACK_POINTER, -4                
  1006  RUNSTACK_COPY_BASE, TYPE_VOID, -4       
  1014  INCREMENT_BASE, TYPE_INTEGER, -4        
  1020  MODIFY_STACK_POINTER, -4                
  1026  RUNSTACK_COPY_BASE, TYPE_VOID, -4       
  1034  DECREMENT_BASE, TYPE_INTEGER, -4        
  1040  MODIFY_STACK_POINTER, -4                
  1046  RUNSTACK_COPY, TYPE_VOID, -104          
  1054  RUNSTACK_COPY, TYPE_VOID, -4            
  1062  CONSTANT, TYPE_INTEGER, 0               
  1068  EQUAL, TYPETYPE_INTEGER_INTEGER         
  1070  JNZ, 12                                 
  1076  JMP, 12                                 
  1082  JMP, 6                                  
  1088  MODIFY_STACK_POINTER, -4                
  1094  CONSTANT, TYPE_INTEGER, 1               
  1100  EXECUTE_COMMAND, 0, 1                   
  1105  MODIFY_STACK_POINTER, -4                
  1111  STORE_STATE, TYPE_ENGST0, 16, 104       
  1121  JMP, 21                                 
  1127  CONSTANT, TYPE_STRING, "Done"           
  1135  EXECUTE_COMMAND, 1, 1                   
  1140  RET                                     
  1142  CONSTANT, TYPE_FLOAT, 0.1000000014901161
  1148  EXECUTE_COMMAND, 7, 2                   
  1153  MODIFY_STACK_POINTER, -104              
  1159  RET                                     
*/
