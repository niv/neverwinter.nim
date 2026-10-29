// the familiar heals itself fully (no effects)
void main()
{
    int nHeal = GetMaxHitPoints();
    effect eHeal = EffectHeal(nHeal);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,OBJECT_SELF);
}
