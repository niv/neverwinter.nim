#include "nw_i0_plot"
#include "NW_J_ASSASSIN"

int StartingConditional()
{
    if (PCAcceptedPlot(GetPCSpeaker()) == TRUE)
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}
