void main()
{
    object oCandle = OBJECT_SELF;
    effect eLight;
    eLight = EffectVisualEffect(VFX_DUR_LIGHT_ORANGE_5);
    eLight = SupernaturalEffect(eLight);

    if (GetLocalInt(oCandle,"TM_LIGHT_ON") == FALSE)
    {
        PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
        SetLocalInt(oCandle,"TM_LIGHT_ON",TRUE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLight,oCandle);
    }
    else
    {
        PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        SetLocalInt(oCandle,"TM_LIGHT_ON", FALSE);
        eLight = GetFirstEffect(oCandle);
        while(GetIsEffectValid(eLight))
        {
            if(GetEffectType(eLight) == EFFECT_TYPE_VISUALEFFECT)
            {
                RemoveEffect(oCandle,eLight);
            }
            eLight = GetNextEffect(oCandle);
        }
    }

}
