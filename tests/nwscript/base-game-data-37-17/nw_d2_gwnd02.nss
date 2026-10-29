//::///////////////////////////////////////////////
//:: Wounded
//:: TEMPL_WND01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character is terribly wounded
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
        if (roll>60)
        {
            int CurrentHP=GetCurrentHitPoints(GetPCSpeaker());
            int MaxHP=GetMaxHitPoints(GetPCSpeaker());
            if ((MaxHP/2)>=(CurrentHP))
            {
                return TRUE;
            }
            return FALSE;
        }
        return FALSE;
    }
    return FALSE;
}

