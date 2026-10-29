//::///////////////////////////////////////////////
//:: Intelligence LT 9
//:: TEMPL_IL8
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character has an INT of less than 9
    25% chance of going down to next priority
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 7, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    if ((GetLocalInt(OBJECT_SELF,"counter")!=3) && (GetLocalInt(OBJECT_SELF,"counter")!=2))
    {
        int roll=d100();
        if (roll>70)
        {
            int iResult=GetAbilityScore(GetPCSpeaker(),ABILITY_INTELLIGENCE);
            if(iResult<=8)
            {
                return TRUE;
            }
            return FALSE;
        }
        return FALSE;
    }
    return FALSE;
}

