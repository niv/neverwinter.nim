//::///////////////////////////////////////////////
//:: Dirge: Heartbeat
//:: x0_s0_dirgeHB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{



    object oTarget;
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
     DoDirgeEffect(oTarget);
        //Get next target.
    oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}


