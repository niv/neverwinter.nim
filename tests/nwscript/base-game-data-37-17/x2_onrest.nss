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

#include "x0_i0_henchman"
#include "x2_inc_restsys"
#include "x2_inc_banter"


// * returns true if its time to say another romance line
int GetPlotProgress();

void main()
{
    object oPC = GetLastPCRested();
    /*  Georg, August 11, 2003
        Added this code to allow the designer to specify a variable on the module
        Instead of using a OnAreaEnter script. Nice new toolset feature!

        Basically, the first time a player rests, the area is scanned for the
        encounter table string and will set it up.
    */
    object oArea = GetArea (oPC);

    // Do not allow to rest during the seige
    if(GetLocalInt(GetModule(), "X2_StartSeerSiegeSpeech") == 2)
    {
        FloatingTextStrRefOnCreature(84142  ,oPC);
        AssignCommand(oPC, ClearAllActions());
        return;
    }


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
     // * Brent October 15
        // * In Chapter 2, your henchmen will progress the romance dialog

            if (GetPlotProgress() == TRUE && GetTag(GetModule()) == "x0_module2")
            {
                AttemptRomanceDialog(oPC, 3); // * can only go up to 4th stage this way
            }

    }

}


