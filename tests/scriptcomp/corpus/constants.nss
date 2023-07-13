const int INT_LITERAL = 42;
const int INT_HEX_LITERAL = 0x42;
const int INT_NEGATIVE_LITERAL = -42;

const float FLOAT_LITERAL_FULL = 42.42f;
const float FLOAT_LITERAL_NO_SUFFIX = 42.42;
const float FLOAT_LITERAL_ENDS_WITH_DOT = 42.;
const float FLOAT_LITERAL_ENDS_WITH_DOT_SUFFIX = 42.f;
const float FLOAT_LITERAL_STARTS_WITH_DOT = .42;
const float FLOAT_LITERAL_STARTS_WITH_DOT_SUFFIX = .42f;
const float FLOAT_LITERAL_NO_DOT_SUFFIX = 42f;

const string STRING_LITERAL = "nwn";
const string STRING_LITERAL_EMPTY = "";
const string STRING_LITERAL_ESCAPE_NEWLINE = "\n";
const string STRING_LITERAL_ESCAPE_QUOTE = "\"";
const string STRING_LITERAL_ESCAPE_HEX = "\x07";

// Constant folding
const int A = 10;
const int B = A + A;

const int CONSTINT_LOGICAL_OR          = A || B;
const int CONSTINT_LOGICAL_AND         = A && B;
const int CONSTINT_INCLUSIVE_OR        = A |  B;
const int CONSTINT_EXCLUSIVE_OR        = A ^  B;
const int CONSTINT_BOOLEAN_AND         = A &  B;
const int CONSTINT_CONDITION_EQUAL     = A == B;
const int CONSTINT_CONDITION_NOT_EQUAL = A != B;
const int CONSTINT_CONDITION_GEQ       = A >= B;
const int CONSTINT_CONDITION_GT        = A >  B;
const int CONSTINT_CONDITION_LT        = A <  B;
const int CONSTINT_CONDITION_LEQ       = A <= B;
const int CONSTINT_SHIFT_LEFT          = A << B;
const int CONSTINT_SHIFT_RIGHT         = A >> B;
const int CONSTINT_ADD                 = A +  B;
const int CONSTINT_SUBTRACT            = A -  B;
const int CONSTINT_MULTIPLY            = A *  B;
const int CONSTINT_DIVIDE              = A /  B;
const int CONSTINT_MODULUS             = A %  B;

const float X = 10.0f;
const float Y = X + X;

const float CONSTFLOAT_ADD                 = X +  Y;
const float CONSTFLOAT_SUBTRACT            = X -  Y;
const float CONSTFLOAT_MULTIPLY            = X *  Y;
const float CONSTFLOAT_DIVIDE              = X /  Y;
const int   CONSTFLOAT_CONDITION_EQUAL     = X == Y;
const int   CONSTFLOAT_CONDITION_NOT_EQUAL = X != Y;
const int   CONSTFLOAT_CONDITION_GEQ       = X >= Y;
const int   CONSTFLOAT_CONDITION_GT        = X >  Y;
const int   CONSTFLOAT_CONDITION_LT        = X <  Y;
const int   CONSTFLOAT_CONDITION_LEQ       = X <= Y;

const string S1 = "AAA";
const string S2 = "BBB";
const string S3 = S1 + "_" + S2;

const int CONSTSTR_CONDITION_EQUAL     = S1 == S2;
const int CONSTSTR_CONDITION_NOT_EQUAL = S1 != S2;

void main() {}
