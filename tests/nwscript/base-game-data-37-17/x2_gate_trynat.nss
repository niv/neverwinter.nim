//::///////////////////////////////////////////////
//:: x2_gate_trynat
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
    object oNat = GetObjectByTag("x2_hen_nathyra");
    if (GetLocalInt(GetModule(), "Nathyrra_Called") == 1 || GetIsObjectValid(oNat) == FALSE)
    {
        return FALSE;
    }
    return TRUE;

}

