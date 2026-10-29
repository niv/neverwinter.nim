// TRUE if henchmen is in stealth mode.

int StartingConditional()
{
    return (GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == TRUE);
}
