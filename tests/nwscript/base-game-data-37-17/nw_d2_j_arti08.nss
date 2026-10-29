#include "nw_i0_plot"

int StartingConditional()
{
    int iResult;

    iResult = GetPLocalInt(GetPCSpeaker(),"NW_ARTI_PLOT_TALKEDTO"+GetTag(OBJECT_SELF)) ==0
           && GetLocalInt(GetModule(),"NW_G_ARTI_PLOT" + GetTag(OBJECT_SELF)) == 1;

    return iResult;
}

