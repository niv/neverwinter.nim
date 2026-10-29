//::///////////////////////////////////////////////
//:: Follow Player
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Follows Player.  Used in the Rescue
  generic plot template.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////
#include "NW_J_RESCUE"
void main()
{  // SpeakString(IntToString(GetLocalInt(Global(),"NW_Resc_Plot")));
    if (GetLocalInt(Global(),"NW_Resc_Plot") == 10)
    {
       if (GetIsObjectValid(GetRingGivenTo()) == TRUE)
       {
        ClearAllActions();
        ActionForceMoveToObject(GetRingGivenTo(),TRUE, 5.5, 5.0);
       }
       else
       {
        ActionSpeakStringByStrRef(0);
       }
    }
}
