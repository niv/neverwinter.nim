//::///////////////////////////////////////////////
//:: x0_s3_chokehb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Heartbeat script for choking powder.
    Every round make a saving throw
    or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void main()
{
    //Get the first object in the persistant AOE
    object oTarget;
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        spellsStinkingCloud(oTarget);
        //Get the next target in the AOE
        oTarget = GetNextInPersistentObject();
    }
}
