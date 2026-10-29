#include "nw_i0_plot"

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF,"NW_ASSA_DOUBLE_CROSS") == 1 &&
              GetPLocalInt(GetPCSpeaker(),"NW_ASSA_DOUBLE_CROSS") !=1;
    return iResult;
}
