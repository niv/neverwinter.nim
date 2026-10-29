// * Apply neat-o visual effects to genie
void main()
{
    effect eVis = EffectVisualEffect(423);
    effect eVis2 = EffectVisualEffect(479);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis2, OBJECT_SELF);
}
