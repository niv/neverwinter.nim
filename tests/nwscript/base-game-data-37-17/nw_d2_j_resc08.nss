#include "nw_i0_plot"
#include "NW_J_RESCUE"

int StartingConditional()
{
    if (GetLocalInt(Global(),"NW_Resc_Plot") == 0)
    {
        return CheckIntelligenceLow();
    }
    return FALSE;
}
