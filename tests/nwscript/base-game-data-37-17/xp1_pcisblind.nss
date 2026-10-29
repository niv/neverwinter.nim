// check the state of the NPC

int StartingConditional()
{
    effect eState = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eState))
    {
        if (GetEffectType(eState) == EFFECT_TYPE_BLINDNESS)
        {
            return TRUE;
        }
        eState = GetNextEffect(OBJECT_SELF);
    }
    return FALSE;
}
