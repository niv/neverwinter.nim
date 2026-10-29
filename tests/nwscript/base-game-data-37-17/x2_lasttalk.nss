//::///////////////////////////////////////////////
//:: x2_lasttalk
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the last trigger where
    henchmen will talk to you, right
    before the return to Waterdeep.
    
    if Valen Romance [Valen romance > . Valen still henchman]
     or
    if Aribeth Romance
     or
    If Nat Romance
    else
     Random
    
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: October 30, 2003
//:://////////////////////////////////////////////
#include "x2_inc_banter"


// * This function returns the correct henchman
object PickHenchman(object oMaster)
{
    object oHench = OBJECT_INVALID;
    // * Get and check variables
    int nValenRomanceValue = GetLocalInt(GetModule(), "iValenRomance");
    int nAribethRomanceValue = GetLocalInt(GetModule(), "iAribethRomance");
    int nNathyrraRomanceValue = GetLocalInt(GetModule(), "iNathyrraRomance");
    int bInLoveWithValen = FALSE;
    int bInLoveWithAribeth = FALSE;
    int bInLoveWithNathyrra = FALSE;
    
    if (nValenRomanceValue > 0)
    {
        bInLoveWithValen = TRUE;
    }
    else
    if (nAribethRomanceValue > 0)
    {
        bInLoveWithAribeth = TRUE;
    }
    else
    if (nNathyrraRomanceValue > 0)
    {
        bInLoveWithNathyrra = TRUE;
    }
    
    // * Valen, then Aribeth, then Nath
    if (bInLoveWithValen == TRUE)
    {
        object oValen = GetObjectByTag("x2_hen_valen");
        if (GetIsObjectValid(oValen) && GetMaster(oValen) == oMaster)
        {
            oHench = oValen;
        }
    }
    else
    if (bInLoveWithAribeth == TRUE)
    {
        object oAribeth = GetObjectByTag("H2_Aribeth");
        if (GetIsObjectValid(oAribeth) && GetMaster(oAribeth) == oMaster)
        {
            oHench = oAribeth;
        }
    }
    else
    if (bInLoveWithNathyrra == TRUE)
    {
        object oNathyrra = GetObjectByTag("x2_hen_nathyra");
        if (GetIsObjectValid(oNathyrra) && GetMaster(oNathyrra) == oMaster)
        {
            oHench = oNathyrra;
        }
    }
    // * choose a random hench to speak
    else
    {
        oHench = GetRandomHench(oMaster, "x2_inter_nr");
    }
    return oHench;
}

void main()
{   // SpawnScriptDebugger();
    // * at end of this script, this is the henchman to talk to
    object oHench;
    object oMaster = GetEnteringObject();
    if (GetIsPC(oMaster) == FALSE)
        return;

    if (GetIsObjectValid(GetObjectByTag("x2_homedoor")) == TRUE)
    {
        DestroyObject(OBJECT_SELF, 1.0);
    }
    else
    {
        return; // * the door to Waterdeep has not been created yet. Not time to speak
    }
    SetCutsceneMode(oMaster, TRUE);
    
    oHench = PickHenchman(oMaster);

    // *
    // * Perform actual speaking
    // *
    if (GetIsObjectValid(oHench) == TRUE)
    {
         // * End of finding henchman
        string sConvFile = GetDialogFileToUse(oMaster, oHench);
        AssignCommand(oMaster, ClearAllActions());
        AssignCommand(oHench, ClearAllActions());
        AssignCommand(oHench, SetHasInterjection(oMaster, TRUE, 16));
        AssignCommand(oHench, ActionStartConversation(oMaster, sConvFile));


//        WrapInterjection(TRIGGER_INTERJECTION_NONRANDOM, 16, oMaster, oHench, "x2_inter_nr", FALSE, sConvFile);
    }
    AssignCommand(oMaster, DelayCommand(0.3, SetCutsceneMode(oMaster, FALSE)));
}
