//::///////////////////////////////////////////////
//:: Name: x2_onrest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The generic wandering monster system
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: June 9/03
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified Date: January 28th, 2008
//:://////////////////////////////////////////////

#include "x2_inc_restsys"
#include "x2_inc_switches"
#include "x3_inc_horse"

void main()
{
    object oPC = GetLastPCRested();
    object oMount;

    if (!GetLocalInt(GetModule(),"X3_MOUNT_NO_REST_DISMOUNT"))
    { // make sure not mounted
        /*  Deva, Jan 17, 2008
            Do not allow a mounted PC to rest
        */
        if (HorseGetIsMounted(oPC))
        { // cannot mount
            if (GetLocalInt(oPC,"X3_REST_CANCEL_MESSAGE_SENT"))
            { // cancel message already played
                DeleteLocalInt(oPC,"X3_REST_CANCEL_MESSAGE_SENT");
            } // cancel message already played
            else
            { // play cancel message
                FloatingTextStrRefOnCreature(112006,oPC,FALSE);
                SetLocalInt(oPC,"X3_REST_CANCEL_MESSAGE_SENT",TRUE); // sentinel
                // value to prevent message played a 2nd time on canceled rest
            } // play cancel message
            AssignCommand(oPC,ClearAllActions(TRUE));
            return;
        } // cannot mount
    } // make sure not mounted

    if (!GetLocalInt(GetModule(),"X3_MOUNT_NO_REST_DESPAWN"))
    { // if there is a paladin mount despawn it
        oMount=HorseGetPaladinMount(oPC);
        if (!GetIsObjectValid(oMount)) oMount=GetLocalObject(oPC,"oX3PaladinMount");
        if (GetIsObjectValid(oMount))
        { // paladin mount exists
            if (oMount==oPC||!GetIsObjectValid(GetMaster(oMount))) AssignCommand(oPC,HorseUnsummonPaladinMount());
            else { AssignCommand(GetMaster(oMount),HorseUnsummonPaladinMount()); }
        } // paladin mount exists
    } // if there is a paladin mount despawn it

    if (GetModuleSwitchValue(MODULE_SWITCH_USE_XP2_RESTSYSTEM) == TRUE)
    {
        /*  Georg, August 11, 2003
            Added this code to allow the designer to specify a variable on the module
            Instead of using a OnAreaEnter script. Nice new toolset feature!
            Basically, the first time a player rests, the area is scanned for the
            encounter table string and will set it up.
        */
        object oArea = GetArea (oPC);

        string sTable = GetLocalString(oArea,"X2_WM_ENCOUNTERTABLE") ;
        if (sTable != "" )
        {
            int nDoors = GetLocalInt(oArea,"X2_WM_AREA_USEDOORS");
            int nDC = GetLocalInt(oArea,"X2_WM_AREA_LISTENCHECK");
            WMSetAreaTable(oArea,sTable,nDoors,nDC);

            //remove string to indicate we are set up
            DeleteLocalString(oArea,"X2_WM_ENCOUNTERTABLE");
        }


        /* Brent, July 2 2003
           - If you rest and are a low level character at the beginning of the module.
             You will trigger the first dream cutscene
        */
        if (GetLocalInt(GetModule(), "X2_G_LOWLEVELSTART") == 10)
        {
            AssignCommand(oPC, ClearAllActions());
            if (GetHitDice(oPC) >= 12)
            {
                ExecuteScript("bk_sleep", oPC);
                return;
            }
            else
            {
                FloatingTextStrRefOnCreature(84141 , oPC);
                return;
            }
        }

        if (GetLastRestEventType()==REST_EVENTTYPE_REST_STARTED)
        {
            if (!WMStartPlayerRest(oPC))
            {
                // The resting system has objections against resting here and now
                // Probably because there is an ambush already in progress
                FloatingTextStrRefOnCreature(84142  ,oPC);
                AssignCommand(oPC,ClearAllActions());
            }
            if (WMCheckForWanderingMonster(oPC))
            {
                //This script MUST be run or the player won't be able to rest again ...
                ExecuteScript("x2_restsys_ambus",oPC);
            }
        }
        else if (GetLastRestEventType()==REST_EVENTTYPE_REST_CANCELLED)
        {
         // No longer used but left in for the community
         // WMFinishPlayerRest(oPC,TRUE); // removes sleep effect, etc
        }
        else if (GetLastRestEventType()==REST_EVENTTYPE_REST_FINISHED)
        {
         // No longer used but left in for the community
         //   WMFinishPlayerRest(oPC); // removes sleep effect, etc
        }
    }
}

