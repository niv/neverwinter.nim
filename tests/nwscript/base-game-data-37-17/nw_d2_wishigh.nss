// checks to see if the PC's Wisdom is 15+

int StartingConditional()
{
    int iResult;

    iResult = GetAbilityScore(GetPCSpeaker(), ABILITY_WISDOM) > 14;
    return iResult;
}
