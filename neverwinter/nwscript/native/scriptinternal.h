//
// SPDX-License-Identifier: GPL-3.0
//
// This file is part of the NWScript compiler open source release.
//
// The initial source release is licensed under GPL-3.0.
//
// All subsequent changes you submit are required to be licensed under MIT.
//
// However, the project overall will still be GPL-3.0.
//
// The intent is for the base game to be able to pick up changes you explicitly
// submit for inclusion painlessly, while ensuring the overall project source code
// remains available for everyone.
//

///////////////////////////////////////////////////////////////////////////////
//                 BIOWARE CORP. CONFIDENTIAL INFORMATION.                   //
//               COPYRIGHT BIOWARE CORP. ALL RIGHTS RESERVED                 //
///////////////////////////////////////////////////////////////////////////////

//::///////////////////////////////////////////////////////////////////////////
//::
//::  Script Project
//::
//::  Copyright (c) 2002, BioWare Corp.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  ScriptInternal.h
//::
//::  Header file for constants and non-exposed classes used inside Script
//::  project.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created By: Mark Brockington
//::  Created On: Oct. 8, 2002
//::
//::///////////////////////////////////////////////////////////////////////////

#ifndef __SCRIPTINTERNAL_H__
#define __SCRIPTINTERNAL_H__

#define CSCRIPTCOMPILER_MAX_STACK_ENTRIES    1024
#define CSCRIPTCOMPILER_MAX_OPERATIONS       88
#define CSCRIPTCOMPILER_MAX_IDENTIFIERS      65536
#define CSCRIPTCOMPILER_SIZE_IDENTIFIER_HASH_TABLE  131072  // NOTE:  This should be larger than MAX_IDENTIFIERS
#define CSCRIPTCOMPILER_MASK_SIZE_IDENTIFIER_HASH_TABLE 0x0001ffff
#define CSCRIPTCOMPILER_MAX_VARIABLES        1024
#define CSCRIPTCOMPILER_MAX_CODE_SIZE        524288  // 512K.
#define CSCRIPTCOMPILER_MAX_DEBUG_OUTPUT_SIZE 2097152 // 2048K, 1048576 = 1024K.
#define CSCRIPTCOMPILER_MAX_STRUCTURES       256
#define CSCRIPTCOMPILER_MAX_STRUCTURE_FIELDS 4096
#define CSCRIPTCOMPILER_MAX_KEYWORDS         42

#define CSCRIPTCOMPILER_BINARY_ADDRESS_LENGTH          13


#define CSCRIPTCOMPILER_TOKEN_UNKNOWN             0
#define CSCRIPTCOMPILER_TOKEN_DIVIDE              1
#define CSCRIPTCOMPILER_TOKEN_CPLUSCOMMENT        2
#define CSCRIPTCOMPILER_TOKEN_CCOMMENT            3
#define CSCRIPTCOMPILER_TOKEN_INTEGER             4
#define CSCRIPTCOMPILER_TOKEN_FLOAT               5
#define CSCRIPTCOMPILER_TOKEN_IDENTIFIER          6
#define CSCRIPTCOMPILER_TOKEN_STRING              7
#define CSCRIPTCOMPILER_TOKEN_LOGICAL_AND         8
#define CSCRIPTCOMPILER_TOKEN_LOGICAL_OR          9
#define CSCRIPTCOMPILER_TOKEN_MINUS               10
#define CSCRIPTCOMPILER_TOKEN_LEFT_BRACE          11
#define CSCRIPTCOMPILER_TOKEN_RIGHT_BRACE         12
#define CSCRIPTCOMPILER_TOKEN_LEFT_BRACKET        13
#define CSCRIPTCOMPILER_TOKEN_RIGHT_BRACKET       14
#define CSCRIPTCOMPILER_TOKEN_SEMICOLON           15
#define CSCRIPTCOMPILER_TOKEN_COMMA               16
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_IF          17
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ELSE        18
#define CSCRIPTCOMPILER_TOKEN_EOF                 19
#define CSCRIPTCOMPILER_TOKEN_COND_GREATER_EQUAL  20
#define CSCRIPTCOMPILER_TOKEN_COND_LESS_EQUAL     21
#define CSCRIPTCOMPILER_TOKEN_COND_GREATER_THAN   22
#define CSCRIPTCOMPILER_TOKEN_COND_LESS_THAN      23
#define CSCRIPTCOMPILER_TOKEN_COND_NOT_EQUAL      24
#define CSCRIPTCOMPILER_TOKEN_COND_EQUAL          25
#define CSCRIPTCOMPILER_TOKEN_PLUS                26
#define CSCRIPTCOMPILER_TOKEN_MODULUS             27
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_EQUAL    28
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_INT         29
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_FLOAT       30
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_STRING      31
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT      32
#define CSCRIPTCOMPILER_TOKEN_VARIABLE            33
#define CSCRIPTCOMPILER_TOKEN_INTEGER_IDENTIFIER  34
#define CSCRIPTCOMPILER_TOKEN_FLOAT_IDENTIFIER    35
#define CSCRIPTCOMPILER_TOKEN_STRING_IDENTIFIER   36
#define CSCRIPTCOMPILER_TOKEN_OBJECT_IDENTIFIER   37
#define CSCRIPTCOMPILER_TOKEN_VOID_IDENTIFIER     38
#define CSCRIPTCOMPILER_TOKEN_INCLUSIVE_OR        39
#define CSCRIPTCOMPILER_TOKEN_EXCLUSIVE_OR        40
#define CSCRIPTCOMPILER_TOKEN_BOOLEAN_AND         41
#define CSCRIPTCOMPILER_TOKEN_SHIFT_LEFT          42
#define CSCRIPTCOMPILER_TOKEN_SHIFT_RIGHT         43
#define CSCRIPTCOMPILER_TOKEN_MULTIPLY                                 44
#define CSCRIPTCOMPILER_TOKEN_HEX_INTEGER                              45
#define CSCRIPTCOMPILER_TOKEN_UNSIGNED_SHIFT_RIGHT                     46
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ACTION                           47
#define CSCRIPTCOMPILER_TOKEN_TILDE                                    48
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_RETURN                           49
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_WHILE                            50
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_FOR                              51
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_DO                               52
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_VOID                             53
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_STRUCT                           54
#define CSCRIPTCOMPILER_TOKEN_STRUCTURE_PART_SPECIFY                   55
#define CSCRIPTCOMPILER_TOKEN_STRUCTURE_IDENTIFIER                     56
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_INCLUDE                          57
#define CSCRIPTCOMPILER_TOKEN_BOOLEAN_NOT                              58
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_VECTOR                           59
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_DEFINE                           60
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_NUM_STRUCTURES_DEFINITION 61
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE_DEFINITION      62
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE0                63
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE1                64
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE2                65
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE3                66
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE4                67
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE5                68
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE6                69
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE7                70
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE8                71
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_ENGINE_STRUCTURE9                72
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE0_IDENTIFIER             73
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE1_IDENTIFIER             74
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE2_IDENTIFIER             75
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE3_IDENTIFIER             76
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE4_IDENTIFIER             77
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE5_IDENTIFIER             78
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE6_IDENTIFIER             79
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE7_IDENTIFIER             80
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE8_IDENTIFIER             81
#define CSCRIPTCOMPILER_TOKEN_ENGINE_STRUCTURE9_IDENTIFIER             82
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_SELF                      83
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_OBJECT_INVALID                   84
#define CSCRIPTCOMPILER_TOKEN_VECTOR_IDENTIFIER                        85
#define CSCRIPTCOMPILER_TOKEN_LEFT_SQUARE_BRACKET                      86
#define CSCRIPTCOMPILER_TOKEN_RIGHT_SQUARE_BRACKET                     87
#define CSCRIPTCOMPILER_TOKEN_INCREMENT                                88
#define CSCRIPTCOMPILER_TOKEN_DECREMENT                                89
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MINUS                         90
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_PLUS                          91
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MULTIPLY                      92
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_DIVIDE                        93
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_MODULUS                       94
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_AND                           95
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_XOR                           96
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_OR                            97
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_SHIFT_LEFT                    98
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_SHIFT_RIGHT                   99
#define CSCRIPTCOMPILER_TOKEN_ASSIGNMENT_USHIFT_RIGHT                 100
#define CSCRIPTCOMPILER_TOKEN_QUESTION_MARK                           101
#define CSCRIPTCOMPILER_TOKEN_COLON                                   102
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_CASE                            103
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_BREAK                           104
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_SWITCH                          105
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_DEFAULT                         106
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_CONTINUE                        107
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_CONST                           108
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_NULL                       109
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_FALSE                      110
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_TRUE                       111
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_OBJECT                     112
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_ARRAY                      113
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_JSON_STRING                     114
#define CSCRIPTCOMPILER_TOKEN_KEYWORD_LOCATION_INVALID                115
#define CSCRIPTCOMPILER_TOKEN_RAW_STRING                              116

const char *TokenKeywordToString(int nTokenKeyword);

#define CSCRIPTCOMPILER_GRAMMAR_PROGRAM                            0
#define CSCRIPTCOMPILER_GRAMMAR_FUNCTIONAL_UNIT                    1
#define CSCRIPTCOMPILER_GRAMMAR_AFTER_PROGRAM                      2
#define CSCRIPTCOMPILER_GRAMMAR_FUNCTION_PARAM_LIST                3
#define CSCRIPTCOMPILER_GRAMMAR_AFTER_FUNCTION_PARAM               4
#define CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_LIST                 5
#define CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_VARLIST              6
#define CSCRIPTCOMPILER_GRAMMAR_NON_INIT_DECL_VARLIST_SEPARATOR    7
#define CSCRIPTCOMPILER_GRAMMAR_WITHIN_COMPOUND_STATEMENT          8
#define CSCRIPTCOMPILER_GRAMMAR_WITHIN_STATEMENT_LIST              9
#define CSCRIPTCOMPILER_GRAMMAR_WITHIN_A_STATEMENT                10
#define CSCRIPTCOMPILER_GRAMMAR_ANY_TYPE_SPECIFIER                11
#define CSCRIPTCOMPILER_GRAMMAR_NON_VOID_TYPE_SPECIFIER           12
#define CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST                      13
#define CSCRIPTCOMPILER_GRAMMAR_DECL_VARLIST_SEPARATOR            14
#define CSCRIPTCOMPILER_GRAMMAR_ARGUMENT_EXPRESSION_LIST          15
#define CSCRIPTCOMPILER_GRAMMAR_AFTER_ARGUMENT_EXPRESSION         16
#define CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_EXPRESSION                17
#define CSCRIPTCOMPILER_GRAMMAR_NON_VOID_EXPRESSION               18
#define CSCRIPTCOMPILER_GRAMMAR_EXPRESSION                        19
#define CSCRIPTCOMPILER_GRAMMAR_ASSIGNMENT_EXPRESSION             20
#define CSCRIPTCOMPILER_GRAMMAR_CONDITIONAL_EXPRESSION            21
#define CSCRIPTCOMPILER_GRAMMAR_LOGICAL_OR_EXPRESSION             22
#define CSCRIPTCOMPILER_GRAMMAR_LOGICAL_AND_EXPRESSION            23
#define CSCRIPTCOMPILER_GRAMMAR_INCLUSIVE_OR_EXPRESSION           24
#define CSCRIPTCOMPILER_GRAMMAR_EXCLUSIVE_OR_EXPRESSION           25
#define CSCRIPTCOMPILER_GRAMMAR_BOOLEAN_AND_EXPRESSION            26
#define CSCRIPTCOMPILER_GRAMMAR_EQUALITY_EXPRESSION               27
#define CSCRIPTCOMPILER_GRAMMAR_RELATIONAL_EXPRESSION             28
#define CSCRIPTCOMPILER_GRAMMAR_SHIFT_EXPRESSION                  29
#define CSCRIPTCOMPILER_GRAMMAR_ADDITIVE_EXPRESSION               30
#define CSCRIPTCOMPILER_GRAMMAR_MULTIPLICATIVE_EXPRESSION         31
#define CSCRIPTCOMPILER_GRAMMAR_UNARY_EXPRESSION                  32
#define CSCRIPTCOMPILER_GRAMMAR_POST_EXPRESSION                   33
#define CSCRIPTCOMPILER_GRAMMAR_PRIMARY_EXPRESSION                34
#define CSCRIPTCOMPILER_GRAMMAR_CONSTANT                          35

const char *GrammarToString(int nGrammar);

#define CSCRIPTCOMPILER_OPERATION_COMPOUND_STATEMENT   0
#define CSCRIPTCOMPILER_OPERATION_STATEMENT            1
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_DECLARATION  2
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_INT          3
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_FLOAT        4
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_STRING       5
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_OBJECT       6
#define CSCRIPTCOMPILER_OPERATION_VARIABLE_LIST        7
#define CSCRIPTCOMPILER_OPERATION_VARIABLE             8
#define CSCRIPTCOMPILER_OPERATION_STATEMENT_LIST       9
#define CSCRIPTCOMPILER_OPERATION_IF_BLOCK             10
#define CSCRIPTCOMPILER_OPERATION_IF_CHOICE            11
#define CSCRIPTCOMPILER_OPERATION_IF_CONDITION         12
#define CSCRIPTCOMPILER_OPERATION_ACTION               13
#define CSCRIPTCOMPILER_OPERATION_ACTION_ID            14
#define CSCRIPTCOMPILER_OPERATION_ASSIGNMENT           15
#define CSCRIPTCOMPILER_OPERATION_ACTION_ARG_LIST      16
#define CSCRIPTCOMPILER_OPERATION_CONSTANT_INTEGER     17
#define CSCRIPTCOMPILER_OPERATION_CONSTANT_FLOAT       18
#define CSCRIPTCOMPILER_OPERATION_CONSTANT_STRING      19
#define CSCRIPTCOMPILER_OPERATION_INTEGER_EXPRESSION   20
#define CSCRIPTCOMPILER_OPERATION_NON_VOID_EXPRESSION  21
#define CSCRIPTCOMPILER_OPERATION_LOGICAL_OR           22
#define CSCRIPTCOMPILER_OPERATION_LOGICAL_AND          23
#define CSCRIPTCOMPILER_OPERATION_INCLUSIVE_OR         24
#define CSCRIPTCOMPILER_OPERATION_EXCLUSIVE_OR         25
#define CSCRIPTCOMPILER_OPERATION_BOOLEAN_AND          26
#define CSCRIPTCOMPILER_OPERATION_CONDITION_EQUAL      27
#define CSCRIPTCOMPILER_OPERATION_CONDITION_NOT_EQUAL  28
#define CSCRIPTCOMPILER_OPERATION_CONDITION_GEQ        29
#define CSCRIPTCOMPILER_OPERATION_CONDITION_GT         30
#define CSCRIPTCOMPILER_OPERATION_CONDITION_LT         31
#define CSCRIPTCOMPILER_OPERATION_CONDITION_LEQ        32
#define CSCRIPTCOMPILER_OPERATION_SHIFT_LEFT           33
#define CSCRIPTCOMPILER_OPERATION_SHIFT_RIGHT          34
#define CSCRIPTCOMPILER_OPERATION_ADD                  35
#define CSCRIPTCOMPILER_OPERATION_SUBTRACT             36
#define CSCRIPTCOMPILER_OPERATION_MULTIPLY             37
#define CSCRIPTCOMPILER_OPERATION_DIVIDE               38
#define CSCRIPTCOMPILER_OPERATION_MODULUS              39
#define CSCRIPTCOMPILER_OPERATION_NEGATION             40
#define CSCRIPTCOMPILER_OPERATION_ACTION_PARAMETER     41
#define CSCRIPTCOMPILER_OPERATION_UNSIGNED_SHIFT_RIGHT 42
#define CSCRIPTCOMPILER_OPERATION_STRUCTURE_PART       43
#define CSCRIPTCOMPILER_OPERATION_ONES_COMPLEMENT      44
#define CSCRIPTCOMPILER_OPERATION_WHILE_BLOCK          45
#define CSCRIPTCOMPILER_OPERATION_WHILE_CHOICE         46
#define CSCRIPTCOMPILER_OPERATION_WHILE_CONDITION      47
#define CSCRIPTCOMPILER_OPERATION_DOWHILE_BLOCK        48
#define CSCRIPTCOMPILER_OPERATION_DOWHILE_CONDITION    49
#define CSCRIPTCOMPILER_OPERATION_FUNCTIONAL_UNIT      50
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_STRUCT       51
#define CSCRIPTCOMPILER_OPERATION_STRUCTURE_DEFINITION 52
#define CSCRIPTCOMPILER_OPERATION_FUNCTION_IDENTIFIER  53
#define CSCRIPTCOMPILER_OPERATION_FUNCTION_DECLARATION 54
#define CSCRIPTCOMPILER_OPERATION_FUNCTION             55
#define CSCRIPTCOMPILER_OPERATION_FUNCTION_PARAM_NAME  56
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_VOID         57
#define CSCRIPTCOMPILER_OPERATION_RETURN               58
#define CSCRIPTCOMPILER_OPERATION_BOOLEAN_NOT          59
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE0 60
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE1 61
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE2 62
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE3 63
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE4 64
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE5 65
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE6 66
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE7 67
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE8 68
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_ENGINE_STRUCTURE9 69
#define CSCRIPTCOMPILER_OPERATION_CONSTANT_OBJECT      70
#define CSCRIPTCOMPILER_OPERATION_KEYWORD_VECTOR       71
#define CSCRIPTCOMPILER_OPERATION_CONSTANT_VECTOR      72
#define CSCRIPTCOMPILER_OPERATION_GLOBAL_VARIABLES     73
#define CSCRIPTCOMPILER_OPERATION_POST_INCREMENT       74
#define CSCRIPTCOMPILER_OPERATION_POST_DECREMENT       75
#define CSCRIPTCOMPILER_OPERATION_PRE_INCREMENT        76
#define CSCRIPTCOMPILER_OPERATION_PRE_DECREMENT        77
#define CSCRIPTCOMPILER_OPERATION_COND_BLOCK           78
#define CSCRIPTCOMPILER_OPERATION_COND_CHOICE          79
#define CSCRIPTCOMPILER_OPERATION_COND_CONDITION       80
#define CSCRIPTCOMPILER_OPERATION_SWITCH_BLOCK         81
#define CSCRIPTCOMPILER_OPERATION_SWITCH_CONDITION     82
#define CSCRIPTCOMPILER_OPERATION_DEFAULT              83
#define CSCRIPTCOMPILER_OPERATION_CASE                 84
#define CSCRIPTCOMPILER_OPERATION_BREAK                85
#define CSCRIPTCOMPILER_OPERATION_CONTINUE             86
#define CSCRIPTCOMPILER_OPERATION_WHILE_CONTINUE       87
#define CSCRIPTCOMPILER_OPERATION_STATEMENT_NO_DEBUG   88
#define CSCRIPTCOMPILER_OPERATION_FOR_BLOCK            89
#define CSCRIPTCOMPILER_OPERATION_CONST_DECLARATION    90
#define CSCRIPTCOMPILER_OPERATION_CONSTANT_JSON        91
#define CSCRIPTCOMPILER_OPERATION_CONSTANT_LOCATION    92

const char *OperationToString(int nOperation);

#define CSCRIPTCOMPILER_IDENT_STATE_START_OF_LINE                     0
#define CSCRIPTCOMPILER_IDENT_STATE_AFTER_TYPE_DECLARATION            1
#define CSCRIPTCOMPILER_IDENT_STATE_AFTER_FUNCTION_IDENTIFIER         2
#define CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST                 3
#define CSCRIPTCOMPILER_IDENT_STATE_BEFORE_CONSTANT_IDENTIFIER        4
#define CSCRIPTCOMPILER_IDENT_STATE_AFTER_CONSTANT_IDENTIFIER         5
#define CSCRIPTCOMPILER_IDENT_STATE_DEFINE_STATEMENT                  6
#define CSCRIPTCOMPILER_IDENT_STATE_DEFINE_NUM_ENGINE_STRUCTURE       7
#define CSCRIPTCOMPILER_IDENT_STATE_DEFINE_SINGLE_ENGINE_STRUCTURE    8
#define CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_PARAMETER               9
#define CSCRIPTCOMPILER_IDENT_STATE_IN_VECTOR_CONSTANT               10
#define CSCRIPTCOMPILER_IDENT_STATE_IN_PARAMETER_LIST_CONSTANT       11

#define CVIRTUALMACHINE_MAX_RECURSION_LEVELS  8
// niv, 17 mar 2017, #28735: now configured in ini
// #define CVIRTUALMACHINE_MAX_INSTRUCT_EXECUTE  131072 //8192
#define CVIRTUALMACHINE_MAX_RUNTIME_VARS      128
#define CVIRTUALMACHINE_MAX_SUBROUTINES       128

#define CVIRTUALMACHINE_BINARY_SCRIPT_HEADER  13 // 9 for the NCS crud, and
// 4 for the size of the file.

// Format of the byte-encoded data.
#define CVIRTUALMACHINE_OPERATION_BASE_SIZE  2
#define CVIRTUALMACHINE_OPCODE_LOCATION      0
#define CVIRTUALMACHINE_AUXCODE_LOCATION     1
#define CVIRTUALMACHINE_EXTRA_DATA_LOCATION  2


#define CVIRTUALMACHINE_OPCODE_ASSIGNMENT            0x01
#define CVIRTUALMACHINE_OPCODE_RUNSTACK_ADD          0x02
#define CVIRTUALMACHINE_OPCODE_RUNSTACK_COPY         0x03
#define CVIRTUALMACHINE_OPCODE_CONSTANT              0x04
#define CVIRTUALMACHINE_OPCODE_EXECUTE_COMMAND       0x05
#define CVIRTUALMACHINE_OPCODE_LOGICAL_AND           0x06
#define CVIRTUALMACHINE_OPCODE_LOGICAL_OR            0x07
#define CVIRTUALMACHINE_OPCODE_INCLUSIVE_OR          0x08
#define CVIRTUALMACHINE_OPCODE_EXCLUSIVE_OR          0x09
#define CVIRTUALMACHINE_OPCODE_BOOLEAN_AND           0x0a
#define CVIRTUALMACHINE_OPCODE_EQUAL                 0x0b
#define CVIRTUALMACHINE_OPCODE_NOT_EQUAL             0x0c
#define CVIRTUALMACHINE_OPCODE_GEQ                   0x0d
#define CVIRTUALMACHINE_OPCODE_GT                    0x0e
#define CVIRTUALMACHINE_OPCODE_LT                    0x0f
#define CVIRTUALMACHINE_OPCODE_LEQ                   0x10
#define CVIRTUALMACHINE_OPCODE_SHIFT_LEFT            0x11
#define CVIRTUALMACHINE_OPCODE_SHIFT_RIGHT           0x12
#define CVIRTUALMACHINE_OPCODE_USHIFT_RIGHT          0x13
#define CVIRTUALMACHINE_OPCODE_ADD                   0x14
#define CVIRTUALMACHINE_OPCODE_SUB                   0x15
#define CVIRTUALMACHINE_OPCODE_MUL                   0x16
#define CVIRTUALMACHINE_OPCODE_DIV                   0x17
#define CVIRTUALMACHINE_OPCODE_MODULUS               0x18
#define CVIRTUALMACHINE_OPCODE_NEGATION              0x19
#define CVIRTUALMACHINE_OPCODE_ONES_COMPLEMENT       0x1a
// New Instructions
#define CVIRTUALMACHINE_OPCODE_MODIFY_STACK_POINTER  0x1b  // move the stack pointer arbitrarily
// to delete useless objects.
#define CVIRTUALMACHINE_OPCODE_STORE_IP              0x1c  // store the instruction pointer for
// use when saving action.
#define CVIRTUALMACHINE_OPCODE_JMP                   0x1d  // jump unconditionally
#define CVIRTUALMACHINE_OPCODE_JSR                   0x1e  // jump to a subroutine
#define CVIRTUALMACHINE_OPCODE_JZ                    0x1f  // jump if top integer on stack is 0
#define CVIRTUALMACHINE_OPCODE_RET                   0x20  // return from a JSR.
#define CVIRTUALMACHINE_OPCODE_DE_STRUCT             0x21  // structure part.
#define CVIRTUALMACHINE_OPCODE_BOOLEAN_NOT           0x22
#define CVIRTUALMACHINE_OPCODE_DECREMENT             0x23
#define CVIRTUALMACHINE_OPCODE_INCREMENT             0x24
#define CVIRTUALMACHINE_OPCODE_JNZ                   0x25
#define CVIRTUALMACHINE_OPCODE_ASSIGNMENT_BASE       0x26
#define CVIRTUALMACHINE_OPCODE_RUNSTACK_COPY_BASE    0x27
#define CVIRTUALMACHINE_OPCODE_DECREMENT_BASE        0x28
#define CVIRTUALMACHINE_OPCODE_INCREMENT_BASE        0x29
#define CVIRTUALMACHINE_OPCODE_SAVE_BASE_POINTER     0x2A
#define CVIRTUALMACHINE_OPCODE_RESTORE_BASE_POINTER  0x2B
#define CVIRTUALMACHINE_OPCODE_STORE_STATE           0x2C  // An extended version of Store_IP, it
// also saves the stack information that
// we need to keep stack sizes down in
// the save games.
#define CVIRTUALMACHINE_OPCODE_NO_OPERATION          0x2D

// For OPCODE_LOOP, determine when to evaluate the operation.
#define CVIRTUALMACHINE_AUXCODE_EVAL_INPLACE       0x70
#define CVIRTUALMACHINE_AUXCODE_EVAL_POSTPLACE     0x71

#define CVIRTUALMACHINE_AUXCODE_TYPE_VOID          0x01
#define CVIRTUALMACHINE_AUXCODE_TYPE_COMMAND       0x02
#define CVIRTUALMACHINE_AUXCODE_TYPE_INTEGER       0x03
#define CVIRTUALMACHINE_AUXCODE_TYPE_FLOAT         0x04
#define CVIRTUALMACHINE_AUXCODE_TYPE_STRING        0x05
#define CVIRTUALMACHINE_AUXCODE_TYPE_OBJECT        0x06
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST0        0x10
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST1        0x11
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST2        0x12 // 8193.35 (CONST): uint32_t 0 = LOCATION_INVALID
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST3        0x13
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST4        0x14
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST5        0x15
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST6        0x16
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST7        0x17 // 8193.35 (CONST): uint16_t size + string
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST8        0x18
#define CVIRTUALMACHINE_AUXCODE_TYPE_ENGST9        0x19

#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_INTEGER  0x20
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_FLOAT_FLOAT      0x21
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_OBJECT_OBJECT    0x22
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_STRING_STRING    0x23
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_STRUCT_STRUCT    0x24
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_INTEGER_FLOAT    0x25
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_FLOAT_INTEGER    0x26
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST0_ENGST0    0x30
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST1_ENGST1    0x31
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST2_ENGST2    0x32
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST3_ENGST3    0x33
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST4_ENGST4    0x34
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST5_ENGST5    0x35
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST6_ENGST6    0x36
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST7_ENGST7    0x37
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST8_ENGST8    0x38
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_ENGST9_ENGST9    0x39
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_VECTOR_VECTOR    0x3a
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_VECTOR_FLOAT     0x3b
#define CVIRTUALMACHINE_AUXCODE_TYPETYPE_FLOAT_VECTOR     0x3c

// stuff for saving out ScriptSituations and Stacks
#define CVIRTUALMACHINE_GFF_CODESIZE                "CodeSize"
#define CVIRTUALMACHINE_GFF_CODE                    "Code"
#define CVIRTUALMACHINE_GFF_INSTRUCTIONPTR          "InstructionPtr"
#define CVIRTUALMACHINE_GFF_SECONDARYPTR            "SecondaryPtr"

#define CVIRTUALMACHINE_GFF_NDBSIZE                 "NDBSize"
#define CVIRTUALMACHINE_GFF_NDB                     "NDB"

#define CVIRTUALMACHINE_GFF_NAME                    "Name"
#define CVIRTUALMACHINE_GFF_SCRIPTCHUNK             "ScriptChunk"
#define CVIRTUALMACHINE_GFF_SCRIPTEVENTID           "ScriptEventID"
#define CVIRTUALMACHINE_GFF_STACKSIZE               "StackSize"
#define CVIRTUALMACHINE_GFF_STACK                   "Stack"

#define CVIRTUALMACHINE_GFF_STACKTYPE               0

#define CVIRTUALMACHINESTACK_BASEPOINTER            "BasePointer"
#define CVIRTUALMACHINESTACK_STACKPOINTER           "StackPointer"
#define CVIRTUALMACHINESTACK_TOTALSIZE              "TotalSize"

#define CVIRTUALMACHINESTACK_STACKLIST              "Stack"
#define CVIRTUALMACHINESTACK_STACKTYPE              "Type"
#define CVIRTUALMACHINESTACK_STACKVALUE             "Value"

#define CVIRTUALMACHINE_GFF_JMPLIST                 "JmpList"
#define CVIRTUALMACHINE_GFF_JMP_LABEL               "Label"
#define CVIRTUALMACHINE_GFF_JMP_VM_INSTPTR          "VMInstPtr"
#define CVIRTUALMACHINE_GFF_JMP_INSTPTR             "InstPtr"
#define CVIRTUALMACHINE_GFF_JMP_STACKPTR            "StackPtr"
#define CVIRTUALMACHINE_GFF_JMP_INSTPTRLEVEL        "InstPtrLevel"
#define CVIRTUALMACHINE_GFF_JMP_FROMJMP             "FromJmp"
#define CVIRTUALMACHINE_GFF_JMP_RETVAL              "RetVal"

#define CVIRTUALMACHINE_MAX_MESSAGE_SIZE     4096

class CScriptParseTreeNode
{

public:
	int32_t   nOperation;
	CExoString *m_psStringData;
	int32_t   nIntegerData;
	int32_t   nIntegerData2;
	int32_t   nIntegerData3;
	int32_t   nIntegerData4;
	float fFloatData;
	float fVectorData[3];
    // json is reusing m_psStringData
	int32_t   m_nFileReference;
	int32_t   nLine;
	int32_t   nChar;
	CScriptParseTreeNode *pLeft;
	CScriptParseTreeNode *pRight;
	int32_t   nType;
	CExoString *m_psTypeName;
	/* int32_t   m_nNodeLocation; ???? */
	int32_t   m_nStackPointer;

	CScriptParseTreeNode() { m_psStringData = NULL; m_psTypeName = NULL; Clean(); }

	void Clean()
	{
		if (m_psStringData != NULL)
		{
			delete m_psStringData;
			m_psStringData = NULL;
		}
		if (m_psTypeName != NULL)
		{
			delete m_psTypeName;
			m_psTypeName = NULL;
		}

		nOperation = 0;
		nIntegerData = 0;
		nIntegerData2 = 0;
		nIntegerData3 = 0;
		nIntegerData4 = 0;
		fFloatData = 0.0f;
		pLeft = NULL ;
		pRight = NULL;
		fVectorData[0] = 0.0f;
		fVectorData[1] = 0.0f;
		fVectorData[2] = 0.0f;
		m_nFileReference = -1;
		nLine = 0;
		nChar = 0;
		nType = 0;
		m_nStackPointer = 0;
	}

	~CScriptParseTreeNode()
	{
		if (m_psStringData != NULL)
		{
			delete m_psStringData;
			m_psStringData = NULL;
		}
		if (m_psTypeName != NULL)
		{
			delete m_psTypeName;
			m_psTypeName = NULL;
		}
	}

    void DebugDump(const char *prefix = "", FILE *out = NULL)
    {
        if (!out) out = stdout;
        fprintf(out, "%s[%p] (pLeft=%p, pRight=%p)\n", prefix, this, pLeft, pRight);
        fprintf(out, "  Operation:         %s\n", OperationToString(nOperation));
        fprintf(out, "  Type:              %s\n", TokenKeywordToString(nType));
        fprintf(out, "  IntegerData:       %d %d %d %d\n", nIntegerData, nIntegerData2, nIntegerData3, nIntegerData4);
        fprintf(out, "  FloatData:         %f %f %f %f\n", fFloatData, fVectorData[0], fVectorData[1], fVectorData[2]);
        fprintf(out, "  StringData:        \"%s\"\n", m_psStringData ? m_psStringData->CStr() : "");
        fprintf(out, "  TypeName:          \"%s\"\n", m_psTypeName ? m_psTypeName->CStr() : "");
        fprintf(out, "  File/Line/Char/SP: %d %d %d %d\n", m_nFileReference, nLine, nChar, m_nStackPointer);
    }
};

#define CSCRIPTCOMPILER_PARSETREENODEBLOCK_SIZE 4096

class CScriptParseTreeNodeBlock
{
public:
	CScriptParseTreeNode m_pNodes[CSCRIPTCOMPILER_PARSETREENODEBLOCK_SIZE];
	CScriptParseTreeNodeBlock *m_pNextBlock;

	CScriptParseTreeNodeBlock()
	{
		m_pNextBlock = NULL;
		CleanBlockEntries();
	}

	void CleanBlockEntries()
	{
		uint32_t nCount;
		for (nCount = 0; nCount < CSCRIPTCOMPILER_PARSETREENODEBLOCK_SIZE; ++nCount)
		{
			m_pNodes[nCount].Clean();
		}
	}
};

class CScriptCompilerStackEntry
{
public:
	int32_t nState;
	int32_t nRule;
	int32_t nTerm;
	CScriptParseTreeNode *pCurrentTree;
	CScriptParseTreeNode *pReturnTree;
};

class CScriptCompilerKeyWordEntry
{
public:
	CScriptCompilerKeyWordEntry()
	{
		m_sAlphanumericName = "";
		m_nHashValue = 0;
		m_nNameLength = 0;
		m_nTokenToTranslate = 0;
	}

	void Add(CExoString sName, int32_t nHashValue, int32_t nTokenToTranslate)
	{
        EXOASSERT(m_nHashValue == 0);
		m_sAlphanumericName = sName;
		m_nHashValue = nHashValue;
		m_nNameLength = sName.GetLength();
		m_nTokenToTranslate = nTokenToTranslate;
	}

	inline CExoString *GetPointerToName() { return &m_sAlphanumericName; }
	inline char *GetAlphanumericName() { return m_sAlphanumericName.CStr(); }
	inline uint32_t GetHash() { return m_nHashValue; }
	inline uint32_t GetLength() { return m_nNameLength; }
	inline int32_t   GetTokenToTranslate() { return m_nTokenToTranslate; }

private:
	CExoString m_sAlphanumericName;
	uint32_t      m_nHashValue;
	uint32_t      m_nNameLength;
	int32_t        m_nTokenToTranslate;
};

#define CSCRIPTCOMPILER_HASH_MANAGER_TYPE_UNKNOWN           0
#define CSCRIPTCOMPILER_HASH_MANAGER_TYPE_IDENTIFIER        1
#define CSCRIPTCOMPILER_HASH_MANAGER_TYPE_KEYWORD           2
#define CSCRIPTCOMPILER_HASH_MANAGER_TYPE_ENGINE_STRUCTURE  3

class CScriptCompilerIdentifierHashTableEntry
{
public:
	CScriptCompilerIdentifierHashTableEntry()
	{
		m_nHashValue = 0;
		m_nIdentifierType = CSCRIPTCOMPILER_HASH_MANAGER_TYPE_UNKNOWN;
		m_nIdentifierIndex = 0;
	}

	uint32_t  m_nHashValue;
	uint32_t  m_nIdentifierType;
	uint32_t  m_nIdentifierIndex;
};

class CScriptCompilerIdListEntry
{
public:
	CExoString m_psIdentifier;
	uint32_t m_nIdentifierLength;
	uint32_t m_nIdentifierHash;
	int32_t   m_nIdentifierType;
	int32_t   m_nReturnType;
	int32_t   m_bImplementationInPlace;
	CExoString m_psStructureReturnName;
	//INT   m_nIdentifierOrder;

	// For constants ...
	CExoString m_psStringData;
	int32_t   m_nIntegerData;
	float m_fFloatData;
	float m_fVectorData[3];

	// For identifiers ..
	int32_t   m_nIdIdentifier;
	int32_t   m_nParameters;
	int32_t   m_nNonOptionalParameters;

	int32_t   m_nParameterSpace;

	// For each parameter ...
	char       *m_pchParameters;
	CExoString *m_psStructureParameterNames;
	// For the optional part of each parameter ...
	BOOL       *m_pbOptionalParameters;
	int32_t        *m_pnOptionalParameterIntegerData;
	float      *m_pfOptionalParameterFloatData;
	CExoString *m_psOptionalParameterStringData;
	OBJECT_ID  *m_poidOptionalParameterObjectData;
	float      *m_pfOptionalParameterVectorData;
    // json is reusing string data

	// For user-defined identifiers
	int32_t   m_nBinarySourceStart;
	int32_t   m_nBinarySourceFinish;
	int32_t   m_nBinaryDestinationStart;
	int32_t   m_nBinaryDestinationFinish;

	CScriptCompilerIdListEntry();
	~CScriptCompilerIdListEntry();
	int32_t ExpandParameterSpace();
};

class CScriptCompilerVarStackEntry
{
public:
	CExoString m_psVarName;
	int32_t        m_nVarType;
	int32_t        m_nVarLevel;
	int32_t        m_nVarRunTimeLocation;
	CExoString m_sVarStructureName;

	CScriptCompilerVarStackEntry()
	{
		m_nVarType = 0;
		m_nVarLevel = 0;
		m_nVarRunTimeLocation = 0;
	}

};

class CScriptCompilerStructureEntry
{
public:
	CExoString m_psName;
	int32_t        m_nFieldStart;
	int32_t        m_nFieldEnd;
	int32_t        m_nByteSize;

	CScriptCompilerStructureEntry()
	{
		m_nFieldStart = 0;
		m_nFieldEnd = 0;
		m_nByteSize = 0;
	}
};

class CScriptCompilerStructureFieldEntry
{
public:
	uint8_t       m_pchType;
	CExoString m_psStructureName;
	CExoString m_psVarName;
	int32_t        m_nLocation;

	CScriptCompilerStructureFieldEntry()
	{
		m_pchType = 0;
		m_nLocation = 0;
	}

};

#define CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_UNKNOWN        0
#define CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_ENTRY 1
#define CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_FUNCTION_EXIT  2
#define CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_BREAK          3
#define CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_CONTINUE       4
#define CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_SWITCH_CASE    5
#define CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_SWITCH_DEFAULT 6

class CScriptCompilerSymbolTableEntry
{
public:
	uint32_t      m_nSymbolType;
	uint32_t      m_nSymbolSubType1;
	uint32_t      m_nSymbolSubType2;
	int32_t        m_nLocationPointer;
	int32_t        m_nNextEntryPointer;

	CScriptCompilerSymbolTableEntry()
	{
		m_nSymbolType = CSCRIPTCOMPILER_SYMBOL_TABLE_ENTRY_TYPE_UNKNOWN;
		m_nSymbolSubType1 = 0;
		m_nSymbolSubType2 = 0;
		m_nLocationPointer = 0;
		m_nNextEntryPointer = -1;
	}
};



#endif // __SCRIPTINTERNAL_H__
