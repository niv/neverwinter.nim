#include "nw_i0_plot"

int StartingConditional()
{
    int iResult;

    iResult =  GetPLocalInt(GetPCSpeaker(),"NW_STORY"+GetTag(OBJECT_SELF)) >= 20;
    return iResult;
}

