// spit stats
void main()
{
    object oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    int nStr = GetAbilityScore(oTarget, ABILITY_STRENGTH);
    int nDex = GetAbilityScore(oTarget, ABILITY_DEXTERITY);
    int nCon = GetAbilityScore(oTarget, ABILITY_CONSTITUTION);
    int nWis = GetAbilityScore(oTarget, ABILITY_WISDOM);
    int nInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
    int nCha = GetAbilityScore(oTarget, ABILITY_CHARISMA);
    string sName = GetName(oTarget);
    SendMessageToPC(GetFirstPC(), sName + " Strength = " + IntToString(nStr)
        + " Dex = " + IntToString(nDex) + " Con = " + IntToString(nCon)
        + " Wis = " + IntToString(nWis) + " Int = " + IntToString(nInt)
        + " Char = " + IntToString(nCha));

}
