//:://////////////////////////////////////////////////
//:: X0_ONITEMACTV
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Common script to be used as OnActivateItem script for
all modules. Executes the script with a name matching
the tag of the item being activated. Functions like
GetItemActivator() and GetItemActivatedTarget() will 
work in these scripts, since they are being executed
from the perspective of the module itself. ???

Credit for this idea belongs to tjm, who posted it to
nwvault.ign.com. 

 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/27/2002
//:://////////////////////////////////////////////////

void main()
{
    ExecuteScript(GetTag(GetItemActivated()), OBJECT_SELF);
}
