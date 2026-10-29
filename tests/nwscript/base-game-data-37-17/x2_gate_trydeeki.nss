//::///////////////////////////////////////////////
//:: x2_gate_trydeeki
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You can only "call forth" a henchman once.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oDeekin = GetObjectByTag("x2_hen_deekin");
    if (GetLocalInt(GetModule(), "Deekin_Called") == 1 || GetIsObjectValid(oDeekin) == FALSE)
    {
        return FALSE;
    }
    return TRUE;

}
