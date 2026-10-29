#include "NW_I0_Plot"
#include "NW_J_ARTIFACT"

int StartingConditional()
{
    object oArtifact = GetItemPossessedBy(GetPCSpeaker(),"ARTI_ITEM01");
    if (PlayerHasArtifactItem(GetPCSpeaker()))
    {
        return CheckIntelligenceLow();
    }
    return FALSE;
}
