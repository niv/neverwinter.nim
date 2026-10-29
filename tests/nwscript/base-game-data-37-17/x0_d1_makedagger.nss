// Deekin takes the Dragon Tooth and makes it into a dagger

void main()
{
    object oTooth = GetItemPossessedBy(GetPCSpeaker(), "x1dragontooth");
    if (GetIsObjectValid(oTooth))
    {
        DestroyObject(oTooth);
        CreateItemOnObject("q2_deek_dagg", GetPCSpeaker());
    }
}
