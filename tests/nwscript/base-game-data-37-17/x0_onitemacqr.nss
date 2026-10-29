//:://////////////////////////////////////////////////
//:: X0_ONITEMACQR
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Common script to be used as OnAcquireItem script for
all modules. Executes the script with a name matching
the tag of the item being activated, plus the suffix
"_aq".

Based on tjm's idea for OnActivateItem, posted to
nwvault.ign.com.

 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/27/2002
//:://////////////////////////////////////////////////

void main()
{
    ExecuteScript(GetTag(GetModuleItemAcquired()) + "_aq", OBJECT_SELF);
}
