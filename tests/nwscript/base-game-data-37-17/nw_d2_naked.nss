//::///////////////////////////////////////////////
//:: Naked
//:: NW_D2_Naked
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character has nothing in his chest slot
    (no armor or clothing)
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 7, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    int TalkCounter;
    if (TalkCounter!=(GetLocalInt(OBJECT_SELF,"counter")==0))
    {
        int roll=d4();
        if (roll>1)
        {
            object oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,GetPCSpeaker());
            if(GetIsObjectValid(oItem) == FALSE)
            {
                return TRUE;
            }
            return FALSE;
        }
        return FALSE;
    }
    return FALSE;
}
