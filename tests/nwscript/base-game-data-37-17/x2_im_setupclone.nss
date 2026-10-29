// Item Appearance Modification Conversation
//////////////////////////////////////////////////////////
// Setup Clone
// Sets up the MockUp model for visual armor modification
// - Make sure you have a waypoint X2_IM_MOCKUPLOC near by
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//////////////////////////////////////////////////////////
#include "x2_inc_craft"

void main()
{
    if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
    {
        object oArmor = GetInventoryDisturbItem();
        object oUser = GetLastDisturbed();
        if(GetIsObjectValid(oArmor) && GetIsObjectValid(oUser))
        {
            if (GetBaseItemType(oArmor)  == BASE_ITEM_ARMOR)
            {

                if ( GetItemFlag(oArmor,ITEM_FLAG_NO_CRAFT_MODIFICATION) == TRUE)
                {
                    SetLocked(OBJECT_SELF,TRUE);
                    AssignCommand(oUser,ClearAllActions());
                    FloatingTextStrRefOnCreature(83889,oUser); // only armor
                    CopyItem(oArmor,oUser);
                    DestroyObject(oArmor);
                    SetLocked(OBJECT_SELF,FALSE);
                }

                /* Setup the mockup*/

                // find a suitable location, either waypoint or on top of PC
                object oMockupLocation = GetNearestObjectByTag("X2_IM_MOCKUPLOC");
                if (oMockupLocation == OBJECT_INVALID)
                {
                    oMockupLocation = oUser;
                }

                //Create Copy of PC
                object oTailor = CopyObject(oUser, GetLocation(oMockupLocation));
                // we need to make him merchant to prevent NPCs from lynching him
                ChangeToStandardFaction(oTailor, STANDARD_FACTION_MERCHANT);
                // Freeze - VFX_DUR_FREEZE_ANIMATIONS - must delay or creature will hover above ground
                effect eFreeze = EffectVisualEffect(352);
                DelayCommand(0.8f,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eFreeze,oTailor));

                // Put some lights on the tailor
                effect       eLight  = EffectVisualEffect( VFX_DUR_LIGHT_WHITE_20);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLight, oTailor);

                //Make invulnerable
                SetPlotFlag(oTailor,TRUE);


                // Remove any item in chest slot if there is one
                object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,oTailor);
                if (oItem != OBJECT_INVALID)
                {
                    DestroyObject(oItem);
                }

                // create backup if the player wants to cancel and store it in IP container
                object oBackup = CopyItem(oArmor,IPGetIPWorkContainer());
                SetLocalObject(oTailor,"X2_TAILOR_BACKUP",oBackup);

                //save item to player
                object oNew = CopyItem(oArmor,oTailor);
                SetLocalString(OBJECT_SELF,"X2_TAILOR_CURRENT_TAG",GetTag(oNew))   ;

                DestroyObject(oArmor,0.1f);

                // add an item which adds all armor feats to the mockup, to allow
                // chars to modify armor they could not wear themselves
                object oRing =GetItemInSlot(INVENTORY_SLOT_LEFTRING,oTailor);
                if (oRing != OBJECT_INVALID)
                {
                    DestroyObject(oRing);
                }
                oRing = IPCreateProficiencyFeatItemOnCreature(oTailor);
                AssignCommand(oTailor,ActionEquipItem(oRing,INVENTORY_SLOT_LEFTRING));


                // Equip the new armor
                AssignCommand(oTailor,ActionEquipItem(oNew,INVENTORY_SLOT_CHEST));
                SetLocalObject(OBJECT_SELF, "X2_TAILOR_OBJ", oTailor);
                AssignCommand(oUser,ClearAllActions(TRUE));

                // Start the armor appearance conversation
                ActionStartConversation(oUser,"",TRUE,FALSE);
                // Default to 0 GP
                SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,"0");
                SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,"0");
                SetLocked(OBJECT_SELF,TRUE);

            }
            else
            {
                SetLocked(OBJECT_SELF,TRUE);
                AssignCommand(oUser,ClearAllActions());
                FloatingTextStrRefOnCreature(83446,oUser); // only armor
                CopyItem(oArmor,oUser);
                DestroyObject(oArmor);
                SetLocked(OBJECT_SELF,FALSE);
            }
       }
    }
}

