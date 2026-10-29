//::///////////////////////////////////////////////
//:: q2_endcon_djinn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Djinn will dissappear if conversation ends
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
     // Minor edits added by Drew K. on July, commented out speak string
//:: Created On: Dec 12/02
//:://////////////////////////////////////////////



void main()
{
    object oDjinni = (GetObjectByTag("q2cdjinn"));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), GetLocation(oDjinni));
    DestroyObject(oDjinni, 1.0);
}
