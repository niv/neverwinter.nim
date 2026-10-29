//::///////////////////////////////////////////////
//:: FileName x1_sc_tracks2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 3/7/2003 2:06:26 PM
//:://////////////////////////////////////////////
int StartingConditional()
{
    if(GetAbilityScore(GetPCSpeaker(), ABILITY_INTELLIGENCE) > 12)
        return TRUE;

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker()) >= 1)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 1))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
