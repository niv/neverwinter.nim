// the henchman targets the familiar with the spell

void main()
{
    object oTarget = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, GetPCSpeaker());
    SetLocalObject(OBJECT_SELF, "Henchman_Spell_Target", oTarget);
}
