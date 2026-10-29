// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_EAGLE_SPLEDOR, OBJECT_SELF);
    return iResult;
}
