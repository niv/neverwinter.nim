#include "NW_I0_PLOT"

int StartingConditional()
{
    int iPlot = GetPLocalInt(GetPCSpeaker(),"NW_ARTI_PLOT_TOLD" + GetTag(OBJECT_SELF));
    if ((iPlot == 0) && (GetLocalInt(GetModule(),"NW_G_ARTI_PLOT" + GetTag(OBJECT_SELF)) == 0))
    {
        return CheckCharismaHigh();
    }
    return FALSE;
}
