// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_ETHEREAL_VISAGE, OBJECT_SELF);
    return iResult;
}
