//::///////////////////////////////////////////////
//:: XP2 Wandering Monster Ambush
//:: x2_restsys_ambus
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This file executes an ambush on the resting
    player.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-29
//:://////////////////////////////////////////////
#include "x2_inc_restsys"
void main()
{
    object oPC = OBJECT_SELF; //This execute script is run on the PC
    // will be random
    struct wm_struct stWMInfo;
    //retrieve the area encounter table from the 2da
    stWMInfo = WMGetAreaMonsterTable(GetArea(oPC));
    float fDelay;

    /*
        // Removed from official campaign but left in for the community to
        // play around with. If uncommented the game will give the character
        // an advance warning about approaching monsters

        if (WMDoListenCheck(oPC)) // Character made listen check
        {
            // Finish Resting (canceled)
            WMFinishPlayerRest(oPC, TRUE);
            DelayCommand(1.0f,FloatingTextStrRefOnCreature(stWMInfo.nFeedBackStrRefSuccess,oPC));
            DelayCommand(1.1f,ClearAllActions());
            fDelay = RoundsToSeconds(1);  // Give two rounds notice
            DelayCommand(fDelay+1.0f,  WMRunAmbush(oPC));
        }


    else // Character Failed Listen Check    */
    {
        //fDelay = IntToFloat(Random(4)+1); // see above
        DelayCommand(fDelay+1.4f,ClearAllActions());
        DelayCommand(fDelay+1.5f,        WMRunAmbush(oPC));
        DelayCommand(fDelay+3.5,FloatingTextStrRefOnCreature(stWMInfo.nFeedBackStrRefFail,oPC));
        // DelayCommand(fDelay+1.0f,  WMFinishPlayerRest(oPC, TRUE)); // see above
       }




}
