// * transport player back to place where you died
void main()
{
     object oSelf = OBJECT_SELF;
     effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
     ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eVis, GetLocalLocation(GetPCSpeaker(),"NW_L_I_DIED_HERE"));
     SetLocalInt(GetPCSpeaker(), "NW_L_I_DIED", 0);
     object oPC = GetPCSpeaker();
     ActionCastFakeSpellAtObject(SPELL_FREEDOM_OF_MOVEMENT, OBJECT_SELF);

     AssignCommand(GetPCSpeaker(),   DelayCommand(0.5, JumpToLocation(GetLocalLocation(oPC,"NW_L_I_DIED_HERE"))));
}
