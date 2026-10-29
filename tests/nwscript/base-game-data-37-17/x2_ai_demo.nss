//::///////////////////////////////////////////////
//:: Custom AI Demo Template
//:: x2_ai_demo
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a template for those who want to
    override the standard combat AI NWN uses.

    The code in this file effectivly replaces
    the DetermineCombatRound() function in
    nw_i0_generic.nss, which is the core of the
    NWN combat AI.

    To override the default AI with this or any
    other AI script you created, you can either
    call the SetCreatureOverrideAIScript from
    x2_inc_switches

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-21
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "x2_inc_switches"
void main()
{
    // The following two lines should not be touched
    object oIntruder = GetCreatureOverrideAIScriptTarget();
    ClearCreatureOverrideAIScriptTarget();


    // ********************* Start of custom AI script ****************************


    // Here you can write your own AI to run in place of DetermineCombatRound.
    // The minimalistic approach would be something like
    //
    // TalentFlee(oTarget); // flee on any combat activity


    // ********************* End of custom AI script ****************************

    // This line *** has to be called here *** or the default AI will take over from
    // this point and really bad things are going to happen
    SetCreatureOverrideAIScriptFinished();
}
