// Henchmen is set to not use dispel magic spells to remove disabling effects

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "X2_HENCH_DO_NOT_DISPEL") == 1;
}
