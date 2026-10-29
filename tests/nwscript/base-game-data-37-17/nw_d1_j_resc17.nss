#include "nw_i0_plot"

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"NW_Resc_Plot") < 100 &&
              GetPLocalInt(GetPCSpeaker(),"NW_Resc_PlotExplained") == 1;
    return iResult;
}

