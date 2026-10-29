// returns TRUE when the henchmen is casting group spells so this option is only displayed for this
// kind of casting.

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "X2_HENCH_GROUP_CASTING") == 1;
}
