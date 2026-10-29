////////////////////////////////////////////////////////
//
//  NWScript
//
//  The list of actions and pre-defined constants.
//
//  (c) BioWare Corp, 1999
//
////////////////////////////////////////////////////////

#define ENGINE_NUM_STRUCTURES   8
#define ENGINE_STRUCTURE_0      effect
#define ENGINE_STRUCTURE_1      event
#define ENGINE_STRUCTURE_2      location
#define ENGINE_STRUCTURE_3      talent
#define ENGINE_STRUCTURE_4      itemproperty
#define ENGINE_STRUCTURE_5      sqlquery
#define ENGINE_STRUCTURE_6      cassowary
#define ENGINE_STRUCTURE_7      json

// Constants

int    NUM_INVENTORY_SLOTS      = 18;

int    TRUE                     = 1;
int    FALSE                    = 0;

float  DIRECTION_EAST           = 0.0;
float  DIRECTION_NORTH          = 90.0;
float  DIRECTION_WEST           = 180.0;
float  DIRECTION_SOUTH          = 270.0;
float  PI                       = 3.141592;

int    ATTITUDE_NEUTRAL         = 0;
int    ATTITUDE_AGGRESSIVE      = 1;
int    ATTITUDE_DEFENSIVE       = 2;
int    ATTITUDE_SPECIAL         = 3;

int    TALKVOLUME_TALK          = 0;
int    TALKVOLUME_WHISPER       = 1;
int    TALKVOLUME_SHOUT         = 2;
int    TALKVOLUME_SILENT_TALK   = 3;
int    TALKVOLUME_SILENT_SHOUT  = 4;
int    TALKVOLUME_PARTY         = 5;
int    TALKVOLUME_TELL          = 6;

int    INVENTORY_SLOT_HEAD      = 0;
int    INVENTORY_SLOT_CHEST     = 1;
int    INVENTORY_SLOT_BOOTS     = 2;
int    INVENTORY_SLOT_ARMS      = 3;
int    INVENTORY_SLOT_RIGHTHAND = 4;
int    INVENTORY_SLOT_LEFTHAND  = 5;
int    INVENTORY_SLOT_CLOAK     = 6;
int    INVENTORY_SLOT_LEFTRING  = 7;
int    INVENTORY_SLOT_RIGHTRING = 8;
int    INVENTORY_SLOT_NECK      = 9;
int    INVENTORY_SLOT_BELT      = 10;
int    INVENTORY_SLOT_ARROWS    = 11;
int    INVENTORY_SLOT_BULLETS   = 12;
int    INVENTORY_SLOT_BOLTS     = 13;
int    INVENTORY_SLOT_CWEAPON_L = 14;
int    INVENTORY_SLOT_CWEAPON_R = 15;
int    INVENTORY_SLOT_CWEAPON_B = 16;
int    INVENTORY_SLOT_CARMOUR   = 17;

//Effect type constants
int    DURATION_TYPE_INSTANT    = 0;
int    DURATION_TYPE_TEMPORARY  = 1;
int    DURATION_TYPE_PERMANENT  = 2;

int    SUBTYPE_MAGICAL          = 8;
int    SUBTYPE_SUPERNATURAL     = 16;
int    SUBTYPE_EXTRAORDINARY    = 24;
int    SUBTYPE_UNYIELDING       = 32;

int    ABILITY_STRENGTH         = 0; // should be the same as in nwseffectlist.cpp
int    ABILITY_DEXTERITY        = 1;
int    ABILITY_CONSTITUTION     = 2;
int    ABILITY_INTELLIGENCE     = 3;
int    ABILITY_WISDOM           = 4;
int    ABILITY_CHARISMA         = 5;

int    SHAPE_SPELLCYLINDER      = 0;
int    SHAPE_CONE               = 1;
int    SHAPE_CUBE               = 2;
int    SHAPE_SPELLCONE          = 3;
int    SHAPE_SPHERE             = 4;

int    METAMAGIC_NONE           = 0;
int    METAMAGIC_EMPOWER        = 1;
int    METAMAGIC_EXTEND         = 2;
int    METAMAGIC_MAXIMIZE       = 4;
int    METAMAGIC_QUICKEN        = 8;
int    METAMAGIC_SILENT         = 16;
int    METAMAGIC_STILL          = 32;
int    METAMAGIC_ANY            = 255;

int    OBJECT_TYPE_CREATURE         = 1;
int    OBJECT_TYPE_ITEM             = 2;
int    OBJECT_TYPE_TRIGGER          = 4;
int    OBJECT_TYPE_DOOR             = 8;
int    OBJECT_TYPE_AREA_OF_EFFECT   = 16;
int    OBJECT_TYPE_WAYPOINT         = 32;
int    OBJECT_TYPE_PLACEABLE        = 64;
int    OBJECT_TYPE_STORE            = 128;
int    OBJECT_TYPE_ENCOUNTER        = 256;
int    OBJECT_TYPE_TILE             = 512;
int    OBJECT_TYPE_ALL              = 32767;

int    OBJECT_TYPE_INVALID          = 32767;

int    GENDER_MALE    = 0;
int    GENDER_FEMALE  = 1;
int    GENDER_BOTH    = 2;
int    GENDER_OTHER   = 3;
int    GENDER_NONE    = 4;

int    DAMAGE_TYPE_BLUDGEONING  = 1;
int    DAMAGE_TYPE_PIERCING     = 2;
int    DAMAGE_TYPE_SLASHING     = 4;
int    DAMAGE_TYPE_MAGICAL      = 8;
int    DAMAGE_TYPE_ACID         = 16;
int    DAMAGE_TYPE_COLD         = 32;
int    DAMAGE_TYPE_DIVINE       = 64;
int    DAMAGE_TYPE_ELECTRICAL   = 128;
int    DAMAGE_TYPE_FIRE         = 256;
int    DAMAGE_TYPE_NEGATIVE     = 512;
int    DAMAGE_TYPE_POSITIVE     = 1024;
int    DAMAGE_TYPE_SONIC        = 2048;
// The base weapon damage is the base damage delivered by the weapon before
// any additional types of damage (e.g. fire) have been added.
int    DAMAGE_TYPE_BASE_WEAPON  = 4096;
int    DAMAGE_TYPE_CUSTOM1      = 8192;
int    DAMAGE_TYPE_CUSTOM2      = 16384;
int    DAMAGE_TYPE_CUSTOM3      = 32768;
int    DAMAGE_TYPE_CUSTOM4      = 65536;
int    DAMAGE_TYPE_CUSTOM5      = 131072;
int    DAMAGE_TYPE_CUSTOM6      = 262144;
int    DAMAGE_TYPE_CUSTOM7      = 524288;
int    DAMAGE_TYPE_CUSTOM8      = 1048576;
int    DAMAGE_TYPE_CUSTOM9      = 2097152;
int    DAMAGE_TYPE_CUSTOM10     = 4194304;
int    DAMAGE_TYPE_CUSTOM11     = 8388608;
int    DAMAGE_TYPE_CUSTOM12     = 16777216;
int    DAMAGE_TYPE_CUSTOM13     = 33554432;
int    DAMAGE_TYPE_CUSTOM14     = 67108864;
int    DAMAGE_TYPE_CUSTOM15     = 134217728;
int    DAMAGE_TYPE_CUSTOM16     = 268435456;
int    DAMAGE_TYPE_CUSTOM17     = 536870912;
int    DAMAGE_TYPE_CUSTOM18     = 1073741824;
int    DAMAGE_TYPE_CUSTOM19     = 2147483648;

// Special versus flag just for AC effects
int    AC_VS_DAMAGE_TYPE_ALL    = 4103;

int    DAMAGE_BONUS_1           = 1;
int    DAMAGE_BONUS_2           = 2;
int    DAMAGE_BONUS_3           = 3;
int    DAMAGE_BONUS_4           = 4;
int    DAMAGE_BONUS_5           = 5;
int    DAMAGE_BONUS_1d4         = 6;
int    DAMAGE_BONUS_1d6         = 7;
int    DAMAGE_BONUS_1d8         = 8;
int    DAMAGE_BONUS_1d10        = 9;
int    DAMAGE_BONUS_2d6         = 10;
int    DAMAGE_BONUS_2d8         = 11;
int    DAMAGE_BONUS_2d4         = 12;
int    DAMAGE_BONUS_2d10        = 13;
int    DAMAGE_BONUS_1d12        = 14;
int    DAMAGE_BONUS_2d12        = 15;
int    DAMAGE_BONUS_6           = 16;
int    DAMAGE_BONUS_7           = 17;
int    DAMAGE_BONUS_8           = 18;
int    DAMAGE_BONUS_9           = 19;
int    DAMAGE_BONUS_10          = 20;
int    DAMAGE_BONUS_11          = 21;
int    DAMAGE_BONUS_12          = 22;
int    DAMAGE_BONUS_13          = 23;
int    DAMAGE_BONUS_14          = 24;
int    DAMAGE_BONUS_15          = 25;
int    DAMAGE_BONUS_16          = 26;
int    DAMAGE_BONUS_17          = 27;
int    DAMAGE_BONUS_18          = 28;
int    DAMAGE_BONUS_19          = 29;
int    DAMAGE_BONUS_20          = 30;

int    DAMAGE_POWER_NORMAL         = 0;
int    DAMAGE_POWER_PLUS_ONE       = 1;
int    DAMAGE_POWER_PLUS_TWO       = 2;
int    DAMAGE_POWER_PLUS_THREE     = 3;
int    DAMAGE_POWER_PLUS_FOUR      = 4;
int    DAMAGE_POWER_PLUS_FIVE      = 5;
int    DAMAGE_POWER_ENERGY         = 6;
int    DAMAGE_POWER_PLUS_SIX       = 7;
int    DAMAGE_POWER_PLUS_SEVEN     = 8;
int    DAMAGE_POWER_PLUS_EIGHT     = 9;
int    DAMAGE_POWER_PLUS_NINE      = 10;
int    DAMAGE_POWER_PLUS_TEN       = 11;
int    DAMAGE_POWER_PLUS_ELEVEN    = 12;
int    DAMAGE_POWER_PLUS_TWELVE    = 13;
int    DAMAGE_POWER_PLUS_THIRTEEN  = 14;
int    DAMAGE_POWER_PLUS_FOURTEEN  = 15;
int    DAMAGE_POWER_PLUS_FIFTEEN   = 16;
int    DAMAGE_POWER_PLUS_SIXTEEN   = 17;
int    DAMAGE_POWER_PLUS_SEVENTEEN = 18;
int    DAMAGE_POWER_PLUS_EIGHTEEN  = 19;
int    DAMAGE_POWER_PLUS_NINTEEN   = 20;
int    DAMAGE_POWER_PLUS_TWENTY    = 21;

int    ATTACK_BONUS_MISC                = 0;
int    ATTACK_BONUS_ONHAND              = 1;
int    ATTACK_BONUS_OFFHAND             = 2;

int    AC_DODGE_BONUS                   = 0;
int    AC_NATURAL_BONUS                 = 1;
int    AC_ARMOUR_ENCHANTMENT_BONUS      = 2;
int    AC_SHIELD_ENCHANTMENT_BONUS      = 3;
int    AC_DEFLECTION_BONUS              = 4;

int    MISS_CHANCE_TYPE_NORMAL          = 0;
int    MISS_CHANCE_TYPE_VS_RANGED       = 1;
int    MISS_CHANCE_TYPE_VS_MELEE        = 2;

int    DOOR_ACTION_OPEN                 = 0;
int    DOOR_ACTION_UNLOCK               = 1;
int    DOOR_ACTION_BASH                 = 2;
int    DOOR_ACTION_IGNORE               = 3;
int    DOOR_ACTION_KNOCK                = 4;

int    PLACEABLE_ACTION_USE                  = 0;
int    PLACEABLE_ACTION_UNLOCK               = 1;
int    PLACEABLE_ACTION_BASH                 = 2;
int    PLACEABLE_ACTION_KNOCK                = 4;


int    RACIAL_TYPE_DWARF                = 0;
int    RACIAL_TYPE_ELF                  = 1;
int    RACIAL_TYPE_GNOME                = 2;
int    RACIAL_TYPE_HALFLING             = 3;
int    RACIAL_TYPE_HALFELF              = 4;
int    RACIAL_TYPE_HALFORC              = 5;
int    RACIAL_TYPE_HUMAN                = 6;
int    RACIAL_TYPE_ABERRATION           = 7;
int    RACIAL_TYPE_ANIMAL               = 8;
int    RACIAL_TYPE_BEAST                = 9;
int    RACIAL_TYPE_CONSTRUCT            = 10;
int    RACIAL_TYPE_DRAGON               = 11;
int    RACIAL_TYPE_HUMANOID_GOBLINOID   = 12;
int    RACIAL_TYPE_HUMANOID_MONSTROUS   = 13;
int    RACIAL_TYPE_HUMANOID_ORC         = 14;
int    RACIAL_TYPE_HUMANOID_REPTILIAN   = 15;
int    RACIAL_TYPE_ELEMENTAL            = 16;
int    RACIAL_TYPE_FEY                  = 17;
int    RACIAL_TYPE_GIANT                = 18;
int    RACIAL_TYPE_MAGICAL_BEAST        = 19;
int    RACIAL_TYPE_OUTSIDER             = 20;
int    RACIAL_TYPE_SHAPECHANGER         = 23;
int    RACIAL_TYPE_UNDEAD               = 24;
int    RACIAL_TYPE_VERMIN               = 25;
int    RACIAL_TYPE_ALL                  = 28;
int    RACIAL_TYPE_INVALID              = 28;
int    RACIAL_TYPE_OOZE                 = 29;

int    ALIGNMENT_ALL                    = 0;
int    ALIGNMENT_NEUTRAL                = 1;
int    ALIGNMENT_LAWFUL                 = 2;
int    ALIGNMENT_CHAOTIC                = 3;
int    ALIGNMENT_GOOD                   = 4;
int    ALIGNMENT_EVIL                   = 5;

int SAVING_THROW_ALL                    = 0;
int SAVING_THROW_FORT                   = 1;
int SAVING_THROW_REFLEX                 = 2;
int SAVING_THROW_WILL                   = 3;

int SAVING_THROW_TYPE_ALL               = 0;
int SAVING_THROW_TYPE_NONE              = 0;
int SAVING_THROW_TYPE_MIND_SPELLS       = 1;
int SAVING_THROW_TYPE_POISON            = 2;
int SAVING_THROW_TYPE_DISEASE           = 3;
int SAVING_THROW_TYPE_FEAR              = 4;
int SAVING_THROW_TYPE_SONIC             = 5;
int SAVING_THROW_TYPE_ACID              = 6;
int SAVING_THROW_TYPE_FIRE              = 7;
int SAVING_THROW_TYPE_ELECTRICITY       = 8;
int SAVING_THROW_TYPE_POSITIVE          = 9;
int SAVING_THROW_TYPE_NEGATIVE          = 10;
int SAVING_THROW_TYPE_DEATH             = 11;
int SAVING_THROW_TYPE_COLD              = 12;
int SAVING_THROW_TYPE_DIVINE            = 13;
int SAVING_THROW_TYPE_TRAP              = 14;
int SAVING_THROW_TYPE_SPELL             = 15;
int SAVING_THROW_TYPE_GOOD              = 16;
int SAVING_THROW_TYPE_EVIL              = 17;
int SAVING_THROW_TYPE_LAW               = 18;
int SAVING_THROW_TYPE_CHAOS             = 19;
int SAVING_THROW_TYPE_PARALYSIS         = 20;

int IMMUNITY_TYPE_NONE              = 0;
int IMMUNITY_TYPE_MIND_SPELLS       = 1;
int IMMUNITY_TYPE_POISON            = 2;
int IMMUNITY_TYPE_DISEASE           = 3;
int IMMUNITY_TYPE_FEAR              = 4;
int IMMUNITY_TYPE_TRAP              = 5;
int IMMUNITY_TYPE_PARALYSIS         = 6;
int IMMUNITY_TYPE_BLINDNESS         = 7;
int IMMUNITY_TYPE_DEAFNESS          = 8;
int IMMUNITY_TYPE_SLOW              = 9;
int IMMUNITY_TYPE_ENTANGLE          = 10;
int IMMUNITY_TYPE_SILENCE           = 11;
int IMMUNITY_TYPE_STUN              = 12;
int IMMUNITY_TYPE_SLEEP             = 13;
int IMMUNITY_TYPE_CHARM             = 14;
int IMMUNITY_TYPE_DOMINATE          = 15;
int IMMUNITY_TYPE_CONFUSED          = 16;
int IMMUNITY_TYPE_CURSED            = 17;
int IMMUNITY_TYPE_DAZED             = 18;
int IMMUNITY_TYPE_ABILITY_DECREASE  = 19;
int IMMUNITY_TYPE_ATTACK_DECREASE   = 20;
int IMMUNITY_TYPE_DAMAGE_DECREASE   = 21;
int IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE = 22;
int IMMUNITY_TYPE_AC_DECREASE       = 23;
int IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE = 24;
int IMMUNITY_TYPE_SAVING_THROW_DECREASE = 25;
int IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE = 26;
int IMMUNITY_TYPE_SKILL_DECREASE    = 27;
int IMMUNITY_TYPE_KNOCKDOWN         = 28;
int IMMUNITY_TYPE_NEGATIVE_LEVEL    = 29;
int IMMUNITY_TYPE_SNEAK_ATTACK      = 30;
int IMMUNITY_TYPE_CRITICAL_HIT      = 31;
int IMMUNITY_TYPE_DEATH             = 32;

int AREA_TRANSITION_RANDOM        = 0;
int AREA_TRANSITION_USER_DEFINED  = 1;
int AREA_TRANSITION_CITY_01       = 2;
int AREA_TRANSITION_CITY_02       = 3;
int AREA_TRANSITION_CITY_03       = 4;
int AREA_TRANSITION_CITY_04       = 5;
int AREA_TRANSITION_CITY_05       = 6;
int AREA_TRANSITION_CRYPT_01      = 7;
int AREA_TRANSITION_CRYPT_02      = 8;
int AREA_TRANSITION_CRYPT_03      = 9;
int AREA_TRANSITION_CRYPT_04      = 10;
int AREA_TRANSITION_CRYPT_05      = 11;
int AREA_TRANSITION_DUNGEON_01    = 12;
int AREA_TRANSITION_DUNGEON_02    = 13;
int AREA_TRANSITION_DUNGEON_03    = 14;
int AREA_TRANSITION_DUNGEON_04    = 15;
int AREA_TRANSITION_DUNGEON_05    = 16;
int AREA_TRANSITION_DUNGEON_06    = 17;
int AREA_TRANSITION_DUNGEON_07    = 18;
int AREA_TRANSITION_DUNGEON_08    = 19;
int AREA_TRANSITION_MINES_01      = 20;
int AREA_TRANSITION_MINES_02      = 21;
int AREA_TRANSITION_MINES_03      = 22;
int AREA_TRANSITION_MINES_04      = 23;
int AREA_TRANSITION_MINES_05      = 24;
int AREA_TRANSITION_MINES_06      = 25;
int AREA_TRANSITION_MINES_07      = 26;
int AREA_TRANSITION_MINES_08      = 27;
int AREA_TRANSITION_MINES_09      = 28;
int AREA_TRANSITION_SEWER_01      = 29;
int AREA_TRANSITION_SEWER_02      = 30;
int AREA_TRANSITION_SEWER_03      = 31;
int AREA_TRANSITION_SEWER_04      = 32;
int AREA_TRANSITION_SEWER_05      = 33;
int AREA_TRANSITION_CASTLE_01     = 34;
int AREA_TRANSITION_CASTLE_02     = 35;
int AREA_TRANSITION_CASTLE_03     = 36;
int AREA_TRANSITION_CASTLE_04     = 37;
int AREA_TRANSITION_CASTLE_05     = 38;
int AREA_TRANSITION_CASTLE_06     = 39;
int AREA_TRANSITION_CASTLE_07     = 40;
int AREA_TRANSITION_CASTLE_08     = 41;
int AREA_TRANSITION_INTERIOR_01   = 42;
int AREA_TRANSITION_INTERIOR_02   = 43;
int AREA_TRANSITION_INTERIOR_03   = 44;
int AREA_TRANSITION_INTERIOR_04   = 45;
int AREA_TRANSITION_INTERIOR_05   = 46;
int AREA_TRANSITION_INTERIOR_06   = 47;
int AREA_TRANSITION_INTERIOR_07   = 48;
int AREA_TRANSITION_INTERIOR_08   = 49;
int AREA_TRANSITION_INTERIOR_09   = 50;
int AREA_TRANSITION_INTERIOR_10   = 51;
int AREA_TRANSITION_INTERIOR_11   = 52;
int AREA_TRANSITION_INTERIOR_12   = 53;
int AREA_TRANSITION_INTERIOR_13   = 54;
int AREA_TRANSITION_INTERIOR_14   = 55;
int AREA_TRANSITION_INTERIOR_15   = 56;
int AREA_TRANSITION_INTERIOR_16   = 57;
int AREA_TRANSITION_FOREST_01     = 58;
int AREA_TRANSITION_FOREST_02     = 59;
int AREA_TRANSITION_FOREST_03     = 60;
int AREA_TRANSITION_FOREST_04     = 61;
int AREA_TRANSITION_FOREST_05     = 62;
int AREA_TRANSITION_RURAL_01      = 63;
int AREA_TRANSITION_RURAL_02      = 64;
int AREA_TRANSITION_RURAL_03      = 65;
int AREA_TRANSITION_RURAL_04      = 66;
int AREA_TRANSITION_RURAL_05      = 67;
int AREA_TRANSITION_WRURAL_01  = 68;
int AREA_TRANSITION_WRURAL_02 = 69;
int AREA_TRANSITION_WRURAL_03 = 70;
int AREA_TRANSITION_WRURAL_04 = 71;
int AREA_TRANSITION_WRURAL_05 = 72;
int AREA_TRANSITION_DESERT_01 = 73;
int AREA_TRANSITION_DESERT_02 = 74;
int AREA_TRANSITION_DESERT_03 = 75;
int AREA_TRANSITION_DESERT_04 = 76;
int AREA_TRANSITION_DESERT_05 = 77;
int AREA_TRANSITION_RUINS_01 = 78;
int AREA_TRANSITION_RUINS_02 = 79;
int AREA_TRANSITION_RUINS_03 = 80;
int AREA_TRANSITION_RUINS_04 = 81;
int AREA_TRANSITION_RUINS_05 = 82;
int AREA_TRANSITION_CARAVAN_WINTER = 83;
int AREA_TRANSITION_CARAVAN_DESERT = 84;
int AREA_TRANSITION_CARAVAN_RURAL = 85;
int AREA_TRANSITION_MAGICAL_01 = 86;
int AREA_TRANSITION_MAGICAL_02 = 87;
int AREA_TRANSITION_UNDERDARK_01 = 88;
int AREA_TRANSITION_UNDERDARK_02 = 89;
int AREA_TRANSITION_UNDERDARK_03 = 90;
int AREA_TRANSITION_UNDERDARK_04 = 91;
int AREA_TRANSITION_UNDERDARK_05 = 92;
int AREA_TRANSITION_UNDERDARK_06 = 93;
int AREA_TRANSITION_UNDERDARK_07 = 94;
int AREA_TRANSITION_BEHOLDER_01  = 95;
int AREA_TRANSITION_BEHOLDER_02  = 96;
int AREA_TRANSITION_DROW_01  = 97;
int AREA_TRANSITION_DROW_02  = 98;
int AREA_TRANSITION_ILLITHID_01   = 99;
int AREA_TRANSITION_ILLITHID_02   = 100;
int AREA_TRANSITION_WASTELAND_01  = 101;
int AREA_TRANSITION_WASTELAND_02  = 102;
int AREA_TRANSITION_WASTELAND_03  = 103;
int AREA_TRANSITION_DROW_03       = 104;
int AREA_TRANSITION_DROW_04       = 105;



// Legacy area-transition constants.  Do not delete these.
int AREA_TRANSITION_CITY          = 2;
int AREA_TRANSITION_CRYPT         = 7;
int AREA_TRANSITION_FOREST        = 58;
int AREA_TRANSITION_RURAL         = 63;

int BODY_NODE_HAND                = 0;
int BODY_NODE_CHEST               = 1;
int BODY_NODE_MONSTER_0           = 2;
int BODY_NODE_MONSTER_1           = 3;
int BODY_NODE_MONSTER_2           = 4;
int BODY_NODE_MONSTER_3           = 5;
int BODY_NODE_MONSTER_4           = 6;
int BODY_NODE_MONSTER_5           = 7;
int BODY_NODE_MONSTER_6           = 8;
int BODY_NODE_MONSTER_7           = 9;
int BODY_NODE_MONSTER_8           = 10;
int BODY_NODE_MONSTER_9           = 11;

float RADIUS_SIZE_SMALL           = 1.67f;
float RADIUS_SIZE_MEDIUM          = 3.33f;
float RADIUS_SIZE_LARGE           = 5.0f;
float RADIUS_SIZE_HUGE            = 6.67f;
float RADIUS_SIZE_GARGANTUAN      = 8.33f;
float RADIUS_SIZE_COLOSSAL        = 10.0f;

// these are magic numbers.  they should correspond to the values layed out in ExecuteCommandGetEffectType
int EFFECT_TYPE_INVALIDEFFECT               = 0;
int EFFECT_TYPE_DAMAGE_RESISTANCE           = 1;
//int EFFECT_TYPE_ABILITY_BONUS               = 2;
int EFFECT_TYPE_REGENERATE                  = 3;
//int EFFECT_TYPE_SAVING_THROW_BONUS          = 4;
//int EFFECT_TYPE_MODIFY_AC                   = 5;
//int EFFECT_TYPE_ATTACK_BONUS                = 6;
int EFFECT_TYPE_DAMAGE_REDUCTION            = 7;
//int EFFECT_TYPE_DAMAGE_BONUS                = 8;
int EFFECT_TYPE_TEMPORARY_HITPOINTS         = 9;
//int EFFECT_TYPE_DAMAGE_IMMUNITY             = 10;
int EFFECT_TYPE_ENTANGLE                    = 11;
int EFFECT_TYPE_INVULNERABLE                = 12;
int EFFECT_TYPE_DEAF                        = 13;
int EFFECT_TYPE_RESURRECTION                = 14;
int EFFECT_TYPE_IMMUNITY                    = 15;
//int EFFECT_TYPE_BLIND                       = 16;
int EFFECT_TYPE_ENEMY_ATTACK_BONUS          = 17;
int EFFECT_TYPE_ARCANE_SPELL_FAILURE        = 18;
//int EFFECT_TYPE_MOVEMENT_SPEED              = 19;
int EFFECT_TYPE_AREA_OF_EFFECT              = 20;
int EFFECT_TYPE_BEAM                        = 21;
//int EFFECT_TYPE_SPELL_RESISTANCE            = 22;
int EFFECT_TYPE_CHARMED                     = 23;
int EFFECT_TYPE_CONFUSED                    = 24;
int EFFECT_TYPE_FRIGHTENED                  = 25;
int EFFECT_TYPE_DOMINATED                   = 26;
int EFFECT_TYPE_PARALYZE                    = 27;
int EFFECT_TYPE_DAZED                       = 28;
int EFFECT_TYPE_STUNNED                     = 29;
int EFFECT_TYPE_SLEEP                       = 30;
int EFFECT_TYPE_POISON                      = 31;
int EFFECT_TYPE_DISEASE                     = 32;
int EFFECT_TYPE_CURSE                       = 33;
int EFFECT_TYPE_SILENCE                     = 34;
int EFFECT_TYPE_TURNED                      = 35;
int EFFECT_TYPE_HASTE                       = 36;
int EFFECT_TYPE_SLOW                        = 37;
int EFFECT_TYPE_ABILITY_INCREASE            = 38;
int EFFECT_TYPE_ABILITY_DECREASE            = 39;
int EFFECT_TYPE_ATTACK_INCREASE             = 40;
int EFFECT_TYPE_ATTACK_DECREASE             = 41;
int EFFECT_TYPE_DAMAGE_INCREASE             = 42;
int EFFECT_TYPE_DAMAGE_DECREASE             = 43;
int EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE    = 44;
int EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE    = 45;
int EFFECT_TYPE_AC_INCREASE                 = 46;
int EFFECT_TYPE_AC_DECREASE                 = 47;
int EFFECT_TYPE_MOVEMENT_SPEED_INCREASE     = 48;
int EFFECT_TYPE_MOVEMENT_SPEED_DECREASE     = 49;
int EFFECT_TYPE_SAVING_THROW_INCREASE       = 50;
int EFFECT_TYPE_SAVING_THROW_DECREASE       = 51;
int EFFECT_TYPE_SPELL_RESISTANCE_INCREASE   = 52;
int EFFECT_TYPE_SPELL_RESISTANCE_DECREASE   = 53;
int EFFECT_TYPE_SKILL_INCREASE              = 54;
int EFFECT_TYPE_SKILL_DECREASE              = 55;
int EFFECT_TYPE_INVISIBILITY                = 56;
int EFFECT_TYPE_IMPROVEDINVISIBILITY        = 57;
int EFFECT_TYPE_DARKNESS                    = 58;
int EFFECT_TYPE_DISPELMAGICALL              = 59;
int EFFECT_TYPE_ELEMENTALSHIELD             = 60;
int EFFECT_TYPE_NEGATIVELEVEL               = 61;
int EFFECT_TYPE_POLYMORPH                   = 62;
int EFFECT_TYPE_SANCTUARY                   = 63;
int EFFECT_TYPE_TRUESEEING                  = 64;
int EFFECT_TYPE_SEEINVISIBLE                = 65;
int EFFECT_TYPE_TIMESTOP                    = 66;
int EFFECT_TYPE_BLINDNESS                   = 67;
int EFFECT_TYPE_SPELLLEVELABSORPTION        = 68;
int EFFECT_TYPE_DISPELMAGICBEST             = 69;
int EFFECT_TYPE_ULTRAVISION                 = 70;
int EFFECT_TYPE_MISS_CHANCE                 = 71;
int EFFECT_TYPE_CONCEALMENT                 = 72;
int EFFECT_TYPE_SPELL_IMMUNITY              = 73;
int EFFECT_TYPE_VISUALEFFECT                = 74;
int EFFECT_TYPE_DISAPPEARAPPEAR             = 75;
int EFFECT_TYPE_SWARM                       = 76;
int EFFECT_TYPE_TURN_RESISTANCE_DECREASE    = 77;
int EFFECT_TYPE_TURN_RESISTANCE_INCREASE    = 78;
int EFFECT_TYPE_PETRIFY                     = 79;
int EFFECT_TYPE_CUTSCENE_PARALYZE           = 80;
int EFFECT_TYPE_ETHEREAL                    = 81;
int EFFECT_TYPE_SPELL_FAILURE               = 82;
int EFFECT_TYPE_CUTSCENEGHOST               = 83;
int EFFECT_TYPE_CUTSCENEIMMOBILIZE          = 84;
int EFFECT_TYPE_RUNSCRIPT                   = 85;
int EFFECT_TYPE_ICON                        = 86;
int EFFECT_TYPE_PACIFY                      = 87;
int EFFECT_TYPE_BONUS_FEAT                  = 88;
int EFFECT_TYPE_TIMESTOP_IMMUNITY           = 89;
int EFFECT_TYPE_FORCE_WALK                  = 90;
// The below values are used only if GetEffectType parameter bAllTypes is TRUE
int EFFECT_TYPE_APPEAR                      = 91;
int EFFECT_TYPE_CUTSCENE_DOMINATED          = 92;
int EFFECT_TYPE_DAMAGE                      = 93;
int EFFECT_TYPE_DEATH                       = 94;
int EFFECT_TYPE_DISAPPEAR                   = 95;
int EFFECT_TYPE_HEAL                        = 96;
int EFFECT_TYPE_HITPOINTCHANGEWHENDYING     = 97;
int EFFECT_TYPE_KNOCKDOWN                   = 98;
int EFFECT_TYPE_MODIFY_ATTACKS              = 99;
int EFFECT_TYPE_SUMMON_CREATURE             = 100;
int EFFECT_TYPE_TAUNT                       = 101;
int EFFECT_TYPE_WOUNDING                    = 102;
// End of valued returned by bAllTypes being TRUE

int ITEM_APPR_TYPE_SIMPLE_MODEL         = 0;
int ITEM_APPR_TYPE_WEAPON_COLOR         = 1;
int ITEM_APPR_TYPE_WEAPON_MODEL         = 2;
int ITEM_APPR_TYPE_ARMOR_MODEL          = 3;
int ITEM_APPR_TYPE_ARMOR_COLOR          = 4;
int ITEM_APPR_NUM_TYPES                 = 5;

int ITEM_APPR_ARMOR_COLOR_LEATHER1      = 0;
int ITEM_APPR_ARMOR_COLOR_LEATHER2      = 1;
int ITEM_APPR_ARMOR_COLOR_CLOTH1        = 2;
int ITEM_APPR_ARMOR_COLOR_CLOTH2        = 3;
int ITEM_APPR_ARMOR_COLOR_METAL1        = 4;
int ITEM_APPR_ARMOR_COLOR_METAL2        = 5;
int ITEM_APPR_ARMOR_NUM_COLORS          = 6;

int ITEM_APPR_ARMOR_MODEL_RFOOT         = 0;
int ITEM_APPR_ARMOR_MODEL_LFOOT         = 1;
int ITEM_APPR_ARMOR_MODEL_RSHIN         = 2;
int ITEM_APPR_ARMOR_MODEL_LSHIN         = 3;
int ITEM_APPR_ARMOR_MODEL_LTHIGH        = 4;
int ITEM_APPR_ARMOR_MODEL_RTHIGH        = 5;
int ITEM_APPR_ARMOR_MODEL_PELVIS        = 6;
int ITEM_APPR_ARMOR_MODEL_TORSO         = 7;
int ITEM_APPR_ARMOR_MODEL_BELT          = 8;
int ITEM_APPR_ARMOR_MODEL_NECK          = 9;
int ITEM_APPR_ARMOR_MODEL_RFOREARM      = 10;
int ITEM_APPR_ARMOR_MODEL_LFOREARM      = 11;
int ITEM_APPR_ARMOR_MODEL_RBICEP        = 12;
int ITEM_APPR_ARMOR_MODEL_LBICEP        = 13;
int ITEM_APPR_ARMOR_MODEL_RSHOULDER     = 14;
int ITEM_APPR_ARMOR_MODEL_LSHOULDER     = 15;
int ITEM_APPR_ARMOR_MODEL_RHAND         = 16;
int ITEM_APPR_ARMOR_MODEL_LHAND         = 17;
int ITEM_APPR_ARMOR_MODEL_ROBE          = 18;
int ITEM_APPR_ARMOR_NUM_MODELS          = 19;

int ITEM_APPR_WEAPON_MODEL_BOTTOM       = 0;
int ITEM_APPR_WEAPON_MODEL_MIDDLE       = 1;
int ITEM_APPR_WEAPON_MODEL_TOP          = 2;

int ITEM_APPR_WEAPON_COLOR_BOTTOM       = 0;
int ITEM_APPR_WEAPON_COLOR_MIDDLE       = 1;
int ITEM_APPR_WEAPON_COLOR_TOP          = 2;

int ITEM_PROPERTY_ABILITY_BONUS                            = 0 ;
int ITEM_PROPERTY_AC_BONUS                                 = 1 ;
int ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP              = 2 ;
int ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE                  = 3 ;
int ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP                 = 4 ;
int ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT           = 5 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS                        = 6 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP     = 7 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP        = 8 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT = 9 ;
int ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER           = 10 ;
int ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION               = 11 ;
int ITEM_PROPERTY_BONUS_FEAT                               = 12 ;
int ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N              = 13 ;

int ITEM_PROPERTY_CAST_SPELL                               = 15 ;
int ITEM_PROPERTY_DAMAGE_BONUS                             = 16 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP          = 17 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP             = 18 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT       = 19 ;
int ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE                     = 20 ;
int ITEM_PROPERTY_DECREASED_DAMAGE                         = 21 ;
int ITEM_PROPERTY_DAMAGE_REDUCTION                         = 22 ;
int ITEM_PROPERTY_DAMAGE_RESISTANCE                        = 23 ;
int ITEM_PROPERTY_DAMAGE_VULNERABILITY                     = 24 ;

int ITEM_PROPERTY_DARKVISION                               = 26 ;
int ITEM_PROPERTY_DECREASED_ABILITY_SCORE                  = 27 ;
int ITEM_PROPERTY_DECREASED_AC                             = 28 ;
int ITEM_PROPERTY_DECREASED_SKILL_MODIFIER                 = 29 ;


int ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT        = 32 ;
int ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE                  = 33 ;
int ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE                 = 34 ;
int ITEM_PROPERTY_HASTE                                    = 35 ;
int ITEM_PROPERTY_HOLY_AVENGER                             = 36 ;
int ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS                   = 37 ;
int ITEM_PROPERTY_IMPROVED_EVASION                         = 38 ;
int ITEM_PROPERTY_SPELL_RESISTANCE                         = 39 ;
int ITEM_PROPERTY_SAVING_THROW_BONUS                       = 40 ;
int ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC              = 41 ;
int ITEM_PROPERTY_KEEN                                     = 43 ;
int ITEM_PROPERTY_LIGHT                                    = 44 ;
int ITEM_PROPERTY_MIGHTY                                   = 45 ;
int ITEM_PROPERTY_MIND_BLANK                               = 46 ;
int ITEM_PROPERTY_NO_DAMAGE                                = 47 ;
int ITEM_PROPERTY_ON_HIT_PROPERTIES                        = 48 ;
int ITEM_PROPERTY_DECREASED_SAVING_THROWS                  = 49 ;
int ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC         = 50 ;
int ITEM_PROPERTY_REGENERATION                             = 51 ;
int ITEM_PROPERTY_SKILL_BONUS                              = 52 ;
int ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL                  = 53 ;
int ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL                    = 54 ;
int ITEM_PROPERTY_THIEVES_TOOLS                            = 55 ;
int ITEM_PROPERTY_ATTACK_BONUS                             = 56 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP          = 57 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP             = 58 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT       = 59 ;
int ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER                = 60 ;
int ITEM_PROPERTY_UNLIMITED_AMMUNITION                     = 61 ;
int ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP           = 62 ;
int ITEM_PROPERTY_USE_LIMITATION_CLASS                     = 63 ;
int ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE               = 64 ;
int ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT        = 65 ;
int ITEM_PROPERTY_USE_LIMITATION_TILESET                   = 66 ;
int ITEM_PROPERTY_REGENERATION_VAMPIRIC                    = 67 ;

int ITEM_PROPERTY_TRAP                                     = 70 ;
int ITEM_PROPERTY_TRUE_SEEING                              = 71 ;
int ITEM_PROPERTY_ON_MONSTER_HIT                           = 72 ;
int ITEM_PROPERTY_TURN_RESISTANCE                          = 73 ;
int ITEM_PROPERTY_MASSIVE_CRITICALS                        = 74 ;
int ITEM_PROPERTY_FREEDOM_OF_MOVEMENT                      = 75 ;

// no longer working, poison is now a on_hit subtype
int ITEM_PROPERTY_POISON                                   = 76 ;

int ITEM_PROPERTY_MONSTER_DAMAGE                           = 77 ;
int ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL                 = 78 ;

int ITEM_PROPERTY_SPECIAL_WALK                             = 79;
int ITEM_PROPERTY_HEALERS_KIT                              = 80;
int ITEM_PROPERTY_WEIGHT_INCREASE                          = 81;
int ITEM_PROPERTY_ONHITCASTSPELL                           = 82;
int ITEM_PROPERTY_VISUALEFFECT                             = 83;
int ITEM_PROPERTY_ARCANE_SPELL_FAILURE                     = 84;

int ITEM_PROPERTY_MATERIAL                                 = 85;
int ITEM_PROPERTY_QUALITY                                  = 86;
int ITEM_PROPERTY_ADDITIONAL                               = 87;


int BASE_ITEM_SHORTSWORD            = 0;
int BASE_ITEM_LONGSWORD             = 1;
int BASE_ITEM_BATTLEAXE             = 2;
int BASE_ITEM_BASTARDSWORD          = 3;
int BASE_ITEM_LIGHTFLAIL            = 4;
int BASE_ITEM_WARHAMMER             = 5;
int BASE_ITEM_HEAVYCROSSBOW         = 6;
int BASE_ITEM_LIGHTCROSSBOW         = 7;
int BASE_ITEM_LONGBOW               = 8;
int BASE_ITEM_LIGHTMACE             = 9;
int BASE_ITEM_HALBERD               = 10;
int BASE_ITEM_SHORTBOW              = 11;
int BASE_ITEM_TWOBLADEDSWORD        = 12;
int BASE_ITEM_GREATSWORD            = 13;
int BASE_ITEM_SMALLSHIELD           = 14;
int BASE_ITEM_TORCH                 = 15;
int BASE_ITEM_ARMOR                 = 16;
int BASE_ITEM_HELMET                = 17;
int BASE_ITEM_GREATAXE              = 18;
int BASE_ITEM_AMULET                = 19;
int BASE_ITEM_ARROW                 = 20;
int BASE_ITEM_BELT                  = 21;
int BASE_ITEM_DAGGER                = 22;
int BASE_ITEM_MISCSMALL             = 24;
int BASE_ITEM_BOLT                  = 25;
int BASE_ITEM_BOOTS                 = 26;
int BASE_ITEM_BULLET                = 27;
int BASE_ITEM_CLUB                  = 28;
int BASE_ITEM_MISCMEDIUM            = 29;
int BASE_ITEM_DART                  = 31;
int BASE_ITEM_DIREMACE              = 32;
int BASE_ITEM_DOUBLEAXE             = 33;
int BASE_ITEM_MISCLARGE             = 34;
int BASE_ITEM_HEAVYFLAIL            = 35;
int BASE_ITEM_GLOVES                = 36;
int BASE_ITEM_LIGHTHAMMER           = 37;
int BASE_ITEM_HANDAXE               = 38;
int BASE_ITEM_HEALERSKIT            = 39;
int BASE_ITEM_KAMA                  = 40;
int BASE_ITEM_KATANA                = 41;
int BASE_ITEM_KUKRI                 = 42;
int BASE_ITEM_MISCTALL              = 43;
int BASE_ITEM_MAGICROD              = 44;
int BASE_ITEM_MAGICSTAFF            = 45;
int BASE_ITEM_MAGICWAND             = 46;
int BASE_ITEM_MORNINGSTAR           = 47;


int BASE_ITEM_POTIONS               = 49;
int BASE_ITEM_QUARTERSTAFF          = 50;
int BASE_ITEM_RAPIER                = 51;
int BASE_ITEM_RING                  = 52;
int BASE_ITEM_SCIMITAR              = 53;
int BASE_ITEM_SCROLL                = 54;
int BASE_ITEM_SCYTHE                = 55;
int BASE_ITEM_LARGESHIELD           = 56;
int BASE_ITEM_TOWERSHIELD           = 57;
int BASE_ITEM_SHORTSPEAR            = 58;
int BASE_ITEM_SHURIKEN              = 59;
int BASE_ITEM_SICKLE                = 60;
int BASE_ITEM_SLING                 = 61;
int BASE_ITEM_THIEVESTOOLS          = 62;
int BASE_ITEM_THROWINGAXE           = 63;
int BASE_ITEM_TRAPKIT               = 64;
int BASE_ITEM_KEY                   = 65;
int BASE_ITEM_LARGEBOX              = 66;
int BASE_ITEM_MISCWIDE              = 68;
int BASE_ITEM_CSLASHWEAPON          = 69;
int BASE_ITEM_CPIERCWEAPON          = 70;
int BASE_ITEM_CBLUDGWEAPON          = 71;
int BASE_ITEM_CSLSHPRCWEAP          = 72;
int BASE_ITEM_CREATUREITEM          = 73;
int BASE_ITEM_BOOK                  = 74;
int BASE_ITEM_SPELLSCROLL           = 75;
int BASE_ITEM_GOLD                  = 76;
int BASE_ITEM_GEM                   = 77;
int BASE_ITEM_BRACER                = 78;
int BASE_ITEM_MISCTHIN              = 79;
int BASE_ITEM_CLOAK                 = 80;
int BASE_ITEM_GRENADE               = 81;
int BASE_ITEM_TRIDENT               = 95;

int BASE_ITEM_BLANK_POTION          = 101;
int BASE_ITEM_BLANK_SCROLL          = 102;
int BASE_ITEM_BLANK_WAND            = 103;

int BASE_ITEM_ENCHANTED_POTION      = 104;
int BASE_ITEM_ENCHANTED_SCROLL      = 105;
int BASE_ITEM_ENCHANTED_WAND        = 106;

int BASE_ITEM_DWARVENWARAXE         = 108;
int BASE_ITEM_CRAFTMATERIALMED      = 109;
int BASE_ITEM_CRAFTMATERIALSML      = 110;
int BASE_ITEM_WHIP                  = 111;


int BASE_ITEM_INVALID               = 256;

int VFX_NONE                        = -1;
int VFX_DUR_BLUR                    = 0;
int VFX_DUR_DARKNESS                = 1;
int VFX_DUR_ENTANGLE                = 2;
int VFX_DUR_FREEDOM_OF_MOVEMENT     = 3;
int VFX_DUR_GLOBE_INVULNERABILITY   = 4;
int VFX_DUR_BLACKOUT                = 5;
int VFX_DUR_INVISIBILITY            = 6;
int VFX_DUR_MIND_AFFECTING_NEGATIVE = 7;
int VFX_DUR_MIND_AFFECTING_POSITIVE = 8;
int VFX_DUR_GHOSTLY_VISAGE          = 9;
int VFX_DUR_ETHEREAL_VISAGE         = 10;
int VFX_DUR_PROT_BARKSKIN           = 11;
int VFX_DUR_PROT_GREATER_STONESKIN  = 12;
int VFX_DUR_PROT_PREMONITION        = 13;
int VFX_DUR_PROT_SHADOW_ARMOR       = 14;
int VFX_DUR_PROT_STONESKIN          = 15;
int VFX_DUR_SANCTUARY               = 16;
int VFX_DUR_WEB                     = 17;
int VFX_FNF_BLINDDEAF               = 18;
int VFX_FNF_DISPEL                  = 19;
int VFX_FNF_DISPEL_DISJUNCTION      = 20;
int VFX_FNF_DISPEL_GREATER          = 21 ;
int VFX_FNF_FIREBALL                = 22 ;
int VFX_FNF_FIRESTORM               = 23 ;
int VFX_FNF_IMPLOSION               = 24 ;
//int VFX_FNF_MASS_HASTE = 25 ;
int VFX_FNF_MASS_HEAL               = 26 ;
int VFX_FNF_MASS_MIND_AFFECTING     = 27 ;
int VFX_FNF_METEOR_SWARM            = 28 ;
int VFX_FNF_NATURES_BALANCE         = 29 ;
int VFX_FNF_PWKILL                  = 30 ;
int VFX_FNF_PWSTUN                  = 31 ;
int VFX_FNF_SUMMON_GATE             = 32 ;
int VFX_FNF_SUMMON_MONSTER_1        = 33 ;
int VFX_FNF_SUMMON_MONSTER_2        = 34 ;
int VFX_FNF_SUMMON_MONSTER_3        = 35 ;
int VFX_FNF_SUMMON_UNDEAD           = 36 ;
int VFX_FNF_SUNBEAM                 = 37 ;
int VFX_FNF_TIME_STOP               = 38 ;
int VFX_FNF_WAIL_O_BANSHEES         = 39 ;
int VFX_FNF_WEIRD                   = 40 ;
int VFX_FNF_WORD                    = 41 ;
int VFX_IMP_AC_BONUS                = 42 ;
int VFX_IMP_ACID_L                  = 43 ;
int VFX_IMP_ACID_S                  = 44 ;
//int VFX_IMP_ALTER_WEAPON = 45 ;
int VFX_IMP_BLIND_DEAF_M            = 46 ;
int VFX_IMP_BREACH                  = 47 ;
int VFX_IMP_CONFUSION_S             = 48 ;
int VFX_IMP_DAZED_S                 = 49 ;
int VFX_IMP_DEATH                   = 50 ;
int VFX_IMP_DISEASE_S               = 51 ;
int VFX_IMP_DISPEL                  = 52 ;
int VFX_IMP_DISPEL_DISJUNCTION      = 53 ;
int VFX_IMP_DIVINE_STRIKE_FIRE      = 54 ;
int VFX_IMP_DIVINE_STRIKE_HOLY      = 55 ;
int VFX_IMP_DOMINATE_S              = 56 ;
int VFX_IMP_DOOM                    = 57 ;
int VFX_IMP_FEAR_S                  = 58 ;
//int VFX_IMP_FLAME_L = 59 ;
int VFX_IMP_FLAME_M                 = 60 ;
int VFX_IMP_FLAME_S                 = 61 ;
int VFX_IMP_FROST_L                 = 62 ;
int VFX_IMP_FROST_S                 = 63 ;
int VFX_IMP_GREASE                  = 64 ;
int VFX_IMP_HASTE                   = 65 ;
int VFX_IMP_HEALING_G               = 66 ;
int VFX_IMP_HEALING_L               = 67 ;
int VFX_IMP_HEALING_M               = 68 ;
int VFX_IMP_HEALING_S               = 69 ;
int VFX_IMP_HEALING_X               = 70 ;
int VFX_IMP_HOLY_AID                = 71 ;
int VFX_IMP_KNOCK                   = 72 ;
int VFX_BEAM_LIGHTNING              = 73 ;
int VFX_IMP_LIGHTNING_M             = 74 ;
int VFX_IMP_LIGHTNING_S             = 75 ;
int VFX_IMP_MAGBLUE                 = 76 ;
//int VFX_IMP_MAGBLUE2 = 77 ;
//int VFX_IMP_MAGBLUE3 = 78 ;
//int VFX_IMP_MAGBLUE4 = 79 ;
//int VFX_IMP_MAGBLUE5 = 80 ;
int VFX_IMP_NEGATIVE_ENERGY         = 81 ;
int VFX_DUR_PARALYZE_HOLD           = 82 ;
int VFX_IMP_POISON_L                = 83 ;
int VFX_IMP_POISON_S                = 84 ;
int VFX_IMP_POLYMORPH               = 85 ;
int VFX_IMP_PULSE_COLD              = 86 ;
int VFX_IMP_PULSE_FIRE              = 87 ;
int VFX_IMP_PULSE_HOLY              = 88 ;
int VFX_IMP_PULSE_NEGATIVE          = 89 ;
int VFX_IMP_RAISE_DEAD              = 90 ;
int VFX_IMP_REDUCE_ABILITY_SCORE    = 91 ;
int VFX_IMP_REMOVE_CONDITION        = 92 ;
int VFX_IMP_SILENCE                 = 93 ;
int VFX_IMP_SLEEP                   = 94 ;
int VFX_IMP_SLOW                    = 95 ;
int VFX_IMP_SONIC                   = 96 ;
int VFX_IMP_STUN                    = 97 ;
int VFX_IMP_SUNSTRIKE               = 98 ;
int VFX_IMP_UNSUMMON                = 99 ;
int VFX_COM_SPECIAL_BLUE_RED        = 100 ;
int VFX_COM_SPECIAL_PINK_ORANGE     = 101 ;
int VFX_COM_SPECIAL_RED_WHITE       = 102 ;
int VFX_COM_SPECIAL_RED_ORANGE      = 103 ;
int VFX_COM_SPECIAL_WHITE_BLUE      = 104 ;
int VFX_COM_SPECIAL_WHITE_ORANGE    = 105 ;
int VFX_COM_BLOOD_REG_WIMP          = 106 ;
int VFX_COM_BLOOD_LRG_WIMP          = 107 ;
int VFX_COM_BLOOD_CRT_WIMP          = 108 ;
int VFX_COM_BLOOD_REG_RED           = 109 ;
int VFX_COM_BLOOD_REG_GREEN         = 110 ;
int VFX_COM_BLOOD_REG_YELLOW        = 111 ;
int VFX_COM_BLOOD_LRG_RED           = 112 ;
int VFX_COM_BLOOD_LRG_GREEN         = 113 ;
int VFX_COM_BLOOD_LRG_YELLOW        = 114 ;
int VFX_COM_BLOOD_CRT_RED           = 115 ;
int VFX_COM_BLOOD_CRT_GREEN         = 116 ;
int VFX_COM_BLOOD_CRT_YELLOW        = 117 ;
int VFX_COM_SPARKS_PARRY            = 118 ;
//int VFX_COM_GIB = 119 ;
int VFX_COM_UNLOAD_MODEL            = 120 ;
int VFX_COM_CHUNK_RED_SMALL         = 121 ;
int VFX_COM_CHUNK_RED_MEDIUM        = 122 ;
int VFX_COM_CHUNK_GREEN_SMALL       = 123 ;
int VFX_COM_CHUNK_GREEN_MEDIUM      = 124 ;
int VFX_COM_CHUNK_YELLOW_SMALL      = 125 ;
int VFX_COM_CHUNK_YELLOW_MEDIUM     = 126 ;
//int VFX_ITM_ACID = 127 ;
//int VFX_ITM_FIRE = 128 ;
//int VFX_ITM_FROST = 129 ;
//int VFX_ITM_ILLUMINATED_BLUE = 130 ;
//int VFX_ITM_ILLUMINATED_PURPLE = 131 ;
//int VFX_ITM_ILLUMINATED_RED = 132 ;
//int VFX_ITM_LIGHTNING = 133 ;
//int VFX_ITM_PULSING_BLUE = 134 ;
//int VFX_ITM_PULSING_PURPLE = 135 ;
//int VFX_ITM_PULSING_RED = 136 ;
//int VFX_ITM_SMOKING = 137 ;
int VFX_DUR_SPELLTURNING            = 138;
int VFX_IMP_IMPROVE_ABILITY_SCORE   = 139;
int VFX_IMP_CHARM                   = 140;
int VFX_IMP_MAGICAL_VISION          = 141;
//int VFX_IMP_LAW_HELP = 142;
//int VFX_IMP_CHAOS_HELP = 143;
int VFX_IMP_EVIL_HELP               = 144;
int VFX_IMP_GOOD_HELP               = 145;
int VFX_IMP_DEATH_WARD              = 146;
int VFX_DUR_ELEMENTAL_SHIELD        = 147;
int VFX_DUR_LIGHT                   = 148;
int VFX_IMP_MAGIC_PROTECTION        = 149;
int VFX_IMP_SUPER_HEROISM           = 150;
int VFX_FNF_STORM                   = 151;
int VFX_IMP_ELEMENTAL_PROTECTION    = 152;
int VFX_DUR_LIGHT_BLUE_5            = 153;
int VFX_DUR_LIGHT_BLUE_10           = 154;
int VFX_DUR_LIGHT_BLUE_15           = 155;
int VFX_DUR_LIGHT_BLUE_20           = 156;
int VFX_DUR_LIGHT_YELLOW_5          = 157;
int VFX_DUR_LIGHT_YELLOW_10         = 158;
int VFX_DUR_LIGHT_YELLOW_15         = 159;
int VFX_DUR_LIGHT_YELLOW_20         = 160;
int VFX_DUR_LIGHT_PURPLE_5          = 161;
int VFX_DUR_LIGHT_PURPLE_10         = 162;
int VFX_DUR_LIGHT_PURPLE_15         = 163;
int VFX_DUR_LIGHT_PURPLE_20         = 164;
int VFX_DUR_LIGHT_RED_5             = 165;
int VFX_DUR_LIGHT_RED_10            = 166;
int VFX_DUR_LIGHT_RED_15            = 167;
int VFX_DUR_LIGHT_RED_20            = 168;
int VFX_DUR_LIGHT_ORANGE_5          = 169;
int VFX_DUR_LIGHT_ORANGE_10         = 170;
int VFX_DUR_LIGHT_ORANGE_15         = 171;
int VFX_DUR_LIGHT_ORANGE_20         = 172;
int VFX_DUR_LIGHT_WHITE_5           = 173;
int VFX_DUR_LIGHT_WHITE_10          = 174;
int VFX_DUR_LIGHT_WHITE_15          = 175;
int VFX_DUR_LIGHT_WHITE_20          = 176;
int VFX_DUR_LIGHT_GREY_5            = 177;
int VFX_DUR_LIGHT_GREY_10           = 178;
int VFX_DUR_LIGHT_GREY_15           = 179;
int VFX_DUR_LIGHT_GREY_20           = 180;
int VFX_IMP_MIRV                    = 181;
int VFX_DUR_DARKVISION              = 182;
int VFX_FNF_SOUND_BURST             = 183;
int VFX_FNF_STRIKE_HOLY             = 184;
int VFX_FNF_LOS_EVIL_10             = 185;
int VFX_FNF_LOS_EVIL_20             = 186;
int VFX_FNF_LOS_EVIL_30             = 187;
int VFX_FNF_LOS_HOLY_10             = 188;
int VFX_FNF_LOS_HOLY_20             = 189;
int VFX_FNF_LOS_HOLY_30             = 190;
int VFX_FNF_LOS_NORMAL_10           = 191;
int VFX_FNF_LOS_NORMAL_20           = 192;
int VFX_FNF_LOS_NORMAL_30           = 193;
int VFX_IMP_HEAD_ACID               = 194;
int VFX_IMP_HEAD_FIRE               = 195;
int VFX_IMP_HEAD_SONIC              = 196;
int VFX_IMP_HEAD_ELECTRICITY        = 197;
int VFX_IMP_HEAD_COLD               = 198;
int VFX_IMP_HEAD_HOLY               = 199;
int VFX_IMP_HEAD_NATURE             = 200;
int VFX_IMP_HEAD_HEAL               = 201;
int VFX_IMP_HEAD_MIND               = 202;
int VFX_IMP_HEAD_EVIL               = 203;
int VFX_IMP_HEAD_ODD                = 204;
int VFX_DUR_CESSATE_NEUTRAL         = 205;
int VFX_DUR_CESSATE_POSITIVE        = 206;
int VFX_DUR_CESSATE_NEGATIVE        = 207;
int VFX_DUR_MIND_AFFECTING_DISABLED = 208;
int VFX_DUR_MIND_AFFECTING_DOMINATED= 209;
int VFX_BEAM_FIRE                   = 210;
int VFX_BEAM_COLD                   = 211;
int VFX_BEAM_HOLY                   = 212;
int VFX_BEAM_MIND                   = 213;
int VFX_BEAM_EVIL                   = 214;
int VFX_BEAM_ODD                    = 215;
int VFX_BEAM_FIRE_LASH              = 216;
int VFX_IMP_DEATH_L                 = 217;
int VFX_DUR_MIND_AFFECTING_FEAR     = 218;
int VFX_FNF_SUMMON_CELESTIAL        = 219;
int VFX_DUR_GLOBE_MINOR             = 220;
int VFX_IMP_RESTORATION_LESSER      = 221;
int VFX_IMP_RESTORATION             = 222;
int VFX_IMP_RESTORATION_GREATER     = 223;
int VFX_DUR_PROTECTION_ELEMENTS     = 224;
int VFX_DUR_PROTECTION_GOOD_MINOR   = 225;
int VFX_DUR_PROTECTION_GOOD_MAJOR   = 226;
int VFX_DUR_PROTECTION_EVIL_MINOR   = 227;
int VFX_DUR_PROTECTION_EVIL_MAJOR   = 228;
int VFX_DUR_MAGICAL_SIGHT           = 229;
int VFX_DUR_WEB_MASS                = 230;
int VFX_FNF_ICESTORM                = 231;
int VFX_DUR_PARALYZED               = 232;
int VFX_IMP_MIRV_FLAME              = 233;
int VFX_IMP_DESTRUCTION             = 234;
int VFX_COM_CHUNK_RED_LARGE         = 235;
int VFX_COM_CHUNK_BONE_MEDIUM       = 236;
int VFX_COM_BLOOD_SPARK_SMALL       = 237;
int VFX_COM_BLOOD_SPARK_MEDIUM      = 238;
int VFX_COM_BLOOD_SPARK_LARGE       = 239;
int VFX_DUR_GHOSTLY_PULSE           = 240;
int VFX_FNF_HORRID_WILTING          = 241;
int VFX_DUR_BLINDVISION             = 242;
int VFX_DUR_LOWLIGHTVISION          = 243;
int VFX_DUR_ULTRAVISION             = 244;
int VFX_DUR_MIRV_ACID               = 245;
int VFX_IMP_HARM                    = 246;
int VFX_DUR_BLIND                   = 247;
int VFX_DUR_ANTI_LIGHT_10           = 248;
int VFX_DUR_MAGIC_RESISTANCE        = 249;
int VFX_IMP_MAGIC_RESISTANCE_USE    = 250;
int VFX_IMP_GLOBE_USE                  = 251;
int VFX_IMP_WILL_SAVING_THROW_USE      = 252;
int VFX_IMP_SPIKE_TRAP                 = 253;
int VFX_IMP_SPELL_MANTLE_USE           = 254;
int VFX_IMP_FORTITUDE_SAVING_THROW_USE = 255;
int VFX_IMP_REFLEX_SAVE_THROW_USE      = 256;
int VFX_FNF_GAS_EXPLOSION_ACID         = 257;
int VFX_FNF_GAS_EXPLOSION_EVIL         = 258;
int VFX_FNF_GAS_EXPLOSION_NATURE       = 259;
int VFX_FNF_GAS_EXPLOSION_FIRE         = 260;
int VFX_FNF_GAS_EXPLOSION_GREASE       = 261;
int VFX_FNF_GAS_EXPLOSION_MIND         = 262;
int VFX_FNF_SMOKE_PUFF                 = 263;
int VFX_IMP_PULSE_WATER                = 264;
int VFX_IMP_PULSE_WIND                 = 265;
int VFX_IMP_PULSE_NATURE               = 266;
int VFX_DUR_AURA_COLD                  = 267;
int VFX_DUR_AURA_FIRE                  = 268;
int VFX_DUR_AURA_POISON                = 269;
int VFX_DUR_AURA_DISEASE               = 270;
int VFX_DUR_AURA_ODD                   = 271;
int VFX_DUR_AURA_SILENCE               = 272;
int VFX_IMP_AURA_HOLY                  = 273;
int VFX_IMP_AURA_UNEARTHLY             = 274;
int VFX_IMP_AURA_FEAR                  = 275;
int VFX_IMP_AURA_NEGATIVE_ENERGY       = 276;
int VFX_DUR_BARD_SONG                  = 277;
int VFX_FNF_HOWL_MIND                  = 278;
int VFX_FNF_HOWL_ODD                   = 279;
int VFX_COM_HIT_FIRE                   = 280;
int VFX_COM_HIT_FROST                  = 281;
int VFX_COM_HIT_ELECTRICAL             = 282;
int VFX_COM_HIT_ACID                   = 283;
int VFX_COM_HIT_SONIC                  = 284;
int VFX_FNF_HOWL_WAR_CRY               = 285;
int VFX_FNF_SCREEN_SHAKE               = 286;
int VFX_FNF_SCREEN_BUMP                = 287;
int VFX_COM_HIT_NEGATIVE               = 288;
int VFX_COM_HIT_DIVINE                 = 289;
int VFX_FNF_HOWL_WAR_CRY_FEMALE        = 290;
int VFX_DUR_AURA_DRAGON_FEAR           = 291;
int VFX_DUR_FLAG_RED                   = 303;
int VFX_DUR_FLAG_BLUE                  = 304;
int VFX_DUR_FLAG_GOLD                  = 305;
int VFX_DUR_FLAG_PURPLE                = 306;
int VFX_DUR_FLAG_GOLD_FIXED            = 306;
int VFX_DUR_FLAG_PURPLE_FIXED          = 305;
int VFX_DUR_TENTACLE                   = 346;
int VFX_DUR_PETRIFY                    = 351;
int VFX_DUR_FREEZE_ANIMATION           = 352;

int VFX_COM_CHUNK_STONE_SMALL          = 353;
int VFX_COM_CHUNK_STONE_MEDIUM         = 354;

int VFX_BEAM_SILENT_LIGHTNING          = 307;
int VFX_BEAM_SILENT_FIRE               = 308;
int VFX_BEAM_SILENT_COLD               = 309;
int VFX_BEAM_SILENT_HOLY               = 310;
int VFX_BEAM_SILENT_MIND               = 311;
int VFX_BEAM_SILENT_EVIL               = 312;
int VFX_BEAM_SILENT_ODD                = 313;
int VFX_DUR_BIGBYS_INTERPOSING_HAND    = 314;
int VFX_IMP_BIGBYS_FORCEFUL_HAND       = 315;
int VFX_DUR_BIGBYS_CLENCHED_FIST       = 316;
int VFX_DUR_BIGBYS_CRUSHING_HAND       = 317;
int VFX_DUR_BIGBYS_GRASPING_HAND       = 318;

int VFX_DUR_CALTROPS                   = 319;
int VFX_DUR_SMOKE                      = 320;
int VFX_DUR_PIXIEDUST                  = 321;
int VFX_FNF_DECK                       = 322;
int VFX_DUR_CUTSCENE_INVISIBILITY      = 355;
int VFX_EYES_RED_FLAME_HUMAN_MALE      = 360;
int VFX_EYES_RED_FLAME_HUMAN_FEMALE    = 361;
int VFX_EYES_RED_FLAME_HALFELF_MALE    = 360;
int VFX_EYES_RED_FLAME_HALFELF_FEMALE  = 361;
int VFX_EYES_RED_FLAME_DWARF_MALE      = 362;
int VFX_EYES_RED_FLAME_DWARF_FEMALE    = 363;
int VFX_EYES_RED_FLAME_ELF_MALE        = 364;
int VFX_EYES_RED_FLAME_ELF_FEMALE      = 365;
int VFX_EYES_RED_FLAME_GNOME_MALE      = 366;
int VFX_EYES_RED_FLAME_GNOME_FEMALE    = 367;
int VFX_EYES_RED_FLAME_HALFLING_MALE   = 368;
int VFX_EYES_RED_FLAME_HALFLING_FEMALE = 369;
int VFX_EYES_RED_FLAME_HALFORC_MALE    = 370;
int VFX_EYES_RED_FLAME_HALFORC_FEMALE  = 371;
int VFX_EYES_RED_FLAME_TROGLODYTE      = 372;
int VFX_EYES_YEL_HUMAN_MALE            = 373;
int VFX_EYES_YEL_HUMAN_FEMALE          = 374;
int VFX_EYES_YEL_DWARF_MALE            = 375;
int VFX_EYES_YEL_DWARF_FEMALE          = 376;
int VFX_EYES_YEL_ELF_MALE              = 377;
int VFX_EYES_YEL_ELF_FEMALE            = 378;
int VFX_EYES_YEL_GNOME_MALE            = 379;
int VFX_EYES_YEL_GNOME_FEMALE          = 380;
int VFX_EYES_YEL_HALFLING_MALE         = 381;
int VFX_EYES_YEL_HALFLING_FEMALE       = 382;
int VFX_EYES_YEL_HALFORC_MALE          = 383;
int VFX_EYES_YEL_HALFORC_FEMALE        = 384;
int VFX_EYES_YEL_TROGLODYTE            = 385;
int VFX_EYES_ORG_HUMAN_MALE            = 386;
int VFX_EYES_ORG_HUMAN_FEMALE          = 387;
int VFX_EYES_ORG_DWARF_MALE            = 388;
int VFX_EYES_ORG_DWARF_FEMALE          = 389;
int VFX_EYES_ORG_ELF_MALE              = 390;
int VFX_EYES_ORG_ELF_FEMALE            = 391;
int VFX_EYES_ORG_GNOME_MALE            = 392;
int VFX_EYES_ORG_GNOME_FEMALE          = 393;
int VFX_EYES_ORG_HALFLING_MALE         = 394;
int VFX_EYES_ORG_HALFLING_FEMALE       = 395;
int VFX_EYES_ORG_HALFORC_MALE          = 396;
int VFX_EYES_ORG_HALFORC_FEMALE        = 397;
int VFX_EYES_ORG_TROGLODYTE            = 398;
int VFX_DUR_IOUNSTONE                  = 403;
int VFX_IMP_TORNADO                    = 407;
int VFX_DUR_GLOW_LIGHT_BLUE            = 408;
int VFX_DUR_GLOW_PURPLE                = 409;
int VFX_DUR_GLOW_BLUE                  = 410;
int VFX_DUR_GLOW_RED                   = 411;
int VFX_DUR_GLOW_LIGHT_RED             = 412;
int VFX_DUR_GLOW_YELLOW                = 413;
int VFX_DUR_GLOW_LIGHT_YELLOW          = 414;
int VFX_DUR_GLOW_GREEN                 = 415;
int VFX_DUR_GLOW_LIGHT_GREEN           = 416;
int VFX_DUR_GLOW_ORANGE                = 417;
int VFX_DUR_GLOW_LIGHT_ORANGE          = 418;
int VFX_DUR_GLOW_BROWN                 = 419;
int VFX_DUR_GLOW_LIGHT_BROWN           = 420;
int VFX_DUR_GLOW_GREY                  = 421;
int VFX_DUR_GLOW_WHITE                 = 422;
int VFX_DUR_GLOW_LIGHT_PURPLE          = 423;
int VFX_DUR_GHOST_TRANSPARENT          = 424;
int VFX_DUR_GHOST_SMOKE                = 425;
int VFX_DUR_GLYPH_OF_WARDING           = 445;
int VFX_FNF_SOUND_BURST_SILENT         = 446;
int VFX_BEAM_DISINTEGRATE              = 447;
int VFX_FNF_ELECTRIC_EXPLOSION         = 459;
int VFX_IMP_DUST_EXPLOSION             = 460;
int VFX_IMP_PULSE_HOLY_SILENT          = 461;
int VFX_DUR_DEATH_ARMOR                = 463;
int VFX_DUR_ICESKIN                    = 465;
int VFX_FNF_SWINGING_BLADE             = 473;
int VFX_DUR_INFERNO                    = 474;
int VFX_FNF_DEMON_HAND                 = 475;
int VFX_DUR_STONEHOLD                  = 476;
int VFX_FNF_MYSTICAL_EXPLOSION         = 477;
int VFX_DUR_GHOSTLY_VISAGE_NO_SOUND    = 478;
int VFX_DUR_GHOST_SMOKE_2              = 479;
int VFX_DUR_FLIES                      = 480;
int VFX_FNF_SUMMONDRAGON               = 481;
int VFX_BEAM_FIRE_W                    = 482;
int VFX_BEAM_FIRE_W_SILENT             = 483;
int VFX_BEAM_CHAIN                     = 484;
int VFX_BEAM_BLACK                     = 485;
int VFX_IMP_WALLSPIKE                  = 486;
int VFX_FNF_GREATER_RUIN               = 487;
int VFX_FNF_UNDEAD_DRAGON              = 488;
int VFX_DUR_PROT_EPIC_ARMOR            = 495;
int VFX_FNF_SUMMON_EPIC_UNDEAD         = 496;
int VFX_DUR_PROT_EPIC_ARMOR_2          = 497;
int VFX_DUR_INFERNO_CHEST              = 498;
int VFX_DUR_IOUNSTONE_RED              = 499;
int VFX_DUR_IOUNSTONE_BLUE             = 500;
int VFX_DUR_IOUNSTONE_YELLOW           = 501;
int VFX_DUR_IOUNSTONE_GREEN            = 502;
int VFX_IMP_MIRV_ELECTRIC              = 503;
int VFX_COM_CHUNK_RED_BALLISTA         = 504;
int VFX_DUR_INFERNO_NO_SOUND           = 505;
int VFX_DUR_AURA_PULSE_RED_WHITE       = 512;
int VFX_DUR_AURA_PULSE_BLUE_WHITE      = 513;
int VFX_DUR_AURA_PULSE_GREEN_WHITE     = 514;
int VFX_DUR_AURA_PULSE_YELLOW_WHITE    = 515;
int VFX_DUR_AURA_PULSE_MAGENTA_WHITE   = 516;
int VFX_DUR_AURA_PULSE_CYAN_WHITE      = 517;
int VFX_DUR_AURA_PULSE_ORANGE_WHITE    = 518;
int VFX_DUR_AURA_PULSE_BROWN_WHITE     = 519;
int VFX_DUR_AURA_PULSE_PURPLE_WHITE    = 520;
int VFX_DUR_AURA_PULSE_GREY_WHITE      = 521;
int VFX_DUR_AURA_PULSE_GREY_BLACK      = 522;
int VFX_DUR_AURA_PULSE_BLUE_GREEN      = 523;
int VFX_DUR_AURA_PULSE_RED_BLUE        = 524;
int VFX_DUR_AURA_PULSE_RED_YELLOW      = 525;
int VFX_DUR_AURA_PULSE_GREEN_YELLOW    = 526;
int VFX_DUR_AURA_PULSE_RED_GREEN       = 527;
int VFX_DUR_AURA_PULSE_BLUE_YELLOW     = 528;
int VFX_DUR_AURA_PULSE_BLUE_BLACK      = 529;
int VFX_DUR_AURA_PULSE_RED_BLACK       = 530;
int VFX_DUR_AURA_PULSE_GREEN_BLACK     = 531;
int VFX_DUR_AURA_PULSE_YELLOW_BLACK    = 532;
int VFX_DUR_AURA_PULSE_MAGENTA_BLACK   = 533;
int VFX_DUR_AURA_PULSE_CYAN_BLACK      = 534;
int VFX_DUR_AURA_PULSE_ORANGE_BLACK    = 535;
int VFX_DUR_AURA_PULSE_BROWN_BLACK     = 536;
int VFX_DUR_AURA_PULSE_PURPLE_BLACK    = 537;
int VFX_DUR_AURA_PULSE_CYAN_GREEN      = 538;
int VFX_DUR_AURA_PULSE_CYAN_BLUE       = 539;
int VFX_DUR_AURA_PULSE_CYAN_RED        = 540;
int VFX_DUR_AURA_PULSE_CYAN_YELLOW     = 541;
int VFX_DUR_AURA_PULSE_MAGENTA_BLUE    = 542;
int VFX_DUR_AURA_PULSE_MAGENTA_RED     = 543;
int VFX_DUR_AURA_PULSE_MAGENTA_GREEN   = 544;
int VFX_DUR_AURA_PULSE_MAGENTA_YELLOW  = 545;
int VFX_DUR_AURA_PULSE_RED_ORANGE      = 546;
int VFX_DUR_AURA_PULSE_YELLOW_ORANGE   = 547;
int VFX_DUR_AURA_RED                   = 548;
int VFX_DUR_AURA_GREEN                 = 549;
int VFX_DUR_AURA_BLUE                  = 550;
int VFX_DUR_AURA_MAGENTA               = 551;
int VFX_DUR_AURA_YELLOW                = 552;
int VFX_DUR_AURA_WHITE                 = 553;
int VFX_DUR_AURA_ORANGE                = 554;
int VFX_DUR_AURA_BROWN                 = 555;
int VFX_DUR_AURA_PURPLE                = 556;
int VFX_DUR_AURA_CYAN                  = 557;
int VFX_DUR_AURA_GREEN_DARK            = 558;
int VFX_DUR_AURA_GREEN_LIGHT           = 559;
int VFX_DUR_AURA_RED_DARK              = 560;
int VFX_DUR_AURA_RED_LIGHT             = 561;
int VFX_DUR_AURA_BLUE_DARK             = 562;
int VFX_DUR_AURA_BLUE_LIGHT            = 563;
int VFX_DUR_AURA_YELLOW_DARK           = 564;
int VFX_DUR_AURA_YELLOW_LIGHT          = 565;
int VFX_DUR_BUBBLES                    = 566;
int VFX_EYES_GREEN_HUMAN_MALE          = 567;
int VFX_EYES_GREEN_HUMAN_FEMALE        = 568;
int VFX_EYES_GREEN_HALFELF_MALE        = 567;
int VFX_EYES_GREEN_HALFELF_FEMALE      = 568;
int VFX_EYES_GREEN_DWARF_MALE          = 569;
int VFX_EYES_GREEN_DWARF_FEMALE        = 570;
int VFX_EYES_GREEN_ELF_MALE            = 571;
int VFX_EYES_GREEN_ELF_FEMALE          = 572;
int VFX_EYES_GREEN_GNOME_MALE          = 573;
int VFX_EYES_GREEN_GNOME_FEMALE        = 574;
int VFX_EYES_GREEN_HALFLING_MALE       = 575;
int VFX_EYES_GREEN_HALFLING_FEMALE     = 576;
int VFX_EYES_GREEN_HALFORC_MALE        = 577;
int VFX_EYES_GREEN_HALFORC_FEMALE      = 578;
int VFX_EYES_GREEN_TROGLODYTE          = 579;
int VFX_EYES_PUR_HUMAN_MALE            = 580;
int VFX_EYES_PUR_HUMAN_FEMALE          = 581;
int VFX_EYES_PUR_DWARF_MALE            = 582;
int VFX_EYES_PUR_DWARF_FEMALE          = 583;
int VFX_EYES_PUR_ELF_MALE              = 584;
int VFX_EYES_PUR_ELF_FEMALE            = 585;
int VFX_EYES_PUR_GNOME_MALE            = 586;
int VFX_EYES_PUR_GNOME_FEMALE          = 587;
int VFX_EYES_PUR_HALFLING_MALE         = 588;
int VFX_EYES_PUR_HALFLING_FEMALE       = 589;
int VFX_EYES_PUR_HALFORC_MALE          = 590;
int VFX_EYES_PUR_HALFORC_FEMALE        = 591;
int VFX_EYES_PUR_TROGLODYTE            = 592;
int VFX_EYES_CYN_HUMAN_MALE            = 593;
int VFX_EYES_CYN_HUMAN_FEMALE          = 594;
int VFX_EYES_CYN_DWARF_MALE            = 595;
int VFX_EYES_CYN_DWARF_FEMALE          = 596;
int VFX_EYES_CYN_ELF_MALE              = 597;
int VFX_EYES_CYN_ELF_FEMALE            = 598;
int VFX_EYES_CYN_GNOME_MALE            = 599;
int VFX_EYES_CYN_GNOME_FEMALE          = 600;
int VFX_EYES_CYN_HALFLING_MALE         = 601;
int VFX_EYES_CYN_HALFLING_FEMALE       = 602;
int VFX_EYES_CYN_HALFORC_MALE          = 603;
int VFX_EYES_CYN_HALFORC_FEMALE        = 604;
int VFX_EYES_CYN_TROGLODYTE            = 605;
int VFX_EYES_WHT_HUMAN_MALE            = 606;
int VFX_EYES_WHT_HUMAN_FEMALE          = 607;
int VFX_EYES_WHT_DWARF_MALE            = 608;
int VFX_EYES_WHT_DWARF_FEMALE          = 609;
int VFX_EYES_WHT_ELF_MALE              = 610;
int VFX_EYES_WHT_ELF_FEMALE            = 611;
int VFX_EYES_WHT_GNOME_MALE            = 612;
int VFX_EYES_WHT_GNOME_FEMALE          = 613;
int VFX_EYES_WHT_HALFLING_MALE         = 614;
int VFX_EYES_WHT_HALFLING_FEMALE       = 615;
int VFX_EYES_WHT_HALFORC_MALE          = 616;
int VFX_EYES_WHT_HALFORC_FEMALE        = 617;
int VFX_EYES_WHT_TROGLODYTE            = 618;
int VFX_IMP_PDK_GENERIC_PULSE          = 623;
int VFX_IMP_PDK_GENERIC_HEAD_HIT       = 624;
int VFX_IMP_PDK_RALLYING_CRY           = 625;
int VFX_IMP_PDK_HEROIC_SHIELD          = 626;
int VFX_IMP_PDK_INSPIRE_COURAGE        = 627;
int VFX_DUR_PDK_FEAR                   = 628;
int VFX_IMP_PDK_WRATH                  = 629;
int VFX_IMP_PDK_OATH                   = 630;
int VFX_IMP_PDK_FINAL_STAND            = 631;
int VFX_DUR_ARROW_IN_STERNUM           = 632;
int VFX_DUR_ARROW_IN_CHEST_LEFT        = 633;
int VFX_DUR_ARROW_IN_CHEST_RIGHT       = 634;
int VFX_DUR_ARROW_IN_BACK              = 635;
int VFX_DUR_ARROW_IN_TEMPLES           = 636;
int VFX_DUR_ARROW_IN_FACE              = 637;
int VFX_DUR_ARROW_IN_HEAD              = 638;
int VFX_DUR_QUILL_IN_CHEST             = 639;
int VFX_IMP_STARBURST_GREEN            = 644;
int VFX_IMP_STARBURST_RED              = 645;
int VFX_IMP_NIGHTMARE_HEAD_HIT         = 670;

//VFX_Persistent.2da
int AOE_PER_FOGACID                = 0;
int AOE_PER_FOGFIRE                = 1;
int AOE_PER_FOGSTINK               = 2;
int AOE_PER_FOGKILL                = 3;
int AOE_PER_FOGMIND                = 4;
int AOE_PER_WALLFIRE               = 5;
int AOE_PER_WALLWIND               = 6;
int AOE_PER_WALLBLADE              = 7;
int AOE_PER_WEB                    = 8;
int AOE_PER_ENTANGLE               = 9;
//int AOE_PER_CHAOS = 10;
int AOE_PER_DARKNESS               = 11;
int AOE_MOB_CIRCEVIL               = 12;
int AOE_MOB_CIRCGOOD               = 13;
int AOE_MOB_CIRCLAW                = 14;
int AOE_MOB_CIRCCHAOS              = 15;
int AOE_MOB_FEAR                   = 16;
int AOE_MOB_BLINDING               = 17;
int AOE_MOB_UNEARTHLY              = 18;
int AOE_MOB_MENACE                 = 19;
int AOE_MOB_UNNATURAL              = 20;
int AOE_MOB_STUN                   = 21;
int AOE_MOB_PROTECTION             = 22;
int AOE_MOB_FIRE                   = 23;
int AOE_MOB_FROST                  = 24;
int AOE_MOB_ELECTRICAL             = 25;
int AOE_PER_FOGGHOUL               = 26;
int AOE_MOB_TYRANT_FOG             = 27;
int AOE_PER_STORM                  = 28;
int AOE_PER_INVIS_SPHERE           = 29;
int AOE_MOB_SILENCE                = 30;
int AOE_PER_DELAY_BLAST_FIREBALL   = 31;
int AOE_PER_GREASE                 = 32;
int AOE_PER_CREEPING_DOOM          = 33;
int AOE_PER_EVARDS_BLACK_TENTACLES = 34;
int AOE_MOB_INVISIBILITY_PURGE     = 35;
int AOE_MOB_DRAGON_FEAR            = 36;
int AOE_PER_CUSTOM_AOE             = 37;
int AOE_PER_GLYPH_OF_WARDING       = 38;
int AOE_PER_FOG_OF_BEWILDERMENT    = 39;
int AOE_PER_VINE_MINE_CAMOUFLAGE   = 40;
int AOE_MOB_TIDE_OF_BATTLE         = 41;
int AOE_PER_STONEHOLD              = 42;
int AOE_PER_OVERMIND               = 43;
int AOE_MOB_HORRIFICAPPEARANCE     = 44;
int AOE_MOB_TROGLODYTE_STENCH      = 45;

int SPELL_ALL_SPELLS                        = -1;  // used for spell immunity.
int SPELL_ACID_FOG                          = 0;
int SPELL_AID                               = 1;
int SPELL_ANIMATE_DEAD                      = 2;
int SPELL_BARKSKIN                          = 3;
int SPELL_BESTOW_CURSE                      = 4;
int SPELL_BLADE_BARRIER                     = 5;
int SPELL_BLESS                             = 6;
int SPELL_BLESS_WEAPON                      = 537;
int SPELL_BLINDNESS_AND_DEAFNESS            = 8;
int SPELL_BULLS_STRENGTH                    = 9;
int SPELL_BURNING_HANDS                     = 10;
int SPELL_CALL_LIGHTNING                    = 11;
//int SPELL_CALM_EMOTIONS = 12;
int SPELL_CATS_GRACE                        = 13;
int SPELL_CHAIN_LIGHTNING                   = 14;
int SPELL_CHARM_MONSTER                     = 15;
int SPELL_CHARM_PERSON                      = 16;
int SPELL_CHARM_PERSON_OR_ANIMAL            = 17;
int SPELL_CIRCLE_OF_DEATH                   = 18;
int SPELL_CIRCLE_OF_DOOM                    = 19;
int SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE    = 20;
int SPELL_CLARITY                           = 21;
int SPELL_CLOAK_OF_CHAOS                    = 22;
int SPELL_CLOUDKILL                         = 23;
int SPELL_COLOR_SPRAY                       = 24;
int SPELL_CONE_OF_COLD                      = 25;
int SPELL_CONFUSION                         = 26;
int SPELL_CONTAGION                         = 27;
int SPELL_CONTROL_UNDEAD                    = 28;
int SPELL_CREATE_GREATER_UNDEAD             = 29;
int SPELL_CREATE_UNDEAD                     = 30;
int SPELL_CURE_CRITICAL_WOUNDS              = 31;
int SPELL_CURE_LIGHT_WOUNDS                 = 32;
int SPELL_CURE_MINOR_WOUNDS                 = 33;
int SPELL_CURE_MODERATE_WOUNDS              = 34;
int SPELL_CURE_SERIOUS_WOUNDS               = 35;
int SPELL_DARKNESS                          = 36;
int SPELL_DAZE                              = 37;
int SPELL_DEATH_WARD                        = 38;
int SPELL_DELAYED_BLAST_FIREBALL            = 39;
int SPELL_DISMISSAL                         = 40;
int SPELL_DISPEL_MAGIC                      = 41;
int SPELL_DIVINE_POWER                      = 42;
int SPELL_DOMINATE_ANIMAL                   = 43;
int SPELL_DOMINATE_MONSTER                  = 44;
int SPELL_DOMINATE_PERSON                   = 45;
int SPELL_DOOM                              = 46;
int SPELL_ELEMENTAL_SHIELD                  = 47;
int SPELL_ELEMENTAL_SWARM                   = 48;
int SPELL_ENDURANCE                         = 49;
int SPELL_ENDURE_ELEMENTS                   = 50;
int SPELL_ENERGY_DRAIN                      = 51;
int SPELL_ENERVATION                        = 52;
int SPELL_ENTANGLE                          = 53;
int SPELL_FEAR                              = 54;
int SPELL_FEEBLEMIND                        = 55;
int SPELL_FINGER_OF_DEATH                   = 56;
int SPELL_FIRE_STORM                        = 57;
int SPELL_FIREBALL                          = 58;
int SPELL_FLAME_ARROW                       = 59;
int SPELL_FLAME_LASH                        = 60;
int SPELL_FLAME_STRIKE                      = 61;
int SPELL_FREEDOM_OF_MOVEMENT               = 62;
int SPELL_GATE                              = 63;
int SPELL_GHOUL_TOUCH                       = 64;
int SPELL_GLOBE_OF_INVULNERABILITY          = 65;
int SPELL_GREASE                            = 66;
int SPELL_GREATER_DISPELLING                = 67;
//int SPELL_GREATER_MAGIC_WEAPON              = 68;
int SPELL_GREATER_PLANAR_BINDING            = 69;
int SPELL_GREATER_RESTORATION               = 70;
//int SPELL_GREATER_SHADOW_CONJURATION = 71;
int SPELL_GREATER_SPELL_BREACH              = 72;
int SPELL_GREATER_SPELL_MANTLE              = 73;
int SPELL_GREATER_STONESKIN                 = 74;
int SPELL_GUST_OF_WIND = 75;
int SPELL_HAMMER_OF_THE_GODS                = 76;
int SPELL_HARM                              = 77;
int SPELL_HASTE                             = 78;
int SPELL_HEAL                              = 79;
int SPELL_HEALING_CIRCLE                    = 80;
int SPELL_HOLD_ANIMAL                       = 81;
int SPELL_HOLD_MONSTER                      = 82;
int SPELL_HOLD_PERSON                       = 83;
int SPELL_HOLY_AURA                         = 84;
int SPELL_HOLY_SWORD                        = 538;
int SPELL_IDENTIFY                          = 86;
int SPELL_IMPLOSION                         = 87;
int SPELL_IMPROVED_INVISIBILITY             = 88;
int SPELL_INCENDIARY_CLOUD                  = 89;
int SPELL_INVISIBILITY                      = 90;
int SPELL_INVISIBILITY_PURGE                = 91;
int SPELL_INVISIBILITY_SPHERE               = 92;
int SPELL_KNOCK                             = 93;
int SPELL_LESSER_DISPEL                     = 94;
int SPELL_LESSER_MIND_BLANK                 = 95;
int SPELL_LESSER_PLANAR_BINDING             = 96;
int SPELL_LESSER_RESTORATION                = 97;
int SPELL_LESSER_SPELL_BREACH               = 98;
int SPELL_LESSER_SPELL_MANTLE               = 99;
int SPELL_LIGHT                             = 100;
int SPELL_LIGHTNING_BOLT                    = 101;
int SPELL_MAGE_ARMOR                        = 102;
int SPELL_MAGIC_CIRCLE_AGAINST_CHAOS        = 103;
int SPELL_MAGIC_CIRCLE_AGAINST_EVIL         = 104;
int SPELL_MAGIC_CIRCLE_AGAINST_GOOD         = 105;
int SPELL_MAGIC_CIRCLE_AGAINST_LAW          = 106;
int SPELL_MAGIC_MISSILE                     = 107;
int SPELL_MAGIC_VESTMENT                    = 546;
//int SPELL_MAGIC_WEAPON                      = 109;
int SPELL_MASS_BLINDNESS_AND_DEAFNESS       = 110;
int SPELL_MASS_CHARM                        = 111;
// int SPELL_MASS_DOMINATION = 112;
int SPELL_MASS_HASTE                        = 113;
int SPELL_MASS_HEAL                         = 114;
int SPELL_MELFS_ACID_ARROW                  = 115;
int SPELL_METEOR_SWARM                      = 116;
int SPELL_MIND_BLANK                        = 117;
int SPELL_MIND_FOG                          = 118;
int SPELL_MINOR_GLOBE_OF_INVULNERABILITY    = 119;
int SPELL_GHOSTLY_VISAGE                    = 120;
int SPELL_ETHEREAL_VISAGE                   = 121;
int SPELL_MORDENKAINENS_DISJUNCTION         = 122;
int SPELL_MORDENKAINENS_SWORD               = 123;
int SPELL_NATURES_BALANCE                   = 124;
int SPELL_NEGATIVE_ENERGY_PROTECTION        = 125;
int SPELL_NEUTRALIZE_POISON                 = 126;
int SPELL_PHANTASMAL_KILLER                 = 127;
int SPELL_PLANAR_BINDING                    = 128;
int SPELL_POISON                            = 129;
int SPELL_POLYMORPH_SELF                    = 130;
int SPELL_POWER_WORD_KILL                   = 131;
int SPELL_POWER_WORD_STUN                   = 132;
int SPELL_PRAYER                            = 133;
int SPELL_PREMONITION                       = 134;
int SPELL_PRISMATIC_SPRAY                   = 135;
int SPELL_PROTECTION__FROM_CHAOS            = 136;
int SPELL_PROTECTION_FROM_ELEMENTS          = 137;
int SPELL_PROTECTION_FROM_EVIL              = 138;
int SPELL_PROTECTION_FROM_GOOD              = 139;
int SPELL_PROTECTION_FROM_LAW               = 140;
int SPELL_PROTECTION_FROM_SPELLS            = 141;
int SPELL_RAISE_DEAD                        = 142;
int SPELL_RAY_OF_ENFEEBLEMENT               = 143;
int SPELL_RAY_OF_FROST                      = 144;
int SPELL_REMOVE_BLINDNESS_AND_DEAFNESS     = 145;
int SPELL_REMOVE_CURSE                      = 146;
int SPELL_REMOVE_DISEASE                    = 147;
int SPELL_REMOVE_FEAR                       = 148;
int SPELL_REMOVE_PARALYSIS                  = 149;
int SPELL_RESIST_ELEMENTS                   = 150;
int SPELL_RESISTANCE                        = 151;
int SPELL_RESTORATION                       = 152;
int SPELL_RESURRECTION                      = 153;
int SPELL_SANCTUARY                         = 154;
int SPELL_SCARE                             = 155;
int SPELL_SEARING_LIGHT                     = 156;
int SPELL_SEE_INVISIBILITY                  = 157;
//int SPELL_SHADES = 158;
//int SPELL_SHADOW_CONJURATION = 159;
int SPELL_SHADOW_SHIELD                     = 160;
int SPELL_SHAPECHANGE                       = 161;
int SPELL_SHIELD_OF_LAW                     = 162;
int SPELL_SILENCE                           = 163;
int SPELL_SLAY_LIVING                       = 164;
int SPELL_SLEEP                             = 165;
int SPELL_SLOW                              = 166;
int SPELL_SOUND_BURST                       = 167;
int SPELL_SPELL_RESISTANCE                  = 168;
int SPELL_SPELL_MANTLE                      = 169;
int SPELL_SPHERE_OF_CHAOS                   = 170;
int SPELL_STINKING_CLOUD                    = 171;
int SPELL_STONESKIN                         = 172;
int SPELL_STORM_OF_VENGEANCE                = 173;
int SPELL_SUMMON_CREATURE_I                 = 174;
int SPELL_SUMMON_CREATURE_II                = 175;
int SPELL_SUMMON_CREATURE_III               = 176;
int SPELL_SUMMON_CREATURE_IV                = 177;
int SPELL_SUMMON_CREATURE_IX                = 178;
int SPELL_SUMMON_CREATURE_V                 = 179;
int SPELL_SUMMON_CREATURE_VI                = 180;
int SPELL_SUMMON_CREATURE_VII               = 181;
int SPELL_SUMMON_CREATURE_VIII              = 182;
int SPELL_SUNBEAM                           = 183;
int SPELL_TENSERS_TRANSFORMATION            = 184;
int SPELL_TIME_STOP                         = 185;
int SPELL_TRUE_SEEING                       = 186;
int SPELL_UNHOLY_AURA                       = 187;
int SPELL_VAMPIRIC_TOUCH                    = 188;
int SPELL_VIRTUE                            = 189;
int SPELL_WAIL_OF_THE_BANSHEE               = 190;
int SPELL_WALL_OF_FIRE                      = 191;
int SPELL_WEB                               = 192;
int SPELL_WEIRD                             = 193;
int SPELL_WORD_OF_FAITH                     = 194;
int SPELLABILITY_AURA_BLINDING              = 195;
int SPELLABILITY_AURA_COLD                  = 196;
int SPELLABILITY_AURA_ELECTRICITY           = 197;
int SPELLABILITY_AURA_FEAR                  = 198;
int SPELLABILITY_AURA_FIRE                  = 199;
int SPELLABILITY_AURA_MENACE                = 200;
int SPELLABILITY_AURA_PROTECTION            = 201;
int SPELLABILITY_AURA_STUN                  = 202;
int SPELLABILITY_AURA_UNEARTHLY_VISAGE      = 203;
int SPELLABILITY_AURA_UNNATURAL             = 204;
int SPELLABILITY_BOLT_ABILITY_DRAIN_CHARISMA = 205;
int SPELLABILITY_BOLT_ABILITY_DRAIN_CONSTITUTION = 206;
int SPELLABILITY_BOLT_ABILITY_DRAIN_DEXTERITY = 207;
int SPELLABILITY_BOLT_ABILITY_DRAIN_INTELLIGENCE = 208;
int SPELLABILITY_BOLT_ABILITY_DRAIN_STRENGTH = 209;
int SPELLABILITY_BOLT_ABILITY_DRAIN_WISDOM  = 210;
int SPELLABILITY_BOLT_ACID                  = 211;
int SPELLABILITY_BOLT_CHARM                 = 212;
int SPELLABILITY_BOLT_COLD                  = 213;
int SPELLABILITY_BOLT_CONFUSE               = 214;
int SPELLABILITY_BOLT_DAZE                  = 215;
int SPELLABILITY_BOLT_DEATH                 = 216;
int SPELLABILITY_BOLT_DISEASE               = 217;
int SPELLABILITY_BOLT_DOMINATE              = 218;
int SPELLABILITY_BOLT_FIRE                  = 219;
int SPELLABILITY_BOLT_KNOCKDOWN             = 220;
int SPELLABILITY_BOLT_LEVEL_DRAIN           = 221;
int SPELLABILITY_BOLT_LIGHTNING             = 222;
int SPELLABILITY_BOLT_PARALYZE              = 223;
int SPELLABILITY_BOLT_POISON                = 224;
int SPELLABILITY_BOLT_SHARDS                = 225;
int SPELLABILITY_BOLT_SLOW                  = 226;
int SPELLABILITY_BOLT_STUN                  = 227;
int SPELLABILITY_BOLT_WEB                   = 228;
int SPELLABILITY_CONE_ACID                  = 229;
int SPELLABILITY_CONE_COLD                  = 230;
int SPELLABILITY_CONE_DISEASE               = 231;
int SPELLABILITY_CONE_FIRE                  = 232;
int SPELLABILITY_CONE_LIGHTNING             = 233;
int SPELLABILITY_CONE_POISON                = 234;
int SPELLABILITY_CONE_SONIC                 = 235;
int SPELLABILITY_DRAGON_BREATH_ACID         = 236;
int SPELLABILITY_DRAGON_BREATH_COLD         = 237;
int SPELLABILITY_DRAGON_BREATH_FEAR         = 238;
int SPELLABILITY_DRAGON_BREATH_FIRE         = 239;
int SPELLABILITY_DRAGON_BREATH_GAS          = 240;
int SPELLABILITY_DRAGON_BREATH_LIGHTNING    = 241;
int SPELLABILITY_DRAGON_BREATH_PARALYZE     = 242;
int SPELLABILITY_DRAGON_BREATH_SLEEP        = 243;
int SPELLABILITY_DRAGON_BREATH_SLOW         = 244;
int SPELLABILITY_DRAGON_BREATH_WEAKEN       = 245;
int SPELLABILITY_DRAGON_WING_BUFFET         = 246;
int SPELLABILITY_FEROCITY_1                 = 247;
int SPELLABILITY_FEROCITY_2                 = 248;
int SPELLABILITY_FEROCITY_3                 = 249;
int SPELLABILITY_GAZE_CHARM                 = 250;
int SPELLABILITY_GAZE_CONFUSION             = 251;
int SPELLABILITY_GAZE_DAZE                  = 252;
int SPELLABILITY_GAZE_DEATH                 = 253;
int SPELLABILITY_GAZE_DESTROY_CHAOS         = 254;
int SPELLABILITY_GAZE_DESTROY_EVIL          = 255;
int SPELLABILITY_GAZE_DESTROY_GOOD          = 256;
int SPELLABILITY_GAZE_DESTROY_LAW           = 257;
int SPELLABILITY_GAZE_DOMINATE              = 258;
int SPELLABILITY_GAZE_DOOM                  = 259;
int SPELLABILITY_GAZE_FEAR                  = 260;
int SPELLABILITY_GAZE_PARALYSIS             = 261;
int SPELLABILITY_GAZE_STUNNED               = 262;
int SPELLABILITY_GOLEM_BREATH_GAS           = 263;
int SPELLABILITY_HELL_HOUND_FIREBREATH      = 264;
int SPELLABILITY_HOWL_CONFUSE               = 265;
int SPELLABILITY_HOWL_DAZE                  = 266;
int SPELLABILITY_HOWL_DEATH                 = 267;
int SPELLABILITY_HOWL_DOOM                  = 268;
int SPELLABILITY_HOWL_FEAR                  = 269;
int SPELLABILITY_HOWL_PARALYSIS             = 270;
int SPELLABILITY_HOWL_SONIC                 = 271;
int SPELLABILITY_HOWL_STUN                  = 272;
int SPELLABILITY_INTENSITY_1                = 273;
int SPELLABILITY_INTENSITY_2                = 274;
int SPELLABILITY_INTENSITY_3                = 275;
int SPELLABILITY_KRENSHAR_SCARE             = 276;
int SPELLABILITY_LESSER_BODY_ADJUSTMENT     = 277;
int SPELLABILITY_MEPHIT_SALT_BREATH         = 278;
int SPELLABILITY_MEPHIT_STEAM_BREATH        = 279;
int SPELLABILITY_MUMMY_BOLSTER_UNDEAD       = 280;
int SPELLABILITY_PULSE_DROWN                = 281;
int SPELLABILITY_PULSE_SPORES               = 282;
int SPELLABILITY_PULSE_WHIRLWIND            = 283;
int SPELLABILITY_PULSE_FIRE                 = 284;
int SPELLABILITY_PULSE_LIGHTNING            = 285;
int SPELLABILITY_PULSE_COLD                 = 286;
int SPELLABILITY_PULSE_NEGATIVE             = 287;
int SPELLABILITY_PULSE_HOLY                 = 288;
int SPELLABILITY_PULSE_DEATH                = 289;
int SPELLABILITY_PULSE_LEVEL_DRAIN          = 290;
int SPELLABILITY_PULSE_ABILITY_DRAIN_INTELLIGENCE = 291;
int SPELLABILITY_PULSE_ABILITY_DRAIN_CHARISMA = 292;
int SPELLABILITY_PULSE_ABILITY_DRAIN_CONSTITUTION = 293;
int SPELLABILITY_PULSE_ABILITY_DRAIN_DEXTERITY = 294;
int SPELLABILITY_PULSE_ABILITY_DRAIN_STRENGTH = 295;
int SPELLABILITY_PULSE_ABILITY_DRAIN_WISDOM = 296;
int SPELLABILITY_PULSE_POISON               = 297;
int SPELLABILITY_PULSE_DISEASE              = 298;
int SPELLABILITY_RAGE_3                     = 299;
int SPELLABILITY_RAGE_4                     = 300;
int SPELLABILITY_RAGE_5                     = 301;
int SPELLABILITY_SMOKE_CLAW                 = 302;
int SPELLABILITY_SUMMON_SLAAD               = 303;
int SPELLABILITY_SUMMON_TANARRI             = 304;
int SPELLABILITY_TRUMPET_BLAST              = 305;
int SPELLABILITY_TYRANT_FOG_MIST            = 306;
int SPELLABILITY_BARBARIAN_RAGE             = 307;
int SPELLABILITY_TURN_UNDEAD                = 308;
int SPELLABILITY_WHOLENESS_OF_BODY          = 309;
int SPELLABILITY_QUIVERING_PALM             = 310;
int SPELLABILITY_EMPTY_BODY                 = 311;
int SPELLABILITY_DETECT_EVIL                = 312;
int SPELLABILITY_LAY_ON_HANDS               = 313;
int SPELLABILITY_AURA_OF_COURAGE            = 314;
int SPELLABILITY_SMITE_EVIL                 = 315;
int SPELLABILITY_REMOVE_DISEASE             = 316;
int SPELLABILITY_SUMMON_ANIMAL_COMPANION    = 317;
int SPELLABILITY_SUMMON_FAMILIAR            = 318;
int SPELLABILITY_ELEMENTAL_SHAPE            = 319;
int SPELLABILITY_WILD_SHAPE                 = 320;
//int SPELL_PROTECTION_FROM_ALIGNMENT = 321;
//int SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT = 322;
//int SPELL_AURA_VERSUS_ALIGNMENT = 323;
int SPELL_SHADES_SUMMON_SHADOW              = 324;
//int SPELL_PROTECTION_FROM_ELEMENTS_COLD = 325;
//int SPELL_PROTECTION_FROM_ELEMENTS_FIRE = 326;
//int SPELL_PROTECTION_FROM_ELEMENTS_ACID = 327;
//int SPELL_PROTECTION_FROM_ELEMENTS_SONIC = 328;
//int SPELL_PROTECTION_FROM_ELEMENTS_ELECTRICITY = 329;
//int SPELL_ENDURE_ELEMENTS_COLD = 330;
//int SPELL_ENDURE_ELEMENTS_FIRE = 331;
//int SPELL_ENDURE_ELEMENTS_ACID = 332;
//int SPELL_ENDURE_ELEMENTS_SONIC = 333;
//int SPELL_ENDURE_ELEMENTS_ELECTRICITY = 334;
//int SPELL_RESIST_ELEMENTS_COLD = 335;
//int SPELL_RESIST_ELEMENTS_FIRE = 336;
//int SPELL_RESIST_ELEMENTS_ACID = 337;
//int SPELL_RESIST_ELEMENTS_SONIC = 338;
//int SPELL_RESIST_ELEMENTS_ELECTRICITY = 339;
int SPELL_SHADES_CONE_OF_COLD               = 340;
int SPELL_SHADES_FIREBALL                   = 341;
int SPELL_SHADES_STONESKIN                  = 342;
int SPELL_SHADES_WALL_OF_FIRE               = 343;
int SPELL_SHADOW_CONJURATION_SUMMON_SHADOW  = 344;
int SPELL_SHADOW_CONJURATION_DARKNESS       = 345;
int SPELL_SHADOW_CONJURATION_INIVSIBILITY   = 346;
int SPELL_SHADOW_CONJURATION_MAGE_ARMOR     = 347;
int SPELL_SHADOW_CONJURATION_MAGIC_MISSILE  = 348;
int SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW = 349;
int SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW = 350;
int SPELL_GREATER_SHADOW_CONJURATION_MIRROR_IMAGE = 351;
int SPELL_GREATER_SHADOW_CONJURATION_WEB    = 352;
int SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE = 353;
int SPELL_EAGLE_SPLEDOR                     = 354;
int SPELL_OWLS_WISDOM                       = 355;
int SPELL_FOXS_CUNNING                      = 356;
int SPELL_GREATER_EAGLE_SPLENDOR            = 357;
int SPELL_GREATER_OWLS_WISDOM               = 358;
int SPELL_GREATER_FOXS_CUNNING              = 359;
int SPELL_GREATER_BULLS_STRENGTH            = 360;
int SPELL_GREATER_CATS_GRACE                = 361;
int SPELL_GREATER_ENDURANCE                 = 362;
int SPELL_AWAKEN                            = 363;
int SPELL_CREEPING_DOOM                     = 364;
int SPELL_DARKVISION                        = 365;
int SPELL_DESTRUCTION                       = 366;
int SPELL_HORRID_WILTING                    = 367;
int SPELL_ICE_STORM                         = 368;
int SPELL_ENERGY_BUFFER                     = 369;
int SPELL_NEGATIVE_ENERGY_BURST             = 370;
int SPELL_NEGATIVE_ENERGY_RAY               = 371;
int SPELL_AURA_OF_VITALITY                  = 372;
int SPELL_WAR_CRY                           = 373;
int SPELL_REGENERATE                        = 374;
int SPELL_EVARDS_BLACK_TENTACLES            = 375;
int SPELL_LEGEND_LORE                       = 376;
int SPELL_FIND_TRAPS                        = 377;
int SPELLABILITY_SUMMON_MEPHIT              = 378;

int SPELLABILITY_SUMMON_CELESTIAL           = 379;
int SPELLABILITY_BATTLE_MASTERY             = 380;
int SPELLABILITY_DIVINE_STRENGTH            = 381;
int SPELLABILITY_DIVINE_PROTECTION          = 382;
int SPELLABILITY_NEGATIVE_PLANE_AVATAR      = 383;
int SPELLABILITY_DIVINE_TRICKERY            = 384;
int SPELLABILITY_ROGUES_CUNNING             = 385;
int SPELLABILITY_ACTIVATE_ITEM              = 386;
int SPELLABILITY_DRAGON_FEAR                = 412;

int SPELL_DIVINE_FAVOR                      = 414;
int SPELL_TRUE_STRIKE                       = 415;
int SPELL_FLARE                             = 416;
int SPELL_SHIELD                            = 417;
int SPELL_ENTROPIC_SHIELD                   = 418;
int SPELL_CONTINUAL_FLAME                   = 419;
int SPELL_ONE_WITH_THE_LAND                 = 420;
int SPELL_CAMOFLAGE                         = 421;
int SPELL_BLOOD_FRENZY                      = 422;
int SPELL_BOMBARDMENT                       = 423;
int SPELL_ACID_SPLASH                       = 424;
int SPELL_QUILLFIRE                         = 425;
int SPELL_EARTHQUAKE                        = 426;
int SPELL_SUNBURST                          = 427;
int SPELL_ACTIVATE_ITEM_SELF2               = 428;
int SPELL_AURAOFGLORY                       = 429;
int SPELL_BANISHMENT                        = 430;
int SPELL_INFLICT_MINOR_WOUNDS              = 431;
int SPELL_INFLICT_LIGHT_WOUNDS              = 432;
int SPELL_INFLICT_MODERATE_WOUNDS           = 433;
int SPELL_INFLICT_SERIOUS_WOUNDS            = 434;
int SPELL_INFLICT_CRITICAL_WOUNDS           = 435;
int SPELL_BALAGARNSIRONHORN                 = 436;
int SPELL_DROWN                             = 437;
int SPELL_OWLS_INSIGHT                      = 438;
int SPELL_ELECTRIC_JOLT                     = 439;
int SPELL_FIREBRAND                         = 440;
int SPELL_WOUNDING_WHISPERS                 = 441;
int SPELL_AMPLIFY                           = 442;
int SPELL_ETHEREALNESS                      = 443;
int SPELL_UNDEATHS_ETERNAL_FOE              = 444;
int SPELL_DIRGE                             = 445;
int SPELL_INFERNO                           = 446;
int SPELL_ISAACS_LESSER_MISSILE_STORM       = 447;
int SPELL_ISAACS_GREATER_MISSILE_STORM      = 448;
int SPELL_BANE                              = 449;
int SPELL_SHIELD_OF_FAITH                   = 450;
int SPELL_PLANAR_ALLY                       = 451;
int SPELL_MAGIC_FANG                        = 452;
int SPELL_GREATER_MAGIC_FANG                = 453;
int SPELL_SPIKE_GROWTH                      = 454;
int SPELL_MASS_CAMOFLAGE                    = 455;
int SPELL_EXPEDITIOUS_RETREAT               = 456;
int SPELL_TASHAS_HIDEOUS_LAUGHTER           = 457;
int SPELL_DISPLACEMENT                      = 458;
int SPELL_BIGBYS_INTERPOSING_HAND           = 459;
int SPELL_BIGBYS_FORCEFUL_HAND              = 460;
int SPELL_BIGBYS_GRASPING_HAND              = 461;
int SPELL_BIGBYS_CLENCHED_FIST              = 462;
int SPELL_BIGBYS_CRUSHING_HAND              = 463;
int SPELL_GRENADE_FIRE                      = 464;
int SPELL_GRENADE_TANGLE                    = 465;
int SPELL_GRENADE_HOLY                      = 466;
int SPELL_GRENADE_CHOKING                   = 467;
int SPELL_GRENADE_THUNDERSTONE              = 468;
int SPELL_GRENADE_ACID                      = 469;
int SPELL_GRENADE_CHICKEN                   = 470;
int SPELL_GRENADE_CALTROPS                  = 471;
int SPELL_ACTIVATE_ITEM_PORTAL              = 472;
int SPELL_DIVINE_MIGHT                      = 473;
int SPELL_DIVINE_SHIELD                     = 474;
int SPELL_SHADOW_DAZE                       = 475;
int SPELL_SUMMON_SHADOW                     = 476;
int SPELL_SHADOW_EVADE                      = 477;
int SPELL_TYMORAS_SMILE                     = 478;
int SPELL_CRAFT_HARPER_ITEM                 = 479;
int SPELL_FLESH_TO_STONE                    = 485;
int SPELL_STONE_TO_FLESH                    = 486;
int SPELL_TRAP_ARROW                        = 487;
int SPELL_TRAP_BOLT                     = 488;
int SPELL_TRAP_DART                     = 493;
int SPELL_TRAP_SHURIKEN                     = 494;

int SPELLABILITY_BREATH_PETRIFY         = 495;
int SPELLABILITY_TOUCH_PETRIFY          = 496;
int SPELLABILITY_GAZE_PETRIFY           = 497;
int SPELLABILITY_MANTICORE_SPIKES       = 498;


int SPELL_ROD_OF_WONDER                 = 499;
int SPELL_DECK_OF_MANY_THINGS           = 500;
int SPELL_ELEMENTAL_SUMMONING_ITEM      = 502;
int SPELL_DECK_AVATAR                   = 503;
int SPELL_DECK_GEMSPRAY                 = 504;
int SPELL_DECK_BUTTERFLYSPRAY           = 505;

int SPELL_HEALINGKIT                    = 506;
int SPELL_POWERSTONE                    = 507;
int SPELL_SPELLSTAFF                    = 508;
int SPELL_CHARGER                       = 500;
int SPELL_DECHARGER                     = 510;

int SPELL_KOBOLD_JUMP                   = 511;
int SPELL_CRUMBLE                       = 512;
int SPELL_INFESTATION_OF_MAGGOTS        = 513;
int SPELL_HEALING_STING                 = 514;
int SPELL_GREAT_THUNDERCLAP             = 515;
int SPELL_BALL_LIGHTNING                = 516;
int SPELL_BATTLETIDE                    = 517;
int SPELL_COMBUST                       = 518;
int SPELL_DEATH_ARMOR                   = 519;
int SPELL_GEDLEES_ELECTRIC_LOOP         = 520;
int SPELL_HORIZIKAULS_BOOM              = 521;
int SPELL_IRONGUTS                      = 522;
int SPELL_MESTILS_ACID_BREATH           = 523;
int SPELL_MESTILS_ACID_SHEATH           = 524;
int SPELL_MONSTROUS_REGENERATION        = 525;
int SPELL_SCINTILLATING_SPHERE          = 526;
int SPELL_STONE_BONES                   = 527;
int SPELL_UNDEATH_TO_DEATH              = 528;
int SPELL_VINE_MINE                     = 529;
int SPELL_VINE_MINE_ENTANGLE            = 530;
int SPELL_VINE_MINE_HAMPER_MOVEMENT     = 531;
int SPELL_VINE_MINE_CAMOUFLAGE          = 532;
int SPELL_BLACK_BLADE_OF_DISASTER       = 533;
int SPELL_SHELGARNS_PERSISTENT_BLADE    = 534;
int SPELL_BLADE_THIRST                  = 535;
int SPELL_DEAFENING_CLANG               = 536;
int SPELL_CLOUD_OF_BEWILDERMENT         = 569;


int SPELL_KEEN_EDGE                     = 539;
int SPELL_BLACKSTAFF                    = 541;
int SPELL_FLAME_WEAPON                  = 542;
int SPELL_ICE_DAGGER                    = 543;
int SPELL_MAGIC_WEAPON                  = 544;
int SPELL_GREATER_MAGIC_WEAPON          = 545;


int SPELL_STONEHOLD                     = 547;
int SPELL_DARKFIRE                      = 548;
int SPELL_GLYPH_OF_WARDING              = 549;

int SPELLABILITY_MINDBLAST              = 551;
int SPELLABILITY_CHARMMONSTER           = 552;

int SPELL_IOUN_STONE_DUSTY_ROSE         = 554;
int SPELL_IOUN_STONE_PALE_BLUE          = 555;
int SPELL_IOUN_STONE_SCARLET_BLUE       = 556;
int SPELL_IOUN_STONE_BLUE               = 557;
int SPELL_IOUN_STONE_DEEP_RED           = 558;
int SPELL_IOUN_STONE_PINK               = 559;
int SPELL_IOUN_STONE_PINK_GREEN         = 560;

int SPELLABILITY_WHIRLWIND              = 561;
int SPELLABILITY_COMMAND_THE_HORDE      = 571;

int SPELLABILITY_AA_IMBUE_ARROW            = 600;
int SPELLABILITY_AA_SEEKER_ARROW_1         = 601;
int SPELLABILITY_AA_SEEKER_ARROW_2         = 602;
int SPELLABILITY_AA_HAIL_OF_ARROWS         = 603;
int SPELLABILITY_AA_ARROW_OF_DEATH         = 604;

int SPELLABILITY_AS_GHOSTLY_VISAGE         = 605;
int SPELLABILITY_AS_DARKNESS               = 606;
int SPELLABILITY_AS_INVISIBILITY           = 607;
int SPELLABILITY_AS_IMPROVED_INVISIBLITY   = 608;

int SPELLABILITY_BG_CREATEDEAD             = 609;
int SPELLABILITY_BG_FIENDISH_SERVANT       = 610;
int SPELLABILITY_BG_INFLICT_SERIOUS_WOUNDS = 611;
int SPELLABILITY_BG_INFLICT_CRITICAL_WOUNDS = 612;
int SPELLABILITY_BG_CONTAGION              = 613;
int SPELLABILITY_BG_BULLS_STRENGTH         = 614;

int SPELL_FLYING_DEBRIS                    = 620;

int SPELLABILITY_DC_DIVINE_WRATH           = 622;

int SPELLABILITY_PM_ANIMATE_DEAD           = 623;
int SPELLABILITY_PM_SUMMON_UNDEAD          = 624;
int SPELLABILITY_PM_UNDEAD_GRAFT_1         = 625;
int SPELLABILITY_PM_UNDEAD_GRAFT_2         = 626;
int SPELLABILITY_PM_SUMMON_GREATER_UNDEAD  = 627;
int SPELLABILITY_PM_DEATHLESS_MASTER_TOUCH = 628;

int SPELL_EPIC_HELLBALL                    = 636;
int SPELL_EPIC_MUMMY_DUST                  = 637;
int SPELL_EPIC_DRAGON_KNIGHT               = 638;
int SPELL_EPIC_MAGE_ARMOR                  = 639;
int SPELL_EPIC_RUIN                        = 640;

int SPELLABILITY_DW_DEFENSIVE_STANCE       = 641;

int SPELLABILITY_EPIC_MIGHTY_RAGE          = 642;
int SPELLABILITY_EPIC_CURSE_SONG           = 644;
int SPELLABILITY_EPIC_IMPROVED_WHIRLWIND   = 645;


int SPELLABILITY_EPIC_SHAPE_DRAGONKIN      = 646;
int SPELLABILITY_EPIC_SHAPE_DRAGON         = 647;

int SPELL_CRAFT_DYE_CLOTHCOLOR_1           = 648;
int SPELL_CRAFT_DYE_CLOTHCOLOR_2           = 649;
int SPELL_CRAFT_DYE_LEATHERCOLOR_1         = 650;
int SPELL_CRAFT_DYE_LEATHERCOLOR_2         = 651;
int SPELL_CRAFT_DYE_METALCOLOR_1           = 652;
int SPELL_CRAFT_DYE_METALCOLOR_2           = 653;

int SPELL_CRAFT_ADD_ITEM_PROPERTY          = 654;
int SPELL_CRAFT_POISON_WEAPON_OR_AMMO      = 655;

int SPELL_CRAFT_CRAFT_WEAPON_SKILL         = 656;
int SPELL_CRAFT_CRAFT_ARMOR_SKILL          = 657;
int SPELLABILITY_DRAGON_BREATH_NEGATIVE    = 698;
int SPELLABILITY_SEAHAG_EVILEYE            = 803;
int SPELLABILITY_AURA_HORRIFICAPPEARANCE   = 804;
int SPELLABILITY_TROGLODYTE_STENCH         = 805;

int SPELL_HORSE_MENU                       = 812;
int SPELL_HORSE_MOUNT                      = 813;
int SPELL_HORSE_DISMOUNT                   = 814;
int SPELL_HORSE_PARTY_MOUNT                = 815;
int SPELL_HORSE_PARTY_DISMOUNT             = 816;
int SPELL_HORSE_ASSIGN_MOUNT               = 817;
int SPELL_PALADIN_SUMMON_MOUNT             = 818;

// these constants must match those in poison.2da
int POISON_NIGHTSHADE                    = 0;
int POISON_SMALL_CENTIPEDE_POISON        = 1;
int POISON_BLADE_BANE                    = 2;
int POISON_GREENBLOOD_OIL                = 3;
int POISON_BLOODROOT                     = 4;
int POISON_PURPLE_WORM_POISON            = 5;
int POISON_LARGE_SCORPION_VENOM          = 6;
int POISON_WYVERN_POISON                 = 7;
int POISON_BLUE_WHINNIS                  = 8;
int POISON_GIANT_WASP_POISON             = 9;
int POISON_SHADOW_ESSENCE                = 10;
int POISON_BLACK_ADDER_VENOM             = 11;
int POISON_DEATHBLADE                    = 12;
int POISON_MALYSS_ROOT_PASTE             = 13;
int POISON_NITHARIT                      = 14;
int POISON_DRAGON_BILE                   = 15;
int POISON_SASSONE_LEAF_RESIDUE          = 16;
int POISON_TERINAV_ROOT                  = 17;
int POISON_CARRION_CRAWLER_BRAIN_JUICE   = 18;
int POISON_BLACK_LOTUS_EXTRACT           = 19;
int POISON_OIL_OF_TAGGIT                 = 20;
int POISON_ID_MOSS                       = 21;
int POISON_STRIPED_TOADSTOOL             = 22;
int POISON_ARSENIC                       = 23;
int POISON_LICH_DUST                     = 24;
int POISON_DARK_REAVER_POWDER            = 25;
int POISON_UNGOL_DUST                    = 26;
int POISON_BURNT_OTHUR_FUMES             = 27;
int POISON_CHAOS_MIST                    = 28;
int POISON_BEBILITH_VENOM                = 29;
int POISON_QUASIT_VENOM                  = 30;
int POISON_PIT_FIEND_ICHOR               = 31;
int POISON_ETTERCAP_VENOM                = 32;
int POISON_ARANEA_VENOM                  = 33;
int POISON_TINY_SPIDER_VENOM             = 34;
int POISON_SMALL_SPIDER_VENOM            = 35;
int POISON_MEDIUM_SPIDER_VENOM           = 36;
int POISON_LARGE_SPIDER_VENOM            = 37;
int POISON_HUGE_SPIDER_VENOM             = 38;
int POISON_GARGANTUAN_SPIDER_VENOM       = 39;
int POISON_COLOSSAL_SPIDER_VENOM         = 40;
int POISON_PHASE_SPIDER_VENOM            = 41;
int POISON_WRAITH_SPIDER_VENOM           = 42;
int POISON_IRON_GOLEM                    = 43;

// these constants match those in disease.2da
int DISEASE_BLINDING_SICKNESS            = 0;
int DISEASE_CACKLE_FEVER                 = 1;
int DISEASE_DEVIL_CHILLS                 = 2;
int DISEASE_DEMON_FEVER                  = 3;
int DISEASE_FILTH_FEVER                  = 4;
int DISEASE_MINDFIRE                     = 5;
int DISEASE_MUMMY_ROT                    = 6;
int DISEASE_RED_ACHE                     = 7;
int DISEASE_SHAKES                       = 8;
int DISEASE_SLIMY_DOOM                   = 9;
int DISEASE_RED_SLAAD_EGGS               = 10;
int DISEASE_GHOUL_ROT                    = 11;
int DISEASE_ZOMBIE_CREEP                 = 12;
int DISEASE_DREAD_BLISTERS               = 13;
int DISEASE_BURROW_MAGGOTS               = 14;
int DISEASE_SOLDIER_SHAKES               = 15;
int DISEASE_VERMIN_MADNESS               = 16;

// the thing after CREATURE_TYPE_ should refer to the
// actual "subtype" in the lists given above.
int CREATURE_TYPE_RACIAL_TYPE     = 0;
int CREATURE_TYPE_PLAYER_CHAR     = 1;
int CREATURE_TYPE_CLASS           = 2;
int CREATURE_TYPE_REPUTATION      = 3;
int CREATURE_TYPE_IS_ALIVE        = 4;
int CREATURE_TYPE_HAS_SPELL_EFFECT = 5;
int CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT = 6;
int CREATURE_TYPE_PERCEPTION                = 7;
//int CREATURE_TYPE_ALIGNMENT       = 2;

int REPUTATION_TYPE_FRIEND        = 0;
int REPUTATION_TYPE_ENEMY         = 1;
int REPUTATION_TYPE_NEUTRAL       = 2;

int PERCEPTION_SEEN_AND_HEARD           = 0;
int PERCEPTION_NOT_SEEN_AND_NOT_HEARD   = 1;
int PERCEPTION_HEARD_AND_NOT_SEEN       = 2;
int PERCEPTION_SEEN_AND_NOT_HEARD       = 3;
int PERCEPTION_NOT_HEARD                = 4;
int PERCEPTION_HEARD                    = 5;
int PERCEPTION_NOT_SEEN                 = 6;
int PERCEPTION_SEEN                     = 7;

int PLAYER_CHAR_NOT_PC            = FALSE;
int PLAYER_CHAR_IS_PC             = TRUE;

int CLASS_TYPE_BARBARIAN = 0;
int CLASS_TYPE_BARD      = 1;
int CLASS_TYPE_CLERIC    = 2;
int CLASS_TYPE_DRUID     = 3;
int CLASS_TYPE_FIGHTER   = 4;
int CLASS_TYPE_MONK      = 5;
int CLASS_TYPE_PALADIN   = 6;
int CLASS_TYPE_RANGER    = 7;
int CLASS_TYPE_ROGUE     = 8;
int CLASS_TYPE_SORCERER  = 9;
int CLASS_TYPE_WIZARD    = 10;
int CLASS_TYPE_ABERRATION = 11;
int CLASS_TYPE_ANIMAL    = 12;
int CLASS_TYPE_CONSTRUCT = 13;
int CLASS_TYPE_HUMANOID  = 14;
int CLASS_TYPE_MONSTROUS = 15;
int CLASS_TYPE_ELEMENTAL = 16;
int CLASS_TYPE_FEY       = 17;
int CLASS_TYPE_DRAGON    = 18;
int CLASS_TYPE_UNDEAD    = 19;
int CLASS_TYPE_COMMONER  = 20;
int CLASS_TYPE_BEAST     = 21;
int CLASS_TYPE_GIANT     = 22;
int CLASS_TYPE_MAGICAL_BEAST = 23;
int CLASS_TYPE_OUTSIDER  = 24;
int CLASS_TYPE_SHAPECHANGER = 25;
int CLASS_TYPE_VERMIN    = 26;
int CLASS_TYPE_SHADOWDANCER = 27;
int CLASS_TYPE_HARPER = 28;
int CLASS_TYPE_ARCANE_ARCHER = 29;
int CLASS_TYPE_ASSASSIN = 30;
int CLASS_TYPE_BLACKGUARD = 31;
int CLASS_TYPE_DIVINECHAMPION   = 32;
int CLASS_TYPE_DIVINE_CHAMPION   = 32;
int CLASS_TYPE_WEAPON_MASTER           = 33;
int CLASS_TYPE_PALEMASTER       = 34;
int CLASS_TYPE_PALE_MASTER       = 34;
int CLASS_TYPE_SHIFTER          = 35;
int CLASS_TYPE_DWARVENDEFENDER  = 36;
int CLASS_TYPE_DWARVEN_DEFENDER  = 36;
int CLASS_TYPE_DRAGONDISCIPLE   = 37;
int CLASS_TYPE_DRAGON_DISCIPLE   = 37;
int CLASS_TYPE_OOZE             = 38;
int CLASS_TYPE_EYE_OF_GRUUMSH   = 39;
int CLASS_TYPE_SHOU_DISCIPLE    = 40;
int CLASS_TYPE_PURPLE_DRAGON_KNIGHT = 41;

int CLASS_TYPE_INVALID   = 255;

// These are for the LevelUpHenchman command.
int PACKAGE_BARBARIAN                    = 0;
int PACKAGE_BARD                         = 1;
int PACKAGE_CLERIC                       = 2;
int PACKAGE_DRUID                        = 3;
int PACKAGE_FIGHTER                      = 4;
int PACKAGE_MONK                         = 5;
int PACKAGE_PALADIN                      = 6;
int PACKAGE_RANGER                       = 7;
int PACKAGE_ROGUE                        = 8;
int PACKAGE_SORCERER                     = 9;
int PACKAGE_WIZARDGENERALIST             = 10;
int PACKAGE_DRUID_INTERLOPER             = 11;
int PACKAGE_DRUID_GRAY                   = 12;
int PACKAGE_DRUID_DEATH                  = 13;
int PACKAGE_DRUID_HAWKMASTER             = 14;
int PACKAGE_BARBARIAN_BRUTE              = 15;
int PACKAGE_BARBARIAN_SLAYER             = 16;
int PACKAGE_BARBARIAN_SAVAGE             = 17;
int PACKAGE_BARBARIAN_ORCBLOOD           = 18;
int PACKAGE_CLERIC_SHAMAN                = 19;
int PACKAGE_CLERIC_DEADWALKER            = 20;
int PACKAGE_CLERIC_ELEMENTALIST          = 21;
int PACKAGE_CLERIC_BATTLE_PRIEST         = 22;
int PACKAGE_FIGHTER_FINESSE              = 23;
int PACKAGE_FIGHTER_PIRATE               = 24;
int PACKAGE_FIGHTER_GLADIATOR            = 25;
int PACKAGE_FIGHTER_COMMANDER            = 26;
int PACKAGE_WIZARD_ABJURATION            = 27;
int PACKAGE_WIZARD_CONJURATION           = 28;
int PACKAGE_WIZARD_DIVINATION            = 29;
int PACKAGE_WIZARD_ENCHANTMENT           = 30;
int PACKAGE_WIZARD_EVOCATION             = 31;
int PACKAGE_WIZARD_ILLUSION              = 32;
int PACKAGE_WIZARD_NECROMANCY            = 33;
int PACKAGE_WIZARD_TRANSMUTATION         = 34;
int PACKAGE_SORCERER_ABJURATION          = 35;
int PACKAGE_SORCERER_CONJURATION         = 36;
int PACKAGE_SORCERER_DIVINATION          = 37;
int PACKAGE_SORCERER_ENCHANTMENT         = 38;
int PACKAGE_SORCERER_EVOCATION           = 39;
int PACKAGE_SORCERER_ILLUSION            = 40;
int PACKAGE_SORCERER_NECROMANCY          = 41;
int PACKAGE_SORCERER_TRANSMUTATION       = 42;
int PACKAGE_BARD_BLADE                   = 43;
int PACKAGE_BARD_GALLANT                 = 44;
int PACKAGE_BARD_JESTER                  = 45;
int PACKAGE_BARD_LOREMASTER              = 46;
int PACKAGE_MONK_SPIRIT                  = 47;
int PACKAGE_MONK_GIFTED                  = 48;
int PACKAGE_MONK_DEVOUT                  = 49;
int PACKAGE_MONK_PEASANT                 = 50;
int PACKAGE_PALADIN_ERRANT               = 51;
int PACKAGE_PALADIN_UNDEAD               = 52;
int PACKAGE_PALADIN_INQUISITOR           = 53;
int PACKAGE_PALADIN_CHAMPION             = 54;
int PACKAGE_RANGER_MARKSMAN              = 55;
int PACKAGE_RANGER_WARDEN                = 56;
int PACKAGE_RANGER_STALKER               = 57;
int PACKAGE_RANGER_GIANTKILLER           = 58;
int PACKAGE_ROGUE_GYPSY                  = 59;
int PACKAGE_ROGUE_BANDIT                 = 60;
int PACKAGE_ROGUE_SCOUT                  = 61;
int PACKAGE_ROGUE_SWASHBUCKLER           = 62;
int PACKAGE_SHADOWDANCER                 = 63;
int PACKAGE_HARPER                       = 64;
int PACKAGE_ARCANE_ARCHER                = 65;
int PACKAGE_ASSASSIN                     = 66;
int PACKAGE_BLACKGUARD                   = 67;
int PACKAGE_NPC_SORCERER                 = 70;
int PACKAGE_NPC_ROGUE                    = 71;
int PACKAGE_NPC_BARD                     = 72;
int PACKAGE_ABERRATION                   = 73;
int PACKAGE_ANIMAL                       = 74;
int PACKAGE_CONSTRUCT                    = 75;
int PACKAGE_HUMANOID                     = 76;
int PACKAGE_MONSTROUS                    = 77;
int PACKAGE_ELEMENTAL                    = 78;
int PACKAGE_FEY                          = 79;
int PACKAGE_DRAGON                       = 80;
int PACKAGE_UNDEAD                       = 81;
int PACKAGE_COMMONER                     = 82;
int PACKAGE_BEAST                        = 83;
int PACKAGE_GIANT                        = 84;
int PACKAGE_MAGICBEAST                   = 85;
int PACKAGE_OUTSIDER                     = 86;
int PACKAGE_SHAPECHANGER                 = 87;
int PACKAGE_VERMIN                       = 88;
int PACKAGE_DWARVEN_DEFENDER             = 89;
int PACKAGE_BARBARIAN_BLACKGUARD         = 90;
int PACKAGE_BARD_HARPER                  = 91;
int PACKAGE_CLERIC_DIVINE                = 92;
int PACKAGE_DRUID_SHIFTER                = 93;
int PACKAGE_FIGHTER_WEAPONMASTER         = 94;
int PACKAGE_MONK_ASSASSIN                = 95;
int PACKAGE_PALADIN_DIVINE               = 96;
int PACKAGE_RANGER_ARCANEARCHER          = 97;
int PACKAGE_ROGUE_SHADOWDANCER           = 98;
int PACKAGE_SORCERER_DRAGONDISCIPLE      = 99;
int PACKAGE_WIZARD_PALEMASTER            = 100;
int PACKAGE_NPC_WIZASSASSIN              = 101;
int PACKAGE_NPC_FT_WEAPONMASTER          = 102;
int PACKAGE_NPC_RG_SHADOWDANCER          = 103;
int PACKAGE_NPC_CLERIC_LINU              = 104;
int PACKAGE_NPC_BARBARIAN_DAELAN         = 105;
int PACKAGE_NPC_BARD_FIGHTER             = 106;
int PACKAGE_NPC_PALADIN_FALLING          = 107;
int PACKAGE_SHIFTER                      = 108;
int PACKAGE_DIVINE_CHAMPION              = 109;
int PACKAGE_PALE_MASTER                  = 110;
int PACKAGE_DRAGON_DISCIPLE              = 111;
int PACKAGE_WEAPONMASTER                 = 112;
int PACKAGE_NPC_FT_WEAPONMASTER_VALEN_2  = 113;
int PACKAGE_NPC_BARD_FIGHTER_SHARWYN2    = 114;
int PACKAGE_NPC_WIZASSASSIN_NATHYRRA     = 115;
int PACKAGE_NPC_RG_TOMI_2                = 116;
int PACKAGE_NPC_BARD_DEEKIN_2            = 117;
int PACKAGE_BARBARIAN_BLACKGUARD_2NDCLASS = 118;
int PACKAGE_BARD_HARPER_2NDCLASS         = 119;
int PACKAGE_CLERIC_DIVINE_2NDCLASS       = 120;
int PACKAGE_DRUID_SHIFTER_2NDCLASS       = 121;
int PACKAGE_FIGHTER_WEAPONMASTER_2NDCLASS = 122;
int PACKAGE_MONK_ASSASSIN_2NDCLASS       = 123;
int PACKAGE_PALADIN_DIVINE_2NDCLASS      = 124;
int PACKAGE_RANGER_ARCANEARCHER_2NDCLASS = 125;
int PACKAGE_ROGUE_SHADOWDANCER_2NDCLASS  = 126;
int PACKAGE_SORCERER_DRAGONDISCIPLE_2NDCLASS = 127;
int PACKAGE_WIZARD_PALEMASTER_2NDCLASS   = 128;
int PACKAGE_NPC_ARIBETH_PALADIN          = 129;
int PACKAGE_NPC_ARIBETH_BLACKGUARD       = 130;

int PACKAGE_INVALID                      = 255;

// These are for GetFirstInPersistentObject() and GetNextInPersistentObject()
int PERSISTENT_ZONE_ACTIVE = 0;
int PERSISTENT_ZONE_FOLLOW = 1;

int STANDARD_FACTION_HOSTILE  = 0;
int STANDARD_FACTION_COMMONER = 1;
int STANDARD_FACTION_MERCHANT = 2;
int STANDARD_FACTION_DEFENDER = 3;

// Skill defines
int SKILL_ANIMAL_EMPATHY   = 0;
int SKILL_CONCENTRATION    = 1;
int SKILL_DISABLE_TRAP     = 2;
int SKILL_DISCIPLINE       = 3;
int SKILL_HEAL             = 4;
int SKILL_HIDE             = 5;
int SKILL_LISTEN           = 6;
int SKILL_LORE             = 7;
int SKILL_MOVE_SILENTLY    = 8;
int SKILL_OPEN_LOCK        = 9;
int SKILL_PARRY            = 10;
int SKILL_PERFORM          = 11;
int SKILL_PERSUADE         = 12;
int SKILL_PICK_POCKET      = 13;
int SKILL_SEARCH           = 14;
int SKILL_SET_TRAP         = 15;
int SKILL_SPELLCRAFT       = 16;
int SKILL_SPOT             = 17;
int SKILL_TAUNT            = 18;
int SKILL_USE_MAGIC_DEVICE = 19;
int SKILL_APPRAISE         = 20;
int SKILL_TUMBLE           = 21;
int SKILL_CRAFT_TRAP       = 22;
int SKILL_BLUFF            = 23;
int SKILL_INTIMIDATE       = 24;
int SKILL_CRAFT_ARMOR      = 25;
int SKILL_CRAFT_WEAPON     = 26;
int SKILL_RIDE             = 27;

int SKILL_ALL_SKILLS       = 255;

int SUBSKILL_FLAGTRAP      = 100;
int SUBSKILL_RECOVERTRAP   = 101;
int SUBSKILL_EXAMINETRAP   = 102;

int FEAT_ALERTNESS                      = 0;
int FEAT_AMBIDEXTERITY                  = 1;
int FEAT_ARMOR_PROFICIENCY_HEAVY        = 2;
int FEAT_ARMOR_PROFICIENCY_LIGHT        = 3;
int FEAT_ARMOR_PROFICIENCY_MEDIUM       = 4;
int FEAT_CALLED_SHOT                    = 5;
int FEAT_CLEAVE                         = 6;
int FEAT_COMBAT_CASTING                 = 7;
int FEAT_DEFLECT_ARROWS                 = 8;
int FEAT_DISARM                         = 9;
int FEAT_DODGE                          = 10;
int FEAT_EMPOWER_SPELL                  = 11;
int FEAT_EXTEND_SPELL                   = 12;
int FEAT_EXTRA_TURNING                  = 13;
int FEAT_GREAT_FORTITUDE                = 14;
int FEAT_IMPROVED_CRITICAL_CLUB         = 15;
int FEAT_IMPROVED_DISARM                = 16;
int FEAT_IMPROVED_KNOCKDOWN             = 17;
int FEAT_IMPROVED_PARRY                 = 18;
int FEAT_IMPROVED_POWER_ATTACK          = 19;
int FEAT_IMPROVED_TWO_WEAPON_FIGHTING   = 20;
int FEAT_IMPROVED_UNARMED_STRIKE        = 21;
int FEAT_IRON_WILL                      = 22;
int FEAT_KNOCKDOWN                      = 23;
int FEAT_LIGHTNING_REFLEXES             = 24;
int FEAT_MAXIMIZE_SPELL                 = 25;
int FEAT_MOBILITY                       = 26;
int FEAT_POINT_BLANK_SHOT               = 27;
int FEAT_POWER_ATTACK                   = 28;
int FEAT_QUICKEN_SPELL                  = 29;
int FEAT_RAPID_SHOT                     = 30;
int FEAT_SAP                            = 31;
int FEAT_SHIELD_PROFICIENCY             = 32;
int FEAT_SILENCE_SPELL                  = 33;
int FEAT_SKILL_FOCUS_ANIMAL_EMPATHY     = 34;
int FEAT_SPELL_FOCUS_ABJURATION         = 35;
int FEAT_SPELL_PENETRATION              = 36;
int FEAT_STILL_SPELL                    = 37;
int FEAT_STUNNING_FIST                  = 39;
int FEAT_TOUGHNESS                      = 40;
int FEAT_TWO_WEAPON_FIGHTING            = 41;
int FEAT_WEAPON_FINESSE                 = 42;
int FEAT_WEAPON_FOCUS_CLUB              = 43;
int FEAT_WEAPON_PROFICIENCY_EXOTIC      = 44;
int FEAT_WEAPON_PROFICIENCY_MARTIAL     = 45;
int FEAT_WEAPON_PROFICIENCY_SIMPLE      = 46;
int FEAT_WEAPON_SPECIALIZATION_CLUB     = 47;
int FEAT_WEAPON_PROFICIENCY_DRUID       = 48;
int FEAT_WEAPON_PROFICIENCY_MONK        = 49;
int FEAT_WEAPON_PROFICIENCY_ROGUE       = 50;
int FEAT_WEAPON_PROFICIENCY_WIZARD      = 51;
int FEAT_IMPROVED_CRITICAL_DAGGER       = 52;
int FEAT_IMPROVED_CRITICAL_DART         = 53;
int FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW = 54;
int FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW = 55;
int FEAT_IMPROVED_CRITICAL_LIGHT_MACE   = 56;
int FEAT_IMPROVED_CRITICAL_MORNING_STAR = 57;
int FEAT_IMPROVED_CRITICAL_STAFF        = 58;
int FEAT_IMPROVED_CRITICAL_SPEAR        = 59;
int FEAT_IMPROVED_CRITICAL_SICKLE       = 60;
int FEAT_IMPROVED_CRITICAL_SLING        = 61;
int FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE = 62;
int FEAT_IMPROVED_CRITICAL_LONGBOW      = 63;
int FEAT_IMPROVED_CRITICAL_SHORTBOW     = 64;
int FEAT_IMPROVED_CRITICAL_SHORT_SWORD  = 65;
int FEAT_IMPROVED_CRITICAL_RAPIER       = 66;
int FEAT_IMPROVED_CRITICAL_SCIMITAR     = 67;
int FEAT_IMPROVED_CRITICAL_LONG_SWORD   = 68;
int FEAT_IMPROVED_CRITICAL_GREAT_SWORD  = 69;
int FEAT_IMPROVED_CRITICAL_HAND_AXE     = 70;
int FEAT_IMPROVED_CRITICAL_THROWING_AXE = 71;
int FEAT_IMPROVED_CRITICAL_BATTLE_AXE   = 72;
int FEAT_IMPROVED_CRITICAL_GREAT_AXE    = 73;
int FEAT_IMPROVED_CRITICAL_HALBERD      = 74;
int FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER = 75;
int FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL  = 76;
int FEAT_IMPROVED_CRITICAL_WAR_HAMMER   = 77;
int FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL  = 78;
int FEAT_IMPROVED_CRITICAL_KAMA         = 79;
int FEAT_IMPROVED_CRITICAL_KUKRI        = 80;
//int FEAT_IMPROVED_CRITICAL_NUNCHAKU = 81;
int FEAT_IMPROVED_CRITICAL_SHURIKEN     = 82;
int FEAT_IMPROVED_CRITICAL_SCYTHE       = 83;
int FEAT_IMPROVED_CRITICAL_KATANA       = 84;
int FEAT_IMPROVED_CRITICAL_BASTARD_SWORD = 85;
int FEAT_IMPROVED_CRITICAL_DIRE_MACE    = 87;
int FEAT_IMPROVED_CRITICAL_DOUBLE_AXE   = 88;
int FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD = 89;
int FEAT_WEAPON_FOCUS_DAGGER            = 90;
int FEAT_WEAPON_FOCUS_DART              = 91;
int FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW    = 92;
int FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW    = 93;
int FEAT_WEAPON_FOCUS_LIGHT_MACE        = 94;
int FEAT_WEAPON_FOCUS_MORNING_STAR      = 95;
int FEAT_WEAPON_FOCUS_STAFF             = 96;
int FEAT_WEAPON_FOCUS_SPEAR             = 97;
int FEAT_WEAPON_FOCUS_SICKLE            = 98;
int FEAT_WEAPON_FOCUS_SLING             = 99;
int FEAT_WEAPON_FOCUS_UNARMED_STRIKE    = 100;
int FEAT_WEAPON_FOCUS_LONGBOW           = 101;
int FEAT_WEAPON_FOCUS_SHORTBOW          = 102;
int FEAT_WEAPON_FOCUS_SHORT_SWORD       = 103;
int FEAT_WEAPON_FOCUS_RAPIER            = 104;
int FEAT_WEAPON_FOCUS_SCIMITAR          = 105;
int FEAT_WEAPON_FOCUS_LONG_SWORD        = 106;
int FEAT_WEAPON_FOCUS_GREAT_SWORD       = 107;
int FEAT_WEAPON_FOCUS_HAND_AXE          = 108;
int FEAT_WEAPON_FOCUS_THROWING_AXE      = 109;
int FEAT_WEAPON_FOCUS_BATTLE_AXE        = 110;
int FEAT_WEAPON_FOCUS_GREAT_AXE         = 111;
int FEAT_WEAPON_FOCUS_HALBERD           = 112;
int FEAT_WEAPON_FOCUS_LIGHT_HAMMER      = 113;
int FEAT_WEAPON_FOCUS_LIGHT_FLAIL       = 114;
int FEAT_WEAPON_FOCUS_WAR_HAMMER        = 115;
int FEAT_WEAPON_FOCUS_HEAVY_FLAIL       = 116;
int FEAT_WEAPON_FOCUS_KAMA              = 117;
int FEAT_WEAPON_FOCUS_KUKRI             = 118;
//int FEAT_WEAPON_FOCUS_NUNCHAKU = 119;
int FEAT_WEAPON_FOCUS_SHURIKEN          = 120;
int FEAT_WEAPON_FOCUS_SCYTHE            = 121;
int FEAT_WEAPON_FOCUS_KATANA            = 122;
int FEAT_WEAPON_FOCUS_BASTARD_SWORD     = 123;
int FEAT_WEAPON_FOCUS_DIRE_MACE         = 125;
int FEAT_WEAPON_FOCUS_DOUBLE_AXE        = 126;
int FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD  = 127;
int FEAT_WEAPON_SPECIALIZATION_DAGGER   = 128;
int FEAT_WEAPON_SPECIALIZATION_DART     = 129;
int FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW = 130;
int FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW = 131;
int FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE = 132;
int FEAT_WEAPON_SPECIALIZATION_MORNING_STAR = 133;
int FEAT_WEAPON_SPECIALIZATION_STAFF    = 134;
int FEAT_WEAPON_SPECIALIZATION_SPEAR    = 135;
int FEAT_WEAPON_SPECIALIZATION_SICKLE   = 136;
int FEAT_WEAPON_SPECIALIZATION_SLING    = 137;
int FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE = 138;
int FEAT_WEAPON_SPECIALIZATION_LONGBOW  = 139;
int FEAT_WEAPON_SPECIALIZATION_SHORTBOW = 140;
int FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD = 141;
int FEAT_WEAPON_SPECIALIZATION_RAPIER   = 142;
int FEAT_WEAPON_SPECIALIZATION_SCIMITAR = 143;
int FEAT_WEAPON_SPECIALIZATION_LONG_SWORD = 144;
int FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD = 145;
int FEAT_WEAPON_SPECIALIZATION_HAND_AXE = 146;
int FEAT_WEAPON_SPECIALIZATION_THROWING_AXE = 147;
int FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE = 148;
int FEAT_WEAPON_SPECIALIZATION_GREAT_AXE = 149;
int FEAT_WEAPON_SPECIALIZATION_HALBERD  = 150;
int FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER = 151;
int FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL = 152;
int FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER = 153;
int FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL = 154;
int FEAT_WEAPON_SPECIALIZATION_KAMA     = 155;
int FEAT_WEAPON_SPECIALIZATION_KUKRI    = 156;
//int FEAT_WEAPON_SPECIALIZATION_NUNCHAKU = 157;
int FEAT_WEAPON_SPECIALIZATION_SHURIKEN = 158;
int FEAT_WEAPON_SPECIALIZATION_SCYTHE   = 159;
int FEAT_WEAPON_SPECIALIZATION_KATANA   = 160;
int FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD = 161;
int FEAT_WEAPON_SPECIALIZATION_DIRE_MACE = 163;
int FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE = 164;
int FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD = 165;
int FEAT_SPELL_FOCUS_CONJURATION        = 166;
int FEAT_SPELL_FOCUS_DIVINATION         = 167;
int FEAT_SPELL_FOCUS_ENCHANTMENT        = 168;
int FEAT_SPELL_FOCUS_EVOCATION          = 169;
int FEAT_SPELL_FOCUS_ILLUSION           = 170;
int FEAT_SPELL_FOCUS_NECROMANCY         = 171;
int FEAT_SPELL_FOCUS_TRANSMUTATION      = 172;
int FEAT_SKILL_FOCUS_CONCENTRATION      = 173;
int FEAT_SKILL_FOCUS_DISABLE_TRAP       = 174;
int FEAT_SKILL_FOCUS_DISCIPLINE         = 175;
int FEAT_SKILL_FOCUS_HEAL               = 177;
int FEAT_SKILL_FOCUS_HIDE               = 178;
int FEAT_SKILL_FOCUS_LISTEN             = 179;
int FEAT_SKILL_FOCUS_LORE               = 180;
int FEAT_SKILL_FOCUS_MOVE_SILENTLY      = 181;
int FEAT_SKILL_FOCUS_OPEN_LOCK          = 182;
int FEAT_SKILL_FOCUS_PARRY              = 183;
int FEAT_SKILL_FOCUS_PERFORM            = 184;
int FEAT_SKILL_FOCUS_PERSUADE           = 185;
int FEAT_SKILL_FOCUS_PICK_POCKET        = 186;
int FEAT_SKILL_FOCUS_SEARCH             = 187;
int FEAT_SKILL_FOCUS_SET_TRAP           = 188;
int FEAT_SKILL_FOCUS_SPELLCRAFT         = 189;
int FEAT_SKILL_FOCUS_SPOT               = 190;
int FEAT_SKILL_FOCUS_TAUNT              = 192;
int FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE   = 193;
int FEAT_BARBARIAN_ENDURANCE            = 194;
int FEAT_UNCANNY_DODGE_1                = 195;
int FEAT_DAMAGE_REDUCTION               = 196;
int FEAT_BARDIC_KNOWLEDGE               = 197;
int FEAT_NATURE_SENSE                   = 198;
int FEAT_ANIMAL_COMPANION               = 199;
int FEAT_WOODLAND_STRIDE                = 200;
int FEAT_TRACKLESS_STEP                 = 201;
int FEAT_RESIST_NATURES_LURE            = 202;
int FEAT_VENOM_IMMUNITY                 = 203;
int FEAT_FLURRY_OF_BLOWS                = 204;
int FEAT_EVASION                        = 206;
int FEAT_MONK_ENDURANCE                 = 207;
int FEAT_STILL_MIND                     = 208;
int FEAT_PURITY_OF_BODY                 = 209;
int FEAT_WHOLENESS_OF_BODY              = 211;
int FEAT_IMPROVED_EVASION               = 212;
int FEAT_KI_STRIKE                      = 213;
int FEAT_DIAMOND_BODY                   = 214;
int FEAT_DIAMOND_SOUL                   = 215;
int FEAT_PERFECT_SELF                   = 216;
int FEAT_DIVINE_GRACE                   = 217;
int FEAT_DIVINE_HEALTH                  = 219;
int FEAT_SNEAK_ATTACK                   = 221;
int FEAT_CRIPPLING_STRIKE               = 222;
int FEAT_DEFENSIVE_ROLL                 = 223;
int FEAT_OPPORTUNIST                    = 224;
int FEAT_SKILL_MASTERY                  = 225;
int FEAT_UNCANNY_REFLEX                 = 226;
int FEAT_STONECUNNING                   = 227;
int FEAT_DARKVISION                     = 228;
int FEAT_HARDINESS_VERSUS_POISONS       = 229;
int FEAT_HARDINESS_VERSUS_SPELLS        = 230;
int FEAT_BATTLE_TRAINING_VERSUS_ORCS    = 231;
int FEAT_BATTLE_TRAINING_VERSUS_GOBLINS = 232;
int FEAT_BATTLE_TRAINING_VERSUS_GIANTS  = 233;
int FEAT_SKILL_AFFINITY_LORE            = 234;
int FEAT_IMMUNITY_TO_SLEEP              = 235;
int FEAT_HARDINESS_VERSUS_ENCHANTMENTS  = 236;
int FEAT_SKILL_AFFINITY_LISTEN          = 237;
int FEAT_SKILL_AFFINITY_SEARCH          = 238;
int FEAT_SKILL_AFFINITY_SPOT            = 239;
int FEAT_KEEN_SENSE                     = 240;
int FEAT_HARDINESS_VERSUS_ILLUSIONS     = 241;
int FEAT_BATTLE_TRAINING_VERSUS_REPTILIANS = 242;
int FEAT_SKILL_AFFINITY_CONCENTRATION   = 243;
int FEAT_PARTIAL_SKILL_AFFINITY_LISTEN  = 244;
int FEAT_PARTIAL_SKILL_AFFINITY_SEARCH  = 245;
int FEAT_PARTIAL_SKILL_AFFINITY_SPOT    = 246;
int FEAT_SKILL_AFFINITY_MOVE_SILENTLY   = 247;
int FEAT_LUCKY                          = 248;
int FEAT_FEARLESS                       = 249;
int FEAT_GOOD_AIM                       = 250;
int FEAT_UNCANNY_DODGE_2                = 251;
int FEAT_UNCANNY_DODGE_3                = 252;
int FEAT_UNCANNY_DODGE_4                = 253;
int FEAT_UNCANNY_DODGE_5                = 254;
int FEAT_UNCANNY_DODGE_6                = 255;
int FEAT_WEAPON_PROFICIENCY_ELF         = 256;
int FEAT_BARD_SONGS                     = 257;
int FEAT_QUICK_TO_MASTER                = 258;
int FEAT_SLIPPERY_MIND                  = 259;
int FEAT_MONK_AC_BONUS                  = 260;
int FEAT_FAVORED_ENEMY_DWARF            = 261;
int FEAT_FAVORED_ENEMY_ELF              = 262;
int FEAT_FAVORED_ENEMY_GNOME            = 263;
int FEAT_FAVORED_ENEMY_HALFLING         = 264;
int FEAT_FAVORED_ENEMY_HALFELF          = 265;
int FEAT_FAVORED_ENEMY_HALFORC          = 266;
int FEAT_FAVORED_ENEMY_HUMAN            = 267;
int FEAT_FAVORED_ENEMY_ABERRATION       = 268;
int FEAT_FAVORED_ENEMY_ANIMAL           = 269;
int FEAT_FAVORED_ENEMY_BEAST            = 270;
int FEAT_FAVORED_ENEMY_CONSTRUCT        = 271;
int FEAT_FAVORED_ENEMY_DRAGON           = 272;
int FEAT_FAVORED_ENEMY_GOBLINOID        = 273;
int FEAT_FAVORED_ENEMY_MONSTROUS        = 274;
int FEAT_FAVORED_ENEMY_ORC              = 275;
int FEAT_FAVORED_ENEMY_REPTILIAN        = 276;
int FEAT_FAVORED_ENEMY_ELEMENTAL        = 277;
int FEAT_FAVORED_ENEMY_FEY              = 278;
int FEAT_FAVORED_ENEMY_GIANT            = 279;
int FEAT_FAVORED_ENEMY_MAGICAL_BEAST    = 280;
int FEAT_FAVORED_ENEMY_OUTSIDER         = 281;
int FEAT_FAVORED_ENEMY_SHAPECHANGER     = 284;
int FEAT_FAVORED_ENEMY_UNDEAD           = 285;
int FEAT_FAVORED_ENEMY_VERMIN           = 286;
int FEAT_WEAPON_PROFICIENCY_CREATURE    = 289;
int FEAT_WEAPON_SPECIALIZATION_CREATURE = 290;
int FEAT_WEAPON_FOCUS_CREATURE          = 291;
int FEAT_IMPROVED_CRITICAL_CREATURE     = 292;
int FEAT_BARBARIAN_RAGE                 = 293;
int FEAT_TURN_UNDEAD                    = 294;
int FEAT_QUIVERING_PALM                 = 296;
int FEAT_EMPTY_BODY                     = 297;
//int FEAT_DETECT_EVIL = 298;
int FEAT_LAY_ON_HANDS                   = 299;
int FEAT_AURA_OF_COURAGE                = 300;
int FEAT_SMITE_EVIL                     = 301;
int FEAT_REMOVE_DISEASE                 = 302;
int FEAT_SUMMON_FAMILIAR                = 303;
int FEAT_ELEMENTAL_SHAPE                = 304;
int FEAT_WILD_SHAPE                     = 305;
int FEAT_WAR_DOMAIN_POWER               = 306;
int FEAT_STRENGTH_DOMAIN_POWER          = 307;
int FEAT_PROTECTION_DOMAIN_POWER        = 308;
int FEAT_LUCK_DOMAIN_POWER              = 309;
int FEAT_DEATH_DOMAIN_POWER             = 310;
int FEAT_AIR_DOMAIN_POWER               = 311;
int FEAT_ANIMAL_DOMAIN_POWER            = 312;
int FEAT_DESTRUCTION_DOMAIN_POWER       = 313;
int FEAT_EARTH_DOMAIN_POWER             = 314;
int FEAT_EVIL_DOMAIN_POWER              = 315;
int FEAT_FIRE_DOMAIN_POWER              = 316;
int FEAT_GOOD_DOMAIN_POWER              = 317;
int FEAT_HEALING_DOMAIN_POWER           = 318;
int FEAT_KNOWLEDGE_DOMAIN_POWER         = 319;
int FEAT_MAGIC_DOMAIN_POWER             = 320;
int FEAT_PLANT_DOMAIN_POWER             = 321;
int FEAT_SUN_DOMAIN_POWER               = 322;
int FEAT_TRAVEL_DOMAIN_POWER            = 323;
int FEAT_TRICKERY_DOMAIN_POWER          = 324;
int FEAT_WATER_DOMAIN_POWER             = 325;
int FEAT_LOWLIGHTVISION                 = 354;
int FEAT_IMPROVED_INITIATIVE = 377;
int FEAT_ARTIST = 378;
int FEAT_BLOODED = 379;
int FEAT_BULLHEADED = 380;
int FEAT_COURTLY_MAGOCRACY = 381;
int FEAT_LUCK_OF_HEROES = 382;
int FEAT_RESIST_POISON = 383;
int FEAT_SILVER_PALM = 384;
int FEAT_SNAKEBLOOD = 386;
int FEAT_STEALTHY = 387;
int FEAT_STRONGSOUL = 388;
int FEAT_EXPERTISE = 389;
int FEAT_IMPROVED_EXPERTISE = 390;
int FEAT_GREAT_CLEAVE = 391;
int FEAT_SPRING_ATTACK = 392;
int FEAT_GREATER_SPELL_FOCUS_ABJURATION = 393;
int FEAT_GREATER_SPELL_FOCUS_CONJURATION = 394;
int FEAT_GREATER_SPELL_FOCUS_DIVINIATION = 395;
int FEAT_GREATER_SPELL_FOCUS_DIVINATION = 395;
int FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT = 396;
int FEAT_GREATER_SPELL_FOCUS_EVOCATION = 397;
int FEAT_GREATER_SPELL_FOCUS_ILLUSION = 398;
int FEAT_GREATER_SPELL_FOCUS_NECROMANCY = 399;
int FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION = 400;
int FEAT_GREATER_SPELL_PENETRATION = 401;
int FEAT_THUG = 402;
int FEAT_SKILLFOCUS_APPRAISE = 404;
int FEAT_SKILL_FOCUS_TUMBLE = 406;
int FEAT_SKILL_FOCUS_CRAFT_TRAP = 407;
int FEAT_BLIND_FIGHT = 408;
int FEAT_CIRCLE_KICK = 409;
int FEAT_EXTRA_STUNNING_ATTACK = 410;
int FEAT_RAPID_RELOAD = 411;
int FEAT_ZEN_ARCHERY = 412;
int FEAT_DIVINE_MIGHT = 413;
int FEAT_DIVINE_SHIELD = 414;
int FEAT_ARCANE_DEFENSE_ABJURATION = 415;
int FEAT_ARCANE_DEFENSE_CONJURATION = 416;
int FEAT_ARCANE_DEFENSE_DIVINATION = 417;
int FEAT_ARCANE_DEFENSE_ENCHANTMENT = 418;
int FEAT_ARCANE_DEFENSE_EVOCATION = 419;
int FEAT_ARCANE_DEFENSE_ILLUSION = 420;
int FEAT_ARCANE_DEFENSE_NECROMANCY = 421;
int FEAT_ARCANE_DEFENSE_TRANSMUTATION = 422;
int FEAT_EXTRA_MUSIC = 423;
int FEAT_LINGERING_SONG = 424;
int FEAT_DIRTY_FIGHTING = 425;
int FEAT_RESIST_DISEASE = 426;
int FEAT_RESIST_ENERGY_COLD = 427;
int FEAT_RESIST_ENERGY_ACID = 428;
int FEAT_RESIST_ENERGY_FIRE = 429;
int FEAT_RESIST_ENERGY_ELECTRICAL = 430;
int FEAT_RESIST_ENERGY_SONIC = 431;
int FEAT_HIDE_IN_PLAIN_SIGHT = 433;
int FEAT_SHADOW_DAZE = 434;
int FEAT_SUMMON_SHADOW = 435;
int FEAT_SHADOW_EVADE = 436;
int FEAT_DENEIRS_EYE = 437;
int FEAT_TYMORAS_SMILE = 438;
int FEAT_LLIIRAS_HEART = 439;
int FEAT_CRAFT_HARPER_ITEM = 440;
int FEAT_HARPER_SLEEP = 441;
int FEAT_HARPER_CATS_GRACE = 442;
int FEAT_HARPER_EAGLES_SPLENDOR = 443;
int FEAT_HARPER_INVISIBILITY = 444;

int FEAT_PRESTIGE_ENCHANT_ARROW_1     =  445;

int FEAT_PRESTIGE_ENCHANT_ARROW_2     =  446;
int FEAT_PRESTIGE_ENCHANT_ARROW_3     =  447;
int FEAT_PRESTIGE_ENCHANT_ARROW_4     =  448;
int FEAT_PRESTIGE_ENCHANT_ARROW_5     =  449;
int FEAT_PRESTIGE_IMBUE_ARROW     =  450;
int FEAT_PRESTIGE_SEEKER_ARROW_1     =  451;
int FEAT_PRESTIGE_SEEKER_ARROW_2     =  452;
int FEAT_PRESTIGE_HAIL_OF_ARROWS     =  453;
int FEAT_PRESTIGE_ARROW_OF_DEATH     =  454;


int FEAT_PRESTIGE_DEATH_ATTACK_1     =  455;
int FEAT_PRESTIGE_DEATH_ATTACK_2     =  456;
int FEAT_PRESTIGE_DEATH_ATTACK_3     =  457;
int FEAT_PRESTIGE_DEATH_ATTACK_4     =  458;
int FEAT_PRESTIGE_DEATH_ATTACK_5     =  459;

int FEAT_BLACKGUARD_SNEAK_ATTACK_1D6     =  460;
int FEAT_BLACKGUARD_SNEAK_ATTACK_2D6     =  461;
int FEAT_BLACKGUARD_SNEAK_ATTACK_3D6     =  462;

int FEAT_PRESTIGE_POISON_SAVE_1     =  463;
int FEAT_PRESTIGE_POISON_SAVE_2     =  464;
int FEAT_PRESTIGE_POISON_SAVE_3     =  465;
int FEAT_PRESTIGE_POISON_SAVE_4     =  466;
int FEAT_PRESTIGE_POISON_SAVE_5     =  467;

int FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE     =  468;
int FEAT_PRESTIGE_DARKNESS     =  469;
int FEAT_PRESTIGE_INVISIBILITY_1     =  470;
int FEAT_PRESTIGE_INVISIBILITY_2     =  471;

int FEAT_SMITE_GOOD     =  472;

int FEAT_PRESTIGE_DARK_BLESSING     =  473;
int FEAT_INFLICT_LIGHT_WOUNDS     =  474;
int FEAT_INFLICT_MODERATE_WOUNDS     =  475;
int FEAT_INFLICT_SERIOUS_WOUNDS     =  476;
int FEAT_INFLICT_CRITICAL_WOUNDS     =  477;
int FEAT_BULLS_STRENGTH     =  478;
int FEAT_CONTAGION     =  479;
int FEAT_EYE_OF_GRUUMSH_BLINDING_SPITTLE   = 480;
int FEAT_EYE_OF_GRUUMSH_BLINDING_SPITTLE_2 = 481;
int FEAT_EYE_OF_GRUUMSH_COMMAND_THE_HORDE  = 482;
int FEAT_EYE_OF_GRUUMSH_SWING_BLINDLY      = 483;
int FEAT_EYE_OF_GRUUMSH_RITUAL_SCARRING    = 484;
int FEAT_BLINDSIGHT_5_FEET                 = 485;
int FEAT_BLINDSIGHT_10_FEET                = 486;
int FEAT_EYE_OF_GRUUMSH_SIGHT_OF_GRUUMSH   = 487;
int FEAT_BLINDSIGHT_60_FEET                = 488;
int FEAT_SHOU_DISCIPLE_DODGE_2             = 489;
int FEAT_EPIC_ARMOR_SKIN     =  490;
int FEAT_EPIC_BLINDING_SPEED     =  491;
int FEAT_EPIC_DAMAGE_REDUCTION_3     =  492;
int FEAT_EPIC_DAMAGE_REDUCTION_6     =  493;
int FEAT_EPIC_DAMAGE_REDUCTION_9     =  494;
int FEAT_EPIC_DEVASTATING_CRITICAL_CLUB     =  495;
int FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER     =  496;
int FEAT_EPIC_DEVASTATING_CRITICAL_DART     =  497;
int FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW     =  498;
int FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW     =  499;
int FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE     =  500;
int FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR     =  501;
int FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF     =  502;
int FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR     =  503;
int FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE     =  504;
int FEAT_EPIC_DEVASTATING_CRITICAL_SLING     =  505;
int FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED     =  506;
int FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW     =  507;
int FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW     =  508;
int FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD     =  509;
int FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER     =  510;
int FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR     =  511;
int FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD     =  512;
int FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD     =  513;
int FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE     =  514;
int FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE     =  515;
int FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE     =  516;
int FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE     =  517;
int FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD     =  518;
int FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER     =  519;
int FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL     =  520;
int FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER     =  521;
int FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL     =  522;
int FEAT_EPIC_DEVASTATING_CRITICAL_KAMA     =  523;
int FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI     =  524;
int FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN     =  525;
int FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE     =  526;
int FEAT_EPIC_DEVASTATING_CRITICAL_KATANA     =  527;
int FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD     =  528;
int FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE     =  529;
int FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE     =  530;
int FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD     =  531;
int FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE     =  532;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_1     =  533;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_2     =  534;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_3     =  535;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_4     =  536;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_5     =  537;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_6     =  538;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_7     =  539;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_8     =  540;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_9     =  541;
int FEAT_EPIC_ENERGY_RESISTANCE_COLD_10     =  542;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_1     =  543;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_2     =  544;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_3     =  545;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_4     =  546;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_5     =  547;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_6     =  548;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_7     =  549;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_8     =  550;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_9     =  551;
int FEAT_EPIC_ENERGY_RESISTANCE_ACID_10     =  552;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1     =  553;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_2     =  554;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_3     =  555;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_4     =  556;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_5     =  557;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_6     =  558;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_7     =  559;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_8     =  560;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_9     =  561;
int FEAT_EPIC_ENERGY_RESISTANCE_FIRE_10     =  562;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_1     =  563;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_2     =  564;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_3     =  565;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_4     =  566;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_5     =  567;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_6     =  568;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_7     =  569;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_8     =  570;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_9     =  571;
int FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_10     =  572;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_1     =  573;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_2     =  574;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_3     =  575;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_4     =  576;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_5     =  577;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_6     =  578;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_7     =  579;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_8     =  580;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_9     =  581;
int FEAT_EPIC_ENERGY_RESISTANCE_SONIC_10     =  582;

int FEAT_EPIC_FORTITUDE     =  583;
int FEAT_EPIC_PROWESS     =  584;
int FEAT_EPIC_REFLEXES     =  585;
int FEAT_EPIC_REPUTATION     =  586;
int FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY     =  587;
int FEAT_EPIC_SKILL_FOCUS_APPRAISE     =  588;
int FEAT_EPIC_SKILL_FOCUS_CONCENTRATION     =  589;
int FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP     =  590;
int FEAT_EPIC_SKILL_FOCUS_DISABLETRAP     =  591;
int FEAT_EPIC_SKILL_FOCUS_DISCIPLINE     =  592;
int FEAT_EPIC_SKILL_FOCUS_HEAL     =  593;
int FEAT_EPIC_SKILL_FOCUS_HIDE     =  594;
int FEAT_EPIC_SKILL_FOCUS_LISTEN     =  595;
int FEAT_EPIC_SKILL_FOCUS_LORE     =  596;
int FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY     =  597;
int FEAT_EPIC_SKILL_FOCUS_OPENLOCK     =  598;
int FEAT_EPIC_SKILL_FOCUS_PARRY     =  599;
int FEAT_EPIC_SKILL_FOCUS_PERFORM     =  600;
int FEAT_EPIC_SKILL_FOCUS_PERSUADE     =  601;
int FEAT_EPIC_SKILL_FOCUS_PICKPOCKET     =  602;
int FEAT_EPIC_SKILL_FOCUS_SEARCH     =  603;
int FEAT_EPIC_SKILL_FOCUS_SETTRAP     =  604;
int FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT     =  605;
int FEAT_EPIC_SKILL_FOCUS_SPOT     =  606;
int FEAT_EPIC_SKILL_FOCUS_TAUNT     =  607;
int FEAT_EPIC_SKILL_FOCUS_TUMBLE     =  608;
int FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE     =  609;
int FEAT_EPIC_SPELL_FOCUS_ABJURATION     =  610;
int FEAT_EPIC_SPELL_FOCUS_CONJURATION     =  611;
int FEAT_EPIC_SPELL_FOCUS_DIVINATION     =  612;
int FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT     =  613;
int FEAT_EPIC_SPELL_FOCUS_EVOCATION     =  614;
int FEAT_EPIC_SPELL_FOCUS_ILLUSION     =  615;
int FEAT_EPIC_SPELL_FOCUS_NECROMANCY     =  616;
int FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION     =  617;
int FEAT_EPIC_SPELL_PENETRATION     =  618;
int FEAT_EPIC_WEAPON_FOCUS_CLUB     =  619;
int FEAT_EPIC_WEAPON_FOCUS_DAGGER     =  620;
int FEAT_EPIC_WEAPON_FOCUS_DART     =  621;
int FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW     =  622;
int FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW     =  623;
int FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE     =  624;
int FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR     =  625;
int FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF     =  626;
int FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR     =  627;
int FEAT_EPIC_WEAPON_FOCUS_SICKLE     =  628;
int FEAT_EPIC_WEAPON_FOCUS_SLING     =  629;
int FEAT_EPIC_WEAPON_FOCUS_UNARMED     =  630;
int FEAT_EPIC_WEAPON_FOCUS_LONGBOW     =  631;
int FEAT_EPIC_WEAPON_FOCUS_SHORTBOW     =  632;
int FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD     =  633;
int FEAT_EPIC_WEAPON_FOCUS_RAPIER     =  634;
int FEAT_EPIC_WEAPON_FOCUS_SCIMITAR     =  635;
int FEAT_EPIC_WEAPON_FOCUS_LONGSWORD     =  636;
int FEAT_EPIC_WEAPON_FOCUS_GREATSWORD     =  637;
int FEAT_EPIC_WEAPON_FOCUS_HANDAXE     =  638;
int FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE     =  639;
int FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE     =  640;
int FEAT_EPIC_WEAPON_FOCUS_GREATAXE     =  641;
int FEAT_EPIC_WEAPON_FOCUS_HALBERD     =  642;
int FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER     =  643;
int FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL     =  644;
int FEAT_EPIC_WEAPON_FOCUS_WARHAMMER     =  645;
int FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL     =  646;
int FEAT_EPIC_WEAPON_FOCUS_KAMA     =  647;
int FEAT_EPIC_WEAPON_FOCUS_KUKRI     =  648;
int FEAT_EPIC_WEAPON_FOCUS_SHURIKEN     =  649;
int FEAT_EPIC_WEAPON_FOCUS_SCYTHE     =  650;
int FEAT_EPIC_WEAPON_FOCUS_KATANA     =  651;
int FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD     =  652;
int FEAT_EPIC_WEAPON_FOCUS_DIREMACE     =  653;
int FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE     =  654;
int FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD     =  655;
int FEAT_EPIC_WEAPON_FOCUS_CREATURE     =  656;
int FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB     =  657;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER     =  658;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DART     =  659;
int FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW     =  660;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW     =  661;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE     =  662;
int FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR     =  663;
int FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF     =  664;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR     =  665;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE     =  666;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SLING     =  667;
int FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED     =  668;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW     =  669;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW     =  670;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD     =  671;
int FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER     =  672;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR     =  673;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD     =  674;
int FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD     =  675;
int FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE     =  676;
int FEAT_EPIC_WEAPON_SPECIALIZATION_THROWINGAXE     =  677;
int FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE     =  678;
int FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE     =  679;
int FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD     =  680;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER     =  681;
int FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL     =  682;
int FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER     =  683;
int FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL     =  684;
int FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA     =  685;
int FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI     =  686;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN     =  687;
int FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE     =  688;
int FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA     =  689;
int FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD     =  690;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE     =  691;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE     =  692;
int FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD     =  693;
int FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE     =  694;

int FEAT_EPIC_WILL     =  695;
int FEAT_EPIC_IMPROVED_COMBAT_CASTING     =  696;
int FEAT_EPIC_IMPROVED_KI_STRIKE_4     =  697;
int FEAT_EPIC_IMPROVED_KI_STRIKE_5     =  698;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_1     =  699;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_2     =  700;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_3     =  701;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_4     =  702;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_5     =  703;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_6     =  704;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_7     =  705;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_8     =  706;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_9     =  707;
int FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_10     =  708;
int FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB     =  709;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER     =  710;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DART     =  711;
int FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYCROSSBOW     =  712;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTCROSSBOW     =  713;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE     =  714;
int FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR     =  715;
int FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF     =  716;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR     =  717;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE     =  718;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SLING     =  719;
int FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED     =  720;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LONGBOW     =  721;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTBOW     =  722;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD     =  723;
int FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER     =  724;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR     =  725;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD     =  726;
int FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD     =  727;
int FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE     =  728;
int FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE     =  729;
int FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE     =  730;
int FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE     =  731;
int FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD     =  732;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER     =  733;
int FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL     =  734;
int FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER     =  735;
int FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL     =  736;
int FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA     =  737;
int FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI     =  738;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN     =  739;
int FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE     =  740;
int FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA     =  741;
int FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD     =  742;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE     =  743;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE     =  744;
int FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD     =  745;
int FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE     =  746;
int FEAT_EPIC_PERFECT_HEALTH     =  747;
int FEAT_EPIC_SELF_CONCEALMENT_10     =  748;
int FEAT_EPIC_SELF_CONCEALMENT_20     =  749;
int FEAT_EPIC_SELF_CONCEALMENT_30     =  750;
int FEAT_EPIC_SELF_CONCEALMENT_40     =  751;
int FEAT_EPIC_SELF_CONCEALMENT_50     =  752;
int FEAT_EPIC_SUPERIOR_INITIATIVE     =  753;
int FEAT_EPIC_TOUGHNESS_1     =  754;
int FEAT_EPIC_TOUGHNESS_2     =  755;
int FEAT_EPIC_TOUGHNESS_3     =  756;
int FEAT_EPIC_TOUGHNESS_4     =  757;
int FEAT_EPIC_TOUGHNESS_5     =  758;
int FEAT_EPIC_TOUGHNESS_6     =  759;
int FEAT_EPIC_TOUGHNESS_7     =  760;
int FEAT_EPIC_TOUGHNESS_8     =  761;
int FEAT_EPIC_TOUGHNESS_9     =  762;
int FEAT_EPIC_TOUGHNESS_10     =  763;
int FEAT_EPIC_GREAT_CHARISMA_1     =  764;
int FEAT_EPIC_GREAT_CHARISMA_2     =  765;
int FEAT_EPIC_GREAT_CHARISMA_3     =  766;
int FEAT_EPIC_GREAT_CHARISMA_4     =  767;
int FEAT_EPIC_GREAT_CHARISMA_5     =  768;
int FEAT_EPIC_GREAT_CHARISMA_6     =  769;
int FEAT_EPIC_GREAT_CHARISMA_7     =  770;
int FEAT_EPIC_GREAT_CHARISMA_8     =  771;
int FEAT_EPIC_GREAT_CHARISMA_9     =  772;
int FEAT_EPIC_GREAT_CHARISMA_10     =  773;
int FEAT_EPIC_GREAT_CONSTITUTION_1     =  774;
int FEAT_EPIC_GREAT_CONSTITUTION_2     =  775;
int FEAT_EPIC_GREAT_CONSTITUTION_3     =  776;
int FEAT_EPIC_GREAT_CONSTITUTION_4     =  777;
int FEAT_EPIC_GREAT_CONSTITUTION_5     =  778;
int FEAT_EPIC_GREAT_CONSTITUTION_6     =  779;
int FEAT_EPIC_GREAT_CONSTITUTION_7     =  780;
int FEAT_EPIC_GREAT_CONSTITUTION_8     =  781;
int FEAT_EPIC_GREAT_CONSTITUTION_9     =  782;
int FEAT_EPIC_GREAT_CONSTITUTION_10     =  783;
int FEAT_EPIC_GREAT_DEXTERITY_1     =  784;
int FEAT_EPIC_GREAT_DEXTERITY_2     =  785;
int FEAT_EPIC_GREAT_DEXTERITY_3     =  786;
int FEAT_EPIC_GREAT_DEXTERITY_4     =  787;
int FEAT_EPIC_GREAT_DEXTERITY_5     =  788;
int FEAT_EPIC_GREAT_DEXTERITY_6     =  789;
int FEAT_EPIC_GREAT_DEXTERITY_7     =  790;
int FEAT_EPIC_GREAT_DEXTERITY_8     =  791;
int FEAT_EPIC_GREAT_DEXTERITY_9     =  792;
int FEAT_EPIC_GREAT_DEXTERITY_10     =  793;
int FEAT_EPIC_GREAT_INTELLIGENCE_1     =  794;
int FEAT_EPIC_GREAT_INTELLIGENCE_2     =  795;
int FEAT_EPIC_GREAT_INTELLIGENCE_3     =  796;
int FEAT_EPIC_GREAT_INTELLIGENCE_4     =  797;
int FEAT_EPIC_GREAT_INTELLIGENCE_5     =  798;
int FEAT_EPIC_GREAT_INTELLIGENCE_6     =  799;
int FEAT_EPIC_GREAT_INTELLIGENCE_7     =  800;
int FEAT_EPIC_GREAT_INTELLIGENCE_8     =  801;
int FEAT_EPIC_GREAT_INTELLIGENCE_9     =  802;
int FEAT_EPIC_GREAT_INTELLIGENCE_10     =  803;
int FEAT_EPIC_GREAT_WISDOM_1     =  804;
int FEAT_EPIC_GREAT_WISDOM_2     =  805;
int FEAT_EPIC_GREAT_WISDOM_3     =  806;
int FEAT_EPIC_GREAT_WISDOM_4     =  807;
int FEAT_EPIC_GREAT_WISDOM_5     =  808;
int FEAT_EPIC_GREAT_WISDOM_6     =  809;
int FEAT_EPIC_GREAT_WISDOM_7     =  810;
int FEAT_EPIC_GREAT_WISDOM_8     =  811;
int FEAT_EPIC_GREAT_WISDOM_9     =  812;
int FEAT_EPIC_GREAT_WISDOM_10     =  813;
int FEAT_EPIC_GREAT_STRENGTH_1     =  814;
int FEAT_EPIC_GREAT_STRENGTH_2     =  815;
int FEAT_EPIC_GREAT_STRENGTH_3     =  816;
int FEAT_EPIC_GREAT_STRENGTH_4     =  817;
int FEAT_EPIC_GREAT_STRENGTH_5     =  818;
int FEAT_EPIC_GREAT_STRENGTH_6     =  819;
int FEAT_EPIC_GREAT_STRENGTH_7     =  820;
int FEAT_EPIC_GREAT_STRENGTH_8     =  821;
int FEAT_EPIC_GREAT_STRENGTH_9     =  822;
int FEAT_EPIC_GREAT_STRENGTH_10     =  823;
int FEAT_EPIC_GREAT_SMITING_1     =  824;
int FEAT_EPIC_GREAT_SMITING_2     =  825;
int FEAT_EPIC_GREAT_SMITING_3     =  826;
int FEAT_EPIC_GREAT_SMITING_4     =  827;
int FEAT_EPIC_GREAT_SMITING_5     =  828;
int FEAT_EPIC_GREAT_SMITING_6     =  829;
int FEAT_EPIC_GREAT_SMITING_7     =  830;
int FEAT_EPIC_GREAT_SMITING_8     =  831;
int FEAT_EPIC_GREAT_SMITING_9     =  832;
int FEAT_EPIC_GREAT_SMITING_10     =  833;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1     =  834;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2     =  835;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3     =  836;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4     =  837;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5     =  838;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6     =  839;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7     =  840;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8     =  841;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9     =  842;
int FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10     =  843;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_1     =  844;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_2     =  845;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_3     =  846;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_4     =  847;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_5     =  848;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_6     =  849;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_7     =  850;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_8     =  851;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_9     =  852;
int FEAT_EPIC_IMPROVED_STUNNING_FIST_10     =  853;

//int FEAT_EPIC_PLANAR_TURNING     =  854;
int FEAT_EPIC_BANE_OF_ENEMIES     =  855;
int FEAT_EPIC_DODGE     =  856;
int FEAT_EPIC_AUTOMATIC_QUICKEN_1     =  857;
int FEAT_EPIC_AUTOMATIC_QUICKEN_2     =  858;
int FEAT_EPIC_AUTOMATIC_QUICKEN_3     =  859;
int FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1   =  860;
int FEAT_EPIC_AUTOMATIC_SILENT_SPELL_2   =  861;
int FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3   =  862;
int FEAT_EPIC_AUTOMATIC_STILL_SPELL_1    =  863;
int FEAT_EPIC_AUTOMATIC_STILL_SPELL_2    =  864;
int FEAT_EPIC_AUTOMATIC_STILL_SPELL_3    =  865;

int FEAT_SHOU_DISCIPLE_MARTIAL_FLURRY_LIGHT = 866;
int FEAT_WHIRLWIND_ATTACK     =  867;
int FEAT_IMPROVED_WHIRLWIND     =  868;
int FEAT_MIGHTY_RAGE     =  869;
int FEAT_EPIC_LASTING_INSPIRATION     =  870;
int FEAT_CURSE_SONG     =  871;
int FEAT_EPIC_WILD_SHAPE_UNDEAD     =  872;
int FEAT_EPIC_WILD_SHAPE_DRAGON     =  873;
int FEAT_EPIC_SPELL_MUMMY_DUST     =  874;
int FEAT_EPIC_SPELL_DRAGON_KNIGHT     =  875;
int FEAT_EPIC_SPELL_HELLBALL     =  876;
int FEAT_EPIC_SPELL_MAGE_ARMOUR     =  877;
int FEAT_EPIC_SPELL_RUIN     =  878;
int FEAT_WEAPON_OF_CHOICE_SICKLE     =  879;
int FEAT_WEAPON_OF_CHOICE_KAMA     =  880;
int FEAT_WEAPON_OF_CHOICE_KUKRI     =  881;
int FEAT_KI_DAMAGE     =  882;
int FEAT_INCREASE_MULTIPLIER     =  883;
int FEAT_SUPERIOR_WEAPON_FOCUS     =  884;
int FEAT_KI_CRITICAL     =  885;
int FEAT_BONE_SKIN_2     =  886;
int FEAT_BONE_SKIN_4     =  887;
int FEAT_BONE_SKIN_6     =  888;
int FEAT_ANIMATE_DEAD     =  889;
int FEAT_SUMMON_UNDEAD     =  890;
int FEAT_DEATHLESS_VIGOR     =  891;
int FEAT_UNDEAD_GRAFT_1     =  892;
int FEAT_UNDEAD_GRAFT_2     =  893;
int FEAT_TOUGH_AS_BONE     =  894;
int FEAT_SUMMON_GREATER_UNDEAD     =  895;
int FEAT_DEATHLESS_MASTERY     =  896;
int FEAT_DEATHLESS_MASTER_TOUCH     =  897;
int FEAT_GREATER_WILDSHAPE_1     =  898;
int FEAT_SHOU_DISCIPLE_MARTIAL_FLURRY_ANY = 899;
int FEAT_GREATER_WILDSHAPE_2     =  900;
int FEAT_GREATER_WILDSHAPE_3     =  901;
int FEAT_HUMANOID_SHAPE     =  902;
int FEAT_GREATER_WILDSHAPE_4   =  903;
int FEAT_SACRED_DEFENSE_1     =  904;
int FEAT_SACRED_DEFENSE_2     =  905;
int FEAT_SACRED_DEFENSE_3     =  906;
int FEAT_SACRED_DEFENSE_4     =  907;
int FEAT_SACRED_DEFENSE_5     =  908;
int FEAT_DIVINE_WRATH     =  909;
int FEAT_EXTRA_SMITING     =  910;
int FEAT_SKILL_FOCUS_CRAFT_ARMOR     =  911;
int FEAT_SKILL_FOCUS_CRAFT_WEAPON     =  912;
int FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR     =  913;
int FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON     =  914;
int FEAT_SKILL_FOCUS_BLUFF     =  915;
int FEAT_SKILL_FOCUS_INTIMIDATE     =  916;
int FEAT_EPIC_SKILL_FOCUS_BLUFF     =  917;
int FEAT_EPIC_SKILL_FOCUS_INTIMIDATE     =  918;

int FEAT_WEAPON_OF_CHOICE_CLUB     =  919;
int FEAT_WEAPON_OF_CHOICE_DAGGER     =  920;
int FEAT_WEAPON_OF_CHOICE_LIGHTMACE     =  921;
int FEAT_WEAPON_OF_CHOICE_MORNINGSTAR     =  922;
int FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF     =  923;
int FEAT_WEAPON_OF_CHOICE_SHORTSPEAR     =  924;
int FEAT_WEAPON_OF_CHOICE_SHORTSWORD     =  925;
int FEAT_WEAPON_OF_CHOICE_RAPIER     =  926;
int FEAT_WEAPON_OF_CHOICE_SCIMITAR     =  927;
int FEAT_WEAPON_OF_CHOICE_LONGSWORD     =  928;
int FEAT_WEAPON_OF_CHOICE_GREATSWORD     =  929;
int FEAT_WEAPON_OF_CHOICE_HANDAXE     =  930;
int FEAT_WEAPON_OF_CHOICE_BATTLEAXE     =  931;
int FEAT_WEAPON_OF_CHOICE_GREATAXE     =  932;
int FEAT_WEAPON_OF_CHOICE_HALBERD     =  933;
int FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER     =  934;
int FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL     =  935;
int FEAT_WEAPON_OF_CHOICE_WARHAMMER     =  936;
int FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL     =  937;
int FEAT_WEAPON_OF_CHOICE_SCYTHE     =  938;
int FEAT_WEAPON_OF_CHOICE_KATANA     =  939;
int FEAT_WEAPON_OF_CHOICE_BASTARDSWORD     =  940;
int FEAT_WEAPON_OF_CHOICE_DIREMACE     =  941;
int FEAT_WEAPON_OF_CHOICE_DOUBLEAXE     =  942;
int FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD     =  943;

int FEAT_BREW_POTION     =  944;
int FEAT_SCRIBE_SCROLL     =  945;
int FEAT_CRAFT_WAND     =  946;

int FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE     =  947;
int FEAT_DAMAGE_REDUCTION_6     =  948;
int FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1     =  949;
int FEAT_PRESTIGE_DEFENSIVE_AWARENESS_2     =  950;
int FEAT_PRESTIGE_DEFENSIVE_AWARENESS_3     =  951;
int FEAT_WEAPON_FOCUS_DWAXE     =  952;
int FEAT_WEAPON_SPECIALIZATION_DWAXE     =  953;
int FEAT_IMPROVED_CRITICAL_DWAXE     =  954;
int FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE     =  955;
int FEAT_EPIC_WEAPON_FOCUS_DWAXE     =  956;
int FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE     =  957;
int FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE     =  958;
int FEAT_WEAPON_OF_CHOICE_DWAXE     =  959;
int FEAT_USE_POISON     =  960;

int FEAT_DRAGON_ARMOR            = 961;
int FEAT_DRAGON_ABILITIES        = 962;
int FEAT_DRAGON_IMMUNE_PARALYSIS = 963;
int FEAT_DRAGON_IMMUNE_FIRE       = 964;
int FEAT_DRAGON_DIS_BREATH        = 965;
int FEAT_EPIC_FIGHTER             = 966;
int FEAT_EPIC_BARBARIAN           = 967;
int FEAT_EPIC_BARD             = 968;
int FEAT_EPIC_CLERIC           = 969;
int FEAT_EPIC_DRUID            = 970;
int FEAT_EPIC_MONK             = 971;
int FEAT_EPIC_PALADIN          = 972;
int FEAT_EPIC_RANGER           = 973;
int FEAT_EPIC_ROGUE            = 974;
int FEAT_EPIC_SORCERER         = 975;
int FEAT_EPIC_WIZARD           = 976;
int FEAT_EPIC_ARCANE_ARCHER    = 977;
int FEAT_EPIC_ASSASSIN         = 978;
int FEAT_EPIC_BLACKGUARD       = 979;
int FEAT_EPIC_SHADOWDANCER     = 980;
int FEAT_EPIC_HARPER_SCOUT     = 981;
int FEAT_EPIC_DIVINE_CHAMPION  = 982;
int FEAT_EPIC_WEAPON_MASTER    = 983;
int FEAT_EPIC_PALE_MASTER      = 984;
int FEAT_EPIC_DWARVEN_DEFENDER = 985;
int FEAT_EPIC_SHIFTER          = 986;
int FEAT_EPIC_RED_DRAGON_DISC  = 987;
int FEAT_EPIC_THUNDERING_RAGE  = 988;
int FEAT_EPIC_TERRIFYING_RAGE    = 989;
int FEAT_EPIC_SPELL_EPIC_WARDING = 990;
int FEAT_WEAPON_FOCUS_WHIP       = 993;
int FEAT_WEAPON_SPECIALIZATION_WHIP = 994;
int FEAT_IMPROVED_CRITICAL_WHIP     = 995;
int FEAT_EPIC_DEVASTATING_CRITICAL_WHIP = 996;
int FEAT_EPIC_WEAPON_FOCUS_WHIP         = 997;
int FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP = 998;
int FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP = 999;
int FEAT_WEAPON_OF_CHOICE_WHIP           = 1000;
int FEAT_EPIC_CHARACTER                  = 1001;
int FEAT_EPIC_EPIC_SHADOWLORD            = 1002;
int FEAT_EPIC_EPIC_FIEND                 = 1003;
int FEAT_PRESTIGE_DEATH_ATTACK_6         = 1004;
int FEAT_PRESTIGE_DEATH_ATTACK_7         = 1005;
int FEAT_PRESTIGE_DEATH_ATTACK_8         = 1006;
int FEAT_BLACKGUARD_SNEAK_ATTACK_4D6     = 1007;
int FEAT_BLACKGUARD_SNEAK_ATTACK_5D6     = 1008;
int FEAT_BLACKGUARD_SNEAK_ATTACK_6D6     = 1009;
int FEAT_BLACKGUARD_SNEAK_ATTACK_7D6     = 1010;
int FEAT_BLACKGUARD_SNEAK_ATTACK_8D6     = 1011;
int FEAT_BLACKGUARD_SNEAK_ATTACK_9D6     = 1012;
int FEAT_BLACKGUARD_SNEAK_ATTACK_10D6    = 1013;
int FEAT_BLACKGUARD_SNEAK_ATTACK_11D6    = 1014;
int FEAT_BLACKGUARD_SNEAK_ATTACK_12D6    = 1015;
int FEAT_BLACKGUARD_SNEAK_ATTACK_13D6    = 1016;
int FEAT_BLACKGUARD_SNEAK_ATTACK_14D6    = 1017;
int FEAT_BLACKGUARD_SNEAK_ATTACK_15D6    = 1018;
int FEAT_PRESTIGE_DEATH_ATTACK_9         = 1019;
int FEAT_PRESTIGE_DEATH_ATTACK_10        = 1020;
int FEAT_PRESTIGE_DEATH_ATTACK_11        = 1021;
int FEAT_PRESTIGE_DEATH_ATTACK_12        = 1022;
int FEAT_PRESTIGE_DEATH_ATTACK_13        = 1023;
int FEAT_PRESTIGE_DEATH_ATTACK_14        = 1024;
int FEAT_PRESTIGE_DEATH_ATTACK_15        = 1025;
int FEAT_PRESTIGE_DEATH_ATTACK_16        = 1026;
int FEAT_PRESTIGE_DEATH_ATTACK_17        = 1027;
int FEAT_PRESTIGE_DEATH_ATTACK_18        = 1028;
int FEAT_PRESTIGE_DEATH_ATTACK_19        = 1029;
int FEAT_PRESTIGE_DEATH_ATTACK_20        = 1030;
int FEAT_SHOU_DISCIPLE_DODGE_3           = 1031;
int FEAT_DRAGON_HDINCREASE_D6            = 1042;
int FEAT_DRAGON_HDINCREASE_D8            = 1043;
int FEAT_DRAGON_HDINCREASE_D10           = 1044;
int FEAT_PRESTIGE_ENCHANT_ARROW_6        = 1045;
int FEAT_PRESTIGE_ENCHANT_ARROW_7        = 1046;
int FEAT_PRESTIGE_ENCHANT_ARROW_8        = 1047;
int FEAT_PRESTIGE_ENCHANT_ARROW_9        = 1048;
int FEAT_PRESTIGE_ENCHANT_ARROW_10       = 1049;
int FEAT_PRESTIGE_ENCHANT_ARROW_11       = 1050;
int FEAT_PRESTIGE_ENCHANT_ARROW_12       = 1051;
int FEAT_PRESTIGE_ENCHANT_ARROW_13       = 1052;
int FEAT_PRESTIGE_ENCHANT_ARROW_14       = 1053;
int FEAT_PRESTIGE_ENCHANT_ARROW_15       = 1054;
int FEAT_PRESTIGE_ENCHANT_ARROW_16       = 1055;
int FEAT_PRESTIGE_ENCHANT_ARROW_17       = 1056;
int FEAT_PRESTIGE_ENCHANT_ARROW_18       = 1057;
int FEAT_PRESTIGE_ENCHANT_ARROW_19       = 1058;
int FEAT_PRESTIGE_ENCHANT_ARROW_20       = 1059;
int FEAT_EPIC_OUTSIDER_SHAPE             = 1060;
int FEAT_EPIC_CONSTRUCT_SHAPE            = 1061;
int FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_1 = 1062;
int FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_2 = 1063;
int FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_3 = 1064;
int FEAT_EPIC_SHIFTER_INFINITE_WILDSHAPE_4 = 1065;
int FEAT_EPIC_SHIFTER_INFINITE_HUMANOID_SHAPE = 1066;
int FEAT_EPIC_BARBARIAN_DAMAGE_REDUCTION = 1067;
int FEAT_EPIC_DRUID_INFINITE_WILDSHAPE   = 1068;
int FEAT_EPIC_DRUID_INFINITE_ELEMENTAL_SHAPE = 1069;
int FEAT_PRESTIGE_POISON_SAVE_EPIC       = 1070;
int FEAT_EPIC_SUPERIOR_WEAPON_FOCUS      = 1071;

int FEAT_WEAPON_FOCUS_TRIDENT               = 1072;
int FEAT_WEAPON_SPECIALIZATION_TRIDENT      = 1073;
int FEAT_IMPROVED_CRITICAL_TRIDENT          = 1074;
int FEAT_EPIC_DEVASTATING_CRITICAL_TRIDENT  = 1075;
int FEAT_EPIC_WEAPON_FOCUS_TRIDENT          = 1076;
int FEAT_EPIC_WEAPON_SPECIALIZATION_TRIDENT = 1077;
int FEAT_EPIC_OVERWHELMING_CRITICAL_TRIDENT = 1078;
int FEAT_WEAPON_OF_CHOICE_TRIDENT           = 1079;
int FEAT_PDK_RALLY                          = 1080;
int FEAT_PDK_SHIELD                         = 1081;
int FEAT_PDK_FEAR                           = 1082;
int FEAT_PDK_WRATH                          = 1083;
int FEAT_PDK_STAND                          = 1084;
int FEAT_PDK_INSPIRE_1                      = 1085;
int FEAT_PDK_INSPIRE_2                      = 1086;
int FEAT_MOUNTED_COMBAT                     = 1087;
int FEAT_MOUNTED_ARCHERY                    = 1088;
int FEAT_HORSE_MENU                         = 1089;
int FEAT_HORSE_MOUNT                        = 1090;
int FEAT_HORSE_DISMOUNT                     = 1091;
int FEAT_HORSE_PARTY_MOUNT                  = 1092;
int FEAT_HORSE_PARTY_DISMOUNT               = 1093;
int FEAT_HORSE_ASSIGN_MOUNT                 = 1094;
int FEAT_PALADIN_SUMMON_MOUNT               = 1095;
int FEAT_PLAYER_TOOL_01                     = 1106;
int FEAT_PLAYER_TOOL_02                     = 1107;
int FEAT_PLAYER_TOOL_03                     = 1108;
int FEAT_PLAYER_TOOL_04                     = 1109;
int FEAT_PLAYER_TOOL_05                     = 1110;
int FEAT_PLAYER_TOOL_06                     = 1111;
int FEAT_PLAYER_TOOL_07                     = 1112;
int FEAT_PLAYER_TOOL_08                     = 1113;
int FEAT_PLAYER_TOOL_09                     = 1114;
int FEAT_PLAYER_TOOL_10                     = 1115;

// Subfeats for engine hardcoded entries
int SUBFEAT_CALLED_SHOT_LEG                 = 65000;
int SUBFEAT_CALLED_SHOT_ARMS                = 65001;
int SUBFEAT_ELEMENTAL_SHAPE_EARTH           = 1004;
int SUBFEAT_ELEMENTAL_SHAPE_WATER           = 1005;
int SUBFEAT_ELEMENTAL_SHAPE_FIRE            = 1006;
int SUBFEAT_ELEMENTAL_SHAPE_AIR             = 1007;
int SUBFEAT_WILD_SHAPE_BROWN_BEAR           = 1008;
int SUBFEAT_WILD_SHAPE_PANTHER              = 1009;
int SUBFEAT_WILD_SHAPE_WOLF                 = 1010;
int SUBFEAT_WILD_SHAPE_BOAR                 = 1011;
int SUBFEAT_WILD_SHAPE_BADGER               = 1012;

// Special Attack Defines
int SPECIAL_ATTACK_INVALID              =   0;
int SPECIAL_ATTACK_CALLED_SHOT_LEG      =   1;
int SPECIAL_ATTACK_CALLED_SHOT_ARM      =   2;
int SPECIAL_ATTACK_SAP                  =   3;
int SPECIAL_ATTACK_DISARM               =   4;
int SPECIAL_ATTACK_IMPROVED_DISARM      =   5;
int SPECIAL_ATTACK_KNOCKDOWN            =   6;
int SPECIAL_ATTACK_IMPROVED_KNOCKDOWN   =   7;
int SPECIAL_ATTACK_STUNNING_FIST        =   8;
int SPECIAL_ATTACK_FLURRY_OF_BLOWS      =   9;
int SPECIAL_ATTACK_RAPID_SHOT           =   10;

// Combat Mode Defines
int COMBAT_MODE_INVALID                 = 0;
int COMBAT_MODE_PARRY                   = 1;
int COMBAT_MODE_POWER_ATTACK            = 2;
int COMBAT_MODE_IMPROVED_POWER_ATTACK   = 3;
int COMBAT_MODE_FLURRY_OF_BLOWS         = 4;
int COMBAT_MODE_RAPID_SHOT              = 5;
int COMBAT_MODE_EXPERTISE               = 6;
int COMBAT_MODE_IMPROVED_EXPERTISE      = 7;
int COMBAT_MODE_DEFENSIVE_CASTING       = 8;
int COMBAT_MODE_DIRTY_FIGHTING          = 9;
int COMBAT_MODE_DEFENSIVE_STANCE        = 10;

// These represent the row in the difficulty 2da, rather than
// a difficulty value.
int ENCOUNTER_DIFFICULTY_VERY_EASY  = 0;
int ENCOUNTER_DIFFICULTY_EASY       = 1;
int ENCOUNTER_DIFFICULTY_NORMAL     = 2;
int ENCOUNTER_DIFFICULTY_HARD       = 3;
int ENCOUNTER_DIFFICULTY_IMPOSSIBLE = 4;

// Looping animation constants.
int ANIMATION_LOOPING_PAUSE                    = 0;
int ANIMATION_LOOPING_PAUSE2                   = 1;
int ANIMATION_LOOPING_LISTEN                   = 2;
int ANIMATION_LOOPING_MEDITATE                 = 3;
int ANIMATION_LOOPING_WORSHIP                  = 4;
int ANIMATION_LOOPING_LOOK_FAR                 = 5;
int ANIMATION_LOOPING_SIT_CHAIR                = 6;
int ANIMATION_LOOPING_SIT_CROSS                = 7;
int ANIMATION_LOOPING_TALK_NORMAL              = 8;
int ANIMATION_LOOPING_TALK_PLEADING            = 9;
int ANIMATION_LOOPING_TALK_FORCEFUL            = 10;
int ANIMATION_LOOPING_TALK_LAUGHING            = 11;
int ANIMATION_LOOPING_GET_LOW                  = 12;
int ANIMATION_LOOPING_GET_MID                  = 13;
int ANIMATION_LOOPING_PAUSE_TIRED              = 14;
int ANIMATION_LOOPING_PAUSE_DRUNK              = 15;
int ANIMATION_LOOPING_DEAD_FRONT               = 16;
int ANIMATION_LOOPING_DEAD_BACK                = 17;
int ANIMATION_LOOPING_CONJURE1                 = 18;
int ANIMATION_LOOPING_CONJURE2                 = 19;
int ANIMATION_LOOPING_SPASM                    = 20;
int ANIMATION_LOOPING_CUSTOM1                  = 21;
int ANIMATION_LOOPING_CUSTOM2                  = 22;
int ANIMATION_LOOPING_CUSTOM3                  = 23;
int ANIMATION_LOOPING_CUSTOM4                  = 24;
int ANIMATION_LOOPING_CUSTOM5                  = 25;
int ANIMATION_LOOPING_CUSTOM6                  = 26;
int ANIMATION_LOOPING_CUSTOM7                  = 27;
int ANIMATION_LOOPING_CUSTOM8                  = 28;
int ANIMATION_LOOPING_CUSTOM9                  = 29;
int ANIMATION_LOOPING_CUSTOM10                 = 30;
int ANIMATION_LOOPING_CUSTOM11                 = 31;
int ANIMATION_LOOPING_CUSTOM12                 = 32;
int ANIMATION_LOOPING_CUSTOM13                 = 33;
int ANIMATION_LOOPING_CUSTOM14                 = 34;
int ANIMATION_LOOPING_CUSTOM15                 = 35;
int ANIMATION_LOOPING_CUSTOM16                 = 36;
int ANIMATION_LOOPING_CUSTOM17                 = 37;
int ANIMATION_LOOPING_CUSTOM18                 = 38;
int ANIMATION_LOOPING_CUSTOM19                 = 39;
int ANIMATION_LOOPING_CUSTOM20                 = 40;
int ANIMATION_MOUNT1                           = 41;
int ANIMATION_DISMOUNT1                        = 42;
int ANIMATION_LOOPING_CUSTOM21                 = 43;
int ANIMATION_LOOPING_CUSTOM22                 = 44;
int ANIMATION_LOOPING_CUSTOM23                 = 45;
int ANIMATION_LOOPING_CUSTOM24                 = 46;
int ANIMATION_LOOPING_CUSTOM25                 = 47;
int ANIMATION_LOOPING_CUSTOM26                 = 48;
int ANIMATION_LOOPING_CUSTOM27                 = 49;
int ANIMATION_LOOPING_CUSTOM28                 = 50;
int ANIMATION_LOOPING_CUSTOM29                 = 51;
int ANIMATION_LOOPING_CUSTOM30                 = 52;
int ANIMATION_LOOPING_CUSTOM31                 = 53;
int ANIMATION_LOOPING_CUSTOM32                 = 54;
int ANIMATION_LOOPING_CUSTOM33                 = 55;
int ANIMATION_LOOPING_CUSTOM34                 = 56;
int ANIMATION_LOOPING_CUSTOM35                 = 57;
int ANIMATION_LOOPING_CUSTOM36                 = 58;
int ANIMATION_LOOPING_CUSTOM37                 = 59;
int ANIMATION_LOOPING_CUSTOM38                 = 60;
int ANIMATION_LOOPING_CUSTOM39                 = 61;
int ANIMATION_LOOPING_CUSTOM40                 = 62;
int ANIMATION_LOOPING_CUSTOM41                 = 63;
int ANIMATION_LOOPING_CUSTOM42                 = 64;
int ANIMATION_LOOPING_CUSTOM43                 = 65;
int ANIMATION_LOOPING_CUSTOM44                 = 66;
int ANIMATION_LOOPING_CUSTOM45                 = 67;
int ANIMATION_LOOPING_CUSTOM46                 = 68;
int ANIMATION_LOOPING_CUSTOM47                 = 69;
int ANIMATION_LOOPING_CUSTOM48                 = 70;
int ANIMATION_LOOPING_CUSTOM49                 = 71;
int ANIMATION_LOOPING_CUSTOM50                 = 72;
int ANIMATION_LOOPING_CUSTOM51                 = 73;
int ANIMATION_LOOPING_CUSTOM52                 = 74;
int ANIMATION_LOOPING_CUSTOM53                 = 75;
int ANIMATION_LOOPING_CUSTOM54                 = 76;
int ANIMATION_LOOPING_CUSTOM55                 = 77;
int ANIMATION_LOOPING_CUSTOM56                 = 78;
int ANIMATION_LOOPING_CUSTOM57                 = 79;
int ANIMATION_LOOPING_CUSTOM58                 = 80;
int ANIMATION_LOOPING_CUSTOM59                 = 81;
int ANIMATION_LOOPING_CUSTOM60                 = 82;
int ANIMATION_LOOPING_CUSTOM61                 = 83;
int ANIMATION_LOOPING_CUSTOM62                 = 84;
int ANIMATION_LOOPING_CUSTOM63                 = 85;
int ANIMATION_LOOPING_CUSTOM64                 = 86;
int ANIMATION_LOOPING_CUSTOM65                 = 87;
int ANIMATION_LOOPING_CUSTOM66                 = 88;
int ANIMATION_LOOPING_CUSTOM67                 = 89;
int ANIMATION_LOOPING_CUSTOM68                 = 90;
int ANIMATION_LOOPING_CUSTOM69                 = 91;
int ANIMATION_LOOPING_CUSTOM70                 = 92;

// Fire and forget animation constants.
int ANIMATION_FIREFORGET_HEAD_TURN_LEFT        = 100;
int ANIMATION_FIREFORGET_HEAD_TURN_RIGHT       = 101;
int ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD    = 102;
int ANIMATION_FIREFORGET_PAUSE_BORED           = 103;
int ANIMATION_FIREFORGET_SALUTE                = 104;
int ANIMATION_FIREFORGET_BOW                   = 105;
int ANIMATION_FIREFORGET_STEAL                 = 106;
int ANIMATION_FIREFORGET_GREETING              = 107;
int ANIMATION_FIREFORGET_TAUNT                 = 108;
int ANIMATION_FIREFORGET_VICTORY1              = 109;
int ANIMATION_FIREFORGET_VICTORY2              = 110;
int ANIMATION_FIREFORGET_VICTORY3              = 111;
int ANIMATION_FIREFORGET_READ                  = 112;
int ANIMATION_FIREFORGET_DRINK                 = 113;
int ANIMATION_FIREFORGET_DODGE_SIDE            = 114;
int ANIMATION_FIREFORGET_DODGE_DUCK            = 115;
int ANIMATION_FIREFORGET_SPASM                 = 116;

// Placeable animation constants
int ANIMATION_PLACEABLE_ACTIVATE               = 200;
int ANIMATION_PLACEABLE_DEACTIVATE             = 201;
int ANIMATION_PLACEABLE_OPEN                   = 202;
int ANIMATION_PLACEABLE_CLOSE                  = 203;

// Door animation constants
int ANIMATION_DOOR_CLOSE                       = 204;
int ANIMATION_DOOR_OPEN1                       = 205;
int ANIMATION_DOOR_OPEN2                       = 206;
int ANIMATION_DOOR_DESTROY                     = 207;

int TALENT_TYPE_SPELL      = 0;
int TALENT_TYPE_FEAT       = 1;
int TALENT_TYPE_SKILL      = 2;

// These must match the values in nwscreature.h and nwccreaturemenu.cpp
// Cannot use the value -1 because that is used to start a conversation
int ASSOCIATE_COMMAND_STANDGROUND             = -2;
int ASSOCIATE_COMMAND_ATTACKNEAREST           = -3;
int ASSOCIATE_COMMAND_HEALMASTER              = -4;
int ASSOCIATE_COMMAND_FOLLOWMASTER            = -5;
int ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK    = -6;
int ASSOCIATE_COMMAND_GUARDMASTER             = -7;
int ASSOCIATE_COMMAND_UNSUMMONFAMILIAR        = -8;
int ASSOCIATE_COMMAND_UNSUMMONANIMALCOMPANION = -9;
int ASSOCIATE_COMMAND_UNSUMMONSUMMONED        = -10;
int ASSOCIATE_COMMAND_MASTERUNDERATTACK       = -11;
int ASSOCIATE_COMMAND_RELEASEDOMINATION       = -12;
int ASSOCIATE_COMMAND_UNPOSSESSFAMILIAR       = -13;
int ASSOCIATE_COMMAND_MASTERSAWTRAP           = -14;
int ASSOCIATE_COMMAND_MASTERATTACKEDOTHER     = -15;
int ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED = -16;
int ASSOCIATE_COMMAND_LEAVEPARTY              = -17;
int ASSOCIATE_COMMAND_PICKLOCK                = -18;
int ASSOCIATE_COMMAND_INVENTORY               = -19;
int ASSOCIATE_COMMAND_DISARMTRAP              = -20;
int ASSOCIATE_COMMAND_TOGGLECASTING           = -21;
int ASSOCIATE_COMMAND_TOGGLESTEALTH           = -22;
int ASSOCIATE_COMMAND_TOGGLESEARCH            = -23;

// These match the values in nwscreature.h
int ASSOCIATE_TYPE_NONE             = 0;
int ASSOCIATE_TYPE_HENCHMAN         = 1;
int ASSOCIATE_TYPE_ANIMALCOMPANION  = 2;
int ASSOCIATE_TYPE_FAMILIAR         = 3;
int ASSOCIATE_TYPE_SUMMONED         = 4;
int ASSOCIATE_TYPE_DOMINATED        = 5;

// These must match the list in nwscreaturestats.cpp
int TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT   = 1;
int TALENT_CATEGORY_HARMFUL_RANGED                    = 2;
int TALENT_CATEGORY_HARMFUL_TOUCH                     = 3;
int TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT     = 4;
int TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH          = 5;
int TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT = 6;
int TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE     = 7;
int TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT = 8;
int TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE     = 9;
int TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF       = 10;
int TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT = 11;
int TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF        = 12;
int TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE      = 13;
int TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT  = 14;
int TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES          = 15;
int TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT         = 16;
int TALENT_CATEGORY_BENEFICIAL_HEALING_POTION         = 17;
int TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION     = 18;
int TALENT_CATEGORY_DRAGONS_BREATH                    = 19;
int TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION      = 20;
int TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION     = 21;
int TALENT_CATEGORY_HARMFUL_MELEE                     = 22;

int INVENTORY_DISTURB_TYPE_ADDED    = 0;
int INVENTORY_DISTURB_TYPE_REMOVED  = 1;
int INVENTORY_DISTURB_TYPE_STOLEN   = 2;

int GUI_PANEL_PLAYER_DEATH      = 0;
int GUI_PANEL_MINIMAP           = 2;
int GUI_PANEL_COMPASS           = 3;
int GUI_PANEL_INVENTORY         = 4;
int GUI_PANEL_PLAYERLIST        = 5;
int GUI_PANEL_JOURNAL           = 6;
int GUI_PANEL_SPELLBOOK         = 7;
int GUI_PANEL_CHARACTERSHEET    = 8;
int GUI_PANEL_LEVELUP           = 9;
int GUI_PANEL_GOLD_INVENTORY    = 10;
int GUI_PANEL_GOLD_BARTER       = 11;
int GUI_PANEL_EXAMINE_CREATURE  = 12;
int GUI_PANEL_EXAMINE_ITEM      = 13;
int GUI_PANEL_EXAMINE_PLACEABLE = 14;
int GUI_PANEL_EXAMINE_DOOR      = 15;
int GUI_PANEL_RADIAL_TILE       = 16;
int GUI_PANEL_RADIAL_TRIGGER    = 17;
int GUI_PANEL_RADIAL_CREATURE   = 18;
int GUI_PANEL_RADIAL_ITEM       = 19;
int GUI_PANEL_RADIAL_PLACEABLE  = 20;
int GUI_PANEL_RADIAL_DOOR       = 21;
int GUI_PANEL_RADIAL_QUICKBAR   = 22;

int VOICE_CHAT_ATTACK           =   0;
int VOICE_CHAT_BATTLECRY1       =   1;
int VOICE_CHAT_BATTLECRY2       =   2;
int VOICE_CHAT_BATTLECRY3       =   3;
int VOICE_CHAT_HEALME           =   4;
int VOICE_CHAT_HELP             =   5;
int VOICE_CHAT_ENEMIES          =   6;
int VOICE_CHAT_FLEE             =   7;
int VOICE_CHAT_TAUNT            =   8;
int VOICE_CHAT_GUARDME          =   9;
int VOICE_CHAT_HOLD             =   10;
int VOICE_CHAT_GATTACK1         =   11;
int VOICE_CHAT_GATTACK2         =   12;
int VOICE_CHAT_GATTACK3         =   13;
int VOICE_CHAT_PAIN1            =   14;
int VOICE_CHAT_PAIN2            =   15;
int VOICE_CHAT_PAIN3            =   16;
int VOICE_CHAT_NEARDEATH        =   17;
int VOICE_CHAT_DEATH            =   18;
int VOICE_CHAT_POISONED         =   19;
int VOICE_CHAT_SPELLFAILED      =   20;
int VOICE_CHAT_WEAPONSUCKS      =   21;
int VOICE_CHAT_FOLLOWME         =   22;
int VOICE_CHAT_LOOKHERE         =   23;
int VOICE_CHAT_GROUP            =   24;
int VOICE_CHAT_MOVEOVER         =   25;
int VOICE_CHAT_PICKLOCK         =   26;
int VOICE_CHAT_SEARCH           =   27;
int VOICE_CHAT_HIDE             =   28;
int VOICE_CHAT_CANDO            =   29;
int VOICE_CHAT_CANTDO           =   30;
int VOICE_CHAT_TASKCOMPLETE     =   31;
int VOICE_CHAT_ENCUMBERED       =   32;
int VOICE_CHAT_SELECTED         =   33;
int VOICE_CHAT_HELLO            =   34;
int VOICE_CHAT_YES              =   35;
int VOICE_CHAT_NO               =   36;
int VOICE_CHAT_STOP             =   37;
int VOICE_CHAT_REST             =   38;
int VOICE_CHAT_BORED            =   39;
int VOICE_CHAT_GOODBYE          =   40;
int VOICE_CHAT_THANKS           =   41;
int VOICE_CHAT_LAUGH            =   42;
int VOICE_CHAT_CUSS             =   43;
int VOICE_CHAT_CHEER            =   44;
int VOICE_CHAT_TALKTOME         =   45;
int VOICE_CHAT_GOODIDEA         =   46;
int VOICE_CHAT_BADIDEA          =   47;
int VOICE_CHAT_THREATEN         =   48;

int POLYMORPH_TYPE_WEREWOLF              = 0;
int POLYMORPH_TYPE_WERERAT               = 1;
int POLYMORPH_TYPE_WERECAT               = 2;
int POLYMORPH_TYPE_GIANT_SPIDER          = 3;
int POLYMORPH_TYPE_TROLL                 = 4;
int POLYMORPH_TYPE_UMBER_HULK            = 5;
int POLYMORPH_TYPE_PIXIE                 = 6;
int POLYMORPH_TYPE_ZOMBIE                = 7;
int POLYMORPH_TYPE_RED_DRAGON            = 8;
int POLYMORPH_TYPE_FIRE_GIANT            = 9;
int POLYMORPH_TYPE_BALOR                 = 10;
int POLYMORPH_TYPE_DEATH_SLAAD           = 11;
int POLYMORPH_TYPE_IRON_GOLEM            = 12;
int POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL   = 13;
int POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL  = 14;
int POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL  = 15;
int POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL    = 16;
int POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL  = 17;
int POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL = 18;
int POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL = 19;
int POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL   = 20;
int POLYMORPH_TYPE_BROWN_BEAR            = 21;
int POLYMORPH_TYPE_PANTHER               = 22;
int POLYMORPH_TYPE_WOLF                  = 23;
int POLYMORPH_TYPE_BOAR                  = 24;
int POLYMORPH_TYPE_BADGER                = 25;
int POLYMORPH_TYPE_PENGUIN               = 26;
int POLYMORPH_TYPE_COW                   = 27;
int POLYMORPH_TYPE_DOOM_KNIGHT           = 28;
int POLYMORPH_TYPE_YUANTI                = 29;
int POLYMORPH_TYPE_IMP                   = 30;
int POLYMORPH_TYPE_QUASIT                = 31;
int POLYMORPH_TYPE_SUCCUBUS              = 32;
int POLYMORPH_TYPE_DIRE_BROWN_BEAR       = 33;
int POLYMORPH_TYPE_DIRE_PANTHER          = 34;
int POLYMORPH_TYPE_DIRE_WOLF             = 35;
int POLYMORPH_TYPE_DIRE_BOAR             = 36;
int POLYMORPH_TYPE_DIRE_BADGER           = 37;
int POLYMORPH_TYPE_CELESTIAL_AVENGER     = 38;
int POLYMORPH_TYPE_VROCK                 = 39;
int POLYMORPH_TYPE_CHICKEN               = 40;
int POLYMORPH_TYPE_FROST_GIANT_MALE      = 41;
int POLYMORPH_TYPE_FROST_GIANT_FEMALE    = 42;
int POLYMORPH_TYPE_HEURODIS              = 43;
int POLYMORPH_TYPE_JNAH_GIANT_MALE       = 44;
int POLYMORPH_TYPE_JNAH_GIANT_FEMAL      = 45;
int POLYMORPH_TYPE_WYRMLING_WHITE        = 52;
int POLYMORPH_TYPE_WYRMLING_BLUE         = 53;
int POLYMORPH_TYPE_WYRMLING_RED          = 54;
int POLYMORPH_TYPE_WYRMLING_GREEN        = 55;
int POLYMORPH_TYPE_WYRMLING_BLACK        = 56;
int POLYMORPH_TYPE_GOLEM_AUTOMATON       = 57;
int POLYMORPH_TYPE_MANTICORE             = 58;
int POLYMORPH_TYPE_MALE_DROW             = 59;
int POLYMORPH_TYPE_HARPY             = 60;
int POLYMORPH_TYPE_BASILISK          = 61;
int POLYMORPH_TYPE_DRIDER            = 62;
int POLYMORPH_TYPE_BEHOLDER          = 63;
int POLYMORPH_TYPE_MEDUSA            = 64;
int POLYMORPH_TYPE_GARGOYLE          = 65;
int POLYMORPH_TYPE_MINOTAUR              = 66;
int POLYMORPH_TYPE_SUPER_CHICKEN         = 67;
int POLYMORPH_TYPE_MINDFLAYER            = 68;
int POLYMORPH_TYPE_DIRETIGER             = 69;
int POLYMORPH_TYPE_FEMALE_DROW           = 70;
int POLYMORPH_TYPE_ANCIENT_BLUE_DRAGON   = 71;
int POLYMORPH_TYPE_ANCIENT_RED_DRAGON    = 72;
int POLYMORPH_TYPE_ANCIENT_GREEN_DRAGON  = 73;
int POLYMORPH_TYPE_VAMPIRE_MALE          = 74;
int POLYMORPH_TYPE_RISEN_LORD            = 75;
int POLYMORPH_TYPE_SPECTRE               = 76;
int POLYMORPH_TYPE_VAMPIRE_FEMALE        = 77;
int POLYMORPH_TYPE_NULL_HUMAN            = 78;

int INVISIBILITY_TYPE_NORMAL   = 1;
int INVISIBILITY_TYPE_DARKNESS = 2;
int INVISIBILITY_TYPE_IMPROVED = 4;

int CREATURE_SIZE_INVALID = 0;
int CREATURE_SIZE_TINY =    1;
int CREATURE_SIZE_SMALL =   2;
int CREATURE_SIZE_MEDIUM =  3;
int CREATURE_SIZE_LARGE =   4;
int CREATURE_SIZE_HUGE =    5;

int SPELL_SCHOOL_GENERAL        = 0;
int SPELL_SCHOOL_ABJURATION     = 1;
int SPELL_SCHOOL_CONJURATION    = 2;
int SPELL_SCHOOL_DIVINATION     = 3;
int SPELL_SCHOOL_ENCHANTMENT    = 4;
int SPELL_SCHOOL_EVOCATION      = 5;
int SPELL_SCHOOL_ILLUSION       = 6;
int SPELL_SCHOOL_NECROMANCY     = 7;
int SPELL_SCHOOL_TRANSMUTATION  = 8;

int ANIMAL_COMPANION_CREATURE_TYPE_BADGER   = 0;
int ANIMAL_COMPANION_CREATURE_TYPE_WOLF     = 1;
int ANIMAL_COMPANION_CREATURE_TYPE_BEAR     = 2;
int ANIMAL_COMPANION_CREATURE_TYPE_BOAR     = 3;
int ANIMAL_COMPANION_CREATURE_TYPE_HAWK     = 4;
int ANIMAL_COMPANION_CREATURE_TYPE_PANTHER  = 5;
int ANIMAL_COMPANION_CREATURE_TYPE_SPIDER   = 6;
int ANIMAL_COMPANION_CREATURE_TYPE_DIREWOLF = 7;
int ANIMAL_COMPANION_CREATURE_TYPE_DIRERAT  = 8;
int ANIMAL_COMPANION_CREATURE_TYPE_NONE     = 255;

int FAMILIAR_CREATURE_TYPE_BAT        = 0;
int FAMILIAR_CREATURE_TYPE_CRAGCAT    = 1;
int FAMILIAR_CREATURE_TYPE_HELLHOUND  = 2;
int FAMILIAR_CREATURE_TYPE_IMP        = 3;
int FAMILIAR_CREATURE_TYPE_FIREMEPHIT = 4;
int FAMILIAR_CREATURE_TYPE_ICEMEPHIT  = 5;
int FAMILIAR_CREATURE_TYPE_PIXIE      = 6;
int FAMILIAR_CREATURE_TYPE_RAVEN           = 7;
int FAMILIAR_CREATURE_TYPE_FAIRY_DRAGON    = 8;
int FAMILIAR_CREATURE_TYPE_PSEUDO_DRAGON    = 9;
int FAMILIAR_CREATURE_TYPE_EYEBALL          = 10;
int FAMILIAR_CREATURE_TYPE_NONE       = 255;

int CAMERA_MODE_CHASE_CAMERA          = 0;
int CAMERA_MODE_TOP_DOWN              = 1;
int CAMERA_MODE_STIFF_CHASE_CAMERA    = 2;

int WEATHER_INVALID = -1;
int WEATHER_CLEAR = 0;
int WEATHER_RAIN  = 1;
int WEATHER_SNOW  = 2;
int WEATHER_USE_AREA_SETTINGS = -1;

int REST_EVENTTYPE_REST_INVALID     = 0;
int REST_EVENTTYPE_REST_STARTED     = 1;
int REST_EVENTTYPE_REST_FINISHED    = 2;
int REST_EVENTTYPE_REST_CANCELLED   = 3;

int PROJECTILE_PATH_TYPE_DEFAULT        = 0;
int PROJECTILE_PATH_TYPE_HOMING         = 1;
int PROJECTILE_PATH_TYPE_BALLISTIC      = 2;
int PROJECTILE_PATH_TYPE_HIGH_BALLISTIC = 3;
int PROJECTILE_PATH_TYPE_ACCELERATING   = 4;

int GAME_DIFFICULTY_VERY_EASY   = 0;
int GAME_DIFFICULTY_EASY        = 1;
int GAME_DIFFICULTY_NORMAL      = 2;
int GAME_DIFFICULTY_CORE_RULES  = 3;
int GAME_DIFFICULTY_DIFFICULT   = 4;

int TILE_MAIN_LIGHT_COLOR_BLACK             = 0;
int TILE_MAIN_LIGHT_COLOR_DIM_WHITE         = 1;
int TILE_MAIN_LIGHT_COLOR_WHITE             = 2;
int TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE      = 3;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW  = 4;
int TILE_MAIN_LIGHT_COLOR_DARK_YELLOW       = 5;
int TILE_MAIN_LIGHT_COLOR_PALE_YELLOW       = 6;
int TILE_MAIN_LIGHT_COLOR_YELLOW            = 7;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN   = 8;
int TILE_MAIN_LIGHT_COLOR_DARK_GREEN        = 9;
int TILE_MAIN_LIGHT_COLOR_PALE_GREEN        = 10;
int TILE_MAIN_LIGHT_COLOR_GREEN             = 11;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA    = 12;
int TILE_MAIN_LIGHT_COLOR_DARK_AQUA         = 13;
int TILE_MAIN_LIGHT_COLOR_PALE_AQUA         = 14;
int TILE_MAIN_LIGHT_COLOR_AQUA              = 15;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE    = 16;
int TILE_MAIN_LIGHT_COLOR_DARK_BLUE         = 17;
int TILE_MAIN_LIGHT_COLOR_PALE_BLUE         = 18;
int TILE_MAIN_LIGHT_COLOR_BLUE              = 19;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE  = 20;
int TILE_MAIN_LIGHT_COLOR_DARK_PURPLE       = 21;
int TILE_MAIN_LIGHT_COLOR_PALE_PURPLE       = 22;
int TILE_MAIN_LIGHT_COLOR_PURPLE            = 23;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED     = 24;
int TILE_MAIN_LIGHT_COLOR_DARK_RED          = 25;
int TILE_MAIN_LIGHT_COLOR_PALE_RED          = 26;
int TILE_MAIN_LIGHT_COLOR_RED               = 27;
int TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE  = 28;
int TILE_MAIN_LIGHT_COLOR_DARK_ORANGE       = 29;
int TILE_MAIN_LIGHT_COLOR_PALE_ORANGE       = 30;
int TILE_MAIN_LIGHT_COLOR_ORANGE            = 31;

int TILE_SOURCE_LIGHT_COLOR_BLACK             = 0;
int TILE_SOURCE_LIGHT_COLOR_WHITE             = 1;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_YELLOW  = 2;
int TILE_SOURCE_LIGHT_COLOR_PALE_YELLOW       = 3;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_GREEN   = 4;
int TILE_SOURCE_LIGHT_COLOR_PALE_GREEN        = 5;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA    = 6;
int TILE_SOURCE_LIGHT_COLOR_PALE_AQUA         = 7;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_BLUE    = 8;
int TILE_SOURCE_LIGHT_COLOR_PALE_BLUE         = 9;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE  = 10;
int TILE_SOURCE_LIGHT_COLOR_PALE_PURPLE       = 11;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_RED     = 12;
int TILE_SOURCE_LIGHT_COLOR_PALE_RED          = 13;
int TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE  = 14;
int TILE_SOURCE_LIGHT_COLOR_PALE_ORANGE       = 15;

int PANEL_BUTTON_MAP                  = 0;
int PANEL_BUTTON_INVENTORY            = 1;
int PANEL_BUTTON_JOURNAL              = 2;
int PANEL_BUTTON_CHARACTER            = 3;
int PANEL_BUTTON_OPTIONS              = 4;
int PANEL_BUTTON_SPELLS               = 5;
int PANEL_BUTTON_REST                 = 6;
int PANEL_BUTTON_PLAYER_VERSUS_PLAYER = 7;

int ACTION_MOVETOPOINT        = 0;
int ACTION_PICKUPITEM         = 1;
int ACTION_DROPITEM           = 2;
int ACTION_ATTACKOBJECT       = 3;
int ACTION_CASTSPELL          = 4;
int ACTION_OPENDOOR           = 5;
int ACTION_CLOSEDOOR          = 6;
int ACTION_DIALOGOBJECT       = 7;
int ACTION_DISABLETRAP        = 8;
int ACTION_RECOVERTRAP        = 9;
int ACTION_FLAGTRAP           = 10;
int ACTION_EXAMINETRAP        = 11;
int ACTION_SETTRAP            = 12;
int ACTION_OPENLOCK           = 13;
int ACTION_LOCK               = 14;
int ACTION_USEOBJECT          = 15;
int ACTION_ANIMALEMPATHY      = 16;
int ACTION_REST               = 17;
int ACTION_TAUNT              = 18;
int ACTION_ITEMCASTSPELL      = 19;
int ACTION_COUNTERSPELL       = 31;
int ACTION_HEAL               = 33;
int ACTION_PICKPOCKET         = 34;
int ACTION_FOLLOW             = 35;
int ACTION_WAIT               = 36;
int ACTION_SIT                = 37;
int ACTION_SMITEGOOD          = 40;
int ACTION_KIDAMAGE           = 41;
int ACTION_RANDOMWALK         = 43;

int ACTION_INVALID            = 65535;

int TRAP_BASE_TYPE_MINOR_SPIKE          = 0;
int TRAP_BASE_TYPE_AVERAGE_SPIKE        = 1;
int TRAP_BASE_TYPE_STRONG_SPIKE         = 2;
int TRAP_BASE_TYPE_DEADLY_SPIKE         = 3;
int TRAP_BASE_TYPE_MINOR_HOLY           = 4;
int TRAP_BASE_TYPE_AVERAGE_HOLY         = 5;
int TRAP_BASE_TYPE_STRONG_HOLY          = 6;
int TRAP_BASE_TYPE_DEADLY_HOLY          = 7;
int TRAP_BASE_TYPE_MINOR_TANGLE         = 8;
int TRAP_BASE_TYPE_AVERAGE_TANGLE       = 9;
int TRAP_BASE_TYPE_STRONG_TANGLE        = 10;
int TRAP_BASE_TYPE_DEADLY_TANGLE        = 11;
int TRAP_BASE_TYPE_MINOR_ACID           = 12;
int TRAP_BASE_TYPE_AVERAGE_ACID         = 13;
int TRAP_BASE_TYPE_STRONG_ACID          = 14;
int TRAP_BASE_TYPE_DEADLY_ACID          = 15;
int TRAP_BASE_TYPE_MINOR_FIRE           = 16;
int TRAP_BASE_TYPE_AVERAGE_FIRE         = 17;
int TRAP_BASE_TYPE_STRONG_FIRE          = 18;
int TRAP_BASE_TYPE_DEADLY_FIRE          = 19;
int TRAP_BASE_TYPE_MINOR_ELECTRICAL     = 20;
int TRAP_BASE_TYPE_AVERAGE_ELECTRICAL   = 21;
int TRAP_BASE_TYPE_STRONG_ELECTRICAL    = 22;
int TRAP_BASE_TYPE_DEADLY_ELECTRICAL    = 23;
int TRAP_BASE_TYPE_MINOR_GAS            = 24;
int TRAP_BASE_TYPE_AVERAGE_GAS          = 25;
int TRAP_BASE_TYPE_STRONG_GAS           = 26;
int TRAP_BASE_TYPE_DEADLY_GAS           = 27;
int TRAP_BASE_TYPE_MINOR_FROST          = 28;
int TRAP_BASE_TYPE_AVERAGE_FROST        = 29;
int TRAP_BASE_TYPE_STRONG_FROST         = 30;
int TRAP_BASE_TYPE_DEADLY_FROST         = 31;
int TRAP_BASE_TYPE_MINOR_NEGATIVE       = 32;
int TRAP_BASE_TYPE_AVERAGE_NEGATIVE     = 33;
int TRAP_BASE_TYPE_STRONG_NEGATIVE      = 34;
int TRAP_BASE_TYPE_DEADLY_NEGATIVE      = 35;
int TRAP_BASE_TYPE_MINOR_SONIC          = 36;
int TRAP_BASE_TYPE_AVERAGE_SONIC        = 37;
int TRAP_BASE_TYPE_STRONG_SONIC         = 38;
int TRAP_BASE_TYPE_DEADLY_SONIC         = 39;
int TRAP_BASE_TYPE_MINOR_ACID_SPLASH    = 40;
int TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH  = 41;
int TRAP_BASE_TYPE_STRONG_ACID_SPLASH   = 42;
int TRAP_BASE_TYPE_DEADLY_ACID_SPLASH   = 43;
int TRAP_BASE_TYPE_EPIC_ELECTRICAL      = 44;
int TRAP_BASE_TYPE_EPIC_FIRE            = 45;
int TRAP_BASE_TYPE_EPIC_FROST           = 46;
int TRAP_BASE_TYPE_EPIC_SONIC           = 47;


int TRACK_RURALDAY1         = 1;
int TRACK_RURALDAY2         = 2;
int TRACK_RURALNIGHT        = 3;
int TRACK_FORESTDAY1        = 4;
int TRACK_FORESTDAY2        = 5;
int TRACK_FORESTNIGHT       = 6;
int TRACK_DUNGEON1          = 7;
int TRACK_SEWER             = 8;
int TRACK_MINES1            = 9;
int TRACK_MINES2            = 10;
int TRACK_CRYPT1            = 11;
int TRACK_CRYPT2            = 12;
int TRACK_DESERT_DAY        = 58;
int TRACK_DESERT_NIGHT      = 61;
int TRACK_WINTER_DAY        = 59;
int TRACK_EVILDUNGEON1      = 13;
int TRACK_EVILDUNGEON2      = 14;
int TRACK_CITYSLUMDAY       = 15;
int TRACK_CITYSLUMNIGHT     = 16;
int TRACK_CITYDOCKDAY       = 17;
int TRACK_CITYDOCKNIGHT     = 18;
int TRACK_CITYWEALTHY       = 19;
int TRACK_CITYMARKET        = 20;
int TRACK_CITYNIGHT         = 21;
int TRACK_TAVERN1           = 22;
int TRACK_TAVERN2           = 23;
int TRACK_TAVERN3           = 24;
int TRACK_TAVERN4           = 56;
int TRACK_RICHHOUSE         = 25;
int TRACK_STORE             = 26;
int TRACK_TEMPLEGOOD        = 27;
int TRACK_TEMPLEGOOD2       = 49;
int TRACK_TEMPLEEVIL        = 28;
int TRACK_THEME_NWN         = 29;
int TRACK_THEME_CHAPTER1    = 30;
int TRACK_THEME_CHAPTER2    = 31;
int TRACK_THEME_CHAPTER3    = 32;
int TRACK_THEME_CHAPTER4    = 33;
int TRACK_BATTLE_RURAL1     = 34;
int TRACK_BATTLE_FOREST1    = 35;
int TRACK_BATTLE_FOREST2    = 36;
int TRACK_BATTLE_DUNGEON1   = 37;
int TRACK_BATTLE_DUNGEON2   = 38;
int TRACK_BATTLE_DUNGEON3   = 39;
int TRACK_BATTLE_CITY1      = 40;
int TRACK_BATTLE_CITY2      = 41;
int TRACK_BATTLE_CITY3      = 42;
int TRACK_BATTLE_CITYBOSS   = 43;
int TRACK_BATTLE_FORESTBOSS = 44;
int TRACK_BATTLE_LIZARDBOSS = 45;
int TRACK_BATTLE_DRAGON     = 46;
int TRACK_BATTLE_ARIBETH    = 47;
int TRACK_BATTLE_ENDBOSS    = 48;
int TRACK_BATTLE_DESERT     = 57;
int TRACK_BATTLE_WINTER     = 60;
int TRACK_CASTLE            = 50;
int TRACK_THEME_ARIBETH1    = 51;
int TRACK_THEME_ARIBETH2    = 52;
int TRACK_THEME_GEND        = 53;
int TRACK_THEME_MAUGRIM     = 54;
int TRACK_THEME_MORAG       = 55;
int TRACK_HOTU_THEME        = 62;
int TRACK_HOTU_WATERDEEP      = 63;
int TRACK_HOTU_UNDERMOUNTAIN  = 64;
int TRACK_HOTU_REBELCAMP      = 65;
int TRACK_HOTU_FIREPLANE      = 66;
int TRACK_HOTU_QUEEN          = 67;
int TRACK_HOTU_HELLFROZEOVER  = 68;
int TRACK_HOTU_DRACOLICH      = 69;
int TRACK_HOTU_BATTLE_SMALL   = 70;
int TRACK_HOTU_BATTLE_MED     = 71;
int TRACK_HOTU_BATTLE_LARGE   = 72;
int TRACK_HOTU_BATTLE_HELL    = 73;
int TRACK_HOTU_BATTLE_BOSS1   = 74;
int TRACK_HOTU_BATTLE_BOSS2   = 75;


int STEALTH_MODE_DISABLED   = 0;
int STEALTH_MODE_ACTIVATED  = 1;
int DETECT_MODE_PASSIVE     = 0;
int DETECT_MODE_ACTIVE      = 1;
int DEFENSIVE_CASTING_MODE_DISABLED = 0;
int DEFENSIVE_CASTING_MODE_ACTIVATED= 1;


int  APPEARANCE_TYPE_INVALID = -1;
int  APPEARANCE_TYPE_ALLIP = 186;
int  APPEARANCE_TYPE_ARANEA = 157;
int  APPEARANCE_TYPE_ARCH_TARGET = 200;
int  APPEARANCE_TYPE_ARIBETH = 190;
int  APPEARANCE_TYPE_ASABI_CHIEFTAIN = 353;
int  APPEARANCE_TYPE_ASABI_SHAMAN = 354;
int  APPEARANCE_TYPE_ASABI_WARRIOR = 355;
int  APPEARANCE_TYPE_BADGER = 8;
int  APPEARANCE_TYPE_BADGER_DIRE = 9;
int  APPEARANCE_TYPE_BALOR = 38;
int  APPEARANCE_TYPE_BARTENDER = 234;
int  APPEARANCE_TYPE_BASILISK = 369;
int  APPEARANCE_TYPE_BAT = 10;
int  APPEARANCE_TYPE_BAT_HORROR = 11;
int  APPEARANCE_TYPE_BEAR_BLACK = 12;
int  APPEARANCE_TYPE_BEAR_BROWN = 13;
int  APPEARANCE_TYPE_BEAR_DIRE = 15;
int  APPEARANCE_TYPE_BEAR_KODIAK = 204;
int  APPEARANCE_TYPE_BEAR_POLAR = 14;
int  APPEARANCE_TYPE_BEETLE_FIRE = 18;
int  APPEARANCE_TYPE_BEETLE_SLICER = 17;
int  APPEARANCE_TYPE_BEETLE_STAG = 19;
int  APPEARANCE_TYPE_BEETLE_STINK = 20;
int  APPEARANCE_TYPE_BEGGER = 220;
int  APPEARANCE_TYPE_BLOOD_SAILER = 221;
int  APPEARANCE_TYPE_BOAR = 21;
int  APPEARANCE_TYPE_BOAR_DIRE = 22;
int  APPEARANCE_TYPE_BODAK = 23;
int  APPEARANCE_TYPE_BUGBEAR_A = 29;
int  APPEARANCE_TYPE_BUGBEAR_B = 30;
int  APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_A = 25;
int  APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_B = 26;
int  APPEARANCE_TYPE_BUGBEAR_SHAMAN_A = 27;
int  APPEARANCE_TYPE_BUGBEAR_SHAMAN_B = 28;
int  APPEARANCE_TYPE_BULETTE = 481;
int  APPEARANCE_TYPE_CAT_CAT_DIRE = 95;
int  APPEARANCE_TYPE_CAT_COUGAR = 203;
int  APPEARANCE_TYPE_CAT_CRAG_CAT = 94;
int  APPEARANCE_TYPE_CAT_JAGUAR = 98;
int  APPEARANCE_TYPE_CAT_KRENSHAR = 96;
int  APPEARANCE_TYPE_CAT_LEOPARD = 93;
int  APPEARANCE_TYPE_CAT_LION = 97;
int  APPEARANCE_TYPE_CAT_MPANTHER = 306;
int  APPEARANCE_TYPE_CAT_PANTHER = 202;
int  APPEARANCE_TYPE_CHICKEN = 31;
int  APPEARANCE_TYPE_COCKATRICE = 368;
int  APPEARANCE_TYPE_COMBAT_DUMMY = 201;
int  APPEARANCE_TYPE_CONVICT = 238;
int  APPEARANCE_TYPE_COW = 34;
int  APPEARANCE_TYPE_CULT_MEMBER = 212;
int  APPEARANCE_TYPE_DEER = 35;
int  APPEARANCE_TYPE_DEER_STAG = 37;
int  APPEARANCE_TYPE_DEVIL = 392;
int  APPEARANCE_TYPE_DOG = 176;
int  APPEARANCE_TYPE_DOG_BLINKDOG = 174;
int  APPEARANCE_TYPE_DOG_DIRE_WOLF = 175;
int  APPEARANCE_TYPE_DOG_FENHOUND = 177;
int  APPEARANCE_TYPE_DOG_HELL_HOUND = 179;
int  APPEARANCE_TYPE_DOG_SHADOW_MASTIF = 180;
int  APPEARANCE_TYPE_DOG_WINTER_WOLF = 184;
int  APPEARANCE_TYPE_DOG_WOLF = 181;
int  APPEARANCE_TYPE_DOG_WORG = 185;
int  APPEARANCE_TYPE_DOOM_KNIGHT = 40;
int  APPEARANCE_TYPE_DRAGON_BLACK = 41;
int  APPEARANCE_TYPE_DRAGON_BLUE = 47;
int  APPEARANCE_TYPE_DRAGON_BRASS = 42;
int  APPEARANCE_TYPE_DRAGON_BRONZE = 45;
int  APPEARANCE_TYPE_DRAGON_COPPER = 43;
int  APPEARANCE_TYPE_DRAGON_GOLD = 46;
int  APPEARANCE_TYPE_DRAGON_GREEN = 48;
int  APPEARANCE_TYPE_DRAGON_RED = 49;
int  APPEARANCE_TYPE_DRAGON_SILVER = 44;
int  APPEARANCE_TYPE_DRAGON_WHITE = 50;
int  APPEARANCE_TYPE_DROW_CLERIC = 215;
int  APPEARANCE_TYPE_DROW_FIGHTER = 216;
int  APPEARANCE_TYPE_DRUEGAR_CLERIC = 218;
int  APPEARANCE_TYPE_DRUEGAR_FIGHTER = 217;
int  APPEARANCE_TYPE_DRYAD = 51;
int  APPEARANCE_TYPE_DWARF = 0;
int  APPEARANCE_TYPE_DWARF_NPC_FEMALE = 248;
int  APPEARANCE_TYPE_DWARF_NPC_MALE = 249;
int  APPEARANCE_TYPE_ELEMENTAL_AIR = 52;
int  APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER = 53;
int  APPEARANCE_TYPE_ELEMENTAL_EARTH = 56;
int  APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER = 57;
int  APPEARANCE_TYPE_ELEMENTAL_FIRE = 60;
int  APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER = 61;
int  APPEARANCE_TYPE_ELEMENTAL_WATER = 69;
int  APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER = 68;
int  APPEARANCE_TYPE_ELF = 1;
int  APPEARANCE_TYPE_ELF_NPC_FEMALE = 245;
int  APPEARANCE_TYPE_ELF_NPC_MALE_01 = 246;
int  APPEARANCE_TYPE_ELF_NPC_MALE_02 = 247;
int  APPEARANCE_TYPE_ETTERCAP = 166;
int  APPEARANCE_TYPE_ETTIN = 72;
int  APPEARANCE_TYPE_FAERIE_DRAGON = 374;
int  APPEARANCE_TYPE_FAIRY = 55;
int  APPEARANCE_TYPE_FALCON = 144;
int  APPEARANCE_TYPE_FEMALE_01 = 222;
int  APPEARANCE_TYPE_FEMALE_02 = 223;
int  APPEARANCE_TYPE_FEMALE_03 = 224;
int  APPEARANCE_TYPE_FEMALE_04 = 225;
int  APPEARANCE_TYPE_FORMIAN_MYRMARCH = 362;
int  APPEARANCE_TYPE_FORMIAN_QUEEN = 363;
int  APPEARANCE_TYPE_FORMIAN_WARRIOR = 361;
int  APPEARANCE_TYPE_FORMIAN_WORKER = 360;
int  APPEARANCE_TYPE_GARGOYLE = 73;
int  APPEARANCE_TYPE_GHAST = 74;
int  APPEARANCE_TYPE_GHOUL = 76;
int  APPEARANCE_TYPE_GHOUL_LORD = 77;
int  APPEARANCE_TYPE_GIANT_FIRE = 80;
int  APPEARANCE_TYPE_GIANT_FIRE_FEMALE = 351;
int  APPEARANCE_TYPE_GIANT_FROST = 81;
int  APPEARANCE_TYPE_GIANT_FROST_FEMALE = 350;
int  APPEARANCE_TYPE_GIANT_HILL = 78;
int  APPEARANCE_TYPE_GIANT_MOUNTAIN = 79;
int  APPEARANCE_TYPE_GNOLL_WARRIOR = 388;
int  APPEARANCE_TYPE_GNOLL_WIZ = 389;
int  APPEARANCE_TYPE_GNOME = 2;
int  APPEARANCE_TYPE_GNOME_NPC_FEMALE = 243;
int  APPEARANCE_TYPE_GNOME_NPC_MALE = 244;
int  APPEARANCE_TYPE_GOBLIN_A = 86;
int  APPEARANCE_TYPE_GOBLIN_B = 87;
int  APPEARANCE_TYPE_GOBLIN_CHIEF_A = 82;
int  APPEARANCE_TYPE_GOBLIN_CHIEF_B = 83;
int  APPEARANCE_TYPE_GOBLIN_SHAMAN_A = 84;
int  APPEARANCE_TYPE_GOBLIN_SHAMAN_B = 85;
int  APPEARANCE_TYPE_GOLEM_BONE = 24;
int  APPEARANCE_TYPE_GOLEM_CLAY = 91;
int  APPEARANCE_TYPE_GOLEM_FLESH = 88;
int  APPEARANCE_TYPE_GOLEM_IRON = 89;
int  APPEARANCE_TYPE_GOLEM_STONE = 92;
int  APPEARANCE_TYPE_GORGON = 367;
int  APPEARANCE_TYPE_GRAY_OOZE = 393;
int  APPEARANCE_TYPE_GREY_RENDER = 205;
int  APPEARANCE_TYPE_GYNOSPHINX = 365;
int  APPEARANCE_TYPE_HALFLING = 3;
int  APPEARANCE_TYPE_HALFLING_NPC_FEMALE = 250;
int  APPEARANCE_TYPE_HALFLING_NPC_MALE = 251;
int  APPEARANCE_TYPE_HALF_ELF = 4;
int  APPEARANCE_TYPE_HALF_ORC = 5;
int  APPEARANCE_TYPE_HALF_ORC_NPC_FEMALE = 252;
int  APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01 = 253;
int  APPEARANCE_TYPE_HALF_ORC_NPC_MALE_02 = 254;
int  APPEARANCE_TYPE_HELMED_HORROR = 100;
int  APPEARANCE_TYPE_HEURODIS_LICH = 370;
int  APPEARANCE_TYPE_HOBGOBLIN_WARRIOR = 390;
int  APPEARANCE_TYPE_HOBGOBLIN_WIZARD = 391;
int  APPEARANCE_TYPE_HOOK_HORROR = 102;
int  APPEARANCE_TYPE_HOUSE_GUARD = 219;
int  APPEARANCE_TYPE_HUMAN = 6;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_01 = 255;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_02 = 256;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_03 = 257;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_04 = 258;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_05 = 259;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_06 = 260;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_07 = 261;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_08 = 262;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_09 = 263;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_10 = 264;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_11 = 265;
int  APPEARANCE_TYPE_HUMAN_NPC_FEMALE_12 = 266;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_01 = 267;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_02 = 268;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_03 = 269;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_04 = 270;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_05 = 271;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_06 = 272;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_07 = 273;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_08 = 274;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_09 = 275;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_10 = 276;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_11 = 277;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_12 = 278;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_13 = 279;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_14 = 280;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_15 = 281;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_16 = 282;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_17 = 283;
int  APPEARANCE_TYPE_HUMAN_NPC_MALE_18 = 284;
int  APPEARANCE_TYPE_IMP = 105;
int  APPEARANCE_TYPE_INN_KEEPER = 233;
int  APPEARANCE_TYPE_INTELLECT_DEVOURER = 117;
int  APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE = 298;
int  APPEARANCE_TYPE_INVISIBLE_STALKER = 64;
int  APPEARANCE_TYPE_KID_FEMALE = 242;
int  APPEARANCE_TYPE_KID_MALE = 241;
int  APPEARANCE_TYPE_KOBOLD_A = 302;
int  APPEARANCE_TYPE_KOBOLD_B = 305;
int  APPEARANCE_TYPE_KOBOLD_CHIEF_A = 300;
int  APPEARANCE_TYPE_KOBOLD_CHIEF_B = 303;
int  APPEARANCE_TYPE_KOBOLD_SHAMAN_A = 301;
int  APPEARANCE_TYPE_KOBOLD_SHAMAN_B = 304;
int  APPEARANCE_TYPE_LANTERN_ARCHON = 103;
int  APPEARANCE_TYPE_LICH = 39;
int  APPEARANCE_TYPE_LIZARDFOLK_A = 134;
int  APPEARANCE_TYPE_LIZARDFOLK_B = 135;
int  APPEARANCE_TYPE_LIZARDFOLK_SHAMAN_A = 132;
int  APPEARANCE_TYPE_LIZARDFOLK_SHAMAN_B = 133;
int  APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_A = 130;
int  APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_B = 131;
int  APPEARANCE_TYPE_LUSKAN_GUARD = 211;
int  APPEARANCE_TYPE_MALE_01 = 226;
int  APPEARANCE_TYPE_MALE_02 = 227;
int  APPEARANCE_TYPE_MALE_03 = 228;
int  APPEARANCE_TYPE_MALE_04 = 229;
int  APPEARANCE_TYPE_MALE_05 = 230;
int  APPEARANCE_TYPE_MANTICORE = 366;
int  APPEARANCE_TYPE_MEDUSA = 352;
int  APPEARANCE_TYPE_MEPHIT_AIR = 106;
int  APPEARANCE_TYPE_MEPHIT_DUST = 107;
int  APPEARANCE_TYPE_MEPHIT_EARTH = 108;
int  APPEARANCE_TYPE_MEPHIT_FIRE = 109;
int  APPEARANCE_TYPE_MEPHIT_ICE = 110;
int  APPEARANCE_TYPE_MEPHIT_MAGMA = 114;
int  APPEARANCE_TYPE_MEPHIT_OOZE = 112;
int  APPEARANCE_TYPE_MEPHIT_SALT = 111;
int  APPEARANCE_TYPE_MEPHIT_STEAM = 113;
int  APPEARANCE_TYPE_MEPHIT_WATER = 115;
int  APPEARANCE_TYPE_MINOGON = 119;
int  APPEARANCE_TYPE_MINOTAUR = 120;
int  APPEARANCE_TYPE_MINOTAUR_CHIEFTAIN = 121;
int  APPEARANCE_TYPE_MINOTAUR_SHAMAN = 122;
int  APPEARANCE_TYPE_MOHRG = 123;
int  APPEARANCE_TYPE_MUMMY_COMMON = 58;
int  APPEARANCE_TYPE_MUMMY_FIGHTER_2 = 59;
int  APPEARANCE_TYPE_MUMMY_GREATER = 124;
int  APPEARANCE_TYPE_MUMMY_WARRIOR = 125;
int  APPEARANCE_TYPE_NWN_AARIN = 188;
int  APPEARANCE_TYPE_NWN_ARIBETH_EVIL = 189;
int  APPEARANCE_TYPE_NWN_HAEDRALINE = 191;
int  APPEARANCE_TYPE_NWN_MAUGRIM = 193;
int  APPEARANCE_TYPE_NWN_MORAG = 192;
int  APPEARANCE_TYPE_NWN_NASHER = 296;
int  APPEARANCE_TYPE_NWN_SEDOS = 297;
int  APPEARANCE_TYPE_NW_MILITIA_MEMBER = 210;
int  APPEARANCE_TYPE_NYMPH = 126;
int  APPEARANCE_TYPE_OCHRE_JELLY_LARGE = 394;
int  APPEARANCE_TYPE_OCHRE_JELLY_MEDIUM = 396;
int  APPEARANCE_TYPE_OCHRE_JELLY_SMALL = 398;
int  APPEARANCE_TYPE_OGRE = 127;
int  APPEARANCE_TYPE_OGREB = 207;
int  APPEARANCE_TYPE_OGRE_CHIEFTAIN = 128;
int  APPEARANCE_TYPE_OGRE_CHIEFTAINB = 208;
int  APPEARANCE_TYPE_OGRE_MAGE = 129;
int  APPEARANCE_TYPE_OGRE_MAGEB = 209;
int  APPEARANCE_TYPE_OLD_MAN = 239;
int  APPEARANCE_TYPE_OLD_WOMAN = 240;
int  APPEARANCE_TYPE_ORC_A = 140;
int  APPEARANCE_TYPE_ORC_B = 141;
int  APPEARANCE_TYPE_ORC_CHIEFTAIN_A = 136;
int  APPEARANCE_TYPE_ORC_CHIEFTAIN_B = 137;
int  APPEARANCE_TYPE_ORC_SHAMAN_A = 138;
int  APPEARANCE_TYPE_ORC_SHAMAN_B = 139;
int  APPEARANCE_TYPE_OX = 142;
int  APPEARANCE_TYPE_PARROT = 7;
int  APPEARANCE_TYPE_PENGUIN = 206;
int  APPEARANCE_TYPE_PLAGUE_VICTIM = 231;
int  APPEARANCE_TYPE_PROSTITUTE_01 = 236;
int  APPEARANCE_TYPE_PROSTITUTE_02 = 237;
int  APPEARANCE_TYPE_PSEUDODRAGON = 375;
int  APPEARANCE_TYPE_QUASIT = 104;
int  APPEARANCE_TYPE_RAKSHASA_BEAR_MALE = 294;
int  APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE = 290;
int  APPEARANCE_TYPE_RAKSHASA_TIGER_MALE = 293;
int  APPEARANCE_TYPE_RAKSHASA_WOLF_MALE = 295;
int  APPEARANCE_TYPE_RAT = 386;
int  APPEARANCE_TYPE_RAT_DIRE = 387;
int  APPEARANCE_TYPE_RAVEN = 145;
int  APPEARANCE_TYPE_SAHUAGIN = 65;
int  APPEARANCE_TYPE_SAHUAGIN_LEADER = 66;
int  APPEARANCE_TYPE_SAHUAGIN_CLERIC = 67;
int  APPEARANCE_TYPE_SEAGULL_FLYING = 291;
int  APPEARANCE_TYPE_SEAGULL_WALKING = 292;
int  APPEARANCE_TYPE_SHADOW = 146;
int  APPEARANCE_TYPE_SHADOW_FIEND = 147;
int  APPEARANCE_TYPE_SHARK_MAKO = 447;
int  APPEARANCE_TYPE_SHARK_HAMMERHEAD = 448;
int  APPEARANCE_TYPE_SHARK_GOBLIN = 449;
int  APPEARANCE_TYPE_SHIELD_GUARDIAN = 90;
int  APPEARANCE_TYPE_SHOP_KEEPER = 232;
int  APPEARANCE_TYPE_SKELETAL_DEVOURER = 36;
int  APPEARANCE_TYPE_SKELETON_CHIEFTAIN = 182;
int  APPEARANCE_TYPE_SKELETON_COMMON = 63;
int  APPEARANCE_TYPE_SKELETON_MAGE = 148;
int  APPEARANCE_TYPE_SKELETON_PRIEST = 62;
int  APPEARANCE_TYPE_SKELETON_WARRIOR = 150;
int  APPEARANCE_TYPE_SKELETON_WARRIOR_1 = 70;
int  APPEARANCE_TYPE_SKELETON_WARRIOR_2 = 71;
int  APPEARANCE_TYPE_SLAAD_BLUE = 151;
int  APPEARANCE_TYPE_SLAAD_DEATH = 152;
int  APPEARANCE_TYPE_SLAAD_GRAY = 153;
int  APPEARANCE_TYPE_SLAAD_GREEN = 154;
int  APPEARANCE_TYPE_SLAAD_RED = 155;
int  APPEARANCE_TYPE_SPECTRE = 156;
int  APPEARANCE_TYPE_SPHINX = 364;
int  APPEARANCE_TYPE_SPIDER_DIRE = 158;
int  APPEARANCE_TYPE_SPIDER_GIANT = 159;
int  APPEARANCE_TYPE_SPIDER_PHASE = 160;
int  APPEARANCE_TYPE_SPIDER_SWORD = 161;
int  APPEARANCE_TYPE_SPIDER_WRAITH = 162;
int  APPEARANCE_TYPE_STINGER = 356;
int  APPEARANCE_TYPE_STINGER_CHIEFTAIN = 358;
int  APPEARANCE_TYPE_STINGER_MAGE = 359;
int  APPEARANCE_TYPE_STINGER_WARRIOR = 357;
int  APPEARANCE_TYPE_SUCCUBUS = 163;
int  APPEARANCE_TYPE_TROGLODYTE = 451;
int  APPEARANCE_TYPE_TROGLODYTE_WARRIOR = 452;
int  APPEARANCE_TYPE_TROGLODYTE_CLERIC = 453;
int  APPEARANCE_TYPE_TROLL = 167;
int  APPEARANCE_TYPE_TROLL_CHIEFTAIN = 164;
int  APPEARANCE_TYPE_TROLL_SHAMAN = 165;
int  APPEARANCE_TYPE_UMBERHULK = 168;
int  APPEARANCE_TYPE_UTHGARD_ELK_TRIBE = 213;
int  APPEARANCE_TYPE_UTHGARD_TIGER_TRIBE = 214;
int  APPEARANCE_TYPE_VAMPIRE_FEMALE = 288;
int  APPEARANCE_TYPE_VAMPIRE_MALE = 289;
int  APPEARANCE_TYPE_VROCK = 101;
int  APPEARANCE_TYPE_WAITRESS = 235;
int  APPEARANCE_TYPE_WAR_DEVOURER = 54;
int  APPEARANCE_TYPE_WERECAT = 99;
int  APPEARANCE_TYPE_WERERAT = 170;
int  APPEARANCE_TYPE_WEREWOLF = 171;
int  APPEARANCE_TYPE_WIGHT = 172;
int  APPEARANCE_TYPE_WILL_O_WISP = 116;
int  APPEARANCE_TYPE_WRAITH = 187;
int  APPEARANCE_TYPE_WYRMLING_BLACK = 378;
int  APPEARANCE_TYPE_WYRMLING_BLUE = 377;
int  APPEARANCE_TYPE_WYRMLING_BRASS = 381;
int  APPEARANCE_TYPE_WYRMLING_BRONZE = 383;
int  APPEARANCE_TYPE_WYRMLING_COPPER = 382;
int  APPEARANCE_TYPE_WYRMLING_GOLD = 385;
int  APPEARANCE_TYPE_WYRMLING_GREEN = 379;
int  APPEARANCE_TYPE_WYRMLING_RED = 376;
int  APPEARANCE_TYPE_WYRMLING_SILVER = 384;
int  APPEARANCE_TYPE_WYRMLING_WHITE = 380;
int  APPEARANCE_TYPE_YUAN_TI = 285;
int  APPEARANCE_TYPE_YUAN_TI_CHIEFTEN = 286;
int  APPEARANCE_TYPE_YUAN_TI_WIZARD = 287;
int  APPEARANCE_TYPE_ZOMBIE = 198;
int  APPEARANCE_TYPE_ZOMBIE_ROTTING = 195;
int  APPEARANCE_TYPE_ZOMBIE_TYRANT_FOG = 199;
int  APPEARANCE_TYPE_ZOMBIE_WARRIOR_1 = 196;
int  APPEARANCE_TYPE_ZOMBIE_WARRIOR_2 = 197;
int  APPEARANCE_TYPE_BEHOLDER = 401;
int  APPEARANCE_TYPE_BEHOLDER_MAGE = 402;
int  APPEARANCE_TYPE_BEHOLDER_EYEBALL = 403;
int  APPEARANCE_TYPE_MEPHISTO_BIG = 404;
int  APPEARANCE_TYPE_DRACOLICH = 405;
int  APPEARANCE_TYPE_DRIDER = 406;
int  APPEARANCE_TYPE_DRIDER_CHIEF = 407;
int  APPEARANCE_TYPE_DROW_SLAVE = 408;
int  APPEARANCE_TYPE_DROW_WIZARD = 409;
int  APPEARANCE_TYPE_DROW_MATRON = 410;
int  APPEARANCE_TYPE_DUERGAR_SLAVE = 411;
int  APPEARANCE_TYPE_DUERGAR_CHIEF = 412;
int  APPEARANCE_TYPE_MINDFLAYER = 413;
int  APPEARANCE_TYPE_MINDFLAYER_2 = 414;
int  APPEARANCE_TYPE_MINDFLAYER_ALHOON = 415;
int  APPEARANCE_TYPE_DEEP_ROTHE = 416;
int  APPEARANCE_TYPE_DRAGON_SHADOW = 418;
int  APPEARANCE_TYPE_HARPY = 419;
int  APPEARANCE_TYPE_GOLEM_MITHRAL = 420;
int  APPEARANCE_TYPE_GOLEM_ADAMANTIUM = 421;
int  APPEARANCE_TYPE_SPIDER_DEMON = 422;
int  APPEARANCE_TYPE_SVIRF_MALE = 423;
int  APPEARANCE_TYPE_SVIRF_FEMALE = 424;
int  APPEARANCE_TYPE_DRAGON_PRIS = 425;
int  APPEARANCE_TYPE_SLAAD_BLACK = 426;
int  APPEARANCE_TYPE_SLAAD_WHITE = 427;
int  APPEARANCE_TYPE_AZER_MALE = 428;
int  APPEARANCE_TYPE_AZER_FEMALE = 429;
int  APPEARANCE_TYPE_DEMI_LICH = 430;
int  APPEARANCE_TYPE_OBJECT_CHAIR = 431;
int  APPEARANCE_TYPE_OBJECT_TABLE = 432;
int  APPEARANCE_TYPE_OBJECT_CANDLE = 433;
int  APPEARANCE_TYPE_OBJECT_CHEST = 434;
int  APPEARANCE_TYPE_OBJECT_WHITE = 435;
int  APPEARANCE_TYPE_OBJECT_BLUE = 436;
int  APPEARANCE_TYPE_OBJECT_CYAN = 437;
int  APPEARANCE_TYPE_OBJECT_GREEN = 438;
int  APPEARANCE_TYPE_OBJECT_YELLOW = 439;
int  APPEARANCE_TYPE_OBJECT_ORANGE = 440;
int  APPEARANCE_TYPE_OBJECT_RED = 441;
int  APPEARANCE_TYPE_OBJECT_PURPLE = 442;
int  APPEARANCE_TYPE_OBJECT_FLAME_SMALL = 443;
int  APPEARANCE_TYPE_OBJECT_FLAME_MEDIUM = 444;
int  APPEARANCE_TYPE_OBJECT_FLAME_LARGE = 445;
int  APPEARANCE_TYPE_DRIDER_FEMALE = 446;
int  APPEARANCE_TYPE_SEA_HAG = 454;
int  APPEARANCE_TYPE_GOLEM_DEMONFLESH = 468;
int  APPEARANCE_TYPE_ANIMATED_CHEST = 469;
int  APPEARANCE_TYPE_GELATINOUS_CUBE = 470;
int  APPEARANCE_TYPE_MEPHISTO_NORM = 471;
int  APPEARANCE_TYPE_BEHOLDER_MOTHER = 472;
int  APPEARANCE_TYPE_OBJECT_BOAT = 473;
int  APPEARANCE_TYPE_DWARF_GOLEM = 474;
int  APPEARANCE_TYPE_DWARF_HALFORC = 475;
int  APPEARANCE_TYPE_DROW_WARRIOR_1 = 476;
int  APPEARANCE_TYPE_DROW_WARRIOR_2 = 477;
int  APPEARANCE_TYPE_DROW_FEMALE_1 = 478;
int  APPEARANCE_TYPE_DROW_FEMALE_2 = 479;
int  APPEARANCE_TYPE_DROW_WARRIOR_3 = 480;

int PHENOTYPE_NORMAL = 0;
int PHENOTYPE_BIG    = 2;
int PHENOTYPE_CUSTOM1 = 3;
int PHENOTYPE_CUSTOM2 = 4;
int PHENOTYPE_CUSTOM3 = 5;
int PHENOTYPE_CUSTOM4 = 6;
int PHENOTYPE_CUSTOM5 = 7;
int PHENOTYPE_CUSTOM6 = 8;
int PHENOTYPE_CUSTOM7 = 9;
int PHENOTYPE_CUSTOM8 = 10;
int PHENOTYPE_CUSTOM9 = 11;
int PHENOTYPE_CUSTOM10 = 12;
int PHENOTYPE_CUSTOM11 = 13;
int PHENOTYPE_CUSTOM12 = 14;
int PHENOTYPE_CUSTOM13 = 15;
int PHENOTYPE_CUSTOM14 = 16;
int PHENOTYPE_CUSTOM15 = 17;
int PHENOTYPE_CUSTOM16 = 18;
int PHENOTYPE_CUSTOM17 = 19;
int PHENOTYPE_CUSTOM18 = 20;

int CAMERA_TRANSITION_TYPE_SNAP = 0;
int CAMERA_TRANSITION_TYPE_CRAWL = 2;
int CAMERA_TRANSITION_TYPE_VERY_SLOW = 5;
int CAMERA_TRANSITION_TYPE_SLOW = 20;
int CAMERA_TRANSITION_TYPE_MEDIUM = 40;
int CAMERA_TRANSITION_TYPE_FAST = 70;
int CAMERA_TRANSITION_TYPE_VERY_FAST = 100;

float FADE_SPEED_SLOWEST = 0.003;
float FADE_SPEED_SLOW = 0.005;
float FADE_SPEED_MEDIUM = 0.01;
float FADE_SPEED_FAST = 0.017;
float FADE_SPEED_FASTEST = 0.25;

int EVENT_HEARTBEAT =  1001;
int EVENT_PERCEIVE = 1002;
int EVENT_END_COMBAT_ROUND = 1003;
int EVENT_DIALOGUE = 1004;
int EVENT_ATTACKED = 1005;
int EVENT_DAMAGED = 1006;
int EVENT_DISTURBED = 1008;
int EVENT_SPELL_CAST_AT = 1011;

int AI_LEVEL_INVALID = -1;
int AI_LEVEL_DEFAULT = -1;
int AI_LEVEL_VERY_LOW = 0;
int AI_LEVEL_LOW = 1;
int AI_LEVEL_NORMAL = 2;
int AI_LEVEL_HIGH = 3;
int AI_LEVEL_VERY_HIGH = 4;

int AREA_INVALID = -1;
int AREA_NATURAL = 1;
int AREA_ARTIFICIAL = 0;
int AREA_ABOVEGROUND = 1;
int AREA_UNDERGROUND = 0;

int AREA_HEIGHT = 0;
int AREA_WIDTH  = 1;

int PORTRAIT_INVALID = 65535;

int USE_CREATURE_LEVEL = 0;


// The following is all the item property constants...
int IP_CONST_ABILITY_STR                        = 0;
int IP_CONST_ABILITY_DEX                        = 1;
int IP_CONST_ABILITY_CON                        = 2;
int IP_CONST_ABILITY_INT                        = 3;
int IP_CONST_ABILITY_WIS                        = 4;
int IP_CONST_ABILITY_CHA                        = 5;
int IP_CONST_ACMODIFIERTYPE_DODGE               = 0;
int IP_CONST_ACMODIFIERTYPE_NATURAL             = 1;
int IP_CONST_ACMODIFIERTYPE_ARMOR               = 2;
int IP_CONST_ACMODIFIERTYPE_SHIELD              = 3;
int IP_CONST_ACMODIFIERTYPE_DEFLECTION          = 4;
int IP_CONST_ADDITIONAL_UNKNOWN                 = 0;
int IP_CONST_ADDITIONAL_CURSED                  = 1;
int IP_CONST_ALIGNMENTGROUP_ALL                 = 0;
int IP_CONST_ALIGNMENTGROUP_NEUTRAL             = 1;
int IP_CONST_ALIGNMENTGROUP_LAWFUL              = 2;
int IP_CONST_ALIGNMENTGROUP_CHAOTIC             = 3;
int IP_CONST_ALIGNMENTGROUP_GOOD                = 4;
int IP_CONST_ALIGNMENTGROUP_EVIL                = 5;
int IP_CONST_ALIGNMENT_LG                       = 0;
int IP_CONST_ALIGNMENT_LN                       = 1;
int IP_CONST_ALIGNMENT_LE                       = 2;
int IP_CONST_ALIGNMENT_NG                       = 3;
int IP_CONST_ALIGNMENT_TN                       = 4;
int IP_CONST_ALIGNMENT_NE                       = 5;
int IP_CONST_ALIGNMENT_CG                       = 6;
int IP_CONST_ALIGNMENT_CN                       = 7;
int IP_CONST_ALIGNMENT_CE                       = 8;
int IP_CONST_RACIALTYPE_DWARF                   = 0;
int IP_CONST_RACIALTYPE_ELF                     = 1;
int IP_CONST_RACIALTYPE_GNOME                   = 2;
int IP_CONST_RACIALTYPE_HALFLING                = 3;
int IP_CONST_RACIALTYPE_HALFELF                 = 4;
int IP_CONST_RACIALTYPE_HALFORC                 = 5;
int IP_CONST_RACIALTYPE_HUMAN                   = 6;
int IP_CONST_RACIALTYPE_ABERRATION              = 7;
int IP_CONST_RACIALTYPE_ANIMAL                  = 8;
int IP_CONST_RACIALTYPE_BEAST                   = 9;
int IP_CONST_RACIALTYPE_CONSTRUCT               = 10;
int IP_CONST_RACIALTYPE_DRAGON                  = 11;
int IP_CONST_RACIALTYPE_HUMANOID_GOBLINOID      = 12;
int IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS      = 13;
int IP_CONST_RACIALTYPE_HUMANOID_ORC            = 14;
int IP_CONST_RACIALTYPE_HUMANOID_REPTILIAN      = 15;
int IP_CONST_RACIALTYPE_ELEMENTAL               = 16;
int IP_CONST_RACIALTYPE_FEY                     = 17;
int IP_CONST_RACIALTYPE_GIANT                   = 18;
int IP_CONST_RACIALTYPE_MAGICAL_BEAST           = 19;
int IP_CONST_RACIALTYPE_OUTSIDER                = 20;
int IP_CONST_RACIALTYPE_SHAPECHANGER            = 23;
int IP_CONST_RACIALTYPE_UNDEAD                  = 24;
int IP_CONST_RACIALTYPE_VERMIN                  = 25;
int IP_CONST_UNLIMITEDAMMO_BASIC                = 1;
int IP_CONST_UNLIMITEDAMMO_1D6FIRE              = 2;
int IP_CONST_UNLIMITEDAMMO_1D6COLD              = 3;
int IP_CONST_UNLIMITEDAMMO_1D6LIGHT             = 4;
int IP_CONST_UNLIMITEDAMMO_PLUS1                = 11;
int IP_CONST_UNLIMITEDAMMO_PLUS2                = 12;
int IP_CONST_UNLIMITEDAMMO_PLUS3                = 13;
int IP_CONST_UNLIMITEDAMMO_PLUS4                = 14;
int IP_CONST_UNLIMITEDAMMO_PLUS5                = 15;
int IP_CONST_AMMOTYPE_ARROW                     = 0;
int IP_CONST_AMMOTYPE_BOLT                      = 1;
int IP_CONST_AMMOTYPE_BULLET                    = 2;
int IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE           = 1;
int IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE    = 2;
int IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE    = 3;
int IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE    = 4;
int IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE    = 5;
int IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE     = 6;
int IP_CONST_CASTSPELL_NUMUSES_0_CHARGES_PER_USE    = 7;
int IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY        = 8;
int IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY       = 9;
int IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY       = 10;
int IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY       = 11;
int IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY       = 12;
int IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE        = 13;
int IP_CONST_DAMAGEBONUS_1                      = 1;
int IP_CONST_DAMAGEBONUS_2                      = 2;
int IP_CONST_DAMAGEBONUS_3                      = 3;
int IP_CONST_DAMAGEBONUS_4                      = 4;
int IP_CONST_DAMAGEBONUS_5                      = 5;
int IP_CONST_DAMAGEBONUS_1d4                    = 6;
int IP_CONST_DAMAGEBONUS_1d6                    = 7;
int IP_CONST_DAMAGEBONUS_1d8                    = 8;
int IP_CONST_DAMAGEBONUS_1d10                   = 9;
int IP_CONST_DAMAGEBONUS_2d6                    = 10;
int IP_CONST_DAMAGEBONUS_2d8                = 11;
int IP_CONST_DAMAGEBONUS_2d4                = 12;
int IP_CONST_DAMAGEBONUS_2d10               = 13;
int IP_CONST_DAMAGEBONUS_1d12               = 14;
int IP_CONST_DAMAGEBONUS_2d12               = 15;
int IP_CONST_DAMAGEBONUS_6                  = 16;
int IP_CONST_DAMAGEBONUS_7                  = 17;
int IP_CONST_DAMAGEBONUS_8                  = 18;
int IP_CONST_DAMAGEBONUS_9                  = 19;
int IP_CONST_DAMAGEBONUS_10                 = 20;
int IP_CONST_DAMAGETYPE_BLUDGEONING             = 0;
int IP_CONST_DAMAGETYPE_PIERCING                = 1;
int IP_CONST_DAMAGETYPE_SLASHING                = 2;
int IP_CONST_DAMAGETYPE_SUBDUAL                 = 3;
int IP_CONST_DAMAGETYPE_PHYSICAL                = 4;
int IP_CONST_DAMAGETYPE_MAGICAL                 = 5;
int IP_CONST_DAMAGETYPE_ACID                    = 6;
int IP_CONST_DAMAGETYPE_COLD                    = 7;
int IP_CONST_DAMAGETYPE_DIVINE                  = 8;
int IP_CONST_DAMAGETYPE_ELECTRICAL              = 9;
int IP_CONST_DAMAGETYPE_FIRE                    = 10;
int IP_CONST_DAMAGETYPE_NEGATIVE                = 11;
int IP_CONST_DAMAGETYPE_POSITIVE                = 12;
int IP_CONST_DAMAGETYPE_SONIC                   = 13;
int IP_CONST_DAMAGEIMMUNITY_5_PERCENT           = 1;
int IP_CONST_DAMAGEIMMUNITY_10_PERCENT          = 2;
int IP_CONST_DAMAGEIMMUNITY_25_PERCENT          = 3;
int IP_CONST_DAMAGEIMMUNITY_50_PERCENT          = 4;
int IP_CONST_DAMAGEIMMUNITY_75_PERCENT          = 5;
int IP_CONST_DAMAGEIMMUNITY_90_PERCENT          = 6;
int IP_CONST_DAMAGEIMMUNITY_100_PERCENT         = 7;
int IP_CONST_DAMAGEVULNERABILITY_5_PERCENT      = 1;
int IP_CONST_DAMAGEVULNERABILITY_10_PERCENT     = 2;
int IP_CONST_DAMAGEVULNERABILITY_25_PERCENT     = 3;
int IP_CONST_DAMAGEVULNERABILITY_50_PERCENT     = 4;
int IP_CONST_DAMAGEVULNERABILITY_75_PERCENT     = 5;
int IP_CONST_DAMAGEVULNERABILITY_90_PERCENT     = 6;
int IP_CONST_DAMAGEVULNERABILITY_100_PERCENT    = 7;
int IP_CONST_FEAT_ALERTNESS                     = 0;
int IP_CONST_FEAT_AMBIDEXTROUS                  = 1;
int IP_CONST_FEAT_CLEAVE                        = 2;
int IP_CONST_FEAT_COMBAT_CASTING                = 3;
int IP_CONST_FEAT_DODGE                         = 4;
int IP_CONST_FEAT_EXTRA_TURNING                 = 5;
int IP_CONST_FEAT_KNOCKDOWN                     = 6;
int IP_CONST_FEAT_POINTBLANK                    = 7;
int IP_CONST_FEAT_SPELLFOCUSABJ                 = 8;
int IP_CONST_FEAT_SPELLFOCUSCON                 = 9;
int IP_CONST_FEAT_SPELLFOCUSDIV                 = 10;
int IP_CONST_FEAT_SPELLFOCUSENC                 = 11;
int IP_CONST_FEAT_SPELLFOCUSEVO                 = 12;
int IP_CONST_FEAT_SPELLFOCUSILL                 = 13;
int IP_CONST_FEAT_SPELLFOCUSNEC                 = 14;
int IP_CONST_FEAT_SPELLPENETRATION              = 15;
int IP_CONST_FEAT_POWERATTACK                   = 16;
int IP_CONST_FEAT_TWO_WEAPON_FIGHTING           = 17;
int IP_CONST_FEAT_WEAPSPEUNARM                  = 18;
int IP_CONST_FEAT_WEAPFINESSE                   = 19;
int IP_CONST_FEAT_IMPCRITUNARM                  = 20;
int IP_CONST_FEAT_WEAPON_PROF_EXOTIC            = 21;
int IP_CONST_FEAT_WEAPON_PROF_MARTIAL           = 22;
int IP_CONST_FEAT_WEAPON_PROF_SIMPLE            = 23;
int IP_CONST_FEAT_ARMOR_PROF_HEAVY              = 24;
int IP_CONST_FEAT_ARMOR_PROF_LIGHT              = 25;
int IP_CONST_FEAT_ARMOR_PROF_MEDIUM             = 26;
int IP_CONST_FEAT_MOBILITY                      = 27;
int IP_CONST_FEAT_DISARM                        = 28;
int IP_CONST_FEAT_WHIRLWIND                     = 29;
int IP_CONST_FEAT_RAPID_SHOT                    = 30;
int IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT           = 31;
int IP_CONST_FEAT_SNEAK_ATTACK_1D6              = 32;
int IP_CONST_FEAT_SNEAK_ATTACK_2D6              = 33;
int IP_CONST_FEAT_SNEAK_ATTACK_3D6              = 34;
int IP_CONST_FEAT_SHIELD_PROFICIENCY            = 35;
int IP_CONST_FEAT_USE_POISON                    = 36;
int IP_CONST_FEAT_DISARM_WHIP                   = 37;
int IP_CONST_FEAT_WEAPON_PROF_CREATURE          = 38;
int IP_CONST_FEAT_SNEAK_ATTACK_5D6              = 39;
int IP_CONST_FEAT_PLAYER_TOOL_01                = 53;
int IP_CONST_FEAT_PLAYER_TOOL_02                = 54;
int IP_CONST_FEAT_PLAYER_TOOL_03                = 55;
int IP_CONST_FEAT_PLAYER_TOOL_04                = 56;
int IP_CONST_FEAT_PLAYER_TOOL_05                = 57;
int IP_CONST_FEAT_PLAYER_TOOL_06                = 58;
int IP_CONST_FEAT_PLAYER_TOOL_07                = 59;
int IP_CONST_FEAT_PLAYER_TOOL_08                = 60;
int IP_CONST_FEAT_PLAYER_TOOL_09                = 61;
int IP_CONST_FEAT_PLAYER_TOOL_10                = 62;
int IP_CONST_IMMUNITYMISC_BACKSTAB              = 0;
int IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN      = 1;
int IP_CONST_IMMUNITYMISC_MINDSPELLS            = 2;
int IP_CONST_IMMUNITYMISC_POISON                = 3;
int IP_CONST_IMMUNITYMISC_DISEASE               = 4;
int IP_CONST_IMMUNITYMISC_FEAR                  = 5;
int IP_CONST_IMMUNITYMISC_KNOCKDOWN             = 6;
int IP_CONST_IMMUNITYMISC_PARALYSIS             = 7;
int IP_CONST_IMMUNITYMISC_CRITICAL_HITS         = 8;
int IP_CONST_IMMUNITYMISC_DEATH_MAGIC           = 9;
int IP_CONST_LIGHTBRIGHTNESS_DIM                = 1;
int IP_CONST_LIGHTBRIGHTNESS_LOW                = 2;
int IP_CONST_LIGHTBRIGHTNESS_NORMAL             = 3;
int IP_CONST_LIGHTBRIGHTNESS_BRIGHT             = 4;
int IP_CONST_LIGHTCOLOR_BLUE                    = 0;
int IP_CONST_LIGHTCOLOR_YELLOW                  = 1;
int IP_CONST_LIGHTCOLOR_PURPLE                  = 2;
int IP_CONST_LIGHTCOLOR_RED                     = 3;
int IP_CONST_LIGHTCOLOR_GREEN                   = 4;
int IP_CONST_LIGHTCOLOR_ORANGE                  = 5;
int IP_CONST_LIGHTCOLOR_WHITE                   = 6;
int IP_CONST_MONSTERDAMAGE_1d2                  = 1;
int IP_CONST_MONSTERDAMAGE_1d3                  = 2;
int IP_CONST_MONSTERDAMAGE_1d4                  = 3;
int IP_CONST_MONSTERDAMAGE_2d4                  = 4;
int IP_CONST_MONSTERDAMAGE_3d4                  = 5;
int IP_CONST_MONSTERDAMAGE_4d4                  = 6;
int IP_CONST_MONSTERDAMAGE_5d4                  = 7;
int IP_CONST_MONSTERDAMAGE_1d6                  = 8;
int IP_CONST_MONSTERDAMAGE_2d6                  = 9;
int IP_CONST_MONSTERDAMAGE_3d6                  = 10;
int IP_CONST_MONSTERDAMAGE_4d6                  = 11;
int IP_CONST_MONSTERDAMAGE_5d6                  = 12;
int IP_CONST_MONSTERDAMAGE_6d6                  = 13;
int IP_CONST_MONSTERDAMAGE_7d6                  = 14;
int IP_CONST_MONSTERDAMAGE_8d6                  = 15;
int IP_CONST_MONSTERDAMAGE_9d6                  = 16;
int IP_CONST_MONSTERDAMAGE_10d6                 = 17;
int IP_CONST_MONSTERDAMAGE_1d8                  = 18;
int IP_CONST_MONSTERDAMAGE_2d8                  = 19;
int IP_CONST_MONSTERDAMAGE_3d8                  = 20;
int IP_CONST_MONSTERDAMAGE_4d8                  = 21;
int IP_CONST_MONSTERDAMAGE_5d8                  = 22;
int IP_CONST_MONSTERDAMAGE_6d8                  = 23;
int IP_CONST_MONSTERDAMAGE_7d8                  = 24;
int IP_CONST_MONSTERDAMAGE_8d8                  = 25;
int IP_CONST_MONSTERDAMAGE_9d8                  = 26;
int IP_CONST_MONSTERDAMAGE_10d8                 = 27;
int IP_CONST_MONSTERDAMAGE_1d10                 = 28;
int IP_CONST_MONSTERDAMAGE_2d10                 = 29;
int IP_CONST_MONSTERDAMAGE_3d10                 = 30;
int IP_CONST_MONSTERDAMAGE_4d10                 = 31;
int IP_CONST_MONSTERDAMAGE_5d10                 = 32;
int IP_CONST_MONSTERDAMAGE_6d10                 = 33;
int IP_CONST_MONSTERDAMAGE_7d10                 = 34;
int IP_CONST_MONSTERDAMAGE_8d10                 = 35;
int IP_CONST_MONSTERDAMAGE_9d10                 = 36;
int IP_CONST_MONSTERDAMAGE_10d10                = 37;
int IP_CONST_MONSTERDAMAGE_1d12                 = 38;
int IP_CONST_MONSTERDAMAGE_2d12                 = 39;
int IP_CONST_MONSTERDAMAGE_3d12                 = 40;
int IP_CONST_MONSTERDAMAGE_4d12                 = 41;
int IP_CONST_MONSTERDAMAGE_5d12                 = 42;
int IP_CONST_MONSTERDAMAGE_6d12                 = 43;
int IP_CONST_MONSTERDAMAGE_7d12                 = 44;
int IP_CONST_MONSTERDAMAGE_8d12                 = 45;
int IP_CONST_MONSTERDAMAGE_9d12                 = 46;
int IP_CONST_MONSTERDAMAGE_10d12                = 47;
int IP_CONST_MONSTERDAMAGE_1d20                 = 48;
int IP_CONST_MONSTERDAMAGE_2d20                 = 49;
int IP_CONST_MONSTERDAMAGE_3d20                 = 50;
int IP_CONST_MONSTERDAMAGE_4d20                 = 51;
int IP_CONST_MONSTERDAMAGE_5d20                 = 52;
int IP_CONST_MONSTERDAMAGE_6d20                 = 53;
int IP_CONST_MONSTERDAMAGE_7d20                 = 54;
int IP_CONST_MONSTERDAMAGE_8d20                 = 55;
int IP_CONST_MONSTERDAMAGE_9d20                 = 56;
int IP_CONST_MONSTERDAMAGE_10d20                = 57;
int IP_CONST_ONMONSTERHIT_ABILITYDRAIN          = 0;
int IP_CONST_ONMONSTERHIT_CONFUSION             = 1;
int IP_CONST_ONMONSTERHIT_DISEASE               = 2;
int IP_CONST_ONMONSTERHIT_DOOM                  = 3;
int IP_CONST_ONMONSTERHIT_FEAR                  = 4;
int IP_CONST_ONMONSTERHIT_LEVELDRAIN            = 5;
int IP_CONST_ONMONSTERHIT_POISON                = 6;
int IP_CONST_ONMONSTERHIT_SLOW                  = 7;
int IP_CONST_ONMONSTERHIT_STUN                  = 8;
int IP_CONST_ONMONSTERHIT_WOUNDING              = 9;
int IP_CONST_ONHIT_SLEEP                        = 0;
int IP_CONST_ONHIT_STUN                         = 1;
int IP_CONST_ONHIT_HOLD                         = 2;
int IP_CONST_ONHIT_CONFUSION                    = 3;
int IP_CONST_ONHIT_DAZE                         = 5;
int IP_CONST_ONHIT_DOOM                         = 6;
int IP_CONST_ONHIT_FEAR                         = 7;
int IP_CONST_ONHIT_KNOCK                        = 8;
int IP_CONST_ONHIT_SLOW                         = 9;
int IP_CONST_ONHIT_LESSERDISPEL                 = 10;
int IP_CONST_ONHIT_DISPELMAGIC                  = 11;
int IP_CONST_ONHIT_GREATERDISPEL                = 12;
int IP_CONST_ONHIT_MORDSDISJUNCTION             = 13;
int IP_CONST_ONHIT_SILENCE                      = 14;
int IP_CONST_ONHIT_DEAFNESS                     = 15;
int IP_CONST_ONHIT_BLINDNESS                    = 16;
int IP_CONST_ONHIT_LEVELDRAIN                   = 17;
int IP_CONST_ONHIT_ABILITYDRAIN                 = 18;
int IP_CONST_ONHIT_ITEMPOISON                   = 19;
int IP_CONST_ONHIT_DISEASE                      = 20;
int IP_CONST_ONHIT_SLAYRACE                     = 21;
int IP_CONST_ONHIT_SLAYALIGNMENTGROUP           = 22;
int IP_CONST_ONHIT_SLAYALIGNMENT                = 23;
int IP_CONST_ONHIT_VORPAL                       = 24;
int IP_CONST_ONHIT_WOUNDING                     = 25;
int IP_CONST_ONHIT_SAVEDC_14                    = 0;
int IP_CONST_ONHIT_SAVEDC_16                    = 1;
int IP_CONST_ONHIT_SAVEDC_18                    = 2;
int IP_CONST_ONHIT_SAVEDC_20                    = 3;
int IP_CONST_ONHIT_SAVEDC_22                    = 4;
int IP_CONST_ONHIT_SAVEDC_24                    = 5;
int IP_CONST_ONHIT_SAVEDC_26                    = 6;
int IP_CONST_ONHIT_DURATION_5_PERCENT_5_ROUNDS  = 0;
int IP_CONST_ONHIT_DURATION_10_PERCENT_4_ROUNDS = 1;
int IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS = 2;
int IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS = 3;
int IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND  = 4;

int IP_CONST_ONHIT_CASTSPELL_ACID_FOG                           = 0;
int IP_CONST_ONHIT_CASTSPELL_BESTOW_CURSE                       = 1;
int IP_CONST_ONHIT_CASTSPELL_BLADE_BARRIER                      = 2;
int IP_CONST_ONHIT_CASTSPELL_BLINDNESS_AND_DEAFNESS             = 3;
int IP_CONST_ONHIT_CASTSPELL_CALL_LIGHTNING                     = 4;
int IP_CONST_ONHIT_CASTSPELL_CHAIN_LIGHTNING                    = 5;
int IP_CONST_ONHIT_CASTSPELL_CLOUDKILL                          = 6;
int IP_CONST_ONHIT_CASTSPELL_CONFUSION                          = 7;
int IP_CONST_ONHIT_CASTSPELL_CONTAGION                          = 8;
int IP_CONST_ONHIT_CASTSPELL_DARKNESS                           = 9;
int IP_CONST_ONHIT_CASTSPELL_DAZE                               = 10;
int IP_CONST_ONHIT_CASTSPELL_DELAYED_BLAST_FIREBALL             = 11;
int IP_CONST_ONHIT_CASTSPELL_DISMISSAL                          = 12;
int IP_CONST_ONHIT_CASTSPELL_DISPEL_MAGIC                       = 13;
int IP_CONST_ONHIT_CASTSPELL_DOOM                               = 14;
int IP_CONST_ONHIT_CASTSPELL_ENERGY_DRAIN                       = 15;
int IP_CONST_ONHIT_CASTSPELL_ENERVATION                         = 16;
int IP_CONST_ONHIT_CASTSPELL_ENTANGLE                           = 17;
int IP_CONST_ONHIT_CASTSPELL_FEAR                               = 18;
int IP_CONST_ONHIT_CASTSPELL_FEEBLEMIND                         = 19;
int IP_CONST_ONHIT_CASTSPELL_FIRE_STORM                         = 20;
int IP_CONST_ONHIT_CASTSPELL_FIREBALL                           = 21;
int IP_CONST_ONHIT_CASTSPELL_FLAME_LASH                         = 22;
int IP_CONST_ONHIT_CASTSPELL_FLAME_STRIKE                       = 23;
int IP_CONST_ONHIT_CASTSPELL_GHOUL_TOUCH                        = 24;
int IP_CONST_ONHIT_CASTSPELL_GREASE                             = 25;
int IP_CONST_ONHIT_CASTSPELL_GREATER_DISPELLING                 = 26;
int IP_CONST_ONHIT_CASTSPELL_GREATER_SPELL_BREACH               = 27;
int IP_CONST_ONHIT_CASTSPELL_GUST_OF_WIND                       = 28;
int IP_CONST_ONHIT_CASTSPELL_HAMMER_OF_THE_GODS                 = 29;
int IP_CONST_ONHIT_CASTSPELL_HARM                               = 30;
int IP_CONST_ONHIT_CASTSPELL_HOLD_ANIMAL                        = 31;
int IP_CONST_ONHIT_CASTSPELL_HOLD_MONSTER                       = 32;
int IP_CONST_ONHIT_CASTSPELL_HOLD_PERSON                        = 33;
int IP_CONST_ONHIT_CASTSPELL_IMPLOSION                          = 34;
int IP_CONST_ONHIT_CASTSPELL_INCENDIARY_CLOUD                   = 35;
int IP_CONST_ONHIT_CASTSPELL_LESSER_DISPEL                      = 36;
int IP_CONST_ONHIT_CASTSPELL_LESSER_SPELL_BREACH                = 38;
int IP_CONST_ONHIT_CASTSPELL_LIGHT                              = 40;
int IP_CONST_ONHIT_CASTSPELL_LIGHTNING_BOLT                     = 41;
int IP_CONST_ONHIT_CASTSPELL_MAGIC_MISSILE                      = 42;
int IP_CONST_ONHIT_CASTSPELL_MASS_BLINDNESS_AND_DEAFNESS        = 43;
int IP_CONST_ONHIT_CASTSPELL_MASS_CHARM                         = 44;
int IP_CONST_ONHIT_CASTSPELL_MELFS_ACID_ARROW                   = 45;
int IP_CONST_ONHIT_CASTSPELL_METEOR_SWARM                       = 46;
int IP_CONST_ONHIT_CASTSPELL_MIND_FOG                           = 47;
int IP_CONST_ONHIT_CASTSPELL_PHANTASMAL_KILLER                  = 49;
int IP_CONST_ONHIT_CASTSPELL_POISON                             = 50;
int IP_CONST_ONHIT_CASTSPELL_POWER_WORD_KILL                    = 51;
int IP_CONST_ONHIT_CASTSPELL_POWER_WORD_STUN                    = 52;

int IP_CONST_ONHIT_CASTSPELL_SCARE                              = 54;
int IP_CONST_ONHIT_CASTSPELL_SEARING_LIGHT                      = 55;
int IP_CONST_ONHIT_CASTSPELL_SILENCE                            = 56;
int IP_CONST_ONHIT_CASTSPELL_SLAY_LIVING                        = 57;
int IP_CONST_ONHIT_CASTSPELL_SLEEP                              = 58;
int IP_CONST_ONHIT_CASTSPELL_SLOW                               = 59;
int IP_CONST_ONHIT_CASTSPELL_SOUND_BURST                        = 60;
int IP_CONST_ONHIT_CASTSPELL_STINKING_CLOUD                     = 61;

int IP_CONST_ONHIT_CASTSPELL_STORM_OF_VENGEANCE                 = 63;
int IP_CONST_ONHIT_CASTSPELL_SUNBEAM                            = 64;
int IP_CONST_ONHIT_CASTSPELL_VAMPIRIC_TOUCH                     = 65;
int IP_CONST_ONHIT_CASTSPELL_WAIL_OF_THE_BANSHEE                = 66;
int IP_CONST_ONHIT_CASTSPELL_WALL_OF_FIRE                       = 67;
int IP_CONST_ONHIT_CASTSPELL_WEB                                = 68;
int IP_CONST_ONHIT_CASTSPELL_WEIRD                              = 69;
int IP_CONST_ONHIT_CASTSPELL_WORD_OF_FAITH                      = 70;

int IP_CONST_ONHIT_CASTSPELL_CREEPING_DOOM                      = 72;
int IP_CONST_ONHIT_CASTSPELL_DESTRUCTION                        = 73;
int IP_CONST_ONHIT_CASTSPELL_HORRID_WILTING                     = 74;
int IP_CONST_ONHIT_CASTSPELL_ICE_STORM                          = 75;
int IP_CONST_ONHIT_CASTSPELL_NEGATIVE_ENERGY_BURST              = 76;
int IP_CONST_ONHIT_CASTSPELL_EVARDS_BLACK_TENTACLES             = 77;
int IP_CONST_ONHIT_CASTSPELL_ACTIVATE_ITEM                      = 78;
int IP_CONST_ONHIT_CASTSPELL_FLARE                              = 79;
int IP_CONST_ONHIT_CASTSPELL_BOMBARDMENT                        = 80;
int IP_CONST_ONHIT_CASTSPELL_ACID_SPLASH                        = 81;
int IP_CONST_ONHIT_CASTSPELL_QUILLFIRE                          = 82;
int IP_CONST_ONHIT_CASTSPELL_EARTHQUAKE                         = 83;
int IP_CONST_ONHIT_CASTSPELL_SUNBURST                           = 84;
int IP_CONST_ONHIT_CASTSPELL_BANISHMENT                         = 85;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_MINOR_WOUNDS               = 86;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_LIGHT_WOUNDS               = 87;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_MODERATE_WOUNDS            = 88;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_SERIOUS_WOUNDS             = 89;
int IP_CONST_ONHIT_CASTSPELL_INFLICT_CRITICAL_WOUNDS            = 90;
int IP_CONST_ONHIT_CASTSPELL_BALAGARNSIRONHORN                  = 91;
int IP_CONST_ONHIT_CASTSPELL_DROWN                              = 92;
int IP_CONST_ONHIT_CASTSPELL_ELECTRIC_JOLT                      = 93;
int IP_CONST_ONHIT_CASTSPELL_FIREBRAND                          = 94;
int IP_CONST_ONHIT_CASTSPELL_WOUNDING_WHISPERS                  = 95;
int IP_CONST_ONHIT_CASTSPELL_UNDEATHS_ETERNAL_FOE               = 96;
int IP_CONST_ONHIT_CASTSPELL_INFERNO                            = 97;
int IP_CONST_ONHIT_CASTSPELL_ISAACS_LESSER_MISSILE_STORM        = 98;
int IP_CONST_ONHIT_CASTSPELL_ISAACS_GREATER_MISSILE_STORM       = 99;
int IP_CONST_ONHIT_CASTSPELL_BANE                               = 100;
int IP_CONST_ONHIT_CASTSPELL_SPIKE_GROWTH                       = 101;
int IP_CONST_ONHIT_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER            = 102;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_INTERPOSING_HAND            = 103;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_FORCEFUL_HAND               = 104;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_GRASPING_HAND               = 105;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_CLENCHED_FIST               = 106;
int IP_CONST_ONHIT_CASTSPELL_BIGBYS_CRUSHING_HAND               = 107;
int IP_CONST_ONHIT_CASTSPELL_FLESH_TO_STONE                     = 108;
int IP_CONST_ONHIT_CASTSPELL_STONE_TO_FLESH                     = 109;
int IP_CONST_ONHIT_CASTSPELL_CRUMBLE                            = 110;
int IP_CONST_ONHIT_CASTSPELL_INFESTATION_OF_MAGGOTS             = 111;
int IP_CONST_ONHIT_CASTSPELL_GREAT_THUNDERCLAP                  = 112;
int IP_CONST_ONHIT_CASTSPELL_BALL_LIGHTNING                     = 113;
int IP_CONST_ONHIT_CASTSPELL_GEDLEES_ELECTRIC_LOOP              = 114;
int IP_CONST_ONHIT_CASTSPELL_HORIZIKAULS_BOOM                   = 115;
int IP_CONST_ONHIT_CASTSPELL_MESTILS_ACID_BREATH                = 116;
int IP_CONST_ONHIT_CASTSPELL_SCINTILLATING_SPHERE               = 117;
int IP_CONST_ONHIT_CASTSPELL_UNDEATH_TO_DEATH                   = 118;
int IP_CONST_ONHIT_CASTSPELL_STONEHOLD                          = 119;

int IP_CONST_ONHIT_CASTSPELL_EVIL_BLIGHT                        = 121;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_TELEPORT                     = 122;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_SLAYRAKSHASA                 = 123;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE                   = 124;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER                  = 125;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_PLANARRIFT                   = 126;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_DARKFIRE                     = 127;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_EXTRACTBRAIN                 = 128;
int IP_CONST_ONHIT_CASTSPELL_ONHITFLAMINGSKIN                   = 129;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_CHAOSSHIELD                  = 130;
int IP_CONST_ONHIT_CASTSPELL_ONHIT_CONSTRICTWEAPON              = 131;
int IP_CONST_ONHIT_CASTSPELL_ONHITRUINARMORBEBILITH             = 132;
int IP_CONST_ONHIT_CASTSPELL_ONHITDEMILICHTOUCH                 = 133;
int IP_CONST_ONHIT_CASTSPELL_ONHITDRACOLICHTOUCH                = 134;
int IP_CONST_ONHIT_CASTSPELL_INTELLIGENT_WEAPON_ONHIT           = 135;
int IP_CONST_ONHIT_CASTSPELL_PARALYZE_2                         = 136;
int IP_CONST_ONHIT_CASTSPELL_DEAFENING_CLNG                     = 137;
int IP_CONST_ONHIT_CASTSPELL_KNOCKDOWN                          = 138;
int IP_CONST_ONHIT_CASTSPELL_FREEZE                             = 139;
int IP_CONST_ONHIT_CASTSPELL_COMBUST                            = 140;

int IP_CONST_POISON_1D2_STRDAMAGE               = 0;
int IP_CONST_POISON_1D2_DEXDAMAGE               = 1;
int IP_CONST_POISON_1D2_CONDAMAGE               = 2;
int IP_CONST_POISON_1D2_INTDAMAGE               = 3;
int IP_CONST_POISON_1D2_WISDAMAGE               = 4;
int IP_CONST_POISON_1D2_CHADAMAGE               = 5;
int IP_CONST_QUALITY_UNKOWN                     = 0;
int IP_CONST_QUALITY_DESTROYED                  = 1;
int IP_CONST_QUALITY_RUINED                     = 2;
int IP_CONST_QUALITY_VERY_POOR                  = 3;
int IP_CONST_QUALITY_POOR                       = 4;
int IP_CONST_QUALITY_BELOW_AVERAGE              = 5;
int IP_CONST_QUALITY_AVERAGE                    = 6;
int IP_CONST_QUALITY_ABOVE_AVERAGE              = 7;
int IP_CONST_QUALITY_GOOD                       = 8;
int IP_CONST_QUALITY_VERY_GOOD                  = 9;
int IP_CONST_QUALITY_EXCELLENT                  = 10;
int IP_CONST_QUALITY_MASTERWORK                 = 11;
int IP_CONST_QUALITY_GOD_LIKE                   = 12;
int IP_CONST_QUALITY_RAW                        = 13;
int IP_CONST_QUALITY_CUT                        = 14;
int IP_CONST_QUALITY_POLISHED                   = 15;
int IP_CONST_CONTAINERWEIGHTRED_20_PERCENT      = 1;
int IP_CONST_CONTAINERWEIGHTRED_40_PERCENT      = 2;
int IP_CONST_CONTAINERWEIGHTRED_60_PERCENT      = 3;
int IP_CONST_CONTAINERWEIGHTRED_80_PERCENT      = 4;
int IP_CONST_CONTAINERWEIGHTRED_100_PERCENT     = 5;
int IP_CONST_DAMAGERESIST_5                     = 1;
int IP_CONST_DAMAGERESIST_10                    = 2;
int IP_CONST_DAMAGERESIST_15                    = 3;
int IP_CONST_DAMAGERESIST_20                    = 4;
int IP_CONST_DAMAGERESIST_25                    = 5;
int IP_CONST_DAMAGERESIST_30                    = 6;
int IP_CONST_DAMAGERESIST_35                    = 7;
int IP_CONST_DAMAGERESIST_40                    = 8;
int IP_CONST_DAMAGERESIST_45                    = 9;
int IP_CONST_DAMAGERESIST_50                    = 10;
int IP_CONST_SAVEVS_ACID                        = 1;
int IP_CONST_SAVEVS_COLD                        = 3;
int IP_CONST_SAVEVS_DEATH                       = 4;
int IP_CONST_SAVEVS_DISEASE                     = 5;
int IP_CONST_SAVEVS_DIVINE                      = 6;
int IP_CONST_SAVEVS_ELECTRICAL                  = 7;
int IP_CONST_SAVEVS_FEAR                        = 8;
int IP_CONST_SAVEVS_FIRE                        = 9;
int IP_CONST_SAVEVS_MINDAFFECTING               = 11;
int IP_CONST_SAVEVS_NEGATIVE                    = 12;
int IP_CONST_SAVEVS_POISON                      = 13;
int IP_CONST_SAVEVS_POSITIVE                    = 14;
int IP_CONST_SAVEVS_SONIC                       = 15;
int IP_CONST_SAVEVS_UNIVERSAL                   = 0;
int IP_CONST_SAVEBASETYPE_FORTITUDE             = 1;
int IP_CONST_SAVEBASETYPE_WILL                  = 2;
int IP_CONST_SAVEBASETYPE_REFLEX                = 3;
int IP_CONST_DAMAGESOAK_5_HP                    = 1;
int IP_CONST_DAMAGESOAK_10_HP                   = 2;
int IP_CONST_DAMAGESOAK_15_HP                   = 3;
int IP_CONST_DAMAGESOAK_20_HP                   = 4;
int IP_CONST_DAMAGESOAK_25_HP                   = 5;
int IP_CONST_DAMAGESOAK_30_HP                   = 6;
int IP_CONST_DAMAGESOAK_35_HP                   = 7;
int IP_CONST_DAMAGESOAK_40_HP                   = 8;
int IP_CONST_DAMAGESOAK_45_HP                   = 9;
int IP_CONST_DAMAGESOAK_50_HP                   = 10;
int IP_CONST_DAMAGEREDUCTION_1                  = 0;
int IP_CONST_DAMAGEREDUCTION_2                  = 1;
int IP_CONST_DAMAGEREDUCTION_3                  = 2;
int IP_CONST_DAMAGEREDUCTION_4                  = 3;
int IP_CONST_DAMAGEREDUCTION_5                  = 4;
int IP_CONST_DAMAGEREDUCTION_6                  = 5;
int IP_CONST_DAMAGEREDUCTION_7                  = 6;
int IP_CONST_DAMAGEREDUCTION_8                  = 7;
int IP_CONST_DAMAGEREDUCTION_9                  = 8;
int IP_CONST_DAMAGEREDUCTION_10                 = 9;
int IP_CONST_DAMAGEREDUCTION_11                 = 10;
int IP_CONST_DAMAGEREDUCTION_12                 = 11;
int IP_CONST_DAMAGEREDUCTION_13                 = 12;
int IP_CONST_DAMAGEREDUCTION_14                 = 13;
int IP_CONST_DAMAGEREDUCTION_15                 = 14;
int IP_CONST_DAMAGEREDUCTION_16                 = 15;
int IP_CONST_DAMAGEREDUCTION_17                 = 16;
int IP_CONST_DAMAGEREDUCTION_18                 = 17;
int IP_CONST_DAMAGEREDUCTION_19                 = 18;
int IP_CONST_DAMAGEREDUCTION_20                 = 19;

int IP_CONST_IMMUNITYSPELL_ACID_FOG                       = 0;
int IP_CONST_IMMUNITYSPELL_AID                            = 1;
int IP_CONST_IMMUNITYSPELL_BARKSKIN                       = 2;
int IP_CONST_IMMUNITYSPELL_BESTOW_CURSE                   = 3;
int IP_CONST_IMMUNITYSPELL_BLINDNESS_AND_DEAFNESS         = 6;
int IP_CONST_IMMUNITYSPELL_BURNING_HANDS                  = 8;
int IP_CONST_IMMUNITYSPELL_CALL_LIGHTNING                 = 9;
int IP_CONST_IMMUNITYSPELL_CHAIN_LIGHTNING                = 12;
int IP_CONST_IMMUNITYSPELL_CHARM_MONSTER                  = 13;
int IP_CONST_IMMUNITYSPELL_CHARM_PERSON                   = 14;
int IP_CONST_IMMUNITYSPELL_CHARM_PERSON_OR_ANIMAL         = 15;
int IP_CONST_IMMUNITYSPELL_CIRCLE_OF_DEATH                = 16;
int IP_CONST_IMMUNITYSPELL_CIRCLE_OF_DOOM                 = 17;
int IP_CONST_IMMUNITYSPELL_CLOUDKILL                      = 21;
int IP_CONST_IMMUNITYSPELL_COLOR_SPRAY                    = 22;
int IP_CONST_IMMUNITYSPELL_CONE_OF_COLD                   = 23;
int IP_CONST_IMMUNITYSPELL_CONFUSION                      = 24;
int IP_CONST_IMMUNITYSPELL_CONTAGION                      = 25;
int IP_CONST_IMMUNITYSPELL_CONTROL_UNDEAD                 = 26;
int IP_CONST_IMMUNITYSPELL_CURE_CRITICAL_WOUNDS           = 27;
int IP_CONST_IMMUNITYSPELL_CURE_LIGHT_WOUNDS              = 28;
int IP_CONST_IMMUNITYSPELL_CURE_MINOR_WOUNDS              = 29;
int IP_CONST_IMMUNITYSPELL_CURE_MODERATE_WOUNDS           = 30;
int IP_CONST_IMMUNITYSPELL_CURE_SERIOUS_WOUNDS            = 31;
int IP_CONST_IMMUNITYSPELL_DARKNESS                       = 32;
int IP_CONST_IMMUNITYSPELL_DAZE                           = 33;
int IP_CONST_IMMUNITYSPELL_DEATH_WARD                     = 34;
int IP_CONST_IMMUNITYSPELL_DELAYED_BLAST_FIREBALL         = 35;
int IP_CONST_IMMUNITYSPELL_DISMISSAL                      = 36;
int IP_CONST_IMMUNITYSPELL_DISPEL_MAGIC                   = 37;
int IP_CONST_IMMUNITYSPELL_DOMINATE_ANIMAL                = 39;
int IP_CONST_IMMUNITYSPELL_DOMINATE_MONSTER               = 40;
int IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON                = 41;
int IP_CONST_IMMUNITYSPELL_DOOM                           = 42;
int IP_CONST_IMMUNITYSPELL_ENERGY_DRAIN                   = 46;
int IP_CONST_IMMUNITYSPELL_ENERVATION                     = 47;
int IP_CONST_IMMUNITYSPELL_ENTANGLE                       = 48;
int IP_CONST_IMMUNITYSPELL_FEAR                           = 49;
int IP_CONST_IMMUNITYSPELL_FEEBLEMIND                     = 50;
int IP_CONST_IMMUNITYSPELL_FINGER_OF_DEATH                = 51;
int IP_CONST_IMMUNITYSPELL_FIRE_STORM                     = 52;
int IP_CONST_IMMUNITYSPELL_FIREBALL                       = 53;
int IP_CONST_IMMUNITYSPELL_FLAME_ARROW                    = 54;
int IP_CONST_IMMUNITYSPELL_FLAME_LASH                     = 55;
int IP_CONST_IMMUNITYSPELL_FLAME_STRIKE                   = 56;
int IP_CONST_IMMUNITYSPELL_FREEDOM_OF_MOVEMENT            = 57;
int IP_CONST_IMMUNITYSPELL_GREASE                         = 59;
int IP_CONST_IMMUNITYSPELL_GREATER_DISPELLING             = 60;
int IP_CONST_IMMUNITYSPELL_GREATER_PLANAR_BINDING         = 62;
int IP_CONST_IMMUNITYSPELL_GREATER_SHADOW_CONJURATION     = 64;
int IP_CONST_IMMUNITYSPELL_GREATER_SPELL_BREACH           = 65;
int IP_CONST_IMMUNITYSPELL_HAMMER_OF_THE_GODS             = 68;
int IP_CONST_IMMUNITYSPELL_HARM                           = 69;
int IP_CONST_IMMUNITYSPELL_HEAL                           = 71;
int IP_CONST_IMMUNITYSPELL_HEALING_CIRCLE                 = 72;
int IP_CONST_IMMUNITYSPELL_HOLD_ANIMAL                    = 73;
int IP_CONST_IMMUNITYSPELL_HOLD_MONSTER                   = 74;
int IP_CONST_IMMUNITYSPELL_HOLD_PERSON                    = 75;
int IP_CONST_IMMUNITYSPELL_IMPLOSION                      = 78;
int IP_CONST_IMMUNITYSPELL_IMPROVED_INVISIBILITY          = 79;
int IP_CONST_IMMUNITYSPELL_INCENDIARY_CLOUD               = 80;
int IP_CONST_IMMUNITYSPELL_INVISIBILITY_PURGE             = 82;
int IP_CONST_IMMUNITYSPELL_LESSER_DISPEL                  = 84;
int IP_CONST_IMMUNITYSPELL_LESSER_PLANAR_BINDING          = 86;
int IP_CONST_IMMUNITYSPELL_LESSER_SPELL_BREACH            = 88;
int IP_CONST_IMMUNITYSPELL_LIGHTNING_BOLT                 = 91;
int IP_CONST_IMMUNITYSPELL_MAGIC_MISSILE                  = 97;
int IP_CONST_IMMUNITYSPELL_MASS_BLINDNESS_AND_DEAFNESS    = 100;
int IP_CONST_IMMUNITYSPELL_MASS_CHARM                     = 101;
int IP_CONST_IMMUNITYSPELL_MASS_HEAL                      = 104;
int IP_CONST_IMMUNITYSPELL_MELFS_ACID_ARROW               = 105;
int IP_CONST_IMMUNITYSPELL_METEOR_SWARM                   = 106;
int IP_CONST_IMMUNITYSPELL_MIND_FOG                       = 108;
int IP_CONST_IMMUNITYSPELL_MORDENKAINENS_DISJUNCTION      = 112;
int IP_CONST_IMMUNITYSPELL_PHANTASMAL_KILLER              = 116;
int IP_CONST_IMMUNITYSPELL_PLANAR_BINDING                 = 117;
int IP_CONST_IMMUNITYSPELL_POISON                         = 118;
int IP_CONST_IMMUNITYSPELL_POWER_WORD_KILL                = 120;
int IP_CONST_IMMUNITYSPELL_POWER_WORD_STUN                = 121;
int IP_CONST_IMMUNITYSPELL_PRISMATIC_SPRAY                = 124;
int IP_CONST_IMMUNITYSPELL_RAY_OF_ENFEEBLEMENT            = 131;
int IP_CONST_IMMUNITYSPELL_RAY_OF_FROST                   = 132;
int IP_CONST_IMMUNITYSPELL_SCARE                          = 142;
int IP_CONST_IMMUNITYSPELL_SEARING_LIGHT                  = 143;
int IP_CONST_IMMUNITYSPELL_SHADES                         = 145;
int IP_CONST_IMMUNITYSPELL_SHADOW_CONJURATION             = 146;
int IP_CONST_IMMUNITYSPELL_SILENCE                        = 150;
int IP_CONST_IMMUNITYSPELL_SLAY_LIVING                    = 151;
int IP_CONST_IMMUNITYSPELL_SLEEP                          = 152;
int IP_CONST_IMMUNITYSPELL_SLOW                           = 153;
int IP_CONST_IMMUNITYSPELL_SOUND_BURST                    = 154;
int IP_CONST_IMMUNITYSPELL_STINKING_CLOUD                 = 158;
int IP_CONST_IMMUNITYSPELL_STONESKIN                      = 159;
int IP_CONST_IMMUNITYSPELL_STORM_OF_VENGEANCE             = 160;
int IP_CONST_IMMUNITYSPELL_SUNBEAM                        = 161;
int IP_CONST_IMMUNITYSPELL_VIRTUE                         = 165;
int IP_CONST_IMMUNITYSPELL_WAIL_OF_THE_BANSHEE            = 166;
int IP_CONST_IMMUNITYSPELL_WEB                            = 167;
int IP_CONST_IMMUNITYSPELL_WEIRD                          = 168;
int IP_CONST_IMMUNITYSPELL_WORD_OF_FAITH                  = 169;
int IP_CONST_IMMUNITYSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT = 171;
int IP_CONST_IMMUNITYSPELL_EAGLE_SPLEDOR                  = 173;
int IP_CONST_IMMUNITYSPELL_OWLS_WISDOM                    = 174;
int IP_CONST_IMMUNITYSPELL_FOXS_CUNNING                   = 175;
int IP_CONST_IMMUNITYSPELL_GREATER_EAGLES_SPLENDOR        = 176;
int IP_CONST_IMMUNITYSPELL_GREATER_OWLS_WISDOM            = 177;
int IP_CONST_IMMUNITYSPELL_GREATER_FOXS_CUNNING           = 178;
int IP_CONST_IMMUNITYSPELL_GREATER_BULLS_STRENGTH         = 179;
int IP_CONST_IMMUNITYSPELL_GREATER_CATS_GRACE             = 180;
int IP_CONST_IMMUNITYSPELL_GREATER_ENDURANCE              = 181;
int IP_CONST_IMMUNITYSPELL_AURA_OF_VITALITY               = 182;
int IP_CONST_IMMUNITYSPELL_WAR_CRY                        = 183;
int IP_CONST_IMMUNITYSPELL_REGENERATE                     = 184;
int IP_CONST_IMMUNITYSPELL_EVARDS_BLACK_TENTACLES         = 185;
int IP_CONST_IMMUNITYSPELL_LEGEND_LORE                    = 186;
int IP_CONST_IMMUNITYSPELL_FIND_TRAPS                     = 187;
int IP_CONST_SPELLLEVEL_0                       = 0; // hmm are these necessary?
int IP_CONST_SPELLLEVEL_1                       = 1;
int IP_CONST_SPELLLEVEL_2                       = 2;
int IP_CONST_SPELLLEVEL_3                       = 3;
int IP_CONST_SPELLLEVEL_4                       = 4;
int IP_CONST_SPELLLEVEL_5                       = 5;
int IP_CONST_SPELLLEVEL_6                       = 6;
int IP_CONST_SPELLLEVEL_7                       = 7;
int IP_CONST_SPELLLEVEL_8                       = 8;
int IP_CONST_SPELLLEVEL_9                       = 9;
int IP_CONST_CASTSPELL_ACID_FOG_11                      = 0;
int IP_CONST_CASTSPELL_ACID_SPLASH_1                    = 355;
int IP_CONST_CASTSPELL_ACTIVATE_ITEM                    = 359;
int IP_CONST_CASTSPELL_AID_3                            = 1;
int IP_CONST_CASTSPELL_AMPLIFY_5                        = 373;
int IP_CONST_CASTSPELL_ANIMATE_DEAD_10                  = 3;
int IP_CONST_CASTSPELL_ANIMATE_DEAD_15                  = 4;
int IP_CONST_CASTSPELL_ANIMATE_DEAD_5                   = 2;
int IP_CONST_CASTSPELL_AURA_OF_VITALITY_13              = 321;
int IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15         = 287;
int IP_CONST_CASTSPELL_AURAOFGLORY_7                    = 360;
int IP_CONST_CASTSPELL_AWAKEN_9                         = 303;
int IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7              = 367;
int IP_CONST_CASTSPELL_BANE_5                           = 380;
int IP_CONST_CASTSPELL_BANISHMENT_15                    = 361;
int IP_CONST_CASTSPELL_BARKSKIN_12                      = 7;
int IP_CONST_CASTSPELL_BARKSKIN_3                       = 5;
int IP_CONST_CASTSPELL_BARKSKIN_6                       = 6;
int IP_CONST_CASTSPELL_BESTOW_CURSE_5                   = 8;
int IP_CONST_CASTSPELL_BIGBYS_CLENCHED_FIST_20          = 393;
int IP_CONST_CASTSPELL_BIGBYS_CRUSHING_HAND_20          = 394;
int IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15          = 391;
int IP_CONST_CASTSPELL_BIGBYS_GRASPING_HAND_17          = 392;
int IP_CONST_CASTSPELL_BIGBYS_INTERPOSING_HAND_15       = 390;
int IP_CONST_CASTSPELL_BLADE_BARRIER_11                 = 9;
int IP_CONST_CASTSPELL_BLADE_BARRIER_15                 = 10;
int IP_CONST_CASTSPELL_BLESS_2                          = 11;
int IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3             = 14;
int IP_CONST_CASTSPELL_BLOOD_FRENZY_7                   = 353;
int IP_CONST_CASTSPELL_BOMBARDMENT_20                   = 354;
int IP_CONST_CASTSPELL_BULLS_STRENGTH_10                = 16;
int IP_CONST_CASTSPELL_BULLS_STRENGTH_15                = 17;
int IP_CONST_CASTSPELL_BULLS_STRENGTH_3                 = 15;
int IP_CONST_CASTSPELL_BURNING_HANDS_2                  = 18;
int IP_CONST_CASTSPELL_BURNING_HANDS_5                  = 19;
int IP_CONST_CASTSPELL_CALL_LIGHTNING_10                = 21;
int IP_CONST_CASTSPELL_CALL_LIGHTNING_5                 = 20;
int IP_CONST_CASTSPELL_CAMOFLAGE_5                      = 352;
int IP_CONST_CASTSPELL_CATS_GRACE_10                    = 26;
int IP_CONST_CASTSPELL_CATS_GRACE_15                    = 27;
int IP_CONST_CASTSPELL_CATS_GRACE_3                     = 25;
int IP_CONST_CASTSPELL_CHAIN_LIGHTNING_11               = 28;
int IP_CONST_CASTSPELL_CHAIN_LIGHTNING_15               = 29;
int IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20               = 30;
int IP_CONST_CASTSPELL_CHARM_MONSTER_10                 = 32;
int IP_CONST_CASTSPELL_CHARM_MONSTER_5                  = 31;
int IP_CONST_CASTSPELL_CHARM_PERSON_10                  = 34;
int IP_CONST_CASTSPELL_CHARM_PERSON_2                   = 33;
int IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10        = 36;
int IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_3         = 35;
int IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_11               = 37;
int IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_15               = 38;
int IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_20               = 39;
int IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_15                = 41;
int IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_20                = 42;
int IP_CONST_CASTSPELL_CIRCLE_OF_DOOM_9                 = 40;
int IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_10    = 44;
int IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15    = 45;
int IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_5     = 43;
int IP_CONST_CASTSPELL_CLARITY_3                        = 46;
int IP_CONST_CASTSPELL_CLOUDKILL_9                      = 48;
int IP_CONST_CASTSPELL_COLOR_SPRAY_2                    = 49;
int IP_CONST_CASTSPELL_CONE_OF_COLD_15                  = 51;
int IP_CONST_CASTSPELL_CONE_OF_COLD_9                   = 50;
int IP_CONST_CASTSPELL_CONFUSION_10                     = 53;
int IP_CONST_CASTSPELL_CONFUSION_5                      = 52;
int IP_CONST_CASTSPELL_CONTAGION_5                      = 54;
int IP_CONST_CASTSPELL_CONTINUAL_FLAME_7                = 350;
int IP_CONST_CASTSPELL_CONTROL_UNDEAD_13                = 55;
int IP_CONST_CASTSPELL_CONTROL_UNDEAD_20                = 56;
int IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_15         = 57;
int IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_16         = 58;
int IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18         = 59;
int IP_CONST_CASTSPELL_CREATE_UNDEAD_11                 = 60;
int IP_CONST_CASTSPELL_CREATE_UNDEAD_14                 = 61;
int IP_CONST_CASTSPELL_CREATE_UNDEAD_16                 = 62;
int IP_CONST_CASTSPELL_CREEPING_DOOM_13                 = 304;
int IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12          = 64;
int IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15          = 65;
int IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7           = 63;
int IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2              = 66;
int IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5              = 67;
int IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1              = 68;
int IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10          = 71;
int IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3           = 69;
int IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6           = 70;
int IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10           = 73;
int IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5            = 72;
int IP_CONST_CASTSPELL_DARKNESS_3                       = 75;
int IP_CONST_CASTSPELL_DARKVISION_3                     = 305;
int IP_CONST_CASTSPELL_DARKVISION_6                     = 306;
int IP_CONST_CASTSPELL_DAZE_1                           = 76;
int IP_CONST_CASTSPELL_DEATH_WARD_7                     = 77;
int IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_13        = 78;
int IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_15        = 79;
int IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_20        = 80;
int IP_CONST_CASTSPELL_DESTRUCTION_13                   = 307;
int IP_CONST_CASTSPELL_DIRGE_15                         = 376;
int IP_CONST_CASTSPELL_DISMISSAL_12                     = 82;
int IP_CONST_CASTSPELL_DISMISSAL_18                     = 83;
int IP_CONST_CASTSPELL_DISMISSAL_7                      = 81;
int IP_CONST_CASTSPELL_DISPEL_MAGIC_10                  = 85;
int IP_CONST_CASTSPELL_DISPEL_MAGIC_5                   = 84;
int IP_CONST_CASTSPELL_DISPLACEMENT_9                   = 389;
int IP_CONST_CASTSPELL_DIVINE_FAVOR_5                   = 345;
int IP_CONST_CASTSPELL_DIVINE_MIGHT_5                   = 395;
int IP_CONST_CASTSPELL_DIVINE_POWER_7                   = 86;
int IP_CONST_CASTSPELL_DIVINE_SHIELD_5                  = 396;
int IP_CONST_CASTSPELL_DOMINATE_ANIMAL_5                = 87;
int IP_CONST_CASTSPELL_DOMINATE_MONSTER_17              = 88;
int IP_CONST_CASTSPELL_DOMINATE_PERSON_7                = 89;
int IP_CONST_CASTSPELL_DOOM_2                           = 90;
int IP_CONST_CASTSPELL_DOOM_5                           = 91;
int IP_CONST_CASTSPELL_DRAGON_BREATH_ACID_10            = 400;
int IP_CONST_CASTSPELL_DRAGON_BREATH_COLD_10            = 401;
int IP_CONST_CASTSPELL_DRAGON_BREATH_FEAR_10            = 402;
int IP_CONST_CASTSPELL_DRAGON_BREATH_FIRE_10            = 403;
int IP_CONST_CASTSPELL_DRAGON_BREATH_GAS_10             = 404;
int IP_CONST_CASTSPELL_DRAGON_BREATH_LIGHTNING_10       = 405;
int IP_CONST_CASTSPELL_DRAGON_BREATH_PARALYZE_10        = 406;
int IP_CONST_CASTSPELL_DRAGON_BREATH_SLEEP_10           = 407;
int IP_CONST_CASTSPELL_DRAGON_BREATH_SLOW_10            = 408;
int IP_CONST_CASTSPELL_DRAGON_BREATH_WEAKEN_10          = 409;
int IP_CONST_CASTSPELL_DROWN_15                         = 368;
int IP_CONST_CASTSPELL_EAGLE_SPLEDOR_10                 = 289;
int IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15                 = 290;
int IP_CONST_CASTSPELL_EAGLE_SPLEDOR_3                  = 288;
int IP_CONST_CASTSPELL_EARTHQUAKE_20                    = 357;
int IP_CONST_CASTSPELL_ELECTRIC_JOLT_1                  = 370;
int IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12              = 93;
int IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7               = 92;
int IP_CONST_CASTSPELL_ELEMENTAL_SWARM_17               = 94;
int IP_CONST_CASTSPELL_ENDURANCE_10                     = 96;
int IP_CONST_CASTSPELL_ENDURANCE_15                     = 97;
int IP_CONST_CASTSPELL_ENDURANCE_3                      = 95;
int IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2                = 98;
int IP_CONST_CASTSPELL_ENERGY_BUFFER_11                 = 311;
int IP_CONST_CASTSPELL_ENERGY_BUFFER_15                 = 312;
int IP_CONST_CASTSPELL_ENERGY_BUFFER_20                 = 313;
int IP_CONST_CASTSPELL_ENERGY_DRAIN_17                  = 99;
int IP_CONST_CASTSPELL_ENERVATION_7                     = 100;
int IP_CONST_CASTSPELL_ENTANGLE_2                       = 101;
int IP_CONST_CASTSPELL_ENTANGLE_5                       = 102;
int IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5                = 349;
int IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15               = 196;
int IP_CONST_CASTSPELL_ETHEREAL_VISAGE_9                = 195;
int IP_CONST_CASTSPELL_ETHEREALNESS_18                  = 374;
int IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_15        = 325;
int IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_7         = 324;
int IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5            = 387;
int IP_CONST_CASTSPELL_FEAR_5                           = 103;
int IP_CONST_CASTSPELL_FEEBLEMIND_9                     = 104;
int IP_CONST_CASTSPELL_FIND_TRAPS_3                     = 327;
int IP_CONST_CASTSPELL_FINGER_OF_DEATH_13               = 105;
int IP_CONST_CASTSPELL_FIRE_STORM_13                    = 106;
int IP_CONST_CASTSPELL_FIRE_STORM_18                    = 107;
int IP_CONST_CASTSPELL_FIREBALL_10                      = 109;
int IP_CONST_CASTSPELL_FIREBALL_5                       = 108;
int IP_CONST_CASTSPELL_FIREBRAND_15                     = 371;
int IP_CONST_CASTSPELL_FLAME_ARROW_12                   = 111;
int IP_CONST_CASTSPELL_FLAME_ARROW_18                   = 112;
int IP_CONST_CASTSPELL_FLAME_ARROW_5                    = 110;
int IP_CONST_CASTSPELL_FLAME_LASH_10                    = 114;
int IP_CONST_CASTSPELL_FLAME_LASH_3                     = 113;
int IP_CONST_CASTSPELL_FLAME_STRIKE_12                  = 116;
int IP_CONST_CASTSPELL_FLAME_STRIKE_18                  = 117;
int IP_CONST_CASTSPELL_FLAME_STRIKE_7                   = 115;
int IP_CONST_CASTSPELL_FLARE_1                          = 347;
int IP_CONST_CASTSPELL_FLESH_TO_STONE_5                 = 398;
int IP_CONST_CASTSPELL_FOXS_CUNNING_10                  = 295;
int IP_CONST_CASTSPELL_FOXS_CUNNING_15                  = 296;
int IP_CONST_CASTSPELL_FOXS_CUNNING_3                   = 294;
int IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7            = 118;
int IP_CONST_CASTSPELL_GATE_17                          = 119;
int IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15                = 194;
int IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3                 = 192;
int IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9                 = 193;
int IP_CONST_CASTSPELL_GHOUL_TOUCH_3                    = 120;
int IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11      = 121;
int IP_CONST_CASTSPELL_GREASE_2                         = 122;
int IP_CONST_CASTSPELL_GREATER_BULLS_STRENGTH_11        = 300;
int IP_CONST_CASTSPELL_GREATER_CATS_GRACE_11            = 301;
int IP_CONST_CASTSPELL_GREATER_DISPELLING_15            = 124;
int IP_CONST_CASTSPELL_GREATER_DISPELLING_7             = 123;
int IP_CONST_CASTSPELL_GREATER_EAGLES_SPLENDOR_11       = 297;
int IP_CONST_CASTSPELL_GREATER_ENDURANCE_11             = 302;
int IP_CONST_CASTSPELL_GREATER_FOXS_CUNNING_11          = 299;
int IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9             = 384;
int IP_CONST_CASTSPELL_GREATER_OWLS_WISDOM_11           = 298;
int IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15        = 126;
int IP_CONST_CASTSPELL_GREATER_RESTORATION_13           = 127;
int IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9     = 128;
int IP_CONST_CASTSPELL_GREATER_SPELL_BREACH_11          = 129;
int IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17          = 130;
int IP_CONST_CASTSPELL_GREATER_STONESKIN_11             = 131;
int IP_CONST_CASTSPELL_GRENADE_ACID_1                   = 341;
int IP_CONST_CASTSPELL_GRENADE_CALTROPS_1               = 343;
int IP_CONST_CASTSPELL_GRENADE_CHICKEN_1                = 342;
int IP_CONST_CASTSPELL_GRENADE_CHOKING_1                = 339;
int IP_CONST_CASTSPELL_GRENADE_FIRE_1                   = 336;
int IP_CONST_CASTSPELL_GRENADE_HOLY_1                   = 338;
int IP_CONST_CASTSPELL_GRENADE_TANGLE_1                 = 337;
int IP_CONST_CASTSPELL_GRENADE_THUNDERSTONE_1           = 340;
int IP_CONST_CASTSPELL_GUST_OF_WIND_10                  = 410;
int IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12            = 134;
int IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_7             = 133;
int IP_CONST_CASTSPELL_HARM_11                          = 136;
int IP_CONST_CASTSPELL_HASTE_10                         = 138;
int IP_CONST_CASTSPELL_HASTE_5                          = 137;
int IP_CONST_CASTSPELL_HEAL_11                          = 139;
int IP_CONST_CASTSPELL_HEALING_CIRCLE_16                = 141;
int IP_CONST_CASTSPELL_HEALING_CIRCLE_9                 = 140;
int IP_CONST_CASTSPELL_HOLD_ANIMAL_3                    = 142;
int IP_CONST_CASTSPELL_HOLD_MONSTER_7                   = 143;
int IP_CONST_CASTSPELL_HOLD_PERSON_3                    = 144;
int IP_CONST_CASTSPELL_HORRID_WILTING_15                = 308;
int IP_CONST_CASTSPELL_HORRID_WILTING_20                = 309;
int IP_CONST_CASTSPELL_ICE_STORM_9                      = 310;
int IP_CONST_CASTSPELL_IDENTIFY_3                       = 147;
int IP_CONST_CASTSPELL_IMPLOSION_17                     = 148;
int IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7          = 149;
int IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15              = 150;
int IP_CONST_CASTSPELL_INFERNO_15                       = 377;
int IP_CONST_CASTSPELL_INFLICT_CRITICAL_WOUNDS_12       = 366;
int IP_CONST_CASTSPELL_INFLICT_LIGHT_WOUNDS_5           = 363;
int IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1           = 362;
int IP_CONST_CASTSPELL_INFLICT_MODERATE_WOUNDS_7        = 364;
int IP_CONST_CASTSPELL_INFLICT_SERIOUS_WOUNDS_9         = 365;
int IP_CONST_CASTSPELL_INVISIBILITY_3                   = 151;
int IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5             = 152;
int IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5            = 153;
int IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15  = 379;
int IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13   = 378;
int IP_CONST_CASTSPELL_KNOCK_3                          = 154;
int IP_CONST_CASTSPELL_LEGEND_LORE_5                    = 326;
int IP_CONST_CASTSPELL_LESSER_DISPEL_3                  = 155;
int IP_CONST_CASTSPELL_LESSER_DISPEL_5                  = 156;
int IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9              = 157;
int IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9          = 158;
int IP_CONST_CASTSPELL_LESSER_RESTORATION_3             = 159;
int IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7            = 160;
int IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9            = 161;
int IP_CONST_CASTSPELL_LIGHT_1                          = 162;
int IP_CONST_CASTSPELL_LIGHT_5                          = 163;
int IP_CONST_CASTSPELL_LIGHTNING_BOLT_10                = 165;
int IP_CONST_CASTSPELL_LIGHTNING_BOLT_5                 = 164;
int IP_CONST_CASTSPELL_MAGE_ARMOR_2                     = 167;
int IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5 = 286;
int IP_CONST_CASTSPELL_MAGIC_FANG_5                     = 383;
int IP_CONST_CASTSPELL_MAGIC_MISSILE_3                  = 172;
int IP_CONST_CASTSPELL_MAGIC_MISSILE_5                  = 173;
int IP_CONST_CASTSPELL_MAGIC_MISSILE_9                  = 174;
int IP_CONST_CASTSPELL_MANIPULATE_PORTAL_STONE          = 344;
int IP_CONST_CASTSPELL_MASS_BLINDNESS_DEAFNESS_15       = 179;
int IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13                = 386;
int IP_CONST_CASTSPELL_MASS_CHARM_15                    = 180;
int IP_CONST_CASTSPELL_MASS_HASTE_11                    = 182;
int IP_CONST_CASTSPELL_MASS_HEAL_15                     = 183;
int IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3               = 184;
int IP_CONST_CASTSPELL_MELFS_ACID_ARROW_6               = 185;
int IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9               = 186;
int IP_CONST_CASTSPELL_METEOR_SWARM_17                  = 187;
int IP_CONST_CASTSPELL_MIND_BLANK_15                    = 188;
int IP_CONST_CASTSPELL_MIND_FOG_9                       = 189;
int IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_15 = 191;
int IP_CONST_CASTSPELL_MINOR_GLOBE_OF_INVULNERABILITY_7 = 190;
int IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17     = 197;
int IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_13           = 198;
int IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_18           = 199;
int IP_CONST_CASTSPELL_NATURES_BALANCE_15               = 200;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_10         = 315;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_BURST_5          = 314;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_10    = 202;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_15    = 203;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_PROTECTION_5     = 201;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_1            = 316;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_3            = 317;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_5            = 318;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_7            = 319;
int IP_CONST_CASTSPELL_NEGATIVE_ENERGY_RAY_9            = 320;
int IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5              = 204;
int IP_CONST_CASTSPELL_ONE_WITH_THE_LAND_7              = 351;
int IP_CONST_CASTSPELL_OWLS_INSIGHT_15                  = 369;
int IP_CONST_CASTSPELL_OWLS_WISDOM_10                   = 292;
int IP_CONST_CASTSPELL_OWLS_WISDOM_15                   = 293;
int IP_CONST_CASTSPELL_OWLS_WISDOM_3                    = 291;
int IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7              = 205;
int IP_CONST_CASTSPELL_PLANAR_ALLY_15                   = 382;
int IP_CONST_CASTSPELL_PLANAR_BINDING_11                = 206;
int IP_CONST_CASTSPELL_POISON_5                         = 207;
int IP_CONST_CASTSPELL_POLYMORPH_SELF_7                 = 208;
int IP_CONST_CASTSPELL_POWER_WORD_KILL_17               = 209;
int IP_CONST_CASTSPELL_POWER_WORD_STUN_13               = 210;
int IP_CONST_CASTSPELL_PRAYER_5                         = 211;
int IP_CONST_CASTSPELL_PREMONITION_15                   = 212;
int IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13               = 213;
int IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2      = 284;
int IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5      = 285;
int IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10      = 217;
int IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_3       = 216;
int IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13        = 224;
int IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20        = 225;
int IP_CONST_CASTSPELL_QUILLFIRE_8                      = 356;
int IP_CONST_CASTSPELL_RAISE_DEAD_9                     = 226;
int IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2            = 227;
int IP_CONST_CASTSPELL_RAY_OF_FROST_1                   = 228;
int IP_CONST_CASTSPELL_REGENERATE_13                    = 323;
int IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5      = 229;
int IP_CONST_CASTSPELL_REMOVE_CURSE_5                   = 230;
int IP_CONST_CASTSPELL_REMOVE_DISEASE_5                 = 231;
int IP_CONST_CASTSPELL_REMOVE_FEAR_2                    = 232;
int IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3               = 233;
int IP_CONST_CASTSPELL_RESIST_ELEMENTS_10               = 235;
int IP_CONST_CASTSPELL_RESIST_ELEMENTS_3                = 234;
int IP_CONST_CASTSPELL_RESISTANCE_2                     = 236;
int IP_CONST_CASTSPELL_RESISTANCE_5                     = 237;
int IP_CONST_CASTSPELL_RESTORATION_7                    = 238;
int IP_CONST_CASTSPELL_RESURRECTION_13                  = 239;
int IP_CONST_CASTSPELL_ROGUES_CUNNING_3                 = 328;
int IP_CONST_CASTSPELL_SANCTUARY_2                      = 240;
int IP_CONST_CASTSPELL_SCARE_2                          = 241;
int IP_CONST_CASTSPELL_SEARING_LIGHT_5                  = 242;
int IP_CONST_CASTSPELL_SEE_INVISIBILITY_3               = 243;
int IP_CONST_CASTSPELL_SHADES_11                        = 244;
int IP_CONST_CASTSPELL_SHADOW_CONJURATION_7             = 245;
int IP_CONST_CASTSPELL_SHADOW_SHIELD_13                 = 246;
int IP_CONST_CASTSPELL_SHAPECHANGE_17                   = 247;
int IP_CONST_CASTSPELL_SHIELD_5                         = 348;
int IP_CONST_CASTSPELL_SHIELD_OF_FAITH_5                = 381;
int IP_CONST_CASTSPELL_SILENCE_3                        = 249;
int IP_CONST_CASTSPELL_SLAY_LIVING_9                    = 250;
int IP_CONST_CASTSPELL_SLEEP_2                          = 251;
int IP_CONST_CASTSPELL_SLEEP_5                          = 252;
int IP_CONST_CASTSPELL_SLOW_5                           = 253;
int IP_CONST_CASTSPELL_SOUND_BURST_3                    = 254;
int IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_BEER             = 330;
int IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_SPIRITS          = 332;
int IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_WINE             = 331;
int IP_CONST_CASTSPELL_SPECIAL_HERB_BELLADONNA          = 333;
int IP_CONST_CASTSPELL_SPECIAL_HERB_GARLIC              = 334;
int IP_CONST_CASTSPELL_SPELL_MANTLE_13                  = 257;
int IP_CONST_CASTSPELL_SPELL_RESISTANCE_15              = 256;
int IP_CONST_CASTSPELL_SPELL_RESISTANCE_9               = 255;
int IP_CONST_CASTSPELL_SPIKE_GROWTH_9                   = 385;
int IP_CONST_CASTSPELL_STINKING_CLOUD_5                 = 259;
int IP_CONST_CASTSPELL_STONE_TO_FLESH_5                 = 399;
int IP_CONST_CASTSPELL_STONESKIN_7                      = 260;
int IP_CONST_CASTSPELL_STORM_OF_VENGEANCE_17            = 261;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2              = 262;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5              = 263;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3             = 264;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5            = 265;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7             = 266;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17            = 267;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9              = 268;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11            = 269;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13           = 270;
int IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15          = 271;
int IP_CONST_CASTSPELL_SUNBEAM_13                       = 272;
int IP_CONST_CASTSPELL_SUNBURST_20                      = 358;
int IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7        = 388;
int IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11        = 273;
int IP_CONST_CASTSPELL_TIME_STOP_17                     = 274;
int IP_CONST_CASTSPELL_TRUE_SEEING_9                    = 275;
int IP_CONST_CASTSPELL_TRUE_STRIKE_5                    = 346;
int IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20          = 375;
int IP_CONST_CASTSPELL_UNIQUE_POWER                     = 329;
int IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY           = 335;
int IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5                 = 277;
int IP_CONST_CASTSPELL_VIRTUE_1                         = 278;
int IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17           = 279;
int IP_CONST_CASTSPELL_WALL_OF_FIRE_9                   = 280;
int IP_CONST_CASTSPELL_WAR_CRY_7                        = 322;
int IP_CONST_CASTSPELL_WEB_3                            = 281;
int IP_CONST_CASTSPELL_WEIRD_17                         = 282;
int IP_CONST_CASTSPELL_WORD_OF_FAITH_13                 = 283;
int IP_CONST_CASTSPELL_WOUNDING_WHISPERS_9              = 372;
int IP_CONST_SPELLSCHOOL_ABJURATION                     = 0;
int IP_CONST_SPELLSCHOOL_CONJURATION                    = 1;
int IP_CONST_SPELLSCHOOL_DIVINATION                     = 2;
int IP_CONST_SPELLSCHOOL_ENCHANTMENT                    = 3;
int IP_CONST_SPELLSCHOOL_EVOCATION                      = 4;
int IP_CONST_SPELLSCHOOL_ILLUSION                       = 5;
int IP_CONST_SPELLSCHOOL_NECROMANCY                     = 6;
int IP_CONST_SPELLSCHOOL_TRANSMUTATION                  = 7;
int IP_CONST_SPELLRESISTANCEBONUS_10                    = 0;
int IP_CONST_SPELLRESISTANCEBONUS_12                    = 1;
int IP_CONST_SPELLRESISTANCEBONUS_14                    = 2;
int IP_CONST_SPELLRESISTANCEBONUS_16                    = 3;
int IP_CONST_SPELLRESISTANCEBONUS_18                    = 4;
int IP_CONST_SPELLRESISTANCEBONUS_20                    = 5;
int IP_CONST_SPELLRESISTANCEBONUS_22                    = 6;
int IP_CONST_SPELLRESISTANCEBONUS_24                    = 7;
int IP_CONST_SPELLRESISTANCEBONUS_26                    = 8;
int IP_CONST_SPELLRESISTANCEBONUS_28                    = 9;
int IP_CONST_SPELLRESISTANCEBONUS_30                    = 10;
int IP_CONST_SPELLRESISTANCEBONUS_32                    = 11;
int IP_CONST_TRAPTYPE_SPIKE                             = 1;
int IP_CONST_TRAPTYPE_HOLY                              = 2;
int IP_CONST_TRAPTYPE_TANGLE                            = 3;
int IP_CONST_TRAPTYPE_BLOBOFACID                        = 4;
int IP_CONST_TRAPTYPE_FIRE                              = 5;
int IP_CONST_TRAPTYPE_ELECTRICAL                        = 6;
int IP_CONST_TRAPTYPE_GAS                               = 7;
int IP_CONST_TRAPTYPE_FROST                             = 8;
int IP_CONST_TRAPTYPE_ACID_SPLASH                       = 9;
int IP_CONST_TRAPTYPE_SONIC                             = 10;
int IP_CONST_TRAPTYPE_NEGATIVE                          = 11;
int IP_CONST_TRAPSTRENGTH_MINOR                         = 0;
int IP_CONST_TRAPSTRENGTH_AVERAGE                       = 1;
int IP_CONST_TRAPSTRENGTH_STRONG                        = 2;
int IP_CONST_TRAPSTRENGTH_DEADLY                        = 3;
int IP_CONST_REDUCEDWEIGHT_80_PERCENT                   = 1;
int IP_CONST_REDUCEDWEIGHT_60_PERCENT                   = 2;
int IP_CONST_REDUCEDWEIGHT_40_PERCENT                   = 3;
int IP_CONST_REDUCEDWEIGHT_20_PERCENT                   = 4;
int IP_CONST_REDUCEDWEIGHT_10_PERCENT                   = 5;
int IP_CONST_WEIGHTINCREASE_5_LBS                       = 0;
int IP_CONST_WEIGHTINCREASE_10_LBS                      = 1;
int IP_CONST_WEIGHTINCREASE_15_LBS                      = 2;
int IP_CONST_WEIGHTINCREASE_30_LBS                      = 3;
int IP_CONST_WEIGHTINCREASE_50_LBS                      = 4;
int IP_CONST_WEIGHTINCREASE_100_LBS                     = 5;
int IP_CONST_CLASS_BARBARIAN                            = 0;
int IP_CONST_CLASS_BARD                                 = 1;
int IP_CONST_CLASS_CLERIC                               = 2;
int IP_CONST_CLASS_DRUID                                = 3;
int IP_CONST_CLASS_FIGHTER                              = 4;
int IP_CONST_CLASS_MONK                                 = 5;
int IP_CONST_CLASS_PALADIN                              = 6;
int IP_CONST_CLASS_RANGER                               = 7;
int IP_CONST_CLASS_ROGUE                                = 8;
int IP_CONST_CLASS_SORCERER                             = 9;
int IP_CONST_CLASS_WIZARD                               = 10;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT       = 0;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT       = 1;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT       = 2;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT       = 3;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT       = 4;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT       = 5;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT       = 6;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT       = 7;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT       = 8;
int IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT        = 9;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_5_PERCENT       = 10;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_10_PERCENT      = 11;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_15_PERCENT      = 12;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_20_PERCENT      = 13;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_25_PERCENT      = 14;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_30_PERCENT      = 15;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_35_PERCENT      = 16;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_40_PERCENT      = 17;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_45_PERCENT      = 18;
int IP_CONST_ARCANE_SPELL_FAILURE_PLUS_50_PERCENT      = 19;

int ACTION_MODE_DETECT                  = 0;
int ACTION_MODE_STEALTH                 = 1;
int ACTION_MODE_PARRY                   = 2;
int ACTION_MODE_POWER_ATTACK            = 3;
int ACTION_MODE_IMPROVED_POWER_ATTACK   = 4;
int ACTION_MODE_COUNTERSPELL            = 5;
int ACTION_MODE_FLURRY_OF_BLOWS         = 6;
int ACTION_MODE_RAPID_SHOT              = 7;
int ACTION_MODE_EXPERTISE               = 8;
int ACTION_MODE_IMPROVED_EXPERTISE      = 9;
int ACTION_MODE_DEFENSIVE_CAST          = 10;
int ACTION_MODE_DIRTY_FIGHTING          = 11;

int ITEM_VISUAL_ACID            = 0;
int ITEM_VISUAL_COLD            = 1;
int ITEM_VISUAL_ELECTRICAL      = 2;
int ITEM_VISUAL_FIRE            = 3;
int ITEM_VISUAL_SONIC           = 4;
int ITEM_VISUAL_HOLY            = 5;
int ITEM_VISUAL_EVIL            = 6;

// these constants must match those in the skyboxes.2da
int SKYBOX_NONE         = 0;
int SKYBOX_GRASS_CLEAR      = 1;
int SKYBOX_GRASS_STORM      = 2;
int SKYBOX_DESERT_CLEAR     = 3;
int SKYBOX_WINTER_CLEAR     = 4;
int SKYBOX_ICY          = 5;

int  FOG_TYPE_ALL       = 0;
int  FOG_TYPE_SUN       = 1;
int  FOG_TYPE_MOON      = 2;

int  FOG_COLOR_RED              = 16711680;
int  FOG_COLOR_RED_DARK         = 6684672;
int  FOG_COLOR_GREEN            = 65280;
int  FOG_COLOR_GREEN_DARK       = 23112;
int  FOG_COLOR_BLUE             = 255;
int  FOG_COLOR_BLUE_DARK        = 102;
int  FOG_COLOR_BLACK            = 0;
int  FOG_COLOR_WHITE            = 16777215;
int  FOG_COLOR_GREY             = 10066329;
int  FOG_COLOR_YELLOW           = 16776960;
int  FOG_COLOR_YELLOW_DARK      = 11184640;
int  FOG_COLOR_CYAN             = 65535;
int  FOG_COLOR_MAGENTA          = 16711935;
int  FOG_COLOR_ORANGE           = 16750848;
int  FOG_COLOR_ORANGE_DARK      = 13395456;
int  FOG_COLOR_BROWN            = 10053120;
int  FOG_COLOR_BROWN_DARK       = 6697728;

int  AREA_LIGHT_COLOR_MOON_AMBIENT  = 0;
int  AREA_LIGHT_COLOR_MOON_DIFFUSE  = 1;
int  AREA_LIGHT_COLOR_SUN_AMBIENT   = 2;
int  AREA_LIGHT_COLOR_SUN_DIFFUSE   = 3;

int  AREA_LIGHT_DIRECTION_MOON  = 0;
int  AREA_LIGHT_DIRECTION_SUN   = 1;

// these constants must match those in the AmbientSound.2da
int AMBIENT_SOUND_NONE				= 0;
int AMBIENT_SOUND_MEN_WHISPER_INSIDE		= 1;
int AMBIENT_SOUND_WOMEN_WHISPER_INSIDE  	= 2;
int AMBIENT_SOUND_PEOPLE_WHISPER_INSIDE		= 3;
int AMBIENT_SOUND_SMALL_GROUP_TALKS_INSIDE	= 4;
int AMBIENT_SOUND_MEDIUM_GROUP_TALKS_INSIDE	= 5;
int AMBIENT_SOUND_LARGE_GROUP_TALKS_INSIDE	= 6;
int AMBIENT_SOUND_COMMONER_TAVERN_TALK		= 7;
int AMBIENT_SOUND_NOBLE_TAVERN_TALK		= 8;
int AMBIENT_SOUND_CITY_SLUMS_DAY_CROWDED	= 9;
int AMBIENT_SOUND_CITY_SLUMS_DAY_SPARSE		= 10;
int AMBIENT_SOUND_CITY_SLUMS_NIGHT		= 11;
int AMBIENT_SOUND_CITY_DAY_CROWDED		= 12;
int AMBIENT_SOUND_CITY_DAY_SPARSE		= 13;
int AMBIENT_SOUND_CITY_NIGHT			= 14;
int AMBIENT_SOUND_CITY_MARKET			= 15;
int AMBIENT_SOUND_CITY_TEMPLE_DISTRICT		= 16;
int AMBIENT_SOUND_TOWN_DAY_CROWDED		= 17;
int AMBIENT_SOUND_TOWN_DAY_SPARSE		= 18;
int AMBIENT_SOUND_TOWN_NIGHT			= 19;
int AMBIENT_SOUND_BORDELLO_WOMEN		= 20;
int AMBIENT_SOUND_BORDELLO_MEN_AND_WOMEN	= 21;
int AMBIENT_SOUND_RIOT_OUTSIDE			= 22;
int AMBIENT_SOUND_RIOT_MUFFLED			= 23;
int AMBIENT_SOUND_COMBAT_OUTSIDE_1		= 24;
int AMBIENT_SOUND_COMBAT_OUTSIDE_2		= 25;
int AMBIENT_SOUND_COMBAT_MUFFLED_1		= 26;
int AMBIENT_SOUND_COMBAT_MUFFLED_2		= 27;
int AMBIENT_SOUND_DUNGEON_LAKE_LAVA		= 28;
int AMBIENT_SOUND_SEWER_SLUDGE_LAKE		= 29;
int AMBIENT_SOUND_WIND_SOFT			= 30;
int AMBIENT_SOUND_WIND_MEDIUM			= 31;
int AMBIENT_SOUND_WIND_STRONG			= 32;
int AMBIENT_SOUND_WIND_FOREST			= 33;
int AMBIENT_SOUND_GUST_CHASM			= 34;
int AMBIENT_SOUND_GUST_CAVERN			= 35;
int AMBIENT_SOUND_GUST_GRASS			= 36;
int AMBIENT_SOUND_GUST_DRAFT			= 37;
int AMBIENT_SOUND_RAIN_LIGHT			= 38;
int AMBIENT_SOUND_RAIN_HARD			= 39;
int AMBIENT_SOUND_RAIN_STORM_SMALL		= 40;
int AMBIENT_SOUND_RAIN_STORM_BIG		= 41;
int AMBIENT_SOUND_CAVE_INSECTS_1		= 42;
int AMBIENT_SOUND_CAVE_INSECTS_2		= 43;
int AMBIENT_SOUND_INTERIOR_INSECTS_1		= 44;
int AMBIENT_SOUND_INTERIOR_INSECTS_2		= 45;
int AMBIENT_SOUND_LIZARD_FOLK_CAVE_CRYSTALS	= 46;
int AMBIENT_SOUND_SEWERS_1			= 47;
int AMBIENT_SOUND_SEWERS_2			= 48;
int AMBIENT_SOUND_FOREST_DAY_1			= 49;
int AMBIENT_SOUND_FOREST_DAY_2			= 50;
int AMBIENT_SOUND_FOREST_DAY_3			= 51;
int AMBIENT_SOUND_FOREST_DAY_SCARY		= 52;
int AMBIENT_SOUND_FOREST_NIGHT_1		= 53;
int AMBIENT_SOUND_FOREST_NIGHT_2		= 54;
int AMBIENT_SOUND_FOREST_NIGHT_SCARY		= 55;
int AMBIENT_SOUND_FOREST_MAGICAL		= 56;
int AMBIENT_SOUND_EVIL_DUNGEON_SMALL		= 57;
int AMBIENT_SOUND_EVIL_DUNGEON_MEDIUM		= 58;
int AMBIENT_SOUND_EVIL_DUNGEON_LARGE		= 59;
int AMBIENT_SOUND_CAVE_SMALL			= 60;
int AMBIENT_SOUND_CAVE_MEDIUM			= 61;
int AMBIENT_SOUND_CAVE_LARGE			= 62;
int AMBIENT_SOUND_MINE_SMALL			= 63;
int AMBIENT_SOUND_MINE_MEDIUM			= 64;
int AMBIENT_SOUND_MINE_LARGE			= 65;
int AMBIENT_SOUND_CASTLE_INTERIOR_SMALL		= 66;
int AMBIENT_SOUND_CASTLE_INTERIOR_MEDIUM	= 67;
int AMBIENT_SOUND_CASTLE_INTERIOR_LARGE		= 68;
int AMBIENT_SOUND_CRYPT_SMALL			= 69;
int AMBIENT_SOUND_CRYPT_MEDIUM_1		= 70;
int AMBIENT_SOUND_CRYPT_MEDIUM_2		= 71;
int AMBIENT_SOUND_HOUSE_INTERIOR_1		= 72;
int AMBIENT_SOUND_HOUSE_INTERIOR_2		= 73;
int AMBIENT_SOUND_HOUSE_INTERIOR_3		= 74;
int AMBIENT_SOUND_KITCHEN_INTERIOR_SMALL	= 75;
int AMBIENT_SOUND_KITCHEN_INTERIOR_LARGE	= 76;
int AMBIENT_SOUND_HAUNTED_INTERIOR_1		= 77;
int AMBIENT_SOUND_HAUNTED_INTERIOR_2		= 78;
int AMBIENT_SOUND_HAUNTED_INTERIOR_3		= 79;
int AMBIENT_SOUND_BLACK_SMITH			= 80;
int AMBIENT_SOUND_PIT_CRIES			= 81;
int AMBIENT_SOUND_MAGIC_INTERIOR_SMALL		= 82;
int AMBIENT_SOUND_MAGIC_INTERIOR_MEDIUM		= 83;
int AMBIENT_SOUND_MAGIC_INTERIOR_LARGE		= 84;
int AMBIENT_SOUND_MAGIC_INTERIOR_EVIL		= 85;
int AMBIENT_SOUND_MAGICAL_INTERIOR_FIRELAB	= 86;
int AMBIENT_SOUND_MAGICAL_INTERIOR_EARTHLAB	= 87;
int AMBIENT_SOUND_MAGICAL_INTERIOR_AIRLAB	= 88;
int AMBIENT_SOUND_MAGICAL_INTERIOR_WATERLAB	= 89;
int AMBIENT_SOUND_WINTER_DAY_WET_XP1		= 90;
int AMBIENT_SOUND_WINTER_DAY_WINDY_XP1		= 91;
int AMBIENT_SOUND_DESERT_DAY_XP1		= 92;
int AMBIENT_SOUND_DESERT_NIGHT_XP1		= 93;
int AMBIENT_SOUND_MONASTERY_INTERIOR_XP1	= 94;
int AMBIENT_SOUND_RUIN_WET_XP1			= 96;
int AMBIENT_SOUND_RUIN_RUMBLING_XP1		= 97;
int AMBIENT_SOUND_RUIN_HAUNTED_XP1		= 98;
int AMBIENT_SOUND_SAND_STORM_LIGHT_XP1		= 99;
int AMBIENT_SOUND_SAND_STORM_EXTREME_XP1	= 100;
int AMBIENT_SOUND_EVIL_DRONE_XP2		= 101;
int AMBIENT_SOUND_PLAIN_OF_FIRE_XP2		= 102;
int AMBIENT_SOUND_FROZEN_HELL_XP2		= 103;
int AMBIENT_SOUND_CAVE_EVIL_1_XP2		= 104;
int AMBIENT_SOUND_CAVE_EVIL_2_XP2		= 105;
int AMBIENT_SOUND_CAVE_EVIL_3_XP2		= 106;
int AMBIENT_SOUND_TAVERN_ROWDY			= 107;

// these constants must match those in the FootstepSounds.2da
int FOOTSTEP_TYPE_INVALID                       = -1;
int FOOTSTEP_TYPE_NORMAL                        = 0;
int FOOTSTEP_TYPE_LARGE                         = 1;
int FOOTSTEP_TYPE_DRAGON                        = 2;
int FOOTSTEP_TYPE_SOFT                          = 3;
int FOOTSTEP_TYPE_HOOF                          = 4;
int FOOTSTEP_TYPE_HOOF_LARGE                    = 5;
int FOOTSTEP_TYPE_BEETLE                        = 6;
int FOOTSTEP_TYPE_SPIDER                        = 7;
int FOOTSTEP_TYPE_SKELETON                      = 8;
int FOOTSTEP_TYPE_LEATHER_WING                  = 9;
int FOOTSTEP_TYPE_FEATHER_WING                  = 10;
//int FOOTSTEP_TYPE_LIZARD                      = 11; // Was not ever used/fully implemented.
int FOOTSTEP_TYPE_NONE                          = 12;
int FOOTSTEP_TYPE_SEAGULL                       = 13;
int FOOTSTEP_TYPE_SHARK                         = 14;
int FOOTSTEP_TYPE_WATER_NORMAL                  = 15;
int FOOTSTEP_TYPE_WATER_LARGE                   = 16;
int FOOTSTEP_TYPE_HORSE                         = 17;
int FOOTSTEP_TYPE_DEFAULT                       = 65535;

// these constants must match those in the WingModel.2da
int CREATURE_WING_TYPE_NONE                     = 0;
int CREATURE_WING_TYPE_DEMON                    = 1;
int CREATURE_WING_TYPE_ANGEL                    = 2;
int CREATURE_WING_TYPE_BAT                      = 3;
int CREATURE_WING_TYPE_DRAGON                   = 4;
int CREATURE_WING_TYPE_BUTTERFLY                = 5;
int CREATURE_WING_TYPE_BIRD                     = 6;

// these constants must match those in the TailModel.2da
int CREATURE_TAIL_TYPE_NONE                     = 0;
int CREATURE_TAIL_TYPE_LIZARD                   = 1;
int CREATURE_TAIL_TYPE_BONE                     = 2;
int CREATURE_TAIL_TYPE_DEVIL                    = 3;

// these constants must match those in the CAPart.2da
int CREATURE_PART_RIGHT_FOOT                    = 0;
int CREATURE_PART_LEFT_FOOT                     = 1;
int CREATURE_PART_RIGHT_SHIN                    = 2;
int CREATURE_PART_LEFT_SHIN                     = 3;
int CREATURE_PART_LEFT_THIGH                    = 4;
int CREATURE_PART_RIGHT_THIGH                   = 5;
int CREATURE_PART_PELVIS                        = 6;
int CREATURE_PART_TORSO                         = 7;
int CREATURE_PART_BELT                          = 8;
int CREATURE_PART_NECK                          = 9;
int CREATURE_PART_RIGHT_FOREARM                 = 10;
int CREATURE_PART_LEFT_FOREARM                  = 11;
int CREATURE_PART_RIGHT_BICEP                   = 12;
int CREATURE_PART_LEFT_BICEP                    = 13;
int CREATURE_PART_RIGHT_SHOULDER                = 14;
int CREATURE_PART_LEFT_SHOULDER                 = 15;
int CREATURE_PART_RIGHT_HAND                    = 16;
int CREATURE_PART_LEFT_HAND                     = 17;
int CREATURE_PART_HEAD                          = 20;

int CREATURE_MODEL_TYPE_NONE                    = 0;
int CREATURE_MODEL_TYPE_SKIN                    = 1;
int CREATURE_MODEL_TYPE_TATTOO                  = 2;
int CREATURE_MODEL_TYPE_UNDEAD                  = 255;

int COLOR_CHANNEL_SKIN                          = 0;
int COLOR_CHANNEL_HAIR                          = 1;
int COLOR_CHANNEL_TATTOO_1                      = 2;
int COLOR_CHANNEL_TATTOO_2                      = 3;

// The following resrefs must match those in the tileset's set file.
string TILESET_RESREF_BEHOLDER_CAVES        = "tib01";
string TILESET_RESREF_CASTLE_INTERIOR       = "tic01";
string TILESET_RESREF_CITY_EXTERIOR         = "tcn01";
string TILESET_RESREF_CITY_INTERIOR         = "tin01";
string TILESET_RESREF_CRYPT                 = "tdc01";
string TILESET_RESREF_DESERT                = "ttd01";
string TILESET_RESREF_DROW_INTERIOR         = "tid01";
string TILESET_RESREF_DUNGEON               = "tde01";
string TILESET_RESREF_FOREST                = "ttf01";
string TILESET_RESREF_FROZEN_WASTES         = "tti01";
string TILESET_RESREF_ILLITHID_INTERIOR     = "tii01";
string TILESET_RESREF_MICROSET              = "tms01";
string TILESET_RESREF_MINES_AND_CAVERNS     = "tdm01";
string TILESET_RESREF_RUINS                 = "tdr01";
string TILESET_RESREF_RURAL                 = "ttr01";
string TILESET_RESREF_RURAL_WINTER          = "tts01";
string TILESET_RESREF_SEWERS                = "tds01";
string TILESET_RESREF_UNDERDARK             = "ttu01";
string TILESET_RESREF_LIZARDFOLK_INTERIOR   = "dag01";
string TILESET_RESREF_MEDIEVAL_CITY_2       = "tcm02";
string TILESET_RESREF_MEDIEVAL_RURAL_2      = "trm02";
string TILESET_RESREF_EARLY_WINTER_2        = "trs02";
string TILESET_RESREF_SEASHIPS              = "tss13";
string TILESET_RESREF_FOREST_FACELIFT       = "ttf02";
string TILESET_RESREF_RURAL_WINTER_FACELIFT = "tts02";
string TILESET_RESREF_STEAMWORKS            = "tsw01";
string TILESET_RESREF_BARROWS_INTERIOR      = "tbw01";
string TILESET_RESREF_SEA_CAVES             = "tdt01";
string TILESET_RESREF_CITY_INTERIOR_2       = "tni01";
string TILESET_RESREF_CASTLE_INTERIOR_2     = "tni02";
string TILESET_RESREF_CASTLE_EXTERIOR_RURAL = "tno01";
string TILESET_RESREF_TROPICAL              = "ttz01";
string TILESET_RESREF_FORT_INTERIOR         = "twc03";

// These constants determine which name table to use when generating random names.
int NAME_FIRST_GENERIC_MALE     = -1;
int NAME_ANIMAL                 = 0;
int NAME_FAMILIAR               = 1;
int NAME_FIRST_DWARF_MALE       = 2;
int NAME_FIRST_DWARF_FEMALE     = 3;
int NAME_LAST_DWARF             = 4;
int NAME_FIRST_ELF_MALE         = 5;
int NAME_FIRST_ELF_FEMALE       = 6;
int NAME_LAST_ELF               = 7;
int NAME_FIRST_GNOME_MALE       = 8;
int NAME_FIRST_GNOME_FEMALE     = 9;
int NAME_LAST_GNOME             = 10;
int NAME_FIRST_HALFELF_MALE     = 11;
int NAME_FIRST_HALFELF_FEMALE   = 12;
int NAME_LAST_HALFELF           = 13;
int NAME_FIRST_HALFLING_MALE    = 14;
int NAME_FIRST_HALFLING_FEMALE  = 15;
int NAME_LAST_HALFLING          = 16;
int NAME_FIRST_HALFORC_MALE     = 17;
int NAME_FIRST_HALFORC_FEMALE   = 18;
int NAME_LAST_HALFORC           = 19;
int NAME_FIRST_HUMAN_MALE       = 20;
int NAME_FIRST_HUMAN_FEMALE     = 21;
int NAME_LAST_HUMAN             = 22;

int EVENT_SCRIPT_MODULE_ON_HEARTBEAT                     = 3000;
int EVENT_SCRIPT_MODULE_ON_USER_DEFINED_EVENT            = 3001;
int EVENT_SCRIPT_MODULE_ON_MODULE_LOAD                   = 3002;
int EVENT_SCRIPT_MODULE_ON_MODULE_START                  = 3003;
int EVENT_SCRIPT_MODULE_ON_CLIENT_ENTER                  = 3004;
int EVENT_SCRIPT_MODULE_ON_CLIENT_EXIT                   = 3005;
int EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM                 = 3006;
int EVENT_SCRIPT_MODULE_ON_ACQUIRE_ITEM                  = 3007;
int EVENT_SCRIPT_MODULE_ON_LOSE_ITEM                     = 3008;
int EVENT_SCRIPT_MODULE_ON_PLAYER_DEATH                  = 3009;
int EVENT_SCRIPT_MODULE_ON_PLAYER_DYING                  = 3010;
int EVENT_SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED        = 3011;
int EVENT_SCRIPT_MODULE_ON_PLAYER_REST                   = 3012;
int EVENT_SCRIPT_MODULE_ON_PLAYER_LEVEL_UP               = 3013;
int EVENT_SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE        = 3014;
int EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM                    = 3015;
int EVENT_SCRIPT_MODULE_ON_UNEQUIP_ITEM                  = 3016;
int EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT                   = 3017;
int EVENT_SCRIPT_MODULE_ON_PLAYER_TARGET                 = 3018;
int EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT               = 3019;
int EVENT_SCRIPT_MODULE_ON_PLAYER_TILE_ACTION            = 3020;
int EVENT_SCRIPT_MODULE_ON_NUI_EVENT                     = 3021;

int EVENT_SCRIPT_AREA_ON_HEARTBEAT                       = 4000;
int EVENT_SCRIPT_AREA_ON_USER_DEFINED_EVENT              = 4001;
int EVENT_SCRIPT_AREA_ON_ENTER                           = 4002;
int EVENT_SCRIPT_AREA_ON_EXIT                            = 4003;

int EVENT_SCRIPT_AREAOFEFFECT_ON_HEARTBEAT               = 11000;
int EVENT_SCRIPT_AREAOFEFFECT_ON_USER_DEFINED_EVENT      = 11001;
int EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_ENTER            = 11002;
int EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_EXIT             = 11003;

int EVENT_SCRIPT_CREATURE_ON_HEARTBEAT                   = 5000;
int EVENT_SCRIPT_CREATURE_ON_NOTICE                      = 5001;
int EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT                 = 5002;
int EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED              = 5003;
int EVENT_SCRIPT_CREATURE_ON_DAMAGED                     = 5004;
int EVENT_SCRIPT_CREATURE_ON_DISTURBED                   = 5005;
int EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND             = 5006;
int EVENT_SCRIPT_CREATURE_ON_DIALOGUE                    = 5007;
int EVENT_SCRIPT_CREATURE_ON_SPAWN_IN                    = 5008;
int EVENT_SCRIPT_CREATURE_ON_RESTED                      = 5009;
int EVENT_SCRIPT_CREATURE_ON_DEATH                       = 5010;
int EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT          = 5011;
int EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR             = 5012;

int EVENT_SCRIPT_TRIGGER_ON_HEARTBEAT                    = 7000;
int EVENT_SCRIPT_TRIGGER_ON_OBJECT_ENTER                 = 7001;
int EVENT_SCRIPT_TRIGGER_ON_OBJECT_EXIT                  = 7002;
int EVENT_SCRIPT_TRIGGER_ON_USER_DEFINED_EVENT           = 7003;
int EVENT_SCRIPT_TRIGGER_ON_TRAPTRIGGERED                = 7004;
int EVENT_SCRIPT_TRIGGER_ON_DISARMED                     = 7005;
int EVENT_SCRIPT_TRIGGER_ON_CLICKED                      = 7006;

int EVENT_SCRIPT_PLACEABLE_ON_CLOSED                     = 9000;
int EVENT_SCRIPT_PLACEABLE_ON_DAMAGED                    = 9001;
int EVENT_SCRIPT_PLACEABLE_ON_DEATH                      = 9002;
int EVENT_SCRIPT_PLACEABLE_ON_DISARM                     = 9003;
int EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT                  = 9004;
int EVENT_SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED         = 9005;
int EVENT_SCRIPT_PLACEABLE_ON_LOCK                       = 9006;
int EVENT_SCRIPT_PLACEABLE_ON_MELEEATTACKED              = 9007;
int EVENT_SCRIPT_PLACEABLE_ON_OPEN                       = 9008;
int EVENT_SCRIPT_PLACEABLE_ON_SPELLCASTAT                = 9009;
int EVENT_SCRIPT_PLACEABLE_ON_TRAPTRIGGERED              = 9010;
int EVENT_SCRIPT_PLACEABLE_ON_UNLOCK                     = 9011;
int EVENT_SCRIPT_PLACEABLE_ON_USED                       = 9012;
int EVENT_SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT         = 9013;
int EVENT_SCRIPT_PLACEABLE_ON_DIALOGUE                   = 9014;
int EVENT_SCRIPT_PLACEABLE_ON_LEFT_CLICK                 = 9015;

int EVENT_SCRIPT_DOOR_ON_OPEN                            = 10000;
int EVENT_SCRIPT_DOOR_ON_CLOSE                           = 10001;
int EVENT_SCRIPT_DOOR_ON_DAMAGE                          = 10002;
int EVENT_SCRIPT_DOOR_ON_DEATH                           = 10003;
int EVENT_SCRIPT_DOOR_ON_DISARM                          = 10004;
int EVENT_SCRIPT_DOOR_ON_HEARTBEAT                       = 10005;
int EVENT_SCRIPT_DOOR_ON_LOCK                            = 10006;
int EVENT_SCRIPT_DOOR_ON_MELEE_ATTACKED                  = 10007;
int EVENT_SCRIPT_DOOR_ON_SPELLCASTAT                     = 10008;
int EVENT_SCRIPT_DOOR_ON_TRAPTRIGGERED                   = 10009;
int EVENT_SCRIPT_DOOR_ON_UNLOCK                          = 10010;
int EVENT_SCRIPT_DOOR_ON_USERDEFINED                     = 10011;
int EVENT_SCRIPT_DOOR_ON_CLICKED                         = 10012;
int EVENT_SCRIPT_DOOR_ON_DIALOGUE                        = 10013;
int EVENT_SCRIPT_DOOR_ON_FAIL_TO_OPEN                    = 10014;

int EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_ENTER               = 13000;
int EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_EXIT                = 13001;
int EVENT_SCRIPT_ENCOUNTER_ON_HEARTBEAT                  = 13002;
int EVENT_SCRIPT_ENCOUNTER_ON_ENCOUNTER_EXHAUSTED        = 13003;
int EVENT_SCRIPT_ENCOUNTER_ON_USER_DEFINED_EVENT         = 13004;

int EVENT_SCRIPT_STORE_ON_OPEN                           = 14000;
int EVENT_SCRIPT_STORE_ON_CLOSE                          = 14001;

int OBJECT_VISUAL_TRANSFORM_SCALE                        = 10;
int OBJECT_VISUAL_TRANSFORM_ROTATE_X                     = 21;
int OBJECT_VISUAL_TRANSFORM_ROTATE_Y                     = 22;
int OBJECT_VISUAL_TRANSFORM_ROTATE_Z                     = 23;
int OBJECT_VISUAL_TRANSFORM_TRANSLATE_X                  = 31;
int OBJECT_VISUAL_TRANSFORM_TRANSLATE_Y                  = 32;
int OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z                  = 33;
int OBJECT_VISUAL_TRANSFORM_ANIMATION_SPEED              = 40;

int OBJECT_VISUAL_TRANSFORM_LERP_NONE                    = 0; // 1
int OBJECT_VISUAL_TRANSFORM_LERP_LINEAR                  = 1; // x
int OBJECT_VISUAL_TRANSFORM_LERP_SMOOTHSTEP              = 2; // x * x * (3 - 2 * x)
int OBJECT_VISUAL_TRANSFORM_LERP_INVERSE_SMOOTHSTEP      = 3; // 0.5 - sin(asin(1.0 - 2.0 * x) / 3.0)
int OBJECT_VISUAL_TRANSFORM_LERP_EASE_IN                 = 4; // (1 - cosf(x * M_PI * 0.5))
int OBJECT_VISUAL_TRANSFORM_LERP_EASE_OUT                = 5; // sinf(x * M_PI * 0.5)
int OBJECT_VISUAL_TRANSFORM_LERP_QUADRATIC               = 6; // x * x
int OBJECT_VISUAL_TRANSFORM_LERP_SMOOTHERSTEP            = 7; // (x * x * x * (x * (6.0 * x - 15.0) + 10.0))

int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_BASE              = 0;
int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_CREATURE_HEAD     = 254;
int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_CREATURE_TAIL     = 253;
int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_CREATURE_WINGS    = 252;
int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_CREATURE_CLOAK    = 243;

int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_ITEM_PART1        = 255;
int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_ITEM_PART2        = 254;
int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_ITEM_PART3        = 253;
int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_ITEM_PART4        = 252;
int OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_ITEM_PART5        = 251;

int OBJECT_VISUAL_TRANSFORM_BEHAVIOR_DEFAULT             = 0; // no special behavior
int OBJECT_VISUAL_TRANSFORM_BEHAVIOR_BOUNCE              = 1; // when repeating a lerp, swap to and from states

int VIBRATOR_MOTOR_ANY                                   = 0;
int VIBRATOR_MOTOR_LEFT                                  = 1;
int VIBRATOR_MOTOR_RIGHT                                 = 2;

int SCREEN_ANCHOR_TOP_LEFT                               = 0;
int SCREEN_ANCHOR_TOP_RIGHT                              = 1;
int SCREEN_ANCHOR_BOTTOM_LEFT                            = 2;
int SCREEN_ANCHOR_BOTTOM_RIGHT                           = 3;
int SCREEN_ANCHOR_CENTER                                 = 4;

int DOMAIN_AIR                                           = 0;
int DOMAIN_ANIMAL                                        = 1;
int DOMAIN_DEATH                                         = 3;
int DOMAIN_DESTRUCTION                                   = 4;
int DOMAIN_EARTH                                         = 5;
int DOMAIN_EVIL                                          = 6;
int DOMAIN_FIRE                                          = 7;
int DOMAIN_GOOD                                          = 8;
int DOMAIN_HEALING                                       = 9;
int DOMAIN_KNOWLEDGE                                     = 10;
int DOMAIN_MAGIC                                         = 13;
int DOMAIN_PLANT                                         = 14;
int DOMAIN_PROTECTION                                    = 15;
int DOMAIN_STRENGTH                                      = 16;
int DOMAIN_SUN                                           = 17;
int DOMAIN_TRAVEL                                        = 18;
int DOMAIN_TRICKERY                                      = 19;
int DOMAIN_WAR                                           = 20;
int DOMAIN_WATER                                         = 21;

int MOUSECURSOR_DEFAULT                                  = 1;
int MOUSECURSOR_DEFAULT_DOWN                             = 2;
int MOUSECURSOR_WALK                                     = 3;
int MOUSECURSOR_WALK_DOWN                                = 4;
int MOUSECURSOR_NOWALK                                   = 5;
int MOUSECURSOR_NOWALK_DOWN                              = 6;
int MOUSECURSOR_ATTACK                                   = 7;
int MOUSECURSOR_ATTACK_DOWN                              = 8;
int MOUSECURSOR_NOATTACK                                 = 9;
int MOUSECURSOR_NOATTACK_DOWN                            = 10;
int MOUSECURSOR_TALK                                     = 11;
int MOUSECURSOR_TALK_DOWN                                = 12;
int MOUSECURSOR_NOTALK                                   = 13;
int MOUSECURSOR_NOTALK_DOWN                              = 14;
int MOUSECURSOR_FOLLOW                                   = 15;
int MOUSECURSOR_FOLLOW_DOWN                              = 16;
int MOUSECURSOR_EXAMINE                                  = 17;
int MOUSECURSOR_EXAMINE_DOWN                             = 18;
int MOUSECURSOR_NOEXAMINE                                = 19;
int MOUSECURSOR_NOEXAMINE_DOWN                           = 20;
int MOUSECURSOR_TRANSITION                               = 21;
int MOUSECURSOR_TRANSITION_DOWN                          = 22;
int MOUSECURSOR_DOOR                                     = 23;
int MOUSECURSOR_DOOR_DOWN                                = 24;
int MOUSECURSOR_USE                                      = 25;
int MOUSECURSOR_USE_DOWN                                 = 26;
int MOUSECURSOR_NOUSE                                    = 27;
int MOUSECURSOR_NOUSE_DOWN                               = 28;
int MOUSECURSOR_MAGIC                                    = 29;
int MOUSECURSOR_MAGIC_DOWN                               = 30;
int MOUSECURSOR_NOMAGIC                                  = 31;
int MOUSECURSOR_NOMAGIC_DOWN                             = 32;
int MOUSECURSOR_DISARM                                   = 33;
int MOUSECURSOR_DISARM_DOWN                              = 34;
int MOUSECURSOR_NODISARM                                 = 35;
int MOUSECURSOR_NODISARM_DOWN                            = 36;
int MOUSECURSOR_ACTION                                   = 37;
int MOUSECURSOR_ACTION_DOWN                              = 38;
int MOUSECURSOR_NOACTION                                 = 39;
int MOUSECURSOR_NOACTION_DOWN                            = 40;
int MOUSECURSOR_LOCK                                     = 41;
int MOUSECURSOR_LOCK_DOWN                                = 42;
int MOUSECURSOR_NOLOCK                                   = 43;
int MOUSECURSOR_NOLOCK_DOWN                              = 44;
int MOUSECURSOR_PUSHPIN                                  = 45;
int MOUSECURSOR_PUSHPIN_DOWN                             = 46;
int MOUSECURSOR_CREATE                                   = 47;
int MOUSECURSOR_CREATE_DOWN                              = 48;
int MOUSECURSOR_NOCREATE                                 = 49;
int MOUSECURSOR_NOCREATE_DOWN                            = 50;
int MOUSECURSOR_KILL                                     = 51;
int MOUSECURSOR_KILL_DOWN                                = 52;
int MOUSECURSOR_NOKILL                                   = 53;
int MOUSECURSOR_NOKILL_DOWN                              = 54;
int MOUSECURSOR_HEAL                                     = 55;
int MOUSECURSOR_HEAL_DOWN                                = 56;
int MOUSECURSOR_NOHEAL                                   = 57;
int MOUSECURSOR_NOHEAL_DOWN                              = 58;
int MOUSECURSOR_RUNARROW                                 = 59;
int MOUSECURSOR_WALKARROW                                = 75;
int MOUSECURSOR_PICKUP                                   = 91;
int MOUSECURSOR_PICKUP_DOWN                              = 92;
int MOUSECURSOR_CUSTOM_00                                = 93;  // gui_mp_custom00u
int MOUSECURSOR_CUSTOM_00_DOWN                           = 94;  // gui_mp_custom00d
int MOUSECURSOR_CUSTOM_99                                = 291; // gui_mp_custom99u
int MOUSECURSOR_CUSTOM_99_DOWN                           = 292; // gui_mp_custom99d

float CASSOWARY_STRENGTH_WEAK                            = 1.0;
float CASSOWARY_STRENGTH_MEDIUM                          = 1000.0;
float CASSOWARY_STRENGTH_STRONG                          = 1000000.0;
float CASSOWARY_STRENGTH_REQUIRED                        = 1001001000.0;

int RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_APPLIED              = 1;
int RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED              = 2;
int RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_INTERVAL             = 3;

int EFFECT_ICON_INVALID                             = 0;
int EFFECT_ICON_DAMAGE_RESISTANCE                   = 1;
int EFFECT_ICON_REGENERATE                          = 2;
int EFFECT_ICON_DAMAGE_REDUCTION                    = 3;
int EFFECT_ICON_TEMPORARY_HITPOINTS                 = 4;
int EFFECT_ICON_ENTANGLE                            = 5;
int EFFECT_ICON_INVULNERABLE                        = 6;
int EFFECT_ICON_DEAF                                = 7;
int EFFECT_ICON_FATIGUE                             = 8;
int EFFECT_ICON_IMMUNITY                            = 9;
int EFFECT_ICON_BLIND                               = 10;
int EFFECT_ICON_ENEMY_ATTACK_BONUS                  = 11;
int EFFECT_ICON_CHARMED                             = 12;
int EFFECT_ICON_CONFUSED                            = 13;
int EFFECT_ICON_FRIGHTENED                          = 14;
int EFFECT_ICON_DOMINATED                           = 15;
int EFFECT_ICON_PARALYZE                            = 16;
int EFFECT_ICON_DAZED                               = 17;
int EFFECT_ICON_STUNNED                             = 18;
int EFFECT_ICON_SLEEP                               = 19;
int EFFECT_ICON_POISON                              = 20;
int EFFECT_ICON_DISEASE                             = 21;
int EFFECT_ICON_CURSE                               = 22;
int EFFECT_ICON_SILENCE                             = 23;
int EFFECT_ICON_TURNED                              = 24;
int EFFECT_ICON_HASTE                               = 25;
int EFFECT_ICON_SLOW                                = 26;
int EFFECT_ICON_ABILITY_INCREASE_STR                = 27;
int EFFECT_ICON_ABILITY_DECREASE_STR                = 28;
int EFFECT_ICON_ATTACK_INCREASE                     = 29;
int EFFECT_ICON_ATTACK_DECREASE                     = 30;
int EFFECT_ICON_DAMAGE_INCREASE                     = 31;
int EFFECT_ICON_DAMAGE_DECREASE                     = 32;
int EFFECT_ICON_DAMAGE_IMMUNITY_INCREASE            = 33;
int EFFECT_ICON_DAMAGE_IMMUNITY_DECREASE            = 34;
int EFFECT_ICON_AC_INCREASE                         = 35;
int EFFECT_ICON_AC_DECREASE                         = 36;
int EFFECT_ICON_MOVEMENT_SPEED_INCREASE             = 37;
int EFFECT_ICON_MOVEMENT_SPEED_DECREASE             = 38;
int EFFECT_ICON_SAVING_THROW_INCREASE               = 39;
int EFFECT_ICON_SAVING_THROW_DECREASE               = 40;
int EFFECT_ICON_SPELL_RESISTANCE_INCREASE           = 41;
int EFFECT_ICON_SPELL_RESISTANCE_DECREASE           = 42;
int EFFECT_ICON_SKILL_INCREASE                      = 43;
int EFFECT_ICON_SKILL_DECREASE                      = 44;
int EFFECT_ICON_INVISIBILITY                        = 45;
int EFFECT_ICON_IMPROVEDINVISIBILITY                = 46;
int EFFECT_ICON_DARKNESS                            = 47;
int EFFECT_ICON_DISPELMAGICALL                      = 48;
int EFFECT_ICON_ELEMENTALSHIELD                     = 49;
int EFFECT_ICON_LEVELDRAIN                          = 50;
int EFFECT_ICON_POLYMORPH                           = 51;
int EFFECT_ICON_SANCTUARY                           = 52;
int EFFECT_ICON_TRUESEEING                          = 53;
int EFFECT_ICON_SEEINVISIBILITY                     = 54;
int EFFECT_ICON_TIMESTOP                            = 55;
int EFFECT_ICON_BLINDNESS                           = 56;
int EFFECT_ICON_SPELLLEVELABSORPTION                = 57;
int EFFECT_ICON_DISPELMAGICBEST                     = 58;
int EFFECT_ICON_ABILITY_INCREASE_DEX                = 59;
int EFFECT_ICON_ABILITY_DECREASE_DEX                = 60;
int EFFECT_ICON_ABILITY_INCREASE_CON                = 61;
int EFFECT_ICON_ABILITY_DECREASE_CON                = 62;
int EFFECT_ICON_ABILITY_INCREASE_INT                = 63;
int EFFECT_ICON_ABILITY_DECREASE_INT                = 64;
int EFFECT_ICON_ABILITY_INCREASE_WIS                = 65;
int EFFECT_ICON_ABILITY_DECREASE_WIS                = 66;
int EFFECT_ICON_ABILITY_INCREASE_CHA                = 67;
int EFFECT_ICON_ABILITY_DECREASE_CHA                = 68;
int EFFECT_ICON_IMMUNITY_ALL                        = 69;
int EFFECT_ICON_IMMUNITY_MIND                       = 70;
int EFFECT_ICON_IMMUNITY_POISON                     = 71;
int EFFECT_ICON_IMMUNITY_DISEASE                    = 72;
int EFFECT_ICON_IMMUNITY_FEAR                       = 73;
int EFFECT_ICON_IMMUNITY_TRAP                       = 74;
int EFFECT_ICON_IMMUNITY_PARALYSIS                  = 75;
int EFFECT_ICON_IMMUNITY_BLINDNESS                  = 76;
int EFFECT_ICON_IMMUNITY_DEAFNESS                   = 77;
int EFFECT_ICON_IMMUNITY_SLOW                       = 78;
int EFFECT_ICON_IMMUNITY_ENTANGLE                   = 79;
int EFFECT_ICON_IMMUNITY_SILENCE                    = 80;
int EFFECT_ICON_IMMUNITY_STUN                       = 81;
int EFFECT_ICON_IMMUNITY_SLEEP                      = 82;
int EFFECT_ICON_IMMUNITY_CHARM                      = 83;
int EFFECT_ICON_IMMUNITY_DOMINATE                   = 84;
int EFFECT_ICON_IMMUNITY_CONFUSE                    = 85;
int EFFECT_ICON_IMMUNITY_CURSE                      = 86;
int EFFECT_ICON_IMMUNITY_DAZED                      = 87;
int EFFECT_ICON_IMMUNITY_ABILITY_DECREASE           = 88;
int EFFECT_ICON_IMMUNITY_ATTACK_DECREASE            = 89;
int EFFECT_ICON_IMMUNITY_DAMAGE_DECREASE            = 90;
int EFFECT_ICON_IMMUNITY_DAMAGE_IMMUNITY_DECREASE   = 91;
int EFFECT_ICON_IMMUNITY_AC_DECREASE                = 92;
int EFFECT_ICON_IMMUNITY_MOVEMENT_SPEED_DECREASE    = 93;
int EFFECT_ICON_IMMUNITY_SAVING_THROW_DECREASE      = 94;
int EFFECT_ICON_IMMUNITY_SPELL_RESISTANCE_DECREASE  = 95;
int EFFECT_ICON_IMMUNITY_SKILL_DECREASE             = 96;
int EFFECT_ICON_IMMUNITY_KNOCKDOWN                  = 97;
int EFFECT_ICON_IMMUNITY_NEGATIVE_LEVEL             = 98;
int EFFECT_ICON_IMMUNITY_SNEAK_ATTACK               = 99;
int EFFECT_ICON_IMMUNITY_CRITICAL_HIT               = 100;
int EFFECT_ICON_IMMUNITY_DEATH_MAGIC                = 101;
int EFFECT_ICON_REFLEX_SAVE_INCREASED               = 102;
int EFFECT_ICON_FORT_SAVE_INCREASED                 = 103;
int EFFECT_ICON_WILL_SAVE_INCREASED                 = 104;
int EFFECT_ICON_TAUNTED                             = 105;
int EFFECT_ICON_SPELLIMMUNITY                       = 106;
int EFFECT_ICON_ETHEREALNESS                        = 107;
int EFFECT_ICON_CONCEALMENT                         = 108;
int EFFECT_ICON_PETRIFIED                           = 109;
int EFFECT_ICON_EFFECT_SPELL_FAILURE                = 110;
int EFFECT_ICON_DAMAGE_IMMUNITY_MAGIC               = 111;
int EFFECT_ICON_DAMAGE_IMMUNITY_ACID                = 112;
int EFFECT_ICON_DAMAGE_IMMUNITY_COLD                = 113;
int EFFECT_ICON_DAMAGE_IMMUNITY_DIVINE              = 114;
int EFFECT_ICON_DAMAGE_IMMUNITY_ELECTRICAL          = 115;
int EFFECT_ICON_DAMAGE_IMMUNITY_FIRE                = 116;
int EFFECT_ICON_DAMAGE_IMMUNITY_NEGATIVE            = 117;
int EFFECT_ICON_DAMAGE_IMMUNITY_POSITIVE            = 118;
int EFFECT_ICON_DAMAGE_IMMUNITY_SONIC               = 119;
int EFFECT_ICON_DAMAGE_IMMUNITY_MAGIC_DECREASE      = 120;
int EFFECT_ICON_DAMAGE_IMMUNITY_ACID_DECREASE       = 121;
int EFFECT_ICON_DAMAGE_IMMUNITY_COLD_DECREASE       = 122;
int EFFECT_ICON_DAMAGE_IMMUNITY_DIVINE_DECREASE     = 123;
int EFFECT_ICON_DAMAGE_IMMUNITY_ELECTRICAL_DECREASE = 124;
int EFFECT_ICON_DAMAGE_IMMUNITY_FIRE_DECREASE       = 125;
int EFFECT_ICON_DAMAGE_IMMUNITY_NEGATIVE_DECREASE   = 126;
int EFFECT_ICON_DAMAGE_IMMUNITY_POSITIVE_DECREASE   = 127;
int EFFECT_ICON_DAMAGE_IMMUNITY_SONIC_DECREASE      = 128;
int EFFECT_ICON_WOUNDING                            = 129;

int GUIEVENT_CHATBAR_FOCUS                          = 1;
int GUIEVENT_CHATBAR_UNFOCUS                        = 2;
int GUIEVENT_CHARACTERSHEET_SKILL_CLICK             = 3;
int GUIEVENT_CHARACTERSHEET_FEAT_CLICK              = 4;
int GUIEVENT_EFFECTICON_CLICK                       = 5;
int GUIEVENT_DEATHPANEL_WAITFORHELP_CLICK           = 6;
int GUIEVENT_MINIMAP_MAPPIN_CLICK                   = 7;
int GUIEVENT_MINIMAP_OPEN                           = 8;
int GUIEVENT_MINIMAP_CLOSE                          = 9;
int GUIEVENT_JOURNAL_OPEN                           = 10;
int GUIEVENT_JOURNAL_CLOSE                          = 11;
int GUIEVENT_PLAYERLIST_PLAYER_CLICK                = 12;
int GUIEVENT_PARTYBAR_PORTRAIT_CLICK                = 13;
int GUIEVENT_DISABLED_PANEL_ATTEMPT_OPEN            = 14;
int GUIEVENT_COMPASS_CLICK                          = 15;
int GUIEVENT_LEVELUP_CANCELLED                      = 16;
int GUIEVENT_AREA_LOADSCREEN_FINISHED               = 17;
int GUIEVENT_QUICKCHAT_ACTIVATE                     = 18;
int GUIEVENT_QUICKCHAT_SELECT                       = 19;
int GUIEVENT_QUICKCHAT_CLOSE                        = 20;
int GUIEVENT_SELECT_CREATURE                        = 21;
int GUIEVENT_UNSELECT_CREATURE                      = 22;
int GUIEVENT_EXAMINE_OBJECT                         = 23;
int GUIEVENT_OPTIONS_OPEN                           = 24;
int GUIEVENT_OPTIONS_CLOSE                          = 25;
int GUIEVENT_RADIAL_OPEN                            = 26;
int GUIEVENT_CHATLOG_PORTRAIT_CLICK                 = 27;
int GUIEVENT_PLAYERLIST_PLAYER_TELL                 = 28;

int JSON_TYPE_NULL                                  = 0; // Also invalid
int JSON_TYPE_OBJECT                                = 1;
int JSON_TYPE_ARRAY                                 = 2;
int JSON_TYPE_STRING                                = 3;
int JSON_TYPE_INTEGER                               = 4;
int JSON_TYPE_FLOAT                                 = 5;
int JSON_TYPE_BOOL                                  = 6;

// The player's gui width (inner window bounds).
string PLAYER_DEVICE_PROPERTY_GUI_WIDTH             = "gui_width";
// The player's gui height (inner window bounds).
string PLAYER_DEVICE_PROPERTY_GUI_HEIGHT            = "gui_height";
// The player's gui scale, in percent (factor 1.4 = 140)
string PLAYER_DEVICE_PROPERTY_GUI_SCALE             = "gui_scale";
// Client config values:
string PLAYER_DEVICE_PROPERTY_GRAPHICS_ANTIALIASING_MODE                    = "graphics.video.anti-aliasing.mode";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_ANISOTROPIC_FILTERING                = "graphics.video.anisotropic-filtering.mode";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_GAMMA                                = "graphics.gamma";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_TEXTURE_ANIMATIONS                   = "graphics.texture-animations.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_SKYBOXES                             = "graphics.skyboxes.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_CREATURE_WIND                        = "graphics.creature-wind.mode";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_SECOND_STORY_TILES                   = "graphics.second-story-tiles.mode";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_TILE_BORDERS                         = "graphics.tile-borders.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_SPELL_TARGETING_EFFECT               = "graphics.spell-targeting-effect.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_TEXTURES_PACK                        = "graphics.textures.pack";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_GRASS                                = "graphics.grass.mode";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_GRASS_RENDER_DISTANCE                = "graphics.grass.render-distance";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_SHINY_WATER                          = "graphics.water.shiny";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_LIGHTING_MAX_LIGHTS                  = "graphics.lighting.max-lights";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_LIGHTING_ENHANCED                    = "graphics.lighting.enhanced";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_SHADOWS_ENVIRONMENT                  = "graphics.shadows.environment.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_SHADOWS_CREATURES                    = "graphics.shadows.creatures.mode";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_SHADOWS_MAX_CASTING_LIGHTS           = "graphics.shadows.max-casting-lights";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_EFFECTS_HIGH_QUALITY                 = "graphics.effects.high-quality";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_EFFECTS_CREATURE_ENVIRONMENT_MAPPING = "graphics.effects.creature-environment-mapping";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_KEYHOLING                            = "graphics.keyholing.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_KEYHOLING_WITH_TOOLTIP               = "graphics.keyholing.with-tooltip";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_KEYHOLING_DISABLES_CAMERA_COLLISIONS = "graphics.keyholing.disables-camera-collisions";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_FBO_SSAO                             = "graphics.fbo.ssao.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_FBO_HIGH_CONTRAST                    = "graphics.fbo.high-contrast.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_FBO_VIBRANCE                         = "graphics.fbo.vibrance.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_FBO_TOON                             = "graphics.fbo.toon.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_FBO_DOF                              = "graphics.fbo.dof.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_LOD                                  = "graphics.lod.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_RENDER_CLOAKS                        = "graphics.experimental.render-cloaks";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_GENERATE_PLT_WITH_SHADERS            = "graphics.experimental.generate-plt-with-shaders";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_HILITE                               = "graphics.hilite.enabled";
string PLAYER_DEVICE_PROPERTY_GRAPHICS_HILITE_GLOW                          = "graphics.hilite.glow";
string PLAYER_DEVICE_PROPERTY_INPUT_KEYBOARD_SHIFT_WALK_INVERTED            = "input.keyboard.shift-walk-mode-inverted";
string PLAYER_DEVICE_PROPERTY_INPUT_MOUSE_HARDWARE_POINTER                  = "input.mouse.hardware-pointer";
string PLAYER_DEVICE_PROPERTY_UI_SCALE                                      = "ui.scale";
string PLAYER_DEVICE_PROPERTY_UI_LARGE_FONT                                 = "ui.large-font";
string PLAYER_DEVICE_PROPERTY_UI_TOOLTIP_DELAY                              = "ui.tooltip-delay";
string PLAYER_DEVICE_PROPERTY_UI_MOUSEOVER_FEEDBACK                         = "ui.mouseover-feedback";
string PLAYER_DEVICE_PROPERTY_UI_TEXT_BUBBLE                                = "ui.text-bubble-mode";
string PLAYER_DEVICE_PROPERTY_UI_TARGETING_FEEDBACK                         = "ui.targeting-feedback-mode";
string PLAYER_DEVICE_PROPERTY_UI_CAN_CLICK_SELF_WHILE_WALKING               = "ui.can-click-self-while-walking";
string PLAYER_DEVICE_PROPERTY_UI_FLOATING_TEXT_FEEDBACK                     = "ui.floating-text-feedback";
string PLAYER_DEVICE_PROPERTY_UI_FLOATING_TEXT_FEEDBACK_DAMAGE_TOTALS_ONLY  = "ui.floating-text-feedback-damage-totals-only";
string PLAYER_DEVICE_PROPERTY_UI_HIDE_QUICKCHAT_TEXT_IN_CHAT_WINDOW         = "ui.hide-quick-chat-text-in-chat-window";
string PLAYER_DEVICE_PROPERTY_UI_CONFIRM_SELFCAST_SPELLS                    = "ui.confirm-self-cast-spells";
string PLAYER_DEVICE_PROPERTY_UI_CONFIRM_SELFCAST_FEATS                     = "ui.confirm-self-cast-feats";
string PLAYER_DEVICE_PROPERTY_UI_CONFIRM_SELFCAST_ITEMS                     = "ui.confirm-self-cast-items";
string PLAYER_DEVICE_PROPERTY_UI_CHARGEN_SORT_CLASSES                       = "ui.chargen.sort-classes";
string PLAYER_DEVICE_PROPERTY_UI_CHAT_PANE_PRIMARY_HEIGHT                   = "ui.chat.pane.primary.height";
string PLAYER_DEVICE_PROPERTY_UI_CHAT_PANE_SECONDARY_HEIGHT                 = "ui.chat.pane.secondary.height";
string PLAYER_DEVICE_PROPERTY_UI_CHAT_SWEAR_FILTER                          = "ui.chat.swear-filter.enabled";
string PLAYER_DEVICE_PROPERTY_UI_PARTY_INVITE_POPUP                         = "ui.party.invite-popup.enabled";
string PLAYER_DEVICE_PROPERTY_UI_SPELLBOOK_SORT_SPELLS                      = "ui.spellbook.sort-spells";
string PLAYER_DEVICE_PROPERTY_UI_RADIAL_SPELLCASTING_ALWAYS_SUBRADIAL       = "ui.radial.spellcasting.always-show-as-subradial";
string PLAYER_DEVICE_PROPERTY_UI_RADIAL_CLASS_ABILITIES_ALWAYS_SUBRADIAL    = "ui.radial.class-abilities.always-show-as-subradial";
string PLAYER_DEVICE_PROPERTY_UI_DISPLAY_LOADSCREEN_HINTS_IN_CHATLOG        = "ui.display-loadscreen-hints-in-chatlog";
string PLAYER_DEVICE_PROPERTY_UI_MOUSE_SCALE                                = "ui.mouse.scale.enabled";
string PLAYER_DEVICE_PROPERTY_UI_MOUSE_SCALE_VALUE                          = "ui.mouse.scale.value";
string PLAYER_DEVICE_PROPERTY_CAMERA_MODE                                   = "camera.mode";
string PLAYER_DEVICE_PROPERTY_CAMERA_EDGE_TURNING                           = "camera.edge-turning";
string PLAYER_DEVICE_PROPERTY_CAMERA_DIALOG_ZOOM                            = "camera.dialog-zoom";
string PLAYER_DEVICE_PROPERTY_GAME_GORE                                     = "game.gore";

int PLAYER_LANGUAGE_INVALID                         = -1;
int PLAYER_LANGUAGE_ENGLISH                         = 0;
int PLAYER_LANGUAGE_FRENCH                          = 1;
int PLAYER_LANGUAGE_GERMAN                          = 2;
int PLAYER_LANGUAGE_ITALIAN                         = 3;
int PLAYER_LANGUAGE_SPANISH                         = 4;
int PLAYER_LANGUAGE_POLISH                          = 5;

int PLAYER_DEVICE_PLATFORM_INVALID                  = 0;
int PLAYER_DEVICE_PLATFORM_WINDOWS_X86              = 1;
int PLAYER_DEVICE_PLATFORM_WINDOWS_X64              = 2;
int PLAYER_DEVICE_PLATFORM_LINUX_X86                = 10;
int PLAYER_DEVICE_PLATFORM_LINUX_X64                = 11;
int PLAYER_DEVICE_PLATFORM_LINUX_ARM32              = 12;
int PLAYER_DEVICE_PLATFORM_LINUX_ARM64              = 13;
int PLAYER_DEVICE_PLATFORM_MAC_X86                  = 20;
int PLAYER_DEVICE_PLATFORM_MAC_X64                  = 21;
int PLAYER_DEVICE_PLATFORM_MAC_ARM64                = 22;
int PLAYER_DEVICE_PLATFORM_IOS                      = 30;
int PLAYER_DEVICE_PLATFORM_ANDROID_ARM32            = 40;
int PLAYER_DEVICE_PLATFORM_ANDROID_ARM64            = 41;
int PLAYER_DEVICE_PLATFORM_ANDROID_X64              = 42;
int PLAYER_DEVICE_PLATFORM_NINTENDO_SWITCH          = 50;
int PLAYER_DEVICE_PLATFORM_MICROSOFT_XBOXONE        = 60;
int PLAYER_DEVICE_PLATFORM_SONY_PS4                 = 70;

int RESTYPE_RES                                     = 0;
int RESTYPE_BMP                                     = 1;
int RESTYPE_MVE                                     = 2;
int RESTYPE_TGA                                     = 3;
int RESTYPE_WAV                                     = 4;
int RESTYPE_WFX                                     = 5;
int RESTYPE_PLT                                     = 6;
int RESTYPE_INI                                     = 7;
int RESTYPE_MP3                                     = 8;
int RESTYPE_MPG                                     = 9;
int RESTYPE_TXT                                     = 10;
int RESTYPE_KEY                                     = 9999;
int RESTYPE_BIF                                     = 9998;
int RESTYPE_ERF                                     = 9997;
int RESTYPE_IDS                                     = 9996;
int RESTYPE_PLH                                     = 2000;
int RESTYPE_TEX                                     = 2001;
int RESTYPE_MDL                                     = 2002;
int RESTYPE_THG                                     = 2003;
int RESTYPE_FNT                                     = 2005;
int RESTYPE_LUA                                     = 2007;
int RESTYPE_SLT                                     = 2008;
int RESTYPE_NSS                                     = 2009;
int RESTYPE_NCS                                     = 2010;
int RESTYPE_MOD                                     = 2011;
int RESTYPE_ARE                                     = 2012;
int RESTYPE_SET                                     = 2013;
int RESTYPE_IFO                                     = 2014;
int RESTYPE_BIC                                     = 2015;
int RESTYPE_WOK                                     = 2016;
int RESTYPE_2DA                                     = 2017;
int RESTYPE_TLK                                     = 2018;
int RESTYPE_TXI                                     = 2022;
int RESTYPE_GIT                                     = 2023;
int RESTYPE_BTI                                     = 2024;
int RESTYPE_UTI                                     = 2025;
int RESTYPE_BTC                                     = 2026;
int RESTYPE_UTC                                     = 2027;
int RESTYPE_DLG                                     = 2029;
int RESTYPE_ITP                                     = 2030;
int RESTYPE_BTT                                     = 2031;
int RESTYPE_UTT                                     = 2032;
int RESTYPE_DDS                                     = 2033;
int RESTYPE_BTS                                     = 2034;
int RESTYPE_UTS                                     = 2035;
int RESTYPE_LTR                                     = 2036;
int RESTYPE_GFF                                     = 2037;
int RESTYPE_FAC                                     = 2038;
int RESTYPE_BTE                                     = 2039;
int RESTYPE_UTE                                     = 2040;
int RESTYPE_BTD                                     = 2041;
int RESTYPE_UTD                                     = 2042;
int RESTYPE_BTP                                     = 2043;
int RESTYPE_UTP                                     = 2044;
int RESTYPE_DFT                                     = 2045;
int RESTYPE_GIC                                     = 2046;
int RESTYPE_GUI                                     = 2047;
int RESTYPE_CSS                                     = 2048;
int RESTYPE_CCS                                     = 2049;
int RESTYPE_BTM                                     = 2050;
int RESTYPE_UTM                                     = 2051;
int RESTYPE_DWK                                     = 2052;
int RESTYPE_PWK                                     = 2053;
int RESTYPE_BTG                                     = 2054;
int RESTYPE_UTG                                     = 2055;
int RESTYPE_JRL                                     = 2056;
int RESTYPE_SAV                                     = 2057;
int RESTYPE_UTW                                     = 2058;
int RESTYPE_4PC                                     = 2059;
int RESTYPE_SSF                                     = 2060;
int RESTYPE_HAK                                     = 2061;
int RESTYPE_NWM                                     = 2062;
int RESTYPE_BIK                                     = 2063;
int RESTYPE_NDB                                     = 2064;
int RESTYPE_PTM                                     = 2065;
int RESTYPE_PTT                                     = 2066;
int RESTYPE_BAK                                     = 2067;
int RESTYPE_DAT                                     = 2068;
int RESTYPE_SHD                                     = 2069;
int RESTYPE_XBC                                     = 2070;
int RESTYPE_WBM                                     = 2071;
int RESTYPE_MTR                                     = 2072;
int RESTYPE_KTX                                     = 2073;
int RESTYPE_TTF                                     = 2074;
int RESTYPE_SQL                                     = 2075;
int RESTYPE_TML                                     = 2076;
int RESTYPE_SQ3                                     = 2077;
int RESTYPE_LOD                                     = 2078;
int RESTYPE_GIF                                     = 2079;
int RESTYPE_PNG                                     = 2080;
int RESTYPE_JPG                                     = 2081;
int RESTYPE_CAF                                     = 2082;
int RESTYPE_JUI                                     = 2083;
int RESTYPE_CDB                                     = 2084;

int RESMAN_FILE_CONTENTS_FORMAT_RAW                 = 0;
int RESMAN_FILE_CONTENTS_FORMAT_BASE64              = 1;
int RESMAN_FILE_CONTENTS_FORMAT_HEX                 = 2;

// For JsonArrayTransform():
int JSON_ARRAY_SORT_ASCENDING                       = 1;
int JSON_ARRAY_SORT_DESCENDING                      = 2;
int JSON_ARRAY_SHUFFLE                              = 3;
int JSON_ARRAY_REVERSE                              = 4;
int JSON_ARRAY_UNIQUE                               = 5;
int JSON_ARRAY_COALESCE                             = 6;

int JSON_FIND_EQUAL                                 = 0;
int JSON_FIND_LT                                    = 1;
int JSON_FIND_LTE                                   = 2;
int JSON_FIND_GT                                    = 3;
int JSON_FIND_GTE                                   = 4;

int JSON_SET_SUBSET                                 = 1;
int JSON_SET_UNION                                  = 2;
int JSON_SET_INTERSECT                              = 3;
int JSON_SET_DIFFERENCE                             = 4;
int JSON_SET_SYMMETRIC_DIFFERENCE                   = 5;

// For SetShaderUniform*():

int SHADER_UNIFORM_1                                = 0;
int SHADER_UNIFORM_2                                = 1;
int SHADER_UNIFORM_3                                = 2;
int SHADER_UNIFORM_4                                = 3;
int SHADER_UNIFORM_5                                = 4;
int SHADER_UNIFORM_6                                = 5;
int SHADER_UNIFORM_7                                = 6;
int SHADER_UNIFORM_8                                = 7;
int SHADER_UNIFORM_9                                = 8;
int SHADER_UNIFORM_10                               = 9;
int SHADER_UNIFORM_11                               = 10;
int SHADER_UNIFORM_12                               = 11;
int SHADER_UNIFORM_13                               = 12;
int SHADER_UNIFORM_14                               = 13;
int SHADER_UNIFORM_15                               = 14;
int SHADER_UNIFORM_16                               = 15;

// For SetSpellTargetingData():

int SPELL_TARGETING_SHAPE_NONE                      = 0;
int SPELL_TARGETING_SHAPE_SPHERE                    = 1;
int SPELL_TARGETING_SHAPE_RECT                      = 2;
int SPELL_TARGETING_SHAPE_CONE                      = 3;
int SPELL_TARGETING_SHAPE_HSPHERE                   = 4;

int SPELL_TARGETING_FLAGS_NONE                      = 0;
int SPELL_TARGETING_FLAGS_HARMS_ENEMIES             = 1;
int SPELL_TARGETING_FLAGS_HARMS_ALLIES              = 2;
int SPELL_TARGETING_FLAGS_HELPS_ALLIES              = 4;
int SPELL_TARGETING_FLAGS_IGNORES_SELF              = 8;
int SPELL_TARGETING_FLAGS_ORIGIN_ON_SELF            = 16;
int SPELL_TARGETING_FLAGS_SUPPRESS_WITH_TARGET      = 32;

// These constants are for RegExpMatch() and RegExpIterate() only; do not mix with RegExpReplace():
//
// At most one grammar option must be chosen out of ECMAScript, basic, extended, awk, grep, egrep:
//
// Use the Modified ECMAScript regular expression grammar (https://en.cppreference.com/w/cpp/regex/ecmascript)
int REGEXP_ECMASCRIPT                               =   0;
// Use the basic POSIX regular expression grammar (http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html#tag_09_03).
int REGEXP_BASIC                                    =   1;
// Use the extended POSIX regular expression grammar (http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html#tag_09_04).
int REGEXP_EXTENDED                                 =   2;
// Use the regular expression grammar used by the awk utility in POSIX (http://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html#tag_20_06_13_04).
int REGEXP_AWK                                      =   4;
// Use the regular expression grammar used by the grep utility in POSIX. This is effectively the same as the basic option with the addition of newline '\n' as an alternation separator.
int REGEXP_GREP                                     =   8;
// Use the regular expression grammar used by the grep utility, with the -E option, in POSIX. This is effectively the same as the extended option with the addition of newline '\n' as an alternation separator in addition to '|'.
int REGEXP_EGREP                                    =  16;
// Character matching should be performed without regard to case.
int REGEXP_ICASE                                    =  32;
// When performing matches, all marked sub-expressions (expr) are treated as non-marking sub-expressions (?:expr).
int REGEXP_NOSUBS                                   =  64;

// These constants are for RegExpReplace() only, do not mix with other RegExp functions:
//
// The first character in [first,last) will be treated as if it is not at the beginning of a line (i.e. ^ will not match [first,first)
int REGEXP_MATCH_NOT_BOL                            = 1;
// The last character in [first,last) will be treated as if it is not at the end of a line (i.e. $ will not match [last,last)
int REGEXP_MATCH_NOT_EOL                            = 2;
// "\b" will not match [first,first)
int REGEXP_MATCH_NOT_BOW                            = 4;
// "\b" will not match [last,last)
int REGEXP_MATCH_NOT_EOW                            = 8;
// If more than one match is possible, then any match is an acceptable result
int REGEXP_MATCH_ANY                                = 16;
// Do not match empty sequences
int REGEXP_MATCH_NOT_NULL                           = 32;
// Only match a sub-sequence that begins at first
int REGEXP_MATCH_CONTINUOUS                         = 64;
// --first is a valid iterator position. When set, causes match_not_bol and match_not_bow to be ignored
int REGEXP_MATCH_PREV_AVAIL                         = 128;
// Use ECMAScript rules to construct strings (http://ecma-international.org/ecma-262/5.1/#sec-15.5.4.11)
int REGEXP_FORMAT_DEFAULT                           = 0;
// Use POSIX sed utility rules (http://pubs.opengroup.org/onlinepubs/9699919799/utilities/sed.html#tag_20_116_13_03)
int REGEXP_FORMAT_SED                               = 256;
// Do not copy un-matched strings to the output
int REGEXP_FORMAT_NO_COPY                           = 512;
// Only replace the first match
int REGEXP_FORMAT_FIRST_ONLY                        = 1024;

int OBJECT_UI_DISCOVERY_DEFAULT                     = -1;
int OBJECT_UI_DISCOVERY_NONE                        = 0;
int OBJECT_UI_DISCOVERY_HILITE_MOUSEOVER            = 1;
int OBJECT_UI_DISCOVERY_HILITE_TAB                  = 2;
int OBJECT_UI_DISCOVERY_TEXTBUBBLE_MOUSEOVER        = 4;
int OBJECT_UI_DISCOVERY_TEXTBUBBLE_TAB              = 8;

int OBJECT_UI_TEXT_BUBBLE_OVERRIDE_NONE             = 0;
int OBJECT_UI_TEXT_BUBBLE_OVERRIDE_REPLACE          = 1;
int OBJECT_UI_TEXT_BUBBLE_OVERRIDE_PREPEND          = 2;
int OBJECT_UI_TEXT_BUBBLE_OVERRIDE_APPEND           = 3;

int CAMERA_FLAG_ENABLE_COLLISION                    = 1;
int CAMERA_FLAG_DISABLE_COLLISION                   = 2;
int CAMERA_FLAG_DISABLE_SHAKE                       = 4;
int CAMERA_FLAG_DISABLE_SCROLL                      = 8;
int CAMERA_FLAG_DISABLE_TURN                        = 16;
int CAMERA_FLAG_DISABLE_TILT                        = 32;
int CAMERA_FLAG_DISABLE_ZOOM                        = 64;

int SETTILE_FLAG_RELOAD_GRASS                       = 1;
int SETTILE_FLAG_RELOAD_BORDER                      = 2;
int SETTILE_FLAG_RECOMPUTE_LIGHTING                 = 4;

int AUDIOSTREAM_IDENTIFIER_0                        = 0;
int AUDIOSTREAM_IDENTIFIER_1                        = 1;
int AUDIOSTREAM_IDENTIFIER_2                        = 2;
int AUDIOSTREAM_IDENTIFIER_3                        = 3;
int AUDIOSTREAM_IDENTIFIER_4                        = 4;
int AUDIOSTREAM_IDENTIFIER_5                        = 5;
int AUDIOSTREAM_IDENTIFIER_6                        = 6;
int AUDIOSTREAM_IDENTIFIER_7                        = 7;
int AUDIOSTREAM_IDENTIFIER_8                        = 8;
int AUDIOSTREAM_IDENTIFIER_9                        = 9;

int SPELL_FAILURE_TYPE_ALL                          = 0;
int SPELL_FAILURE_TYPE_ARCANE                       = 1;

string sLanguage = "nwscript";

// Get an integer between 0 and nMaxInteger-1.
// Return value on error: 0
int Random(int nMaxInteger);

// Output sString to the log file.
void PrintString(string sString);

// Output a formatted float to the log file.
// - nWidth should be a value from 0 to 18 inclusive.
// - nDecimals should be a value from 0 to 9 inclusive.
void PrintFloat(float fFloat, int nWidth=18, int nDecimals=9);

// Convert fFloat into a string.
// - nWidth should be a value from 0 to 18 inclusive.
// - nDecimals should be a value from 0 to 9 inclusive.
string FloatToString(float fFloat, int nWidth=18, int nDecimals=9);

// Output nInteger to the log file.
void PrintInteger(int nInteger);

// Output oObject's ID to the log file.
void PrintObject(object oObject);

// Assign aActionToAssign to oActionSubject.
// * No return value, but if an error occurs, the log file will contain
//   "AssignCommand failed."
//   (If the object doesn't exist, nothing happens.)
void AssignCommand(object oActionSubject,action aActionToAssign);

// Delay aActionToDelay by fSeconds.
// * No return value, but if an error occurs, the log file will contain
//   "DelayCommand failed.".
// It is suggested that functions which create effects should not be used
// as parameters to delayed actions.  Instead, the effect should be created in the
// script and then passed into the action.  For example:
// effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
// DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
void DelayCommand(float fSeconds, action aActionToDelay);

// Make oTarget run sScript and then return execution to the calling script.
// If sScript does not specify a compiled script, nothing happens.
void ExecuteScript(string sScript, object oTarget = OBJECT_SELF);

// Clear all the actions of oObject.
// * No return value, but if an error occurs, the log file will contain
//   "ClearAllActions failed.".
// - nClearCombatState: if true, this will immediately clear the combat state
//   on a creature, which will stop the combat music and allow them to rest,
//   engage in dialog, or other actions that they would normally have to wait for.
void ClearAllActions(int nClearCombatState=FALSE, object oObject = OBJECT_SELF);

// Cause oObject to face fDirection.
// - fDirection is expressed as anticlockwise degrees from Due East.
//   DIRECTION_EAST, DIRECTION_NORTH, DIRECTION_WEST and DIRECTION_SOUTH are
//   predefined. (0.0f=East, 90.0f=North, 180.0f=West, 270.0f=South)
void SetFacing(float fDirection, object oObject = OBJECT_SELF);

// Set the calendar to the specified date.
// - nYear should be from 0 to 32000 inclusive
// - nMonth should be from 1 to 12 inclusive
// - nDay should be from 1 to 28 inclusive
// 1) Time can only be advanced forwards; attempting to set the time backwards
//    will result in no change to the calendar.
// 2) If values larger than the month or day are specified, they will be wrapped
//    around and the overflow will be used to advance the next field.
//    e.g. Specifying a year of 1350, month of 33 and day of 10 will result in
//    the calender being set to a year of 1352, a month of 9 and a day of 10.
void SetCalendar(int nYear,int nMonth, int nDay);

// Set the time to the time specified.
// - nHour should be from 0 to 23 inclusive
// - nMinute should be from 0 to 59 inclusive
// - nSecond should be from 0 to 59 inclusive
// - nMillisecond should be from 0 to 999 inclusive
// 1) Time can only be advanced forwards; attempting to set the time backwards
//    will result in the day advancing and then the time being set to that
//    specified, e.g. if the current hour is 15 and then the hour is set to 3,
//    the day will be advanced by 1 and the hour will be set to 3.
// 2) If values larger than the max hour, minute, second or millisecond are
//    specified, they will be wrapped around and the overflow will be used to
//    advance the next field, e.g. specifying 62 hours, 250 minutes, 10 seconds
//    and 10 milliseconds will result in the calendar day being advanced by 2
//    and the time being set to 18 hours, 10 minutes, 10 milliseconds.
void SetTime(int nHour,int nMinute,int nSecond,int nMillisecond);

// Get the current calendar year.
int GetCalendarYear();

// Get the current calendar month.
int GetCalendarMonth();

// Get the current calendar day.
int GetCalendarDay();

// Get the current hour.
int GetTimeHour();

// Get the current minute
int GetTimeMinute();

// Get the current second
int GetTimeSecond();

// Get the current millisecond
int GetTimeMillisecond();

// The action subject will generate a random location near its current location
// and pathfind to it.  ActionRandomwalk never ends, which means it is neccessary
// to call ClearAllActions in order to allow a creature to perform any other action
// once ActionRandomWalk has been called.
// * No return value, but if an error occurs the log file will contain
//   "ActionRandomWalk failed."
void ActionRandomWalk();

// The action subject will move to lDestination.
// - lDestination: The object will move to this location.  If the location is
//   invalid or a path cannot be found to it, the command does nothing.
// - bRun: If this is TRUE, the action subject will run rather than walk
// * No return value, but if an error occurs the log file will contain
//   "MoveToPoint failed."
void ActionMoveToLocation(location lDestination, int bRun=FALSE);

// Cause the action subject to move to a certain distance from oMoveTo.
// If there is no path to oMoveTo, this command will do nothing.
// - oMoveTo: This is the object we wish the action subject to move to
// - bRun: If this is TRUE, the action subject will run rather than walk
// - fRange: This is the desired distance between the action subject and oMoveTo
// * No return value, but if an error occurs the log file will contain
//   "ActionMoveToObject failed."
void ActionMoveToObject(object oMoveTo, int bRun=FALSE, float fRange=1.0f);

// Cause the action subject to move to a certain distance away from oFleeFrom.
// - oFleeFrom: This is the object we wish the action subject to move away from.
//   If oFleeFrom is not in the same area as the action subject, nothing will
//   happen.
// - bRun: If this is TRUE, the action subject will run rather than walk
// - fMoveAwayRange: This is the distance we wish the action subject to put
//   between themselves and oFleeFrom
// * No return value, but if an error occurs the log file will contain
//   "ActionMoveAwayFromObject failed."
void ActionMoveAwayFromObject(object oFleeFrom, int bRun=FALSE, float fMoveAwayRange=40.0f);

// Get the area that oTarget is currently in
// * Return value on error: OBJECT_INVALID
object GetArea(object oTarget);

// The value returned by this function depends on the object type of the caller:
// 1) If the caller is a door it returns the object that last
//    triggered it.
// 2) If the caller is a trigger, area of effect, module, area or encounter it
//    returns the object that last entered it.
// * Return value on error: OBJECT_INVALID
//  When used for doors, this should only be called from the OnAreaTransitionClick
//  event.  Otherwise, it should only be called in OnEnter scripts.
object GetEnteringObject();

// Get the object that last left the caller.  This function works on triggers,
// areas of effect, modules, areas and encounters.
// * Return value on error: OBJECT_INVALID
// Should only be called in OnExit scripts.
object GetExitingObject();

// Get the position of oTarget
// * Return value on error: vector (0.0f, 0.0f, 0.0f)
vector GetPosition(object oTarget);

// Get the direction in which oTarget is facing, expressed as a float between
// 0.0f and 360.0f
// * Return value on error: -1.0f
float GetFacing(object oTarget);

// Get the possessor of oItem
// - bReturnBags: If TRUE will potentially return a bag container item the item is in, instead of
//                the object holding the bag. Make sure to check the returning item object type with this flag.
// * Return value on error: OBJECT_INVALID
object GetItemPossessor(object oItem, int bReturnBags = FALSE);

// Get the object possessed by oCreature with the tag sItemTag
// * Return value on error: OBJECT_INVALID
object GetItemPossessedBy(object oCreature, string sItemTag);

// Create an item with the template sItemTemplate in oTarget's inventory.
// - nStackSize: This is the stack size of the item to be created
// - sNewTag: If this string is not empty, it will replace the default tag from the template
// * Return value: The object that has been created.  On error, this returns
//   OBJECT_INVALID.
// If the item created was merged into an existing stack of similar items,
// the function will return the merged stack object. If the merged stack
// overflowed, the function will return the overflowed stack that was created.
object CreateItemOnObject(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="");

// Equip oItem into nInventorySlot.
// - nInventorySlot: INVENTORY_SLOT_*
// * No return value, but if an error occurs the log file will contain
//   "ActionEquipItem failed."
//
// Note:
//       If the creature already has an item equipped in the slot specified, it will be
//       unequipped automatically by the call to ActionEquipItem.
//
//       In order for ActionEquipItem to succeed the creature must be able to equip the
//       item oItem normally. This means that:
//       1) The item is in the creature's inventory.
//       2) The item must already be identified (if magical).
//       3) The creature has the level required to equip the item (if magical and ILR is on).
//       4) The creature possesses the required feats to equip the item (such as weapon proficiencies).
void ActionEquipItem(object oItem, int nInventorySlot);

// Unequip oItem from whatever slot it is currently in.
void ActionUnequipItem(object oItem);

// Pick up oItem from the ground.
// * No return value, but if an error occurs the log file will contain
//   "ActionPickUpItem failed."
void ActionPickUpItem(object oItem);

// Put down oItem on the ground.
// * No return value, but if an error occurs the log file will contain
//   "ActionPutDownItem failed."
void ActionPutDownItem(object oItem);

// Get the last attacker of oAttackee.  This should only be used ONLY in the
// OnAttacked events for creatures, placeables and doors.
// * Return value on error: OBJECT_INVALID
object GetLastAttacker(object oAttackee=OBJECT_SELF);

// Attack oAttackee.
// - bPassive: If this is TRUE, attack is in passive mode.
void ActionAttack(object oAttackee, int bPassive=FALSE);

// Get the creature nearest to oTarget, subject to all the criteria specified.
// - nFirstCriteriaType: CREATURE_TYPE_*
// - nFirstCriteriaValue:
//   -> CLASS_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_CLASS
//   -> SPELL_* if nFirstCriteriaType was CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT
//      or CREATURE_TYPE_HAS_SPELL_EFFECT
//   -> TRUE or FALSE if nFirstCriteriaType was CREATURE_TYPE_IS_ALIVE
//   -> PERCEPTION_* if nFirstCriteriaType was CREATURE_TYPE_PERCEPTION
//   -> PLAYER_CHAR_IS_PC or PLAYER_CHAR_NOT_PC if nFirstCriteriaType was
//      CREATURE_TYPE_PLAYER_CHAR
//   -> RACIAL_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_RACIAL_TYPE
//   -> REPUTATION_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_REPUTATION
//   For example, to get the nearest PC, use:
//   (CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC)
// - oTarget: We're trying to find the creature of the specified type that is
//   nearest to oTarget
// - nNth: We don't have to find the first nearest: we can find the Nth nearest...
// - nSecondCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nSecondCriteriaValue: This is used in the same way as nFirstCriteriaValue
//   to further specify the type of creature that we are looking for.
// - nThirdCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nThirdCriteriaValue: This is used in the same way as nFirstCriteriaValue to
//   further specify the type of creature that we are looking for.
// * Return value on error: OBJECT_INVALID
object GetNearestCreature(int nFirstCriteriaType, int nFirstCriteriaValue, object oTarget=OBJECT_SELF, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1,  int nThirdCriteriaValue=-1 );

// Add a speak action to the action subject.
// - sStringToSpeak: String to be spoken
// - nTalkVolume: TALKVOLUME_*
void ActionSpeakString(string sStringToSpeak, int nTalkVolume=TALKVOLUME_TALK);

// Cause the action subject to play an animation
// - nAnimation: ANIMATION_*
// - fSpeed: Speed of the animation
// - fDurationSeconds: Duration of the animation (this is not used for Fire and
//   Forget animations)
void ActionPlayAnimation(int nAnimation, float fSpeed=1.0, float fDurationSeconds=0.0);

// Get the distance from oFrom to oObject in metres.
// * Return value on error: -1.0f
float GetDistanceToObject(object oObject, object oFrom = OBJECT_SELF);

// * Returns TRUE if oObject is a valid object.
int GetIsObjectValid(object oObject);

// Cause the action subject to open oDoor
// - bRun: If TRUE, subject will run to the door instead of walking
void ActionOpenDoor(object oDoor, int bRun = FALSE);

// Cause the action subject to close oDoor
// - bRun: If TRUE, subject will run to the door instead of walking
void ActionCloseDoor(object oDoor, int bRun = FALSE);

// Change the direction in which the camera is facing
// - fDirection is expressed as anticlockwise degrees from Due East.
//   (0.0f=East, 90.0f=North, 180.0f=West, 270.0f=South)
// A value of -1.0f for any parameter will be ignored and instead it will
// use the current camera value.
// This can be used to change the way the camera is facing after the player
// emerges from an area transition.
// - nTransitionType: CAMERA_TRANSITION_TYPE_*  SNAP will immediately move the
//   camera to the new position, while the other types will result in the camera moving gradually into position
// Pitch and distance are limited to valid values for the current camera mode:
// Top Down: Distance = 5-20, Pitch = 1-50
// Driving camera: Distance = 6 (can't be changed), Pitch = 1-62
// Chase: Distance = 5-20, Pitch = 1-50
// *** NOTE *** In NWN:Hordes of the Underdark the camera limits have been relaxed to the following:
// Distance 1-25
// Pitch 1-89
void SetCameraFacing(float fDirection, float fDistance = -1.0f, float fPitch = -1.0, int nTransitionType=CAMERA_TRANSITION_TYPE_SNAP);

// Play sSoundName
// - sSoundName: TBD - SS
// This will play a mono sound from the location of the object running the command.
void PlaySound(string sSoundName);

// Get the object at which the caller last cast a spell
// * Return value on error: OBJECT_INVALID
object GetSpellTargetObject();

// This action casts a spell at oTarget.
// - nSpell: SPELL_*
// - oTarget: Target for the spell
// - nMetaMagic: METAMAGIC_*. If nClass is specified, cannot be METAMAGIC_ANY.
// - bCheat: If this is TRUE, then the executor of the action doesn't have to be
//   able to cast the spell. Ignored if nClass is specified.
// - bCheat: If this is TRUE, then the executor of the action doesn't have to be
//   able to cast the spell.
// - nDomainLevel: The level of the spell if cast from a domain slot.
//   eg SPELL_HEAL can be spell level 5 on a cleric. Use 0 for no domain slot.
// - nProjectilePathType: PROJECTILE_PATH_TYPE_*
// - bInstantSpell: If this is TRUE, the spell is cast immediately. This allows
//   the end-user to simulate a high-level magic-user having lots of advance
//   warning of impending trouble
// - nClass: If set to a CLASS_TYPE_* it will cast using that class specifically.
//   CLASS_TYPE_INVALID will use spell abilities.
// - bSpontaneousCast: If set to TRUE will attempt to cast the given spell spontaneously,
//   ie a Cleric casting Cure Light Wounds using any level 1 slot. Needs a valid nClass set.
void ActionCastSpellAtObject(int nSpell, object oTarget, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nDomainLevel=0, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE, int nClass=-1, int bSpontaneousCast=FALSE);

// Get the current hitpoints of oObject
// * Return value on error: 0
int GetCurrentHitPoints(object oObject=OBJECT_SELF);

// Get the maximum hitpoints of oObject
// * Return value on error: 0
int GetMaxHitPoints(object oObject=OBJECT_SELF);

// Get oObject's local integer variable sVarName
// * Return value on error: 0
int GetLocalInt(object oObject, string sVarName);

// Get oObject's local float variable sVarName
// * Return value on error: 0.0f
float GetLocalFloat(object oObject, string sVarName);

// Get oObject's local string variable sVarName
// * Return value on error: ""
string GetLocalString(object oObject, string sVarName);

// Get oObject's local object variable sVarName
// * Return value on error: OBJECT_INVALID
object GetLocalObject(object oObject, string sVarName);

// Set oObject's local integer variable sVarName to nValue
void SetLocalInt(object oObject, string sVarName, int nValue);

// Set oObject's local float variable sVarName to nValue
void SetLocalFloat(object oObject, string sVarName, float fValue);

// Set oObject's local string variable sVarName to nValue
void SetLocalString(object oObject, string sVarName, string sValue);

// Set oObject's local object variable sVarName to nValue
void SetLocalObject(object oObject, string sVarName, object oValue);

// Get the length of sString
// * Return value on error: -1
int GetStringLength(string sString);

// Convert sString into upper case
// * Return value on error: ""
string GetStringUpperCase(string sString);

// Convert sString into lower case
// * Return value on error: ""
string GetStringLowerCase(string sString);

// Get nCount characters from the right end of sString
// * Return value on error: ""
string GetStringRight(string sString, int nCount);

// Get nCounter characters from the left end of sString
// * Return value on error: ""
string GetStringLeft(string sString, int nCount);

// Insert sString into sDestination at nPosition
// * Return value on error: ""
string InsertString(string sDestination, string sString, int nPosition);

// Get nCount characters from sString, starting at nStart
// * Return value on error: ""
string GetSubString(string sString, int nStart, int nCount);

// Find the position of sSubstring inside sString
// - nStart: The character position to start searching at (from the left end of the string).
// * Return value on error: -1
int FindSubString(string sString, string sSubString, int nStart=0);

// math operations

// Maths operation: absolute value of fValue
float fabs(float fValue);

// Maths operation: cosine of fValue
float cos(float fValue);

// Maths operation: sine of fValue
float sin(float fValue);

// Maths operation: tan of fValue
float tan(float fValue);

// Maths operation: arccosine of fValue
// * Returns zero if fValue > 1 or fValue < -1
float acos(float fValue);

// Maths operation: arcsine of fValue
// * Returns zero if fValue >1 or fValue < -1
float asin(float fValue);

// Maths operation: arctan of fValue
float atan(float fValue);

// Maths operation: log of fValue
// * Returns zero if fValue <= zero
float log(float fValue);

// Maths operation: fValue is raised to the power of fExponent
// * Returns zero if fValue ==0 and fExponent <0
float pow(float fValue, float fExponent);

// Maths operation: square root of fValue
// * Returns zero if fValue <0
float sqrt(float fValue);

// Maths operation: integer absolute value of nValue
// * Return value on error: 0
int abs(int nValue);

// Create a Heal effect. This should be applied as an instantaneous effect.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nDamageToHeal < 0.
effect EffectHeal(int nDamageToHeal);

// Create a Damage effect
// - nDamageAmount: amount of damage to be dealt. This should be applied as an
//   instantaneous effect.
// - nDamageType: DAMAGE_TYPE_*
// - nDamagePower: DAMAGE_POWER_*
effect EffectDamage(int nDamageAmount, int nDamageType=DAMAGE_TYPE_MAGICAL, int nDamagePower=DAMAGE_POWER_NORMAL);

// Create an Ability Increase effect
// - bAbilityToIncrease: ABILITY_*
effect EffectAbilityIncrease(int nAbilityToIncrease, int nModifyBy);

// Create a Damage Resistance effect that removes the first nAmount points of
// damage of type nDamageType, up to nLimit (or infinite if nLimit is 0)
// - nDamageType: DAMAGE_TYPE_*
// - nAmount: The amount of damage to soak each time the target is damaged.
// - nLimit: How much damage the effect can absorb before disappearing.
//   Set to zero for infinite.
// - bRangedOnly: Set to TRUE to have this resistance only apply to ranged attacks.
effect EffectDamageResistance(int nDamageType, int nAmount, int nLimit=0, int bRangedOnly = FALSE);

// Create a Resurrection effect. This should be applied as an instantaneous effect.
effect EffectResurrection();

// Create a Summon Creature effect.  The creature is created and placed into the
// caller's party/faction.
// - sCreatureResref: Identifies the creature to be summoned
// - nVisualEffectId: VFX_*
// - fDelaySeconds: There can be delay between the visual effect being played, and the
//   creature being added to the area
// - nUseAppearAnimation: should this creature play it's "appear" animation when it is
//   summoned. If zero, it will just fade in somewhere near the target.  If the value is 1
//   it will use the appear animation, and if it's 2 it will use appear2 (which doesn't exist for most creatures)
// - nUnsummonVisualEffectId: VFX_* to apply when the creature is unsummoned
// - oSummonToAdd: If sCreatureResref is blank, this object (if they have no master) is instead added as the summon, applying nVisualEffectId at their location
//                 fDelaySeconds and nUseAppearAnimation are unused, and no "Summoned a creature" feedback is sent, allowing you to do your own.
//                 The creature otherwise acts like a summon from then on, including not giving out XP for being killed, and able to be 
//                 unsummoned by the master or when the effect expires.
effect EffectSummonCreature(string sCreatureResref, int nVisualEffectId=VFX_NONE, float fDelaySeconds=0.0f, int nUseAppearAnimation=0, int nUnsummonVisualEffectId=VFX_IMP_UNSUMMON, object oSummonToAdd = OBJECT_INVALID);

// Get the caster level of an object. This is consistent with the caster level used when applying effects if OBJECT_SELF is used.
// - oObject: A creature will return the caster level of their currently cast spell or ability, or the item's caster level if an item was used
//            A placeable will return an automatic caster level: floor(10, (spell innate level * 2) - 1)
//            An Area of Effect object will return the caster level that was used to create the Area of Effect.
// * Return value on error, or if oObject has not yet cast a spell: 0;
int GetCasterLevel(object oObject);

// Get the first in-game effect on oCreature.
effect GetFirstEffect(object oCreature);

// Get the next in-game effect on oCreature.
effect GetNextEffect(object oCreature);

// Remove eEffect from oCreature.
// * No return value
void RemoveEffect(object oCreature, effect eEffect);

// * Returns TRUE if eEffect is a valid effect. The effect must have been applied to
// * an object or else it will return FALSE
int GetIsEffectValid(effect eEffect);

// Get the duration type (DURATION_TYPE_*) of eEffect.
// * Return value if eEffect is not valid: -1
int GetEffectDurationType(effect eEffect);

// Get the subtype (SUBTYPE_*) of eEffect.
// * Return value on error: 0
int GetEffectSubType(effect eEffect);

// Get the object that created eEffect.
// * Returns OBJECT_INVALID if eEffect is not a valid effect.
object GetEffectCreator(effect eEffect);

// Convert nInteger into a string.
// * Return value on error: ""
string IntToString(int nInteger);

// Get the first object in oArea.
// If no valid area is specified, it will use the caller's area.
// - nObjectFilter: This allows you to filter out undesired object types, using bitwise "or".
//   For example, to return only creatures and doors, the value for this parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// * Return value on error: OBJECT_INVALID
object GetFirstObjectInArea(object oArea=OBJECT_INVALID, int nObjectFilter = OBJECT_TYPE_ALL);

// Get the next object in oArea.
// If no valid area is specified, it will use the caller's area.
// - nObjectFilter: This allows you to filter out undesired object types, using bitwise "or".
//   For example, to return only creatures and doors, the value for this parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// * Return value on error: OBJECT_INVALID
object GetNextObjectInArea(object oArea=OBJECT_INVALID, int nObjectFilter = OBJECT_TYPE_ALL);

// Get the total from rolling (nNumDice x d2 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d2(int nNumDice=1);

// Get the total from rolling (nNumDice x d3 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d3(int nNumDice=1);

// Get the total from rolling (nNumDice x d4 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d4(int nNumDice=1);

// Get the total from rolling (nNumDice x d6 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d6(int nNumDice=1);

// Get the total from rolling (nNumDice x d8 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d8(int nNumDice=1);

// Get the total from rolling (nNumDice x d10 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d10(int nNumDice=1);

// Get the total from rolling (nNumDice x d12 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d12(int nNumDice=1);

// Get the total from rolling (nNumDice x d20 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d20(int nNumDice=1);

// Get the total from rolling (nNumDice x d100 dice).
// - nNumDice: If this is less than 1, the value 1 will be used.
int d100(int nNumDice=1);

// Get the magnitude of vVector; this can be used to determine the
// distance between two points.
// * Return value on error: 0.0f
float VectorMagnitude(vector vVector);

// Get the metamagic type (METAMAGIC_*) of the last spell cast by the caller
// * Return value if the caster is not a valid object: -1
int GetMetaMagicFeat();

// Get the object type (OBJECT_TYPE_*) of oTarget
// * Return value if oTarget is not a valid object: -1
int GetObjectType(object oTarget);

// Get the racial type (RACIAL_TYPE_*) of oCreature
// * Return value if oCreature is not a valid creature: RACIAL_TYPE_INVALID
int GetRacialType(object oCreature);

// Do a Fortitude Save check for the given DC
// - oCreature
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
// Returns: 0 if the saving throw roll failed
// Returns: 1 if the saving throw roll succeeded
// Returns: 2 if the target was immune to the save type specified
// Note: If used within an Area of Effect Object Script (On Enter, OnExit, OnHeartbeat), you MUST pass
// GetAreaOfEffectCreator() into oSaveVersus!!
int FortitudeSave(object oCreature, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// Does a Reflex Save check for the given DC
// - oCreature
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
// Returns: 0 if the saving throw roll failed
// Returns: 1 if the saving throw roll succeeded
// Returns: 2 if the target was immune to the save type specified
// Note: If used within an Area of Effect Object Script (On Enter, OnExit, OnHeartbeat), you MUST pass
// GetAreaOfEffectCreator() into oSaveVersus!!
int ReflexSave(object oCreature, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// Does a Will Save check for the given DC
// - oCreature
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
// Returns: 0 if the saving throw roll failed
// Returns: 1 if the saving throw roll succeeded
// Returns: 2 if the target was immune to the save type specified
// Note: If used within an Area of Effect Object Script (On Enter, OnExit, OnHeartbeat), you MUST pass
// GetAreaOfEffectCreator() into oSaveVersus!!
int WillSave(object oCreature, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// Get the DC to save against for a spell (10 + spell level + relevant ability
// bonus).  This can be called by a creature or by an Area of Effect object.
int GetSpellSaveDC();

// Set the subtype of eEffect to Magical and return eEffect.
// (Effects default to magical if the subtype is not set)
// Magical effects are removed by resting, and by dispel magic
effect MagicalEffect(effect eEffect);

// Set the subtype of eEffect to Supernatural and return eEffect.
// (Effects default to magical if the subtype is not set)
// Permanent supernatural effects are not removed by resting
effect SupernaturalEffect(effect eEffect);

// Set the subtype of eEffect to Extraordinary and return eEffect.
// (Effects default to magical if the subtype is not set)
// Extraordinary effects are removed by resting, but not by dispel magic
effect ExtraordinaryEffect(effect eEffect);

// Create an AC Increase effect
// - nValue: size of AC increase
// - nModifyType: AC_*_BONUS
// - nDamageType: DAMAGE_TYPE_*
//   * Default value for nDamageType should only ever be used in this function prototype.
effect EffectACIncrease(int nValue, int nModifyType=AC_DODGE_BONUS, int nDamageType=AC_VS_DAMAGE_TYPE_ALL);

// If oObject is a creature, this will return that creature's armour class
// If oObject is an item, door or placeable, this will return zero.
// - nForFutureUse: this parameter is not currently used
// * Return value if oObject is not a creature, item, door or placeable: -1
int GetAC(object oObject, int nForFutureUse=0);

// Create a Saving Throw Increase effect
// - nSave: SAVING_THROW_* (not SAVING_THROW_TYPE_*)
//          SAVING_THROW_ALL
//          SAVING_THROW_FORT
//          SAVING_THROW_REFLEX
//          SAVING_THROW_WILL
// - nValue: size of the Saving Throw increase
// - nSaveType: SAVING_THROW_TYPE_* (e.g. SAVING_THROW_TYPE_ACID )
effect EffectSavingThrowIncrease(int nSave, int nValue, int nSaveType=SAVING_THROW_TYPE_ALL);

// Create an Attack Increase effect
// - nBonus: size of attack bonus
// - nModifierType: ATTACK_BONUS_*
effect EffectAttackIncrease(int nBonus, int nModifierType=ATTACK_BONUS_MISC);

// Create a Damage Reduction effect
// - nAmount: amount of damage reduction
// - nDamagePower: DAMAGE_POWER_*
// - nLimit: How much damage the effect can absorb before disappearing.
//   Set to zero for infinite
// - bRangedOnly: Set to TRUE to have this reduction only apply to ranged attacks 
effect EffectDamageReduction(int nAmount, int nDamagePower, int nLimit=0, int bRangedOnly = FALSE);

// Create a Damage Increase effect
// - nBonus: DAMAGE_BONUS_*
// - nDamageType: DAMAGE_TYPE_*
// NOTE! You *must* use the DAMAGE_BONUS_* constants! Using other values may
//       result in odd behaviour.
effect EffectDamageIncrease(int nBonus, int nDamageType=DAMAGE_TYPE_MAGICAL);

// Convert nRounds into a number of seconds
// A round is always 6.0 seconds
float RoundsToSeconds(int nRounds);

// Convert nHours into a number of seconds
// The result will depend on how many minutes there are per hour (game-time)
float HoursToSeconds(int nHours);

// Convert nTurns into a number of seconds
// A turn is always 60.0 seconds
float TurnsToSeconds(int nTurns);

// Get an integer between 0 and 100 (inclusive) to represent oCreature's
// Law/Chaos alignment
// (100=law, 0=chaos)
// * Return value if oCreature is not a valid creature: -1
int GetLawChaosValue(object oCreature);

// Get an integer between 0 and 100 (inclusive) to represent oCreature's
// Good/Evil alignment
// (100=good, 0=evil)
// * Return value if oCreature is not a valid creature: -1
int GetGoodEvilValue(object oCreature);

// Return an ALIGNMENT_* constant to represent oCreature's law/chaos alignment
// * Return value if oCreature is not a valid creature: -1
int GetAlignmentLawChaos(object oCreature);

// Return an ALIGNMENT_* constant to represent oCreature's good/evil alignment
// * Return value if oCreature is not a valid creature: -1
int GetAlignmentGoodEvil(object oCreature);

// Get the first object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//      Spell Cylinder's always have a radius of 1.5m.
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_SPELLCONE, this is the length of the cone in the
//      direction of lTarget. Spell cones are always 60 degrees with the origin
//      at OBJECT_SELF.
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetLocation(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. Line of sight check is done from origin to target object
//   at a height 1m above the ground
//   (This can be used to ensure that spell effects do not go through walls.)
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or".
//   For example, to return only creatures and doors, the value for this
//   parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the
//   origin of the effect(normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
object GetFirstObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// Get the next object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder.
//      Spell Cylinder's always have a radius of 1.5m.
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_SPELLCONE, this is the length of the cone in the
//      direction of lTarget. Spell cones are always 60 degrees with the origin
//      at OBJECT_SELF.
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetLocation(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. (This can be used to ensure that spell effects do not go
//   through walls.) Line of sight check is done from origin to target object
//   at a height 1m above the ground
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or". For example, to return only creatures and doors, the value for
//   this parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the origin
//   of the effect (normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
object GetNextObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// Create an Entangle effect
// When applied, this effect will restrict the creature's movement and apply a
// (-2) to all attacks and a -4 to AC.
effect EffectEntangle();

// Causes object oObject to run the event evToRun. The script on the object that is
// associated with the event specified will run.
// Events can be created using the following event functions:
//    EventActivateItem() - This creates an OnActivateItem module event. The script for handling
//                          this event can be set in Module Properties on the Event Tab.
//    EventConversation() - This creates on OnConversation creature event. The script for handling
//                          this event can be set by viewing the Creature Properties on a
//                          creature and then clicking on the Scripts Tab.
//    EventSpellCastAt()  - This creates an OnSpellCastAt event. The script for handling this
//                          event can be set in the Scripts Tab of the Properties menu
//                          for the object.
//    EventUserDefined()  - This creates on OnUserDefined event. The script for handling this event
//                          can be set in the Scripts Tab of the Properties menu for the object/area/module.
void SignalEvent(object oObject, event evToRun);

// Create an event of the type nUserDefinedEventNumber
// Note: This only creates the event. The event wont actually trigger until SignalEvent()
// is called using this created UserDefined event as an argument.
// For example:
//     SignalEvent(oObject, EventUserDefined(9999));
// Once the event has been signaled. The script associated with the OnUserDefined event will
// run on the object oObject.
//
// To specify the OnUserDefined script that should run, view the object's Properties
// and click on the Scripts Tab. Then specify a script for the OnUserDefined event.
// From inside the OnUserDefined script call:
//    GetUserDefinedEventNumber() to retrieve the value of nUserDefinedEventNumber
//    that was used when the event was signaled.
event EventUserDefined(int nUserDefinedEventNumber);

// Create a Death effect
// - nSpectacularDeath: if this is TRUE, the creature to which this effect is
//   applied will die in an extraordinary fashion
// - nDisplayFeedback
effect EffectDeath(int nSpectacularDeath=FALSE, int nDisplayFeedback=TRUE);

// Create a Knockdown effect
// This effect knocks creatures off their feet, they will sit until the effect
// is removed. This should be applied as a temporary effect with a 3 second
// duration minimum (1 second to fall, 1 second sitting, 1 second to get up).
effect EffectKnockdown();

// Give oItem to oGiveTo
// If oItem is not a valid item, or oGiveTo is not a valid object, nothing will
// happen.
void ActionGiveItem(object oItem, object oGiveTo);

// Take oItem from oTakeFrom
// If oItem is not a valid item, or oTakeFrom is not a valid object, nothing
// will happen.
void ActionTakeItem(object oItem, object oTakeFrom);

// Normalize vVector
vector VectorNormalize(vector vVector);

// Create a Curse effect.
// - nStrMod: strength modifier
// - nDexMod: dexterity modifier
// - nConMod: constitution modifier
// - nIntMod: intelligence modifier
// - nWisMod: wisdom modifier
// - nChaMod: charisma modifier
effect EffectCurse(int nStrMod=1, int nDexMod=1, int nConMod=1, int nIntMod=1, int nWisMod=1, int nChaMod=1);

// Get the ability score of type nAbility for a creature (otherwise 0)
// - oCreature: the creature whose ability score we wish to find out
// - nAbilityType: ABILITY_*
// - nBaseAbilityScore: if set to true will return the base ability score without
//                      bonuses (e.g. ability bonuses granted from equipped items).
// Return value on error: 0
int GetAbilityScore(object oCreature, int nAbilityType, int nBaseAbilityScore=FALSE);

// * Returns TRUE if oCreature is a dead NPC, dead PC or a dying PC.
int GetIsDead(object oCreature);

// Output vVector to the logfile.
// - vVector
// - bPrepend: if this is TRUE, the message will be prefixed with "PRINTVECTOR:"
void PrintVector(vector vVector, int bPrepend);

// Create a vector with the specified values for x, y and z
vector Vector(float x=0.0f, float y=0.0f, float z=0.0f);

// Cause oObject to face vTarget.
void SetFacingPoint(vector vTarget, object oObject = OBJECT_SELF);

// Convert fAngle to a vector
vector AngleToVector(float fAngle);

// Convert vVector to an angle
float VectorToAngle(vector vVector);

// The oAttacker will perform a Melee Touch Attack on oTarget.
// This is not an action, and it assumes the caller is already within range of
// oTarget
// * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
int TouchAttackMelee(object oTarget, int bDisplayFeedback=TRUE, object oAttacker = OBJECT_SELF);

// The oAttacker will perform a Ranged Touch Attack on oTarget.
// * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
int TouchAttackRanged(object oTarget, int bDisplayFeedback=TRUE, object oAttacker = OBJECT_SELF);

// Create a Paralyze effect
effect EffectParalyze();

// Create a Spell Immunity effect.
// There is a known bug with this function. There *must* be a parameter specified
// when this is called (even if the desired parameter is SPELL_ALL_SPELLS),
// otherwise an effect of type EFFECT_TYPE_INVALIDEFFECT will be returned.
// - nImmunityToSpell: SPELL_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nImmunityToSpell is
//   invalid.
effect EffectSpellImmunity(int nImmunityToSpell=SPELL_ALL_SPELLS);

// Create a Deaf effect
effect EffectDeaf();

// Get the distance in metres between oObjectA and oObjectB.
// * Return value if either object is invalid: 0.0f
float GetDistanceBetween(object oObjectA, object oObjectB);

// Set oObject's local location variable sVarname to lValue
void SetLocalLocation(object oObject, string sVarName, location lValue);

// Get oObject's local location variable sVarname
location GetLocalLocation(object oObject, string sVarName);

// Create a Sleep effect
effect EffectSleep();

// Get the object which is in oCreature's specified inventory slot
// - nInventorySlot: INVENTORY_SLOT_*
// - oCreature
// * Returns OBJECT_INVALID if oCreature is not a valid creature or there is no
//   item in nInventorySlot.
object GetItemInSlot(int nInventorySlot, object oCreature=OBJECT_SELF);

// Create a Charm effect
effect EffectCharmed();

// Create a Confuse effect
effect EffectConfused();

// Create a Frighten effect
effect EffectFrightened();

// Create a Dominate effect
effect EffectDominated();

// Create a Daze effect
effect EffectDazed();

// Create a Stun effect
effect EffectStunned();

// Set whether oTarget's action stack can be modified
void SetCommandable(int bCommandable, object oTarget=OBJECT_SELF);

// Determine whether oTarget's action stack can be modified.
int GetCommandable(object oTarget=OBJECT_SELF);

// Create a Regenerate effect.
// - nAmount: amount of damage to be regenerated per time interval
// - fIntervalSeconds: length of interval in seconds
effect EffectRegenerate(int nAmount, float fIntervalSeconds);

// Create a Movement Speed Increase effect.
// - nPercentChange - range 0 through 99
// eg.
//    0 = no change in speed
//   50 = 50% faster
//   99 = almost twice as fast
effect EffectMovementSpeedIncrease(int nPercentChange);

// Get the number of hitdice for oCreature.
// * Return value if oCreature is not a valid creature: 0
int GetHitDice(object oCreature);

// The action subject will follow oFollow until a ClearAllActions() is called.
// - oFollow: this is the object to be followed
// - fFollowDistance: follow distance in metres
// * No return value
void ActionForceFollowObject(object oFollow, float fFollowDistance=0.0f);

// Get the Tag of oObject
// * Return value if oObject is not a valid object: ""
string GetTag(object oObject);

// Do a Spell Resistance check between oCaster and oTarget, returning TRUE if
// the spell was resisted.
// * Return value if oCaster or oTarget is an invalid object: FALSE
// * Return value if spell cast is not a player spell: - 1
// * Return value if spell resisted: 1
// * Return value if spell resisted via magic immunity: 2
// * Return value if spell resisted via spell absorption: 3
int ResistSpell(object oCaster, object oTarget);

// Get the effect type (EFFECT_TYPE_*) of eEffect.
// - bAllTypes: Set to TRUE to return additional values the game used to return EFFECT_INVALIDEFFECT for, specifically:
//  EFFECT_TYPE: APPEAR, CUTSCENE_DOMINATED, DAMAGE, DEATH, DISAPPEAR, HEAL, HITPOINTCHANGEWHENDYING, KNOCKDOWN, MODIFYNUMATTACKS, SUMMON_CREATURE, TAUNT, WOUNDING
// * Return value if eEffect is invalid: EFFECT_INVALIDEFFECT
int GetEffectType(effect eEffect, int bAllTypes = FALSE);

// Create an Area Of Effect effect in the area of the creature it is applied to.
// If the scripts are not specified, default ones will be used.
effect EffectAreaOfEffect(int nAreaEffectId, string sOnEnterScript="", string sHeartbeatScript="", string sOnExitScript="");

// * Returns TRUE if the Faction Ids of the two objects are the same
int GetFactionEqual(object oFirstObject, object oSecondObject=OBJECT_SELF);

// Make oObjectToChangeFaction join the faction of oMemberOfFactionToJoin.
// NB. ** This will only work for two NPCs **
void ChangeFaction(object oObjectToChangeFaction, object oMemberOfFactionToJoin);

// * Returns TRUE if oObject is listening for something
int GetIsListening(object oObject);

// Set whether oObject is listening.
void SetListening(object oObject, int bValue);

// Set the string for oObject to listen for.
// Note: this does not set oObject to be listening.
void SetListenPattern(object oObject, string sPattern, int nNumber=0);

// * Returns TRUE if sStringToTest matches sPattern.
int TestStringAgainstPattern(string sPattern, string sStringToTest);

// Get the appropriate matched string (this should only be used in
// OnConversation scripts).
// * Returns the appropriate matched string, otherwise returns ""
string GetMatchedSubstring(int nString);

// Get the number of string parameters available.
// * Returns -1 if no string matched (this could be because of a dialogue event)
int GetMatchedSubstringsCount();

// * Create a Visual Effect that can be applied to an object.
// - nVisualEffectId
// - nMissEffect: if this is TRUE, a random vector near or past the target will
//   be generated, on which to play the effect
effect EffectVisualEffect(int nVisualEffectId, int nMissEffect=FALSE, float fScale=1.0f, vector vTranslate=[0.0,0.0,0.0], vector vRotate=[0.0,0.0,0.0]);

// Get the weakest member of oFactionMember's faction.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionWeakestMember(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the strongest member of oFactionMember's faction.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionStrongestMember(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the member of oFactionMember's faction that has taken the most hit points
// of damage.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionMostDamagedMember(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the member of oFactionMember's faction that has taken the fewest hit
// points of damage.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionLeastDamagedMember(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the amount of gold held by oFactionMember's faction.
// * Returns -1 if oFactionMember's faction is invalid.
int GetFactionGold(object oFactionMember);

// Get an integer between 0 and 100 (inclusive) that represents how
// oSourceFactionMember's faction feels about oTarget.
// * Return value on error: -1
int GetFactionAverageReputation(object oSourceFactionMember, object oTarget);

// Get an integer between 0 and 100 (inclusive) that represents the average
// good/evil alignment of oFactionMember's faction.
// * Return value on error: -1
int GetFactionAverageGoodEvilAlignment(object oFactionMember);

// Get an integer between 0 and 100 (inclusive) that represents the average
// law/chaos alignment of oFactionMember's faction.
// * Return value on error: -1
int GetFactionAverageLawChaosAlignment(object oFactionMember);

// Get the average level of the members of the faction.
// * Return value on error: -1
int GetFactionAverageLevel(object oFactionMember);

// Get the average XP of the members of the faction.
// * Return value on error: -1
int GetFactionAverageXP(object oFactionMember);

// Get the most frequent class in the faction - this can be compared with the
// constants CLASS_TYPE_*.
// * Return value on error: -1
int GetFactionMostFrequentClass(object oFactionMember);

// Get the object faction member with the lowest armour class.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionWorstAC(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Get the object faction member with the highest armour class.
// * Returns OBJECT_INVALID if oFactionMember's faction is invalid.
object GetFactionBestAC(object oFactionMember=OBJECT_SELF, int bMustBeVisible=TRUE);

// Sit in oChair.
// Note: Not all creatures will be able to sit and not all
//       objects can be sat on.
//       The object oChair must also be marked as usable in the toolset.
//
// For Example: To get a player to sit in oChair when they click on it,
// place the following script in the OnUsed event for the object oChair.
// void main()
// {
//    object oChair = OBJECT_SELF;
//    AssignCommand(GetLastUsedBy(),ActionSit(oChair));
// }
void ActionSit(object oChair);

// In an onConversation script this gets the number of the string pattern
// matched (the one that triggered the script).
// * Returns -1 if no string matched
int GetListenPatternNumber();

// Jump to an object ID, or as near to it as possible.
void ActionJumpToObject(object oToJumpTo, int bWalkStraightLineToPoint=TRUE);

// Get the first waypoint with the specified tag.
// * Returns OBJECT_INVALID if the waypoint cannot be found.
object GetWaypointByTag(string sWaypointTag);

// Get the destination object for the given object.
//
// All objects can hold a transition target, but only Doors and Triggers
// will be made clickable by the game engine (This may change in the
// future). You can set and query transition targets on other objects for
// your own scripted purposes.
//
// * Returns OBJECT_INVALID if oTransition does not hold a target.
object GetTransitionTarget(object oTransition);

// Link the two supplied effects, returning eChildEffect as a child of
// eParentEffect.
// Note: When applying linked effects if the target is immune to all valid
// effects all other effects will be removed as well. This means that if you
// apply a visual effect and a silence effect (in a link) and the target is
// immune to the silence effect that the visual effect will get removed as well.
// Visual Effects are not considered "valid" effects for the purposes of
// determining if an effect will be removed or not and as such should never be
// packaged *only* with other visual effects in a link.
effect EffectLinkEffects(effect eChildEffect, effect eParentEffect );

// Get the nNth object with the specified tag.
// - sTag
// - nNth: the nth object with this tag may be requested
// * Returns OBJECT_INVALID if the object cannot be found.
// Note: The module cannot be retrieved by GetObjectByTag(), use GetModule() instead.
object GetObjectByTag(string sTag, int nNth=0);

// Adjust the alignment of oSubject.
// - oSubject
// - nAlignment:
//   -> ALIGNMENT_LAWFUL/ALIGNMENT_CHAOTIC/ALIGNMENT_GOOD/ALIGNMENT_EVIL: oSubject's
//      alignment will be shifted in the direction specified
//   -> ALIGNMENT_ALL: nShift will be added to oSubject's law/chaos and
//      good/evil alignment values
//   -> ALIGNMENT_NEUTRAL: nShift is applied to oSubject's law/chaos and
//      good/evil alignment values in the direction which is towards neutrality.
//     e.g. If oSubject has a law/chaos value of 10 (i.e. chaotic) and a
//          good/evil value of 80 (i.e. good) then if nShift is 15, the
//          law/chaos value will become (10+15)=25 and the good/evil value will
//          become (80-25)=55
//     Furthermore, the shift will at most take the alignment value to 50 and
//     not beyond.
//     e.g. If oSubject has a law/chaos value of 40 and a good/evil value of 70,
//          then if nShift is 15, the law/chaos value will become 50 and the
//          good/evil value will become 55
// - nShift: this is the desired shift in alignment
// - bAllPartyMembers: when TRUE the alignment shift of oSubject also has a
//                     diminished affect all members of oSubject's party (if oSubject is a Player).
//                     When FALSE the shift only affects oSubject.
// * No return value
void AdjustAlignment(object oSubject, int nAlignment, int nShift, int bAllPartyMembers=TRUE);

// Do nothing for fSeconds seconds.
void ActionWait(float fSeconds);

// Set the transition bitmap of a player; this should only be called in area
// transition scripts. This action should be run by the person "clicking" the
// area transition via AssignCommand.
// - nPredefinedAreaTransition:
//   -> To use a predefined area transition bitmap, use one of AREA_TRANSITION_*
//   -> To use a custom, user-defined area transition bitmap, use
//      AREA_TRANSITION_USER_DEFINED and specify the filename in the second
//      parameter
// - sCustomAreaTransitionBMP: this is the filename of a custom, user-defined
//   area transition bitmap
void SetAreaTransitionBMP(int nPredefinedAreaTransition, string sCustomAreaTransitionBMP="");

// Starts a conversation with oObjectToConverseWith - this will cause their
// OnDialog event to fire.
// - oObjectToConverseWith
// - sDialogResRef: If this is blank, the creature's own dialogue file will be used
// - bPrivateConversation
// Turn off bPlayHello if you don't want the initial greeting to play
void ActionStartConversation(object oObjectToConverseWith, string sDialogResRef="", int bPrivateConversation=FALSE, int bPlayHello=TRUE);

// Pause the current conversation.
void ActionPauseConversation();

// Resume a conversation after it has been paused.
void ActionResumeConversation();

// Create a Beam effect.
// - nBeamVisualEffect: VFX_BEAM_*
// - oEffector: the beam is emitted from this creature
// - nBodyPart: BODY_NODE_*
// - bMissEffect: If this is TRUE, the beam will fire to a random vector near or
//   past the target
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nBeamVisualEffect is
//   not valid.
effect EffectBeam(int nBeamVisualEffect, object oEffector, int nBodyPart, int bMissEffect=FALSE, float fScale=1.0f, vector vTranslate=[0.0,0.0,0.0], vector vRotate=[0.0,0.0,0.0]);

// Get an integer between 0 and 100 (inclusive) that represents how oSource
// feels about oTarget.
// -> 0-10 means oSource is hostile to oTarget
// -> 11-89 means oSource is neutral to oTarget
// -> 90-100 means oSource is friendly to oTarget
// * Returns -1 if oSource or oTarget does not identify a valid object
int GetReputation(object oSource, object oTarget);

// Adjust how oSourceFactionMember's faction feels about oTarget by the
// specified amount.
// Note: This adjusts Faction Reputation, how the entire faction that
// oSourceFactionMember is in, feels about oTarget.
// * No return value
// Note: You can't adjust a player character's (PC) faction towards
//       NPCs, so attempting to make an NPC hostile by passing in a PC object
//       as oSourceFactionMember in the following call will fail:
//       AdjustReputation(oNPC,oPC,-100);
//       Instead you should pass in the PC object as the first
//       parameter as in the following call which should succeed:
//       AdjustReputation(oPC,oNPC,-100);
// Note: Will fail if oSourceFactionMember is a plot object.
void AdjustReputation(object oTarget, object oSourceFactionMember, int nAdjustment);

// Get the creature that is currently sitting on the specified object.
// - oChair
// * Returns OBJECT_INVALID if oChair is not a valid placeable.
object GetSittingCreature(object oChair);

// Get the creature that is going to attack oTarget.
// Note: This value is cleared out at the end of every combat round and should
// not be used in any case except when getting a "going to be attacked" shout
// from the master creature (and this creature is a henchman)
// * Returns OBJECT_INVALID if oTarget is not a valid creature.
object GetGoingToBeAttackedBy(object oTarget);

// Create a Spell Resistance Increase effect.
// - nValue: size of spell resistance increase
effect EffectSpellResistanceIncrease(int nValue);

// Get the location of oObject.
location GetLocation(object oObject);

// The subject will jump to lLocation instantly (even between areas).
// If lLocation is invalid, nothing will happen.
void ActionJumpToLocation(location lLocation);

// Create a location.
// The special constant LOCATION_INVALID describes a location with area equalling OBJECT_INVALID
// and all other values 0.0f. Declared but not initialised location variables default to this value.
location Location(object oArea, vector vPosition, float fOrientation);

// Apply eEffect at lLocation.
void ApplyEffectAtLocation(int nDurationType, effect eEffect, location lLocation, float fDuration=0.0f);

// * Returns TRUE if oCreature is a Player Controlled character.
int GetIsPC(object oCreature);

// Convert fFeet into a number of meters.
float FeetToMeters(float fFeet);

// Convert fYards into a number of meters.
float YardsToMeters(float fYards);

// Apply eEffect to oTarget.
void ApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration=0.0f);

// The caller will immediately speak sStringToSpeak (this is different from
// ActionSpeakString)
// - sStringToSpeak
// - nTalkVolume: TALKVOLUME_*
void SpeakString(string sStringToSpeak, int nTalkVolume=TALKVOLUME_TALK);

// Get the location of the caller's last spell target.
location GetSpellTargetLocation();

// Get the position vector from lLocation.
vector GetPositionFromLocation(location lLocation);

// Get the area's object ID from lLocation.
object GetAreaFromLocation(location lLocation);

// Get the orientation value from lLocation.
float GetFacingFromLocation(location lLocation);

// Get the creature nearest to lLocation, subject to all the criteria specified.
// - nFirstCriteriaType: CREATURE_TYPE_*
// - nFirstCriteriaValue:
//   -> CLASS_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_CLASS
//   -> SPELL_* if nFirstCriteriaType was CREATURE_TYPE_DOES_NOT_HAVE_SPELL_EFFECT
//      or CREATURE_TYPE_HAS_SPELL_EFFECT
//   -> TRUE or FALSE if nFirstCriteriaType was CREATURE_TYPE_IS_ALIVE
//   -> PERCEPTION_* if nFirstCriteriaType was CREATURE_TYPE_PERCEPTION
//   -> PLAYER_CHAR_IS_PC or PLAYER_CHAR_NOT_PC if nFirstCriteriaType was
//      CREATURE_TYPE_PLAYER_CHAR
//   -> RACIAL_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_RACIAL_TYPE
//   -> REPUTATION_TYPE_* if nFirstCriteriaType was CREATURE_TYPE_REPUTATION
//   For example, to get the nearest PC, use
//   (CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC)
// - lLocation: We're trying to find the creature of the specified type that is
//   nearest to lLocation
// - nNth: We don't have to find the first nearest: we can find the Nth nearest....
// - nSecondCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nSecondCriteriaValue: This is used in the same way as nFirstCriteriaValue
//   to further specify the type of creature that we are looking for.
// - nThirdCriteriaType: This is used in the same way as nFirstCriteriaType to
//   further specify the type of creature that we are looking for.
// - nThirdCriteriaValue: This is used in the same way as nFirstCriteriaValue to
//   further specify the type of creature that we are looking for.
// * Return value on error: OBJECT_INVALID
object GetNearestCreatureToLocation(int nFirstCriteriaType, int nFirstCriteriaValue,  location lLocation, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1,  int nThirdCriteriaValue=-1 );

// Get the Nth object nearest to oTarget that is of the specified type.
// - nObjectType: OBJECT_TYPE_*
// - oTarget
// - nNth
// * Return value on error: OBJECT_INVALID
object GetNearestObject(int nObjectType=OBJECT_TYPE_ALL, object oTarget=OBJECT_SELF, int nNth=1);

// Get the nNth object nearest to lLocation that is of the specified type.
// - nObjectType: OBJECT_TYPE_*
// - lLocation
// - nNth
// * Return value on error: OBJECT_INVALID
object GetNearestObjectToLocation(int nObjectType, location lLocation, int nNth=1);

// Get the nth Object nearest to oTarget that has sTag as its tag.
// * Return value on error: OBJECT_INVALID
object GetNearestObjectByTag(string sTag, object oTarget=OBJECT_SELF, int nNth=1);

// Convert nInteger into a floating point number.
float IntToFloat(int nInteger);

// Convert fFloat into the nearest integer.
int FloatToInt(float fFloat);

// Convert sNumber into an integer.
int StringToInt(string sNumber);

// Convert sNumber into a floating point number.
float StringToFloat(string sNumber);

// Cast spell nSpell at lTargetLocation.
// - nSpell: SPELL_*
// - lTargetLocation
// - nMetaMagic: METAMAGIC_*. If nClass is specified, cannot be METAMAGIC_ANY.
// - bCheat: If this is TRUE, then the executor of the action doesn't have to be
//   able to cast the spell. Ignored if nClass is specified.
// - bCheat: If this is TRUE, then the executor of the action doesn't have to be
//   able to cast the spell.
// - nProjectilePathType: PROJECTILE_PATH_TYPE_*
// - bInstantSpell: If this is TRUE, the spell is cast immediately; this allows
//   the end-user to simulate
//   a high-level magic user having lots of advance warning of impending trouble.
// - nClass: If set to a CLASS_TYPE_* it will cast using that class specifically.
//   CLASS_TYPE_INVALID will use spell abilities.
// - bSpontaneousCast: If set to TRUE will attempt to cast the given spell spontaneously,
//   ie a Cleric casting Cure Light Wounds using any level 1 slot. Needs a valid nClass set.
// - nDomainLevel: The level of the spell if cast from a domain slot.
//   eg SPELL_HEAL can be spell level 5 on a cleric. Use 0 for no domain slot.
void ActionCastSpellAtLocation(int nSpell, location lTargetLocation, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE, int nClass=-1, int bSpontaneousCast=FALSE, int nDomainlevel=0);

// * Returns TRUE if oSource considers oTarget as an enemy.
int GetIsEnemy(object oTarget, object oSource=OBJECT_SELF);

// * Returns TRUE if oSource considers oTarget as a friend.
int GetIsFriend(object oTarget, object oSource=OBJECT_SELF);

// * Returns TRUE if oSource considers oTarget as neutral.
int GetIsNeutral(object oTarget, object oSource=OBJECT_SELF);

// Get the PC that is involved in the conversation.
// * Returns OBJECT_INVALID on error.
object GetPCSpeaker();

// Get a string from the talk table using nStrRef.
string GetStringByStrRef(int nStrRef, int nGender=GENDER_MALE);

// Causes the creature to speak a translated string.
// - nStrRef: Reference of the string in the talk table
// - nTalkVolume: TALKVOLUME_*
void ActionSpeakStringByStrRef(int nStrRef, int nTalkVolume=TALKVOLUME_TALK);

// Destroy oObject (irrevocably).
// This will not work on modules and areas.
void DestroyObject(object oDestroy, float fDelay=0.0f);

// Get the module.
// * Return value on error: OBJECT_INVALID
object GetModule();

// Create an object of the specified type at lLocation.
// - nObjectType: OBJECT_TYPE_ITEM, OBJECT_TYPE_CREATURE, OBJECT_TYPE_PLACEABLE,
//   OBJECT_TYPE_STORE, OBJECT_TYPE_WAYPOINT
// - sTemplate
// - lLocation
// - bUseAppearAnimation
// - sNewTag - if this string is not empty, it will replace the default tag from the template
object CreateObject(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="");

// Create an event which triggers the "SpellCastAt" script
// Note: This only creates the event. The event wont actually trigger until SignalEvent()
// is called using this created SpellCastAt event as an argument.
// For example:
//     SignalEvent(oCreature, EventSpellCastAt(oCaster, SPELL_MAGIC_MISSILE, TRUE));
// This function doesn't cast the spell specified, it only creates an event so that
// when the event is signaled on an object, the object will use its OnSpellCastAt script
// to react to the spell being cast.
//
// To specify the OnSpellCastAt script that should run, view the Object's Properties
// and click on the Scripts Tab. Then specify a script for the OnSpellCastAt event.
// From inside the OnSpellCastAt script call:
//     GetLastSpellCaster() to get the object that cast the spell (oCaster).
//     GetLastSpell() to get the type of spell cast (nSpell)
//     GetLastSpellHarmful() to determine if the spell cast at the object was harmful.
event EventSpellCastAt(object oCaster, int nSpell, int bHarmful=TRUE);

// This is for use in a "Spell Cast" script, it gets who cast the spell.
// The spell could have been cast by a creature, placeable or door.
// * Returns OBJECT_INVALID if the caller is not a creature, placeable or door.
object GetLastSpellCaster();

// This is for use in a "Spell Cast" script, it gets the ID of the spell that
// was cast.
int GetLastSpell();

// This is for use in a user-defined script, it gets the event number.
int GetUserDefinedEventNumber();

// This is for use in a Spell script, it gets the ID of the spell that is being cast.
// If used in an Area of Effect script it will return the ID of the spell that generated the AOE effect.
// * Returns the spell ID (SPELL_*) or -1 if no spell was cast or on error
int GetSpellId();

// Generate a random name.
// nNameType: The type of random name to be generated (NAME_*)
string RandomName(int nNameType=NAME_FIRST_GENERIC_MALE);

// Create a Poison effect.
// - nPoisonType: POISON_*
effect EffectPoison(int nPoisonType);

// Create a Disease effect.
// - nDiseaseType: DISEASE_*
effect EffectDisease(int nDiseaseType);

// Create a Silence effect.
effect EffectSilence();

// Get the name of oObject.
// - bOriginalName:  if set to true any new name specified via a SetName scripting command
//                   is ignored and the original object's name is returned instead.
string GetName(object oObject, int bOriginalName=FALSE);

// Use this in a conversation script to get the person with whom you are conversing.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetLastSpeaker();

// Use this in an OnDialog script to start up the dialog tree.
// - sResRef: if this is not specified, the default dialog file will be used
// - oObjectToDialog: if this is not specified the person that triggered the
//   event will be used
int BeginConversation(string sResRef="", object oObjectToDialog=OBJECT_INVALID);

// Use this in an OnPerception script to get the object that was perceived.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetLastPerceived();

// Use this in an OnPerception script to determine whether the object that was
// perceived was heard.
int GetLastPerceptionHeard();

// Use this in an OnPerception script to determine whether the object that was
// perceived has become inaudible.
int GetLastPerceptionInaudible();

// Use this in an OnPerception script to determine whether the object that was
// perceived was seen.
int GetLastPerceptionSeen();

// Use this in an OnClosed script to get the object that closed oObject.
// * Returns OBJECT_INVALID if oObject is not a valid door, placeable or store.
object GetLastClosedBy(object oObject=OBJECT_SELF);

// Use this in an OnPerception script to determine whether the object that was
// perceived has vanished.
int GetLastPerceptionVanished();

// Get the first object within oPersistentObject.
// - oPersistentObject
// - nResidentObjectType: OBJECT_TYPE_*
// - nPersistentZone: PERSISTENT_ZONE_ACTIVE. [This could also take the value
//   PERSISTENT_ZONE_FOLLOW, but this is no longer used.]
// * Returns OBJECT_INVALID if no object is found.
object GetFirstInPersistentObject(object oPersistentObject=OBJECT_SELF, int nResidentObjectType=OBJECT_TYPE_CREATURE, int nPersistentZone=PERSISTENT_ZONE_ACTIVE);

// Get the next object within oPersistentObject.
// - oPersistentObject
// - nResidentObjectType: OBJECT_TYPE_*
// - nPersistentZone: PERSISTENT_ZONE_ACTIVE. [This could also take the value
//   PERSISTENT_ZONE_FOLLOW, but this is no longer used.]
// * Returns OBJECT_INVALID if no object is found.
object GetNextInPersistentObject(object oPersistentObject=OBJECT_SELF, int nResidentObjectType=OBJECT_TYPE_CREATURE, int nPersistentZone=PERSISTENT_ZONE_ACTIVE);

// This returns the creator of oAreaOfEffectObject.
// * Returns OBJECT_INVALID if oAreaOfEffectObject is not a valid Area of Effect object.
object GetAreaOfEffectCreator(object oAreaOfEffectObject=OBJECT_SELF);

// Delete oObject's local integer variable sVarName
void DeleteLocalInt(object oObject, string sVarName);

// Delete oObject's local float variable sVarName
void DeleteLocalFloat(object oObject, string sVarName);

// Delete oObject's local string variable sVarName
void DeleteLocalString(object oObject, string sVarName);

// Delete oObject's local object variable sVarName
void DeleteLocalObject(object oObject, string sVarName);

// Delete oObject's local location variable sVarName
void DeleteLocalLocation(object oObject, string sVarName);

// Create a Haste effect.
effect EffectHaste();

// Create a Slow effect.
effect EffectSlow();

// Convert oObject into a hexadecimal string.
string ObjectToString(object oObject);

// Create an Immunity effect.
// - nImmunityType: IMMUNITY_TYPE_*
effect EffectImmunity(int nImmunityType);

// - oCreature
// - nImmunityType: IMMUNITY_TYPE_*
// - oVersus: if this is specified, then we also check for the race and
//   alignment of oVersus
// * Returns TRUE if oCreature has immunity of type nImmunity versus oVersus.
int GetIsImmune(object oCreature, int nImmunityType, object oVersus=OBJECT_INVALID);

// Creates a Damage Immunity Increase effect.
// - nDamageType: DAMAGE_TYPE_*
// - nPercentImmunity
effect EffectDamageImmunityIncrease(int nDamageType, int nPercentImmunity);

// Determine whether oEncounter is active.
int  GetEncounterActive(object oEncounter=OBJECT_SELF);

// Set oEncounter's active state to nNewValue.
// - nNewValue: TRUE/FALSE
// - oEncounter
void SetEncounterActive(int nNewValue, object oEncounter=OBJECT_SELF);

// Get the maximum number of times that oEncounter will spawn.
int GetEncounterSpawnsMax(object oEncounter=OBJECT_SELF);

// Set the maximum number of times that oEncounter can spawn
void SetEncounterSpawnsMax(int nNewValue, object oEncounter=OBJECT_SELF);

// Get the number of times that oEncounter has spawned so far
int  GetEncounterSpawnsCurrent(object oEncounter=OBJECT_SELF);

// Set the number of times that oEncounter has spawned so far
void SetEncounterSpawnsCurrent(int nNewValue, object oEncounter=OBJECT_SELF);

// Use this in an OnItemAcquired script to get the item that was acquired.
// * Returns OBJECT_INVALID if the module is not valid.
object GetModuleItemAcquired();

// Use this in an OnItemAcquired script to get the creatre that previously
// possessed the item.
// * Returns OBJECT_INVALID if the item was picked up from the ground.
object GetModuleItemAcquiredFrom();

// Set the value for a custom token.
void SetCustomToken(int nCustomTokenNumber, string sTokenValue);

// Determine whether oCreature has nFeat, optionally if nFeat is useable.
// - nFeat: FEAT_*
// - oCreature
// - bIgnoreUses: Will check if the creature has the given feat even if it has no uses remaining
int GetHasFeat(int nFeat, object oCreature=OBJECT_SELF, int bIgnoreUses=FALSE);

// Determine whether oCreature has nSkill, and nSkill is useable.
// - nSkill: SKILL_*
// - oCreature
int GetHasSkill(int nSkill, object oCreature=OBJECT_SELF);

// Use nFeat on oTarget.
// - nFeat: FEAT_*
// - oTarget: Target of the feat. Must be OBJECT_INVALID if lTarget is used.
// - nSubFeat: - For feats with subdial options, use either:
//        - SUBFEAT_* for some specific feats like called shot
//        - spells.2da line of the subdial spell, eg 708 for Dragon Shape: Blue Dragon when using FEAT_EPIC_WILD_SHAPE_DRAGON
// - lTarget: The location to use the feat at. oTarget must be OBJECT_INVALID for this to be used.
void ActionUseFeat(int nFeat, object oTarget=OBJECT_SELF, int nSubFeat = 0, location lTarget=LOCATION_INVALID);

// Runs the action "UseSkill" on the current creature
// Use nSkill on oTarget.
// - nSkill: SKILL_*
// - oTarget
// - nSubSkill: SUBSKILL_*
// - oItemUsed: Item to use in conjunction with the skill
void ActionUseSkill(int nSkill, object oTarget, int nSubSkill=0, object oItemUsed=OBJECT_INVALID );

// Determine whether oSource sees oTarget.
// NOTE: This *only* works on creatures, as visibility lists are not
//       maintained for non-creature objects.
int GetObjectSeen(object oTarget, object oSource=OBJECT_SELF);

// Determine whether oSource hears oTarget.
// NOTE: This *only* works on creatures, as visibility lists are not
//       maintained for non-creature objects.
int GetObjectHeard(object oTarget, object oSource=OBJECT_SELF);

// Use this in an OnPlayerDeath module script to get the last player that died.
object GetLastPlayerDied();

// Use this in an OnItemLost script to get the item that was lost/dropped.
// * Returns OBJECT_INVALID if the module is not valid.
object GetModuleItemLost();

// Use this in an OnItemLost script to get the creature that lost the item.
// * Returns OBJECT_INVALID if the module is not valid.
object GetModuleItemLostBy();

// Do aActionToDo.
void ActionDoCommand(action aActionToDo);

// Creates a conversation event.
// Note: This only creates the event. The event wont actually trigger until SignalEvent()
// is called using this created conversation event as an argument.
// For example:
//     SignalEvent(oCreature, EventConversation());
// Once the event has been signaled. The script associated with the OnConversation event will
// run on the creature oCreature.
//
// To specify the OnConversation script that should run, view the Creature Properties on
// the creature and click on the Scripts Tab. Then specify a script for the OnConversation event.
event EventConversation();

// Set the difficulty level of oEncounter.
// - nEncounterDifficulty: ENCOUNTER_DIFFICULTY_*
// - oEncounter
void SetEncounterDifficulty(int nEncounterDifficulty, object oEncounter=OBJECT_SELF);

// Get the difficulty level of oEncounter.
int GetEncounterDifficulty(object oEncounter=OBJECT_SELF);

// Get the distance between lLocationA and lLocationB.
float GetDistanceBetweenLocations(location lLocationA, location lLocationB);

// Use this in spell scripts to get nDamage adjusted by oTarget's reflex and
// evasion saves.
// - nDamage
// - oTarget
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
int GetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// Play nAnimation immediately.
// - nAnimation: ANIMATION_*
// - fSpeed
// - fSeconds
void PlayAnimation(int nAnimation, float fSpeed=1.0, float fSeconds=0.0);

// Create a Spell Talent.
// - nSpell: SPELL_*
talent TalentSpell(int nSpell);

// Create a Feat Talent.
// - nFeat: FEAT_*
talent TalentFeat(int nFeat);

// Create a Skill Talent.
// - nSkill: SKILL_*
talent TalentSkill(int nSkill);

// Determines whether oObject has any effects applied by nSpell
// - nSpell: SPELL_*
// - oObject
// * The spell id on effects is only valid if the effect is created
//   when the spell script runs. If it is created in a delayed command
//   then the spell id on the effect will be invalid.
int GetHasSpellEffect(int nSpell, object oObject=OBJECT_SELF);

// Get the spell (SPELL_*) that applied eSpellEffect.
// * Returns -1 if eSpellEffect was applied outside a spell script.
int GetEffectSpellId(effect eSpellEffect);

// Determine whether oCreature has tTalent.
int GetCreatureHasTalent(talent tTalent, object oCreature=OBJECT_SELF);

// Get a random talent of oCreature, within nCategory.
// - nCategory: TALENT_CATEGORY_*
// - oCreature
talent GetCreatureTalentRandom(int nCategory, object oCreature=OBJECT_SELF);

// Get the best talent (i.e. closest to nCRMax without going over) of oCreature,
// within nCategory.
// - nCategory: TALENT_CATEGORY_*
// - nCRMax: Challenge Rating of the talent
// - oCreature
talent GetCreatureTalentBest(int nCategory, int nCRMax, object oCreature=OBJECT_SELF);

// Use tChosenTalent on oTarget.
void ActionUseTalentOnObject(talent tChosenTalent, object oTarget);

// Use tChosenTalent at lTargetLocation.
void ActionUseTalentAtLocation(talent tChosenTalent, location lTargetLocation);

// Get the gold piece value of oItem.
// * Returns 0 if oItem is not a valid item.
int GetGoldPieceValue(object oItem);

// * Returns TRUE if oCreature is of a playable racial type.
int GetIsPlayableRacialType(object oCreature);

// Jump to lDestination.  The action is added to the TOP of the action queue.
void JumpToLocation(location lDestination);

// Create a Temporary Hitpoints effect.
// - nHitPoints: a positive integer
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nHitPoints < 0.
effect EffectTemporaryHitpoints(int nHitPoints);

// Get the number of ranks that oTarget has in nSkill.
// - nSkill: SKILL_*
// - oTarget
// - nBaseSkillRank: if set to true returns the number of base skill ranks the target
//                   has (i.e. not including any bonuses from ability scores, feats, etc).
// * Returns -1 if oTarget doesn't have nSkill.
// * Returns 0 if nSkill is untrained.
int GetSkillRank(int nSkill, object oTarget=OBJECT_SELF, int nBaseSkillRank=FALSE);

// Get the attack target of oCreature.
// This only works when oCreature is in combat.
object GetAttackTarget(object oCreature=OBJECT_SELF);

// Get the attack type (SPECIAL_ATTACK_*) of oCreature's last attack.
// This only works when oCreature is in combat.
int GetLastAttackType(object oCreature=OBJECT_SELF);

// Get the attack mode (COMBAT_MODE_*) of oCreature's last attack.
// This only works when oCreature is in combat.
int GetLastAttackMode(object oCreature=OBJECT_SELF);

// Get the master of oAssociate.
object GetMaster(object oAssociate=OBJECT_SELF);

// * Returns TRUE if oCreature is in combat.
int GetIsInCombat(object oCreature=OBJECT_SELF);

// Get the last command (ASSOCIATE_COMMAND_*) issued to oAssociate.
int GetLastAssociateCommand(object oAssociate=OBJECT_SELF);

// Give nGP gold to oCreature.
void GiveGoldToCreature(object oCreature, int nGP);

// Set the destroyable status of oObject
// - bDestroyable: If this is FALSE, the caller does not fade out on death, but
//   sticks around as a corpse.
// - bRaiseable: If this is TRUE, the caller can be raised via resurrection.
// - bSelectableWhenDead: If this is TRUE, the caller is selectable after death.
// - oObject: Object to affect.
void SetIsDestroyable(int bDestroyable, int bRaiseable=TRUE, int bSelectableWhenDead=FALSE, object oObject = OBJECT_SELF);

// Set the locked state of oTarget, which can be a door or a placeable object.
void SetLocked(object oTarget, int bLocked);

// Get the locked state of oTarget, which can be a door or a placeable object.
int GetLocked(object oTarget);

// Use this in a trigger's OnClick event script to get the object that last
// clicked on it.
// This is identical to GetEnteringObject.
// GetClickingObject() should not be called from a placeable's OnClick event,
// instead use GetPlaceableLastClickedBy();
object GetClickingObject();

// Initialise oTarget to listen for the standard Associates commands.
void SetAssociateListenPatterns(object oTarget=OBJECT_SELF);

// Get the last weapon that oCreature used in an attack.
// * Returns OBJECT_INVALID if oCreature did not attack, or has no weapon equipped.
object GetLastWeaponUsed(object oCreature);

// Use oPlaceable.
void ActionInteractObject(object oPlaceable);

// Get the last object that used the placeable object that is calling this function.
// * Returns OBJECT_INVALID if it is called by something other than a placeable or
//   a door.
object GetLastUsedBy();

// Returns the ability modifier for the specified ability
// Get oCreature's ability modifier for nAbility.
// - nAbility: ABILITY_*
// - oCreature
int GetAbilityModifier(int nAbility, object oCreature=OBJECT_SELF);

// Determined whether oItem has been identified.
int GetIdentified(object oItem);

// Set whether oItem has been identified.
void SetIdentified(object oItem, int bIdentified);

// Summon an Animal Companion
void SummonAnimalCompanion(object oMaster=OBJECT_SELF);

// Summon a Familiar
void SummonFamiliar(object oMaster=OBJECT_SELF);

// Get the last blocking door encountered by the caller of this function.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetBlockingDoor();

// - oTargetDoor
// - nDoorAction: DOOR_ACTION_*
// * Returns TRUE if nDoorAction can be performed on oTargetDoor.
int GetIsDoorActionPossible(object oTargetDoor, int nDoorAction);

// Perform nDoorAction on oTargetDoor.
void DoDoorAction(object oTargetDoor, int nDoorAction);

// Get the first item in oTarget's inventory (start to cycle through oTarget's
// inventory).
// * Returns OBJECT_INVALID if oTarget is not a creature, item, placeable or store,
//   or if no item is found.
object GetFirstItemInInventory(object oTarget=OBJECT_SELF);

// Get the next item in oTarget's inventory (continue to cycle through oTarget's
// inventory).
// * Returns OBJECT_INVALID if oTarget is not a creature, item, placeable or store,
//   or if no item is found.
object GetNextItemInInventory(object oTarget=OBJECT_SELF);

// A creature can have up to three classes.  This function determines the
// creature's class (CLASS_TYPE_*) based on nClassPosition.
// - nClassPosition: 1, 2 or 3
// - oCreature
// * Returns CLASS_TYPE_INVALID if the oCreature does not have a class in
//   nClassPosition (i.e. a single-class creature will only have a value in
//   nClassLocation=1) or if oCreature is not a valid creature.
int GetClassByPosition(int nClassPosition, object oCreature=OBJECT_SELF);

// A creature can have up to three classes.  This function determines the
// creature's class level based on nClass Position.
// - nClassPosition: 1, 2 or 3
// - oCreature
// * Returns 0 if oCreature does not have a class in nClassPosition
//   (i.e. a single-class creature will only have a value in nClassLocation=1)
//   or if oCreature is not a valid creature.
int GetLevelByPosition(int nClassPosition, object oCreature=OBJECT_SELF);

// Determine the levels that oCreature holds in nClassType.
// - nClassType: CLASS_TYPE_*
// - oCreature
int GetLevelByClass(int nClassType, object oCreature=OBJECT_SELF);

// Get the amount of damage of type nDamageType that has been dealt to the caller.
// - nDamageType: DAMAGE_TYPE_*
int GetDamageDealtByType(int nDamageType);

// Get the total amount of damage that has been dealt to the caller.
int GetTotalDamageDealt();

// Get the last object that damaged oObject
// * Returns OBJECT_INVALID if oObject is not a valid object.
object GetLastDamager(object oObject=OBJECT_SELF);

// Get the last object that disarmed the trap on the caller.
// * Returns OBJECT_INVALID if the caller is not a valid placeable, trigger or
//   door.
object GetLastDisarmed();

// Get the last object that disturbed the inventory of oObject.
// * Returns OBJECT_INVALID if oObject is not a valid creature or placeable.
object GetLastDisturbed(object oObject=OBJECT_SELF);

// Get the last object that locked oObject.
// * Returns OBJECT_INVALID if oObject is not a valid door or placeable.
object GetLastLocked(object oObject=OBJECT_SELF);

// Get the last object that unlocked oObject.
// * Returns OBJECT_INVALID if oObject is not a valid door or placeable.
object GetLastUnlocked(object oObject=OBJECT_SELF);

// Create a Skill Increase effect.
// - nSkill: SKILL_*
// - nValue
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nSkill is invalid.
effect EffectSkillIncrease(int nSkill, int nValue);

// Get the type of disturbance (INVENTORY_DISTURB_*) that caused the oObject's
// OnInventoryDisturbed script to fire.  This will only work for creatures and
// placeables.
int GetInventoryDisturbType(object oObject=OBJECT_SELF);

// get the item that caused oObject's OnInventoryDisturbed script to fire.
// * Returns OBJECT_INVALID if the oObject is not a valid object.
object GetInventoryDisturbItem(object oObject=OBJECT_SELF);

// Get the henchman belonging to oMaster.
// * Return OBJECT_INVALID if oMaster does not have a henchman.
// -nNth: Which henchman to return.
object GetHenchman(object oMaster=OBJECT_SELF,int nNth=1);

// Set eEffect to be versus a specific alignment.
// - eEffect
// - nLawChaos: ALIGNMENT_LAWFUL/ALIGNMENT_CHAOTIC/ALIGNMENT_ALL
// - nGoodEvil: ALIGNMENT_GOOD/ALIGNMENT_EVIL/ALIGNMENT_ALL
effect VersusAlignmentEffect(effect eEffect, int nLawChaos=ALIGNMENT_ALL, int nGoodEvil=ALIGNMENT_ALL);

// Set eEffect to be versus nRacialType.
// - eEffect
// - nRacialType: RACIAL_TYPE_*
effect VersusRacialTypeEffect(effect eEffect, int nRacialType);

// Set eEffect to be versus traps.
effect VersusTrapEffect(effect eEffect);

// Get the gender of oCreature.
int GetGender(object oCreature);

// * Returns TRUE if tTalent is valid.
int GetIsTalentValid(talent tTalent);

// Causes the action subject to move away from lMoveAwayFrom.
void ActionMoveAwayFromLocation(location lMoveAwayFrom, int bRun=FALSE, float fMoveAwayRange=40.0f);

// Get the target that the caller attempted to attack - this should be used in
// conjunction with GetAttackTarget(). This value is set every time an attack is
// made, and is reset at the end of combat.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetAttemptedAttackTarget();

// Get the type (TALENT_TYPE_*) of tTalent.
int GetTypeFromTalent(talent tTalent);

// Get the ID of tTalent.  This could be a SPELL_*, FEAT_* or SKILL_*.
int GetIdFromTalent(talent tTalent);

// Get the associate of type nAssociateType belonging to oMaster.
// - nAssociateType: ASSOCIATE_TYPE_*
// - nMaster
// - nTh: Which associate of the specified type to return
// * Returns OBJECT_INVALID if no such associate exists.
object GetAssociate(int nAssociateType, object oMaster=OBJECT_SELF, int nTh=1);

// Add oHenchman as a henchman to oMaster
// If oHenchman is either a DM or a player character, this will have no effect.
void AddHenchman(object oMaster, object oHenchman=OBJECT_SELF);

// Remove oHenchman from the service of oMaster, returning them to their original faction.
void RemoveHenchman(object oMaster, object oHenchman=OBJECT_SELF);

// Add a journal quest entry to oCreature.
// - szPlotID: the plot identifier used in the toolset's Journal Editor
// - nState: the state of the plot as seen in the toolset's Journal Editor
// - oCreature
// - bAllPartyMembers: If this is TRUE, the entry will show up in the journal of
//   everyone in the party
// - bAllPlayers: If this is TRUE, the entry will show up in the journal of
//   everyone in the world
// - bAllowOverrideHigher: If this is TRUE, you can set the state to a lower
//   number than the one it is currently on
void AddJournalQuestEntry(string szPlotID, int nState, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE, int bAllowOverrideHigher=FALSE);

// Remove a journal quest entry from oCreature.
// - szPlotID: the plot identifier used in the toolset's Journal Editor
// - oCreature
// - bAllPartyMembers: If this is TRUE, the entry will be removed from the
//   journal of everyone in the party
// - bAllPlayers: If this is TRUE, the entry will be removed from the journal of
//   everyone in the world
void RemoveJournalQuestEntry(string szPlotID, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE);

// Get the public part of the CD Key that oPlayer used when logging in.
// - nSinglePlayerCDKey: If set to TRUE, the player's public CD Key will
//   be returned when the player is playing in single player mode
//   (otherwise returns an empty string in single player mode).
string GetPCPublicCDKey(object oPlayer, int nSinglePlayerCDKey=FALSE);

// Get the IP address from which oPlayer has connected.
string GetPCIPAddress(object oPlayer);

// Get the name of oPlayer.
string GetPCPlayerName(object oPlayer);

// Sets oPlayer and oTarget to like each other.
void SetPCLike(object oPlayer, object oTarget);

// Sets oPlayer and oTarget to dislike each other.
void SetPCDislike(object oPlayer, object oTarget);

// Send a server message (szMessage) to the oPlayer.
void SendMessageToPC(object oPlayer, string szMessage);

// Get the target at which the caller attempted to cast a spell.
// This value is set every time a spell is cast and is reset at the end of
// combat.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetAttemptedSpellTarget();

// Get the last creature that opened oObject.
// * Returns OBJECT_INVALID if oObject is not a valid door, placeable or store.
object GetLastOpenedBy(object oObject=OBJECT_SELF);

// Determines the number of times that oCreature has nSpell memorised.
// - nSpell: SPELL_*
// - oCreature
int GetHasSpell(int nSpell, object oCreature=OBJECT_SELF);

// Open oStore for oPC.
// - nBonusMarkUp is added to the stores default mark up percentage on items sold (-100 to 100)
// - nBonusMarkDown is added to the stores default mark down percentage on items bought (-100 to 100)
void OpenStore(object oStore, object oPC, int nBonusMarkUp=0, int nBonusMarkDown=0);

// Create a Turned effect.
// Turned effects are supernatural by default.
effect EffectTurned();

// Get the first member of oMemberOfFaction's faction (start to cycle through
// oMemberOfFaction's faction).
// * Returns OBJECT_INVALID if oMemberOfFaction's faction is invalid.
object GetFirstFactionMember(object oMemberOfFaction, int bPCOnly=TRUE);

// Get the next member of oMemberOfFaction's faction (continue to cycle through
// oMemberOfFaction's faction).
// * Returns OBJECT_INVALID if oMemberOfFaction's faction is invalid.
object GetNextFactionMember(object oMemberOfFaction, int bPCOnly=TRUE);

// Force the action subject to move to lDestination.
void ActionForceMoveToLocation(location lDestination, int bRun=FALSE, float fTimeout=30.0f);

// Force the action subject to move to oMoveTo.
void ActionForceMoveToObject(object oMoveTo, int bRun=FALSE, float fRange=1.0f, float fTimeout=30.0f);

// Get the experience assigned in the journal editor for szPlotID.
int GetJournalQuestExperience(string szPlotID);

// Jump to oToJumpTo (the action is added to the top of the action queue).
void JumpToObject(object oToJumpTo, int nWalkStraightLineToPoint=1);

// Set whether oMapPin is enabled.
// - oMapPin
// - nEnabled: 0=Off, 1=On
void SetMapPinEnabled(object oMapPin, int nEnabled);

// Create a Hit Point Change When Dying effect.
// - fHitPointChangePerRound: this can be positive or negative, but not zero.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if fHitPointChangePerRound is 0.
effect EffectHitPointChangeWhenDying(float fHitPointChangePerRound);

// Spawn a GUI panel for the client that controls oPC.
// Will force show panels disabled with SetGuiPanelDisabled()
// - oPC
// - nGUIPanel: GUI_PANEL_*, except GUI_PANEL_COMPASS / GUI_PANEL_LEVELUP / GUI_PANEL_GOLD_* / GUI_PANEL_EXAMINE_*
// * Nothing happens if oPC is not a player character or if an invalid value is used for nGUIPanel.
void PopUpGUIPanel(object oPC, int nGUIPanel);

// Clear all personal feelings that oSource has about oTarget.
void ClearPersonalReputation(object oTarget, object oSource=OBJECT_SELF);

// oSource will temporarily be friends towards oTarget.
// bDecays determines whether the personal reputation value decays over time
// fDurationInSeconds is the length of time that the temporary friendship lasts
// Make oSource into a temporary friend of oTarget using personal reputation.
// - oTarget
// - oSource
// - bDecays: If this is TRUE, the friendship decays over fDurationInSeconds;
//   otherwise it is indefinite.
// - fDurationInSeconds: This is only used if bDecays is TRUE, it is how long
//   the friendship lasts.
// Note: If bDecays is TRUE, the personal reputation amount decreases in size
// over fDurationInSeconds. Friendship will only be in effect as long as
// (faction reputation + total personal reputation) >= REPUTATION_TYPE_FRIEND.
void SetIsTemporaryFriend(object oTarget, object oSource=OBJECT_SELF, int bDecays=FALSE, float fDurationInSeconds=180.0f);

// Make oSource into a temporary enemy of oTarget using personal reputation.
// - oTarget
// - oSource
// - bDecays: If this is TRUE, the enmity decays over fDurationInSeconds;
//   otherwise it is indefinite.
// - fDurationInSeconds: This is only used if bDecays is TRUE, it is how long
//   the enmity lasts.
// Note: If bDecays is TRUE, the personal reputation amount decreases in size
// over fDurationInSeconds. Enmity will only be in effect as long as
// (faction reputation + total personal reputation) <= REPUTATION_TYPE_ENEMY.
void SetIsTemporaryEnemy(object oTarget, object oSource=OBJECT_SELF, int bDecays=FALSE, float fDurationInSeconds=180.0f);

// Make oSource temporarily neutral to oTarget using personal reputation.
// - oTarget
// - oSource
// - bDecays: If this is TRUE, the neutrality decays over fDurationInSeconds;
//   otherwise it is indefinite.
// - fDurationInSeconds: This is only used if bDecays is TRUE, it is how long
//   the neutrality lasts.
// Note: If bDecays is TRUE, the personal reputation amount decreases in size
// over fDurationInSeconds. Neutrality will only be in effect as long as
// (faction reputation + total personal reputation) > REPUTATION_TYPE_ENEMY and
// (faction reputation + total personal reputation) < REPUTATION_TYPE_FRIEND.
void SetIsTemporaryNeutral(object oTarget, object oSource=OBJECT_SELF, int bDecays=FALSE, float fDurationInSeconds=180.0f);

// Gives nXpAmount to oCreature.
void GiveXPToCreature(object oCreature, int nXpAmount);

// Sets oCreature's experience to nXpAmount.
void SetXP(object oCreature, int nXpAmount);

// Get oCreature's experience.
int GetXP(object oCreature);

// Convert nInteger to hex, returning the hex value as a string.
// * Return value has the format "0x????????" where each ? will be a hex digit
//   (8 digits in total).
string IntToHexString(int nInteger);

// Get the base item type (BASE_ITEM_*) of oItem.
// * Returns BASE_ITEM_INVALID if oItem is an invalid item.
int GetBaseItemType(object oItem);

// Determines whether oItem has nProperty.
// - oItem
// - nProperty: ITEM_PROPERTY_*
// * Returns FALSE if oItem is not a valid item, or if oItem does not have
//   nProperty.
int GetItemHasItemProperty(object oItem, int nProperty);

// The creature will equip the melee weapon in its possession that can do the
// most damage. If no valid melee weapon is found, it will equip the most
// damaging range weapon. This function should only ever be called in the
// EndOfCombatRound scripts, because otherwise it would have to stop the combat
// round to run simulation.
// - oVersus: You can try to get the most damaging weapon against oVersus
// - bOffHand
void ActionEquipMostDamagingMelee(object oVersus=OBJECT_INVALID, int bOffHand=FALSE);

// The creature will equip the range weapon in its possession that can do the
// most damage.
// If no valid range weapon can be found, it will equip the most damaging melee
// weapon.
// - oVersus: You can try to get the most damaging weapon against oVersus
void ActionEquipMostDamagingRanged(object oVersus=OBJECT_INVALID);

// Get the Armour Class of oItem.
// * Return 0 if the oItem is not a valid item, or if oItem has no armour value.
int GetItemACValue(object oItem);

// The creature will rest if not in combat and no enemies are nearby.
// - bCreatureToEnemyLineOfSightCheck: TRUE to allow the creature to rest if enemies
//                                     are nearby, but the creature can't see the enemy.
//                                     FALSE the creature will not rest if enemies are
//                                     nearby regardless of whether or not the creature
//                                     can see them, such as if an enemy is close by,
//                                     but is in a different room behind a closed door.
void ActionRest(int bCreatureToEnemyLineOfSightCheck=FALSE);

// Expose/Hide the entire map of oArea for oPlayer.
// - oArea: The area that the map will be exposed/hidden for.
// - oPlayer: The player the map will be exposed/hidden for.
// - bExplored: TRUE/FALSE. Whether the map should be completely explored or hidden.
void ExploreAreaForPlayer(object oArea, object oPlayer, int bExplored=TRUE);

// The creature will equip the armour in its possession that has the highest
// armour class.
void ActionEquipMostEffectiveArmor();

// * Returns TRUE if it is currently day.
int GetIsDay();

// * Returns TRUE if it is currently night.
int GetIsNight();

// * Returns TRUE if it is currently dawn.
int GetIsDawn();

// * Returns TRUE if it is currently dusk.
int GetIsDusk();

// * Returns TRUE if oCreature was spawned from an encounter.
int GetIsEncounterCreature(object oCreature=OBJECT_SELF);

// Use this in an OnPlayerDying module script to get the last player who is dying.
object GetLastPlayerDying();

// Get the starting location of the module.
location GetStartingLocation();

// Make oCreatureToChange join one of the standard factions.
// ** This will only work on an NPC **
// - nStandardFaction: STANDARD_FACTION_*
void ChangeToStandardFaction(object oCreatureToChange, int nStandardFaction);

// Play oSound.
void SoundObjectPlay(object oSound);

// Stop playing oSound.
void SoundObjectStop(object oSound);

// Set the volume of oSound.
// - oSound
// - nVolume: 0-127
void SoundObjectSetVolume(object oSound, int nVolume);

// Set the position of oSound.
void SoundObjectSetPosition(object oSound, vector vPosition);

// Immediately speak a conversation one-liner.
// - sDialogResRef
// - oTokenTarget: This must be specified if there are creature-specific tokens
//   in the string.
void SpeakOneLinerConversation(string sDialogResRef="", object oTokenTarget=OBJECT_TYPE_INVALID);

// Get the amount of gold possessed by oTarget.
int GetGold(object oTarget=OBJECT_SELF);

// Use this in an OnRespawnButtonPressed module script to get the object id of
// the player who last pressed the respawn button.
object GetLastRespawnButtonPresser();

// * Returns TRUE if oCreature is the Dungeon Master.
// Note: This will return FALSE if oCreature is a DM Possessed creature.
// To determine if oCreature is a DM Possessed creature, use GetIsDMPossessed()
int GetIsDM(object oCreature);

// Play a voice chat.
// - nVoiceChatID: VOICE_CHAT_*
// - oTarget
void PlayVoiceChat(int nVoiceChatID, object oTarget=OBJECT_SELF);

// * Returns TRUE if the weapon equipped is capable of damaging oVersus.
int GetIsWeaponEffective(object oVersus=OBJECT_INVALID, int bOffHand=FALSE);

// Use this in a SpellCast script to determine whether the spell was considered
// harmful.
// * Returns TRUE if the last spell cast was harmful.
int GetLastSpellHarmful();

// Activate oItem.
event EventActivateItem(object oItem, location lTarget, object oTarget=OBJECT_INVALID);

// Play the background music for oArea.
void MusicBackgroundPlay(object oArea);

// Stop the background music for oArea.
void MusicBackgroundStop(object oArea);

// Set the delay for the background music for oArea.
// - oArea
// - nDelay: delay in milliseconds
void MusicBackgroundSetDelay(object oArea, int nDelay);

// Change the background day track for oArea to nTrack.
// - oArea
// - nTrack
void MusicBackgroundChangeDay(object oArea, int nTrack);

// Change the background night track for oArea to nTrack.
// - oArea
// - nTrack
void MusicBackgroundChangeNight(object oArea, int nTrack);

// Play the battle music for oArea.
void MusicBattlePlay(object oArea);

// Stop the battle music for oArea.
void MusicBattleStop(object oArea);

// Change the battle track for oArea.
// - oArea
// - nTrack
void MusicBattleChange(object oArea, int nTrack);

// Play the ambient sound for oArea.
void AmbientSoundPlay(object oArea);

// Stop the ambient sound for oArea.
void AmbientSoundStop(object oArea);

// Change the ambient day track for oArea to nTrack.
// - oArea
// - nTrack
void AmbientSoundChangeDay(object oArea, int nTrack);

// Change the ambient night track for oArea to nTrack.
// - oArea
// - nTrack
void AmbientSoundChangeNight(object oArea, int nTrack);

// Get the object that killed the caller.
object GetLastKiller();

// Use this in a spell script to get the item used to cast the spell.
object GetSpellCastItem();

// Use this in an OnItemActivated module script to get the item that was activated.
object GetItemActivated();

// Use this in an OnItemActivated module script to get the creature that
// activated the item.
object GetItemActivator();

// Use this in an OnItemActivated module script to get the location of the item's
// target.
location GetItemActivatedTargetLocation();

// Use this in an OnItemActivated module script to get the item's target.
object GetItemActivatedTarget();

// * Returns TRUE if oObject (which is a placeable or a door) is currently open.
int GetIsOpen(object oObject);

// Take nAmount of gold from oCreatureToTakeFrom.
// - nAmount
// - oCreatureToTakeFrom: If this is not a valid creature, nothing will happen.
// - bDestroy: If this is TRUE, the caller will not get the gold.  Instead, the
//   gold will be destroyed and will vanish from the game.
void TakeGoldFromCreature(int nAmount, object oCreatureToTakeFrom, int bDestroy=FALSE);

// Determine whether oObject is in conversation.
int IsInConversation(object oObject);

// Create an Ability Decrease effect.
// - nAbility: ABILITY_*
// - nModifyBy: This is the amount by which to decrement the ability
effect EffectAbilityDecrease(int nAbility, int nModifyBy);

// Create an Attack Decrease effect.
// - nPenalty
// - nModifierType: ATTACK_BONUS_*
effect EffectAttackDecrease(int nPenalty, int nModifierType=ATTACK_BONUS_MISC);

// Create a Damage Decrease effect.
// - nPenalty
// - nDamageType: DAMAGE_TYPE_*
effect EffectDamageDecrease(int nPenalty, int nDamageType=DAMAGE_TYPE_MAGICAL);

// Create a Damage Immunity Decrease effect.
// - nDamageType: DAMAGE_TYPE_*
// - nPercentImmunity
effect EffectDamageImmunityDecrease(int nDamageType, int nPercentImmunity);

// Create an AC Decrease effect.
// - nValue
// - nModifyType: AC_*
// - nDamageType: DAMAGE_TYPE_*
//   * Default value for nDamageType should only ever be used in this function prototype.
effect EffectACDecrease(int nValue, int nModifyType=AC_DODGE_BONUS, int nDamageType=AC_VS_DAMAGE_TYPE_ALL);

// Create a Movement Speed Decrease effect.
// - nPercentChange - range 0 through 99
// eg.
//    0 = no change in speed
//   50 = 50% slower
//   99 = almost immobile
effect EffectMovementSpeedDecrease(int nPercentChange);

// Create a Saving Throw Decrease effect.
// - nSave: SAVING_THROW_* (not SAVING_THROW_TYPE_*)
//          SAVING_THROW_ALL
//          SAVING_THROW_FORT
//          SAVING_THROW_REFLEX
//          SAVING_THROW_WILL
// - nValue: size of the Saving Throw decrease
// - nSaveType: SAVING_THROW_TYPE_* (e.g. SAVING_THROW_TYPE_ACID )
effect EffectSavingThrowDecrease(int nSave, int nValue, int nSaveType=SAVING_THROW_TYPE_ALL);

// Create a Skill Decrease effect.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nSkill is invalid.
effect EffectSkillDecrease(int nSkill, int nValue);

// Create a Spell Resistance Decrease effect.
effect EffectSpellResistanceDecrease(int nValue);

// Determine whether oTarget is a plot object.
int GetPlotFlag(object oTarget=OBJECT_SELF);

// Set oTarget's plot object status.
void SetPlotFlag(object oTarget, int nPlotFlag);

// Create an Invisibility effect.
// - nInvisibilityType: INVISIBILITY_TYPE_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nInvisibilityType
//   is invalid.
effect EffectInvisibility(int nInvisibilityType);

// Create a Concealment effect.
// - nPercentage: 1-100 inclusive
// - nMissChanceType: MISS_CHANCE_TYPE_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nPercentage < 1 or
//   nPercentage > 100.
effect EffectConcealment(int nPercentage, int nMissType=MISS_CHANCE_TYPE_NORMAL);

// Create a Darkness effect.
effect EffectDarkness();

// Create a Dispel Magic All effect.
// If no parameter is specified, USE_CREATURE_LEVEL will be used. This will
// cause the dispel effect to use the level of the creature that created the
// effect.
effect EffectDispelMagicAll(int nCasterLevel=USE_CREATURE_LEVEL);

// Create an Ultravision effect.
effect EffectUltravision();

// Create a Negative Level effect.
// - nNumLevels: the number of negative levels to apply.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nNumLevels > 100.
effect EffectNegativeLevel(int nNumLevels, int bHPBonus=FALSE);

// Create a Polymorph effect.
// - nLocked: If TRUE the creature cannot cancel the polymorph. 
// - nUnpolymorphVFX: If -1 no VFX will play when this polymorph is removed. Else will play the relevant VFX.
// - nSpellAbilityModifier: Set a custom spell ability modifier for the 3 polymorph spells. 
//                          Save DC is 10 + Innate spell level + this ability modifier.
//                          -1 uses the creators spellcasting/feat using class spellcasting ability modifier.
// - nSpellAbilityCasterLevel: Set a custom caster level for the 3 polymorph spells.
//                             Default (0) is to use the first class slot class level as previously.
effect EffectPolymorph(int nPolymorphSelection, int nLocked=FALSE, int nUnpolymorphVFX=VFX_IMP_POLYMORPH, int nSpellAbilityModifier = -1, int nSpellAbilityCasterLevel = 0);

// Create a Sanctuary effect.
// - nDifficultyClass: must be a non-zero, positive number
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nDifficultyClass <= 0.
effect EffectSanctuary(int nDifficultyClass);

// Create a True Seeing effect.
effect EffectTrueSeeing();

// Create a See Invisible effect.
effect EffectSeeInvisible();

// Create a Time Stop effect.
effect EffectTimeStop();

// Create a Blindness effect.
effect EffectBlindness();

// Determine whether oSource has a friendly reaction towards oTarget, depending
// on the reputation, PVP setting and (if both oSource and oTarget are PCs),
// oSource's Like/Dislike setting for oTarget.
// Note: If you just want to know how two objects feel about each other in terms
// of faction and personal reputation, use GetIsFriend() instead.
// * Returns TRUE if oSource has a friendly reaction towards oTarget
int GetIsReactionTypeFriendly(object oTarget, object oSource=OBJECT_SELF);

// Determine whether oSource has a neutral reaction towards oTarget, depending
// on the reputation, PVP setting and (if both oSource and oTarget are PCs),
// oSource's Like/Dislike setting for oTarget.
// Note: If you just want to know how two objects feel about each other in terms
// of faction and personal reputation, use GetIsNeutral() instead.
// * Returns TRUE if oSource has a neutral reaction towards oTarget
int GetIsReactionTypeNeutral(object oTarget, object oSource=OBJECT_SELF);

// Determine whether oSource has a Hostile reaction towards oTarget, depending
// on the reputation, PVP setting and (if both oSource and oTarget are PCs),
// oSource's Like/Dislike setting for oTarget.
// Note: If you just want to know how two objects feel about each other in terms
// of faction and personal reputation, use GetIsEnemy() instead.
// * Returns TRUE if oSource has a hostile reaction towards oTarget
int GetIsReactionTypeHostile(object oTarget, object oSource=OBJECT_SELF);

// Create a Spell Level Absorption effect.
// - nMaxSpellLevelAbsorbed: maximum spell level that will be absorbed by the
//   effect
// - nTotalSpellLevelsAbsorbed: maximum number of spell levels that will be
//   absorbed by the effect
// - nSpellSchool: SPELL_SCHOOL_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if:
//   nMaxSpellLevelAbsorbed is not between -1 and 9 inclusive, or nSpellSchool
//   is invalid.
effect EffectSpellLevelAbsorption(int nMaxSpellLevelAbsorbed, int nTotalSpellLevelsAbsorbed=0, int nSpellSchool=SPELL_SCHOOL_GENERAL );

// Create a Dispel Magic Best effect.
// If no parameter is specified, USE_CREATURE_LEVEL will be used. This will
// cause the dispel effect to use the level of the creature that created the
// effect.
effect EffectDispelMagicBest(int nCasterLevel=USE_CREATURE_LEVEL);

// Try to send oTarget to a new server defined by sIPaddress.
// - oTarget
// - sIPaddress: this can be numerical "192.168.0.84" or alphanumeric
//   "www.bioware.com". It can also contain a port "192.168.0.84:5121" or
//   "www.bioware.com:5121"; if the port is not specified, it will default to
//   5121.
// - sPassword: login password for the destination server
// - sWaypointTag: if this is set, after portalling the character will be moved
//   to this waypoint if it exists
// - bSeamless: if this is set, the client wil not be prompted with the
//   information window telling them about the server, and they will not be
//   allowed to save a copy of their character if they are using a local vault
//   character.
void ActivatePortal(object oTarget, string sIPaddress="", string sPassword="", string sWaypointTag="", int bSeemless=FALSE);

// Get the number of stacked items that oItem comprises.
int GetNumStackedItems(object oItem);

// Use this on an NPC to cause all creatures within a 10-metre radius to stop
// what they are doing and sets the NPC's enemies within this range to be
// neutral towards the NPC for roughly 3 minutes. If this command is run on a PC
// or an object that is not a creature, nothing will happen.
void SurrenderToEnemies();

// Create a Miss Chance effect.
// - nPercentage: 1-100 inclusive
// - nMissChanceType: MISS_CHANCE_TYPE_*
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nPercentage < 1 or
//   nPercentage > 100.
effect EffectMissChance(int nPercentage, int nMissChanceType=MISS_CHANCE_TYPE_NORMAL);

// Get the number of Hitdice worth of Turn Resistance that oUndead may have.
// This will only work on undead creatures.
int GetTurnResistanceHD(object oUndead=OBJECT_SELF);

// Get the size (CREATURE_SIZE_*) of oCreature.
int GetCreatureSize(object oCreature);

// Create a Disappear/Appear effect.
// The object will "fly away" for the duration of the effect and will reappear
// at lLocation.
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
effect EffectDisappearAppear(location lLocation, int nAnimation=1);

// Create a Disappear effect to make the object "fly away" and then destroy
// itself.
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
effect EffectDisappear(int nAnimation=1);

// Create an Appear effect to make the object "fly in".
// - nAnimation determines which appear and disappear animations to use. Most creatures
// only have animation 1, although a few have 2 (like beholders)
effect EffectAppear(int nAnimation=1);

// The action subject will unlock oTarget, which can be a door or a placeable
// object.
void ActionUnlockObject(object oTarget);

// The action subject will lock oTarget, which can be a door or a placeable
// object.
void ActionLockObject(object oTarget);

// Create a Modify Attacks effect to add attacks.
// - nAttacks: maximum is 5, even with the effect stacked
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nAttacks > 5.
effect EffectModifyAttacks(int nAttacks);

// Get the last trap detected by oTarget.
// * Return value on error: OBJECT_INVALID
object GetLastTrapDetected(object oTarget=OBJECT_SELF);

// Create a Damage Shield effect which does (nDamageAmount + nRandomAmount)
// damage to any melee attacker on a successful attack of damage type nDamageType.
// - nDamageAmount: an integer value
// - nRandomAmount: DAMAGE_BONUS_*
// - nDamageType: DAMAGE_TYPE_*
// NOTE! You *must* use the DAMAGE_BONUS_* constants! Using other values may
//       result in odd behaviour.
effect EffectDamageShield(int nDamageAmount, int nRandomAmount, int nDamageType);

// Get the trap nearest to oTarget.
// Note : "trap objects" are actually any trigger, placeable or door that is
// trapped in oTarget's area.
// - oTarget
// - nTrapDetected: if this is TRUE, the trap returned has to have been detected
//   by oTarget.
object GetNearestTrapToObject(object oTarget=OBJECT_SELF, int nTrapDetected=TRUE);

// Get the name of oCreature's deity.
// * Returns "" if oCreature is invalid (or if the deity name is blank for
//   oCreature).
string GetDeity(object oCreature);

// Get the name of oCreature's sub race.
// * Returns "" if oCreature is invalid (or if sub race is blank for oCreature).
string GetSubRace(object oTarget);

// Get oTarget's base fortitude saving throw value (this will only work for
// creatures, doors, and placeables).
// * Returns 0 if oTarget is invalid.
int GetFortitudeSavingThrow(object oTarget);

// Get oTarget's base will saving throw value (this will only work for creatures,
// doors, and placeables).
// * Returns 0 if oTarget is invalid.
int GetWillSavingThrow(object oTarget);

// Get oTarget's base reflex saving throw value (this will only work for
// creatures, doors, and placeables).
// * Returns 0 if oTarget is invalid.
int GetReflexSavingThrow(object oTarget);

// Get oCreature's challenge rating.
// * Returns 0.0 if oCreature is invalid.
float GetChallengeRating(object oCreature);

// Get oCreature's age.
// * Returns 0 if oCreature is invalid.
int GetAge(object oCreature);

// Get oCreature's movement rate.
// * Returns 0 if oCreature is invalid.
int GetMovementRate(object oCreature);

// Get oCreature's familiar creature type (FAMILIAR_CREATURE_TYPE_*).
// * Returns FAMILIAR_CREATURE_TYPE_NONE if oCreature is invalid or does not
//   currently have a familiar.
int GetFamiliarCreatureType(object oCreature);

// Get oCreature's animal companion creature type
// (ANIMAL_COMPANION_CREATURE_TYPE_*).
// * Returns ANIMAL_COMPANION_CREATURE_TYPE_NONE if oCreature is invalid or does
//   not currently have an animal companion.
int GetAnimalCompanionCreatureType(object oCreature);

// Get oCreature's familiar's name.
// * Returns "" if oCreature is invalid, does not currently
// have a familiar or if the familiar's name is blank.
string GetFamiliarName(object oCreature);

// Get oCreature's animal companion's name.
// * Returns "" if oCreature is invalid, does not currently
// have an animal companion or if the animal companion's name is blank.
string GetAnimalCompanionName(object oTarget);

// The action subject will fake casting a spell at oTarget; the conjure and cast
// animations and visuals will occur, nothing else.
// - nSpell
// - oTarget
// - nProjectilePathType: PROJECTILE_PATH_TYPE_*
void ActionCastFakeSpellAtObject(int nSpell, object oTarget, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT);

// The action subject will fake casting a spell at lLocation; the conjure and
// cast animations and visuals will occur, nothing else.
// - nSpell
// - lTarget
// - nProjectilePathType: PROJECTILE_PATH_TYPE_*
void ActionCastFakeSpellAtLocation(int nSpell, location lTarget, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT);

// Removes oAssociate from the service of oMaster, returning them to their
// original faction.
void RemoveSummonedAssociate(object oMaster, object oAssociate=OBJECT_SELF);

// Set the camera mode for oPlayer.
// - oPlayer
// - nCameraMode: CAMERA_MODE_*
// * If oPlayer is not player-controlled or nCameraMode is invalid, nothing
//   happens.
void SetCameraMode(object oPlayer, int nCameraMode);

// * Returns TRUE if oCreature is resting.
int GetIsResting(object oCreature=OBJECT_SELF);

// Get the last PC that has rested in the module.
object GetLastPCRested();

// Set the weather for oTarget.
// - oTarget: if this is GetModule(), all outdoor areas will be modified by the
//   weather constant. If it is an area, oTarget will play the weather only if
//   it is an outdoor area.
// - nWeather: WEATHER_*
//   -> WEATHER_USER_AREA_SETTINGS will set the area back to random weather.
//   -> WEATHER_CLEAR, WEATHER_RAIN, WEATHER_SNOW will make the weather go to
//      the appropriate precipitation *without stopping*.
void SetWeather(object oTarget, int nWeather);

// Determine the type (REST_EVENTTYPE_REST_*) of the last rest event (as
// returned from the OnPCRested module event).
int GetLastRestEventType();

// Shut down the currently loaded module and start a new one (moving all
// currently-connected players to the starting point.
void StartNewModule(string sModuleName);

// Create a Swarm effect.
// - nLooping: If this is TRUE, for the duration of the effect when one creature
//   created by this effect dies, the next one in the list will be created.  If
//   the last creature in the list dies, we loop back to the beginning and
//   sCreatureTemplate1 will be created, and so on...
// - sCreatureTemplate1
// - sCreatureTemplate2
// - sCreatureTemplate3
// - sCreatureTemplate4
effect EffectSwarm(int nLooping, string sCreatureTemplate1, string sCreatureTemplate2="", string sCreatureTemplate3="", string sCreatureTemplate4="");

// * Returns TRUE if oItem is a ranged weapon.
int GetWeaponRanged(object oItem);

// Only if we are in a single player game, AutoSave the game.
void DoSinglePlayerAutoSave();

// Get the game difficulty (GAME_DIFFICULTY_*).
int GetGameDifficulty();

// Set the main light color on the tile at lTileLocation.
// - lTileLocation: the vector part of this is the tile grid (x,y) coordinate of
//   the tile.
// - nMainLight1Color: TILE_MAIN_LIGHT_COLOR_*
// - nMainLight2Color: TILE_MAIN_LIGHT_COLOR_*
void SetTileMainLightColor(location lTileLocation, int nMainLight1Color, int nMainLight2Color);

// Set the source light color on the tile at lTileLocation.
// - lTileLocation: the vector part of this is the tile grid (x,y) coordinate of
//   the tile.
// - nSourceLight1Color: TILE_SOURCE_LIGHT_COLOR_*
// - nSourceLight2Color: TILE_SOURCE_LIGHT_COLOR_*
void SetTileSourceLightColor(location lTileLocation, int nSourceLight1Color, int nSourceLight2Color);

// All clients in oArea will recompute the static lighting.
// This can be used to update the lighting after changing any tile lights or if
// placeables with lights have been added/deleted.
void RecomputeStaticLighting(object oArea);

// Get the color (TILE_MAIN_LIGHT_COLOR_*) for the main light 1 of the tile at
// lTile.
// - lTile: the vector part of this is the tile grid (x,y) coordinate of the tile.
int GetTileMainLight1Color(location lTile);

// Get the color (TILE_MAIN_LIGHT_COLOR_*) for the main light 2 of the tile at
// lTile.
// - lTile: the vector part of this is the tile grid (x,y) coordinate of the
//   tile.
int GetTileMainLight2Color(location lTile);

// Get the color (TILE_SOURCE_LIGHT_COLOR_*) for the source light 1 of the tile
// at lTile.
// - lTile: the vector part of this is the tile grid (x,y) coordinate of the
//   tile.
int GetTileSourceLight1Color(location lTile);

// Get the color (TILE_SOURCE_LIGHT_COLOR_*) for the source light 2 of the tile
// at lTile.
// - lTile: the vector part of this is the tile grid (x,y) coordinate of the
//   tile.
int GetTileSourceLight2Color(location lTile);

// Make the corresponding panel button on the player's client start or stop
// flashing.
// - oPlayer
// - nButton: PANEL_BUTTON_*
// - nEnableFlash: if this is TRUE nButton will start flashing.  It if is FALSE,
//   nButton will stop flashing.
void SetPanelButtonFlash(object oPlayer, int nButton, int nEnableFlash);

// Get the current action (ACTION_*) that oObject is executing.
int GetCurrentAction(object oObject=OBJECT_SELF);

// Set how nStandardFaction feels about oCreature.
// - nStandardFaction: STANDARD_FACTION_*
// - nNewReputation: 0-100 (inclusive)
// - oCreature
void SetStandardFactionReputation(int nStandardFaction, int nNewReputation, object oCreature=OBJECT_SELF);

// Find out how nStandardFaction feels about oCreature.
// - nStandardFaction: STANDARD_FACTION_*
// - oCreature
// Returns -1 on an error.
// Returns 0-100 based on the standing of oCreature within the faction nStandardFaction.
// 0-10   :  Hostile.
// 11-89  :  Neutral.
// 90-100 :  Friendly.
int GetStandardFactionReputation(int nStandardFaction, object oCreature=OBJECT_SELF);

// Display floaty text above the specified creature.
// The text will also appear in the chat buffer of each player that receives the
// floaty text.
// - nStrRefToDisplay: String ref (therefore text is translated)
// - oCreatureToFloatAbove
// - bBroadcastToFaction: If this is TRUE then only creatures in the same faction
//   as oCreatureToFloatAbove
//   will see the floaty text, and only if they are within range (30 metres).
// - bChatWindow:  If TRUE, the string reference will be displayed in oCreatureToFloatAbove's chat window
void FloatingTextStrRefOnCreature(int nStrRefToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE, int bChatWindow=TRUE);

// Display floaty text above the specified creature.
// The text will also appear in the chat buffer of each player that receives the
// floaty text.
// - sStringToDisplay: String
// - oCreatureToFloatAbove
// - bBroadcastToFaction: If this is TRUE then only creatures in the same faction
//   as oCreatureToFloatAbove
//   will see the floaty text, and only if they are within range (30 metres).
// - bChatWindow:  If TRUE, sStringToDisplay will be displayed in oCreatureToFloatAbove's chat window.
void FloatingTextStringOnCreature(string sStringToDisplay, object oCreatureToFloatAbove, int bBroadcastToFaction=TRUE, int bChatWindow=TRUE);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject is disarmable.
int GetTrapDisarmable(object oTrapObject);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject is detectable.
int GetTrapDetectable(object oTrapObject);

// - oTrapObject: a placeable, door or trigger
// - oCreature
// * Returns TRUE if oCreature has detected oTrapObject
int GetTrapDetectedBy(object oTrapObject, object oCreature);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject has been flagged as visible to all creatures.
int GetTrapFlagged(object oTrapObject);

// Get the trap base type (TRAP_BASE_TYPE_*) of oTrapObject.
// - oTrapObject: a placeable, door or trigger
int GetTrapBaseType(object oTrapObject);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject is one-shot (i.e. it does not reset itself
//   after firing.
int GetTrapOneShot(object oTrapObject);

// Get the creator of oTrapObject, the creature that set the trap.
// - oTrapObject: a placeable, door or trigger
// * Returns OBJECT_INVALID if oTrapObject was created in the toolset.
object GetTrapCreator(object oTrapObject);

// Get the tag of the key that will disarm oTrapObject.
// - oTrapObject: a placeable, door or trigger
string GetTrapKeyTag(object oTrapObject);

// Get the DC for disarming oTrapObject.
// - oTrapObject: a placeable, door or trigger
int GetTrapDisarmDC(object oTrapObject);

// Get the DC for detecting oTrapObject.
// - oTrapObject: a placeable, door or trigger
int GetTrapDetectDC(object oTrapObject);

// * Returns TRUE if a specific key is required to open the lock on oObject.
int GetLockKeyRequired(object oObject);

// Get the tag of the key that will open the lock on oObject.
string GetLockKeyTag(object oObject);

// * Returns TRUE if the lock on oObject is lockable.
int GetLockLockable(object oObject);

// Get the DC for unlocking oObject.
int GetLockUnlockDC(object oObject);

// Get the DC for locking oObject.
int GetLockLockDC(object oObject);

// Get the last PC that levelled up.
object GetPCLevellingUp();

// - nFeat: FEAT_*
// - oObject
// * Returns TRUE if oObject has effects on it originating from nFeat.
int GetHasFeatEffect(int nFeat, object oObject=OBJECT_SELF);

// Set the status of the illumination for oPlaceable.
// - oPlaceable
// - bIlluminate: if this is TRUE, oPlaceable's illumination will be turned on.
//   If this is FALSE, oPlaceable's illumination will be turned off.
// Note: You must call RecomputeStaticLighting() after calling this function in
// order for the changes to occur visually for the players.
// SetPlaceableIllumination() buffers the illumination changes, which are then
// sent out to the players once RecomputeStaticLighting() is called.  As such,
// it is best to call SetPlaceableIllumination() for all the placeables you wish
// to set the illumination on, and then call RecomputeStaticLighting() once after
// all the placeable illumination has been set.
// * If oPlaceable is not a placeable object, or oPlaceable is a placeable that
//   doesn't have a light, nothing will happen.
void SetPlaceableIllumination(object oPlaceable=OBJECT_SELF, int bIlluminate=TRUE);

// * Returns TRUE if the illumination for oPlaceable is on
int GetPlaceableIllumination(object oPlaceable=OBJECT_SELF);

// - oPlaceable
// - nPlaceableAction: PLACEABLE_ACTION_*
// * Returns TRUE if nPlacebleAction is valid for oPlaceable.
int GetIsPlaceableObjectActionPossible(object oPlaceable, int nPlaceableAction);

// The caller performs nPlaceableAction on oPlaceable.
// - oPlaceable
// - nPlaceableAction: PLACEABLE_ACTION_*
void DoPlaceableObjectAction(object oPlaceable, int nPlaceableAction);

// Get the first PC in the player list.
// This resets the position in the player list for GetNextPC().
object GetFirstPC();

// Get the next PC in the player list.
// This picks up where the last GetFirstPC() or GetNextPC() left off.
object GetNextPC();

// Set whether or not the creature oDetector has detected the trapped object oTrap.
// - oTrap: A trapped trigger, placeable or door object.
// - oDetector: This is the creature that the detected status of the trap is being adjusted for.
// - bDetected: A Boolean that sets whether the trapped object has been detected or not.
int SetTrapDetectedBy(object oTrap, object oDetector, int bDetected=TRUE);

// Note: Only placeables, doors and triggers can be trapped.
// * Returns TRUE if oObject is trapped.
int GetIsTrapped(object oObject);

// Create a Turn Resistance Decrease effect.
// - nHitDice: a positive number representing the number of hit dice for the
///  decrease
effect EffectTurnResistanceDecrease(int nHitDice);

// Create a Turn Resistance Increase effect.
// - nHitDice: a positive number representing the number of hit dice for the
//   increase
effect EffectTurnResistanceIncrease(int nHitDice);

// Spawn in the Death GUI.
// The default (as defined by BioWare) can be spawned in by PopUpGUIPanel, but
// if you want to turn off the "Respawn" or "Wait for Help" buttons, this is the
// function to use.
// - oPC
// - bRespawnButtonEnabled: if this is TRUE, the "Respawn" button will be enabled
//   on the Death GUI.
// - bWaitForHelpButtonEnabled: if this is TRUE, the "Wait For Help" button will
//   be enabled on the Death GUI (Note: This button will not appear in single player games).
// - nHelpStringReference
// - sHelpString
void PopUpDeathGUIPanel(object oPC, int bRespawnButtonEnabled=TRUE, int bWaitForHelpButtonEnabled=TRUE, int nHelpStringReference=0, string sHelpString="");

// Disable oTrap.
// - oTrap: a placeable, door or trigger.
void SetTrapDisabled(object oTrap);

// Get the last object that was sent as a GetLastAttacker(), GetLastDamager(),
// GetLastSpellCaster() (for a hostile spell), or GetLastDisturbed() (when a
// creature is pickpocketed).
// Note: Return values may only ever be:
// 1) A Creature
// 2) Plot Characters will never have this value set
// 3) Area of Effect Objects will return the AOE creator if they are registered
//    as this value, otherwise they will return INVALID_OBJECT_ID
// 4) Traps will not return the creature that set the trap.
// 5) This value will never be overwritten by another non-creature object.
// 6) This value will never be a dead/destroyed creature
object GetLastHostileActor(object oVictim=OBJECT_SELF);

// Force all the characters of the players who are currently in the game to
// be exported to their respective directories i.e. LocalVault/ServerVault/ etc.
void ExportAllCharacters();

// Get the Day Track for oArea.
int MusicBackgroundGetDayTrack(object oArea);

// Get the Night Track for oArea.
int MusicBackgroundGetNightTrack(object oArea);

// Write sLogEntry as a timestamped entry into the log file
void WriteTimestampedLogEntry(string sLogEntry);

// Get the module's name in the language of the server that's running it.
// * If there is no entry for the language of the server, it will return an
//   empty string
string GetModuleName();

// Get the player leader of the faction of which oMemberOfFaction is a member.
// * Returns OBJECT_INVALID if oMemberOfFaction is not a valid creature,
//   or oMemberOfFaction is a member of a NPC faction.
object GetFactionLeader(object oMemberOfFaction);

// Sends szMessage to all the Dungeon Masters currently on the server.
void SendMessageToAllDMs(string szMessage);

// End the currently running game, play sEndMovie then return all players to the
// game's main menu.
void EndGame(string sEndMovie);

// Remove oPlayer from the server.
// You can optionally specify a reason to override the text shown to the player.
void BootPC(object oPlayer, string sReason = "");

// Counterspell oCounterSpellTarget.
void ActionCounterSpell(object oCounterSpellTarget);

// Set the ambient day volume for oArea to nVolume.
// - oArea
// - nVolume: 0 - 100
void AmbientSoundSetDayVolume(object oArea, int nVolume);

// Set the ambient night volume for oArea to nVolume.
// - oArea
// - nVolume: 0 - 100
void AmbientSoundSetNightVolume(object oArea, int nVolume);

// Get the Battle Track for oArea.
int MusicBackgroundGetBattleTrack(object oArea);

// Determine whether oObject has an inventory.
// * Returns TRUE for creatures and stores, and checks to see if an item or placeable object is a container.
// * Returns FALSE for all other object types.
int GetHasInventory(object oObject);

// Get the duration (in seconds) of the sound attached to nStrRef
// * Returns 0.0f if no duration is stored or if no sound is attached
float GetStrRefSoundDuration(int nStrRef);

// Add oPC to oPartyLeader's party.  This will only work on two PCs.
// - oPC: player to add to a party
// - oPartyLeader: player already in the party
void AddToParty(object oPC, object oPartyLeader);

// Remove oPC from their current party. This will only work on a PC.
// - oPC: removes this player from whatever party they're currently in.
void RemoveFromParty(object oPC);

// Returns the stealth mode of the specified creature.
// - oCreature
// * Returns a constant STEALTH_MODE_*
int GetStealthMode(object oCreature);

// Returns the detection mode of the specified creature.
// - oCreature
// * Returns a constant DETECT_MODE_*
int GetDetectMode(object oCreature);

// Returns the defensive casting mode of the specified creature.
// - oCreature
// * Returns a constant DEFENSIVE_CASTING_MODE_*
int GetDefensiveCastingMode(object oCreature);

// returns the appearance type of the specified creature.
// * returns a constant APPEARANCE_TYPE_* for valid creatures
// * returns APPEARANCE_TYPE_INVALID for non creatures/invalid creatures
int GetAppearanceType(object oCreature);

// SpawnScriptDebugger() will attempt to communicate with the a running script debugger
// instance. You need to run it yourself, and enable it in Options/Config beforehand.
// A sample debug server is included with the game installation in utils/.
// Will only work in singleplayer, NOT on dedicated servers.
// In order to compile the script for debugging go to Tools->Options->Script Editor
// and check the box labeled "Generate Debug Information When Compiling Scripts"
// After you have checked the above box, recompile the script that you want to debug.
// If the script file isn't compiled for debugging, this command will do nothing.
// Remove any SpawnScriptDebugger() calls once you have finished
// debugging the script.
void SpawnScriptDebugger();

// in an onItemAcquired script, returns the size of the stack of the item
// that was just acquired.
// * returns the stack size of the item acquired
int GetModuleItemAcquiredStackSize();

// Decrement the remaining uses per day for this creature by one.
// - oCreature: creature to modify
// - nFeat: constant FEAT_*
void DecrementRemainingFeatUses(object oCreature, int nFeat);

// Decrement the remaining uses per day for this creature by one.
// - oCreature: creature to modify
// - nSpell: constant SPELL_*
void DecrementRemainingSpellUses(object oCreature, int nSpell);

// returns the template used to create this object (if appropriate)
// * returns an empty string when no template found
string GetResRef(object oObject);

// returns an effect that will petrify the target
// * currently applies EffectParalyze and the stoneskin visual effect.
effect EffectPetrify();

// duplicates the item and returns a new object
// oItem - item to copy
// oTargetInventory - create item in this object's inventory. If this parameter
//                    is not valid, the item will be created in oItem's location
// bCopyVars - copy the local variables from the old item to the new one
// * returns the new item
// * returns OBJECT_INVALID for non-items.
// * can only copy empty item containers. will return OBJECT_INVALID if oItem contains
//   other items.
// * if it is possible to merge this item with any others in the target location,
//   then it will do so and return the merged object.
object CopyItem(object oItem, object oTargetInventory=OBJECT_INVALID, int bCopyVars=FALSE);

// returns an effect that is guaranteed to paralyze a creature.
// this effect is identical to EffectParalyze except that it cannot be resisted.
effect EffectCutsceneParalyze();

// returns TRUE if the item CAN be dropped
// Droppable items will appear on a creature's remains when the creature is killed.
int GetDroppableFlag(object oItem);

// returns TRUE if the object is usable
int GetUseableFlag(object oObject=OBJECT_SELF);

// returns TRUE if the item is stolen
int GetStolenFlag(object oStolen);

// This stores a float out to the specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignFloat(string sCampaignName, string sVarName, float flFloat, object oPlayer=OBJECT_INVALID);

// This stores an int out to the specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignInt(string sCampaignName, string sVarName, int nInt, object oPlayer=OBJECT_INVALID);

// This stores a vector out to the specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignVector(string sCampaignName, string sVarName, vector vVector, object oPlayer=OBJECT_INVALID);

// This stores a location out to the specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignLocation(string sCampaignName, string sVarName, location locLocation, object oPlayer=OBJECT_INVALID);

// This stores a string out to the specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignString(string sCampaignName, string sVarName, string sString, object oPlayer=OBJECT_INVALID);

// This will delete the entire campaign database if it exists.
void DestroyCampaignDatabase(string sCampaignName);

// This will read a float from the  specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
float GetCampaignFloat(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// This will read an int from the  specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
int GetCampaignInt(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// This will read a vector from the  specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
vector GetCampaignVector(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// This will read a location from the  specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
location GetCampaignLocation(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// This will read a string from the  specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
string GetCampaignString(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// Duplicates the object specified by oSource.
// NOTE: this command can be used for copying Creatures, Items, Placeables, Waypoints, Stores, Doors, Triggers, Encounters.
// If an owner is specified and the object is an item, it will be put into their inventory
// Otherwise, it will be created at the location.
// If a new tag is specified, it will be assigned to the new object.
// If bCopyLocalState is TRUE, local vars, effects, action queue, and transition info (triggers, doors) are copied over.
object CopyObject(object oSource, location locLocation, object oOwner = OBJECT_INVALID, string sNewTag = "", int bCopyLocalState = FALSE);

// This will remove ANY campaign variable. Regardless of type.
void DeleteCampaignVariable(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// Stores an object with the given id.
// NOTE: this command can be used for storing Creatures, Items, Placeables, Waypoints, Stores, Doors, Triggers, Encounters.
// Returns 0 if it failled, 1 if it worked.
// If bSaveObjectState is TRUE, local vars, effects, action queue, and transition info (triggers, doors) are saved out
// (except for Combined Area Format, which always has object state saved out).
int StoreCampaignObject(string sCampaignName, string sVarName, object oObject, object oPlayer=OBJECT_INVALID, int bSaveObjectState=FALSE);

// Use RetrieveCampaign with the given id to restore it.
// If you specify an owner, the object will try to be created in their repository
// If the owner can't handle the item (or if it's a non-item) it will be created at the given location.
// If bLoadObjectState is TRUE, local vars, effects, action queue, and transition info (triggers, doors) are read in.
object RetrieveCampaignObject(string sCampaignName, string sVarName, location locLocation, object oOwner = OBJECT_INVALID, object oPlayer=OBJECT_INVALID, int bLoadObjectState=FALSE);

// Returns an effect that is guaranteed to dominate a creature
// Like EffectDominated but cannot be resisted
effect EffectCutsceneDominated();

// Returns stack size of an item
// - oItem: item to query
int GetItemStackSize(object oItem);

// Sets stack size of an item.
// - oItem: item to change
// - nSize: new size of stack.  Will be restricted to be between 1 and the
//   maximum stack size for the item type.  If a value less than 1 is passed it
//   will set the stack to 1.  If a value greater than the max is passed
//   then it will set the stack to the maximum size
void SetItemStackSize(object oItem, int nSize);

// Returns charges left on an item
// - oItem: item to query
int GetItemCharges(object oItem);

// Sets charges left on an item.
// - oItem: item to change
// - nCharges: number of charges.  If value below 0 is passed, # charges will
//   be set to 0.  If value greater than maximum is passed, # charges will
//   be set to maximum.  If the # charges drops to 0 the item
//   will be destroyed.
void SetItemCharges(object oItem, int nCharges);

// ***********************  START OF ITEM PROPERTY FUNCTIONS  **********************

// adds an item property to the specified item
// Only temporary and permanent duration types are allowed.
void AddItemProperty(int nDurationType, itemproperty ipProperty, object oItem, float fDuration=0.0f);

// removes an item property from the specified item
void RemoveItemProperty(object oItem, itemproperty ipProperty);

// if the item property is valid this will return true
int GetIsItemPropertyValid(itemproperty ipProperty);

// Gets the first item property on an item
itemproperty GetFirstItemProperty(object oItem);

// Will keep retrieving the next and the next item property on an Item,
// will return an invalid item property when the list is empty.
itemproperty GetNextItemProperty(object oItem);

// will return the item property type (ie. holy avenger)
int GetItemPropertyType(itemproperty ip);

// will return the duration type of the item property
int GetItemPropertyDurationType(itemproperty ip);

// Returns Item property ability bonus.  You need to specify an
// ability constant(IP_CONST_ABILITY_*) and the bonus.  The bonus should
// be a positive integer between 1 and 12.
itemproperty ItemPropertyAbilityBonus(int nAbility, int nBonus);

// Returns Item property AC bonus.  You need to specify the bonus.
// The bonus should be a positive integer between 1 and 20. The modifier
// type depends on the item it is being applied to.
itemproperty ItemPropertyACBonus(int nBonus);

// Returns Item property AC bonus vs. alignment group.  An example of
// an alignment group is Chaotic, or Good.  You need to specify the
// alignment group constant(IP_CONST_ALIGNMENTGROUP_*) and the AC bonus.
// The AC bonus should be an integer between 1 and 20.  The modifier
// type depends on the item it is being applied to.
itemproperty ItemPropertyACBonusVsAlign(int nAlignGroup, int nACBonus);

// Returns Item property AC bonus vs. Damage type (ie. piercing).  You
// need to specify the damage type constant(IP_CONST_DAMAGETYPE_*) and the
// AC bonus.  The AC bonus should be an integer between 1 and 20.  The
// modifier type depends on the item it is being applied to.
// NOTE: Only the first 3 damage types may be used here, the 3 basic
//       physical types.
itemproperty ItemPropertyACBonusVsDmgType(int nDamageType, int nACBonus);

// Returns Item property AC bonus vs. Racial group.  You need to specify
// the racial group constant(IP_CONST_RACIALTYPE_*) and the AC bonus.  The AC
// bonus should be an integer between 1 and 20.  The modifier type depends
// on the item it is being applied to.
itemproperty ItemPropertyACBonusVsRace(int nRace, int nACBonus);

// Returns Item property AC bonus vs. Specific alignment.  You need to
// specify the specific alignment constant(IP_CONST_ALIGNMENT_*) and the AC
// bonus.  The AC bonus should be an integer between 1 and 20.  The
// modifier type depends on the item it is being applied to.
itemproperty ItemPropertyACBonusVsSAlign(int nAlign, int nACBonus);

// Returns Item property Enhancement bonus.  You need to specify the
// enhancement bonus.  The Enhancement bonus should be an integer between
// 1 and 20.
itemproperty ItemPropertyEnhancementBonus(int nEnhancementBonus);

// Returns Item property Enhancement bonus vs. an Alignment group.  You
// need to specify the alignment group constant(IP_CONST_ALIGNMENTGROUP_*)
// and the enhancement bonus.  The Enhancement bonus should be an integer
// between 1 and 20.
itemproperty ItemPropertyEnhancementBonusVsAlign(int nAlignGroup, int nBonus);

// Returns Item property Enhancement bonus vs. Racial group.  You need
// to specify the racial group constant(IP_CONST_RACIALTYPE_*) and the
// enhancement bonus.  The enhancement bonus should be an integer between
// 1 and 20.
itemproperty ItemPropertyEnhancementBonusVsRace(int nRace, int nBonus);

// Returns Item property Enhancement bonus vs. a specific alignment.  You
// need to specify the alignment constant(IP_CONST_ALIGNMENT_*) and the
// enhancement bonus.  The enhancement bonus should be an integer between
// 1 and 20.
itemproperty ItemPropertyEnhancementBonusVsSAlign(int nAlign, int nBonus);

// Returns Item property Enhancment penalty.  You need to specify the
// enhancement penalty.  The enhancement penalty should be a POSITIVE
// integer between 1 and 5 (ie. 1 = -1).
itemproperty ItemPropertyEnhancementPenalty(int nPenalty);

// Returns Item property weight reduction.  You need to specify the weight
// reduction constant(IP_CONST_REDUCEDWEIGHT_*).
itemproperty ItemPropertyWeightReduction(int nReduction);

// Returns Item property Bonus Feat.  You need to specify the the feat
// constant(IP_CONST_FEAT_*).
itemproperty ItemPropertyBonusFeat(int nFeat);

// Returns Item property Bonus level spell (Bonus spell of level).  You must
// specify the class constant(IP_CONST_CLASS_*) of the bonus spell(MUST BE a
// spell casting class) and the level of the bonus spell.  The level of the
// bonus spell should be an integer between 0 and 9.
itemproperty ItemPropertyBonusLevelSpell(int nClass, int nSpellLevel);

// Returns Item property Cast spell.  You must specify the spell constant
// (IP_CONST_CASTSPELL_*) and the number of uses constant(IP_CONST_CASTSPELL_NUMUSES_*).
// NOTE: The number after the name of the spell in the constant is the level
//       at which the spell will be cast.  Sometimes there are multiple copies
//       of the same spell but they each are cast at a different level.  The higher
//       the level, the more cost will be added to the item.
// NOTE: The list of spells that can be applied to an item will depend on the
//       item type.  For instance there are spells that can be applied to a wand
//       that cannot be applied to a potion.  Below is a list of the types and the
//       spells that are allowed to be placed on them.  If you try to put a cast
//       spell effect on an item that is not allowed to have that effect it will
//       not work.
// NOTE: Even if spells have multiple versions of different levels they are only
//       listed below once.
//
// WANDS:
//          Acid_Splash
//          Activate_Item
//          Aid
//          Amplify
//          Animate_Dead
//          AuraOfGlory
//          BalagarnsIronHorn
//          Bane
//          Banishment
//          Barkskin
//          Bestow_Curse
//          Bigbys_Clenched_Fist
//          Bigbys_Crushing_Hand
//          Bigbys_Forceful_Hand
//          Bigbys_Grasping_Hand
//          Bigbys_Interposing_Hand
//          Bless
//          Bless_Weapon
//          Blindness/Deafness
//          Blood_Frenzy
//          Bombardment
//          Bulls_Strength
//          Burning_Hands
//          Call_Lightning
//          Camoflage
//          Cats_Grace
//          Charm_Monster
//          Charm_Person
//          Charm_Person_or_Animal
//          Clairaudience/Clairvoyance
//          Clarity
//          Color_Spray
//          Confusion
//          Continual_Flame
//          Cure_Critical_Wounds
//          Cure_Light_Wounds
//          Cure_Minor_Wounds
//          Cure_Moderate_Wounds
//          Cure_Serious_Wounds
//          Darkness
//          Darkvision
//          Daze
//          Death_Ward
//          Dirge
//          Dismissal
//          Dispel_Magic
//          Displacement
//          Divine_Favor
//          Divine_Might
//          Divine_Power
//          Divine_Shield
//          Dominate_Animal
//          Dominate_Person
//          Doom
//          Dragon_Breath_Acid
//          Dragon_Breath_Cold
//          Dragon_Breath_Fear
//          Dragon_Breath_Fire
//          Dragon_Breath_Gas
//          Dragon_Breath_Lightning
//          Dragon_Breath_Paralyze
//          Dragon_Breath_Sleep
//          Dragon_Breath_Slow
//          Dragon_Breath_Weaken
//          Drown
//          Eagle_Spledor
//          Earthquake
//          Electric_Jolt
//          Elemental_Shield
//          Endurance
//          Endure_Elements
//          Enervation
//          Entangle
//          Entropic_Shield
//          Etherealness
//          Expeditious_Retreat
//          Fear
//          Find_Traps
//          Fireball
//          Firebrand
//          Flame_Arrow
//          Flame_Lash
//          Flame_Strike
//          Flare
//          Foxs_Cunning
//          Freedom_of_Movement
//          Ghostly_Visage
//          Ghoul_Touch
//          Grease
//          Greater_Magic_Fang
//          Greater_Magic_Weapon
//          Grenade_Acid
//          Grenade_Caltrops
//          Grenade_Chicken
//          Grenade_Choking
//          Grenade_Fire
//          Grenade_Holy
//          Grenade_Tangle
//          Grenade_Thunderstone
//          Gust_of_wind
//          Hammer_of_the_Gods
//          Haste
//          Hold_Animal
//          Hold_Monster
//          Hold_Person
//          Ice_Storm
//          Identify
//          Improved_Invisibility
//          Inferno
//          Inflict_Critical_Wounds
//          Inflict_Light_Wounds
//          Inflict_Minor_Wounds
//          Inflict_Moderate_Wounds
//          Inflict_Serious_Wounds
//          Invisibility
//          Invisibility_Purge
//          Invisibility_Sphere
//          Isaacs_Greater_Missile_Storm
//          Isaacs_Lesser_Missile_Storm
//          Knock
//          Lesser_Dispel
//          Lesser_Restoration
//          Lesser_Spell_Breach
//          Light
//          Lightning_Bolt
//          Mage_Armor
//          Magic_Circle_against_Alignment
//          Magic_Fang
//          Magic_Missile
//          Manipulate_Portal_Stone
//          Mass_Camoflage
//          Melfs_Acid_Arrow
//          Meteor_Swarm
//          Mind_Blank
//          Mind_Fog
//          Negative_Energy_Burst
//          Negative_Energy_Protection
//          Negative_Energy_Ray
//          Neutralize_Poison
//          One_With_The_Land
//          Owls_Insight
//          Owls_Wisdom
//          Phantasmal_Killer
//          Planar_Ally
//          Poison
//          Polymorph_Self
//          Prayer
//          Protection_from_Alignment
//          Protection_From_Elements
//          Quillfire
//          Ray_of_Enfeeblement
//          Ray_of_Frost
//          Remove_Blindness/Deafness
//          Remove_Curse
//          Remove_Disease
//          Remove_Fear
//          Remove_Paralysis
//          Resist_Elements
//          Resistance
//          Restoration
//          Sanctuary
//          Scare
//          Searing_Light
//          See_Invisibility
//          Shadow_Conjuration
//          Shield
//          Shield_of_Faith
//          Silence
//          Sleep
//          Slow
//          Sound_Burst
//          Spike_Growth
//          Stinking_Cloud
//          Stoneskin
//          Summon_Creature_I
//          Summon_Creature_I
//          Summon_Creature_II
//          Summon_Creature_III
//          Summon_Creature_IV
//          Sunburst
//          Tashas_Hideous_Laughter
//          True_Strike
//          Undeaths_Eternal_Foe
//          Unique_Power
//          Unique_Power_Self_Only
//          Vampiric_Touch
//          Virtue
//          Wall_of_Fire
//          Web
//          Wounding_Whispers
//
// POTIONS:
//          Activate_Item
//          Aid
//          Amplify
//          AuraOfGlory
//          Bane
//          Barkskin
//          Barkskin
//          Barkskin
//          Bless
//          Bless_Weapon
//          Bless_Weapon
//          Blood_Frenzy
//          Bulls_Strength
//          Bulls_Strength
//          Bulls_Strength
//          Camoflage
//          Cats_Grace
//          Cats_Grace
//          Cats_Grace
//          Clairaudience/Clairvoyance
//          Clairaudience/Clairvoyance
//          Clairaudience/Clairvoyance
//          Clarity
//          Continual_Flame
//          Cure_Critical_Wounds
//          Cure_Critical_Wounds
//          Cure_Critical_Wounds
//          Cure_Light_Wounds
//          Cure_Light_Wounds
//          Cure_Minor_Wounds
//          Cure_Moderate_Wounds
//          Cure_Moderate_Wounds
//          Cure_Moderate_Wounds
//          Cure_Serious_Wounds
//          Cure_Serious_Wounds
//          Cure_Serious_Wounds
//          Darkness
//          Darkvision
//          Darkvision
//          Death_Ward
//          Dispel_Magic
//          Dispel_Magic
//          Displacement
//          Divine_Favor
//          Divine_Might
//          Divine_Power
//          Divine_Shield
//          Dragon_Breath_Acid
//          Dragon_Breath_Cold
//          Dragon_Breath_Fear
//          Dragon_Breath_Fire
//          Dragon_Breath_Gas
//          Dragon_Breath_Lightning
//          Dragon_Breath_Paralyze
//          Dragon_Breath_Sleep
//          Dragon_Breath_Slow
//          Dragon_Breath_Weaken
//          Eagle_Spledor
//          Eagle_Spledor
//          Eagle_Spledor
//          Elemental_Shield
//          Elemental_Shield
//          Endurance
//          Endurance
//          Endurance
//          Endure_Elements
//          Entropic_Shield
//          Ethereal_Visage
//          Ethereal_Visage
//          Etherealness
//          Expeditious_Retreat
//          Find_Traps
//          Foxs_Cunning
//          Foxs_Cunning
//          Foxs_Cunning
//          Freedom_of_Movement
//          Ghostly_Visage
//          Ghostly_Visage
//          Ghostly_Visage
//          Globe_of_Invulnerability
//          Greater_Bulls_Strength
//          Greater_Cats_Grace
//          Greater_Dispelling
//          Greater_Dispelling
//          Greater_Eagles_Splendor
//          Greater_Endurance
//          Greater_Foxs_Cunning
//          Greater_Magic_Weapon
//          Greater_Owls_Wisdom
//          Greater_Restoration
//          Greater_Spell_Mantle
//          Greater_Stoneskin
//          Grenade_Acid
//          Grenade_Caltrops
//          Grenade_Chicken
//          Grenade_Choking
//          Grenade_Fire
//          Grenade_Holy
//          Grenade_Tangle
//          Grenade_Thunderstone
//          Haste
//          Haste
//          Heal
//          Hold_Animal
//          Hold_Monster
//          Hold_Person
//          Identify
//          Invisibility
//          Lesser_Dispel
//          Lesser_Dispel
//          Lesser_Mind_Blank
//          Lesser_Restoration
//          Lesser_Spell_Mantle
//          Light
//          Light
//          Mage_Armor
//          Manipulate_Portal_Stone
//          Mass_Camoflage
//          Mind_Blank
//          Minor_Globe_of_Invulnerability
//          Minor_Globe_of_Invulnerability
//          Mordenkainens_Disjunction
//          Negative_Energy_Protection
//          Negative_Energy_Protection
//          Negative_Energy_Protection
//          Neutralize_Poison
//          One_With_The_Land
//          Owls_Insight
//          Owls_Wisdom
//          Owls_Wisdom
//          Owls_Wisdom
//          Polymorph_Self
//          Prayer
//          Premonition
//          Protection_From_Elements
//          Protection_From_Elements
//          Protection_from_Spells
//          Protection_from_Spells
//          Raise_Dead
//          Remove_Blindness/Deafness
//          Remove_Curse
//          Remove_Disease
//          Remove_Fear
//          Remove_Paralysis
//          Resist_Elements
//          Resist_Elements
//          Resistance
//          Resistance
//          Restoration
//          Resurrection
//          Rogues_Cunning
//          See_Invisibility
//          Shadow_Shield
//          Shapechange
//          Shield
//          Shield_of_Faith
//          Special_Alcohol_Beer
//          Special_Alcohol_Spirits
//          Special_Alcohol_Wine
//          Special_Herb_Belladonna
//          Special_Herb_Garlic
//          Spell_Mantle
//          Spell_Resistance
//          Spell_Resistance
//          Stoneskin
//          Tensers_Transformation
//          True_Seeing
//          True_Strike
//          Unique_Power
//          Unique_Power_Self_Only
//          Virtue
//
// GENERAL USE (ie. everything else):
//          Just about every spell is useable by all the general use items so instead we
//          will only list the ones that are not allowed:
//          Special_Alcohol_Beer
//          Special_Alcohol_Spirits
//          Special_Alcohol_Wine
//
itemproperty ItemPropertyCastSpell(int nSpell, int nNumUses);

// Returns Item property damage bonus.  You must specify the damage type constant
// (IP_CONST_DAMAGETYPE_*) and the amount of damage constant(IP_CONST_DAMAGEBONUS_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageBonus(int nDamageType, int nDamage);

// Returns Item property damage bonus vs. Alignment groups.  You must specify the
// alignment group constant(IP_CONST_ALIGNMENTGROUP_*) and the damage type constant
// (IP_CONST_DAMAGETYPE_*) and the amount of damage constant(IP_CONST_DAMAGEBONUS_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageBonusVsAlign(int nAlignGroup, int nDamageType, int nDamage);

// Returns Item property damage bonus vs. specific race.  You must specify the
// racial group constant(IP_CONST_RACIALTYPE_*) and the damage type constant
// (IP_CONST_DAMAGETYPE_*) and the amount of damage constant(IP_CONST_DAMAGEBONUS_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageBonusVsRace(int nRace, int nDamageType, int nDamage);

// Returns Item property damage bonus vs. specific alignment.  You must specify the
// specific alignment constant(IP_CONST_ALIGNMENT_*) and the damage type constant
// (IP_CONST_DAMAGETYPE_*) and the amount of damage constant(IP_CONST_DAMAGEBONUS_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageBonusVsSAlign(int nAlign, int nDamageType, int nDamage);

// Returns Item property damage immunity.  You must specify the damage type constant
// (IP_CONST_DAMAGETYPE_*) that you want to be immune to and the immune bonus percentage
// constant(IP_CONST_DAMAGEIMMUNITY_*).
// NOTE: not all the damage types will work, use only the following: Acid, Bludgeoning,
//       Cold, Electrical, Fire, Piercing, Slashing, Sonic.
itemproperty ItemPropertyDamageImmunity(int nDamageType, int nImmuneBonus);

// Returns Item property damage penalty.  You must specify the damage penalty.
// The damage penalty should be a POSITIVE integer between 1 and 5 (ie. 1 = -1).
itemproperty ItemPropertyDamagePenalty(int nPenalty);

// Returns Item property damage reduction.  You must specify the enhancment level
// (IP_CONST_DAMAGEREDUCTION_*) that is required to get past the damage reduction
// and the amount of HP of damage constant(IP_CONST_DAMAGESOAK_*) will be soaked
// up if your weapon is not of high enough enhancement.
itemproperty ItemPropertyDamageReduction(int nEnhancement, int nHPSoak);

// Returns Item property damage resistance.  You must specify the damage type
// constant(IP_CONST_DAMAGETYPE_*) and the amount of HP of damage constant
// (IP_CONST_DAMAGERESIST_*) that will be resisted against each round.
itemproperty ItemPropertyDamageResistance(int nDamageType, int nHPResist);

// Returns Item property damage vulnerability.  You must specify the damage type
// constant(IP_CONST_DAMAGETYPE_*) that you want the user to be extra vulnerable to
// and the percentage vulnerability constant(IP_CONST_DAMAGEVULNERABILITY_*).
itemproperty ItemPropertyDamageVulnerability(int nDamageType, int nVulnerability);

// Return Item property Darkvision.
itemproperty ItemPropertyDarkvision();

// Return Item property decrease ability score.  You must specify the ability
// constant(IP_CONST_ABILITY_*) and the modifier constant.  The modifier must be
// a POSITIVE integer between 1 and 10 (ie. 1 = -1).
itemproperty ItemPropertyDecreaseAbility(int nAbility, int nModifier);

// Returns Item property decrease Armor Class.  You must specify the armor
// modifier type constant(IP_CONST_ACMODIFIERTYPE_*) and the armor class penalty.
// The penalty must be a POSITIVE integer between 1 and 5 (ie. 1 = -1).
itemproperty ItemPropertyDecreaseAC(int nModifierType, int nPenalty);

// Returns Item property decrease skill.  You must specify the constant for the
// skill to be decreased(SKILL_*) and the amount of the penalty.  The penalty
// must be a POSITIVE integer between 1 and 10 (ie. 1 = -1).
itemproperty ItemPropertyDecreaseSkill(int nSkill, int nPenalty);

// Returns Item property container reduced weight.  This is used for special
// containers that reduce the weight of the objects inside them.  You must
// specify the container weight reduction type constant(IP_CONST_CONTAINERWEIGHTRED_*).
itemproperty ItemPropertyContainerReducedWeight(int nContainerType);

// Returns Item property extra melee damage type.  You must specify the extra
// melee base damage type that you want applied.  It is a constant(IP_CONST_DAMAGETYPE_*).
// NOTE: only the first 3 base types (piercing, slashing, & bludgeoning are applicable
//       here.
// NOTE: It is also only applicable to melee weapons.
itemproperty ItemPropertyExtraMeleeDamageType(int nDamageType);

// Returns Item property extra ranged damage type.  You must specify the extra
// melee base damage type that you want applied.  It is a constant(IP_CONST_DAMAGETYPE_*).
// NOTE: only the first 3 base types (piercing, slashing, & bludgeoning are applicable
//       here.
// NOTE: It is also only applicable to ranged weapons.
itemproperty ItemPropertyExtraRangeDamageType(int nDamageType);

// Returns Item property haste.
itemproperty ItemPropertyHaste();

// Returns Item property Holy Avenger.
itemproperty ItemPropertyHolyAvenger();

// Returns Item property immunity to miscellaneous effects.  You must specify the
// effect to which the user is immune, it is a constant(IP_CONST_IMMUNITYMISC_*).
itemproperty ItemPropertyImmunityMisc(int nImmunityType);

// Returns Item property improved evasion.
itemproperty ItemPropertyImprovedEvasion();

// Returns Item property bonus spell resistance.  You must specify the bonus spell
// resistance constant(IP_CONST_SPELLRESISTANCEBONUS_*).
itemproperty ItemPropertyBonusSpellResistance(int nBonus);

// Returns Item property saving throw bonus vs. a specific effect or damage type.
// You must specify the save type constant(IP_CONST_SAVEVS_*) that the bonus is
// applied to and the bonus that is be applied.  The bonus must be an integer
// between 1 and 20.
itemproperty ItemPropertyBonusSavingThrowVsX(int nBonusType, int nBonus);

// Returns Item property saving throw bonus to the base type (ie. will, reflex,
// fortitude).  You must specify the base type constant(IP_CONST_SAVEBASETYPE_*)
// to which the user gets the bonus and the bonus that he/she will get.  The
// bonus must be an integer between 1 and 20.
itemproperty ItemPropertyBonusSavingThrow(int nBaseSaveType, int nBonus);

// Returns Item property keen.  This means a critical threat range of 19-20 on a
// weapon will be increased to 17-20 etc.
itemproperty ItemPropertyKeen();

// Returns Item property light.  You must specify the intesity constant of the
// light(IP_CONST_LIGHTBRIGHTNESS_*) and the color constant of the light
// (IP_CONST_LIGHTCOLOR_*).
itemproperty ItemPropertyLight(int nBrightness, int nColor);

// Returns Item property Max range strength modification (ie. mighty).  You must
// specify the maximum modifier for strength that is allowed on a ranged weapon.
// The modifier must be a positive integer between 1 and 20.
itemproperty ItemPropertyMaxRangeStrengthMod(int nModifier);

// Returns Item property no damage.  This means the weapon will do no damage in
// combat.
itemproperty ItemPropertyNoDamage();

// Returns Item property on hit -> do effect property.  You must specify the on
// hit property constant(IP_CONST_ONHIT_*) and the save DC constant(IP_CONST_ONHIT_SAVEDC_*).
// Some of the item properties require a special parameter as well.  If the
// property does not require one you may leave out the last one.  The list of
// the ones with 3 parameters and what they are are as follows:
//      ABILITYDRAIN      :nSpecial is the ability it is to drain.
//                         constant(IP_CONST_ABILITY_*)
//      BLINDNESS         :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      CONFUSION         :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      DAZE              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      DEAFNESS          :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      DISEASE           :nSpecial is the type of desease that will effect the victim.
//                         constant(DISEASE_*)
//      DOOM              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      FEAR              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      HOLD              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      ITEMPOISON        :nSpecial is the type of poison that will effect the victim.
//                         constant(IP_CONST_POISON_*)
//      SILENCE           :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      SLAYRACE          :nSpecial is the race that will be slain.
//                         constant(IP_CONST_RACIALTYPE_*)
//      SLAYALIGNMENTGROUP:nSpecial is the alignment group that will be slain(ie. chaotic).
//                         constant(IP_CONST_ALIGNMENTGROUP_*)
//      SLAYALIGNMENT     :nSpecial is the specific alignment that will be slain.
//                         constant(IP_CONST_ALIGNMENT_*)
//      SLEEP             :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      SLOW              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
//      STUN              :nSpecial is the duration/percentage of effecting victim.
//                         constant(IP_CONST_ONHIT_DURATION_*)
itemproperty ItemPropertyOnHitProps(int nProperty, int nSaveDC, int nSpecial=0);

// Returns Item property reduced saving throw vs. an effect or damage type.  You must
// specify the constant to which the penalty applies(IP_CONST_SAVEVS_*) and the
// penalty to be applied.  The penalty must be a POSITIVE integer between 1 and 20
// (ie. 1 = -1).
itemproperty ItemPropertyReducedSavingThrowVsX(int nBaseSaveType, int nPenalty);

// Returns Item property reduced saving to base type.  You must specify the base
// type to which the penalty applies (ie. will, reflex, or fortitude) and the penalty
// to be applied.  The constant for the base type starts with (IP_CONST_SAVEBASETYPE_*).
// The penalty must be a POSITIVE integer between 1 and 20 (ie. 1 = -1).
itemproperty ItemPropertyReducedSavingThrow(int nBonusType, int nPenalty);

// Returns Item property regeneration.  You must specify the regeneration amount.
// The amount must be an integer between 1 and 20.
itemproperty ItemPropertyRegeneration(int nRegenAmount);

// Returns Item property skill bonus.  You must specify the skill to which the user
// will get a bonus(SKILL_*) and the amount of the bonus.  The bonus amount must
// be an integer between 1 and 50.
itemproperty ItemPropertySkillBonus(int nSkill, int nBonus);

// Returns Item property spell immunity vs. specific spell.  You must specify the
// spell to which the user will be immune(IP_CONST_IMMUNITYSPELL_*).
itemproperty ItemPropertySpellImmunitySpecific(int nSpell);

// Returns Item property spell immunity vs. spell school.  You must specify the
// school to which the user will be immune(IP_CONST_SPELLSCHOOL_*).
itemproperty ItemPropertySpellImmunitySchool(int nSchool);

// Returns Item property Thieves tools.  You must specify the modifier you wish
// the tools to have.  The modifier must be an integer between 1 and 12.
itemproperty ItemPropertyThievesTools(int nModifier);

// Returns Item property Attack bonus.  You must specify an attack bonus.  The bonus
// must be an integer between 1 and 20.
itemproperty ItemPropertyAttackBonus(int nBonus);

// Returns Item property Attack bonus vs. alignment group.  You must specify the
// alignment group constant(IP_CONST_ALIGNMENTGROUP_*) and the attack bonus.  The
// bonus must be an integer between 1 and 20.
itemproperty ItemPropertyAttackBonusVsAlign(int nAlignGroup, int nBonus);

// Returns Item property attack bonus vs. racial group.  You must specify the
// racial group constant(IP_CONST_RACIALTYPE_*) and the attack bonus.  The bonus
// must be an integer between 1 and 20.
itemproperty ItemPropertyAttackBonusVsRace(int nRace, int nBonus);

// Returns Item property attack bonus vs. a specific alignment.  You must specify
// the alignment you want the bonus to work against(IP_CONST_ALIGNMENT_*) and the
// attack bonus.  The bonus must be an integer between 1 and 20.
itemproperty ItemPropertyAttackBonusVsSAlign(int nAlignment, int nBonus);

// Returns Item property attack penalty.  You must specify the attack penalty.
// The penalty must be a POSITIVE integer between 1 and 5 (ie. 1 = -1).
itemproperty ItemPropertyAttackPenalty(int nPenalty);

// Returns Item property unlimited ammo.  If you leave the parameter field blank
// it will be just a normal bolt, arrow, or bullet.  However you may specify that
// you want the ammunition to do special damage (ie. +1d6 Fire, or +1 enhancement
// bonus).  For this parmeter you use the constants beginning with:
//      (IP_CONST_UNLIMITEDAMMO_*).
itemproperty ItemPropertyUnlimitedAmmo(int nAmmoDamage=IP_CONST_UNLIMITEDAMMO_BASIC);

// Returns Item property limit use by alignment group.  You must specify the
// alignment group(s) that you want to be able to use this item(IP_CONST_ALIGNMENTGROUP_*).
itemproperty ItemPropertyLimitUseByAlign(int nAlignGroup);

// Returns Item property limit use by class.  You must specify the class(es) who
// are able to use this item(IP_CONST_CLASS_*).
itemproperty ItemPropertyLimitUseByClass(int nClass);

// Returns Item property limit use by race.  You must specify the race(s) who are
// allowed to use this item(IP_CONST_RACIALTYPE_*).
itemproperty ItemPropertyLimitUseByRace(int nRace);

// Returns Item property limit use by specific alignment.  You must specify the
// alignment(s) of those allowed to use the item(IP_CONST_ALIGNMENT_*).
itemproperty ItemPropertyLimitUseBySAlign(int nAlignment);

// replace this function it does nothing.
itemproperty BadBadReplaceMeThisDoesNothing();

// Returns Item property vampiric regeneration.  You must specify the amount of
// regeneration.  The regen amount must be an integer between 1 and 20.
itemproperty ItemPropertyVampiricRegeneration(int nRegenAmount);

// Returns Item property Trap.  You must specify the trap level constant
// (IP_CONST_TRAPSTRENGTH_*) and the trap type constant(IP_CONST_TRAPTYPE_*).
itemproperty ItemPropertyTrap(int nTrapLevel, int nTrapType);

// Returns Item property true seeing.
itemproperty ItemPropertyTrueSeeing();

// Returns Item property Monster on hit apply effect property.  You must specify
// the property that you want applied on hit.  There are some properties that
// require an additional special parameter to be specified.  The others that
// don't require any additional parameter you may just put in the one.  The
// special cases are as follows:
//      ABILITYDRAIN:nSpecial is the ability to drain.
//                   constant(IP_CONST_ABILITY_*)
//      DISEASE     :nSpecial is the disease that you want applied.
//                   constant(DISEASE_*)
//      LEVELDRAIN  :nSpecial is the number of levels that you want drained.
//                   integer between 1 and 5.
//      POISON      :nSpecial is the type of poison that will effect the victim.
//                   constant(IP_CONST_POISON_*)
//      WOUNDING    :nSpecial is the amount of wounding.
//                   integer between 1 and 5.
// NOTE: Any that do not appear in the above list do not require the second
//       parameter.
// NOTE: These can only be applied to monster NATURAL weapons (ie. bite, claw,
//       gore, and slam).  IT WILL NOT WORK ON NORMAL WEAPONS.
itemproperty ItemPropertyOnMonsterHitProperties(int nProperty, int nSpecial=0);

// Returns Item property turn resistance.  You must specify the resistance bonus.
// The bonus must be an integer between 1 and 50.
itemproperty ItemPropertyTurnResistance(int nModifier);

// Returns Item property Massive Critical.  You must specify the extra damage
// constant(IP_CONST_DAMAGEBONUS_*) of the criticals.
itemproperty ItemPropertyMassiveCritical(int nDamage);

// Returns Item property free action.
itemproperty ItemPropertyFreeAction();

// Returns Item property monster damage.  You must specify the amount of damage
// the monster's attack will do(IP_CONST_MONSTERDAMAGE_*).
// NOTE: These can only be applied to monster NATURAL weapons (ie. bite, claw,
//       gore, and slam).  IT WILL NOT WORK ON NORMAL WEAPONS.
itemproperty ItemPropertyMonsterDamage(int nDamage);

// Returns Item property immunity to spell level.  You must specify the level of
// which that and below the user will be immune.  The level must be an integer
// between 1 and 9.  By putting in a 3 it will mean the user is immune to all
// 3rd level and lower spells.
itemproperty ItemPropertyImmunityToSpellLevel(int nLevel);

// Returns Item property special walk.  If no parameters are specified it will
// automatically use the zombie walk.  This will apply the special walk animation
// to the user.
itemproperty ItemPropertySpecialWalk(int nWalkType=0);

// Returns Item property healers kit.  You must specify the level of the kit.
// The modifier must be an integer between 1 and 12.
itemproperty ItemPropertyHealersKit(int nModifier);

// Returns Item property weight increase.  You must specify the weight increase
// constant(IP_CONST_WEIGHTINCREASE_*).
itemproperty ItemPropertyWeightIncrease(int nWeight);

// ***********************  END OF ITEM PROPERTY FUNCTIONS  **************************

// Returns true if 1d20 roll + skill rank is greater than or equal to difficulty
// - oTarget: the creature using the skill
// - nSkill: the skill being used
// - nDifficulty: Difficulty class of skill
int GetIsSkillSuccessful(object oTarget, int nSkill, int nDifficulty);

// Creates an effect that inhibits spells
// - nPercent - percentage of failure
// - nSpellSchool - the school of spells affected. Only applies to SPELL_FAILURE_TYPE_ALL.
// - nSpellFailureType - Use SPELL_FAILURE_TYPE_* constants for different spell failure types
effect EffectSpellFailure(int nPercent=100, int nSpellSchool=SPELL_SCHOOL_GENERAL, int nSpellFailureType=SPELL_FAILURE_TYPE_ALL);

// Causes the object to instantly speak a translated string.
// (not an action, not blocked when uncommandable)
// - nStrRef: Reference of the string in the talk table
// - nTalkVolume: TALKVOLUME_*
void SpeakStringByStrRef(int nStrRef, int nTalkVolume=TALKVOLUME_TALK);

// Sets the given creature into cutscene mode.  This prevents the player from
// using the GUI and camera controls.
// - oCreature: creature in a cutscene
// - nInCutscene: TRUE to move them into cutscene, FALSE to remove cutscene mode
// - nLeftClickingEnabled: TRUE to allow the user to interact with the game world using the left mouse button only.
//                         FALSE to stop the user from interacting with the game world.
// Note: SetCutsceneMode(oPlayer, TRUE) will also make the player 'plot' (unkillable).
// SetCutsceneMode(oPlayer, FALSE) will restore the player's plot flag to what it
// was when SetCutsceneMode(oPlayer, TRUE) was called.
void SetCutsceneMode(object oCreature, int nInCutscene=TRUE, int nLeftClickingEnabled=FALSE);

// Gets the last player character to cancel from a cutscene.
object GetLastPCToCancelCutscene();

// Gets the length of the specified wavefile, in seconds
// Only works for sounds used for dialog.
float GetDialogSoundLength(int nStrRef);

// Fades the screen for the given creature/player from black to regular screen
// - oCreature: creature controlled by player that should fade from black
void FadeFromBlack(object oCreature, float fSpeed=FADE_SPEED_MEDIUM);

// Fades the screen for the given creature/player from regular screen to black
// - oCreature: creature controlled by player that should fade to black
void FadeToBlack(object oCreature, float fSpeed=FADE_SPEED_MEDIUM);

// Removes any fading or black screen.
// - oCreature: creature controlled by player that should be cleared
void StopFade(object oCreature);

// Sets the screen to black.  Can be used in preparation for a fade-in (FadeFromBlack)
// Can be cleared by either doing a FadeFromBlack, or by calling StopFade.
// - oCreature: creature controlled by player that should see black screen
void BlackScreen(object oCreature);

// Returns the base attach bonus for the given creature.
int GetBaseAttackBonus(object oCreature);

// Set a creature's immortality flag.
// -oCreature: creature affected
// -bImmortal: TRUE = creature is immortal and cannot be killed (but still takes damage)
//             FALSE = creature is not immortal and is damaged normally.
// This scripting command only works on Creature objects.
void SetImmortal(object oCreature, int bImmortal);

// Open's this creature's inventory panel for this player
// - oCreature: creature to view
// - oPlayer: the owner of this creature will see the panel pop up
// * DM's can view any creature's inventory
// * Players can view their own inventory, or that of their henchman, familiar or animal companion
void OpenInventory(object oCreature, object oPlayer);

// Stores the current camera mode and position so that it can be restored (using
// RestoreCameraFacing())
void StoreCameraFacing();

// Restores the camera mode and position to what they were last time StoreCameraFacing
// was called.  RestoreCameraFacing can only be called once, and must correspond to a
// previous call to StoreCameraFacing.
void RestoreCameraFacing();

// Levels up a creature using default settings.
// If successfull it returns the level the creature now is, or 0 if it fails.
// If you want to give them a different level (ie: Give a Fighter a level of Wizard)
//    you can specify that in the nClass.
// However, if you specify a class to which the creature no package specified,
//   they will use the default package for that class for their levelup choices.
//   (ie: no Barbarian Savage/Wizard Divination combinations)
// If you turn on bReadyAllSpells, all memorized spells will be ready to cast without resting.
// if nPackage is PACKAGE_INVALID then it will use the starting package assigned to that class or just the class package
int LevelUpHenchman(object oCreature, int nClass = CLASS_TYPE_INVALID, int bReadyAllSpells = FALSE, int nPackage = PACKAGE_INVALID);

// Sets the droppable flag on an item
// - oItem: the item to change
// - bDroppable: TRUE or FALSE, whether the item should be droppable
// Droppable items will appear on a creature's remains when the creature is killed.
void SetDroppableFlag(object oItem, int bDroppable);

// Gets the weight of an item, or the total carried weight of a creature in tenths
// of pounds (as per the baseitems.2da).
// - oTarget: the item or creature for which the weight is needed
int GetWeight(object oTarget=OBJECT_SELF);

// Gets the object that acquired the module item.  May be a creature, item, or placeable
object GetModuleItemAcquiredBy();

// Get the immortal flag on a creature
int GetImmortal(object oTarget=OBJECT_SELF);

// Does a single attack on every hostile creature within 10ft. of the attacker
// and determines damage accordingly.  If the attacker has a ranged weapon
// equipped, this will have no effect.
// ** NOTE ** This is meant to be called inside the spell script for whirlwind
// attack, it is not meant to be used to queue up a new whirlwind attack.  To do
// that you need to call ActionUseFeat(FEAT_WHIRLWIND_ATTACK, oEnemy)
// - int bDisplayFeedback: TRUE or FALSE, whether or not feedback should be
//   displayed
// - int bImproved: If TRUE, the improved version of whirlwind is used
void DoWhirlwindAttack(int bDisplayFeedback=TRUE, int bImproved=FALSE);

// Gets a value from a 2DA file on the server and returns it as a string
// avoid using this function in loops
// - s2DA: the name of the 2da file, 16 chars max
// - sColumn: the name of the column in the 2da
// - nRow: the row in the 2da
// * returns an empty string if file, row, or column not found
string Get2DAString(string s2DA, string sColumn, int nRow);

// Returns an effect of type EFFECT_TYPE_ETHEREAL which works just like EffectSanctuary
// except that the observers get no saving throw
effect EffectEthereal();

// Gets the current AI Level that the creature is running at.
// Returns one of the following:
// AI_LEVEL_INVALID, AI_LEVEL_VERY_LOW, AI_LEVEL_LOW, AI_LEVEL_NORMAL, AI_LEVEL_HIGH, AI_LEVEL_VERY_HIGH
int GetAILevel(object oTarget=OBJECT_SELF);

// Sets the current AI Level of the creature to the value specified. Does not work on Players.
// The game by default will choose an appropriate AI level for
// creatures based on the circumstances that the creature is in.
// Explicitly setting an AI level will over ride the game AI settings.
// The new setting will last until SetAILevel is called again with the argument AI_LEVEL_DEFAULT.
// AI_LEVEL_DEFAULT  - Default setting. The game will take over seting the appropriate AI level when required.
// AI_LEVEL_VERY_LOW - Very Low priority, very stupid, but low CPU usage for AI. Typically used when no players are in the area.
// AI_LEVEL_LOW      - Low priority, mildly stupid, but slightly more CPU usage for AI. Typically used when not in combat, but a player is in the area.
// AI_LEVEL_NORMAL   - Normal priority, average AI, but more CPU usage required for AI. Typically used when creature is in combat.
// AI_LEVEL_HIGH     - High priority, smartest AI, but extremely high CPU usage required for AI. Avoid using this. It is most likely only ever needed for cutscenes.
void SetAILevel(object oTarget, int nAILevel);

// This will return TRUE if the creature running the script is a familiar currently
// possessed by his master.
// returns FALSE if not or if the creature object is invalid
int GetIsPossessedFamiliar(object oCreature);

// This will cause a Player Creature to unpossess his/her familiar.  It will work if run
// on the player creature or the possessed familiar.  It does not work in conjunction with
// any DM possession.
void UnpossessFamiliar(object oCreature);

// This will return TRUE if the area is flagged as either interior or underground.
int GetIsAreaInterior( object oArea = OBJECT_INVALID );

// Send a server message (szMessage) to the oPlayer.
void SendMessageToPCByStrRef(object oPlayer, int nStrRef);

// Increment the remaining uses per day for this creature by one.
// Total number of feats per day can not exceed the maximum.
// - oCreature: creature to modify
// - nFeat: constant FEAT_*
void IncrementRemainingFeatUses(object oCreature, int nFeat);

// Force the character of the player specified to be exported to its respective directory
// i.e. LocalVault/ServerVault/ etc.
void ExportSingleCharacter(object oPlayer);

// This will play a sound that is associated with a stringRef, it will be a mono sound from the location of the object running the command.
// if nRunAsAction is off then the sound is forced to play intantly.
void PlaySoundByStrRef(int nStrRef, int nRunAsAction = TRUE );

// Set the name of oCreature's sub race to sSubRace.
void SetSubRace(object oCreature, string sSubRace);

// Set the name of oCreature's Deity to sDeity.
void SetDeity(object oCreature, string sDeity);

// Returns TRUE if the creature oCreature is currently possessed by a DM character.
// Returns FALSE otherwise.
// Note: GetIsDMPossessed() will return FALSE if oCreature is the DM character.
// To determine if oCreature is a DM character use GetIsDM()
int GetIsDMPossessed(object oCreature);

// Gets the current weather conditions for the area oArea.
//   Returns: WEATHER_CLEAR, WEATHER_RAIN, WEATHER_SNOW, WEATHER_INVALID
//   Note: If called on an Interior area, this will always return WEATHER_CLEAR.
int GetWeather(object oArea);

// Returns AREA_NATURAL if the area oArea is natural, AREA_ARTIFICIAL otherwise.
// Returns AREA_INVALID, on an error.
int GetIsAreaNatural(object oArea);

// Returns AREA_ABOVEGROUND if the area oArea is above ground, AREA_UNDERGROUND otherwise.
// Returns AREA_INVALID, on an error.
int GetIsAreaAboveGround(object oArea);

// Use this to get the item last equipped by a player character in OnPlayerEquipItem..
object GetPCItemLastEquipped();

// Use this to get the player character who last equipped an item in OnPlayerEquipItem..
object GetPCItemLastEquippedBy();

// Use this to get the item last unequipped by a player character in OnPlayerEquipItem..
object GetPCItemLastUnequipped();

// Use this to get the player character who last unequipped an item in OnPlayerUnEquipItem..
object GetPCItemLastUnequippedBy();

// Creates a new copy of an item, while making a single change to the appearance of the item.
// Helmet models and simple items ignore iIndex.
// iType                            iIndex                              iNewValue
// ITEM_APPR_TYPE_SIMPLE_MODEL      [Ignored]                           Model #
// ITEM_APPR_TYPE_WEAPON_COLOR      ITEM_APPR_WEAPON_COLOR_*            1-4
// ITEM_APPR_TYPE_WEAPON_MODEL      ITEM_APPR_WEAPON_MODEL_*            Model #
// ITEM_APPR_TYPE_ARMOR_MODEL       ITEM_APPR_ARMOR_MODEL_*             Model #
// ITEM_APPR_TYPE_ARMOR_COLOR       ITEM_APPR_ARMOR_COLOR_* [0]         0-175 [1]
//
// [0] Alternatively, where ITEM_APPR_TYPE_ARMOR_COLOR is specified, if per-part coloring is
// desired, the following equation can be used for nIndex to achieve that:
//
//   ITEM_APPR_ARMOR_NUM_COLORS + (ITEM_APPR_ARMOR_MODEL_ * ITEM_APPR_ARMOR_NUM_COLORS) + ITEM_APPR_ARMOR_COLOR_
//
// For example, to change the CLOTH1 channel of the torso, nIndex would be:
//
//   6 + (7 * 6) + 2 = 50
//
// [1] When specifying per-part coloring, the value 255 is allowed and corresponds with the logical
// function 'clear colour override', which clears the per-part override for that part.
object CopyItemAndModify(object oItem, int nType, int nIndex, int nNewValue, int bCopyVars=FALSE);

// Queries the current value of the appearance settings on an item. The parameters are
// identical to those of CopyItemAndModify().
int GetItemAppearance(object oItem, int nType, int nIndex);

// Creates an item property that (when applied to a weapon item) causes a spell to be cast
// when a successful strike is made, or (when applied to armor) is struck by an opponent.
// - nSpell uses the IP_CONST_ONHIT_CASTSPELL_* constants
itemproperty ItemPropertyOnHitCastSpell(int nSpell, int nLevel);

// Returns the SubType number of the item property. See the 2DA files for value definitions.
int GetItemPropertySubType(itemproperty iProperty);

// Gets the status of ACTION_MODE_* modes on a creature.
int GetActionMode(object oCreature, int nMode);

// Sets the status of modes ACTION_MODE_* on a creature.
void SetActionMode(object oCreature, int nMode, int nStatus);

// Returns the current arcane spell failure factor of a creature
int GetArcaneSpellFailure(object oCreature);

// Makes a player examine the object oExamine. This causes the examination
// pop-up box to appear for the object specified.
void ActionExamine(object oExamine);

// Creates a visual effect (ITEM_VISUAL_*) that may be applied to
// melee weapons only.
itemproperty ItemPropertyVisualEffect(int nEffect);

// Sets the lootable state of a *living* NPC creature.
// This function will *not* work on players or dead creatures.
void SetLootable( object oCreature, int bLootable );

// Returns the lootable state of a creature.
int GetLootable( object oCreature );

// Returns the current movement rate factor
// of the cutscene 'camera man'.
// NOTE: This will be a value between 0.1, 2.0 (10%-200%)
float GetCutsceneCameraMoveRate( object oCreature );

// Sets the current movement rate factor for the cutscene
// camera man.
// NOTE: You can only set values between 0.1, 2.0 (10%-200%)
void SetCutsceneCameraMoveRate( object oCreature, float fRate );

// Returns TRUE if the item is cursed and cannot be dropped
int GetItemCursedFlag(object oItem);

// When cursed, items cannot be dropped
void SetItemCursedFlag(object oItem, int nCursed);

// Sets the maximum number of henchmen
void SetMaxHenchmen( int nNumHenchmen );

// Gets the maximum number of henchmen
int GetMaxHenchmen();

// Returns the associate type of the specified creature.
// - Returns ASSOCIATE_TYPE_NONE if the creature is not the associate of anyone.
int GetAssociateType( object oAssociate );

// Returns the spell resistance of the specified creature.
// - Returns 0 if the creature has no spell resistance or an invalid
//   creature is passed in.
int GetSpellResistance( object oCreature );

// Changes the current Day/Night cycle for this player to night
// - oPlayer: which player to change the lighting for
// - fTransitionTime: how long the transition should take
void DayToNight(object oPlayer, float fTransitionTime=0.0f);

// Changes the current Day/Night cycle for this player to daylight
// - oPlayer: which player to change the lighting for
// - fTransitionTime: how long the transition should take
void NightToDay(object oPlayer, float fTransitionTime=0.0f);

// Returns whether or not there is a direct line of sight
// between the two objects. (Not blocked by any geometry).
//
// PLEASE NOTE: This is an expensive function and may
//              degrade performance if used frequently.
int LineOfSightObject( object oSource, object oTarget );

// Returns whether or not there is a direct line of sight
// between the two vectors. (Not blocked by any geometry).
//
// This function must be run on a valid object in the area
// it will not work on the module or area.
//
// PLEASE NOTE: This is an expensive function and may
//              degrade performance if used frequently.
int LineOfSightVector( vector vSource, vector vTarget );

// Returns the class that the spellcaster cast the
// spell as.
// - Returns CLASS_TYPE_INVALID if the caster has
//   no valid class (placeables, etc...)
// If used in an Area of Effect script it will return the creators spellcasting class.
int GetLastSpellCastClass();

// Sets the number of base attacks each round for the specified creature (PC or NPC).
// If set on a PC it will not be shown on their character sheet, but will save to BIC/savegame.
// - nBaseAttackBonus - Number of base attacks per round, 1 to 6
void SetBaseAttackBonus( int nBaseAttackBonus, object oCreature = OBJECT_SELF );

// Restores the number of base attacks back to it's
// original state.
void RestoreBaseAttackBonus( object oCreature = OBJECT_SELF );

// Creates a cutscene ghost effect, this will allow creatures
// to pathfind through other creatures without bumping into them
// for the duration of the effect.
effect EffectCutsceneGhost();

// Creates an item property that offsets the effect on arcane spell failure
// that a particular item has. Parameters come from the ITEM_PROP_ASF_* group.
itemproperty ItemPropertyArcaneSpellFailure(int nModLevel);

// Returns the amount of gold a store currently has. -1 indicates it is not using gold.
// -2 indicates the store could not be located.
int GetStoreGold(object oidStore);

// Sets the amount of gold a store has. -1 means the store does not use gold.
void SetStoreGold(object oidStore, int nGold);

// Gets the maximum amount a store will pay for any item. -1 means price unlimited.
// -2 indicates the store could not be located.
int GetStoreMaxBuyPrice(object oidStore);

// Sets the maximum amount a store will pay for any item. -1 means price unlimited.
void SetStoreMaxBuyPrice(object oidStore, int nMaxBuy);

// Gets the amount a store charges for identifying an item. Default is 100. -1 means
// the store will not identify items.
// -2 indicates the store could not be located.
int GetStoreIdentifyCost(object oidStore);

// Sets the amount a store charges for identifying an item. Default is 100. -1 means
// the store will not identify items.
void SetStoreIdentifyCost(object oidStore, int nCost);

// Sets the creature's appearance type to the value specified (uses the APPEARANCE_TYPE_XXX constants)
void SetCreatureAppearanceType(object oCreature, int nAppearanceType);

// Returns the default package selected for this creature to level up with
// - returns PACKAGE_INVALID if error occurs
int GetCreatureStartingPackage(object oCreature);

// Returns an effect that when applied will paralyze the target's legs, rendering
// them unable to walk but otherwise unpenalized. This effect cannot be resisted.
effect EffectCutsceneImmobilize();

// Is this creature in the given subarea? (trigger, area of effect object, etc..)
// This function will tell you if the creature has triggered an onEnter event,
// not if it is physically within the space of the subarea
int GetIsInSubArea(object oCreature, object oSubArea=OBJECT_SELF);

// Returns the Cost Table number of the item property. See the 2DA files for value definitions.
int GetItemPropertyCostTable(itemproperty iProp);

// Returns the Cost Table value (index of the cost table) of the item property.
// See the 2DA files for value definitions.
int GetItemPropertyCostTableValue(itemproperty iProp);

// Returns the Param1 number of the item property. See the 2DA files for value definitions.
int GetItemPropertyParam1(itemproperty iProp);

// Returns the Param1 value of the item property. See the 2DA files for value definitions.
int GetItemPropertyParam1Value(itemproperty iProp);

// Is this creature able to be disarmed? (checks disarm flag on creature, and if
// the creature actually has a weapon equipped in their right hand that is droppable)
int GetIsCreatureDisarmable(object oCreature);

// Sets whether this item is 'stolen' or not
void SetStolenFlag(object oItem, int nStolenFlag);

// Instantly gives this creature the benefits of a rest (restored hitpoints, spells, feats, etc..)
void ForceRest(object oCreature);

// Forces this player's camera to be set to this height. Setting this value to zero will
// restore the camera to the racial default height.
void SetCameraHeight(object oPlayer, float fHeight=0.0f);

// Changes the sky that is displayed in the specified area.
// nSkyBox = SKYBOX_* constants (associated with skyboxes.2da)
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
void SetSkyBox(int nSkyBox, object oArea=OBJECT_INVALID);

// Returns the creature's currently set PhenoType (body type).
int GetPhenoType(object oCreature);

// Sets the creature's PhenoType (body type) to the type specified.
// nPhenoType = PHENOTYPE_NORMAL
// nPhenoType = PHENOTYPE_BIG
// nPhenoType = PHENOTYPE_CUSTOM* - The custom PhenoTypes should only ever
// be used if you have specifically created your own custom content that
// requires the use of a new PhenoType and you have specified the appropriate
// custom PhenoType in your custom content.
// SetPhenoType will only work on part based creature (i.e. the starting
// default playable races).
void SetPhenoType(int nPhenoType, object oCreature=OBJECT_SELF);

// Sets the fog color in the area specified.
// nFogType = FOG_TYPE_* specifies wether the Sun, Moon, or both fog types are set.
// nFogColor = FOG_COLOR_* specifies the color the fog is being set to.
// The fog color can also be represented as a hex RGB number if specific color shades
// are desired.
// The format of a hex specified color would be 0xFFEEDD where
// FF would represent the amount of red in the color
// EE would represent the amount of green in the color
// DD would represent the amount of blue in the color.
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
// If fFadeTime is above 0.0, it will fade to the new color in the amount of seconds specified. 
void SetFogColor(int nFogType, int nFogColor, object oArea=OBJECT_INVALID, float fFadeTime = 0.0);

// Gets the current cutscene state of the player specified by oCreature.
// Returns TRUE if the player is in cutscene mode.
// Returns FALSE if the player is not in cutscene mode, or on an error
// (such as specifying a non creature object).
int GetCutsceneMode(object oCreature=OBJECT_SELF);

// Gets the skybox that is currently displayed in the specified area.
// Returns:
//     SKYBOX_* constant
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
int GetSkyBox(object oArea=OBJECT_INVALID);

// Gets the fog color in the area specified.
// nFogType specifies wether the Sun, or Moon fog type is returned.
//    Valid values for nFogType are FOG_TYPE_SUN or FOG_TYPE_MOON.
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
int GetFogColor(int nFogType, object oArea=OBJECT_INVALID);

// Sets the fog amount in the area specified.
// nFogType = FOG_TYPE_* specifies wether the Sun, Moon, or both fog types are set.
// nFogAmount = specifies the density that the fog is being set to.
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
void SetFogAmount(int nFogType, int nFogAmount, object oArea=OBJECT_INVALID);

// Gets the fog amount in the area specified.
// nFogType = nFogType specifies wether the Sun, or Moon fog type is returned.
//    Valid values for nFogType are FOG_TYPE_SUN or FOG_TYPE_MOON.
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
int GetFogAmount(int nFogType, object oArea=OBJECT_INVALID);

// returns TRUE if the item CAN be pickpocketed
int GetPickpocketableFlag(object oItem);

// Sets the Pickpocketable flag on an item
// - oItem: the item to change
// - bPickpocketable: TRUE or FALSE, whether the item can be pickpocketed.
void SetPickpocketableFlag(object oItem, int bPickpocketable);

// returns the footstep type of the creature specified.
// The footstep type determines what the creature's footsteps sound
// like when ever they take a step.
// returns FOOTSTEP_TYPE_INVALID if used on a non-creature object, or if
// used on creature that has no footstep sounds by default (e.g. Will-O'-Wisp).
int GetFootstepType(object oCreature=OBJECT_SELF);

// Sets the footstep type of the creature specified.
// Changing a creature's footstep type will change the sound that
// its feet make when ever the creature makes takes a step.
// By default a creature's footsteps are detemined by the appearance
// type of the creature. SetFootstepType() allows you to make a
// creature use a difference footstep type than it would use by default
// for its given appearance.
// - nFootstepType (FOOTSTEP_TYPE_*):
//      FOOTSTEP_TYPE_NORMAL
//      FOOTSTEP_TYPE_LARGE
//      FOOTSTEP_TYPE_DRAGON
//      FOOTSTEP_TYPE_SoFT
//      FOOTSTEP_TYPE_HOOF
//      FOOTSTEP_TYPE_HOOF_LARGE
//      FOOTSTEP_TYPE_BEETLE
//      FOOTSTEP_TYPE_SPIDER
//      FOOTSTEP_TYPE_SKELETON
//      FOOTSTEP_TYPE_LEATHER_WING
//      FOOTSTEP_TYPE_FEATHER_WING
//      FOOTSTEP_TYPE_DEFAULT - Makes the creature use its original default footstep sounds.
//      FOOTSTEP_TYPE_NONE
// - oCreature: the creature to change the footstep sound for.
void SetFootstepType(int nFootstepType, object oCreature=OBJECT_SELF);

// returns the Wing type of the creature specified.
//      CREATURE_WING_TYPE_NONE
//      CREATURE_WING_TYPE_DEMON
//      CREATURE_WING_TYPE_ANGEL
//      CREATURE_WING_TYPE_BAT
//      CREATURE_WING_TYPE_DRAGON
//      CREATURE_WING_TYPE_BUTTERFLY
//      CREATURE_WING_TYPE_BIRD
// returns CREATURE_WING_TYPE_NONE if used on a non-creature object,
// if the creature has no wings, or if the creature can not have its
// wing type changed in the toolset.
int GetCreatureWingType(object oCreature=OBJECT_SELF);

// Sets the Wing type of the creature specified.
// - nWingType (CREATURE_WING_TYPE_*)
//      CREATURE_WING_TYPE_NONE
//      CREATURE_WING_TYPE_DEMON
//      CREATURE_WING_TYPE_ANGEL
//      CREATURE_WING_TYPE_BAT
//      CREATURE_WING_TYPE_DRAGON
//      CREATURE_WING_TYPE_BUTTERFLY
//      CREATURE_WING_TYPE_BIRD
// - oCreature: the creature to change the wing type for.
// Note: Only two creature model types will support wings.
// The MODELTYPE for the part based (playable races) 'P'
// and MODELTYPE 'W'in the appearance.2da
void SetCreatureWingType(int nWingType, object oCreature=OBJECT_SELF);

// returns the model number being used for the body part and creature specified
// The model number returned is for the body part when the creature is not wearing
// armor (i.e. whether or not the creature is wearing armor does not affect
// the return value).
// Note: Only works on part based creatures, which is typically restricted to
// the playable races (unless some new part based custom content has been
// added to the module).
//
// returns CREATURE_PART_INVALID if used on a non-creature object,
// or if the creature does not use a part based model.
//
// - nPart (CREATURE_PART_*)
//      CREATURE_PART_RIGHT_FOOT
//      CREATURE_PART_LEFT_FOOT
//      CREATURE_PART_RIGHT_SHIN
//      CREATURE_PART_LEFT_SHIN
//      CREATURE_PART_RIGHT_THIGH
//      CREATURE_PART_LEFT_THIGH
//      CREATURE_PART_PELVIS
//      CREATURE_PART_TORSO
//      CREATURE_PART_BELT
//      CREATURE_PART_NECK
//      CREATURE_PART_RIGHT_FOREARM
//      CREATURE_PART_LEFT_FOREARM
//      CREATURE_PART_RIGHT_BICEP
//      CREATURE_PART_LEFT_BICEP
//      CREATURE_PART_RIGHT_SHOULDER
//      CREATURE_PART_LEFT_SHOULDER
//      CREATURE_PART_RIGHT_HAND
//      CREATURE_PART_LEFT_HAND
//      CREATURE_PART_HEAD
int GetCreatureBodyPart(int nPart, object oCreature=OBJECT_SELF);

// Sets the body part model to be used on the creature specified.
// The model names for parts need to be in the following format:
//   p<m/f><race letter><phenotype>_<body part><model number>.mdl
//
// - nPart (CREATURE_PART_*)
//      CREATURE_PART_RIGHT_FOOT
//      CREATURE_PART_LEFT_FOOT
//      CREATURE_PART_RIGHT_SHIN
//      CREATURE_PART_LEFT_SHIN
//      CREATURE_PART_RIGHT_THIGH
//      CREATURE_PART_LEFT_THIGH
//      CREATURE_PART_PELVIS
//      CREATURE_PART_TORSO
//      CREATURE_PART_BELT
//      CREATURE_PART_NECK
//      CREATURE_PART_RIGHT_FOREARM
//      CREATURE_PART_LEFT_FOREARM
//      CREATURE_PART_RIGHT_BICEP
//      CREATURE_PART_LEFT_BICEP
//      CREATURE_PART_RIGHT_SHOULDER
//      CREATURE_PART_LEFT_SHOULDER
//      CREATURE_PART_RIGHT_HAND
//      CREATURE_PART_LEFT_HAND
//      CREATURE_PART_HEAD
// - nModelNumber: CREATURE_MODEL_TYPE_*
//      CREATURE_MODEL_TYPE_NONE
//      CREATURE_MODEL_TYPE_SKIN (not for use on shoulders, pelvis or head).
//      CREATURE_MODEL_TYPE_TATTOO (for body parts that support tattoos, i.e. not heads/feet/hands).
//      CREATURE_MODEL_TYPE_UNDEAD (undead model only exists for the right arm parts).
// - oCreature: the creature to change the body part for.
// Note: Only part based creature appearance types are supported.
// i.e. The model types for the playable races ('P') in the appearance.2da
void SetCreatureBodyPart(int nPart, int nModelNumber, object oCreature=OBJECT_SELF);

// returns the Tail type of the creature specified.
//      CREATURE_TAIL_TYPE_NONE
//      CREATURE_TAIL_TYPE_LIZARD
//      CREATURE_TAIL_TYPE_BONE
//      CREATURE_TAIL_TYPE_DEVIL
// returns CREATURE_TAIL_TYPE_NONE if used on a non-creature object,
// if the creature has no Tail, or if the creature can not have its
// Tail type changed in the toolset.
int GetCreatureTailType(object oCreature=OBJECT_SELF);

// Sets the Tail type of the creature specified.
// - nTailType (CREATURE_TAIL_TYPE_*)
//      CREATURE_TAIL_TYPE_NONE
//      CREATURE_TAIL_TYPE_LIZARD
//      CREATURE_TAIL_TYPE_BONE
//      CREATURE_TAIL_TYPE_DEVIL
// - oCreature: the creature to change the Tail type for.
// Note: Only two creature model types will support Tails.
// The MODELTYPE for the part based (playable) races 'P'
// and MODELTYPE 'T'in the appearance.2da
void SetCreatureTailType(int nTailType, object oCreature=OBJECT_SELF);

// returns the Hardness of a Door or Placeable object.
// - oObject: a door or placeable object.
// returns -1 on an error or if used on an object that is
// neither a door nor a placeable object.
int GetHardness(object oObject=OBJECT_SELF);

// Sets the Hardness of a Door or Placeable object.
// - nHardness: must be between 0 and 250.
// - oObject: a door or placeable object.
// Does nothing if used on an object that is neither
// a door nor a placeable.
void SetHardness(int nHardness, object oObject=OBJECT_SELF);

// When set the object can not be opened unless the
// opener possesses the required key. The key tag required
// can be specified either in the toolset, or by using
// the SetLockKeyTag() scripting command.
// - oObject: a door, or placeable.
// - nKeyRequired: TRUE/FALSE
void SetLockKeyRequired(object oObject, int nKeyRequired=TRUE);

// Set the key tag required to open object oObject.
// This will only have an effect if the object is set to
// "Key required to unlock or lock" either in the toolset
// or by using the scripting command SetLockKeyRequired().
// - oObject: a door, placeable or trigger.
// - sNewKeyTag: the key tag required to open the locked object.
void SetLockKeyTag(object oObject, string sNewKeyTag);

// Sets whether or not the object can be locked.
// - oObject: a door or placeable.
// - nLockable: TRUE/FALSE
void SetLockLockable(object oObject, int nLockable=TRUE);

// Sets the DC for unlocking the object.
// - oObject: a door or placeable object.
// - nNewUnlockDC: must be between 0 and 250.
void SetLockUnlockDC(object oObject, int nNewUnlockDC);

// Sets the DC for locking the object.
// - oObject: a door or placeable object.
// - nNewLockDC: must be between 0 and 250.
void SetLockLockDC(object oObject, int nNewLockDC);

// Sets whether or not the trapped object can be disarmed.
// - oTrapObject: a placeable, door or trigger
// - nDisarmable: TRUE/FALSE
void SetTrapDisarmable(object oTrapObject, int nDisarmable=TRUE);

// Sets whether or not the trapped object can be detected.
// - oTrapObject: a placeable, door or trigger
// - nDetectable: TRUE/FALSE
// Note: Setting a trapped object to not be detectable will
// not make the trap disappear if it has already been detected.
void SetTrapDetectable(object oTrapObject, int nDetectable=TRUE);

// Sets whether or not the trap is a one-shot trap
// (i.e. whether or not the trap resets itself after firing).
// - oTrapObject: a placeable, door or trigger
// - nOneShot: TRUE/FALSE
void SetTrapOneShot(object oTrapObject, int nOneShot=TRUE);

// Set the tag of the key that will disarm oTrapObject.
// - oTrapObject: a placeable, door or trigger
void SetTrapKeyTag(object oTrapObject, string sKeyTag);

// Set the DC for disarming oTrapObject.
// - oTrapObject: a placeable, door or trigger
// - nDisarmDC: must be between 0 and 250.
void SetTrapDisarmDC(object oTrapObject, int nDisarmDC);

// Set the DC for detecting oTrapObject.
// - oTrapObject: a placeable, door or trigger
// - nDetectDC: must be between 0 and 250.
void SetTrapDetectDC(object oTrapObject, int nDetectDC);

// Creates a square Trap object.
// - nTrapType: The base type of trap (TRAP_BASE_TYPE_*)
// - lLocation: The location and orientation that the trap will be created at.
// - fSize: The size of the trap. Minimum size allowed is 1.0f.
// - sTag: The tag of the trap being created.
// - nFaction: The faction of the trap (STANDARD_FACTION_*).
// - sOnDisarmScript: The OnDisarm script that will fire when the trap is disarmed.
//                    If "" no script will fire.
// - sOnTrapTriggeredScript: The OnTrapTriggered script that will fire when the
//                           trap is triggered.
//                           If "" the default OnTrapTriggered script for the trap
//                           type specified will fire instead (as specified in the
//                           traps.2da).
object CreateTrapAtLocation(int nTrapType, location lLocation, float fSize=2.0f, string sTag="", int nFaction=STANDARD_FACTION_HOSTILE, string sOnDisarmScript="", string sOnTrapTriggeredScript="");

// Creates a Trap on the object specified.
// - nTrapType: The base type of trap (TRAP_BASE_TYPE_*)
// - oObject: The object that the trap will be created on. Works only on Doors and Placeables.
// - nFaction: The faction of the trap (STANDARD_FACTION_*).
// - sOnDisarmScript: The OnDisarm script that will fire when the trap is disarmed.
//                    If "" no script will fire.
// - sOnTrapTriggeredScript: The OnTrapTriggered script that will fire when the
//                           trap is triggered.
//                           If "" the default OnTrapTriggered script for the trap
//                           type specified will fire instead (as specified in the
//                           traps.2da).
// Note: After creating a trap on an object, you can change the trap's properties
//       using the various SetTrap* scripting commands by passing in the object
//       that the trap was created on (i.e. oObject) to any subsequent SetTrap* commands.
void CreateTrapOnObject(int nTrapType, object oObject, int nFaction=STANDARD_FACTION_HOSTILE, string sOnDisarmScript="", string sOnTrapTriggeredScript="");

// Set the Will saving throw value of the Door or Placeable object oObject.
// - oObject: a door or placeable object.
// - nWillSave: must be between 0 and 250.
void SetWillSavingThrow(object oObject, int nWillSave);

// Set the Reflex saving throw value of the Door or Placeable object oObject.
// - oObject: a door or placeable object.
// - nReflexSave: must be between 0 and 250.
void SetReflexSavingThrow(object oObject, int nReflexSave);

// Set the Fortitude saving throw value of the Door or Placeable object oObject.
// - oObject: a door or placeable object.
// - nFortitudeSave: must be between 0 and 250.
void SetFortitudeSavingThrow(object oObject, int nFortitudeSave);

// returns the resref (TILESET_RESREF_*) of the tileset used to create area oArea.
//      TILESET_RESREF_BEHOLDER_CAVES
//      TILESET_RESREF_CASTLE_INTERIOR
//      TILESET_RESREF_CITY_EXTERIOR
//      TILESET_RESREF_CITY_INTERIOR
//      TILESET_RESREF_CRYPT
//      TILESET_RESREF_DESERT
//      TILESET_RESREF_DROW_INTERIOR
//      TILESET_RESREF_DUNGEON
//      TILESET_RESREF_FOREST
//      TILESET_RESREF_FROZEN_WASTES
//      TILESET_RESREF_ILLITHID_INTERIOR
//      TILESET_RESREF_MICROSET
//      TILESET_RESREF_MINES_AND_CAVERNS
//      TILESET_RESREF_RUINS
//      TILESET_RESREF_RURAL
//      TILESET_RESREF_RURAL_WINTER
//      TILESET_RESREF_SEWERS
//      TILESET_RESREF_UNDERDARK
// * returns an empty string on an error.
string GetTilesetResRef(object oArea);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject can be recovered.
int GetTrapRecoverable(object oTrapObject);

// Sets whether or not the trapped object can be recovered.
// - oTrapObject: a placeable, door or trigger
void SetTrapRecoverable(object oTrapObject, int nRecoverable=TRUE);

// Get the XP scale being used for the module.
int GetModuleXPScale();

// Set the XP scale used by the module.
// - nXPScale: The XP scale to be used. Must be between 0 and 200.
void SetModuleXPScale(int nXPScale);

// Get the feedback message that will be displayed when trying to unlock the object oObject.
// - oObject: a door or placeable.
// Returns an empty string "" on an error or if the game's default feedback message is being used
string GetKeyRequiredFeedback(object oObject);

// Set the feedback message that is displayed when trying to unlock the object oObject.
// This will only have an effect if the object is set to
// "Key required to unlock or lock" either in the toolset
// or by using the scripting command SetLockKeyRequired().
// - oObject: a door or placeable.
// - sFeedbackMessage: the string to be displayed in the player's text window.
//                     to use the game's default message, set sFeedbackMessage to ""
void SetKeyRequiredFeedback(object oObject, string sFeedbackMessage);

// - oTrapObject: a placeable, door or trigger
// * Returns TRUE if oTrapObject is active
int GetTrapActive(object oTrapObject);

// Sets whether or not the trap is an active trap
// - oTrapObject: a placeable, door or trigger
// - nActive: TRUE/FALSE
// Notes:
// Setting a trap as inactive will not make the
// trap disappear if it has already been detected.
// Call SetTrapDetectedBy() to make a detected trap disappear.
// To make an inactive trap not detectable call SetTrapDetectable()
void SetTrapActive(object oTrapObject, int nActive=TRUE);

// Locks the player's camera pitch to its current pitch setting,
// or unlocks the player's camera pitch.
// Stops the player from tilting their camera angle.
// - oPlayer: A player object.
// - bLocked: TRUE/FALSE.
void LockCameraPitch(object oPlayer, int bLocked=TRUE);

// Locks the player's camera distance to its current distance setting,
// or unlocks the player's camera distance.
// Stops the player from being able to zoom in/out the camera.
// - oPlayer: A player object.
// - bLocked: TRUE/FALSE.
void LockCameraDistance(object oPlayer, int bLocked=TRUE);

// Locks the player's camera direction to its current direction,
// or unlocks the player's camera direction to enable it to move
// freely again.
// Stops the player from being able to rotate the camera direction.
// - oPlayer: A player object.
// - bLocked: TRUE/FALSE.
void LockCameraDirection(object oPlayer, int bLocked=TRUE);

// Get the last object that default clicked (left clicked) on the placeable object
// that is calling this function.
// Should only be called from a placeables OnClick event.
// * Returns OBJECT_INVALID if it is called by something other than a placeable.
object GetPlaceableLastClickedBy();

// returns TRUE if the item is flagged as infinite.
// - oItem: an item.
// The infinite property affects the buying/selling behavior of the item in a store.
// An infinite item will still be available to purchase from a store after a player
// buys the item (non-infinite items will disappear from the store when purchased).
int GetInfiniteFlag(object oItem);

// Sets the Infinite flag on an item
// - oItem: the item to change
// - bInfinite: TRUE or FALSE, whether the item should be Infinite
// The infinite property affects the buying/selling behavior of the item in a store.
// An infinite item will still be available to purchase from a store after a player
// buys the item (non-infinite items will disappear from the store when purchased).
void SetInfiniteFlag(object oItem, int bInfinite=TRUE);

// Gets the size of the area.
// - nAreaDimension: The area dimension that you wish to determine.
//      AREA_HEIGHT
//      AREA_WIDTH
// - oArea: The area that you wish to get the size of.
// Returns: The number of tiles that the area is wide/high, or zero on an error.
// If no valid area (or object) is specified, it uses the area of the caller.
// If an object other than an area is specified, will use the area that the object is currently in.
int GetAreaSize(int nAreaDimension, object oArea=OBJECT_INVALID);

// Set the name of oObject.
// - oObject: the object for which you are changing the name (a creature, placeable, item, or door).
// - sNewName: the new name that the object will use.
// Note: Setting an object's name to "" will make the object
//       revert to using the name it had originally before any
//       SetName() calls were made on the object.
void SetName(object oObject, string sNewName="");

// Get the PortraitId of oTarget.
// - oTarget: the object for which you are getting the portrait Id.
// Returns: The Portrait Id number being used for the object oTarget.
//          The Portrait Id refers to the row number of the Portraits.2da
//          that this portrait is from.
//          If a custom portrait is being used, oTarget is a player object,
//          or on an error returns PORTRAIT_INVALID. In these instances
//          try using GetPortraitResRef() instead.
int GetPortraitId(object oTarget=OBJECT_SELF);

// Change the portrait of oTarget to use the Portrait Id specified.
// - oTarget: the object for which you are changing the portrait.
// - nPortraitId: The Id of the new portrait to use.
//                nPortraitId refers to a row in the Portraits.2da
// Note: Not all portrait Ids are suitable for use with all object types.
//       Setting the portrait Id will also cause the portrait ResRef
//       to be set to the appropriate portrait ResRef for the Id specified.
void SetPortraitId(object oTarget, int nPortraitId);

// Get the Portrait ResRef of oTarget.
// - oTarget: the object for which you are getting the portrait ResRef.
// Returns: The Portrait ResRef being used for the object oTarget.
//          The Portrait ResRef will not include a trailing size letter.
string GetPortraitResRef(object oTarget=OBJECT_SELF);

// Change the portrait of oTarget to use the Portrait ResRef specified.
// - oTarget: the object for which you are changing the portrait.
// - sPortraitResRef: The ResRef of the new portrait to use.
//                    The ResRef should not include any trailing size letter ( e.g. po_el_f_09_ ).
// Note: Not all portrait ResRefs are suitable for use with all object types.
//       Setting the portrait ResRef will also cause the portrait Id
//       to be set to PORTRAIT_INVALID.
void SetPortraitResRef(object oTarget, string sPortraitResRef);

// Set oTarget's useable object status.
// Note: Only works on non-static placeables, creatures, doors and items.
// On items, it affects interactivity when they're on the ground, and not useability in inventory.
void SetUseableFlag(object oTarget, int nUseableFlag);

// Get the description of oObject.
// - oObject: the object from which you are obtaining the description.
//            Can be a creature, item, placeable, door, trigger or module object.
// - bOriginalDescription:  if set to true any new description specified via a SetDescription scripting command
//                   is ignored and the original object's description is returned instead.
// - bIdentified: If oObject is an item, setting this to TRUE will return the identified description,
//                setting this to FALSE will return the unidentified description. This flag has no
//                effect on objects other than items.
string GetDescription(object oObject, int bOriginalDescription=FALSE, int bIdentifiedDescription=TRUE);

// Set the description of oObject.
// - oObject: the object for which you are changing the description
//            Can be a creature, placeable, item, door, or trigger.
// - sNewDescription: the new description that the object will use.
// - bIdentified: If oObject is an item, setting this to TRUE will set the identified description,
//                setting this to FALSE will set the unidentified description. This flag has no
//                effect on objects other than items.
// Note: Setting an object's description to "" will make the object
//       revert to using the description it originally had before any
//       SetDescription() calls were made on the object.
void SetDescription(object oObject, string sNewDescription="", int bIdentifiedDescription=TRUE);

// Get the PC that sent the last player chat(text) message.
// Should only be called from a module's OnPlayerChat event script.
// * Returns OBJECT_INVALID on error.
// Note: Private tells do not trigger a OnPlayerChat event.
object GetPCChatSpeaker();

// Get the last player chat(text) message that was sent.
// Should only be called from a module's OnPlayerChat event script.
// * Returns empty string "" on error.
// Note: Private tells do not trigger a OnPlayerChat event.
string GetPCChatMessage();

// Get the volume of the last player chat(text) message that was sent.
// Returns one of the following TALKVOLUME_* constants based on the volume setting
// that the player used to send the chat message.
//                TALKVOLUME_TALK
//                TALKVOLUME_WHISPER
//                TALKVOLUME_SHOUT
//                TALKVOLUME_SILENT_SHOUT (used for DM chat channel)
//                TALKVOLUME_PARTY
// Should only be called from a module's OnPlayerChat event script.
// * Returns -1 on error.
// Note: Private tells do not trigger a OnPlayerChat event.
int GetPCChatVolume();

// Set the last player chat(text) message before it gets sent to other players.
// - sNewChatMessage: The new chat text to be sent onto other players.
//                    Setting the player chat message to an empty string "",
//                    will cause the chat message to be discarded
//                    (i.e. it will not be sent to other players).
// Note: The new chat message gets sent after the OnPlayerChat script exits.
void SetPCChatMessage(string sNewChatMessage="");

// Set the last player chat(text) volume before it gets sent to other players.
// - nTalkVolume: The new volume of the chat text to be sent onto other players.
//                TALKVOLUME_TALK
//                TALKVOLUME_WHISPER
//                TALKVOLUME_SHOUT
//                TALKVOLUME_SILENT_SHOUT (used for DM chat channel)
//                TALKVOLUME_PARTY
//                TALKVOLUME_TELL (sends the chat message privately back to the original speaker)
// Note: The new chat message gets sent after the OnPlayerChat script exits.
void SetPCChatVolume(int nTalkVolume=TALKVOLUME_TALK);

// Get the Color of oObject from the color channel specified.
// - oObject: the object from which you are obtaining the color.
//            Can be a creature that has color information (i.e. the playable races).
// - nColorChannel: The color channel that you want to get the color value of.
//                   COLOR_CHANNEL_SKIN
//                   COLOR_CHANNEL_HAIR
//                   COLOR_CHANNEL_TATTOO_1
//                   COLOR_CHANNEL_TATTOO_2
// * Returns -1 on error.
int GetColor(object oObject, int nColorChannel);

// Set the color channel of oObject to the color specified.
// - oObject: the object for which you are changing the color.
//            Can be a creature that has color information (i.e. the playable races).
// - nColorChannel: The color channel that you want to set the color value of.
//                   COLOR_CHANNEL_SKIN
//                   COLOR_CHANNEL_HAIR
//                   COLOR_CHANNEL_TATTOO_1
//                   COLOR_CHANNEL_TATTOO_2
// - nColorValue: The color you want to set (0-175).
void SetColor(object oObject, int nColorChannel, int nColorValue);

// Returns Item property Material.  You need to specify the Material Type.
// - nMasterialType: The Material Type should be a positive integer between 0 and 77 (see iprp_matcost.2da).
// Note: The Material Type property will only affect the cost of the item if you modify the cost in the iprp_matcost.2da.
itemproperty ItemPropertyMaterial(int nMaterialType);

// Returns Item property Quality. You need to specify the Quality.
// - nQuality:  The Quality of the item property to create (see iprp_qualcost.2da).
//              IP_CONST_QUALITY_*
// Note: The quality property will only affect the cost of the item if you modify the cost in the iprp_qualcost.2da.
itemproperty ItemPropertyQuality(int nQuality);

// Returns a generic Additional Item property. You need to specify the Additional property.
// - nProperty: The item property to create (see iprp_addcost.2da).
//              IP_CONST_ADDITIONAL_*
// Note: The additional property only affects the cost of the item if you modify the cost in the iprp_addcost.2da.
itemproperty ItemPropertyAdditional(int nAdditionalProperty);

// Sets a new tag for oObject.
// Will do nothing for invalid objects or the module object.
//
// Note: Care needs to be taken with this function.
//       Changing the tag for creature with waypoints will make them stop walking them.
//       Changing waypoint, door or trigger tags will break their area transitions.
void SetTag(object oObject, string sNewTag);

// Returns the string tag set for the provided effect.
// - If no tag has been set, returns an empty string.
string GetEffectTag(effect eEffect);

// Tags the effect with the provided string.
// - Any other tags in the link will be overwritten.
effect TagEffect(effect eEffect, string sNewTag);

// Returns the caster level of the creature who created the effect.
// - If not created by a creature, returns 0.
// - If created by a spell-like ability, returns 0.
int GetEffectCasterLevel(effect eEffect);

// Returns the total duration of the effect in seconds.
// - Returns 0 if the duration type of the effect is not DURATION_TYPE_TEMPORARY.
int GetEffectDuration(effect eEffect);

// Returns the remaining duration of the effect in seconds.
// - Returns 0 if the duration type of the effect is not DURATION_TYPE_TEMPORARY.
int GetEffectDurationRemaining(effect eEffect);

// Returns the string tag set for the provided item property.
// - If no tag has been set, returns an empty string.
string GetItemPropertyTag(itemproperty nProperty);

// Tags the item property with the provided string.
// - Any tags currently set on the item property will be overwritten.
itemproperty TagItemProperty(itemproperty nProperty, string sNewTag);

// Returns the total duration of the item property in seconds.
// - Returns 0 if the duration type of the item property is not DURATION_TYPE_TEMPORARY.
int GetItemPropertyDuration(itemproperty nProperty);

// Returns the remaining duration of the item property in seconds.
// - Returns 0 if the duration type of the item property is not DURATION_TYPE_TEMPORARY.
int GetItemPropertyDurationRemaining(itemproperty nProperty);

// Instances a new area from the given sSourceResRef, which needs to be a existing module area.
// Will optionally set a new area tag and displayed name. The new area is accessible
// immediately, but initialisation scripts for the area and all contained creatures will only
// run after the current script finishes (so you can clean up objects before returning).
//
// Returns the new area, or OBJECT_INVALID on failure.
//
// Note: When spawning a second instance of a existing area, you will have to manually
//       adjust all transitions (doors, triggers) with the relevant script commands,
//       or players might end up in the wrong area.
// Note: Areas cannot have duplicate ResRefs, so your new area will have a autogenerated,
//       sequential resref starting with "nw_"; for example: nw_5. You cannot influence this resref.
//       If you destroy an area, that resref will be come free for reuse for the next area created.
//       If you need to know the resref of your new area, you can call GetResRef on it.
// Note: When instancing an area from a loaded savegame, it will spawn the area as it was at time of save, NOT
//       at module creation. This is because the savegame replaces the module data. Due to technical limitations,
//       polymorphed creatures, personal reputation, and associates will currently fail to restore correctly.
object CreateArea(string sSourceResRef, string sNewTag = "", string sNewName = "");

// Destroys the given area object and everything in it.
//
// If the area is in a module, the .are and .git data is left behind and you can spawn from
// it again. If the area is a temporary copy, the data will be deleted and you cannot spawn it again
// via the resref.
//
// Return values:
//    0: Object not an area or invalid.
//   -1: Area contains spawn location and removal would leave module without entrypoint.
//   -2: Players in area.
//    1: Area destroyed successfully.
int DestroyArea(object oArea);

// Creates a copy of a existing area, including everything inside of it (except players).
// Will optionally set a new area tag and displayed name. The new area is accessible
// immediately, but initialisation scripts for the area and all contained creatures will only
// run after the current script finishes (so you can clean up objects before returning).
//
// This is similar to CreateArea, except this variant will copy all changes made to the source
// area since it has spawned. CreateArea() will instance the area from the .are and .git data
// as it was at creation.
//
// Returns the new area, or OBJECT_INVALID on error.
//
// Note: You will have to manually adjust all transitions (doors, triggers) with the
//       relevant script commands, or players might end up in the wrong area.
// Note: Areas cannot have duplicate ResRefs, so your new area will have a autogenerated,
//       sequential resref starting with "nw_"; for example: nw_5. You cannot influence this resref.
//       If you destroy an area, that resref will be come free for reuse for the next area created.
//       If you need to know the resref of your new area, you can call GetResRef on it.
object CopyArea(object oArea, string sNewTag = "", string sNewName = "");

// Returns the first area in the module.
object GetFirstArea();

// Returns the next area in the module (after GetFirstArea), or OBJECT_INVALID if no more
// areas are loaded.
object GetNextArea();

// Sets the transition target for oTransition.
//
// Notes:
// - oTransition can be any valid game object, except areas.
// - oTarget can be any valid game object with a location, or OBJECT_INVALID (to unlink).
// - Rebinding a transition will NOT change the other end of the transition; for example,
//   with normal doors you will have to do either end separately.
// - Any valid game object can hold a transition target, but only some are used by the game engine
//   (doors and triggers). This might change in the future. You can still set and query them for
//   other game objects from nwscript.
// - Transition target objects are cached: The toolset-configured destination tag is
//   used for a lookup only once, at first use. Thus, attempting to use SetTag() to change the
//   destination for a transition will not work in a predictable fashion.
void SetTransitionTarget(object oTransition, object oTarget);

// Sets whether the provided item should be hidden when equipped.
// - The intended usage of this function is to provide an easy way to hide helmets, but it
//   can be used equally for any slot which has creature mesh visibility when equipped,
//   e.g.: armour, helm, cloak, left hand, and right hand.
// - nValue should be TRUE or FALSE.
void SetHiddenWhenEquipped(object oItem, int nValue);

// Returns whether the provided item is hidden when equipped.
int GetHiddenWhenEquipped(object oItem);

// Sets if the given creature has explored tile at x, y of the given area.
// Note that creature needs to be a player- or player-possessed creature.
//
// Keep in mind that tile exploration also controls object visibility in areas
// and the fog of war for interior and underground areas.
//
// Return values:
//  -1: Area or creature invalid.
//   0: Tile was not explored before setting newState.
//   1: Tile was explored before setting newState.
int SetTileExplored(object creature, object area, int x, int y, int newState);

// Returns whether the given tile at x, y, for the given creature in the stated
// area is visible on the map.
// Note that creature needs to be a player- or player-possessed creature.
//
// Keep in mind that tile exploration also controls object visibility in areas
// and the fog of war for interior and underground areas.
//
// Return values:
//  -1: Area or creature invalid.
//   0: Tile is not explored yet.
//   1: Tile is explored.
int GetTileExplored(object creature, object area, int x, int y);

// Sets the creature to auto-explore the map as it walks around.
//
// Keep in mind that tile exploration also controls object visibility in areas
// and the fog of war for interior and underground areas.
//
// This means that if you turn off auto exploration, it falls to you to manage this
// through SetTileExplored(); otherwise, the player will not be able to see anything.
//
// Valid arguments: TRUE and FALSE.
// Does nothing for non-creatures.
// Returns the previous state (or -1 if non-creature).
int SetCreatureExploresMinimap(object creature, int newState);

// Returns TRUE if the creature is set to auto-explore the map as it walks around (on by default).
// Returns FALSE if creature is not actually a creature.
int GetCreatureExploresMinimap(object creature);

// Get the surface material at the given location. (This is
// equivalent to the walkmesh type).
// Returns 0 if the location is invalid or has no surface type.
int GetSurfaceMaterial(location at);

// Returns the z-offset at which the walkmesh is at the given location.
// Returns -6.0 for invalid locations.
float GetGroundHeight(location at);

// Gets the attack bonus limit.
// - The default value is 20.
int GetAttackBonusLimit();

// Gets the damage bonus limit.
// - The default value is 100.
int GetDamageBonusLimit();

// Gets the saving throw bonus limit.
// - The default value is 20.
int GetSavingThrowBonusLimit();

// Gets the ability bonus limit.
// - The default value is 12.
int GetAbilityBonusLimit();

// Gets the ability penalty limit.
// - The default value is 30.
int GetAbilityPenaltyLimit();

// Gets the skill bonus limit.
// - The default value is 50.
int GetSkillBonusLimit();

// Sets the attack bonus limit.
// - The minimum value is 0.
// - The maximum value is 255.
// - This script call will temporarily override user/server configuration for the running module only.
void SetAttackBonusLimit(int nNewLimit);

// Sets the damage bonus limit.
// - The minimum value is 0.
// - The maximum value is 255.
// - This script call will temporarily override user/server configuration for the running module only.
void SetDamageBonusLimit(int nNewLimit);

// Sets the saving throw bonus limit.
// - The minimum value is 0.
// - The maximum value is 255.
// - This script call will temporarily override user/server configuration for the running module only.
void SetSavingThrowBonusLimit(int nNewLimit);

// Sets the ability bonus limit.
// - The minimum value is 0.
// - The maximum value is 255.
// - This script call will temporarily override user/server configuration for the running module only.
void SetAbilityBonusLimit(int nNewLimit);

// Sets the ability penalty limit.
// - The minimum value is 0.
// - The maximum value is 255.
// - This script call will temporarily override user/server configuration for the running module only.
void SetAbilityPenaltyLimit(int nNewLimit);

// Sets the skill bonus limit.
// - The minimum value is 0.
// - The maximum value is 255.
// - This script call will temporarily override user/server configuration for the running module only.
void SetSkillBonusLimit(int nNewLimit);

// Get if oPlayer is currently connected over a relay (instead of directly).
// Returns FALSE for any other object, including OBJECT_INVALID.
int GetIsPlayerConnectionRelayed(object oPlayer);

// Returns the event script for the given object and handler.
// Will return "" if unset, the object is invalid, or the object cannot
// have the requested handler.
string GetEventScript(object oObject, int nHandler);

// Sets the given event script for the given object and handler.
// Returns 1 on success, 0 on failure.
// Will fail if oObject is invalid or does not have the requested handler.
int SetEventScript(object oObject, int nHandler, string sScript);

// Gets a visual transform on the given object.
// - oObject can be any valid Creature, Placeable, Item or Door.
// - nTransform is one of OBJECT_VISUAL_TRANSFORM_*
// - nScope is one of OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_* and specific to the object type being VT'ed.
// Returns the current (or default) value.
float GetObjectVisualTransform(object oObject, int nTransform, int bCurrentLerp = FALSE, int nScope = OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_BASE);

// Sets a visual transform on the given object.
// - oObject can be any valid Creature, Placeable, Item or Door.
// - nTransform is one of OBJECT_VISUAL_TRANSFORM_*
// - fValue depends on the transformation to apply.
// - nScope is one of OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_* and specific to the object type being VT'ed.
// - nBehaviorFlags: bitmask of OBJECT_VISUAL_TRANSFORM_BEHAVIOR_*.
// - nRepeats: If > 0: N times, jump back to initial/from state after completing the transform. If -1: Do forever.
// Returns the old/previous value.
float SetObjectVisualTransform(object oObject, int nTransform, float fValue, int nLerpType = OBJECT_VISUAL_TRANSFORM_LERP_NONE, float fLerpDuration = 0.0, int bPauseWithGame = TRUE, int nScope = OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_BASE, int nBehaviorFlags = OBJECT_VISUAL_TRANSFORM_BEHAVIOR_DEFAULT, int nRepeats = 0);

// Sets an integer material shader uniform override.
// - sMaterial needs to be a material on that object.
// - sParam needs to be a valid shader parameter already defined on the material.
void SetMaterialShaderUniformInt(object oObject, string sMaterial, string sParam, int nValue);

// Sets a vec4 material shader uniform override.
// - sMaterial needs to be a material on that object.
// - sParam needs to be a valid shader parameter already defined on the material.
// - You can specify a single float value to set just a float, instead of a vec4.
void SetMaterialShaderUniformVec4(object oObject, string sMaterial, string sParam, float fValue1, float fValue2 = 0.0, float fValue3 = 0.0, float fValue4 = 0.0);

// Resets material shader parameters on the given object:
// - Supply a material to only reset shader uniforms for meshes with that material.
// - Supply a parameter to only reset shader uniforms of that name.
// - Supply both to only reset shader uniforms of that name on meshes with that material.
void ResetMaterialShaderUniforms(object oObject, string sMaterial = "", string sParam = "");

// Vibrate the player's device or controller. Does nothing if vibration is not supported.
// - nMotor is one of VIBRATOR_MOTOR_*
// - fStrength is between 0.0 and 1.0
// - fSeconds is the number of seconds to vibrate
void Vibrate(object oPlayer, int nMotor, float fStrength, float fSeconds);

// Unlock an achievement for the given player who must be logged in.
// - sId is the achievement ID on the remote server
// - nLastValue is the previous value of the associated achievement stat
// - nCurValue is the current value of the associated achievement stat
// - nMaxValue is the maximum value of the associate achievement stat
void UnlockAchievement(object oPlayer, string sId, int nLastValue=0, int nCurValue=0, int nMaxValue=0);

// Execute a script chunk.
// The script chunk runs immediately, same as ExecuteScript().
// The script is jitted in place and currently not cached: Each invocation will recompile the script chunk.
// Note that the script chunk will run as if a separate script. This is not eval().
// By default, the script chunk is wrapped into void main() {}. Pass in bWrapIntoMain = FALSE to override.
// Returns "" on success, or the compilation error.
string ExecuteScriptChunk(string sScriptChunk, object oObject = OBJECT_SELF, int bWrapIntoMain = TRUE);

// Returns a UUID. This UUID will not be associated with any object.
// The generated UUID is currently a v4.
string GetRandomUUID();

// Returns the given objects' UUID. This UUID is persisted across save boundaries,
// like Save/RestoreCampaignObject and save games.
//
// Thus, reidentification is only guaranteed in scenarios where players cannot introduce
// new objects (i.e. servervault servers).
//
// UUIDs are guaranteed to be unique in any single running game.
//
// If a loaded object would collide with a UUID already present in the game, the
// object receives no UUID and a warning is emitted to the log. Requesting a UUID
// for the new object will generate a random one.
//
// This UUID is useful to, for example:
// - Safely identify servervault characters
// - Track serialisable objects (like items or creatures) as they are saved to the
//   campaign DB - i.e. persistent storage chests or dropped items.
// - Track objects across multiple game instances (in trusted scenarios).
//
// Currently, the following objects can carry UUIDs:
//   Items, Creatures, Placeables, Triggers, Doors, Waypoints, Stores,
//   Encounters, Areas.
//
// Will return "" (empty string) when the given object cannot carry a UUID.
string GetObjectUUID(object oObject);

// Forces the given object to receive a new UUID, discarding the current value.
void ForceRefreshObjectUUID(object oObject);

// Looks up a object on the server by it's UUID.
// Returns OBJECT_INVALID if the UUID is not on the server.
object GetObjectByUUID(string sUUID);

// Do not call. This does nothing on this platform except to return an error.
void Reserved899();

// Makes oPC load texture sNewName instead of sOldName.
// If oPC is OBJECT_INVALID, it will apply the override to all active players
// Setting sNewName to "" will clear the override and revert to original.
void SetTextureOverride(string sOldName, string sNewName = "", object oPC = OBJECT_INVALID);

// Displays sMsg on oPC's screen.
// The message is displayed on top of whatever is on the screen, including UI elements
//  nX, nY - coordinates of the first character to be displayed. The value is in terms
//           of character 'slot' relative to the nAnchor anchor point.
//           If the number is negative, it is applied from the bottom/right.
//  nAnchor - SCREEN_ANCHOR_* constant
//  fLife - Duration in seconds until the string disappears.
//  nRGBA, nRGBA2 - Colors of the string in 0xRRGGBBAA format. String starts at nRGBA,
//                  but as it nears end of life, it will slowly blend into nRGBA2.
//  nID - Optional ID of a string. If not 0, subsequent calls to PostString will
//        remove the old string with the same ID, even if it's lifetime has not elapsed.
//        Only positive values are allowed.
//  sFont - If specified, use this custom font instead of default console font.
void PostString(object oPC, string sMsg, int nX = 0, int nY = 0, int nAnchor = SCREEN_ANCHOR_TOP_LEFT, float fLife = 10.0f, int nRGBA = 2147418367, int nRGBA2 = 2147418367, int nID = 0, string sFont="");

// Returns oCreature's spell school specialization in nClass (SPELL_SCHOOL_* constants)
// Unless custom content is used, only Wizards have spell schools
// Returns -1 on error
int GetSpecialization(object oCreature, int nClass = CLASS_TYPE_WIZARD);

// Returns oCreature's domain in nClass (DOMAIN_* constants)
// nDomainIndex - 1 or 2
// Unless custom content is used, only Clerics have domains
// Returns -1 on error
int GetDomain(object oCreature, int nDomainIndex = 1, int nClass = CLASS_TYPE_CLERIC);

// Returns the patch build number of oPlayer (i.e. the 8193 out of "87.8193.35-29 abcdef01").
// Returns 0 if the given object isn't a player or did not advertise their build info, or the
// player version is old enough not to send this bit of build info to the server.
int GetPlayerBuildVersionMajor(object oPlayer);

// Returns the patch revision number of oPlayer (i.e. the 35 out of "87.8193.35-29 abcdef01").
// Returns 0 if the given object isn't a player or did not advertise their build info, or the
// player version is old enough not to send this bit of build info to the server.
int GetPlayerBuildVersionMinor(object oPlayer);

// Returns the script parameter value for a given parameter name.
// Script parameters can be set for conversation scripts in the toolset's
// Conversation Editor, or for any script with SetScriptParam().
// * Will return "" if a parameter with the given name does not exist.
string GetScriptParam(string sParamName);

// Set a script parameter value for the next script to be run.
// Call this function to set parameters right before calling ExecuteScript().
void SetScriptParam(string sParamName, string sParamValue);

// Returns the number of uses per day remaining of the given item and item property.
// * Will return 0 if the given item does not have the requested item property,
//   or the item property is not uses/day.
int GetItemPropertyUsesPerDayRemaining(object oItem, itemproperty ip);

// Sets the number of uses per day remaining of the given item and item property.
// * Will do nothing if the given item and item property is not uses/day.
// * Will constrain nUsesPerDay to the maximum allowed as the cost table defines.
void SetItemPropertyUsesPerDayRemaining(object oItem, itemproperty ip, int nUsesPerDay);

// Queue an action to use an active item property.
// * oItem - item that has the item property to use
// * ip - item property to use
// * object oTarget - target
// * nSubPropertyIndex - specify if your itemproperty has subproperties (such as subradial spells)
// * bDecrementCharges - decrement charges if item property is limited
void ActionUseItemOnObject(object oItem, itemproperty ip, object oTarget, int nSubPropertyIndex = 0, int bDecrementCharges = TRUE);

// Queue an action to use an active item property.
// * oItem - item that has the item property to use
// * ip - item property to use
// * location lTarget - target location (must be in the same area as item possessor)
// * nSubPropertyIndex - specify if your itemproperty has subproperties (such as subradial spells)
// * bDecrementCharges - decrement charges if item property is limited
void ActionUseItemAtLocation(object oItem, itemproperty ip, location lTarget, int nSubPropertyIndex = 0, int bDecrementCharges = TRUE);

// Makes oPC enter a targeting mode, letting them select an object as a target
// If a PC selects a target or cancels out, it will trigger the module OnPlayerTarget event.
// * nValidObjectTypes - If you use 0 will cancel any current targeting mode the client is in.
void EnterTargetingMode(object oPC, int nValidObjectTypes = OBJECT_TYPE_ALL, int nMouseCursorId = MOUSECURSOR_MAGIC, int nBadTargetCursor = MOUSECURSOR_NOMAGIC);

// Gets the target object in the module OnPlayerTarget event.
// Returns the area object when the target is the ground.
// Note: returns OBJECT_INVALID if the player cancelled out of targeting mode.
object GetTargetingModeSelectedObject();

// Gets the target position in the module OnPlayerTarget event.
vector GetTargetingModeSelectedPosition();

// Gets the player object that triggered the OnPlayerTarget event.
object GetLastPlayerToSelectTarget();

// Sets oObject's hilite color to nColor
// The nColor format is 0xRRGGBB; -1 clears the color override.
void SetObjectHiliteColor(object oObject, int nColor = -1);

// Sets the cursor (MOUSECURSOR_*) to use when hovering over oObject
void SetObjectMouseCursor(object oObject, int nCursor = -1);

// Returns TRUE if the given player-controlled creature has DM privileges
// gained through a player login (as opposed to the DM client).
// Note: GetIsDM() also returns TRUE for player creature DMs.
int GetIsPlayerDM(object oCreature);

// Sets the detailed wind data for oArea
// The predefined values in the toolset are:
//   NONE:  vDirection=(1.0, 1.0, 0.0), fMagnitude=0.0, fYaw=0.0,   fPitch=0.0
//   LIGHT: vDirection=(1.0, 1.0, 0.0), fMagnitude=1.0, fYaw=100.0, fPitch=3.0
//   HEAVY: vDirection=(1.0, 1.0, 0.0), fMagnitude=2.0, fYaw=150.0, fPitch=5.0
void SetAreaWind(object oArea, vector vDirection, float fMagnitude, float fYaw, float fPitch);

// Replace's oObject's texture sOld with sNew.
// Specifying sNew = "" will restore the original texture.
// If sNew cannot be found, the original texture will be restored.
// sNew must refer to a simple texture, not PLT
void ReplaceObjectTexture(object oObject, string sOld, string sNew = "");

// Destroys the given sqlite database, clearing out all data and schema.
// This operation is _immediate_ and _irreversible_, even when
// inside a transaction or running query.
// Existing active/prepared sqlqueries will remain functional, but any references
// to stored data or schema members will be invalidated.
// oObject: Same as SqlPrepareQueryObject().
//          To reset a campaign database, please use DestroyCampaignDatabase().
void SqlDestroyDatabase(object oObject);

// Returns "" if the last Sql command succeeded; or a human-readable error otherwise.
// Additionally, all SQL errors are logged to the server log.
// Additionally, all SQL errors are sent to all connected players.
string SqlGetError(sqlquery sqlQuery);

// Sets up a query.
// This will NOT run the query; only make it available for parameter binding.
// To run the query, you need to call SqlStep(); even if you do not
// expect result data.
// sDatabase: The name of a campaign database.
//            Note that when accessing campaign databases, you do not write access
//            to the builtin tables needed for CampaignDB functionality.
// N.B.: You can pass sqlqueries into DelayCommand; HOWEVER
//       *** they will NOT survive a game save/load ***
//       Any commands on a restored sqlquery will fail.
// N.B.: All uncommitted transactions left over at script termination are automatically rolled back.
//       This ensures that no database handle will be left in an unusable state.
// Please check the SQLite_README.txt file in lang/en/docs/ for the list of builtin functions.
sqlquery SqlPrepareQueryCampaign(string sDatabase, string sQuery);

// Sets up a query.
// This will NOT run the query; only make it available for parameter binding.
// To run the query, you need to call SqlStep(); even if you do not
// expect result data.
// oObject: Can be either the module (GetModule()), or a player character.
//          The database is persisted to savegames in case of the module,
//          and to character files in case of a player characters.
//          Other objects cannot carry databases, and this function call
//          will error for them.
// N.B: Databases on objects (especially player characters!) should be kept
//      to a reasonable size. Delete old data you no longer need.
//      If you attempt to store more than a few megabytes of data on a
//      player creature, you may have a bad time.
// N.B.: You can pass sqlqueries into DelayCommand; HOWEVER
//       *** they will NOT survive a game save/load ***
//       Any commands on a restored sqlquery will fail.
// N.B.: All uncommitted transactions left over at script termination are automatically rolled back.
//       This ensures that no database handle will be left in an unusable state.
// Please check the SQLite_README.txt file in lang/en/docs/ for the list of builtin functions.
sqlquery SqlPrepareQueryObject(object oObject, string sQuery);

// Bind an integer to a named parameter of the given prepared query.
// Example:
//   sqlquery v = SqlPrepareQueryObject(GetModule(), "insert into test (col) values (@myint);");
//   SqlBindInt(v, "@myint", 5);
//   SqlStep(v);
void SqlBindInt(sqlquery sqlQuery, string sParam, int nValue);

// Bind a float to a named parameter of the given prepared query.
void SqlBindFloat(sqlquery sqlQuery, string sParam, float fFloat);

// Bind a string to a named parameter of the given prepared query.
void SqlBindString(sqlquery sqlQuery, string sParam, string sString);

// Bind a vector to a named parameter of the given prepared query.
void SqlBindVector(sqlquery sqlQuery, string sParam, vector vVector);

// Bind a object to a named parameter of the given prepared query.
// Objects are serialized, NOT stored as a reference!
// Currently supported object types: Creatures, Items, Placeables, Waypoints, Stores, Doors, Triggers, Encounters, Areas (CAF format)
// If bSaveObjectState is TRUE, local vars, effects, action queue, and transition info (triggers, doors) are saved out
// (except for Combined Area Format, which always has object state saved out).
void SqlBindObject(sqlquery sqlQuery, string sParam, object oObject, int bSaveObjectState = FALSE);

// Executes the given query and fetches a row; returning true if row data was
// made available; false otherwise. Note that this will return false even if
// the query ran successfully but did not return data.
// You need to call SqlPrepareQuery() and potentially SqlBind* before calling this.
// Example:
//   sqlquery n = SqlPrepareQueryObject(GetFirstPC(), "select widget from widgets;");
//   while (SqlStep(n))
//     SendMessageToPC(GetFirstPC(), "Found widget: " + SqlGetString(n, 0));
int SqlStep(sqlquery sqlQuery);

// Retrieve a column cast as an integer of the currently stepped row.
// You can call this after SqlStep() returned TRUE.
// In case of error, 0 will be returned.
// In traditional fashion, nIndex starts at 0.
int SqlGetInt(sqlquery sqlQuery, int nIndex);

// Retrieve a column cast as a float of the currently stepped row.
// You can call this after SqlStep() returned TRUE.
// In case of error, 0.0f will be returned.
// In traditional fashion, nIndex starts at 0.
float SqlGetFloat(sqlquery sqlQuery, int nIndex);

// Retrieve a column cast as a string of the currently stepped row.
// You can call this after SqlStep() returned TRUE.
// In case of error, a empty string will be returned.
// In traditional fashion, nIndex starts at 0.
string SqlGetString(sqlquery sqlQuery, int nIndex);

// Retrieve a vector of the currently stepped query.
// You can call this after SqlStep() returned TRUE.
// In case of error, a zero vector will be returned.
// In traditional fashion, nIndex starts at 0.
vector SqlGetVector(sqlquery sqlQuery, int nIndex);

// Retrieve a object of the currently stepped query.
// You can call this after SqlStep() returned TRUE.
// The object will be spawned into a inventory if it is a item and the receiver
// has the capability to receive it, otherwise at lSpawnAt.
// Objects are serialized, NOT stored as a reference!
// In case of error, INVALID_OBJECT will be returned.
// In traditional fashion, nIndex starts at 0.
// If bLoadObjectState is TRUE, local vars, effects, action queue, and transition info (triggers, doors) are read in.
object SqlGetObject(sqlquery sqlQuery, int nIndex, location lSpawnAt, object oInventory = OBJECT_INVALID, int bLoadObjectState = FALSE);

// Convert sHex, a string containing a hexadecimal object id,
// into a object reference. Counterpart to ObjectToString().
object StringToObject(string sHex);

// Sets the current hitpoints of oObject.
// * You cannot destroy or revive objects or creatures with this function.
// * For currently dying PCs, you can only set hitpoints in the range of -9 to 0.
// * All other objects need to be alive and the range is clamped to 1 and max hitpoints.
// * This is not considered damage (or healing). It circumvents all combat logic, including damage resistance and reduction.
// * This is not considered a friendly or hostile combat action. It will not affect factions, nor will it trigger script events.
// * This will not advise player parties in the combat log.
void SetCurrentHitPoints(object oObject, int nHitPoints);

// Returns the currently executing event (EVENT_SCRIPT_*) or 0 if not determinable.
// Note: Will return 0 in DelayCommand/AssignCommand.
// * bInheritParent: If TRUE, ExecuteScript(Chunk) will inherit their event ID from their parent event.
//                   If FALSE, it will return the event ID of the current script, which may be 0.
//
// Some events can run in the same script context as a previous event (for example: CreatureOnDeath, CreatureOnDamaged)
// In cases like these calling the function with bInheritParent = TRUE will return the wrong event ID.
int GetCurrentlyRunningEvent(int bInheritParent = TRUE);

// Get the integer parameter of eEffect at nIndex.
// * nIndex bounds: 0 >= nIndex < 8.
// * Some experimentation will be needed to find the right index for the value you wish to determine.
// Returns: the value or 0 on error/when not set.
int GetEffectInteger(effect eEffect, int nIndex);

// Get the float parameter of eEffect at nIndex.
// * nIndex bounds: 0 >= nIndex < 4.
// * Some experimentation will be needed to find the right index for the value you wish to determine.
// Returns: the value or 0.0f on error/when not set.
float GetEffectFloat(effect eEffect, int nIndex);

// Get the string parameter of eEffect at nIndex.
// * nIndex bounds: 0 >= nIndex < 6.
// * Some experimentation will be needed to find the right index for the value you wish to determine.
// Returns: the value or "" on error/when not set.
string GetEffectString(effect eEffect, int nIndex);

// Get the object parameter of eEffect at nIndex.
// * nIndex bounds: 0 >= nIndex < 4.
// * Some experimentation will be needed to find the right index for the value you wish to determine.
// Returns: the value or OBJECT_INVALID on error/when not set.
object GetEffectObject(effect eEffect, int nIndex);

// Get the vector parameter of eEffect at nIndex.
// * nIndex bounds: 0 >= nIndex < 2.
// * Some experimentation will be needed to find the right index for the value you wish to determine.
// Returns: the value or {0.0f, 0.0f, 0.0f} on error/when not set.
vector GetEffectVector(effect eEffect, int nIndex);

// Check if nBaseItemType fits in oTarget's inventory.
// Note: Does not check inside any container items possessed by oTarget.
// * nBaseItemType: a BASE_ITEM_* constant.
// * oTarget: a valid creature, placeable or item.
// Returns: TRUE if the baseitem type fits, FALSE if not or on error.
int GetBaseItemFitsInInventory(int nBaseItemType, object oTarget);

// Get oObject's local cassowary variable reference sVarName
// * Return value on error: empty solver
// * NB: cassowary types are references, same as objects.
//   Unlike scalars such as int and string, solver references share the same data.
//   Modifications made to one reference are reflected on others.
cassowary GetLocalCassowary(object oObject, string sVarName);

// Set a reference to the given solver on oObject.
// * NB: cassowary types are references, same as objects.
//   Unlike scalars such as int and string, solver references share the same data.
//   Modifications made to one reference are reflected on others.
void SetLocalCassowary(object oObject, string sVarName, cassowary cSolver);

// Delete local solver reference.
// * NB: cassowary types are references, same as objects.
//   Unlike scalars such as int and string, solver references share the same data.
//   Modifications made to one reference are reflected on others.
void DeleteLocalCassowary(object oObject, string sVarName);

// Clear out this solver, removing all state, constraints and suggestions.
// This is provided as a convenience if you wish to reuse a cassowary variable.
// It is not necessary to call this for solvers you simply want to let go out of scope.
void CassowaryReset(cassowary cSolver);

// Add a constraint to the system.
// * The constraint needs to be a valid comparison equation, one of: >=, ==, <=.
// * This implementation is a linear constraint solver.
// * You cannot multiply or divide variables and expressions with each other.
//   Doing so will result in a error when attempting to add the constraint.
//   (You can, of course, multiply or divide by constants).
// * fStrength must be >= CASSOWARY_STRENGTH_WEAK && <= CASSOWARY_STRENGTH_REQUIRED.
// * Any referenced variables can be retrieved with CassowaryGetValue().
// * Returns "" on success, or the parser/constraint system error message.
string CassowaryConstrain(cassowary cSolver, string sConstraint, float fStrength = CASSOWARY_STRENGTH_REQUIRED);

// Suggest a value to the solver.
// * Edit variables are soft constraints and exist as an optimisation for complex systems.
//   You can do the same with Constrain("v == 5", CASSOWARY_STRENGTH_xxx); but edit variables
//   allow you to suggest values without having to rebuild the solver.
// * fStrength must be >= CASSOWARY_STRENGTH_WEAK && < CASSOWARY_STRENGTH_REQUIRED
//   Suggested values cannot be required, as suggesting a value must not invalidate the solver.
void CassowarySuggestValue(cassowary cSolver, string sVarName, float fValue, float fStrength = CASSOWARY_STRENGTH_STRONG);

// Get the value for the given variable, or 0.0 on error.
float CassowaryGetValue(cassowary cSolver, string sVarName);

// Gets a printable debug state of the given solver, which may help you debug
// complex systems.
string CassowaryDebug(cassowary cSolver);

// Overrides a given strref to always return sValue instead of what is in the TLK file.
// Setting sValue to "" will delete the override
void SetTlkOverride(int nStrRef, string sValue="");

// Constructs a custom itemproperty given all the parameters explicitly.
// This function can be used in place of all the other ItemPropertyXxx constructors
// Use GetItemProperty{Type,SubType,CostTableValue,Param1Value} to see the values for a given itemproperty.
itemproperty ItemPropertyCustom(int nType, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=-1);

// Create a RunScript effect.
// Notes: When applied as instant effect, only sOnAppliedScript will fire.
//        In the scripts, OBJECT_SELF will be the object the effect is applied to.
// * sOnAppliedScript: An optional script to execute when the effect is applied.
// * sOnRemovedScript: An optional script to execute when the effect is removed.
// * sOnIntervalScript: An optional script to execute every fInterval seconds.
// * fInterval: The interval in seconds, must be >0.0f if an interval script is set.
//              Very low values may have an adverse effect on performance.
// * sData: An optional string of data saved in the effect, retrievable with GetEffectString() at index 0.
effect EffectRunScript(string sOnAppliedScript = "", string sOnRemovedScript = "", string sOnIntervalScript = "", float fInterval = 0.0f, string sData = "");

// Get the effect that last triggered an EffectRunScript() script.
// Note: This can be used to get the creator or tag, among others, of the EffectRunScript() in one of its scripts.
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT when called outside of an EffectRunScript() script.
effect GetLastRunScriptEffect();

// Get the script type (RUNSCRIPT_EFFECT_SCRIPT_TYPE_*) of the last triggered EffectRunScript() script.
// * Returns 0 when called outside of an EffectRunScript() script.
int GetLastRunScriptEffectScriptType();

// Hides the effect icon of eEffect and of all effects currently linked to it.
effect HideEffectIcon(effect eEffect);

// Create an Icon effect.
// * nIconID: The effect icon (EFFECT_ICON_*) to display.
//            Using the icon for Poison/Disease will also color the health bar green/brown, useful to simulate custom poisons/diseases.
// Returns an effect of type EFFECT_TYPE_INVALIDEFFECT when nIconID is < 1 or > 255.
effect EffectIcon(int nIconID);

// Gets the player that last triggered the module OnPlayerGuiEvent event.
object GetLastGuiEventPlayer();

// Gets the last triggered GUIEVENT_* in the module OnPlayerGuiEvent event.
int GetLastGuiEventType();

// Gets an optional integer of specific gui events in the module OnPlayerGuiEvent event.
// * GUIEVENT_CHATBAR_*: The selected chat channel. Does not indicate the actual used channel.
//                       0 = Shout, 1 = Whisper, 2 = Talk, 3 = Party, 4 = DM
// * GUIEVENT_CHARACTERSHEET_SKILL_SELECT: The skill ID.
// * GUIEVENT_CHARACTERSHEET_FEAT_SELECT: The feat ID.
// * GUIEVENT_EFFECTICON_CLICK: The effect icon ID (EFFECT_ICON_*)
// * GUIEVENT_DISABLED_PANEL_ATTEMPT_OPEN: The GUI_PANEL_* the player attempted to open.
// * GUIEVENT_QUICKCHAT_SELECT: The hotkey character representing the option
// * GUIEVENT_EXAMINE_OBJECT: A GUI_PANEL_EXAMINE_* constant
int GetLastGuiEventInteger();

// Gets an optional object of specific gui events in the module OnPlayerGuiEvent event.
// * GUIEVENT_MINIMAP_MAPPIN_CLICK: The waypoint the map note is attached to.
// * GUIEVENT_CHARACTERSHEET_*_SELECT: The owner of the character sheet.
// * GUIEVENT_PLAYERLIST_PLAYER_CLICK: The player clicked on.
// * GUIEVENT_PARTYBAR_PORTRAIT_CLICK: The creature clicked on.
// * GUIEVENT_DISABLED_PANEL_ATTEMPT_OPEN: For GUI_PANEL_CHARACTERSHEET, the owner of the character sheet.
//                                         For GUI_PANEL_EXAMINE_*, the object being examined.
// * GUIEVENT_*SELECT_CREATURE: The creature that was (un)selected
// * GUIEVENT_EXAMINE_OBJECT: The object being examined.
// * GUIEVENT_CHATLOG_PORTRAIT_CLICK: The owner of the portrait.
// * GUIEVENT_PLAYERLIST_PLAYER_TELL: The selected player.
object GetLastGuiEventObject();

// Disable a gui panel for the client that controls oPlayer.
// Notes: Will close the gui panel if currently open, except GUI_PANEL_LEVELUP / GUI_PANEL_GOLD_*
//        Does not persist through relogging or in savegames.
//        Will fire a GUIEVENT_DISABLED_PANEL_ATTEMPT_OPEN OnPlayerGuiEvent for some gui panels if a player attempts to open them.
//        You can still force show a panel with PopUpGUIPanel().
//        You can still force examine an object with ActionExamine().
// * nGuiPanel: A GUI_PANEL_* constant, except GUI_PANEL_PLAYER_DEATH.
void SetGuiPanelDisabled(object oPlayer, int nGuiPanel, int bDisabled, object oTarget = OBJECT_INVALID);

// Gets the ID (1..8) of the last tile action performed in OnPlayerTileAction
int GetLastTileActionId();

// Gets the target position in the module OnPlayerTileAction event.
vector GetLastTileActionPosition();

// Gets the player object that triggered the OnPlayerTileAction event.
object GetLastPlayerToDoTileAction();

// Parse the given string as a valid json value, and returns the corresponding type.
// Returns a JSON_TYPE_NULL on error.
// Check JsonGetError() to see the parse error, if any.
// NB: The parsed string needs to be in game-local encoding, but the generated json structure
//     will contain UTF-8 data.
json JsonParse(string sJson);

// Dump the given json value into a string that can be read back in via JsonParse.
// nIndent describes the indentation level for pretty-printing; a value of -1 means no indentation and no linebreaks.
// Returns a string describing JSON_TYPE_NULL on error.
// NB: The dumped string is in game-local encoding, with all non-ascii characters escaped.
string JsonDump(json jValue, int nIndent = -1);

// Describes the type of the given json value.
// Returns JSON_TYPE_NULL if the value is empty.
int JsonGetType(json jValue);

// Returns the length of the given json type.
// For objects, returns the number of top-level keys present.
// For arrays, returns the number of elements.
// Null types are of size 0.
// All other types return 1.
int JsonGetLength(json jValue);

// Returns the error message if the value has errored out.
// Currently only describes parse errors.
string JsonGetError(json jValue);

// Create a NULL json value, seeded with a optional error message for JsonGetError().
// You can say JSON_NULL for default parameters on functions to initialise with a null value.
json JsonNull(string sError = "");

// Create a empty json object.
// You can say JSON_OBJECT for default parameters on functions to initialise with an empty object.
json JsonObject();

// Create a empty json array.
// You can say JSON_ARRAY for default parameters on functions to initialise with an empty array.
json JsonArray();

// Create a json string value.
// You can say JSON_STRING for default parameters on functions to initialise with a empty string.
// NB: Strings are encoded to UTF-8 from the game-local charset.
json JsonString(string sValue);

// Create a json integer value.
json JsonInt(int nValue);

// Create a json floating point value.
json JsonFloat(float fValue);

// Create a json bool value.
// You can say JSON_TRUE or JSON_FALSE for default parameters on functions to initialise with a bool.
json JsonBool(int bValue);

// Returns a string representation of the json value.
// Returns "" if the value cannot be represented as a string, or is empty.
// NB: Strings are decoded from UTF-8 to the game-local charset.
string JsonGetString(json jValue);

// Returns a int representation of the json value, casting where possible.
// Returns 0 if the value cannot be represented as a int.
// Use this to parse json bool types.
// NB: This will narrow down to signed 32 bit, as that is what NWScript int is.
//     If you are trying to read a 64 bit or unsigned integer that doesn't fit into int32, you will lose data.
//     You will not lose data if you keep the value as a json element (via Object/ArrayGet).
int JsonGetInt(json jValue);

// Returns a float representation of the json value, casting where possible.
// Returns 0.0 if the value cannot be represented as a float.
// NB: This will narrow doubles down to float.
//     If you are trying to read a double, you will potentially lose precision.
//     You will not lose data if you keep the value as a json element (via Object/ArrayGet).
float JsonGetFloat(json jValue);

// Returns a json array containing all keys of jObject.
// Returns a empty array if the object is empty or not a json object, with JsonGetError() filled in.
json JsonObjectKeys(json jObject);

// Returns the key value of sKey on the object jObect.
// Returns a null json value if jObject is not a object or sKey does not exist on the object, with JsonGetError() filled in.
json JsonObjectGet(json jObject, string sKey);

// Returns a modified copy of jObject with the key at sKey set to jValue.
// Returns a json null value if jObject is not a object, with JsonGetError() filled in.
json JsonObjectSet(json jObject, string sKey, json jValue);

// Returns a modified copy of jObject with the key at sKey deleted.
// Returns a json null value if jObject is not a object, with JsonGetError() filled in.
json JsonObjectDel(json jObject, string sKey);

// Gets the json object at jArray index position nIndex.
// Returns a json null value if the index is out of bounds, with JsonGetError() filled in.
json JsonArrayGet(json jArray, int nIndex);

// Returns a modified copy of jArray with position nIndex set to jValue.
// Returns a json null value if jArray is not actually an array, with JsonGetError() filled in.
// Returns a json null value if nIndex is out of bounds, with JsonGetError() filled in.
json JsonArraySet(json jArray, int nIndex, json jValue);

// Returns a modified copy of jArray with jValue inserted at position nIndex.
// All succeeding objects in the array will move by one.
// By default (-1), inserts objects at the end of the array ("push").
// nIndex = 0 inserts at the beginning of the array.
// Returns a json null value if jArray is not actually an array, with JsonGetError() filled in.
// Returns a json null value if nIndex is not 0 or -1 and out of bounds, with JsonGetError() filled in.
json JsonArrayInsert(json jArray, json jValue, int nIndex = -1);

// Returns a modified copy of jArray with the element at position nIndex removed,
// and the array resized by one.
// Returns a json null value if jArray is not actually an array, with JsonGetError() filled in.
// Returns a json null value if nIndex is out of bounds, with JsonGetError() filled in.
json JsonArrayDel(json jArray, int nIndex);

// Transforms the given object into a json structure.
// The json format is compatible with what https://github.com/niv/neverwinter.nim@1.4.3+ emits.
// Returns the null json type on errors, or if oObject is not serializable, with JsonGetError() filled in.
// Supported object types: creature, item, trigger, placeable, door, waypoint, encounter, store, area (combined format), soundobject
// If bSaveObjectState is TRUE, local vars, effects, action queue, and transition info (triggers, doors) are saved out
// (except for Combined Area Format, which always has object state saved out).
//
// N.B.:
//   This function is for advanced usecases that require understanding of the game's internals
//   and how the engine loads and migrates data as the game is changed to support new features.
//   The only guarantee given is that older data files can be loaded on newer game versions.
//   As such, fields can become deprecated or change meaning. You need to handle this by
//   either constructing a clean-room GFF file, or by writing migration code using the
//   game/build version getters.
json ObjectToJson(object oObject, int bSaveObjectState = FALSE);

// Deserializes the game object described in jObject.
// Returns OBJECT_INVALID on errors.
// Supported object types: creature, item, trigger, placeable, door, waypoint, encounter, store, area (combined format), soundobject
// For areas, locLocation is ignored.
// If bLoadObjectState is TRUE, local vars, effects, action queue, and transition info (triggers, doors) are read in.
//
// N.B.:
//   This function is for advanced usecases that require understanding of the game's internals
//   and how the engine loads and migrates data as the game is changed to support new features.
//   The only guarantee given is that older data files can be loaded on newer game versions.
//   As such, fields can become deprecated or change meaning. You need to handle this by
//   either constructing a clean-room GFF file, or by writing migration code using the
//   game/build version getters.
object JsonToObject(json jObject, location locLocation, object oOwner = OBJECT_INVALID, int bLoadObjectState = FALSE);

// Returns the element at the given JSON pointer value.
// For example, given the JSON document:
//   {
//     "foo": ["bar", "baz"],
//     "": 0,
//     "a/b": 1,
//     "c%d": 2,
//     "e^f": 3,
//     "g|h": 4,
//     "i\\j": 5,
//     "k\"l": 6,
//     " ": 7,
//     "m~n": 8
//   }
// The following JSON strings evaluate to the accompanying values:
//   ""           // the whole document
//   "/foo"       ["bar", "baz"]
//   "/foo/0"     "bar"
//   "/"          0
//   "/a~1b"      1
//   "/c%d"       2
//   "/e^f"       3
//   "/g|h"       4
//   "/i\\j"      5
//   "/k\"l"      6
//   "/ "         7
//   "/m~0n"      8
// See https://datatracker.ietf.org/doc/html/rfc6901 for more details.
// Returns a json null value on error, with JsonGetError() filled in.
json JsonPointer(json jData, string sPointer);

// Return a modified copy of jData with jPatch applied, according to the rules described below.
// See JsonPointer() for documentation on the pointer syntax.
// Returns a json null value on error, with JsonGetError() filled in.
// jPatch is an array of patch elements, each containing a op, a path, and a value field. Example:
// [
//   { "op": "replace", "path": "/baz", "value": "boo" },
//   { "op": "add", "path": "/hello", "value": ["world"] },
//   { "op": "remove", "path": "/foo"}
// ]
// Valid operations are: add, remove, replace, move, copy, test
// See https://datatracker.ietf.org/doc/html/rfc7386 for more details on the patch rules.
json JsonPatch(json jData, json jPatch);

// Returns the diff (described as a json structure you can pass into JsonPatch) between the two objects.
// Returns a json null value on error, with JsonGetError() filled in.
json JsonDiff(json jLHS, json jRHS);

// Returns a modified copy of jData with jMerge merged into it. This is an alternative to
// JsonPatch/JsonDiff, with a syntax more closely resembling the final object.
// See https://datatracker.ietf.org/doc/html/rfc7386 for details.
// Returns a json null value on error, with JsonGetError() filled in.
json JsonMerge(json jData, json jMerge);

// Get oObject's local json variable sVarName
// * Return value on error: json null type
json GetLocalJson(object oObject, string sVarName);

// Set oObject's local json variable sVarName to jValue
void SetLocalJson(object oObject, string sVarName, json jValue);

// Delete oObject's local json variable sVarName
void DeleteLocalJson(object oObject, string sVarName);

// Bind an json to a named parameter of the given prepared query.
// Json values are serialised into a string.
// Example:
//   sqlquery v = SqlPrepareQueryObject(GetModule(), "insert into test (col) values (@myjson);");
//   SqlBindJson(v, "@myjson", myJsonObject);
//   SqlStep(v);
void SqlBindJson(sqlquery sqlQuery, string sParam, json jValue);

// Retrieve a column cast as a json value of the currently stepped row.
// You can call this after SqlStep() returned TRUE.
// In case of error, a json null value will be returned.
// In traditional fashion, nIndex starts at 0.
json SqlGetJson(sqlquery sqlQuery, int nIndex);

// This stores a json out to the specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
void SetCampaignJson(string sCampaignName, string sVarName, json jValue, object oPlayer=OBJECT_INVALID);

// This will read a json from the  specified campaign database
// The database name:
//  - is case insensitive and it must be the same for both set and get functions.
//  - can only contain alphanumeric characters, no spaces.
// The var name must be unique across the entire database, regardless of the variable type.
// If you want a variable to pertain to a specific player in the game, provide a player object.
json GetCampaignJson(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);

// Gets a device property/capability as advertised by the client.
// sProperty is one of PLAYER_DEVICE_PROPERTY_xxx.
// Returns -1 if
// - the property was never set by the client,
// - the the actual value is -1,
// - the player is running a older build that does not advertise device properties,
// - the player has disabled sending device properties (Options->Game->Privacy).
int GetPlayerDeviceProperty(object oPlayer, string sProperty);

// Returns the LANGUAGE_xx code of the given player, or -1 if unavailable.
int GetPlayerLanguage(object oPlayer);

// Returns one of PLAYER_DEVICE_PLATFORM_xxx, or 0 if unavailable.
int GetPlayerDevicePlatform(object oPlayer);

// Deserializes the given resref/template into a JSON structure.
// Supported GFF resource types:
// * RESTYPE_CAF (and RESTYPE_ARE, RESTYPE_GIT, RESTYPE_GIC)
// * RESTYPE_UTC
// * RESTYPE_UTI
// * RESTYPE_UTT
// * RESTYPE_UTP
// * RESTYPE_UTD
// * RESTYPE_UTW
// * RESTYPE_UTE
// * RESTYPE_UTM
// * RESTYPE_DLG
// * RESTYPE_UTS
// * RESTYPE_IFO
// * RESTYPE_FAC
// * RESTYPE_ITP
// * RESTYPE_GUI
// * RESTYPE_GFF
// Returns a valid gff-type json structure, or a null value with JsonGetError() set.
json TemplateToJson(string sResRef, int nResType);

// Returns the resource location of sResRef.nResType, as seen by the running module.
// Note for dedicated servers: Checks on the module/server side, not the client.
// Returns "" if the resource does not exist in the search space.
string ResManGetAliasFor(string sResRef, int nResType);

// Finds the nNth available resref starting with sPrefix.
// * Set bSearchBaseData to TRUE to also search base game content stored in your game installation directory.
//   WARNING: This can be very slow.
// * Set sOnlyKeyTable to a specific keytable to only search the given named keytable (e.g. "OVERRIDE:").
// Returns "" if no such resref exists.
string ResManFindPrefix(string sPrefix, int nResType, int nNth = 1, int bSearchBaseData = FALSE, string sOnlyKeyTable = "");

// Create a NUI window from the given resref(.jui) for the given player.
// * The resref needs to be available on the client, not the server.
// * The token is a integer for ease of handling only. You are not supposed to do anything with it, except store/pass it.
// * The window ID needs to be alphanumeric and short. Only one window (per client) with the same ID can exist at a time.
//   Re-creating a window with the same id of one already open will immediately close the old one.
// * sEventScript is optional and overrides the NUI module event for this window only.
// * See nw_inc_nui.nss for full documentation.
// Returns the window token on success (>0), or 0 on error.
int NuiCreateFromResRef(object oPlayer, string sResRef, string sWindowId = "", string sEventScript = "");

// Create a NUI window inline for the given player.
// * The token is a integer for ease of handling only. You are not supposed to do anything with it, except store/pass it.
// * The window ID needs to be alphanumeric and short. Only one window (per client) with the same ID can exist at a time.
//   Re-creating a window with the same id of one already open will immediately close the old one.
// * sEventScript is optional and overrides the NUI module event for this window only.
// * See nw_inc_nui.nss for full documentation.
// Returns the window token on success (>0), or 0 on error.
int NuiCreate(object oPlayer, json jNui, string sWindowId = "", string sEventScript = "");

// You can look up windows by ID, if you gave them one.
// * Windows with a ID present are singletons - attempting to open a second one with the same ID
//   will fail, even if the json definition is different.
// Returns the token if found, or 0.
int NuiFindWindow(object oPlayer, string sId);

// Destroys the given window, by token, immediately closing it on the client.
// Does nothing if nUiToken does not exist on the client.
// Does not send a close event - this immediately destroys all serverside state.
// The client will close the window asynchronously.
void NuiDestroy(object oPlayer, int nUiToken);

// Returns the originating player of the current event.
object NuiGetEventPlayer();

// Gets the window token of the current event (or 0 if not in a event).
int NuiGetEventWindow();

// Returns the event type of the current event.
// * See nw_inc_nui.nss for full documentation of all events.
string NuiGetEventType();

// Returns the ID of the widget that triggered the event.
string NuiGetEventElement();

// Get the array index of the current event.
// This can be used to get the index into an array, for example when rendering lists of buttons.
// Returns -1 if the event is not originating from within an array.
int NuiGetEventArrayIndex();

// Returns the window ID of the window described by nUiToken.
// Returns "" on error, or if the window has no ID.
string NuiGetWindowId(object oPlayer, int nUiToken);

// Gets the json value for the given player, token and bind.
// * json values can hold all kinds of values; but NUI widgets require specific bind types.
//   It is up to you to either handle this in NWScript, or just set compatible bind types.
//   No auto-conversion happens.
// Returns a json null value if the bind does not exist.
json NuiGetBind(object oPlayer, int nUiToken, string sBindName);

// Sets a json value for the given player, token and bind.
// The value is synced down to the client and can be used in UI binding.
// When the UI changes the value, it is returned to the server and can be retrieved via NuiGetBind().
// * json values can hold all kinds of values; but NUI widgets require specific bind types.
//   It is up to you to either handle this in NWScript, or just set compatible bind types.
//   No auto-conversion happens.
// * If the bind is on the watch list, this will immediately invoke the event handler with the "watch"
//   even type; even before this function returns. Do not update watched binds from within the watch handler
//   unless you enjoy stack overflows.
// Does nothing if the given player+token is invalid.
void NuiSetBind(object oPlayer, int nUiToken, string sBindName, json jValue);

// Swaps out the given element (by id) with the given nui layout (partial).
// * This currently only works with the "group" element type, and the special "_window_" root group.
void NuiSetGroupLayout(object oPlayer, int nUiToken, string sElement, json jNui);

// Mark the given bind name as watched.
// A watched bind will invoke the NUI script event every time it's value changes.
// Be careful with binding nui data inside a watch event handler: It's easy to accidentally recurse yourself into a stack overflow.
int NuiSetBindWatch(object oPlayer, int nUiToken, string sBind, int bWatch);

// Returns the nNth window token of the player, or 0.
// nNth starts at 0.
// Iterator is not write-safe: Calling DestroyWindow() will invalidate move following offsets by one.
int NuiGetNthWindow(object oPlayer, int nNth = 0);

// Return the nNth bind name of the given window, or "".
// If bWatched is TRUE, iterates only watched binds.
// If FALSE, iterates all known binds on the window (either set locally or in UI).
string NuiGetNthBind(object oPlayer, int nToken, int bWatched, int nNth = 0);

// Returns the event payload, specific to the event.
// Returns JsonNull if event has no payload.
json NuiGetEventPayload();

// Get the userdata of the given window token.
// Returns JsonNull if the window does not exist on the given player, or has no userdata set.
json NuiGetUserData(object oPlayer, int nToken);

// Sets an arbitrary json value as userdata on the given window token.
// This userdata is not read or handled by the game engine and not sent to clients.
// This mechanism only exists as a convenience for the programmer to store data bound to a windows' lifecycle.
// Will do nothing if the window does not exist.
void NuiSetUserData(object oPlayer, int nToken, json jUserData);

// Returns the number of script instructions remaining for the currently-running script.
// Once this value hits zero, the script will abort with TOO MANY INSTRUCTIONS.
// The instruction limit is configurable by the user, so if you have a really long-running
// process, this value can guide you with splitting it up into smaller, discretely schedulable parts.
// Note: Running this command and checking/handling the value also takes up some instructions.
int GetScriptInstructionsRemaining();

// Returns a modified copy of jArray with the value order changed according to nTransform:
// * JSON_ARRAY_SORT_ASCENDING, JSON_ARRAY_SORT_DESCENDING
//    Sorting is dependent on the type and follows json standards (.e.g. 99 < "100").
// * JSON_ARRAY_SHUFFLE
//   Randomises the order of elements.
// * JSON_ARRAY_REVERSE
//   Reverses the array.
// * JSON_ARRAY_UNIQUE
//   Returns a modified copy of jArray with duplicate values removed.
//   Coercable but different types are not considered equal (e.g. 99 != "99"); int/float equivalence however applies: 4.0 == 4.
//   Order is preserved.
// * JSON_ARRAY_COALESCE
//   Returns the first non-null entry. Empty-ish values (e.g. "", 0) are not considered null, only the json scalar type.
json JsonArrayTransform(json jArray, int nTransform);

// Returns the nth-matching index or key of jNeedle in jHaystack.
// Supported haystacks: object, array
// Ordering behaviour for objects is unspecified.
// Return null when not found or on any error.
json JsonFind(json jHaystack, json jNeedle, int nNth = 0, int nConditional = JSON_FIND_EQUAL);

// Returns a copy of the range (nBeginIndex, nEndIndex) inclusive of jArray.
// Negative nEndIndex values count from the other end.
// Out-of-bound values are clamped to the array range.
// Examples:
//  json a = JsonParse("[0, 1, 2, 3, 4]");
//  JsonArrayGetRange(a, 0, 1)    // => [0, 1]
//  JsonArrayGetRange(a, 1, -1)   // => [1, 2, 3, 4]
//  JsonArrayGetRange(a, 0, 4)    // => [0, 1, 2, 3, 4]
//  JsonArrayGetRange(a, 0, 999)  // => [0, 1, 2, 3, 4]
//  JsonArrayGetRange(a, 1, 0)    // => []
//  JsonArrayGetRange(a, 1, 1)    // => [1]
// Returns a null type on error, including type mismatches.
json JsonArrayGetRange(json jArray, int nBeginIndex, int nEndIndex);

// Returns the result of a set operation on two arrays.
// Operations:
// * JSON_SET_SUBSET (v <= o):
//   Returns true if every element in jValue is also in jOther.
// * JSON_SET_UNION (v | o):
//   Returns a new array containing values from both sides.
// * JSON_SET_INTERSECT (v & o):
//   Returns a new array containing only values common to both sides.
// * JSON_SET_DIFFERENCE (v - o):
//   Returns a new array containing only values not in jOther.
// * JSON_SET_SYMMETRIC_DIFFERENCE (v ^ o):
//   Returns a new array containing all elements present in either array, but not both.
json JsonSetOp(json jValue, int nOp, json jOther);

// Returns the column name of s2DA at nColumn index (starting at 0).
// Returns "" if column nColumn doesn't exist (at end).
string Get2DAColumn(string s2DA, int nColumnIdx);

// Returns the number of defined rows in the 2da s2DA.
int Get2DARowCount(string s2DA);

// Set the subtype of eEffect to Unyielding and return eEffect.
// (Effects default to magical if the subtype is not set)
// Unyielding effects are not removed by resting, death or dispel magic, only by RemoveEffect().
// Note: effects that modify state, Stunned/Knockdown/Deaf etc, WILL be removed on death.
effect UnyieldingEffect(effect eEffect);

// Set eEffect to ignore immunities and return eEffect.
effect IgnoreEffectImmunity(effect eEffect);

// Sets the global shader uniform for the player to the specified float.
// These uniforms are not used by the base game and are reserved for module-specific scripting.
// You need to add custom shaders that will make use of them.
// In multiplayer, these need to be reapplied when a player rejoins.
// - nShader: SHADER_UNIFORM_*
void SetShaderUniformFloat(object oPlayer, int nShader, float fValue);

// Sets the global shader uniform for the player to the specified integer.
// These uniforms are not used by the base game and are reserved for module-specific scripting.
// You need to add custom shaders that will make use of them.
// In multiplayer, these need to be reapplied when a player rejoins.
// - nShader: SHADER_UNIFORM_*
void SetShaderUniformInt(object oPlayer, int nShader, int nValue);

// Sets the global shader uniform for the player to the specified vec4.
// These uniforms are not used by the base game and are reserved for module-specific scripting.
// You need to add custom shaders that will make use of them.
// In multiplayer, these need to be reapplied when a player rejoins.
// - nShader: SHADER_UNIFORM_*
void SetShaderUniformVec(object oPlayer, int nShader, float fX, float fY, float fZ, float fW);

// Sets the spell targeting data manually for the player. This data is usually specified in spells.2da.
// This data persists through spell casts; you're overwriting the entry in spells.2da for this session.
// In multiplayer, these need to be reapplied when a player rejoins.
// - nSpell: SPELL_*
// - nShape: SPELL_TARGETING_SHAPE_*
// - nFlags: SPELL_TARGETING_FLAGS_*
void SetSpellTargetingData(object oPlayer, int nSpell, int nShape, float fSizeX, float fSizeY, int nFlags);

// Sets the spell targeting data which is used for the next call to EnterTargetingMode() for this player.
// If the shape is set to SPELL_TARGETING_SHAPE_NONE and the range is provided, the dotted line range indicator will still appear.
// - nShape: SPELL_TARGETING_SHAPE_*
// - nFlags: SPELL_TARGETING_FLAGS_*
// - nSpell: SPELL_* (optional, passed to the shader but does nothing by default, you need to edit the shader to use it)
// - nFeat: FEAT_* (optional, passed to the shader but does nothing by default, you need to edit the shader to use it)
void SetEnterTargetingModeData(object oPlayer, int nShape, float fSizeX, float fSizeY, int nFlags, float fRange = 0.0f, int nSpell = -1, int nFeat = -1);

// Gets the number of memorized spell slots for a given spell level.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellLevel: the spell level, 0-9.
// Returns: the number of spell slots.
int GetMemorizedSpellCountByLevel(object oCreature, int nClassType, int nSpellLevel);

// Gets the spell id of a memorized spell slot.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellLevel: the spell level, 0-9.
// - nIndex: the index of the spell slot. Bounds: 0 <= nIndex < GetMemorizedSpellCountByLevel()
// Returns: a SPELL_* constant or -1 if the slot is not set.
int GetMemorizedSpellId(object oCreature, int nClassType, int nSpellLevel, int nIndex);

// Gets the ready state of a memorized spell slot.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellLevel: the spell level, 0-9.
// - nIndex: the index of the spell slot. Bounds: 0 <= nIndex < GetMemorizedSpellCountByLevel()
// Returns: TRUE/FALSE or -1 if the slot is not set.
int GetMemorizedSpellReady(object oCreature, int nClassType, int nSpellLevel, int nIndex);

// Gets the metamagic of a memorized spell slot.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellLevel: the spell level, 0-9.
// - nIndex: the index of the spell slot. Bounds: 0 <= nIndex < GetMemorizedSpellCountByLevel()
// Returns: a METAMAGIC_* constant or -1 if the slot is not set.
int GetMemorizedSpellMetaMagic(object oCreature, int nClassType, int nSpellLevel, int nIndex);

// Gets if the memorized spell slot has a domain spell.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellLevel: the spell level, 0-9.
// - nIndex: the index of the spell slot. Bounds: 0 <= nIndex < GetMemorizedSpellCountByLevel()
// Returns: TRUE/FALSE or -1 if the slot is not set.
int GetMemorizedSpellIsDomainSpell(object oCreature, int nClassType, int nSpellLevel, int nIndex);

// Set a memorized spell slot.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellLevel: the spell level, 0-9.
// - nIndex: the index of the spell slot. Bounds: 0 <= nIndex < GetMemorizedSpellCountByLevel()
// - nSpellId: a SPELL_* constant.
// - bReady: TRUE to mark the slot ready.
// - nMetaMagic: a METAMAGIC_* constant.
// - bIsDomainSpell: TRUE for a domain spell.
void SetMemorizedSpell(object oCreature, int nClassType, int nSpellLevel, int nIndex, int nSpellId, int bReady = TRUE, int nMetaMagic = METAMAGIC_NONE, int bIsDomainSpell = FALSE);

// Set the ready state of a memorized spell slot.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellLevel: the spell level, 0-9.
// - nIndex: the index of the spell slot. Bounds: 0 <= nIndex < GetMemorizedSpellCountByLevel()
// - bReady: TRUE to mark the slot ready.
void SetMemorizedSpellReady(object oCreature, int nClassType, int nSpellLevel, int nIndex, int bReady);

// Clear a specific memorized spell slot.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellLevel: the spell level, 0-9.
// - nIndex: the index of the spell slot. Bounds: 0 <= nIndex < GetMemorizedSpellCountByLevel()
void ClearMemorizedSpell(object oCreature, int nClassType, int nSpellLevel, int nIndex);

// Clear all memorized spell slots of a specific spell id, including metamagic'd ones.
// - nClassType: a CLASS_TYPE_* constant. Must be a MemorizesSpells class.
// - nSpellId: a SPELL_* constant.
void ClearMemorizedSpellBySpellId(object oCreature, int nClassType, int nSpellId);

// Gets the number of known spells for a given spell level.
// - nClassType: a CLASS_TYPE_* constant. Must be a SpellBookRestricted class.
// - nSpellLevel: the spell level, 0-9.
// Returns: the number of known spells.
int GetKnownSpellCount(object oCreature, int nClassType, int nSpellLevel);

// Gets the spell id of a known spell.
// - nClassType: a CLASS_TYPE_* constant. Must be a SpellBookRestricted class.
// - nSpellLevel: the spell level, 0-9.
// - nIndex: the index of the known spell. Bounds: 0 <= nIndex < GetKnownSpellCount()
// Returns: a SPELL_* constant or -1 on error.
int GetKnownSpellId(object oCreature, int nClassType, int nSpellLevel, int nIndex);

// Gets if a spell is in the known spell list.
// - nClassType: a CLASS_TYPE_* constant. Must be a SpellBookRestricted class.
// - nSpellId: a SPELL_* constant.
// Returns: TRUE if the spell is in the known spell list.
int GetIsInKnownSpellList(object oCreature, int nClassType, int nSpellId);

// Gets the amount of uses a spell has left.
// - nClassType: a CLASS_TYPE_* constant.
// - nSpellid: a SPELL_* constant.
// - nMetaMagic: a METAMAGIC_* constant.
// - nDomainLevel: the domain level, if a domain spell.
// Returns: the amount of spell uses left.
int GetSpellUsesLeft(object oCreature, int nClassType, int nSpellId, int nMetaMagic = METAMAGIC_NONE, int nDomainLevel = 0);

// Gets the spell level at which a class gets a spell.
// - nClassType: a CLASS_TYPE_* constant.
// - nSpellId: a SPELL_* constant.
// Returns: the spell level or -1 if the class does not get the spell.
int GetSpellLevelByClass(int nClassType, int nSpellId);

// Replaces oObject's animation sOld with sNew.
// Specifying sNew = "" will restore the original animation.
void ReplaceObjectAnimation(object oObject, string sOld, string sNew = "");

// Sets the distance (in meters) at which oObject info will be sent to clients (default 45.0)
// This is still subject to other limitations, such as perception ranges for creatures
// Note: Increasing visibility ranges of many objects can have a severe negative effect on
//       network latency and server performance, and rendering additional objects will
//       impact graphics performance of clients. Use cautiously.
void SetObjectVisibleDistance(object oObject, float fDistance=45.0f);

// Gets oObject's visible distance, as set by SetObjectVisibleDistance()
// Returns -1.0f on error
float GetObjectVisibleDistance(object oObject);

// Sets the active game pause state - same as if the player requested pause.
void SetGameActivePause(int bState);

// Returns >0 if the game is currently paused:
// - 0: Game is not paused.
// - 1: Timestop
// - 2: Active Player Pause (optionally on top of timestop)
int GetGamePauseState();

// Set the gender of oCreature.
// - nGender: a GENDER_* constant.
void SetGender(object oCreature, int nGender);

// Get the soundset of oCreature.
// Returns -1 on error.
int GetSoundset(object oCreature);

// Set the soundset of oCreature, see soundset.2da for possible values.
void SetSoundset(object oCreature, int nSoundset);

// Ready a spell level for oCreature.
// - nSpellLevel: 0-9
// - nClassType: a CLASS_TYPE_* constant or CLASS_TYPE_INVALID to ready the spell level for all classes.
// - nSlotsToReady: The amount of spells to set to ready at the given spell level. 0 will clear all uses, negative numbers will
//                  reduce the amount, positive increase the amount.
void ReadySpellLevel(object oCreature, int nSpellLevel, int nClassType = CLASS_TYPE_INVALID, int nSlotsToReady = 255);

// Makes oCreature controllable by oPlayer, if player party control is enabled
// Setting oPlayer=OBJECT_INVALID removes the override and reverts to regular party control behavior
// NB: A creature is only controllable by one player, so if you set oPlayer to a non-Player object
//    (e.g. the module) it will disable regular party control for this creature
void SetCommandingPlayer(object oCreature, object oPlayer);

// Sets oPlayer's camera limits that override any client configuration limits
// Value of -1.0 means use the client config instead
// NB: Like all other camera settings, this is not saved when saving the game
void SetCameraLimits(object oPlayer, float fMinPitch = -1.0, float fMaxPitch = -1.0, float fMinDist = -1.0, float fMaxDist = -1.0);

// Applies sRegExp on sValue, returning an array containing all matching groups.
// * The regexp is not bounded by default (so /t/ will match "test").
// * A matching result with always return a JSON_ARRAY with the full match as the first element.
// * All matching groups will be returned as additional elements, depth-first.
// * A non-matching result will return a empty JSON_ARRAY.
// * If there was an error, the function will return JSON_NULL, with a error string filled in.
// * nSyntaxFlags is a mask of REGEXP_*
// * nMatchFlags is a mask of REGEXP_MATCH_* and REGEXP_FORMAT_*.
// Examples:
// * RegExpMatch("[", "test value")             -> null (error: "The expression contained mismatched [ and ].")
// * RegExpMatch("nothing", "test value")       -> []
// * RegExpMatch("^test", "test value")         -> ["test"]
// * RegExpMatch("^(test) (.+)$", "test value") -> ["test value", "test", "value"]
json RegExpMatch(string sRegExp, string sValue, int nSyntaxFlags = REGEXP_ECMASCRIPT, int nMatchFlags = REGEXP_FORMAT_DEFAULT);

// Iterates sValue with sRegExp.
// * Returns an array of arrays; where each sub-array contains first the full match and then all matched groups.
// * Returns empty JSON_ARRAY if no matches are found.
// * If there was an error, the function will return JSON_NULL, with a error string filled in.
// * nSyntaxFlags is a mask of REGEXP_*
// * nMatchFlags is a mask of REGEXP_MATCH_* and REGEXP_FORMAT_*.
// Example: RegExpIterate("(\\d)(\\S+)", "1i 2am 3 4asentence"); -> [["1i", "1", "i"], ["2am", "2", "am"], ["4sentence", "4", "sentence"]]
json RegExpIterate(string sRegExp, string sValue, int nSyntaxFlags = REGEXP_ECMASCRIPT, int nMatchFlags = REGEXP_FORMAT_DEFAULT);

// Replaces all matching sRegExp in sValue with sReplacement.
// * Returns a empty string on error.
// * Please see the format documentation for replacement patterns.
// * nSyntaxFlags is a mask of REGEXP_*
// * nMatchFlags is a mask of REGEXP_MATCH_* and REGEXP_FORMAT_*.
// * FORMAT_DEFAULT replacement patterns:
//    $$    $
//    $&    The matched substring.
//    $`    The portion of string that precedes the matched substring.
//    $'    The portion of string that follows the matched substring.
//    $n    The nth capture, where n is a single digit in the range 1 to 9 and $n is not followed by a decimal digit.
//    $nn   The nnth capture, where nn is a two-digit decimal number in the range 01 to 99.
// Example: RegExpReplace("a+", "vaaalue", "[$&]")    => "v[aaa]lue"
string RegExpReplace(string sRegExp, string sValue, string sReplacement, int nSyntaxFlags = REGEXP_ECMASCRIPT, int nMatchFlags = REGEXP_FORMAT_DEFAULT);

// Get the contents of a file as string, as seen by the server's resman.
// Note: If the output contains binary data it will only return data up to the first null byte.
// - nResType: a RESTYPE_* constant.
// - nFormat: one of RESMAN_FILE_CONTENTS_FORMAT_*
// Returns "" if the file does not exist.
string ResManGetFileContents(string sResRef, int nResType, int nFormat = RESMAN_FILE_CONTENTS_FORMAT_RAW);

// Compile a script and place it in the server's CURRENTGAME: folder.
// Note: Scripts will persist for as long as the module is running.
// SinglePlayer / Saves: Scripts that overwrite existing module scripts will persist to the save file.
//                       New scripts, unknown to the module, will have to be re-compiled on module load when loading a save.
// Returns "" on success or the error on failure.
string CompileScript(string sScriptName, string sScriptData, int bWrapIntoMain = FALSE, int bGenerateNDB = FALSE);

// Sets the object oPlayer's camera will be attached to.
// - oTarget: A valid creature or placeable. If oTarget is OBJECT_INVALID, it will revert the camera back to oPlayer's character.
//            The target must be known to oPlayer's client, this means it must be in the same area and within visible distance.
//              - SetObjectVisibleDistance() can be used to increase this range.
//              - If the target is a creature, it also must be within the perception range of oPlayer and perceived.
// - bFindClearView: if TRUE, the client will attempt to find a camera position where oTarget is in view.
// Notes:
//       - If oTarget gets destroyed while oPlayer's camera is attached to it, the camera will revert back to oPlayer's character.
//       - If oPlayer goes through a transition with its camera attached to a different object, it will revert back to oPlayer's character.
//       - The object the player's camera is attached to is not saved when saving the game.
void AttachCamera(object oPlayer, object oTarget, int bFindClearView = FALSE);

// Get the current discoverability mask of oObject.
// Returns -1 if oObject cannot have a discovery mask.
int GetObjectUiDiscoveryMask(object oObject);

// Sets the discoverability mask on oObject.
// This allows toggling areahilite (TAB key by default) and mouseover discovery in the area view.
// * nMask is a bitmask of OBJECT_UI_DISCOVERY_*
// Will currently only work on Creatures, Doors (Hilite only), Items and Useable Placeables.
// Does not affect inventory items.
void SetObjectUiDiscoveryMask(object oObject, int nMask = OBJECT_UI_DISCOVERY_DEFAULT);

// Sets a text override for the mouseover/tab-highlight text bubble of oObject.
// Will currently only work on Creatures, Items and Useable Placeables.
// * nMode is one of OBJECT_UI_TEXT_BUBBLE_OVERRIDE_*.
void SetObjectTextBubbleOverride(object oObject, int nMode, string sText);

// Immediately unsets a VTs for the given object, with no lerp.
// * nScope: one of OBJECT_VISUAL_TRANSFORM_DATA_SCOPE_, or -1 for all scopes
// Returns TRUE only if transforms were successfully removed (valid object, transforms existed).
int ClearObjectVisualTransform(object oObject, int nScope = -1);

// Gets an optional vecror of specific gui events in the module OnPlayerGuiEvent event.
// GUIEVENT_RADIAL_OPEN - World vector position of radial if on tile.
vector GetLastGuiEventVector();

// Sets oPlayer's camera settings that override any client configuration settings
// nFlags is a bitmask of CAMERA_FLAG_* constants;
// NB: Like all other camera settings, this is not saved when saving the game
void SetCameraFlags(object oPlayer, int nFlags=0);

// Gets the light color in the area specified.
// nColorType specifies the color type returned.
//    Valid values for nColorType are the AREA_LIGHT_COLOR_* values.
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
int GetAreaLightColor(int nColorType, object oArea=OBJECT_INVALID);

// Sets the light color in the area specified.
// nColorType = AREA_LIGHT_COLOR_* specifies the color type.
// nColor = FOG_COLOR_* specifies the color the fog is being set to.
// The color can also be represented as a hex RGB number if specific color shades
// are desired.
// The format of a hex specified color would be 0xFFEEDD where
// FF would represent the amount of red in the color
// EE would represent the amount of green in the color
// DD would represent the amount of blue in the color.
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
// If fFadeTime is above 0.0, it will fade to the new color in the amount of seconds specified. 
void SetAreaLightColor(int nColorType, int nColor, object oArea=OBJECT_INVALID, float fFadeTime = 0.0);

// Gets the light direction of origin in the area specified.
// nLightType specifies whether the Moon or Sun light direction is returned.
//    Valid values for nColorType are the AREA_LIGHT_DIRECTION_* values.
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
vector GetAreaLightDirection(int nLightType, object oArea=OBJECT_INVALID);

// Sets the light direction of origin in the area specified.
// nLightType = AREA_LIGHT_DIRECTION_* specifies the light type.
// vDirection = specifies the direction of origin of the light type, i.e. the direction the sun/moon is in from the area.
// If no valid area (or object) is specified, it uses the area of caller.
// If an object other than an area is specified, will use the area that the object is currently in.
// If fFadeTime is above 0.0, it will fade to the new color in the amount of seconds specified. 
void SetAreaLightDirection(int nLightType, vector vDirection, object oArea=OBJECT_INVALID, float fFadeTime = 0.0);

// This immediately aborts the running script.
// - Will not emit an error to the server log by default.
// - You can specify the optional sError to emit as a script error, which will be printed
//   to the log and sent to all players, just like any other script error.
// - Will not terminate other script recursion (e.g. nested ExecuteScript()) will resume as if the
//   called script exited cleanly.
// - This call will never return.
void AbortRunningScript(string sError = "");

// Generate a VM debug view into the current execution location.
// - Names and symbols can only be resolved if debug information is available (NDB file).
// - This call can be a slow call for large scripts.
// - Setting bIncludeStack = TRUE will include stack info in the output, which could be a
//   lot of data for large scripts. You can turn it off if you do not need the info.
// Returned data format (JSON object):
//   "frames": array of stack frames:
//     "ip": instruction pointer into code
//     "bp", "sp": current base/stack pointer
//     "file", "line", "function": available only if NDB loaded correctly
//   "stack": abbreviated stack data (only if bIncludeStack is TRUE)
//     "type": one of the nwscript object types, OR:
//     "type_unknown": hex code of AUX
//     "data": type-specific payload. Not all type info is rendered in the interest of brevity.
//             Only enough for you to re-identify which variable this might belong to.
json GetScriptBacktrace(int bIncludeStack = TRUE);

// Mark the current location in code as a jump target, identified by sLabel.
// - Returns 0 on initial invocation, but will return nRetVal if jumped-to by LongJmp.
// - sLabel can be any valid string (including empty); though it is recommended to pick
//   something distinct. The responsibility of namespacing lies with you.
// - Calling repeatedly with the same label will overwrite the previous jump location.
//   If you want to nest them, you need to manage nesting state externally.
int SetJmp(string sLabel);

// Jump execution back in time to the point where you called SetJmp with the same label.
// - This function is a GREAT way to get really hard-to-debug stack under/overflows.
// - Will not work across script runs or script recursion; only within the same script.
//   (However, it WILL work across includes - those go into the same script data in compilation)
// - Will throw a script error if sLabel does not exist.
// - Will throw a script error if no valid jump destination exists.
// - You CAN jump to locations with compatible stack layout, including sibling functions.
//   For the script to successfully finish, the entire stack needs to be correct (either in code or
//   by jumping elsewhere again). Making sure this is the case is YOUR responsibility.
// - The parameter nRetVal is passed to SetJmp, resuming script execution as if SetJmp returned
//   that value (instead of 0).
//   If you accidentally pass 0 as nRetVal, it will be silently rewritten to 1.
//   Any other integer value is valid, including negative ones.
// - This call will never return.
void LongJmp(string sLabel, int nRetVal = 1);

// Returns TRUE if the given sLabel is a valid jump target at the current code location.
int GetIsValidJmp(string sLabel);

// Create a Pacified effect, making the creature unable to attack anyone
effect EffectPacified();

// Get the current script recursion level.
int GetScriptRecursionLevel();

// Get the name of the script at a script recursion level.
// - nRecursionLevel: Between 0 and <= GetScriptRecursionLevel() or -1 for the current recursion level.
// Returns the script name or "" on error.
string GetScriptName(int nRecursionLevel = -1);

// Get the script chunk attached to a script recursion level.
// - nRecursionLevel: Between 0 and <= GetScriptRecursionLevel() or -1 for the current recursion level.
// Returns the script chunk or "" on error / no script chunk attached.
string GetScriptChunk(int nRecursionLevel = -1);

// Returns the patch postfix of oPlayer (i.e. the 29 out of "87.8193.35-29 abcdef01").
// Returns 0 if the given object isn't a player or did not advertise their build info, or the
// player version is old enough not to send this bit of build info to the server.
int GetPlayerBuildVersionPostfix(object oPlayer);

// Returns the patch commit sha1 of oPlayer (i.e. the "abcdef01" out of "87.8193.35-29 abcdef01").
// Returns "" if the given object isn't a player or did not advertise their build info, or the
// player version is old enough not to send this bit of build info to the server.
string GetPlayerBuildVersionCommitSha1(object oPlayer);

// In the spell script returns the feat used, or -1 if no feat was used
// In an Area of Effect script returns the feat used to generate it (or -1 otherwise)
int GetSpellFeatId();

// Returns the given effects Link ID. There is no guarantees about this identifier other than
// it is unique and the same for all effects linked to it.
string GetEffectLinkId(effect eEffect);

// If oCreature has nFeat, and nFeat is useable, returns the number of remaining uses left
// or the maximum int value if the feat has unlimited uses (eg FEAT_KNOCKDOWN)
// - nFeat: FEAT_*
// - oCreature: Creature to check the feat of
int GetFeatRemainingUses(int nFeat, object oCreature=OBJECT_SELF);

// Change a tile in an area, it will also update the tile for all players in the area.
// * Notes:
//   - For optimal use you should be familiar with how tilesets / .set files work.
//   - Will not update the height of non-creature objects.
//   - Creatures may get stuck on non-walkable terrain.
//
// - locTile: The location of the tile.
// - nTileID: the ID of the tile, for values see the .set file of the tileset.
// - nOrientation: the orientation of the tile, 0-3.
//                 0 = Normal orientation
//                 1 = 90 degrees counterclockwise
//                 2 = 180 degrees counterclockwise
//                 3 = 270 degrees counterclockwise
// - nHeight: the height of the tile.
// - nFlags: a bitmask of SETTILE_FLAG_* constants.
//           - SETTILE_FLAG_RELOAD_GRASS: reloads the area's grass, use if your tile used to have grass or should have grass now.
//           - SETTILE_FLAG_RELOAD_BORDER: reloads the edge tile border, use if you changed a tile on the edge of the area.
//           - SETTILE_FLAG_RECOMPUTE_LIGHTING: recomputes the area's lighting and static shadows, use most of time.
void SetTile(location locTile, int nTileID, int nOrientation, int nHeight = 0, int nFlags = SETTILE_FLAG_RECOMPUTE_LIGHTING);

// Get the ID of the tile at location locTile.
// Returns -1 on error.
int GetTileID(location locTile);

// Get the orientation of the tile at location locTile.
// Returns -1 on error.
int GetTileOrientation(location locTile);

// Get the height of the tile at location locTile.
// Returns -1 on error.
int GetTileHeight(location locTile);

// All clients in oArea will reload the area's grass.
// This can be used to update the grass of an area after changing a tile with SetTile() that will have or used to have grass.
void ReloadAreaGrass(object oArea);

// Set the state of the tile animation loops of the tile at location locTile.
void SetTileAnimationLoops(location locTile, int bAnimLoop1, int bAnimLoop2, int bAnimLoop3);

// Change multiple tiles in an area, it will also update the tiles for all players in the area.
// Note: See SetTile() for additional information.
// - oArea: the area to change one or more tiles of.
// - jTileData: a JsonArray() with one or more JsonObject()s with the following keys:
//               - index: the index of the tile as a JsonInt()
//                        For example, a 3x3 area has the following tile indexes:
//                        6 7 8
//                        3 4 5
//                        0 1 2
//               - tileid: the ID of the tile as a JsonInt(), defaults to 0 if not set
//               - orientation: the orientation of the tile as JsonInt(), defaults to 0 if not set
//               - height: the height of the tile as JsonInt(), defaults to 0 if not set
//               - animloop1: the state of a tile animation, 1/0 as JsonInt(), defaults to the current value if not set
//               - animloop2: the state of a tile animation, 1/0 as JsonInt(), defaults to the current value if not set
//               - animloop3: the state of a tile animation, 1/0 as JsonInt(), defaults to the current value if not set
// - nFlags: a bitmask of SETTILE_FLAG_* constants.
// - sTileset: if not empty, it will also change the area's tileset
//             Warning: only use this if you really know what you're doing, it's very easy to break things badly.
//                      Make sure jTileData changes *all* tiles in the area and to a tile id that's supported by sTileset.
void SetTileJson(object oArea, json jTileData, int nFlags = SETTILE_FLAG_RECOMPUTE_LIGHTING, string sTileset = "");

// All clients in oArea will reload the inaccesible border tiles.
// This can be used to update the edge tiles after changing a tile with SetTile().
void ReloadAreaBorder(object oArea);

// Sets whether or not oCreatures's nIconId is flashing in their GUI icon bar.  If oCreature does not
// have an icon associated with nIconId, nothing happens. This function does not add icons to 
// oCreatures's GUI icon bar. The icon will flash until the underlying effect is removed or this 
// function is called again with bFlashing = FALSE.
// - oCreature: Player object to affect
// - nIconId: Referenced to effecticons.2da or EFFECT_ICON_*
// - bFlashing: TRUE to force an existing icon to flash, FALSE to to stop.
void SetEffectIconFlashing(object oCreature, int nIconId, int bFlashing = TRUE);

// Creates a bonus feat effect. These act like the Bonus Feat item property,
// and do not work as feat prerequisites for levelup purposes.
// - nFeat: FEAT_*
effect EffectBonusFeat(int nFeat);

// Returns the INVENTORY_SLOT_* constant of the last item equipped.  Can only be used in the
// module's OnPlayerEquip event.  Returns -1 on error.
int GetPCItemLastEquippedSlot();

// Returns the INVENTORY_SLOT_* constant of the last item unequipped.  Can only be used in the
// module's OnPlayerUnequip event.  Returns -1 on error.
int GetPCItemLastUnequippedSlot();

// Returns TRUE if the last spell was cast spontaneously
// eg; a Cleric casting SPELL_CURE_LIGHT_WOUNDS when it is not prepared, using another level 1 slot
// Area of Effect objects can also retrieve if the spell used to generate it was casted spontaneously.
int GetSpellCastSpontaneously();

// Reset the given sqlquery, readying it for re-execution after it has been stepped.
// All existing binds are kept untouched, unless bClearBinds is TRUE.
// This command only works on successfully-prepared queries that have not errored out.
void SqlResetQuery(sqlquery sqlQuery, int bClearBinds = FALSE);

// Provides immunity to the effects of EffectTimeStop which allows actions during other creatures time stop effects
effect EffectTimeStopImmunity();

// Return the current game tick rate (mainloop iterations per second).
// This is equivalent to graphics frames per second when the module is running inside a client.
int GetTickRate();

// Returns the level of the last spell cast. This value is only valid in a Spell script.
int GetLastSpellLevel();

// Returns the 32bit integer hash of sString
// This hash is stable and will always have the same value for same input string, regardless of platform.
// The hash algorithm is the same as the one used internally for strings in case statements, so you can do:
//    switch (HashString(sString))
//    {
//         case "AAA":    HandleAAA(); break;
//         case "BBB":    HandleBBB(); break;
//    }
// NOTE: The exact algorithm used is XXH32(sString) ^ XXH32(""). This means that HashString("") is 0.
int HashString(string sString);

// Returns the current microsecond counter value. This value is meaningless on its own, but can be subtracted
// from other values returned by this function in the same script to get high resolution elapsed time:
//     int nMicrosecondsStart = GetMicrosecondCounter();
//     DoSomething();
//     int nElapsedMicroseconds = GetMicrosecondCounter() - nMicrosecondsStart;
int GetMicrosecondCounter();

// Forces the creature to always walk
effect EffectForceWalk();

// Assign one of the available audio streams to play a specific file. This mechanism can be used
// to replace regular music playback, and synchronize it between clients.
// * There is currently no way to get playback state from clients.
// * Audio streams play in the streams channel which has its own volume setting in the client.
// * nStreamIdentifier is one of AUDIOSTREAM_IDENTIFIER_*.
// * Currently, only MP3 CBR files are supported and properly seekable.
// * Unlike regular music, audio streams do not pause on load screens.
// * If fSeekOffset is at or beyond the end of the stream, the seek offset will wrap around, even if the file is configured not to loop.
// * fFadeTime is in seconds to gradually fade in the audio instead of starting directly.
// * Only one type of fading can be active at once, for example:
//   If you call StartAudioStream() with fFadeTime = 10.0f, any other audio stream functions with a fade time >0.0f will have no effect
//   until StartAudioStream() is done fading.
void StartAudioStream(object oPlayer, int nStreamIdentifier, string sResRef, int bLooping = FALSE, float fFadeTime = 0.0f, float fSeekOffset = -1.0f, float fVolume = 1.0f);

// Stops the given audio stream.
// * fFadeTime is in seconds to gradually fade out the audio instead of stopping directly.
// * Only one type of fading can be active at once, for example:
//   If you call StartAudioStream() with fFadeInTime = 10.0f, any other audio stream functions with a fade time >0.0f will have no effect
//   until StartAudioStream() is done fading.
// * Will do nothing if the stream is currently not in use.
void StopAudioStream(object oPlayer, int nStreamIdentifier, float fFadeTime = 0.0);

// Un/pauses the given audio stream.
// * fFadeTime is in seconds to gradually fade the audio out/in instead of pausing/resuming directly.
// * Only one type of fading can be active at once, for example:
//   If you call StartAudioStream() with fFadeInTime = 10.0f, any other audio stream functions with a fade time >0.0f will have no effect
//   until StartAudioStream() is done fading.
// * Will do nothing if the stream is currently not in use.
void SetAudioStreamPaused(object oPlayer, int nStreamIdentifier, int bPaused, float fFadeTime = 0.0f);

// Change volume of audio stream.
// * Volume is from 0.0 to 1.0.
// * fFadeTime is in seconds to gradually change the volume.
// * Only one type of fading can be active at once, for example:
//   If you call StartAudioStream() with fFadeInTime = 10.0f, any other audio stream functions with a fade time >0.0f will have no effect
//   until StartAudioStream() is done fading.
// * Subsequent calls to this function with fFadeTime >0.0f while already fading the volume
//   will start the new fade with the previous' fade's progress as starting point.
// * Will do nothing if the stream is currently not in use.
void SetAudioStreamVolume(object oPlayer, int nStreamIdentifier, float fVolume = 1.0, float fFadeTime = 0.0f);

// Seek the audio stream to the given offset.
// * When seeking at or beyond the end of a stream, the seek offset will wrap around, even if the file is configured not to loop.
// * Will do nothing if the stream is currently not in use.
// * Will do nothing if the stream is in ended state (reached end of file and looping is off). In this
//   case, you need to restart the stream.
void SeekAudioStream(object oPlayer, int nStreamIdentifier, float fSeconds);

// Sets the effect creator
// - oCreator: The creator of the effect. Can be OBJECT_INVALID.
effect SetEffectCreator(effect eEffect, object oCreator);

// Sets the effect caster level
// - nCasterLevel: The caster level of the effect for the purposes of dispel magic and GetEffectCasterlevel. Must be >= 0.
effect SetEffectCasterLevel(effect eEffect, int nCasterLevel);

// Sets the effect spell id
// - nSpellId: The spell id for the purposes of effect stacking, dispel magic and GetEffectSpellId. Must be >= -1 (-1 being invalid/no spell)
effect SetEffectSpellId(effect eEffect, int nSpellId);

// Retrieve the column count of a prepared query.  
// * sqlQuery must be prepared before this function is called, but can be called before or after parameters are bound.
// * If the prepared query contains no columns (such as with an UPDATE or INSERT query), 0 is returned.
// * If a non-SELECT query contains a RETURNING clause, the number of columns in the RETURNING clause will be returned.
// * A returned value greater than 0 does not guarantee the query will return rows.
int SqlGetColumnCount(sqlquery sqlQuery);

// Retrieve the column name of the Nth column of a prepared query.
// * sqlQuery must be prepared before this function is called, but can be called before or after parameters are bound.
// * If the prepared query contains no columns (such as with an UPDATE or INSERT query), an empty string is returned.
// * If a non-SELECT query contains a RETURNING clause, the name of the nNth column in the RETURNING clause is returned.
// * If nNth is out of range, an sqlite error is broadcast and an empty string is returned.
// * The value of the AS clause will be returned, if the clause exists for the nNth column.
// * A returned non-empty string does not guarantee the query will return rows.
string SqlGetColumnName(sqlquery sqlQuery, int nNth);

// Gets the total number of spell abilities a creature has.
int GetSpellAbilityCount(object oCreature);

// Gets the spell Id of the spell ability at the given index.
// - nIndex: the index of the spell ability. Bounds: 0 <= nIndex < GetSpellAbilityCount()
// Returns: a SPELL_* constant or -1 if the slot is not set.
int GetSpellAbilitySpell(object oCreature, int nIndex);

// Gets the caster level of the spell ability in the given slot. Returns 0 by default.
// - nIndex: the index of the spell ability. Bounds: 0 <= nIndex < GetSpellAbilityCount()
// Returns: the caster level or -1 if the slot is not set.
int GetSpellAbilityCasterLevel(object oCreature, int nIndex);

// Gets the ready state of a spell ability.
// - nIndex: the index of the spell ability. Bounds: 0 <= nIndex < GetSpellAbilityCount()
// Returns: TRUE/FALSE or -1 if the slot is not set.
int GetSpellAbilityReady(object oCreature, int nIndex);

// Set the ready state of a spell ability slot.
// - nIndex: the index of the spell ability. Bounds: 0 <= nIndex < GetSpellAbilityCount()
// - bReady: TRUE to mark the slot ready.
void SetSpellAbilityReady(object oCreature, int nIndex, int bReady = TRUE);

// Serializes the given JSON structure (which must be a valid template spec) into a template.
// * The template will be stored in the TEMP: alias and currently NOT stored in savegames.
// * The stored template will override anything currently available in the module.
// * Supported GFF resource types are the same as TemplateToJson().
//   However, some types will not be read by the game (e.g. module.IFO is only read at module load).
// * Returns TRUE if the serialization was successful.
// * Any target file in TEMP: will be overwritten, even if the serialisation is not successful.
//   JsonToTemplate(JSON_NULL, ..) can be used to delete a previously-generated file.
int JsonToTemplate(json jTemplateSpec, string sResRef, int nResType);

// Modifies jObject in-place (with no memory copies of the full object).
// jObject will have the key at sKey set to jValue.
void JsonObjectSetInplace(json jObject, string sKey, json jValue);

// Modifies jObject in-place (with no memory copies needed).
// jObject will have the element at the key sKey removed.
// Will do nothing if jObject is not a object, or sKey does not exist on the object.
void JsonObjectDelInplace(json jObject, string sKey);

// Modifies jArray in-place (with no memory copies needed).
// jArray will have jValue inserted at position nIndex.
// All succeeding elements in the array will move by one.
// By default (-1), inserts elements at the end of the array ("push").
// nIndex = 0 inserts at the beginning of the array.
void JsonArrayInsertInplace(json jArray, json jValue, int nIndex = -1);

// Modifies jArray in-place (with no memory copies needed).
// jArray will have jValue set at position nIndex.
// Will do nothing if jArray is not an array or nIndex is out of range.
void JsonArraySetInplace(json jArray, int nIndex, json jValue);

// Modifies jArray in-place (with no memory copies needed).
// jArray will have the element at nIndex removed, and the array will be resized accordingly.
// Will do nothing if jArray is not an array or nIndex is out of range.
void JsonArrayDelInplace(json jArray, int nIndex);

// Sets a grass override for nMaterialId in oArea.
// * You can have multiple grass types per area by using different materials.
// * You can add grass to areas that normally do not have grass, for example by calling this on the
//   wood surface material(5) for an inn area.
//
//   - nMaterialId: a surface material, see surfacemat.2da. 3 is the default grass material.
//   - sTexture: the grass texture, cannot be empty.
//   - fDensity: the density of the grass.
//   - fHeight: the height of the grass.
//   - vAmbientColor: the ambient color of the grass, xyz as RGB clamped to 0.0-1.0f per value.
//   - vDiffuseColor: the diffuse color of the grass, xyz as RGB clamped to 0.0-1.0f per value.
void SetAreaGrassOverride(object oArea, int nMaterialId, string sTexture, float fDensity, float fHeight, vector vAmbientColor, vector vDiffuseColor);

// Remove a grass override from oArea for nMaterialId.
void RemoveAreaGrassOverride(object oArea, int nMaterialId);

// Set to TRUE to disable the default grass of oArea.
void SetAreaDefaultGrassDisabled(object oArea, int bDisabled);

// Gets the NoRest area flag.
// Returns TRUE if resting is not allowed in the area.
// Passing in OBJECT_INVALID to parameter oArea will result in operating on the area of the caller.
int GetAreaNoRestFlag(object oArea=OBJECT_INVALID);

// Sets the NoRest flag on an area.
// Passing in OBJECT_INVALID to parameter oArea will result in operating on the area of the caller.
void SetAreaNoRestFlag(int bNoRestFlag, object oArea=OBJECT_INVALID);

// Sets the age of oCreature.
void SetAge(object oCreature, int nAge);

// Gets the base number of attacks oCreature can make every round
// Excludes additional effects such as haste, slow, spells, circle kick, attack modes, etc.
// * bCheckOverridenValue - Checks for SetBaseAttackBonus() on the creature, if FALSE will return the non-overriden version
int GetAttacksPerRound(object oCreature, int bCheckOverridenValue = TRUE);

// Create an Enemy Attack Bonus effect. Creatures attacking the given creature with melee/ranged attacks or touch attacks get a bonus to hit.
effect EffectEnemyAttackBonus(int nBonus);

// Set to TRUE to disable the inaccessible tile border of oArea. Requires a client area reload to take effect.
void SetAreaTileBorderDisabled(object oArea, int bDisabled);

// Checks if a object is destroyable (toggle this state with SetIsDestroyable)
// Returns TRUE if they can be destroyed, FALSE otherwise or in error
int GetIsDestroyable(object oObject);

// Checks if a creature is able to be raised with EffectResurrection (toggle this state with SetIsDestroyable)
// Returns TRUE if they can be raised, FALSE otherwise or in error
int GetIsRaiseable(object oCreature);

// Checks if a creature is able to be selected when dead (toggle this state with SetIsDestroyable)
// Returns TRUE if they can be selected, FALSE otherwise or in error
int GetIsSelectableWhenDead(object oCreature);

// Check if NWNX is currently running.
// Returns TRUE if NWNX is available, FALSE if not.
int NWNXGetIsAvailable();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXCall(string sArg1, string sArg2);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushInt(int nValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushFloat(float fValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushObject(object oValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushString(string sValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushVector(vector vValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushLocation(location locValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushEffect(effect eValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushItemProperty(itemproperty ipValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushJson(json jValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushAction(action aValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushEvent(event eValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushTalent(talent tValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushSqlquery(sqlquery sqlValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
void NWNXPushCassowary(cassowary cValue);

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
int NWNXPopInt();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
float NWNXPopFloat();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
object NWNXPopObject();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
string NWNXPopString();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
vector NWNXPopVector();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
location NWNXPopLocation();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
effect NWNXPopEffect();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
itemproperty NWNXPopItemProperty();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
json NWNXPopJson();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
event NWNXPopEvent();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
talent NWNXPopTalent();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
sqlquery NWNXPopSqlquery();

// This is an internal function for NWNX, it will abort the script if called without NWNX running.
cassowary NWNXPopCassowary();

// Does a spell resistance check. The roll is 1d20 + nCasterLevel + nCasterBonus vs. nSpellResistance
// - nSpellId         - The spell ID to use if other variables are not set. If -1 it will attempt to be auto-detected.
// - nCasterLevel     - The caster level. If -1 it attempts to find it automatically from oCaster.
// - nSpellResistance - The spell resistance to penetrate. If -1 it will use the spell resistance of oTarget.
// - bFeedback        - If TRUE displays feedback automatically, FALSE it suppresses it.
// Returns: TRUE if the target resists oCasters spell resistance roll, FALSE if failed or an error occured
int SpellResistanceCheck(object oTarget, object oCaster, int nSpellId = -1, int nCasterLevel=-1, int nSpellResistance=-1, int bFeedback=TRUE);

// Does a spell immunity check. This checks for EFfectSpellImmunity and related item properties.
// - nSpellId  - The spell ID to check immunity of. If -1 it will attempt to be auto-detected.
// - bFeedback - If TRUE displays feedback automatically, FALSE it suppresses it.
// Returns: TRUE if the target is immune to nSpellId, FALSE if failed or an error occured
int SpellImmunityCheck(object oTarget, object oCaster, int nSpellId=-1, int bFeedback=TRUE);

// Does a spell absorption check that checks limited (eg Spell Mantle)
// - nSpellId      - The Spell Id. If -1 it will attempt to be auto-detected.
// - nSpellSchool  - The spell school to check for. If -1 uses nSpellId's spell school.
// - nSpellLevel   - The spell level. If -1 uses nSpellId's spell level (given the casters last spell cast class)
// - bRemoveLevels - If TRUE this removes spell levels from the effect that would stop it (and remove it if 0 or less remain), but if FALSE they will not be removed.
// - bFeedback     - If TRUE displays feedback automatically, FALSE it suppresses it.
// Returns: TRUE if the target absorbs oCasters spell, FALSE if failed or an error occured
int SpellAbsorptionLimitedCheck(object oTarget, object oCaster, int nSpellId=-1, int nSpellSchool=-1, int nSpellLevel=-1, int bRemoveLevels=TRUE, int bFeedback=TRUE);

// Does a spell absorption check that checks unlimited spell absorption effects (eg; Globes)
// - nSpellId     - The Spell Id. If -1 it will attempt to be auto-detected.
// - nSpellSchool - The spell school to check for. If -1 uses nSpellId's spell school.
// - nSpellLevel  - The spell level. If -1 uses nSpellId's spell level (given the casters last spell cast class)
// - bFeedback    - If TRUE displays feedback automatically, FALSE it suppresses it. As per existing ResistSpell convention it defaults to FALSE.
// Returns: TRUE if the target absorbs oCasters spell, FALSE if failed or an error occured
int SpellAbsorptionUnlimitedCheck(object oTarget, object oCaster, int nSpellId=-1, int nSpellSchool=-1, int nSpellLevel=-1, int bFeedback=FALSE);

// Returns the network latency of this player device.
// The value is a round trip time (server->player->server) in milliseconds.
// * Players are pinged every 6000 milliseconds.
// * When bSmoothed is TRUE, returns a moving average over a longer timeframe.
//   This average calculation is not strictly specified and subject to change,
//   but intended to provide a reasonable average to rely on.
// * When bSmoothed is FALSE, returns the current/last received value.
// * Returns 0 if the client failed to respond to latency requests or no data is available.
//   This is currently the case for clients that do not support this functionality (build <37).
int GetPlayerNetworkLatency(object oPlayer, int bSmoothed = TRUE);

// Gets the creature or placeable body bag type (bodybag.2da entry)
// Returns -1 on error.
int GetBodyBag(object oObject);

// Sets the creature or placeable body bag type (bodybag.2da entry)
void SetBodyBag(object oObject, int nBodyBag);
