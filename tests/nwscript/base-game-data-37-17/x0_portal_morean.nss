//::///////////////////////////////////////////////
//:: x0_portal_morean
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if there are more anchors to be
    placed.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_portal"

int StartingConditional()
{
    int nAllAnchorsExist = PortalAllAnchorExists(GetPCSpeaker());
    int nRelicExists = FALSE;
    if (GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), "x2_p_reaper")))
        nRelicExists = TRUE;
    if(!nAllAnchorsExist && nRelicExists)
    {
            return TRUE;
    }

    return FALSE;
}
