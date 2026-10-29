#include "NW_J_FETCH"

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(Global(), "NW_J_FETCHPLOT") ==99;

    return iResult;
}

