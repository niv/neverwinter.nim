//::///////////////////////////////////////////////
//:: x2_asc_con_summo
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    - returns true if dominated
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oSelf = OBJECT_SELF;
    if (GetAssociateType(oSelf) == ASSOCIATE_TYPE_SUMMONED)
    {
        return TRUE;
    }
    return FALSE;

}
