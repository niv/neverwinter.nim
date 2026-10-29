//::///////////////////////////////////////////////
//:: x0_dm_spycomm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Tells you who is commandable and who isn't
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void main()
{
    object oCritter = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCritter) == TRUE)
    {
        if (GetObjectType(oCritter) == OBJECT_TYPE_CREATURE)
        {
            if (GetCommandable(oCritter) == TRUE)
            {
                SendMessageToPC(GetFirstPC(), GetName(oCritter) + " is commandable.");
            }
            else
            if (GetCommandable(oCritter) == FALSE)
            {
                SendMessageToPC(GetFirstPC(), GetName(oCritter) + " is NOT commandable.");
            }
        }
        oCritter = GetNextObjectInArea(GetArea(OBJECT_SELF));
    }
}
