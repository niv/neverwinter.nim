//::///////////////////////////////////////////////
//:: x2_asc_con_famil
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    - returns true if a familiar
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oSelf = OBJECT_SELF;
    if (GetAssociateType(oSelf) == ASSOCIATE_TYPE_FAMILIAR)
    {
        return TRUE;
    }
    return FALSE;

}
