// Henchmen enters stealth mode until the next fight.

void main()
{
    SetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE", 0);
    SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
}
