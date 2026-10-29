//::///////////////////////////////////////////////
//:: Not Race
//:: TEMPL_NRC03
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is of a different race
    and does not have a high charisma
    (but not human)
    50% chance of going down to next priority
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 8, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    if ((GetLocalInt(OBJECT_SELF,"counter")!=3) && (GetLocalInt(OBJECT_SELF,"counter")!=1))
    {
        int roll=d100();
        if (roll>70)
        {
            if ((GetRacialType(GetPCSpeaker()))!= (GetRacialType(OBJECT_SELF)) && ((GetRacialType(GetPCSpeaker()))!=RACIAL_TYPE_HUMAN))
            {
                if (GetAbilityScore(GetPCSpeaker(),ABILITY_CHARISMA) < 14)
                {
                    return TRUE;
                }
                return FALSE;
            }
            return FALSE;
        }
        return FALSE;
    }
    return FALSE;
}

