#include "nw_i0_plot"

int StartingConditional()
{
    if (GetPLocalInt(GetPCSpeaker(),"NW_Assa_Plot_Accepted") == 1)
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}

