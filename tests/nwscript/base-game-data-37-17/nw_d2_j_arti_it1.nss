#include "NW_I0_Plot"
#include "NW_J_ARTIFACT"

int StartingConditional()
{
    if (PlayerHasArtifactItem(GetPCSpeaker()))
    {
        return CheckIntelligenceNormal();
    }
    return FALSE;
}
