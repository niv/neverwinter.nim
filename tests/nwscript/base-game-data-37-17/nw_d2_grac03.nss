//::///////////////////////////////////////////////
//:: Race
//:: TEMPL_RAC01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is of the same race
    (but not human)
    25% chance of going down to next priority
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 8, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    if ((GetLocalInt(OBJECT_SELF,"counter")!=1) && (GetLocalInt(OBJECT_SELF,"counter")!=3))
    {
        int roll=d100();
        if (roll>50)
        {
            if (((GetRacialType(GetPCSpeaker()))==(GetRacialType(OBJECT_SELF))) && ((GetRacialType(GetPCSpeaker()))!=RACIAL_TYPE_HUMAN))
            {
                return TRUE;
            }
            return FALSE;
        }
        return FALSE;
    }
    return FALSE;
}

