#include "NW_J_ASSASSIN"
#include "nw_i0_plot"

int StartingConditional()
{
    int iJob1 = GetLocalInt(OBJECT_SELF,"NW_ASSA_DOUBLE_CROSS");
    if (iJob1 == 1)
    {
        int iJob2 = GetPLocalInt(GetPCSpeaker(),"NW_ASSA_DOUBLE_CROSS");
        if ((PlotGiverDead() == TRUE) && (iJob2 != 1))
        {
            return TRUE;
        }
    }
    return FALSE;
}

