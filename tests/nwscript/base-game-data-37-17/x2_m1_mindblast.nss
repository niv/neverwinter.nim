//::///////////////////////////////////////////////
//:: Cone: Mindflayer Mind Blast
//:: x2_m1_mindblast
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Anyone caught in the cone must make a
    Will save (DC 17) or be stunned for 3d4 rounds
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5/02
//:://////////////////////////////////////////////

#include "x2_i0_spells"

void main()
{
   int nSaveDC = 10 +(GetHitDice(OBJECT_SELF)/2) +  GetAbilityModifier(ABILITY_WISDOM,OBJECT_SELF);
   object oTarget = GetSpellTargetObject();
   DoMindBlast(nSaveDC, d4(1), 15.0f);
}

