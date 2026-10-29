// Flag henchmen as casting a group of spells so the option of casting on all party members
// can be displayed.

void main()
{
    SetLocalInt(OBJECT_SELF, "X2_HENCH_GROUP_CASTING", 1);
}
