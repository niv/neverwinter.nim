// * click on me and you shall sit
void main()
{
    object oSelf = OBJECT_SELF;
    AssignCommand(GetLastUsedBy(), ActionSit(oSelf));
}
