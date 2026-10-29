// the henchman targets the one of the henchmen.

void main()
{
    object oTarget = GetHenchman(GetPCSpeaker(), 4);
    SetLocalObject(OBJECT_SELF, "Henchman_Spell_Target", oTarget);
}
