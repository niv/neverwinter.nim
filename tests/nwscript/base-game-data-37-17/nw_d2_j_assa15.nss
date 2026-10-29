#include "nw_i0_plot"
#include "NW_J_ASSASSIN"

//* low IQ, plot accepted
int StartingConditional()
{
    if (PCAcceptedPlot(GetPCSpeaker()) == FALSE)
    {
        return CheckIntelligenceLow();
    }
    return FALSE;
}
