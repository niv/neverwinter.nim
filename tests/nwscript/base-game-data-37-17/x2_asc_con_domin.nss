//::///////////////////////////////////////////////
//:: x2_asc_con_domin
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    - returns true if dominated
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oSelf = OBJECT_SELF;
    if (GetAssociateType(oSelf) == ASSOCIATE_TYPE_DOMINATED)
    {
        return TRUE;
    }
    return FALSE;

}
