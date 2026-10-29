//::///////////////////////////////////////////////
//:: Default: On Spell Cast At
//:: NW_C2_DEFAULTB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This determines if the spell just cast at the
    target is harmful or not.

    SEP27: Trying to add a little Area-of-effect IQ
    When affected will move towards the originator
    of the area effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 6, 2001
//:://////////////////////////////////////////////


#include "inc_mf_combat"

void main()
{

    object oCaster = GetLastSpellCaster();
    if(GetLastSpellHarmful())
    {
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
                object oCaster = GetLastSpellCaster();
                ActionForceMoveToObject(oCaster, TRUE, 2.0);
                DelayCommand(1.2, ActionDoCommand(DetermineMindflayerCombat(oCaster)));
                return;
              }
        }
        else
        if(
         !GetIsObjectValid(GetAttackTarget()) &&
         !GetIsObjectValid(GetAttemptedSpellTarget()) &&
         !GetIsObjectValid(GetAttemptedAttackTarget()) &&
         GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN))
        )
        {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                DetermineSpecialBehavior(oCaster);
            }
            else
            {
                DetermineMindflayerCombat(oCaster);
            }
            //Shout Attack my target, only works with the On Spawn In setup
            SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
            //Shout that I was attacked
            SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
        }
    }
    if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1011));
    }
}
