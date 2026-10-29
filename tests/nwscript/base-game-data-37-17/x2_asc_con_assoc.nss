//::///////////////////////////////////////////////
//:: x2_asc_con_assoc
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    - returns true if a animal companion
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oSelf = OBJECT_SELF;
    if (GetAssociateType(oSelf) == ASSOCIATE_TYPE_ANIMALCOMPANION)
    {
        return TRUE;
    }
    return FALSE;

}
