#include "nw_i0_plot"
#include "NW_J_RESCUE"

int StartingConditional()
{
    object oResc = GetPrisoner();
    if (!GetIsObjectValid(oResc))
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}
