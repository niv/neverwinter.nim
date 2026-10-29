/* Use a placeable portal. This allows for locks and traps to be
 * placed on the portal.
 *
 * Works for both standard and secret portals. For standard, the tag
 * of the waypoint destination must be set to LOC_<tag of door>.
 * For secret, the waypoint should be set to LOC_<tag of detect trigger>.
 *
 * This goes in the OnUsed event handler of the actual
 * placeable portal object.
 */

#include "x0_i0_secret"

void main()
{
    object oUser = GetLastUsedBy();

    // Allow for traps and locks
    if (GetIsTrapped(OBJECT_SELF)) {return;}
    if (GetLocked(OBJECT_SELF)) {
        // See if we have the key and unlock if so
        string sKey = GetTrapKeyTag(OBJECT_SELF);
        object oKey = GetItemPossessedBy(oUser, sKey);
        if (sKey != "" && GetIsObjectValid(oKey)) {
            SendMessageToPC(oUser, GetStringByStrRef(7945));
            SetLocked(OBJECT_SELF, FALSE);
        } else {
            // Print '*locked*' message and play sound
            DelayCommand(0.1, PlaySound("as_cv_potclang3"));
            FloatingTextStringOnCreature("*" 
                                         + GetStringByStrRef(8307)
                                         + "*",
                                         oUser);
            SendMessageToPC(oUser, GetStringByStrRef(8296));
            return;
        }
    }

    UseSecretTransport(GetLastUsedBy());
}
