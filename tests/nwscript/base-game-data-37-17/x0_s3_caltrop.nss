//::///////////////////////////////////////////////
//:: Caltrops
//:: x0_s3_caltrop
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Creates a permanent field of caltrops that will disappear
    after 25 points of damage have been dished out.
    (1 point per creature per round)

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

void SetObject(location lTarget, object oVisual)
{
    object oArea = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget);
    if (GetIsObjectValid(oArea) == TRUE)
    {
        SetLocalObject(oArea, "X0_L_IMPACT", oVisual);
    }
}

void main()
{
    //Declare major variables including Area of Effect Object
    // * passing dirge script for exit because it is an empty script (i.e., there is no special exit effects)
    effect eAOE = EffectAreaOfEffect(37, "x0_s3_calEN", "x0_s3_calHB", "");
    location lTarget = GetSpellTargetLocation();

    //effect eImpact = EffectVisualEffect(257);

    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAOE, lTarget);
    object oVisual = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lTarget);
    SetObject(lTarget, oVisual);

    effect eFieldOfSharp = EffectVisualEffect(VFX_DUR_CALTROPS);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFieldOfSharp, oVisual);

}

