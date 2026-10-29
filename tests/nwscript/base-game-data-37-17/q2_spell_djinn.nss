//::///////////////////////////////////////////////
//:: q2_spell_djinn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Djinn will never stick around if a spell
    is cast at him...
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 12/02
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

void main()
{
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), GetLocation(OBJECT_SELF));
    DestroyObject(OBJECT_SELF, 2.0);
}
