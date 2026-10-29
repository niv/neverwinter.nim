//::///////////////////////////////////////////////
//:: FileName x1_sc_tracks1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 3/7/2003 1:11:35 PM
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_RANGER, OBJECT_SELF) >= 1)
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
