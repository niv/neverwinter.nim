//:://////////////////////////////////////////////////
//:: X0_D2_DEEK_HATE
//:://////////////////////////////////////////////////
/*
Returns TRUE if the speaker is the henchman's current
master.
 */

#include "x0_i0_henchman"

int StartingConditional()
{
    int nLike = GetCampaignInt("Deekin", "Deekin_Like_PC", GetPCSpeaker());
    if (nLike < -4)
    {
        return GetWorkingForPlayer(GetPCSpeaker());
    }
    return FALSE;
}
