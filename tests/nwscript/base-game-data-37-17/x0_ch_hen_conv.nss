//:://////////////////////////////////////////////////
//:: X0_CH_HEN_CONV
/*

  OnDialogue event handler for henchmen/associates.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////


#include "x0_inc_henai"
#include "x0_i0_henchman"

//* GeorgZ - Put in a fix for henchmen talking even if they are petrified
int AbleToTalk(object oSelf)
{
   if (GetHasEffect(EFFECT_TYPE_CONFUSED, oSelf) || GetHasEffect(EFFECT_TYPE_DOMINATED, oSelf) ||
        GetHasEffect(EFFECT_TYPE_PETRIFY, oSelf) || GetHasEffect(EFFECT_TYPE_PARALYZE, oSelf)   ||
        GetHasEffect(EFFECT_TYPE_STUNNED, oSelf) || GetHasEffect(EFFECT_TYPE_FRIGHTENED, oSelf)
    )
    {
        return FALSE;
    }

   return TRUE;
}


#include "x0_i0_henchman"


void main()
{
  // * XP2, special handling code for interjections
  // * This script only fires if someone inits with me.
  // * with that in mind, I am now clearing any interjections
  // * that the character might have on themselves.
  if (GetLocalInt(GetModule(), "X2_L_XP2") == TRUE)
  {
    SetLocalInt(OBJECT_SELF, "X2_BANTER_TRY", 0);
    SetHasInterjection(GetMaster(OBJECT_SELF), FALSE);
    SetLocalInt(OBJECT_SELF, "X0_L_BUSY_SPEAKING_ONE_LINER", 0);
    SetOneLiner(FALSE, 0);
  }
    
    object oShouter = GetLastSpeaker();
    if (GetTag(OBJECT_SELF) == "x0_hen_dee")
    {
        string sCall = GetCampaignString("Deekin", "q6_Deekin_Call"+ GetName(oShouter), oShouter);

        if (sCall == "")
        {
            SetCustomToken(1001, GetStringByStrRef(40570));
        }
        else SetCustomToken(1001, sCall);
    }

//    int i = GetLocalInt(OBJECT_SELF, sAssociateMasterConditionVarname);
//    SendMessageToPC(GetFirstPC(), IntToHexString(i));
    if (GetIsHenchmanDying() == TRUE)
    {
        return;
    }

    object oMaster = GetMaster();
    int nMatch = GetListenPatternNumber();

    object oIntruder;

    if (nMatch == -1)
    {
        // * September 2 2003
        // * Added the GetIsCommandable check back in so that
        // * Henchman cannot be interrupted when they are walking away
        if (GetCommandable(OBJECT_SELF) == TRUE && AbleToTalk(OBJECT_SELF)
           && (GetCurrentAction() != ACTION_OPENLOCK))
        {   //SetCommandable(TRUE);
            ClearActions(CLEAR_X0_CH_HEN_CONV_26);
            

            string sDialogFileToUse = GetDialogFileToUse(GetLastSpeaker());

            
            BeginConversation(sDialogFileToUse);
        }
    }
    else
    {
        // listening pattern matched
        if (GetIsObjectValid(oMaster))
        {
            // we have a master, only listen to them
            // * Nov 2003 - Added an AbleToTalk, so that henchmen
            // * do not respond to orders when 'frozen'
            if (GetIsObjectValid(oShouter) && oMaster == oShouter && AbleToTalk(OBJECT_SELF)) {
                SetCommandable(TRUE);
                bkRespondToHenchmenShout(oShouter, nMatch, oIntruder);
            }
        }

        // we don't have a master, behave in default way
        else if (GetIsObjectValid(oShouter)
                 && !GetIsPC(oShouter)
                 && GetIsFriend(oShouter)) {

             object oIntruder = OBJECT_INVALID;

             // Determine the intruder if any
             if(nMatch == 4) {
                 oIntruder = GetLocalObject(oShouter, "NW_BLOCKER_INTRUDER");
             }
             else if (nMatch == 5) {
                 oIntruder = GetLastHostileActor(oShouter);
                 if(!GetIsObjectValid(oIntruder)) {
                     oIntruder = GetAttemptedAttackTarget();
                     if(!GetIsObjectValid(oIntruder)) {
                         oIntruder = GetAttemptedSpellTarget();
                     }
                 }
             }

             // Actually respond to the shout
             RespondToShout(oShouter, nMatch, oIntruder);
         }
    }


    // Signal user-defined event
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT)) {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}

