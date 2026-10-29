#include "nw_j_fetch"

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(Global(), "NW_J_FETCHPLOT") >=30;

    return iResult;
}
