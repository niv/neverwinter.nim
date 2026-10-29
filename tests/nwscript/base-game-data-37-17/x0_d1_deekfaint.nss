// Deekin spasms and then faints

void main()
{
    ClearAllActions();
    ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 0.7, 1.5);

    effect eFaint = EffectSleep();
    ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFaint, OBJECT_SELF, 10.0));

}
