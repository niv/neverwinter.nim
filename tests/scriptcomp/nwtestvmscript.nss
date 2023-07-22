// Dummy VM implementation used for test runner.

// NB: When changing this file, also adjust tlangspec.nim to match.

#define ENGINE_NUM_STRUCTURES   0
// #define ENGINE_STRUCTURE_0      effect

int    TRUE                     = 1;
int    FALSE                    = 0;

string sLanguage = "nwscript";

void Assert(int bCond, string sMsg = "");

string IntToString(int nValue);

int Random(int nMax);

// These do nothing with the args.
void TakeInt(int nInt);
void TakeClosure(action aClosure);
