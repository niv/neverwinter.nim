// the henchman targets the PC with the spell

void main()
{
    SetLocalObject(OBJECT_SELF, "Henchman_Spell_Target", GetPCSpeaker());
}
