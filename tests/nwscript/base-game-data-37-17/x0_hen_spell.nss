//::///////////////////////////////////////////////
//:: Henchmen: On Spell Cast At
//:: NW_CH_ACB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This determines if the spell just cast at the
    target is harmful or not.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 6, 2001
//:://////////////////////////////////////////////

#include "X0_INC_HENAI"

void main()
{
    object oCaster = GetLastSpellCaster();
    if(GetLastSpellHarmful())
    {
        SetCommandable(TRUE);
        // * get out of an area of effect
        if (MatchAreaOfEffectSpell(GetLastSpell()) == TRUE)
        {
            ClearAllActions();
            // * cast Gust of wind if have it
//            if (GetHasSpell(75) == TRUE)
            if (GetHasSpell(75))
            {
                ActionCastSpellAtLocation(75, GetLocation(OBJECT_SELF));
                ActionDoCommand(SetCommandable(TRUE));
                SetCommandable(FALSE);
                return;

            }
            else

              {
                ActionMoveToObject(GetMaster(), TRUE, 1.1);
                DelayCommand(1.2, ActionDoCommand(HenchmenCombatRound(OBJECT_INVALID)));
                return;
              }
        }

        if(
         !GetIsObjectValid(GetAttackTarget()) &&
         !GetIsObjectValid(GetAttemptedSpellTarget()) &&
         !GetIsObjectValid(GetAttemptedAttackTarget()) &&
         !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)) &&
         !GetIsFriend(oCaster)
        )
        {
            SetCommandable(TRUE);
            //Shout Attack my target, only works with the On Spawn In setup
            SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
            //Shout that I was attacked
            SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
            HenchmenCombatRound(oCaster);
        }
    }
}
