//::///////////////////////////////////////////////
//:: Flirt
//:: NW_D2_FLMALE
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if character is male
    and with at least a normal CHR, and the PC
    is female with a high charisma
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 8, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
    if (GetAbilityScore(OBJECT_SELF,ABILITY_CHARISMA) > 8)
    {
        if (GetAbilityScore(GetPCSpeaker(),ABILITY_CHARISMA) > 13)
        {
            if ((GetGender(OBJECT_SELF)==GENDER_MALE) && (GetGender(GetPCSpeaker())==GENDER_FEMALE))
            {
                return TRUE;
            }
            return FALSE;
        }
        return FALSE;
    }
    return FALSE;
}
