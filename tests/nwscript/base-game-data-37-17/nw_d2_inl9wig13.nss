int StartingConditional()
{
    int l_iResult;

    l_iResult = GetAbilityScore(GetLastSpeaker(),ABILITY_INTELLIGENCE) < 9 && GetAbilityScore(GetLastSpeaker(),ABILITY_WISDOM) > 13;
    return l_iResult;
}
