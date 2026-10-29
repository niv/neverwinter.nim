// cancels Deekin's spell settings

void main()
{
    SetLocalInt(OBJECT_SELF, "Deekin_Spell_Cast", 0);
    SetLocalObject(OBJECT_SELF, "Henchman_Spell_Target", OBJECT_INVALID);
}
