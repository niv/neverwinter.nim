// Henchmen enters stealth mode and return to stealth mode when the fight is over.

void main()
{
    ClearAllActions();
    SetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE", 1);
    DelayCommand(1.0, SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE));
}
