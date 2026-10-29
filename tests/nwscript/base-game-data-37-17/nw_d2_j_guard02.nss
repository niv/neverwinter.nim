#include "nw_i0_plot"

int StartingConditional()
{
    int iResult;

    iResult = GetPLocalInt(GetPCSpeaker(), "NW_L_ENTRANCEGRANTED"+GetTag(OBJECT_SELF)) ==1;
    return iResult;
}
