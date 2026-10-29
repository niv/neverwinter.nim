// * Hack. In the script at the end of random party
// * banter I set this to 100. To prevent this from firing.
// * once a character has started speaking, its really difficult
// * to make them not speak. So instead, I make it so this, the
// * the generic, almost always true response won't show up in the
// * case of *failed* party banter. (x0_d2_hen_master checks this value)
int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "X2_PLEASE_NO_TALKING") == 100)
    {
        SetLocalInt(OBJECT_SELF, "X2_PLEASE_NO_TALKING", 0);
        return FALSE;
    }
        SetLocalInt(OBJECT_SELF, "X2_PLEASE_NO_TALKING", 0);

    return TRUE;
}
