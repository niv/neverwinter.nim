//::///////////////////////////////////////////////
//:: Demon Grants Several Powers to Player
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  December
//:://////////////////////////////////////////////

void main()
{
   ActionPauseConversation();
   ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ELEMENTS, GetPCSpeaker(), METAMAGIC_ANY, TRUE);
//   ActionCastSpellAtObject(SPELL_STONESKIN, GetPCSpeaker(), METAMAGIC_ANY, TRUE);
//   ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, GetPCSpeaker(), METAMAGIC_ANY, TRUE);
   ActionResumeConversation();
}
