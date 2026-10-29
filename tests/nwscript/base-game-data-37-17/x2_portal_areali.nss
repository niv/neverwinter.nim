//::///////////////////////////////////////////////
//:: x2_portal_areali
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Sets the custom tokens that the XP2 portal
 stone uses, so that the list of areas is
 displayed in conversation.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_portal"

void main()
{
    int i = 0;

    for (i = 0; i <= 5; i++)
    {
        if (PortalAnchorExists(i, GetPCSpeaker()) == TRUE)
        {
            object oPortal = PortalGetAnchor(i, GetPCSpeaker());
            if (GetIsObjectValid(oPortal) == TRUE)
            {
                SetCustomToken(1000 + i, GetName(GetArea(oPortal)));
            }
        }
    }
}
