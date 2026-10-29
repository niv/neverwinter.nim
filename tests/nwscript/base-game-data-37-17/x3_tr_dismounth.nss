//::///////////////////////////////////////////////
//:: Dismount and Hitch Trigger OnEnter
//:: x3_tr_dismounth
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
    location lLoc=GetLocation(oCreature);
    object oHitch=GetNearestObjectByTag("X3_HITCHING_POST",oCreature);
    int bAnim=!GetLocalInt(OBJECT_SELF,"bDismountFast"); // animated dismount on this trigger by default (ie. variable not set)
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oCreature),"fX3_MOUNT_MULTIPLE");
    float fX3_DISMOUNT_MULTIPLE=GetLocalFloat(GetArea(oCreature),"fX3_DISMOUNT_MULTIPLE");
    if (GetLocalFloat(oCreature,"fX3_MOUNT_MULTIPLE")>fX3_MOUNT_MULTIPLE) fX3_MOUNT_MULTIPLE=GetLocalFloat(oCreature,"fX3_MOUNT_MULTIPLE");
    if (fX3_MOUNT_MULTIPLE<=0.0) fX3_MOUNT_MULTIPLE=1.0;
    if (GetLocalFloat(oCreature,"fX3_DISMOUNT_MULTIPLE")>0.0) fX3_DISMOUNT_MULTIPLE=GetLocalFloat(oCreature,"fX3_DISMOUNT_MULTIPLE");
    if (fX3_DISMOUNT_MULTIPLE>0.0) fX3_MOUNT_MULTIPLE=fX3_DISMOUNT_MULTIPLE; // use dismount multiple instead of mount multiple
    float fDelay=2.0*fX3_MOUNT_MULTIPLE; // non-animated dismount lasts 1.0+1.0=2.0 by default, so wait at least that!
    if (bAnim) fDelay+=2.8*fX3_MOUNT_MULTIPLE; // animated dismount lasts (X3_ACTION_DELAY+HORSE_DISMOUNT_DURATION+1.0)*fX3_MOUNT_MULTIPLE=4.8 by default, so wait at least that!
    if (HorseGetIsMounted(oCreature)&&!HorseGetIsAMount(oCreature))
    { // is mounted
        AssignCommand(oCreature,ClearAllActions(TRUE));
        AssignCommand(oCreature,HORSE_SupportDismountWrapper(bAnim,TRUE));
        DelayCommand(fDelay,HorseHitchHorses(oHitch,oCreature,lLoc));
    } // is mounted
    else if (HorseGetIsAMount(oCreature))
    { // hitch
        DelayCommand(fDelay,HorseHitchHorses(oHitch,GetMaster(oCreature),lLoc));
    } // hitch
}
