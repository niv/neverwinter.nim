//------------------------------------------------------------------------------
//   x2_inc_switches::   Interface for switching subsystem functionality
//------------------------------------------------------------------------------
/*
   This file provides a basic interface for switching different Hordes of
   the Underdark subsystems on/off  and allows centralized access to certain
   "expert"  functionality like overriding AI or Spellscripts.

   Changing any of these switches from their default position is considered
   unsupported and done at your own risk - please do NOT send any bug reports
   about problems caused by these switches.
*/
//------------------------------------------------------------------------------
// Copyright (c) 2003 Bioware Corp. * Created By: Georg Zoeller * On: 2003-07-16
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//                                    M O D U L E
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// * Force Use Magic Device Skillchecks, Default = FALSE except for GAME_DIFFICULTY_CORE_RULES+
// * If switched to TRUE, a rogue has to succeed in a UMD check against DC 25+SpellLevel
// * in order to use a scroll. See x2_pc_umdcheck.nss for details
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_UMD_SCROLLS    = "X2_SWITCH_ENABLE_UMD_SCROLLS";

//------------------------------------------------------------------------------
// * Toggle on/off the Item Creation Feats, Default = O
// * Disable the Item Creation Feats that come with Hordes of the Underdark for the
// * module.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_DISABLE_ITEM_CREATION_FEATS    = "X2_SWITCH_DISABLE_ITEMCREATION_FEATS";

//------------------------------------------------------------------------------
// * Toggle Area of Effect Spell behaviour
// * If set to TRUE, AOE Spells will hurt NPCS that are neutral to the caster if they are
// * caught in the effect
//------------------------------------------------------------------------------
const string MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS = "X0_G_ALLOWSPELLSTOHURT";

//------------------------------------------------------------------------------
// * For balancing reasons the crafting system will create 50 charges on a new wand
// * instead it will create 10 + casterlevel charges. if you want to be "hard core rules compliant"
// * 50 charges, enable thiis switch
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_CRAFT_WAND_50_CHARGES    = "X2_SWITCH_ENABLE_50_WAND_CHARGES";

//------------------------------------------------------------------------------
// * Some epic spells, namely Hellball, do damage to the caster. We found this too confusing
// * in testing, so it was disabled. You can reactivate using this flag
//------------------------------------------------------------------------------
const string MODULE_SWITCH_EPIC_SPELLS_HURT_CASTER = "X2_SWITCH_EPIC_SPELLS_HURT_CASTER";

//------------------------------------------------------------------------------// * Deathless master touch is not supposed to affect creatures of size > large
// * but we do not check this condition by default to balance the fact that the slain
// * creature is not raised under the command of the pale master.
// * by setting this switch to TRUE, the ability will no longer effect creatures of
// * huge+ size.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_SPELL_CORERULES_DMASTERTOUCH = "X2_SWITCH_SPELL_CORERULE_DMTOUCH";

//------------------------------------------------------------------------------
// * By default, all characters can use the various poisons that can be found to poison their weapons if
// * they win a Dex check. Activating this flag will restrict the use of poison to chars with the UsePoison
// * feat only
//------------------------------------------------------------------------------
const string MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT = "X2_SWITCH_RESTRICT_USE_POISON_FEAT";

//------------------------------------------------------------------------------
// * Multiple Henchmen: By default, henchmen will never damage each other with AoE spells.
// * By activating this switch, henchmen will be able to damage each other with AoE spells
// * and potentially go on each other's throats.
// * Warning: Activating this switch has the potential of introducing game breaking bugs. Do
// *          not use on the official SoU campaign. Use at your own risk. Really, its dangerous!
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE = "X2_SWITCH_MULTI_HENCH_AOE_MADNESS";

//------------------------------------------------------------------------------
// * Spell Targeting: Pre Hordes of the underdark, in hardcore mode, creatures would not hurt each other
// * with their AOE spells if they were no PCs. Setting this switch to true, will activate the correct
// * behaviour. Activating this on older modules can break things, unless you know what you are doing!
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES = "X2_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES";

//------------------------------------------------------------------------------
// * If set to TRUE, the Bebilith Ruin Armor ability is going to actually destroy
// * the armor it hits. Would be very annoying for players...
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_BEBILITH_RUIN_ARMOR = "X2_SWITCH_BEBILITH_HARDCORE_RUIN_ARMOR";

//------------------------------------------------------------------------------
// * Setting this switch to TRUE will make the Glyph of warding symbol disappear after 6 seconds, but
// * the glyph will stay active....
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING = "X2_SWITCH_GLYPH_OF_WARDING_INVISIBLE";

//------------------------------------------------------------------------------
// * Setting this switch to TRUE will enable the allow NPCs running between waypoints using the WalkWaypoints
// * function to cross areas, like they did in the original NWN. This was changed in 1.30 to use only
// * waypoints in one area.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS = "X2_SWITCH_CROSSAREA_WALKWAYPOINTS";

//------------------------------------------------------------------------------
// * Setting this switch to TRUE will disable the glow of a newly found secret door
// * used in some locations in XP2
//------------------------------------------------------------------------------
const string MODULE_SWITCH_DISABLE_SECRET_DOOR_FLASH = "X2_SWITCH_DISABLE_SECRET_DOOR_FLASH";

//------------------------------------------------------------------------------
// * Setting this switch to TRUE will disable execution of tagbased scripts that are enabled
// * by default when using the standard module events (x2_mod_def_*)
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS = "X2_SWITCH_ENABLE_TAGBASED_SCRIPTS";

//------------------------------------------------------------------------------
// * Setting thsi switch to TRUE will enable the XP2 Wandering Monster System
// * for this module (if you are using the default rest script and you have set
// * up the correct variables for each area
//------------------------------------------------------------------------------
const string MODULE_SWITCH_USE_XP2_RESTSYSTEM = "X2_SWITCH_ENABLE_XP2_RESTSYSTEM";

//------------------------------------------------------------------------------
// * if this variable is set, the AI will not use Dispel Magic against harmfull AOE
// * spells.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_DISABLE_AI_DISPEL_AOE = "X2_L_AI_NO_AOE_DISPEL";

//------------------------------------------------------------------------------
// * Setting this variable to TRUE on the module will disable the call to the
// * random loot generation in most creatures' OnSpawn script.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_NO_RANDOM_MONSTER_LOOT = "X2_L_NOTREASURE";

//------------------------------------------------------------------------------
//                             M I S C
//------------------------------------------------------------------------------
const string MODULE_VAR_OVERRIDE_SPELLSCRIPT ="X2_S_UD_SPELLSCRIPT";

const string MODULE_VAR_TAGBASED_SCRIPT_PREFIX ="X2_S_UD_SPELLSCRIPT";

//------------------------------------------------------------------------------
// * Variable that holds the wandering monster 2da filename
//------------------------------------------------------------------------------
const string MODULE_VAR_WANDERING_MONSTER_2DA ="X2_WM_2DA_NAME";

//------------------------------------------------------------------------------
// * This variable allows to specify a % for NOT using dispel magic against AOEs
// instead fleeing
//------------------------------------------------------------------------------
const string MODULE_VAR_AI_NO_DISPEL_AOE_CHANCE = "X2_L_AI_AOE_DISPEL_CHANCE";

//------------------------------------------------------------------------------
// * Setting this variable to TRUE will cause the Expertise/Improved Expertise
// * modes to be disabled whenever a player is casting a spell.
//------------------------------------------------------------------------------
const string MODULE_VAR_AI_STOP_EXPERTISE_ABUSE = "X2_L_STOP_EXPERTISE_ABUSE";


//------------------------------------------------------------------------------
//                             C R E A T U R E S
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// * see x2_ai_demo for details
//------------------------------------------------------------------------------
const string CREATURE_VAR_CUSTOM_AISCRIPT = "X2_SPECIAL_COMBAT_AI_SCRIPT";


//------------------------------------------------------------------------------
// * Setting this variable on a creature will make its use a
// * random name.
// * see nw_c2_default9 for details.
//------------------------------------------------------------------------------
const string CREATURE_VAR_RANDOMIZE_NAME = "X2_NAME_RANDOM";

//------------------------------------------------------------------------------
// * Setting this variable on a spellcaster creature will make its spelluse a
// * bit more random, but their spell selection may not always be appropriate
// * to the situation anymore.
//------------------------------------------------------------------------------
const string CREATURE_VAR_RANDOMIZE_SPELLUSE = "X2_SPELL_RANDOM";

//------------------------------------------------------------------------------
// * Set to 1 to make the creature activate stealth mode after spawn
//------------------------------------------------------------------------------
const string CREATURE_VAR_USE_SPAWN_STEALTH = "X2_L_SPAWN_USE_STEALTH";

//------------------------------------------------------------------------------
// * Set to 1 to make the creature activate detectmode after spawn
//------------------------------------------------------------------------------
const string CREATURE_VAR_USE_SPAWN_SEARCH = "X2_L_SPAWN_USE_SEARCH";

//------------------------------------------------------------------------------
// * Set to 1 to make the creature play mobile ambient animations after spawn
//------------------------------------------------------------------------------
const string CREATURE_VAR_USE_SPAWN_AMBIENT = "X2_L_SPAWN_USE_AMBIENT";

//------------------------------------------------------------------------------
// * Set to 1 to make the creature play immobile ambient animations after spawn
//------------------------------------------------------------------------------
const string CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE = "X2_L_SPAWN_USE_AMBIENT_IMMOBILE";

//------------------------------------------------------------------------------
// * Set to 1 to make the creature immune to dispel magic (used for statues)
//------------------------------------------------------------------------------
const string CREATURE_VAR_IMMUNE_TO_DISPEL = "X1_L_IMMUNE_TO_DISPEL";

//------------------------------------------------------------------------------
// * Set this variable to 1 on a creature to make it walk through other creatures
//------------------------------------------------------------------------------
const string CREATURE_VAR_IS_INCORPOREAL = "X2_L_IS_INCORPOREAL";

//------------------------------------------------------------------------------
// * Set this variable to 1 - 6 to override the number of attacks a creature has based on its BAB
//------------------------------------------------------------------------------
const string CREATURE_VAR_NUMBER_OF_ATTACKS = "X2_L_NUMBER_OF_ATTACKS";

//------------------------------------------------------------------------------
// * The value of this variable (int) is added to the chance that a creature
// * will use magic in combat. Set to 100 for always, 0 for never
//------------------------------------------------------------------------------
const string CREATURE_AI_MODIFIED_MAGIC_RATE = "X2_L_BEH_MAGIC";

//------------------------------------------------------------------------------
// * The higher value of this variable, the higher the chance that the creature
// * will use offensive abilities in combat. Set to 0 to make them flee.
//------------------------------------------------------------------------------
const string CREATURE_AI_MODIFIED_OFFENSE_RATE = "X2_L_BEH_OFFENSE";

//------------------------------------------------------------------------------
// * The higher value of this variable, the higher the chance that the creature
// * will aid friendly creatures in combat. Not that helping usually degrades
// * the overall difficulty of an encounter, but makes it more interesting.
//------------------------------------------------------------------------------
const string CREATURE_AI_MODIFIED_COMPASSION_RATE = "X2_L_BEH_COMPASSION";

//------------------------------------------------------------------------------
// * This allows you to script items that enhance a palemaster's summoned creatures. You need
// * to put the name of a script into this variable that will be run on any creature called by
// * the pale master's summon undead ability. You can use this script to add effects to the creature.
// * You can use the OnEquip/OnUnEquip event hooks set this variable.
//------------------------------------------------------------------------------
const string CREATURE_VAR_PALE_MASTER_SPECIAL_ITEM = "X2_S_PM_SPECIAL_ITEM";


//------------------------------------------------------------------------------
// These constants define item messages that are routed to script files with
// the item tag's through the default XP2 module scripts.
//------------------------------------------------------------------------------
const int X2_ITEM_EVENT_ACTIVATE = 0;
const int X2_ITEM_EVENT_EQUIP = 1;
const int X2_ITEM_EVENT_UNEQUIP = 2;
const int X2_ITEM_EVENT_ONHITCAST = 3;
const int X2_ITEM_EVENT_ACQUIRE = 4;
const int X2_ITEM_EVENT_UNACQUIRE = 5;
const int X2_ITEM_EVENT_SPELLCAST_AT = 6;

const int X2_EXECUTE_SCRIPT_CONTINUE =0;
const int X2_EXECUTE_SCRIPT_END =1;

// Set the active User Defined Item Event
// X2_ITEM_EVENT_ACTIVATE
// X2_ITEM_EVENT_EQUIP
// X2_ITEM_EVENT_UNEQUIP
// X2_ITEM_EVENT_ONHITCAST
// X2_ITEM_EVENT_ACQUIRE
// X2_ITEM_EVENT_UNACQUIRE
// X2_ITEM_EVENT_SPELLCAST_AT
void SetUserDefinedItemEventNumber(int nEvent);

// Get the active User Defined Item Event
// X2_ITEM_EVENT_ACTIVATE
// X2_ITEM_EVENT_EQUIP
// X2_ITEM_EVENT_UNEQUIP
// X2_ITEM_EVENT_ONHITCAST
// X2_ITEM_EVENT_ACQUIRE
// X2_ITEM_EVENT_UNACQUIRE
// X2_ITEM_EVENT_SPELLCAST_AT
int GetUserDefinedItemEventNumber();

//------------------------------------------------------------------------------
// * Used to switch between different rule implementations or to subsystems for the game
// * see x2_inc_switches for more detailed information on these constants
//------------------------------------------------------------------------------
void SetModuleSwitch(string sModuleSwitchConstant,int bValue);

//------------------------------------------------------------------------------
// * Returns the value of a module switch
//------------------------------------------------------------------------------
int GetModuleSwitchValue(string  sModuleSwitchConstant);

//------------------------------------------------------------------------------
//                                D O O R S
//------------------------------------------------------------------------------
const string DOOR_FLAG_RESIST_KNOCK = "X2_FLAG_DOOR_RESIST_KNOCK";

//------------------------------------------------------------------------------
// * Used to toggle custom flags on a door
// * oDoor - Door to set the switch on
// * Valid values for sDoorFlagConstant:
// * X2_FLAG_DOOR_RESIST_KNOCK -
// *        Set to 1 to prevent knock from working with feedback.
// *        Set to 2 to prevent knock from working without feedback
//------------------------------------------------------------------------------
void SetDoorFlag(object oDoor, string sDoorFlagConstant, int nValue);
int GetDoorFlag(object oDoor, string  sDoorFlagConstant);

//------------------------------------------------------------------------------
//                           W A Y P O I N T S
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// * By setting this variable to 1 on a waypoint, a creature using this
// * waypoint as part of its WalkWaypoints routine will assume the facing
// * of the waypoint upon reaching it.
//------------------------------------------------------------------------------
const string  WAYPOINT_VAR_FORCE_SETFACING = "X2_L_WAYPOINT_SETFACING";

//------------------------------------------------------------------------------
//                           I T E M S
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// NOTE: THIS NO LONGER WORKS. TO PREVENT MODIFICATION USE THE PLOT FLAG
//------------------------------------------------------------------------------
const string ITEM_FLAG_NO_CRAFT_MODIFICATION = "X2_FLAG_ITEM_CRAFT_DO_NOT_MODIFY";
void SetItemFlag(object oItem, string sItemFlagConstant, int nValue);
int GetItemFlag(object oItem, string  sItemFlagConstant);

//------------------------------------------------------------------------------
// * Execute sScript on oTarget returning an integer.
// * Do not nest this function
//------------------------------------------------------------------------------
int ExecuteScriptAndReturnInt(string sScript, object oTarget);

//------------------------------------------------------------------------------
// * Sets the return value for scripts called via ExecuteScriptAndReturnInt
// * valid values are
// * X2_EXECUTE_SCRIPT_CONTINUE - continue calling script after executed scriptis done
// * X2_EXECUTE_SCRIPT_END - end calling script after executed script is done
//------------------------------------------------------------------------------
void  SetExecutedScriptReturnValue(int nValue = X2_EXECUTE_SCRIPT_END);

//------------------------------------------------------------------------------
// * This is a security feature. If you are running a *local vault* server and you
// * have tag based script execution enabled, people could bring items into your
// * game that execute existing scripts. You can set a script prefix here to
// * prevent that. Note that you have to add this prefix to your item scripts in
// * the module to make them work.
//------------------------------------------------------------------------------
void SetUserDefinedItemEventPrefix(string sPrefix="");

//------------------------------------------------------------------------------
//                          S P E L L S C R I P T S
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Allows the module creator to specify a script that will be run before any spellscript is run
// You can call SetModuleOverrideSpellscript() at the end of the script specified by
// sScriptName. If you call this function this will prevent the original spellscript
// (and all craft item code) from being executed.
// If you do not add this line, the original spellscript and/or crafting code will
// run in addition to your script
//------------------------------------------------------------------------------
void SetModuleOverrideSpellscript(string sScriptName);

//------------------------------------------------------------------------------
//                             C R E A T U R E S
//------------------------------------------------------------------------------

void SetCreatureFlag(object oCreature, string sFlag, int nValue);
int  GetCreatureFlag(object oCreature, string sFlag);

//------------------------------------------------------------------------------
// * Define a replacement script for DetermineCombatRound
// * See x2_ai_demo for details
//------------------------------------------------------------------------------
void SetCreatureOverrideAIScript(object oCreature, string sScriptName);

//------------------------------------------------------------------------------
// * Call this at end of your custom override AI script set via CREATURE_VAR_CUSTOM_AISCRIPT
// * See x2_ai_demo for details.
//------------------------------------------------------------------------------
void   SetCreatureOverrideAIScriptFinished(object oCreature = OBJECT_SELF);
void   ClearCreatureOverrideAIScriptTarget(object oCreature = OBJECT_SELF);
object GetCreatureOverrideAIScriptTarget(object oCreature = OBJECT_SELF);

//------------------------------------------------------------------------------
// * Define the name of the 2da file which is used for the wandering monster
// * system
//------------------------------------------------------------------------------
void SetWanderingMonster2DAFile(string s2DAName = "des_restsystem");



//----------------------------------------------------------------------------
// Interface to switch on / off specific  subsystems or behaviors
// Check X2_INC_SWITCHES.NSS for details
//----------------------------------------------------------------------------
void SetModuleSwitch(string sModuleSwitchConstant,int bValue)
{
    if (bValue == 0)
    {
        DeleteLocalInt (GetModule(),sModuleSwitchConstant);
        return;
    } else if ((sModuleSwitchConstant) == MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS && bValue == TRUE)
    {
      bValue = 10;
    }
    SetLocalInt (GetModule(),sModuleSwitchConstant, bValue);
}

//----------------------------------------------------------------------------
// Return the value of a module switch set by SetModuleSwitch
// See X2_INC_SWITCHES for a list of all module switches
//----------------------------------------------------------------------------
int GetModuleSwitchValue(string  sModuleSwitchConstant)
{
    int nRet =  GetLocalInt (GetModule(),sModuleSwitchConstant);
    return nRet;
}

void SetDoorFlag(object oDoor, string sDoorFlagConstant, int nValue)
{
    if (nValue == 0)
    {
        DeleteLocalInt (oDoor,sDoorFlagConstant);
        return;
    }
    SetLocalInt (oDoor,sDoorFlagConstant, nValue);
}

int GetDoorFlag(object oDoor, string  sDoorFlagConstant)
{
    int nRet =  GetLocalInt (oDoor,sDoorFlagConstant);
    return nRet;
}

void SetItemFlag(object oItem, string sItemFlagConstant, int nValue)
{
    if (nValue == 0)
    {
        DeleteLocalInt (oItem,sItemFlagConstant);
        return;
    }
    SetLocalInt (oItem,sItemFlagConstant, nValue);
}

int GetItemFlag(object oItem, string  sItemFlagConstant)
{
    int nRet =  GetLocalInt (oItem,sItemFlagConstant);
    return nRet;
}

void SetModuleOverrideSpellscript(string sScriptName)
{
    SetLocalString(GetModule(),MODULE_VAR_OVERRIDE_SPELLSCRIPT,sScriptName);
}

string GetModuleOverrideSpellscript()
{
     string  sScript = GetLocalString(GetModule(),"X2_S_UD_SPELLSCRIPT");
     return sScript;
}

//------------------------------------------------------------------------------
// You can call this in our overridden spellscript. If you call this
// this will prevent the original spellscript (and all craft item code)
// from being executed. If you do not add this line, the original spellscript
// and/or crafting code will run in addition to your script
//------------------------------------------------------------------------------
void SetModuleOverrideSpellScriptFinished()
{
    SetLocalInt(OBJECT_SELF,"X2_L_BLOCK_LAST_SPELL",TRUE);
}

int GetModuleOverrideSpellScriptFinished()
{
    int nRet = GetLocalInt(OBJECT_SELF,"X2_L_BLOCK_LAST_SPELL");
    DeleteLocalInt(OBJECT_SELF,"X2_L_BLOCK_LAST_SPELL");
    return nRet;
}

void SetCreatureOverrideAIScript(object oCreature, string sScriptName)
{
    SetLocalString(oCreature,CREATURE_VAR_CUSTOM_AISCRIPT,sScriptName);
}

void SetCreatureOverrideAIScriptFinished(object oCreature = OBJECT_SELF)
{
 //   WriteTimestampedLogEntry("Custom AI Finished");
    SetLocalInt(oCreature,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK",TRUE);
}

object GetCreatureOverrideAIScriptTarget(object oCreature = OBJECT_SELF)
{
    object oRet= GetLocalObject(oCreature,"X2_NW_I0_GENERIC_INTRUDER");
    return oRet;
}

void ClearCreatureOverrideAIScriptTarget(object oCreature = OBJECT_SELF)
{
    DeleteLocalObject(oCreature,"X2_NW_I0_GENERIC_INTRUDER");
}

void SetCreatureFlag(object oCreature, string sFlag, int nValue)
{
    if (sFlag == CREATURE_VAR_IMMUNE_TO_DISPEL)
    {
        if (nValue != 0)
        {
            nValue = 10;
        }
    }

    SetLocalInt(oCreature,sFlag ,nValue);
}

int GetCreatureFlag(object oCreature, string sFlag)
{
    int nRet = GetLocalInt(oCreature,sFlag);
    return nRet;
}

//----------------------------------------------------------------------------
// Get the current UserDefined Item Event Number
// X2_ITEM_EVENT_ACTIVATE
// X2_ITEM_EVENT_EQUIP
// X2_ITEM_EVENT_UNEQUIP
// X2_ITEM_EVENT_ONHITCAST
// X2_ITEM_EVENT_ACQUIRE
// X2_ITEM_EVENT_UNACQUIRE
// X2_ITEM_EVENT_SPELLCAST_AT
//----------------------------------------------------------------------------
int GetUserDefinedItemEventNumber()
{
    return GetLocalInt(OBJECT_SELF,"X2_L_LAST_ITEM_EVENT");
}

//----------------------------------------------------------------------------
// Set the current UserDefined Item Event Number
// X2_ITEM_EVENT_ACTIVATE
// X2_ITEM_EVENT_EQUIP
// X2_ITEM_EVENT_UNEQUIP
// X2_ITEM_EVENT_ONHITCAST
// X2_ITEM_EVENT_ACQUIRE
// X2_ITEM_EVENT_UNACQUIRE
// X2_ITEM_EVENT_SPELLCAST_AT
//----------------------------------------------------------------------------
void SetUserDefinedItemEventNumber(int nEvent)
{
    SetLocalInt(OBJECT_SELF,"X2_L_LAST_ITEM_EVENT",nEvent);
}

//----------------------------------------------------------------------------
// Returns the name for the User Defined Item Event script for oItem,
// including possible prefixes configured by SetUserDefinedItemEventPrefix
//----------------------------------------------------------------------------
string GetUserDefinedItemEventScriptName(object oItem)
{
    string sPrefix = GetLocalString(GetModule(),"MODULE_VAR_TAGBASED_SCRIPT_PREFIX");
    string sTag = sPrefix + GetTag(oItem);
    return sTag;
}

//----------------------------------------------------------------------------
// You can define a prefix for any User Defined Item Event here, to prevent
// people from executing scripts you do not like them to execute on your
// local vault server
//----------------------------------------------------------------------------
void SetUserDefinedItemEventPrefix(string sPrefix="")
{
    SetLocalString(GetModule(),"MODULE_VAR_TAGBASED_SCRIPT_PREFIX",sPrefix);
}

//----------------------------------------------------------------------------
// Wrapper for Execute Script to execute a script and get an integer
// return value. Do not nest this function!
//----------------------------------------------------------------------------
int ExecuteScriptAndReturnInt(string sScript, object oTarget)
{
    DeleteLocalInt(oTarget,"X2_L_LAST_RETVAR");
    ExecuteScript(sScript,oTarget);
    int nRet = GetLocalInt(oTarget,"X2_L_LAST_RETVAR");
    DeleteLocalInt(oTarget,"X2_L_LAST_RETVAR");
    return nRet;
}

//----------------------------------------------------------------------------
// Helper function for ExecuteScriptAndReturnInt
//----------------------------------------------------------------------------
void  SetExecutedScriptReturnValue(int nValue = X2_EXECUTE_SCRIPT_CONTINUE)
{
    SetLocalInt(OBJECT_SELF,"X2_L_LAST_RETVAR",nValue);
}

//----------------------------------------------------------------------------
// Define the name of the 2da file which is used for the wandering monster
// system
//----------------------------------------------------------------------------
void SetWanderingMonster2DAFile(string s2DAName = "des_restsystem")
{
    SetLocalString(OBJECT_SELF,MODULE_VAR_WANDERING_MONSTER_2DA,s2DAName);
}
