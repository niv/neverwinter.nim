//::///////////////////////////////////////////////
//:: Flirt, Low Intelligence
//:: NW_D2_FLIRTI_L
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a Chr Normal check and a gender check to
    see if the person is of the opposite sex, also
    checks for low int.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_PLOT"

int StartingConditional()
{
    int nGender = GetGender(GetPCSpeaker());
    if(CheckCharismaNormal() && CheckIntelligenceLow())
    {
        if(nGender == 0)
        {
            if(GetGender(OBJECT_SELF) == 1)
            {
                return TRUE;
            }
            else
            {
                return FALSE;
            }
        }
        else if (nGender == 1)
        {
            if(GetGender(OBJECT_SELF) == 0)
            {
                return TRUE;
            }
            else
            {
                return FALSE;
            }
        }
        else
        {
            return FALSE;
        }
    }
    return FALSE;
}
