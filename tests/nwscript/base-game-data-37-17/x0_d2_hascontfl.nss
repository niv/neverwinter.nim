// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_CONTINUAL_FLAME, OBJECT_SELF);
    return iResult;
}
