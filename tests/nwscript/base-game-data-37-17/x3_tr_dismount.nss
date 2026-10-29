//::///////////////////////////////////////////////
//:: Dismount Trigger OnEnter
//:: x3_tr_dismount
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script dismounts mounted objects entering it.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: Jan 28th, 2008
//:: Last Update: Apr 12th, 2008
//:://////////////////////////////////////////////


#include "x3_inc_horse"


void main()
{
    object oCreature=GetEnteringObject();
    int bAnim=!GetLocalInt(OBJECT_SELF,"bDismountFast");
    if (HorseGetIsMounted(oCreature)&&!HorseGetIsAMount(oCreature))
    { // is mounted
        AssignCommand(oCreature,ClearAllActions(TRUE));
        AssignCommand(oCreature,HORSE_SupportDismountWrapper(bAnim,TRUE));
    } // is mounted
}
