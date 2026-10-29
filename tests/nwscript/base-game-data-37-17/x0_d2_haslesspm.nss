// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_LESSER_SPELL_MANTLE, OBJECT_SELF);
    return iResult;
}
