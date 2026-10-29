//::///////////////////////////////////////////////
//:: Responder
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Says, 'cannot find them' dialog.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    if (GetLocalInt(OBJECT_SELF, "NW_L_ONTHEMOVE") == 1)
     {
         SetLocalInt(OBJECT_SELF, "NW_L_ONTHEMOVE",0);
         // * move back to location, set locals resetting self
         DelayCommand(3.0,ActionMoveToLocation(GetLocalLocation(OBJECT_SELF,"NW_L_I_WAS_HERE")));
         return TRUE;
     }
     else
    return FALSE;
}
