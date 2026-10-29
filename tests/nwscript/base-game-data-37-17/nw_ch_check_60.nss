//::///////////////////////////////////////////////
//:: NW_CH_CHECK_60
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Returns true if the henchmen is on the
 End-Of_Game Trigger
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetMaster(), "NW_L_ENDPLAYERSPEECH");
    // * if player is still on trigger allow endgame speech

    if (iResult == 10)
    {
        // * if Henchman hasn't said speech already say it, otherwise this is invalid
        if (GetLocalInt(OBJECT_SELF, "NW_L_ENDSPEECH") == 10)
        {
            return TRUE;
        }
            return FALSE;
    }
    return FALSE;
}
