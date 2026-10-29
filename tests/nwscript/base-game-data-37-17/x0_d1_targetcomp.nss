// the henchman targets the animal companion with the spell

void main()
{
    object oTarget = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, GetPCSpeaker());
    SetLocalObject(OBJECT_SELF, "Henchman_Spell_Target", oTarget);
}
