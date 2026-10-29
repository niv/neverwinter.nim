void main()
{
    object oPC = GetPCSpeaker();

    // Remove custscene immobilize from player
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
         if (GetEffectType(eEff) == EFFECT_TYPE_CUTSCENEIMMOBILIZE
             && GetEffectCreator(eEff) == oPC
             && GetEffectSubType(eEff) == SUBTYPE_EXTRAORDINARY )
         {
            RemoveEffect(oPC,eEff);
         }
         eEff = GetNextEffect(oPC);
     }

    RestoreCameraFacing();
    ClearAllActions();
}
