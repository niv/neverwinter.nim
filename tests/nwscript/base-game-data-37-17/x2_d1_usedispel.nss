// Henchman uses dispel magic spells to remove disabling effects from party members

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "X2_HENCH_DO_NOT_DISPEL") == 0;
}
