// Remove the flag for henchmen of casting a group of spells.

void main()
{
    SetLocalInt(OBJECT_SELF, "X2_HENCH_GROUP_CASTING", 0);
}
