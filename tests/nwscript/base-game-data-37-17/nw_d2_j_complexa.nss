#include "NW_I0_PLOT"

int StartingConditional()
{
    int iResult;

    iResult = GetPLocalInt(GetPCSpeaker(),"NW_COMPLEXPLOT"+GetTag(OBJECT_SELF)) <=10
                && CheckCharismaLow();
    return iResult;
}
