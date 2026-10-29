//::///////////////////////////////////////////////
//:: x2_turnoffbanter
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If no appropriate banter was found
    then turn off the banter variable.

    Always return false, this is a tech line
    only.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{

    // * The script on the action node will be unable to fire
    // * so instead, just execute that script from here in the case where
    // * I do have a legitimiate banter
    
    if (GetLocalInt(OBJECT_SELF, "X2_BANTER_TRY") == TRUE)
    {
        SetLocalInt(OBJECT_SELF, "X2_PLEASE_NO_TALKING", 100);
        ExecuteScript("x2_hen_try_other", OBJECT_SELF);
    }

    SetLocalInt(OBJECT_SELF, "X2_BANTER_TRY", 0);
    return FALSE;
}
