//::///////////////////////////////////////////////
//:: Flirt
//:: TEMPL_FLR01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true 50% of the time if a PC Male with
    more than 13 CHR speaks with a Female
    NPC with more than 8 CHR.
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 8, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
    if ((GetLocalInt(OBJECT_SELF,"counter")!=1) && (GetLocalInt(OBJECT_SELF,"counter")!=2))
    {
        int roll=d100();
        if (roll>50)
        {
            if (GetAbilityScore(OBJECT_SELF,ABILITY_CHARISMA) > 8)
            {
                if (GetAbilityScore(GetPCSpeaker(),ABILITY_CHARISMA) > 13)
                {
                    if ((GetGender(OBJECT_SELF)==GENDER_FEMALE) && (GetGender(GetPCSpeaker())==GENDER_MALE))
                    {
                        return TRUE;
                    }
                }
            }
        }
    }
    return FALSE;
}

