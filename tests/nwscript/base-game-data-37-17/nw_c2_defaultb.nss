//::///////////////////////////////////////////////
//:: Default: On Spell Cast At
//:: NW_C2_DEFAULTB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This determines if the spell just cast at the
    target is harmful or not.

    GZ 2003-Oct-02 : - New AoE Behavior AI. Will use
                       Dispel Magic against AOES
                     - Flying Creatures will ignore
                       Grease

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 6, 2001
//:: Last Modified On: 2003-Oct-13
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Jan 4th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////

#include "nw_i0_generic"
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

        // ------------------------------------------------------------------
        // If I was hurt by someone in my own faction
        // Then clear any hostile feelings I have against them
        // After all, we're all just trying to do our job here
        // if we singe some eyebrow hair, oh well.
        // ------------------------------------------------------------------
        if (GetFactionEqual(oCaster, OBJECT_SELF) == TRUE)
        {
            ClearPersonalReputation(oCaster, OBJECT_SELF);
            ClearAllActions(TRUE);
            DelayCommand(1.2, ActionDoCommand(DetermineCombatRound(OBJECT_INVALID)));
            // Send the user-defined event as appropriate
            if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
            {
                SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT));
            }
            return;
        }

        int bAttack = TRUE;
        // ------------------------------------------------------------------
        // GZ, 2003-Oct-02
        // Try to do something smart if we are subject to an AoE Spell.
        // ------------------------------------------------------------------
        if (MatchAreaOfEffectSpell(GetLastSpell()) == TRUE)
        {
            int nAI = (GetBestAOEBehavior(GetLastSpell())); // from x2_i0_spells
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
                         oCaster = GetLastSpellCaster();
                         ActionForceMoveToObject(oCaster, TRUE, 2.0);
                         DelayCommand(1.2, ActionDoCommand(DetermineCombatRound(oCaster)));
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
        // ---------------------------------------------------------------------
        // Not an area of effect spell, but another hostile spell.
        // If we're not already fighting someone else,
        // attack the caster.
        // ---------------------------------------------------------------------
        if( !GetIsFighting(OBJECT_SELF) && bAttack)
        {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                DetermineSpecialBehavior(oCaster);
            }
            else
            {
                DetermineCombatRound(oCaster);
            }
        }

        // We were attacked, so yell for help
        SetCommandable(TRUE);
        //Shout Attack my target, only works with the On Spawn In setup
        SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

        //Shout that I was attacked
        SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
    }
    else
    {
        // ---------------------------------------------------------------------
        // July 14, 2003 BK
        // If there is a valid enemy nearby and a NON HARMFUL spell has been
        // cast on me  I should call DetermineCombatRound
        // I may be invisible and casting spells on myself to buff myself up
        // ---------------------------------------------------------------------
        // Fix: JE - let's only do this if I'm currently in combat. If I'm not
        // in combat, and something casts a spell on me, it'll make me search
        // out the nearest enemy, no matter where they are on the level, which
        // is kinda dumb.
        object oEnemy =GetNearestEnemy();
        if ((GetIsObjectValid(oEnemy) == TRUE) && (GetIsInCombat() == TRUE))
        {
           // SpeakString("keep me in combat");
            DetermineCombatRound(oEnemy);
        }
    }

    // Send the user-defined event as appropriate
    if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT));
    }


}
