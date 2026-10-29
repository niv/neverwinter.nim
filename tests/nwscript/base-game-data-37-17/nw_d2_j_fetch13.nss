#include "NW_J_FETCH"

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(Global(), "NW_J_FETCHPLOT") >= 50 &&
              GetLocalObject(Global(), "NW_J_FETCHPLOT_PC") == GetPCSpeaker();

    return iResult;
}
