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
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Jan 4th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////

#include "X0_INC_HENAI"
#include "x2_i0_spells"

void main()
{
    object oCaster = GetLastSpellCaster();
    if(GetLastSpellHarmful())
    {
        SetCommandable(TRUE);

        if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
        { // set variables on target for mounted combat
            DeleteLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL");
        } // set variables on target for mounted combat

        // * GZ Oct 3, 2003
        // * Really, the engine should handle this, but hey, this world is not perfect...
        // * If I was hurt by my master or the creature hurting me has
        // * the same master
        // * Then clear any hostile feelings I have against them
        // * After all, we're all just trying to do our job here
        // * if we singe some eyebrow hair, oh well.
        object oMyMaster = GetMaster(OBJECT_SELF);
        if ((oMyMaster != OBJECT_INVALID) && (oMyMaster == oCaster || (oMyMaster  == GetMaster(oCaster)))  )
        {
            ClearPersonalReputation(oCaster, OBJECT_SELF);
            // Send the user-defined event as appropriate
            if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
            {
                SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT));
            }
            return;
        }

        int bAttack = TRUE;
        // * AOE Behavior

        if (MatchAreaOfEffectSpell(GetLastSpell()) == TRUE)
        {
            if (GetIsHenchmanDying() == FALSE)
            {

                //* GZ 2003-Oct-02 : New AoE Behavior AI
                int nAI = (GetBestAOEBehavior(GetLastSpell()));

                switch (nAI)
                {
                    case X2_SPELL_AOEBEHAVIOR_DISPEL_L:
                    case X2_SPELL_AOEBEHAVIOR_DISPEL_N:
                    case X2_SPELL_AOEBEHAVIOR_DISPEL_M:
                    case X2_SPELL_AOEBEHAVIOR_DISPEL_G:
                    case X2_SPELL_AOEBEHAVIOR_DISPEL_C:
                            bAttack = FALSE;
                            ActionCastSpellAtLocation(nAI, GetLocation(OBJECT_SELF));
                            ActionDoCommand(SetCommandable(TRUE));
                            SetCommandable(FALSE);
                            break;


                    case X2_SPELL_AOEBEHAVIOR_FLEE:
                             ClearActions(CLEAR_NW_C2_DEFAULTB_GUSTWIND);
                             ActionForceMoveToObject(oCaster, TRUE, 2.0);
                             ActionMoveToObject(GetMaster(), TRUE, 1.1);
                                DelayCommand(1.2, ActionDoCommand(HenchmenCombatRound(OBJECT_INVALID)));
                             bAttack = FALSE;
                             break;

                    case X2_SPELL_AOEBEHAVIOR_IGNORE:
                             // well ... nothing
                            break;

                    case X2_SPELL_AOEBEHAVIOR_GUST:
                            ActionCastSpellAtLocation(SPELL_GUST_OF_WIND, GetLocation(OBJECT_SELF));
                            ActionDoCommand(SetCommandable(TRUE));
                            SetCommandable(FALSE);
                             bAttack = FALSE;
                            break;
                }

            }


        }

        if(
         (!GetIsObjectValid(GetAttackTarget()) &&
         !GetIsObjectValid(GetAttemptedSpellTarget()) &&
         !GetIsObjectValid(GetAttemptedAttackTarget()) &&
         !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)) &&
         !GetIsFriend(oCaster)) && bAttack
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

