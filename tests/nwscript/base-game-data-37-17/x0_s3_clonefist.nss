//::///////////////////////////////////////////////
//:: x0_s3_clonefist
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Create a fiery version of the character
    to help them fight.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "nw_i0_generic"

void FakeHB()
{
    effect eFlame = EffectVisualEffect(VFX_IMP_FLAME_M);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, OBJECT_SELF);
    int nExplode = GetLocalInt(OBJECT_SELF, "X0_L_MYTIMERTOEXPLODE");
    object oMaster = GetLocalObject(OBJECT_SELF, "X0_L_MYMASTER");
    if (nExplode == 6)
    {

        ClearAllActions();
        PlayVoiceChat(VOICE_CHAT_GOODBYE);
        effect eFirePro = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFirePro, oMaster, 3.5);
        ActionCastSpellAtLocation(SPELL_FIREBALL, GetLocation(OBJECT_SELF), METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);

        DestroyObject(OBJECT_SELF, 0.5);
        SetCommandable(FALSE);
        return;
    }
    else
    {
        object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oMaster, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        // * attack my master's enemy
        if (GetIsObjectValid(oEnemy) )
        {
            DetermineCombatRound(oEnemy);
        }

        ActionMoveToObject(GetLocalObject(OBJECT_SELF, "X0_L_MYMASTER"), TRUE);
        SetLocalInt(OBJECT_SELF, "X0_L_MYTIMERTOEXPLODE", nExplode + 1);
        DelayCommand(3.0, FakeHB());
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oFireGuy = CopyObject(oPC, GetLocation(OBJECT_SELF), OBJECT_INVALID, GetName(oPC) + "CLONEFROMFISTS");

    SetLocalInt(oFireGuy, "X0_L_MYTIMERTOEXPLODE",1);
    SetLocalObject(oFireGuy, "X0_L_MYMASTER", oPC);
    ChangeToStandardFaction(oFireGuy, STANDARD_FACTION_COMMONER);
    SetPCLike(oPC, oFireGuy);
    DelayCommand(0.5, SetPlotFlag(oFireGuy, TRUE)); // * so items don't drop, I can destroy myself.
    AssignCommand(oFireGuy, FakeHB());
    effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oFireGuy);
    
}
    
