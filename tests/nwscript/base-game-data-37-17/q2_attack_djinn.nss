//::///////////////////////////////////////////////
//:: q2_attack_djinn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round

    Djinn will dissappear if attacked
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 12/02
//:://////////////////////////////////////////////



void main()
{

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), GetLocation(OBJECT_SELF));
    DestroyObject(OBJECT_SELF, 2.0);
}
