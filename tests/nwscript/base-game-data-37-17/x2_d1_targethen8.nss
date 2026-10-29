// the henchman targets the one of the henchmen.

void main()
{
    object oTarget = GetHenchman(GetPCSpeaker(), 8);
    SetLocalObject(OBJECT_SELF, "Henchman_Spell_Target", oTarget);
}
