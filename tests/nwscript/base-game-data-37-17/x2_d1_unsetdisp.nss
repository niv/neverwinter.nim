// Set henchman not to use dispel magic to remove disabling effects from party members

void main()
{
    SetLocalInt(OBJECT_SELF, "X2_HENCH_DO_NOT_DISPEL", 1);
}
