// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF);
    return iResult;
}

