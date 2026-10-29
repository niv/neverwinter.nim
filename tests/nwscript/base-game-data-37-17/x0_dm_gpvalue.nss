//::///////////////////////////////////////////////
//:: x0_dm_gpvalue
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the total gp value of all gold
    and equipment that the player is carrying.
    - won't check inside containers
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int nEquippedAccum = 0;
int nAccum;

void DetermineCost(object oTarget)
{
    object oItem = GetFirstItemInInventory(oTarget);
    while (GetIsObjectValid(oItem))
    {
        nAccum = nAccum + GetGoldPieceValue(oItem);
        SetIdentified(oItem, TRUE);
        if (GetBaseItemType(oItem) == BASE_ITEM_LARGEBOX)
        {
            object oNextItem = GetFirstItemInInventory(oItem);
            while (GetIsObjectValid(oNextItem))
            {
                nAccum = nAccum + GetGoldPieceValue(oNextItem);
               // SpeakString(" = " + GetName(oNextItem));
                oNextItem = GetNextItemInInventory(oItem);
            }
        }

        oItem = GetNextItemInInventory(oTarget);
    }
    int i = 0;

    for (i = 0 ; i<= 17; i++)
    {
        oItem = GetItemInSlot(i);
        if (GetIsObjectValid(oItem) == TRUE)
        {
            nEquippedAccum = nEquippedAccum + GetGoldPieceValue(oItem);
        }
    }



}

void main()
{
    DoSinglePlayerAutoSave();
    DetermineCost(OBJECT_SELF);
    object oAssoc = GetAssociate(ASSOCIATE_TYPE_HENCHMAN);
    if (GetIsObjectValid(oAssoc))
    {
        DetermineCost(oAssoc) ;
    }
    int nAccum1 = GetGold(OBJECT_SELF) + nAccum + nEquippedAccum;
    int nAccum2 = GetGold(OBJECT_SELF) + FloatToInt(nEquippedAccum*0.35) + FloatToInt(nAccum * 0.35);

    //SpeakString(" Total value of equipment before taxes " + IntToString(nAccum1));

    SpeakString("Total value of equipment at standard cost: " + IntToString(nAccum2));



    SpeakString("Total Value just of equipped (vs. just backpack): " + IntToString(FloatToInt(nEquippedAccum*0.35))
            + " ( " + IntToString(FloatToInt(nAccum * 0.35)) + ")");

}
