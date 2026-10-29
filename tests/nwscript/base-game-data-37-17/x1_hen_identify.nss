// Henchman tries to identify all items in his and the player's inventory.

void IdentifyAll(object oObject, object oMaster);

void main()
{
    object oPC = GetMaster(OBJECT_SELF);
    IdentifyAll(oPC, oPC);
    IdentifyAll(OBJECT_SELF, oPC);
}

void IdentifyAll(object oObject, object oPC)
{

    int nMyLore = GetSkillRank(SKILL_LORE, OBJECT_SELF); // henchman lore rank
    int nItemValue; // gold value of item
    string sMaxValue = Get2DAString("SkillVsItemCost", "DeviceCostMax", nMyLore); // max value that the henchman can id
    int nMaxValue = StringToInt(sMaxValue);

    // * Handle overflow (November 2003 - BK)
    if (sMaxValue == "")
    {
        nMaxValue = 120000000;
    }
    
    object oItem = GetFirstItemInInventory(oObject);
    while(oItem != OBJECT_INVALID)
    {
        if(!GetIdentified(oItem))
        {
            SetIdentified(oItem, TRUE); // setting TRUE to get the true value of the item
            nItemValue = GetGoldPieceValue(oItem);
            SetIdentified(oItem, FALSE); // back to FALSE
            if(nMaxValue >= nItemValue)
            {
                SetIdentified(oItem, TRUE);
                SendMessageToPC(oPC, GetName(OBJECT_SELF) + " " +  GetStringByStrRef(75930) + " " + GetName(oItem));
            }
        }
        oItem = GetNextItemInInventory(oObject);
    }
}

