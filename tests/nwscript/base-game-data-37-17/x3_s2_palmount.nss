//::///////////////////////////////////////////////
//:: Post Mount Script for a Paladin Mount
//:: x3_s2_palmount
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script is fired by the rider after successfully mounting
     a summoned paladin mount.  It's primary duty is to make sure monitoring
     for paladin mount unsummoning still occurs while the mount is mounted.

     X3_EXTEND_PALMOUNT = string variable that if set on the module object
     will allow a person to extend this paladin mount script to call other
     scripts in a daisy chain type situation such as saddle bag handling ones.

*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: 2008-01-01
//:: Last Update: March 29th, 2008
//:://////////////////////////////////////////////

#include "x3_inc_horse"

void main()
{
    object oRider=OBJECT_SELF;
    string sScript=GetLocalString(GetModule(),"X3_EXTEND_PALMOUNT");
    SetLocalObject(oRider,"oX3_PALADIN_MOUNT",oRider);
    HORSE_SupportIncreaseSpeed(oRider,OBJECT_INVALID);
    HORSE_SupportAdjustMountedArcheryPenalty(oRider);
    DelayCommand(0.5,HORSE_SupportApplyMountedSkillDecreases(oRider));
    SetLocalInt(oRider,"bX3_HORSE_MODIFIERS",TRUE);
    HORSE_SupportMonitorPaladinUnsummon(oRider);
    if (GetStringLength(sScript)>0) ExecuteScript(sScript,oRider);
}
