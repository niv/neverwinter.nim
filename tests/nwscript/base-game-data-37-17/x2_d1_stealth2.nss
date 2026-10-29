// Henchmen enters stealth mode until the next fight.

void main()
{
      ClearAllActions();
    SetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE", 2);
    DelayCommand(1.0, SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE));
}
