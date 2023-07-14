#define ENGINE_NUM_STRUCTURES   8
#define ENGINE_STRUCTURE_0      effect
#define ENGINE_STRUCTURE_1      event
#define ENGINE_STRUCTURE_2      location
#define ENGINE_STRUCTURE_3      talent
#define ENGINE_STRUCTURE_4      itemproperty
#define ENGINE_STRUCTURE_5      sqlquery
#define ENGINE_STRUCTURE_6      cassowary
#define ENGINE_STRUCTURE_7      json

// Constants

int    TRUE                     = 1;
int    FALSE                    = 0;

string sLanguage = "nwscript";

void Assert(int bCond, string sMsg = "");

string IntToString(int nValue);

int Random(int nMax);

// These do nothing with the args.
void TakeInt(int nInt);
void TakeClosure(action aClosure);
