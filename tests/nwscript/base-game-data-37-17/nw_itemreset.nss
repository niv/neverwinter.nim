void main()
{
    object oItem = GetFirstItemInInventory();
    int bFoundCursedItem = FALSE;
    while(GetIsObjectValid(oItem))
    {
        if(GetItemCursedFlag(oItem))
        {
            bFoundCursedItem = TRUE;
            SendMessageToPC(OBJECT_SELF, "Reset non-droppable flag on item: "+GetName(oItem));
            SetItemCursedFlag(oItem, FALSE);
        }
        oItem = GetNextItemInInventory();
    }
    if(!bFoundCursedItem)
    {
        SendMessageToPC(OBJECT_SELF, "No non-droppable items found in inventory.");
    }
}
