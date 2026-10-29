// Deekin takes the Dragon Tooth and makes it into an amulet

void main()
{
    object oTooth = GetItemPossessedBy(GetPCSpeaker(), "x1dragontooth");
    object oWear = GetItemInSlot(INVENTORY_SLOT_NECK, OBJECT_SELF);
    if (GetIsObjectValid(oTooth))
    {
        DestroyObject(oTooth);
        CreateItemOnObject("q2_deek_amul", OBJECT_SELF);
        object oAmulet = GetItemPossessedBy(OBJECT_SELF, "q2_deek_amul");
        ClearAllActions();
        ActionPauseConversation();

        if (GetIsObjectValid(oWear))
        {
            ActionUnequipItem(oWear);
            ActionEquipItem(oAmulet, INVENTORY_SLOT_NECK);
        }
        else
        {
            ActionEquipItem(oAmulet, INVENTORY_SLOT_NECK);
        }

        ActionDoCommand(SetDroppableFlag(oAmulet, FALSE));
        ActionResumeConversation();
    }
}
