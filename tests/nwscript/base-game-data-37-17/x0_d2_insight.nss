/* Checks to see if the player has at least normal intelligence AND wisdom,
 * and a reasonably high score in at least one.
 */

int StartingConditional()
{
    int nIntelligence =  GetAbilityScore(GetPCSpeaker(), ABILITY_INTELLIGENCE);
    int nWisdom =  GetAbilityScore(GetPCSpeaker(), ABILITY_WISDOM);

    // Must have at least normal intelligence AND wisdom
    if (nIntelligence < 9)
        return FALSE;
    if (nWisdom < 9)
        return FALSE;

    // Must have high intelligence OR high wisdom
    if (nIntelligence >= 13)
        return TRUE;
    if (nWisdom >= 13)
        return TRUE;

    return FALSE;

}
