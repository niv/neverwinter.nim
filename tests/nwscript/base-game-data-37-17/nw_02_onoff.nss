//::///////////////////////////////////////////////
//:: NW_O2_ONOFF.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Turns the placeable object's animation on/off
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  January 2002
//:://////////////////////////////////////////////


void main()
{

    if (GetLocalInt(OBJECT_SELF,"NW_L_AMION") == 0)
    {
        object oSelf = OBJECT_SELF;
        PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
        //DelayCommand(0.4,SetPlaceableIllumination(oSelf, TRUE));
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",1);
        //DelayCommand(0.5,RecomputeStaticLighting(GetArea(oSelf)));
        effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, oSelf);
    }
    else
    {
        object oSelf = OBJECT_SELF;
        PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        //DelayCommand(0.4,SetPlaceableIllumination(oSelf, FALSE));
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",0);
        //DelayCommand(0.9,RecomputeStaticLighting(GetArea(oSelf)));
        effect eEffect = GetFirstEffect(oSelf);
        while (GetIsEffectValid(eEffect) == TRUE)
        {
            if (GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT)
                RemoveEffect(oSelf, eEffect);
            eEffect = GetNextEffect(oSelf);
        }

    }
}
