//::///////////////////////////////////////////////
//:: Horse Text Appears When Saddlebags enabled
//:: x3_ct_saddlebags
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script handles making saddlebags accessible.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: Feb 2nd, 2008
//:: Last Update: Feb 2nd, 2008
//:://////////////////////////////////////////////

#include "x3_inc_horse"

int StartingConditional()
{
    object oHorse=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS")&&GetLocalInt(oHorse,"bX3_HAS_SADDLEBAGS"))
    { // open saddle bags
        DelayCommand(0.1,OpenInventory(oHorse,oPC));
    } // open saddle bags
    return FALSE;
}
