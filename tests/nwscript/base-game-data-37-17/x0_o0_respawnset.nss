//:://////////////////////////////////////////////////
//:: X0_O0_RESPAWNSET
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
  Set the respawn point for the caller. If a PC, set it
  on his/her henchman too.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 10/09/2002
//:://////////////////////////////////////////////////

#include "x0_i0_common"

void main()
{
    SetRespawnLocation();
    if (GetIsPC(OBJECT_SELF)) {
        object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN);
        if (GetIsObjectValid(oHench)) {
            SetRespawnLocation(oHench);
        }
    }
}
