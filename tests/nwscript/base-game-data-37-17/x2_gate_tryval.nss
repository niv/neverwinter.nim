//::///////////////////////////////////////////////
//:: x2_gate_tryval
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
    object oVal = GetObjectByTag("x2_hen_valen");
    if (GetLocalInt(GetModule(), "Valen_Called") == 1 || GetIsObjectValid(oVal) == FALSE)
    {
        return FALSE;
    }
    return TRUE;

}


