#include "NW_I0_PLOT"

int StartingConditional()
{
    int iAdvance = GetLocalInt(OBJECT_SELF,"NW_ARTI_PLOT_ADVANCE");
    if (iAdvance == 0)
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}
