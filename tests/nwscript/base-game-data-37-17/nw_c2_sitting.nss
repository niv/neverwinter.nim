//::///////////////////////////////////////////////
//:: NW_C2_SITTING.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Will make the NPC sit down
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
//    ActionPlayAnimation(ANIMATION_LOOPING_SIT_CHAIR,1.0,5000.0);
   // * do not do this if already sitting
   
   // * May 2002 (Brent): Don't do this if I am in combat or conversation
   if (!GetIsInCombat() && !IsInConversation(OBJECT_SELF))
   if (GetCurrentAction() != ACTION_SIT)
   {
        ClearAllActions();
        int i = 1;
        // * find first free chair
        object oChair = GetNearestObjectByTag("NW_CHAIR", OBJECT_SELF,i);
        int bFoundChair = FALSE;
        while (bFoundChair == FALSE && GetIsObjectValid(oChair) == TRUE)
        {
          // * This chair is free
          if (GetIsObjectValid(GetSittingCreature(oChair)) == FALSE)
          {
              bFoundChair = TRUE;
              ActionSit(oChair);
          }
          else
          {
              i++;
              oChair = GetNearestObjectByTag("NW_CHAIR", OBJECT_SELF,i);
          }
        }
        if (bFoundChair == FALSE)
        {
           // SpeakString("This sucks I have no place to sit");
           ClearAllActions();
           ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
        }
    }
}
