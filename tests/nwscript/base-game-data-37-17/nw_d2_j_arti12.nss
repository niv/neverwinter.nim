#include "NW_I0_PLOT"
#include "NW_J_ARTIFACT"

int StartingConditional()
{
    if (!PlayerHasArtifactItem(GetPCSpeaker()))
    {
        return CheckIntelligenceLow();
    }
    return FALSE;
}
