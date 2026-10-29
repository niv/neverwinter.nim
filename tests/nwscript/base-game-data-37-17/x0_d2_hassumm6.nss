// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_SUMMON_CREATURE_VI, OBJECT_SELF);
    return iResult;
}
