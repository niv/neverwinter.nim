#include "nw_i0_plot"

int StartingConditional()
{
    int iResult;

    iResult = GetPLocalInt(GetPCSpeaker(),"NW_COMPLEXPLOT"+GetTag(OBJECT_SELF)) ==100;
    return iResult;
}
