// the PC has the dragon's tooth

int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), "x1dragontooth"));
    return iResult;
}
