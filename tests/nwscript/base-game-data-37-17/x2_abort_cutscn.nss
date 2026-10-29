//::///////////////////////////////////////////////
//:: Name x2_abort_cutscn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cutscene aborted script.
    Check to see which cutscene has been aborted by
    the player and run the appropriate script to
    remove the player from the cutscene (The name of the script should be "cutabortX"
    where X is the cutscene number).
*/

#include "x2_inc_cutscene"

void main()
{
    object oPC = GetLastPCToCancelCutscene();
    //switch based on which cutscene the player was in.
    int nCutNum = CutGetActiveCutsceneForObject(oPC);
    if(CutGetIsAbortDisabled(nCutNum) == 1) // check whether it is possible to abort this cutscene
        return;
    // generating the name of the cutscene-specific abort acript
    string sAbortScript = "cutabort" + IntToString(nCutNum);
    if(CutGetIsMainPC(oPC))
    {
        //CutRestorePCAppearance(nCutNum, oPC);
        SetLocalInt(GetModule(), "X2_DelayType" + IntToString(nCutNum), CUT_DELAY_TYPE_CONSTANT);
        float fDelay1 = CutGetAbortDelay(nCutNum);
        float fDelay2 = CutGetDestroyCopyDelay(nCutNum);
        CutResetActiveObjectsForCutscene(nCutNum); // all objects should stop executing cutscene actions after this line
        CutDisableCutscene(nCutNum, fDelay1, fDelay2);
        // Notice: do not use any Cut* delayed commands inside the abort script for players as the
        // cutscene is not running anymore, and none of them would execute (except for
        // CutRestore* functions which should still work after the cutscene has been aborted).
        ExecuteScript(sAbortScript, GetModule());
    }
    else
        FloatingTextStrRefOnCreature(40519, oPC);
}

