
//::///////////////////////////////////////////////
//:: Horse Mounting and Control System
//:: x3_inc_horse
//:: Copyright (c) 2007-2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Holds horse specific functionality which can  be used
     in other scripts to support horses as present in patch 1.69.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Tweaking By: Martin "Azbest" Psikal
//:: Created On: Dec 14th, 2007
//:: Last Update: April 21th, 2008
//:: Help from community members: Proleric,
//:: The Krit, OldMansBeard, FriendlyFire,
//:: Bannor "JP" Bloodfist, Brian Chung,
//:: Craig Welburn, Barry_1066, Jahodnik,
//:: fluffyamoeba, Axe Murderer, and more.
//:: Thank you!
//:://////////////////////////////////////////////

#include "x0_i0_position"
#include "X0_INC_HENAI"
#include "x3_inc_skin"

/*

    HOW TO GET THE MOST FROM THIS HORSE SCRIPT:
    ===========================================

    This script has been setup to simply work with the default horses but, some
    effort was made to provide you with some simple methods to hook your own
    mounts, mounting scripts, etc. into this script.


    [HORSE BLUEPRINT VARIABLES]
    ===========================

    The following variables can be set on the BLUEPRINT of a creature to extend
    this mounting system.   These scripts could be used to add database
    functionality, or extend the system however, you like.

    bX3_IS_MOUNT = integer that should be set to 1 if this is a custom blueprint
    mount that for some reason the script indicates is not a mount.

    X3_HORSE_PREMOUNT_SCRIPT = script to fire before the horse is mounted.  If
    this script determines it cannot mount then it will set X3_HORSE_NOMOUNT to
    TRUE on the mount.  You can use a script like this to create support for
    saddlebags or to
    use this to extend the mounting system.  This will be executed by the rider
    and the variable oX3_TempHorse will be set pointing to the horse so that
    the custom script knows which horse this relates to.

    X3_HORSE_POSTMOUNT_SCRIPT = can be set to a script that can be fired after
    this mount is mounted.  This may be useful for adding things like feats and
    other after mounting needs. If this
    script does not exist then the standard Speed, Skill Decreases, Mounted
    Archery Adjustments, etc. will be applied.  If you want your own post mount
    script then it is important to note you will have to apply these modifiers
    if you also want them to be used within your own script.  The horse that
    was mounted will be referenced by oX3_TempHorse as stored on the Rider. If
    you use such a custom hook script make sure to set bX3_IS_MOUNTED to TRUE by
    using the SetSkinInt() function from x3_inc_skin.
    on the rider after they mount.   This is required in some cases for the
    dismount radial to work. (mainly when working with custom mounts)

    X3_HORSE_PREDISMOUNT_SCRIPT = can be set to a script that needs to be
    executed before the dismount portion continues.  If X3_HORSE_NODISMOUNT is
    set to TRUE then the horse dismount will be aborted.

    X3_HORSE_POSTDISMOUNT_SCRIPT = can be set to a script to be executed after
    dismount to reverse steps that may have occurred with a POSTMOUNT script
    such as adding feats.  This script could be used to remove feats.

    It is possible you might want to add a new horse/mount type that does not
    fit neatly into the appearance.2da or tails.2da with the other horse types.
    The following variables if set to any number greater than 0 will override
    the default settings and use what you specifiy instead.

    X3_HORSE_NULL_APPEARANCE = the appearance to use when scaling the horse for
    the mounting animation.

    X3_HORSE_TAIL = the tail to use with the tails.2da that defines this horse.

    X3_HORSE_FOOTSTEP = the footstep number to use when this horse is mounted.

    X3_HORSE_MOUNT_DURATION = is the duration in seconds 0.0f that the mount
    animation should take with this horse.  This only needs to be set if
    the mounting animation for this blueprint is faster or longer than the
    default animations.

    X3_HORSE_MOUNT_SPEED = is the mount speed increase or decrease that should
    be used with this mount.  If the value is 0 then it will use the
    HORSE_DEFAULT_SPEED_INCREASE constant value.

    X3_HORSE_DISMOUNT_DURATION = is the duration in seconds 0.0f that the dis-
    mount animation should take with this hores.  This only needs to be set if
    the dismounting animation for this blueprint is faster or longer than the
    default animations.

    X3_HORSE_RESTRICT_race = is a variable that set to TRUE this horse cannot
    be mounted by the specified race.  Supported races are ELF, HUMAN, HALFELF,
    DWARF, HALFORC, HALFLING, and GNOME, CUSTOM# = racial type number.

    X3_CUSTOM_RACE_APPEARANCE = a variable to set on a rider if they use a custom
    racial appearance.  This value should be set to what appearance number they
    use from appearance.2da.   This will prevent custom races from being denied
    mounting rights due to the script thinking the rider is shape shifted.

    X3_CUSTOM_RACE_MOUNTED_PHENO = This variable should be used on the rider if they
    should use a special phenotype when mounted.  This is provided to support
    custom races.

    X3_CUSTOM_RACE_JOUST_PHENO = This variable should be used on the rider if
    they need a special phenotype when mounted in joust mode.

    X3_CUSTOM_RACE_PHENOTYPE = This variable should be used on the rider if they
    need a special phenotype when not mounted.

    X3_CUSTOM_RACE_MOUNTED_APPEARANCE = a variable to set on the rider to
    indicate which appearance they should use when mounted.

    X3_HORSE_OWNER_TAG = a string that can be set on the horse that will tell
    it to Add itself as a henchman to an NPC with the specified tag.

    X3_HORSE_NOT_RIDEABLE_OWNER = if this integer is set to 1 on the Horse then
    Mount will not be useable and the error it will return if asked is that it
    is NOT rideable due to it being owned by someone else.  This is useful if
    you want horses around that the PCs and Henchmen cannot mount for reasons
    such as they are owned by a store, etc.

    bX3_IS_MOUNT = a variable that should be set to TRUE if a mount is added
    as a henchman but, is still mountable.

    X3_NO_MOUNT_ANIMATE = if this integer is set to 1 then this mount does not EVER
    animate mounting or dismounting.

    X3_TOTAL_MOUNT_ANIMATION_DELAY = a variable containing a time lot indicating
    how much time the routine has before it needs to be finished. it is used for
    the sake of synchronizing animation and the process running in the background,
    exclusively used in mounting animation portion of the HorseMount() routine,
    but can be used elsewhere. Note, that the variable is artificially set even
    in case no animation is desired so that the code doesnt happen instantly. It
    is not meant to be changed, unless something bad is happening timing-wise.
    The value is precalculated and in our particular case it is supposed to hold
    the total animation length.

    The following make it easier to implement existing mount support systems
    in conjunction with this one.

    X3_HORSE_SCRIPT_MOUNT = Script to call for mounting instead of using the
    default one called by the horse menu feat.  This still checks to make sure
    mounting in the area is legal first. This is intended for making the radial
    menus do something different just for this horse and is not intended to
    alter the HorseMount(), HorseDismount(), etc. functions.   There are already
    POSTMOUNT, POSTDISMOUNT, PREMOUNT, and PREDISMOUNT hooks which make that
    functionality possible so, that is not what this variable is for.

    X3_HORSE_SCRIPT_DISMOUNT = Script to call for dismounting instead of using
    the default one called by the horse menu feat. This is intended for making
    the radial menus do something different just for this horse and is not
    intended to alter the HorseMount(), HorseDismount(), etc. functions.   There
    are already POSTMOUNT, POSTDISMOUNT, PREMOUNT, and PREDISMOUNT hooks which
    make that functionality possible so, that is not what this variable is for.

    X3_HORSE_SCRIPT_ASSIGN = Script to call for assign mount instead of using
    the default one called by the horse menu feat. This is intended for making
    the radial menus do something different just for this horse and is not
    intended to alter the HorseMount(), HorseDismount(), etc. functions.   There
    are already POSTMOUNT, POSTDISMOUNT, PREMOUNT, and PREDISMOUNT hooks which
    make that functionality possible so, that is not what this variable is for.

    bX3_HAS_SADDLEBAGS = Integer that if set to 1 on the mount will indicate
    the horse has saddle bags.  It will support inventory control if it is
    enabled (NOT: by default).  You will also want to set the dialog
    X3_DLG_SADDLEBAG on the horse blueprint.  Or, create your own dialog that
    handles what the saddlebags one does.  You will only be able to access
    saddlebags of associates in your party.


    [AREA RELATED VARIABLES TO SET]
    ===============================

    X3_NO_HORSES = Horses not allowed in this area

    X3_NO_MOUNTING = Horses may not be ridden in this area and anyone attempting
    to do so should be forcibly dismounted.

    X3_HITCHING_POST = if a placeable or waypoint in the area a person was in
    before entering a new area has a tag of this then it will move any horses
    to this object and set them to STAND_GUARD mode.

    X3_MOUNT_OK_EXCEPTION = is an integer that if set to 1 on this area will
    override the external and underground restrictions for this area that may
    be set module wide.

    fX3_MOUNT_MULTIPLE = is a floating point value that is multiplied times
    all delays if it exists on the area.   It can be used to make an area perform
    the mounting animations at a different speed if you have really busy areas
    and want to make the animation faster or slower.   If this is not defined
    then it will always be a value of 1.0.   If it is set to 0.5 then delays
    will be shortened by half.   If it is set to 2.0 then the delays will take
    200% longer.   This is something a module builder will need to be aware of
    and can adjust. NOTE: This can be set on the PC as well and whichever number
    is larger is the one that will be used.

    fX3_DISMOUNT_MULTIPLE = is similar to fX3_MOUNT_MULTIPLE and should only be
    supplied if you want the dismount to use a different speed than the mount
    multiple.   It can be set on the area or on the PC.   The PC will take
    priority over the area.

    bX3_MOUNT_NO_ZAXIS = value to set to TRUE or 1 on the module, PC, or area
    to indicate when calculating the proper mounting location you do not want
    the Z Axis to be included in the measurement.  This has been found to
    work well in areas where you do not want the Z axis to be measured in terms
    of whether to perform the mounting animation or not.

    X3_ABORT_WHEN_STUCK = if set to TRUE, distance between player and horse is
    recorded and checked in each cycle against the current one, when moving to
    a horse during the mounting procedure. Should the two ever be equal, meaning
    that the player got stuck on his way to horse, the mounting procedure will
    be terminated. This is handy in cases when horses are behind obstacles that
    are hard to overcome like walls, but the timer that ensures that rider can
    mount his horse even in difficult terrain, would eventually force-mount the
    potential rider, which could seem like an illogical act. This doesn't need
    to be used when using X3_HORSE_ACT_VS_DELAY option, where the timer starts
    ticking only after the player gets as close as 1.5m to a horse. The switch
    can be set on an area or horses (ie. using an OnEnter script of a trigger).


    [MODULE RELATED VARIABLES TO SET]
    =================================

    X3_HORSE_PALADIN_USE_PHB = integer that if set to 1 on the module object
    will cause the script to use paladin mount summoning durations as specified
    in the Player's Handbook 3.5 edition rather than just defaulting to 24 hours.

    X3_HORSE_DISABLE_SPEED = integer that if set to 1 on the module object
    will indicate you do not want a speed increase applied when a person mounts.

    X3_HORSE_DISABLE_SKILL = integer that if set to 1 on the module object will
    indicate you do not want the skill decreases to be applied when a person
    mounts.

    X3_HORSE_ENABLE_ACBOOST = integer that if set to 1 on the module object will
    indicate that you want the PCs AC to be increased if need be to at least
    match that of the horse that is being mounted.

    X3_HORSE_ENABLE_HPBOOST = integer that if set to 1 on the module object will
    indicate that you want the PCs Hit Points to  be increased by half of the
    hit points of the mount when it is mounted.

    X3_NO_MOUNT_COMMANDABLE = integer that if set to 1 on the module object will
    indicate that you do not want the SetCommandable() commands to be used with
    the module.

    X3_NO_MOUNTED_COMBAT_FEAT = integer that if set to 1 on the module object
    will indicate that you do not want the special code added to Bioware scripts
    to try to support Mounted Combat close to how it is in Player's Handbook to
    be used.

    X3_ENABLE_MOUNT_DAMAGE = integer that if set to 1 will attempt to transfer
    some damage to the mount when a rider dismounts if damage occurred while
    they were mounted.

    X3_ENABLE_MOUNT_DB = integer that if set to 1 will enable database and
    persistent world support with this script.   You will want to modify the
    HORSE_Support functions related to the database so, that they write and
    read properly however you have the database setup in your module.  You will
    also want to plan on using something like the x3_mod_def_hb script for your
    module heartbeat script if you are going to use the database.   This is not
    used on modules by default.

    X3_NO_SHAPESHIFT_SPELL_CHECK = integer that if set to 1 on the module will
    prevent the script from checking to see if a shapeshifted spell is targetted
    on a mounted creature.   If this variable is set to 1 then the
    x2_inc_spellhook scripts will work exactly like they did before horses were
    introduced with no concern whether the target is mounted or not.

    X3_MOUNT_NO_REST_DISMOUNT = integer that if set to 1 on the module will make
    it so, you are able to rest while mounted.

    X3_MOUNT_NO_REST_DESPAWN = integer that if set to 1 on the module will make
    it so, your paladin mount is not despawned when you rest and adheres
    strictly to his summoned duration.   If time is advanced by resting then
    it is still possible it will despawn.

    X3_MOUNTS_EXTERNAL_ONLY = integer that if set to 1 on the module will make
    it so mounts can only be ridden in external areas.  There is an exception
    variable that can be set on an area to override this.

    X3_MOUNTS_NO_UNDERGROUND = integer that if set to 1 on the module will make
    it so mounts cannot be ridden in underground areas.  There is an exception
    variable that can be set on an area to override this.

    X3_HORSE_ENABLE_SADDLEBAGS = integer that if set to 1 on the module will
    enable inventory support for the horse.  NOTE: If you want it to use a quick
    non-database method for storing the inventory place a waypoint with the tag
    X3_HORSE_INVENTORY_STORAGE somewhere in an area that a PC can never get to.
    If this waypoint does not exist then it will assume that the database is to
    be used.   If you are using a database it is adviseable that you change the
    support functions because, they use the standard databases and it will often
    prove slower than you may like.

    X3_SADDLEBAG_DATABASE = string to set to the name of the database to use
    for storing saddlebag inventory.   If no name is specified it will use the
    module tag and a small modifier.

    X3_HORSE_NO_HENCHMAN_INCREASE = integer that if set to 1 on the module will
    prevent the henchmen from being increased to make room for the horse.

    X3_HORSE_MAX_HENCHMEN = integer to set on the module to indicate the maximum
    number of henchmen to allow it to be increased to in order to make room for
    horses.   By default there is no maximum.

    X3_HORSE_NO_CORPSES = integer to set on the module to 1 to indicate you
    do not want lootable horse corpses created when a mounted PC or NPC dies.

    X3_RESTORE_HENCHMEN_LOCATIONS = integer to set to 1 on the module if you
    want henchmen's henchmen to be restored to a location near the henchman that
    is their master when a PC master of the henchman connects.   This is NOT
    enabled by default to prevent problems with older modules.

    X3_EXTEND_PALMOUNT = string variable that if set on the module object
    will allow a person to extend this paladin mount script to call other
    scripts in a daisy chain type situation such as saddle bag handling ones.

    X3_EXTEND_PALDMOUNT = string variable that if set on the module object
    will allow a person to extend this paladin mount script to call other
    scripts in a daisy chain type situation such as saddle bag handling ones.

    X3_HORSE_ACT_VS_DELAY = integer to set on the module to 1 to indicate you
    want the system to use Actions as opposed to delays in some portions of the
    mounting sequence.  Doing this might provide another way to handle inaccessible
    horses besides using X3_HORSE_NOT_RIDEABLE_OWNER.   It may result in not
    being able to access accidentally poorly placed horses due to scripts or
    other factors but, it may be desired by some module designers so, it has
    been provided as an option.


    [ON THE MODULE or THE PLAYER]
    =============================

    X3_PALMOUNT_SUMMONOVR = string if set on the module or the player (player has
    priority) it will do all the checks to see if a summon is okay.   Then if
    this variable is set it will execute the script you define here rather than
    using the standard summon paladin mount function.  Beware:  If you use this
    then handling all other aspects of this mount become your responsability.

    fX3_TIMEOUT_TO_MOUNT = value to set on the module or PC to indicate how long
    the PC/NPC should attempt to move into a proper mounting animation to perform
    the mounting animation.   When this time is reached if it is still not in
    position it will instant mount instead and will not animate. If this value is
    lower than 6.0 or is not set, then the default value of 18.0 will be used.

    fX3_FREQUENCY = frequency of recursive call of the HorseMount() function to
    try and initiate new pathfinding to the horse everytime until the character
    reaches the mounting position or until the time limit for mounting is up or
    unless X3_HORSE_ACT_VS_DELAY is set to TRUE, in which case the actionqueue
    is not locked and moving towards a horse is interruptable, ie. by clicking.
    if set larger than 9.0 or less than 1.0 the value defaults to 2.0 seconds.

    bX3_MOUNT_NO_ZAXIS = value to set to TRUE or 1 on the module, PC, or area
    to indicate when calculating the proper mounting location you do not want
    the Z Axis to be included in the measurement.  This has been found to
    work well in areas where you do not want the Z axis to be measured in terms
    of whether to perform the mounting animation or not.


    [SCRIPT TO OVERRIDE SKIN SYSTEM]
    ================================

    The skin system is designed to supply the horse radial menus to older characters
    and it also is used to track some of the information about the state of the
    PC semi-persistently.   The system is setup in such a way that PRC or HCR or
    other systems that use skins will still use their own skin as long as they
    run first.   If the horse system does not detect a skin it will create one.
    Thus, if it runs before PRC or HCR create their skins there might be a problem.
    To make this less of an upgrade nightmare the horse script includes support
    for a hook script.   If PRC, or HCR or other scripting package people create
    a script named [x3_mod_pre_enter] and make that script add their skin to the
    PC then this script WILL execute ALWAYS before the horse scripts create
    their skin.   This means all you need to do is make such a script and have
    it add your skin and your scripts should function as they did before (EVEN)
    if the horse scripts execute other aspects before yours.


    [DEBUGGING AND TWEAKING SCRIPTS]
    ================================

    Press ~ in game to bring up console mode.  Type DebugMode 1 and press enter.
    Press ~ in game and this time type dm_runscript scriptname and press enter.
    Press ~ in game and type DebugMode 0 when you want to disable debug mode.
    SCRIPTS:
    x3_fix_horse = use this when the PC is being treated as mounted when it is not
    x3_fix_horseout = use this to make a module not designed with horses in mind
       only allow horses in outside areas.
    x3_fix_nocmd = set it not to use the SetCommandable with mounting toggle
    x3_fix_act = set to use actions when mounting toggle
    x3_fix_speed100 = mount/dismount speed multiple set to normal 100%
    x3_fix_speed125 = mount/dismount speed multiple set to 1255 (25% slower)
    x3_fix_speed150 = mount/dismount speed multiple set to 150% (50% slower)
    x3_fix_speed200 = mount/dismount speed multiple set to 200% (100% slower)


*/

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////   CONSTANTS   //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


const string X3_HORSE_DATABASE = "X3HORSE";

// The following constants are provided to facilitate extending the system
// if need be.   They are also provided in the event that a hak pack used
// in a module might rearrange the location of some of the aspects needed
// to handle horses.
// This constant points to the location in the appearance.2da where the
// unmounted horse appearances occur.
const int HORSE_APPEARANCE_OFFSET =     496;
// This constant points to the location in the tails.2da where the horse
// appearances begin.
const int HORSE_TAIL_OFFSET =           15;
// This constant lists how many horses are listed beginning at the location
// specified by the offset.
const int HORSE_NUMBER_OF_HORSES =      65;
// This is the prefix that should be used with the paladin mounts when spawning
// them.
const string HORSE_PALADIN_PREFIX =     "x3_palhrs";
// The constants that follow here specify what appearance to use when scaling
// the horse as a tail during mounting process to make the animation be handled
// properly.
const int HORSE_NULL_RACE_DWARF =       562;
const int HORSE_NULL_RACE_ELF =         563;
const int HORSE_NULL_RACE_HALFLING =    565;
const int HORSE_NULL_RACE_HUMAN =       568;
const int HORSE_NULL_RACE_HALFELF =     566;
const int HORSE_NULL_RACE_HALFORC =     567;
const int HORSE_NULL_RACE_GNOME =       564;
// The constants that follow here specify the appearance that should be used
// when the specified mount is mounted.   These appearances are often required
// to set the proper speeds, radiuses, etc.  They also have the complete
// phenotypes and animations associated with them.
const int HORSE_RACE_MOUNTED_DWARFM =   483;
const int HORSE_RACE_MOUNTED_DWARFF =   482;
const int HORSE_RACE_MOUNTED_ELFM =     485;
const int HORSE_RACE_MOUNTED_ELFF =     484;
const int HORSE_RACE_MOUNTED_GNOMEM =   487;
const int HORSE_RACE_MOUNTED_GNOMEF =   486;
const int HORSE_RACE_MOUNTED_HALFLINGM= 489;
const int HORSE_RACE_MOUNTED_HALFLINGF= 488;
const int HORSE_RACE_MOUNTED_HALFELFM = 491;
const int HORSE_RACE_MOUNTED_HALFELFF = 490;
const int HORSE_RACE_MOUNTED_HALFORCM = 493;
const int HORSE_RACE_MOUNTED_HALFORCF = 492;
const int HORSE_RACE_MOUNTED_HUMANM   = 495;
const int HORSE_RACE_MOUNTED_HUMANF   = 494;
// The following constants indicate which phenotype numbers should be used by
// the mounting system. _N specifies the mounting race started as a normal
// phenotype, and _L specifies the race started as a large phenotype.
const int HORSE_PHENOTYPE_MOUNTED_N =   3;
const int HORSE_PHENOTYPE_MOUNTED_L =   5;
const int HORSE_PHENOTYPE_JOUSTING_N =  6;
const int HORSE_PHENOTYPE_JOUSTING_L =  8;
// The following constants indicate which animation numbers indicate which
// animations can be used well with the horse system.
const int HORSE_ANIMATION_MOUNT =                      41;
const int HORSE_ANIMATION_DISMOUNT =                   42;
const int HORSE_ANIMATION_LOOPING_JOUST_VIOLENT_FALL = ANIMATION_LOOPING_CUSTOM3;
const int HORSE_ANIMATION_LOOPING_JOUST_GLANCE =       ANIMATION_LOOPING_CUSTOM4;
const int HORSE_ANIMATION_LOOPING_JOUST_FALL =         ANIMATION_LOOPING_CUSTOM5;
const int HORSE_ANIMATION_LOOPING_JOUST_STAB =         ANIMATION_LOOPING_CUSTOM10;
const int HORSE_ANIMATION_LOOPING_JOUST_HELMOFF =      ANIMATION_LOOPING_CUSTOM4;
// The following constant defines what footstep sound should be used when
// the horse is mounted.
const int HORSE_FOOTSTEP_SOUND =        17;
// The following constant defines the duration in seconds that it should take
// to complete the default animation.
const float HORSE_MOUNT_DURATION =      2.0f;
// The following constant defines the duration in seconds that it should take
// to complete the default animation.
const float HORSE_DISMOUNT_DURATION =   3.0f;
// The following constants refer to specific feats that might be needed to
// handle horses
const int IP_CONST_HORSE_MENU =         40;
// The constant below designates the default speed increase that should be
// granted when a person mounts a horse.
const int HORSE_DEFAULT_SPEED_INCREASE= 99;
// The following constants were added to support the new feats.  When these
// constants are added to the master constants list they can be removed from
// this part of the script.
//const int FEAT_MOUNTED_COMBAT =         1087;
//const int FEAT_MOUNTED_ARCHERY =        1088;
// Scripts called by the above feats
// x3_s3_horse
// x3_s3_palmount

// This constant is a safety to be inserted between the ClearAllActions and
// a command to play a dismount animation. If set to 0.0 or if missing, the
// dismount animation will not play properly when trying to dismount a horse
// while in motion. If you ever encounter problems with mounting animation,
// try inserting this small delay in the same fashion in the animated mounting
// procedure. All pending DelayCommands shall respect this delay accordingly
// for the sake of precise timing. Values of 0.8f and above are safe to use.
const float X3_ACTION_DELAY =           0.8f;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////   PROTOTYPES   ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


// FILE: x3_inc_horse       FUNCTION: HorseMount()
// This function will cause the calling object to attempt to mount oHorse.
// If bAnimate is set to TRUE this will cause the calling object and oHorse
// to be involved in the complete animating process.  If you bAnimate is false
// and bInstant is false the caller will still walk to the horse before mounting.
// If bAnimate is false and bInstant is TRUE then the script will immediately
// mount oHorse without any moving (this is the quickest method if needed for
// situations like cutscenes).  nState is a variable used by the function itself
// and need not be adjusted when this function is called.
void HorseMount(object oHorse,int bAnimate=TRUE,int bInstant=FALSE,int nState=0);


// FILE: x3_inc_horse       FUNCTION: HorseDismount()
// This function will cause the calling object to dismount if it is mounted. If
// bAnimate is TRUE then it will animate the dismount.   If bOwner is set to
// TRUE then it will set the object that dismounted as the owner.  This function
// will return the object that is the dismounted horse.
object HorseDismount(int bAnimate=TRUE,int bSetOwner=TRUE);


// FILE: x3_inc_horse       FUNCTION: HorseSetOwner()
// This function will set oOwner as the owner of oHorse. If bAssign is set to
// TRUE it will also set this horse to be oOwners assigned mount.   This is not
// done by default so more than one mount can be assigned to a single target if
// need be.
void HorseSetOwner(object oHorse,object oOwner,int bAssign=FALSE);


// FILE: x3_inc_horse       FUNCTION: HorseRemoveOwner()
// This function will remove the owner from oHorse.  This will not work on
// Paladin mounts.
void HorseRemoveOwner(object oHorse);


// FILE: x3_inc_horse       FUNCTION: HorseGetCanBeMounted()
// This function will return TRUE if oTarget can be mounted.  If oRider is
// specified it will also make sure that oTarget can be ridden by oRider.
// The bAssignMount field should be set to TRUE if the call of this function
// should ignore whether someone can mount a horse in the area or not.
int HorseGetCanBeMounted(object oTarget,object oRider=OBJECT_INVALID,int bAssignMount=FALSE);


// FILE: x3_inc_horse       FUNCTION: HorseSummonPaladinMount()
// This function can be used to cause the calling object to summon the paladin
// mount.   If bPHBDuration is set to TRUE then the mount will use the Players
// Handbook 3.0 edition rules for the duration that the mount will stay around.
object HorseSummonPaladinMount(int bPHBDuration=FALSE);


// FILE: x3_inc_horse       FUNCTION: HorseUnsummonPaladinMount()
// This function can be used to cause the calling object to unsummon its paladin
// mount.
void HorseUnsummonPaladinMount();


// FILE: x3_inc_horse       FUNCTION: HorseGetIsMounted()
// This function will return TRUE if oTarget is mounted.
int HorseGetIsMounted(object oTarget);


// FILE: x3_inc_horse       FUNCTION: HorseCreateHorse()
// This function will create a horse based on the blueprint sResRef at location
// lLoc and will set the owner of the horse to oOwner.  If sTag is set to
// something other than "" it will set the horse to that tag.  If nAppearance,
// nTail, and nFootstep are set to something other than -1 then it will set the
// horse to that appearance, tail, or footstep.  The function will return the
// horse that is spawned.   This function is setup the way it is so, that you
// could potentially use a single blueprint to store multiple appearance horses.
// sScript is a specific script that should be executed on the horse after it is
// spawned.  This is again supplied to further support multiple horses with a
// single blueprint.
object HorseCreateHorse(string sResRef,location lLoc,object oOwner=OBJECT_INVALID,string sTag="",int nAppearance=-1,int nTail=-1,int nFootstep=-1,string sScript="");


// FILE: x3_inc_horse       FUNCTION: HorseGetOwner()
// This function will return an object pointer to whom the owner of oHorse is
// if there is a valid horse.   If there is no owner it will return
// OBJECT_INVALID.
object HorseGetOwner(object oHorse);


// FILE: x3_inc_horse       FUNCTION: HorseSetPhenotype()
// This function will set oRider to the correct mounted phenotype for riding
// a horse.  If bJoust is set to TRUE it will set oRider to the mounted jousting
// phenotype.  This is a special phenotype with differing animation sets and
// designed to hold the lance in a very specific way.
void HorseSetPhenotype(object oRider,int bJoust=FALSE);


// FILE: x3_inc_horse       FUNCTION: HorseInstantMount()
// This function is primarily supplied for cutscenes and other instances where
// you simply need oRider to be switched to mounted mode as quickly as possible
// without preserving any variables or anything.  However, you can store a
// resref for the horse to dismount by setting sResRef.  If bJoust is set to
// TRUE then it will use the Joust Phenotypes.
// WARNING: This does not care whether someone meets the criteria to mount,
// or even if they are already mounted.   It will simply set them to the
// proper appearance and mode.   The ResRef is provided only in case someone
// uses HorseDismount() instead of using HorseInstantDismount() with this
// rider.   It is recommended this function only be used in conjunction with
// HorseInstantDismount().
void HorseInstantMount(object oRider,int nTail,int bJoust=FALSE,string sResRef="");


// FILE: x3_inc_horse       FUNCTION: HorseInstantDismount()
// This function is used to rapidly dismount oRider and does not produce a horse
// object.   It's intended usage is with cutscenes or other instances where
// having oRider dismounted as quickly as possible are required.  This will not
// produce horse/mount as it is primarily intende for cutscene work and not
// intended to replace the HorseDismount() function in other cases.
// WARNING: This does not protect Saddlebags so, it is recommended this only
// be used in conjunction with HorseInstantMount.   If you need to protect
// saddlebag contents use HorseDismount().
void HorseInstantDismount(object oRider);


// FILE: x3_inc_horse       FUNCTION: HorseGetMountTail()
// This function will return the tail that should be used with the specified
// horse.
int HorseGetMountTail(object oHorse);


// FILE: x3_inc_horse       FUNCTION: HorseGetMountFailureMessage()
// This is a companion function to HorseGetCanBeMounted.  If you need a text
// message that explains why the horse cannot be mounted.
string HorseGetMountFailureMessage(object oHorse,object oRider=OBJECT_INVALID);


// FILE: x3_inc_horse       FUNCTION: HorseAddHorseMenu()
// This function will add horse menus to the respective PC.  This is only
// needed for PCs that were not created new using patch 1.69.
void HorseAddHorseMenu(object oPC);


// FILE: x3_inc_horse       FUNCTION: HorseGetPaladinMount()
// If this rider has a paladin mount then it will be returned as the object.
// If the rider is currently riding their paladin mount then it will return
// oRider as the object.   If no paladin mount currently exists for oRider it
// will return OBJECT_INVALID.
object HorseGetPaladinMount(object oRider);


// FILE: x3_inc_horse       FUNCTION: HorseGetIsAMount()
// This will return TRUE if oTarget is a mountable creature.
int HorseGetIsAMount(object oTarget);


// FILE: x3_inc_horse       FUNCTION: HorseGetIsDisabled()
// This function detects if oCreature is in a disabled state. Can be used to
// detect disabling effects such as death, fear, confusion, sleep, paralysis,
// petrify, stun, entangle and knockdown (also applied in a non-hostile way,
// where oCreature doesn't enter a combat state)
int HorseGetIsDisabled(object oCreature=OBJECT_SELF);


// FILE: x3_inc_horse       FUNCTION: HorseReloadFromDatabase()
// This function is provided for use with an OnClientEnter script when you
// are using a persistent world type environment and need the PC's mounted
// state reloaded.  This will also make sure that henchmen for the PC are also
// restored as they were.
void HorseReloadFromDatabase(object oPC,string sDatabase);


// FILE: x3_inc_horse       FUNCTION: HorseSaveToDatabase()
// This will save all of the current status for the PC and the PCs henchmen.
void HorseSaveToDatabase(object oPC,string sDatabase);


// FILE: x3_inc_horse       FUNCTION: HorseStoreInventory()
// This function is used to store inventory of the horse for later recovery.
// See x3_inc_horse for complete details.
void HorseStoreInventory(object oCreature,object oRider=OBJECT_INVALID);


// FILE: x3_inc_horse       FUNCTION: HorseRestoreInventory()
// This function is used to return stored inventory back onto the horse
// See x3_inc_horse for complete details. If bDrop is set to TRUE then it
// will drop the contents where the horse is rather than putting them on the
// horse.  bDrop was primarily intended for cases where a mounted PC dies.
void HorseRestoreInventory(object oCreature,int bDrop=FALSE);


// FILE: x3_inc_horse       FUNCTION: HorseChangeToDefault()
// This function will set oCreature to the default racial appearance and is
// useful for reversing any situations where a creature or PC is stuck in some
// variation of a mounted appearance.   This will also clear ANY information
// stored on the creature relating to mounting. NOTE: If the target had a
// tail when not mounted this function will not restore that.
void HorseChangeToDefault(object oCreature);


// FILE: x3_inc_horse       FUNCTION: HorseIfNotDefaultAppearanceChange()
// This funtion will check the appearance of oCreature,   If it is not set to
// the default racial appearance (see racialtypes.2da) then it will call the
// HorseChangeToDefault() function.
void HorseIfNotDefaultAppearanceChange(object oCreature);


// FILE: x3_inc_horse       FUNCTION: HorseGetMyHorse()
// When oRider is dismounted, this function returns the horse currently assigned
// to oRider (OBJECT_INVALID if there is none). In certain script hooks
// (pre-mount, post-mount and post-dismount), the function returns the horse
// that is currently being mounted / dismounted. It should not be used when the
// rider is mounted, or in a pre-dismount script hook.
object HorseGetMyHorse(object oRider);


// FILE: x3_inc_horse       FUNCTION: HorseGetHasAHorse()
// This function will return TRUE if oRider has a mount or horse.
int HorseGetHasAHorse(object oRider);


// FILE: x3_inc_horse       FUNCTION: HorseGetHorse()
// This function will return the nNth horse that is owned by oRider.
object HorseGetHorse(object oRider,int nN=1);


// FILE: x3_inc_horse       FUNCTION: HorseRestoreHenchmenLocations()
// This function will check the module variable X3_RESTORE_HENCHMEN_LOCATIONS
// which when set to TRUE on the module will cause this function to jump any
// npc henchmen to the PC and will also make sure their henchmen also jump.
// This function is provided so, that there exists a function which will remain
// true to whether henchmen are mounted in no mount areas and whether mounts are
// prevented from entering no mount areas.   This is not the perfect function
// but, it will address some of the issues with the engine not restoring the
// locations of henchmen belonging to henchmen on a module reload.   This will
// actually NOT jump henchmen to the PC.   It's primary purpose is to make sure
// that henchmen belonging to the henchman are jumped to the proper location.
// It is assumed that the henchman that is their master will already be at the
// proper location due to a reload or due to a respawn from some special script
// for the server.
void HorseRestoreHenchmenLocations(object oPC);


// FILE: x3_inc_horse        FUNCTION: HorseHitchHorses()
// This function is designed to be used in conjunction with a transition script.
// oHitch is an object to hitch horses/mounts near.   If it is OBJECT_INVALID
// then a specific destination to hitch will not be used.  oClicker is who
// clicked the area transistion.  lPreJump is a pre-transition location which
// is used to determine where the horses should stay near (actually walk a
// small distance away) if they do not transition.
void HorseHitchHorses(object oHitch,object oClicker,location lPreJump);


// FILE: x3_inc_horse       FUNCTION: HorseForceJump()
// This is used to make sure oJumper makes it to withing fRange of oDestination.
// The nTimeOut is used to set a maximum number of attempts that will be made.
void HorseForceJump(object oJumper,object oDestination,float fRange=2.0,int nTimeOut=10);


// FILE: x3_inc_horse       FUNCTION: HorseMoveAssociates()
// This function is intended to be used after a transition has been made and
// oMaster has moved onto the target destination.   This function will cause
// any associates that also transitioned to move away from oMaster a small
// amount to make sure they do not block movement for oMaster.   This can be
// particularly important when you consider horses have a bit more personal
// space requirements than the traditional associate.
void HorseMoveAssociates(object oMaster);


// FILE: x3_inc_horse       FUNCTION: HorsePreloadAnimations()
// The mount and dismount animations are rather complex and by default the
// aurora engine does not always preload these animations.   This function was
// created to temporarily set the tail and appearance of a PC to that of one of
// the horse models that will thus, force preloading of the animations.   After
// that is done the animations should played properly.   This is a good function
// to call in the OnEnter script of the module or similar location.
void HorsePreloadAnimations(object oPC);


////////////////////////////////////////////////////////////////////////////////
// SUPPORT FUNCTIONS
//-----------------------------
// These functions are not intended to be called by external scripts to this
// file and are simply used as support functions called by other functions
// from within this script.
////////////////////////////////////////////////////////////////////////////////


int HORSE_SupportGetMountedAppearance(object oRider)
{ // PURPOSE: Return which appearance the rider should use when mounted
    int nRace=GetRacialType(oRider);
    int nGender=GetGender(oRider);
    if (GetLocalInt(oRider,"X3_CUSTOM_RACE_MOUNTED_APPEARANCE")>0) return GetLocalInt(oRider,"X3_CUSTOM_RACE_MOUNTED_APPEARANCE");
    if (nGender==GENDER_FEMALE)
    { // female
             if (nRace==RACIAL_TYPE_DWARF) return HORSE_RACE_MOUNTED_DWARFF;
        else if (nRace==RACIAL_TYPE_ELF) return HORSE_RACE_MOUNTED_ELFF;
        else if (nRace==RACIAL_TYPE_GNOME) return HORSE_RACE_MOUNTED_GNOMEF;
        else if (nRace==RACIAL_TYPE_HALFLING) return HORSE_RACE_MOUNTED_HALFLINGF;
        else if (nRace==RACIAL_TYPE_HALFELF) return HORSE_RACE_MOUNTED_HALFELFF;
        else if (nRace==RACIAL_TYPE_HALFORC) return HORSE_RACE_MOUNTED_HALFORCF;
        else if (nRace==RACIAL_TYPE_HUMAN) return HORSE_RACE_MOUNTED_HUMANF;
    } // female
    else
    { // male
             if (nRace==RACIAL_TYPE_DWARF) return HORSE_RACE_MOUNTED_DWARFM;
        else if (nRace==RACIAL_TYPE_ELF) return HORSE_RACE_MOUNTED_ELFM;
        else if (nRace==RACIAL_TYPE_GNOME) return HORSE_RACE_MOUNTED_GNOMEM;
        else if (nRace==RACIAL_TYPE_HALFLING) return HORSE_RACE_MOUNTED_HALFLINGM;
        else if (nRace==RACIAL_TYPE_HALFELF) return HORSE_RACE_MOUNTED_HALFELFM;
        else if (nRace==RACIAL_TYPE_HALFORC) return HORSE_RACE_MOUNTED_HALFORCM;
        else if (nRace==RACIAL_TYPE_HUMAN) return HORSE_RACE_MOUNTED_HUMANM;
    } // male
    return GetAppearanceType(oRider);
} // HORSE_SupportGetMountedAppearance()


string HORSE_SupportRaceRestrictString(object oRider)
{ // PURPOSE: This will return the race restriction string to use for oRider
    string sRet="X3_HORSE_RESTRICT_";
    int nRace=GetRacialType(oRider);
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid
             if (nRace==RACIAL_TYPE_DWARF) sRet=sRet+"DWARF";
        else if (nRace==RACIAL_TYPE_ELF) sRet=sRet+"ELF";
        else if (nRace==RACIAL_TYPE_GNOME) sRet=sRet+"GNOME";
        else if (nRace==RACIAL_TYPE_HALFELF) sRet=sRet+"HALFELF";
        else if (nRace==RACIAL_TYPE_HALFLING) sRet=sRet+"HALFLING";
        else if (nRace==RACIAL_TYPE_HALFORC) sRet=sRet+"HALFORC";
        else if (nRace==RACIAL_TYPE_HUMAN) sRet=sRet+"HUMAN";
        else {sRet=sRet+"CUSTOM"+IntToString(nRace);}
    } // valid
    return sRet;
} // HORSE_SupportRaceRestrictString(oRider)


string HORSE_SupportMountResRef(object oRider)
{ // PURPOSE: Return the resref of the mount oRider is on
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        return GetSkinString(oRider,"sX3_HorseResRef");
    } // valid parameter
    return "";
} // HORSE_SupportMountResRef()


int HORSE_SupportMountAppearance(object oRider)
{ // PURPOSE: Return the appearance of the mount oRider is on
     if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
     { // valid parameter
         return GetSkinInt(oRider,"nX3_HorseAppearance");
     } // valid parameter
     return -1;
} // HORSE_SupportMountAppearance()


int HORSE_SupportMountTail(object oRider)
{ // PURPOSE: Return the tail of the mount oRider is on
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        return GetCreatureTailType(oRider);
    } // valid parameter
    return -1;
} // HORSE_SupportMountTail()


int HORSE_SupportMountFootstep(object oRider)
{ // PURPOSE: Return the footstep sound of the rider is supposed to be when not
  // mounted
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        return GetSkinInt(oRider,"nX3_StoredFootstep");
    } // valid parameter
    return -1;
} // HORSE_SupportMountFootstep()


string HORSE_SupportMountTag(object oRider)
{ // PURPOSE: Return the tag of the mount that rider is riding
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        return GetSkinString(oRider,"sX3_HorseMountTag");
    } // valid parameter
    return "";
} // HORSE_SupportMountTag()


string HORSE_SupportMountScript(object oRider)
{ // PURPOSE: Return the post spawn script to run for the horse oRider is riding
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        return GetLocalString(oRider,"sX3_HorseMountString");
    } // valid parameter
    return "";
} // HORSE_SupportMountScript()


int HORSE_SupportRiderAppearance(object oRider)
{ // PURPOSE: Return the appearance of oRider when not mounted
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        return GetSkinInt(oRider,"nX3_HorseRiderAppearance");
    } // valid parameter
    return -1;
} // HORSE_SupportRiderAppearance()


int HORSE_SupportRiderPhenotype(object oRider)
{ // PURPOSE: Return the phenotype of the rider when not mounted
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        if (GetLocalInt(oRider,"X3_CUSTOM_RACE_PHENOTYPE")) return GetLocalInt(oRider,"X3_CUSTOM_RACE_PHENOTYPE");
        return GetSkinInt(oRider,"nX3_HorseRiderPhenotype");
    } // valid parameter
    return -1;
} // HORSE_SupportRiderPhenotype()


void HORSE_SupportCleanVariables(object oTarget)
{ // PURPOSE: Remove any mount related variables after dismount
    DeleteLocalInt(oTarget,"X3_HORSE_NULL_APPEARANCE");
    //DeleteSkinInt(oTarget,"X3_HORSE_APPEARANCE");
    DeleteLocalInt(oTarget,"X3_HORSE_TAIL");
    //DeleteSkinInt(oTarget,"nX3_HorseRiderAppearance");
    //DeleteSkinInt(oTarget,"nX3_HorseRiderPhenotype");
    //DeleteSkinInt(oTarget,"nX3_StoredFootstep");
    DeleteSkinString(oTarget,"X3_HORSE_PREDISMOUNT_SCRIPT");
    DeleteSkinString(oTarget,"X3_HORSE_POSTDISMOUNT_SCRIPT");
    DeleteLocalString(oTarget,"X3_HORSE_PREMOUNT_SCRIPT");
    DeleteLocalString(oTarget,"X3_HORSE_POSTMOUNT_SCRIPT");
    DeleteSkinString(oTarget,"sX3_HorseResRef");
    DeleteSkinString(oTarget,"sX3_HorseMountTag");
    DeleteLocalString(oTarget,"sX3_HorseMountScript");
    DeleteLocalInt(oTarget,"X3_NO_MOUNT_CUTSCENE");
    DeleteLocalInt(oTarget,"X3_NO_MOUNT_ANIMATE");
    DeleteLocalInt(oTarget,"nX3_RiderHP");
    DeleteSkinInt(oTarget,"nX3_HorseHP");
    DeleteLocalInt(oTarget,"nX3_HorsePortrait");
    DeleteLocalInt(oTarget,"bX3_HAS_SADDLEBAGS");
    DeleteLocalString(oTarget,"sDB_Inv");
    DeleteSkinInt(oTarget,"bX3_IS_MOUNTED");
    DeleteLocalInt(oTarget,"nX3_StoredMountState");
    DeleteLocalInt(oTarget,"X3_ABORT_WHEN_STUCK");
    //DeleteSkinInt(oTarget,"nX3_HorseRiderTail");
} // HORSE_SupportCleanVariables()


void HORSE_SupportMountCleanVariables(object oRider)
{ // PURPOSE: Clean variables off of oRider related to the mount
    if (GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        HORSE_SupportCleanVariables(oRider);
    } // valid parameter
} // HORSE_SupportMountCleanVariables()


location HORSE_SupportGetMountLocation(object oCreature,object oRider,float fDirection=90.0)
{ // PURPOSE: To Locate the location to place the mount
    object oArea=GetArea(oCreature);
    vector vPos=GetPosition(oCreature);
    float fFace=GetFacing(oCreature);
    location lLoc;
    float fDist=0.8*StringToFloat(Get2DAString("appearance","WING_TAIL_SCALE",HORSE_SupportGetMountedAppearance(oRider)));
    lLoc=Location(oArea,vPos+fDist*AngleToVector(fFace-fDirection),fFace);
    return lLoc;
} // HORSE_SupportGetMountLocation()


int HORSE_SupportNullAppearance(object oHorse,object oRider)
{ // PURPOSE: This will return which appearance should be used to handle animation
    int nRace;
    if (GetLocalInt(oHorse,"X3_HORSE_NULL_APPEARANCE")>0) return GetLocalInt(oHorse,"X3_HORSE_NULL_APPEARANCE");
    nRace=GetRacialType(oRider);
         if (nRace==RACIAL_TYPE_DWARF) return HORSE_NULL_RACE_DWARF;
    else if (nRace==RACIAL_TYPE_ELF) return HORSE_NULL_RACE_ELF;
    else if (nRace==RACIAL_TYPE_GNOME) return HORSE_NULL_RACE_GNOME;
    else if (nRace==RACIAL_TYPE_HALFELF) return HORSE_NULL_RACE_HALFELF;
    else if (nRace==RACIAL_TYPE_HALFLING) return HORSE_NULL_RACE_HALFLING;
    else if (nRace==RACIAL_TYPE_HALFORC) return HORSE_NULL_RACE_HALFORC;
    return HORSE_NULL_RACE_HUMAN;
} // HORSE_SupportNullAppearance()


int Horse_SupportRaceAppearance(int nAppearance)
{ // PURPOSE: This will return TRUE if the appearance passed as a parameter
  // is an appearance used as part of the mounting process.
         if (nAppearance==HORSE_RACE_MOUNTED_DWARFF) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_DWARFM) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_ELFF) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_ELFM) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_GNOMEF) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_GNOMEM) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_HALFELFF) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_HALFELFM) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_HALFLINGF) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_HALFLINGM) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_HALFORCF) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_HALFORCM) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_HUMANF) return TRUE;
    else if (nAppearance==HORSE_RACE_MOUNTED_HUMANM) return TRUE;
    return FALSE;
} // Horse_SupportRaceAppearance()


void HORSE_SupportIncreaseSpeed(object oRider,object oHorse)
{ // PURPOSE: Change the movement speed based on that of the horse (wont work unless EffectMovementSpeedIncrease() bug is fixed)
    if (GetLocalInt(GetModule(),"X3_HORSE_DISABLE_SPEED")) return;
    int nSpeed=GetLocalInt(oHorse,"X3_HORSE_MOUNT_SPEED");
    effect eMovement;
    float fSpeed;
    int nMonkEpic;
    int nMonk=GetLevelByClass(CLASS_TYPE_MONK,oRider);
    if (nSpeed==0) nSpeed=HORSE_DEFAULT_SPEED_INCREASE;
    if (nSpeed>50) nSpeed=50; // upper limit
    if (nSpeed<-100) nSpeed=-100;
    if (nMonk>2)
    { // find out monk adjustment
    nSpeed-=10*nMonk/3;
    //nSpeed-=GetBuggedSpeedAdjustment(oRider)+10*nMonk/3;
    } // find out monk adjustment
    if (GetLevelByClass(CLASS_TYPE_BARBARIAN,oRider)>0)
    { // barbarian class adjustment
    nSpeed-=10;
    //nSpeed-=GetBuggedSpeedAdjustment(oRider)+10;
    } // barbarian class adjustment
    if (nSpeed<-150) nSpeed=-150;
    SetLocalInt(oRider,"nX3_SpeedIncrease",nSpeed);
    eMovement=SupernaturalEffect(EffectMovementSpeedIncrease(nSpeed)); // EffectMovementSpeedIncrease() with negative numbers is the same as EffectMovementSpeedDecrease() with positive numbers
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMovement,oRider);
} // HORSE_SupportIncreaseSpeed()


void HORSE_SupportOriginalSpeed(object oRider)
{ // PURPOSE: Remove speed increases based upon mounted
    if (GetLocalInt(GetModule(),"X3_HORSE_DISABLE_SPEED")) return;
    effect eSearch=GetFirstEffect(oRider);
    while(GetIsEffectValid(eSearch))
    { // cycle through effects
        if((GetEffectType(eSearch) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE) &&
          (GetEffectDurationType(eSearch) == DURATION_TYPE_PERMANENT) &&
          (GetEffectSubType(eSearch) == SUBTYPE_SUPERNATURAL))
        { // check to see if matches conditions
            RemoveEffect(oRider,eSearch);
        } // check to see if matches conditions
        eSearch=GetNextEffect(oRider);
    } // cycle through effects
} // HORSE_SupportOriginalSpeed()


void HORSE_SupportAdjustMountedArcheryPenalty(object oRider)
{ // PURPOSE: Check for feats and adjust penalties to archery while mounted
    int nMountedArcheryPenalty=GetLocalInt(oRider,"nX3_MountedArchery");
    int nNewPenalty;
    effect eEffect;
    int bMatched;
    //if (HorseGetIsMounted(oRider)&&GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oRider)))
    if (HorseGetIsMounted(oRider)&&GetLocalInt(oRider,"bX3_M_ARCHERY"))
    { // Rider is mounted and has a ranged weapon - apply penalty
        nNewPenalty=4;
        if (GetHasFeat(FEAT_MOUNTED_ARCHERY,oRider)) nNewPenalty=2;
        if (nNewPenalty!=nMountedArcheryPenalty&&nMountedArcheryPenalty>0)
        { // remove existing penalties before applying the new one
            eEffect=GetFirstEffect(oRider);
            bMatched=FALSE;
            while(GetIsEffectValid(eEffect)&&!bMatched)
            { // traverse effects
               if ((GetEffectType(eEffect)==EFFECT_TYPE_ATTACK_DECREASE)&&
               (GetEffectSubType(eEffect)==SUBTYPE_SUPERNATURAL)&&
               (GetEffectDurationType(eEffect)==DURATION_TYPE_PERMANENT))
               { // match
                   RemoveEffect(oRider,eEffect);
                   bMatched=TRUE;
               } // match
               eEffect=GetNextEffect(oRider);
           } // traverse effects
        } // remove existing penalties before applying the new one
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectAttackDecrease(nNewPenalty)),oRider);
        SetLocalInt(oRider,"nX3_MountedArchery",nNewPenalty);
    } // Rider is mounted and has a ranged weapon - apply penalty
    else if (nMountedArcheryPenalty)
    { // no penalty needed - remove it
        eEffect=GetFirstEffect(oRider);
        bMatched=FALSE;
        while(GetIsEffectValid(eEffect)&&!bMatched)
        { // traverse effects
            if ((GetEffectType(eEffect)==EFFECT_TYPE_ATTACK_DECREASE)&&
            (GetEffectSubType(eEffect)==SUBTYPE_SUPERNATURAL)&&
            (GetEffectDurationType(eEffect)==DURATION_TYPE_PERMANENT))
            { // match
                RemoveEffect(oRider,eEffect);
                bMatched=TRUE;
            } // match
            eEffect=GetNextEffect(oRider);
        } // traverse effects
        DeleteLocalInt(oRider,"nX3_MountedArchery");
    } // no penalty needed - remove it
} // HORSE_SupportAdjustMountedArcheryPenalty()


void HORSE_SupportApplyMountedSkillDecreases(object oRider)
{ // PURPOSE: Applies decreases to skills while mounted
    if (GetLocalInt(GetModule(),"X3_HORSE_DISABLE_SKILL")) return;
    object oMod=GetModule();
    effect eDisarmTrap = SupernaturalEffect(EffectSkillDecrease(SKILL_DISABLE_TRAP , 50));
    effect eOpenLock   = SupernaturalEffect(EffectSkillDecrease(SKILL_OPEN_LOCK    , 50));
    effect eHide       = SupernaturalEffect(EffectSkillDecrease(SKILL_HIDE         , 50));
    effect eMove       = SupernaturalEffect(EffectSkillDecrease(SKILL_MOVE_SILENTLY, 50));
    effect ePickPocket = SupernaturalEffect(EffectSkillDecrease(SKILL_PICK_POCKET  , 50));
    effect eSetTrap    = SupernaturalEffect(EffectSkillDecrease(SKILL_SET_TRAP     , 50));
    effect eTumble     = SupernaturalEffect(EffectSkillDecrease(SKILL_TUMBLE       , 50));
    AssignCommand(oMod,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDisarmTrap,oRider));
    AssignCommand(oMod,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eOpenLock,oRider));
    AssignCommand(oMod,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eHide,oRider));
    AssignCommand(oMod,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMove,oRider));
    AssignCommand(oMod,ApplyEffectToObject(DURATION_TYPE_PERMANENT,ePickPocket,oRider));
    AssignCommand(oMod,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSetTrap,oRider));
    AssignCommand(oMod,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eTumble,oRider));
} // HORSE_SupportApplyMountedSkillDecreases()


void HORSE_SupportRemoveMountedSkillDecreases(object oRider)
{ // PURPOSE: To remove any negative effects caused by being mounted
    if (GetLocalInt(GetModule(),"X3_HORSE_DISABLE_SKILL")) return;
    effect ePenalty=GetFirstEffect(oRider);
    while (GetIsEffectValid(ePenalty))
    { // traverse effects
        if ((GetEffectType(ePenalty)==EFFECT_TYPE_SKILL_DECREASE)&&
        (GetEffectSubType(ePenalty)==SUBTYPE_SUPERNATURAL)&&
        (GetEffectDurationType(ePenalty)==DURATION_TYPE_PERMANENT))
        { // match
            RemoveEffect(oRider, ePenalty);
        } // match
        ePenalty=GetNextEffect(oRider);
    } // traverse effects
} // HORSE_SupportRemoveMountedSkillDecreases()


void HORSE_SupportResetUnmountedAppearance(object oRider)
{ // PURPOSE: Reset oRider to an unmounted appearance
    int nApp=GetSkinInt(oRider,"nX3_HorseRiderAppearance");
    int nPheno=GetSkinInt(oRider,"nX3_HorseRiderPhenotype");
    int nFoot=GetSkinInt(oRider,"nX3_StoredFootstep");
    int nTail=GetSkinInt(oRider,"nX3_HorseRiderTail");
    SetCreatureTailType(nTail,oRider);
    SetPhenoType(nPheno,oRider);
    SetCreatureAppearanceType(oRider,nApp);
    SetFootstepType(nFoot,oRider);
} // HORSE_SupportResetUnmountedAppearance()


int HORSE_SupportAbsoluteMinute()
{ // PURPOSE: Returns the current absolute time expressed in minutes
    int nTime=GetTimeMinute()+GetTimeHour()*60+GetCalendarDay()*60*24;
    int nYear=GetCalendarYear();
    if (nYear>20) nYear=nYear%20;
    nTime=nTime+GetCalendarMonth()*60*24*30+nYear*60*24*30*12;
    return nTime;
} // HORSE_SupportAbsoluteMinute()


void HORSE_SupportMonitorPaladinUnsummon(object oPaladin)
{ // PURPOSE: Monitor whether to unsummon the paladin mount
  // see hook scripts x3_s2_palmount and x3_s2_paldmount
    object oMount=GetLocalObject(oPaladin,"oX3_PALADIN_MOUNT");
    int nTime;
    if (GetIsObjectValid(oPaladin)&&oMount==oPaladin)
    { // valid
        if (GetIsObjectValid(oMount))
        { // paladin mount exists
            SetLocalObject(oPaladin,"oX3_PALADIN_MOUNT",oMount);
            nTime=HORSE_SupportAbsoluteMinute();
            if (nTime>=GetLocalInt(oPaladin,"nX3_PALADIN_UNSUMMON")&&!GetCutsceneMode(oPaladin))
            { // unsummon as long as not in a cutscene
                AssignCommand(oPaladin,HorseUnsummonPaladinMount());
            } // unsummon as long as not in a cutscene
            DelayCommand(10.0,HORSE_SupportMonitorPaladinUnsummon(oPaladin));
        } // paladin mount exists
    } // valid
} // HORSE_SupportMonitorPaladinUnsummon()


void HORSE_SupportApplyACBonus(object oRider,object oHorse)
{ // PURPOSE: Apply AC bonus
    if (!GetLocalInt(GetModule(),"X3_HORSE_ENABLE_ACBOOST")) return;
    effect eEffect;
    int nRiderAC=GetAC(oRider);
    int nHorseAC=GetAC(oHorse);
    int nDiff=nHorseAC-nRiderAC;
    if (nDiff<1) return;
    eEffect=SupernaturalEffect(EffectACIncrease(nDiff,AC_NATURAL_BONUS));
    AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oRider));
} // HORSE_SupportApplyACBonus()


void HORSE_SupportRemoveACBonus(object oRider)
{ // PURPOSE: Remove AC Bonus
    if (!GetLocalInt(GetModule(),"X3_HORSE_ENABLE_ACBOOST")) return;
    effect eEffect;
    eEffect=GetFirstEffect(oRider);
    while(GetIsEffectValid(eEffect))
    { // traverse effects
        if ((GetEffectType(eEffect)==EFFECT_TYPE_AC_INCREASE)&&
        (GetEffectSubType(eEffect)==SUBTYPE_SUPERNATURAL)&&
        (GetEffectDurationType(eEffect)==DURATION_TYPE_PERMANENT))
        { // remove
            RemoveEffect(oRider,eEffect);
            return;
        } // remove
        eEffect=GetNextEffect(oRider);
    } // traverse effects
} // HORSE_SupportRemoveACBonus()


void HORSE_SupportApplyHPBonus(object oRider,object oHorse)
{ // PURPOSE: Apply HP bonus
    if (!GetLocalInt(GetModule(),"X3_HORSE_ENABLE_HPBOOST")) return;
    effect eEffect;
    int nHP=GetCurrentHitPoints(oHorse);
    nHP=nHP/2;
    if (nHP<1) nHP=1;
    eEffect=SupernaturalEffect(EffectTemporaryHitpoints(nHP));
    AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oRider));
} // HORSE_SupportApplyHPBonus()


void HORSE_SupportRemoveHPBonus(object oRider)
{ // PURPOSE: Remove HP Bonus
    if (!GetLocalInt(GetModule(),"X3_HORSE_ENABLE_HPBOOST")) return;
    effect eEffect;
    eEffect=GetFirstEffect(oRider);
    while(GetIsEffectValid(eEffect))
    { // traverse effects
        if ((GetEffectType(eEffect)==EFFECT_TYPE_TEMPORARY_HITPOINTS)&&
        (GetEffectSubType(eEffect)==SUBTYPE_SUPERNATURAL)&&
        (GetEffectDurationType(eEffect)==DURATION_TYPE_PERMANENT))
        { // remove
            RemoveEffect(oRider,eEffect);
            return;
        } // remove
        eEffect=GetNextEffect(oRider);
    } // traverse effects
} // HORSE_SupportRemoveHPBonus()


void HORSE_SupportHandleDamage(object oRider,object oHorse)
{ // PURPOSE: Handle resetting damage to the horse back to its original setting
  // and also support damage sharing with the horse if that feature is enabled.
    int nRiderCHP=GetCurrentHitPoints(oRider);
    int nHorseCHP=GetCurrentHitPoints(oHorse);
    int nRiderSHP=GetLocalInt(oRider,"nX3_RiderHP");
    int nHorseSHP=GetSkinInt(oRider,"nX3_HorseHP");
    int nDamage;
    effect eDamage;
    effect eHeal;
    effect ePCDamage;
    int nAmount;
    if (!GetIsObjectValid(oRider)||!GetIsObjectValid(oHorse)) return;
    if (nRiderCHP<nRiderSHP) nDamage=nRiderSHP-nRiderCHP;
    if (nHorseCHP>nHorseSHP&&nHorseSHP!=0)
    { // restore horse damage
        eDamage=EffectDamage(nHorseCHP-nHorseSHP);
        nHorseCHP=nHorseSHP;
        AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oHorse));
    } // restore horse damage
    if (nDamage>0)
    { // damage was received while mounted
        if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DAMAGE"))
        { // share damage with the mount
            nAmount=nDamage/2;
            if (nAmount>(nHorseCHP-1)) nAmount=nHorseCHP-1;
            eHeal=EffectHeal(nAmount);
            eDamage=EffectDamage(nAmount);
            ePCDamage=EffectDamage(nDamage-nAmount);
            if (GetCurrentHitPoints(oRider)>(nRiderSHP-(nDamage-nAmount))) AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_INSTANT,ePCDamage,oRider));
            else if (GetCurrentHitPoints(oRider)<(nRiderSHP-(nDamage-nAmount))) AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oRider));
            AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oHorse));
        } // share damage with the mount
    } // damage was received while mounted
} // HORSE_SupportHandleDamage()


void KillTheHorse(object oHorse,int bStart=TRUE)
{ // PURPOSE: To Kill the horse
    effect eDeath=EffectDeath();
    object oItem=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oHorse);
    //SendMessageToPC(GetFirstPC(),"KillTheHorse("+GetName(oHorse)+","+IntToString(bStart)+")");
    if (GetBaseItemType(oItem)==BASE_ITEM_CREATUREITEM&&bStart)
    { // destroy
        //SendMessageToPC(GetFirstPC(),"Destroy CARMOUR '"+GetName(oHorse)+"'");
        SetPlotFlag(oItem,FALSE);
        SetDroppableFlag(oItem,FALSE);
        DestroyObject(oItem);
    } // destroy
    if (bStart) oItem=GetFirstItemInInventory(oHorse);
    else { oItem=GetNextItemInInventory(oHorse); }
    if (GetIsObjectValid(oItem))
    { // valid
        //SendMessageToPC(GetFirstPC(),"Item '"+GetName(oItem)+"'");
        if (GetBaseItemType(oItem)==BASE_ITEM_CREATUREITEM)
        { // destroy
            //SendMessageToPC(GetFirstPC(),"  Destroy");
            SetPlotFlag(oItem,FALSE);
            SetDroppableFlag(oItem,FALSE);
            DestroyObject(oItem,1.0);
        } // destroy
        DelayCommand(0.03,KillTheHorse(oHorse,FALSE));
    } // valid
    else
    { // kill
        //SendMessageToPC(GetFirstPC(),"Kill '"+GetName(oHorse)+"'");
        DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oHorse));
    } // kill
} // KillTheHorse()


void HORSE_SupportTransferInventory(object oFrom,object oTo,location lLoc,int bDestroyFrom=FALSE,int bFirst=TRUE)
{ // PURPOSE: Delay Command transfer to handle moving inventory
    object oItem;
    object oCopy;
    if (bFirst) oItem=GetFirstItemInInventory(oFrom);
    else { oItem=GetNextItemInInventory(oFrom); }
    if (GetIsObjectValid(oItem))
    { // item found
        if (GetIsObjectValid(oTo))
        { // to object
            if (GetBaseItemType(oItem)!=BASE_ITEM_CREATUREITEM)
            { // no pchide transfers
                oCopy=CopyItem(oItem,oTo,TRUE);
            } // no pchide transfers
        } // to object
        else
        { // to location
            if (GetBaseItemType(oItem)!=BASE_ITEM_CREATUREITEM)
            { // no pchide transfers
                oCopy=CopyObject(oItem,lLoc);
                if (GetItemStackSize(oCopy)!=GetItemStackSize(oItem)) SetItemStackSize(oCopy,GetItemStackSize(oItem));
                if (GetItemCharges(oCopy)!=GetItemCharges(oItem)) SetItemCharges(oCopy,GetItemCharges(oItem));
            } // no pchide transfers
        } // to location
        DestroyObject(oItem,2.0);
        DelayCommand(0.02,HORSE_SupportTransferInventory(oFrom,oTo,lLoc,bDestroyFrom,FALSE));
    } // item found
    else
    { // transfer gold
        if (GetIsObjectValid(oTo))
        { // to object
            if (GetGold(oFrom)>0) oCopy=CreateItemOnObject("nw_it_gold001",oTo,GetGold(oFrom));
        } // to object
        else
        { // to location
            if (GetGold(oFrom)>0) oCopy=CreateObject(OBJECT_TYPE_ITEM,"nw_it_gold001",lLoc,GetGold(oFrom));
        } // to location
        if (bDestroyFrom)
        { // destroy
            DestroyObject(oFrom);
        } // destroy
        if (GetLocalInt(oTo,"bDie"))
        { // death effect
            oItem=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTo);
            if (GetBaseItemType(oItem)==BASE_ITEM_CREATUREITEM)
            { // destroy
                SetDroppableFlag(oItem,FALSE);
                SetPlotFlag(oItem,FALSE);
                DestroyObject(oItem);
            } // destroy
            DelayCommand(0.1,KillTheHorse(oTo));
        } // death effect
    } // transfer gold
} // HORSE_SupportTransferInventory()


int HORSE_SupportCountHenchmen(object oPC)
{ // PURPOSE: Return the number of henchmen
    int nC=0;
    object oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nC+1);
    while(GetIsObjectValid(oHench))
    { // count
        nC++;
        oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nC+1);
    } // count
    return nC;
} // HORSE_SupportCountHenchmen()


void HORSE_SupportTransferPreservedValues(object oRider,object oHorse)
{ // PURPOSE: This will transfer preserved values for the mounted horse to
  // oHorse from oRider and then will remove them from oRider
    string sS;
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_MOUNT_MULTIPLE");
    float fX3_DISMOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_DISMOUNT_MULTIPLE");
    if (GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE")>fX3_MOUNT_MULTIPLE) fX3_MOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE");
    if (fX3_MOUNT_MULTIPLE<=0.0) fX3_MOUNT_MULTIPLE=1.0;
    if (GetLocalFloat(oRider,"fX3_DISMOUNT_MULTIPLE")>0.0) fX3_DISMOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_DISMOUNT_MULTIPLE");
    if (fX3_DISMOUNT_MULTIPLE>0.0) fX3_MOUNT_MULTIPLE=fX3_DISMOUNT_MULTIPLE; // use dismount multiple instead of mount multiple
    if (GetIsObjectValid(oHorse))
    { // transfer values to horse

    } // transfer values to horse
    sS=GetSkinString(oRider,"X3_HORSE_POSTDISMOUNT_SCRIPT");
    if (GetStringLength(sS)>0)
    { // run post dismount script
        SetLocalObject(oRider,"oX3_TempHorse",oHorse);
        ExecuteScript(sS,oRider);
        DeleteLocalObject(oRider,"oX3_TempHorse");
    } // run post dismount script
    // delete variables
    if (GetLocalInt(oRider,"bX3_HORSE_MODIFIERS")&&GetStringLength(sS)<1)
    { // remove horse modifiers
        DeleteLocalInt(oRider,"bX3_HORSE_MODIFIERS");
        DelayCommand(0.10*fX3_MOUNT_MULTIPLE,HORSE_SupportOriginalSpeed(oRider));
        DelayCommand(0.30*fX3_MOUNT_MULTIPLE,HORSE_SupportAdjustMountedArcheryPenalty(oRider));
        DelayCommand(0.15*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveMountedSkillDecreases(oRider));
        DelayCommand(0.25*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveACBonus(oRider));
        DelayCommand(0.25*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveHPBonus(oRider));
        DelayCommand(0.20*fX3_MOUNT_MULTIPLE,HORSE_SupportHandleDamage(oRider,oHorse));
    } // remove horse modifiers
    //HORSE_SupportMountCleanVariables(oRider);
} // HORSE_SupportTransferPreservedValues()


void HORSE_SupportDismountWrapper(int bAnimate,int bSetOwner)
{ // Wrap
    object oHorse=HorseDismount(bAnimate,bSetOwner);
    object oNPC=OBJECT_SELF;
    if (bSetOwner) SetLocalObject(oNPC,"oAssignedHorse",oHorse);
} // HORSE_SupportDismountWrapper()


void HORSE_SupportRestoreFromPreload(object oPC,int nApp,int nTail)
{ // PURPOSE: Restore to previous appearance before preload
    SetCreatureAppearanceType(oPC,nApp);
    SetCreatureTailType(nTail,oPC);
} // HORSE_SupportRestoreFromPreload()


void HORSE_SupportSetMountingSentinel(object oRider,object oHorse,float fTimeout=6.0, int nCount=0)
{ // PURPOSE: This will set a mounting process that will make sure the PC or NPC
  // is returned to commandable.   There may be a slight delay but, this will
  // insure recovery from aborted mounts that could result in PC being stuck as
  // not commandable.
    if (!HorseGetIsMounted(oRider)&&!IsInConversation(oRider)&&!GetIsInCombat(oRider)&&!HorseGetIsDisabled(oRider))
    { // keep waiting
        float fFreq=1.0; // frequency in seconds
        if (nCount<FloatToInt(fTimeout/fFreq))
        { // keep trying
            DelayCommand(fFreq,HORSE_SupportSetMountingSentinel(oRider,oHorse,fTimeout,nCount+1));
        } // keep trying
        else if (!GetCutsceneMode(oRider))
        { // make commandable
            if (!GetCommandable(oRider))
            { // commandable
                SetCommandable(TRUE,oRider);
                SetCommandable(TRUE,oHorse);
                //HORSE_SupportCleanVariables(oRider);
                DeleteLocalInt(oRider,"X3_DOING_HORSE_ACTION");
                DeleteLocalInt(oHorse,"X3_DOING_HORSE_ACTION");
                DeleteLocalObject(oHorse,"oX3_TempRider");
                DeleteLocalInt(oRider,"nX3_MovingMount");
                DeleteLocalFloat(oRider,"fLastHorseDist");
                DeleteLocalInt(oRider,"bPathIsBlocked");
            } // commandable
        } // make commandable
    } // keep waiting
    else if (!GetCutsceneMode(oRider))
    { // make sure commandable if not in a cutscene
        if (!GetCommandable(oRider))
        { // commandable
            SetCommandable(TRUE,oRider);
            SetCommandable(TRUE,oHorse);
            //HORSE_SupportCleanVariables(oRider);
            DeleteLocalInt(oRider,"X3_DOING_HORSE_ACTION");
            DeleteLocalInt(oHorse,"X3_DOING_HORSE_ACTION");
            DeleteLocalObject(oHorse,"oX3_TempRider");
            DeleteLocalInt(oRider,"nX3_MovingMount");
            DeleteLocalFloat(oRider,"fLastHorseDist");
            DeleteLocalInt(oRider,"bPathIsBlocked");
        } // commandable
    } // make sure commandable if not in a cutscene
} // HORSE_SupportSetMountingSentinel()


void HORSE_Support_AssignRemainingMount(object oOwner)
{ // PURPOSE: Make a link between the oOwner and one of the horses he may own
    int nN=1;
    object oAssociate=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oOwner,nN);
    while(GetIsObjectValid(oAssociate))
    { // traverse associtates
        if (HorseGetIsAMount(oAssociate)&&HorseGetCanBeMounted(oAssociate,oOwner,TRUE)&&oOwner==HorseGetOwner(oAssociate))
        { // pick first unmounted owned mount
            SetLocalObject(oOwner,"oAssignedHorse",oAssociate);
            return;
        } // pick first unmounted owned mount
        nN++;
        oAssociate=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oOwner,nN);
    } // traverse associtates
} // HORSE_Support_AssignRemainingMount()


////////////////////////////////////////////////////////////////////////////////
////////////////////////   DATABASE SUPPORT FUNCTIONS   ////////////////////////
////////////////////////////////////////////////////////////////////////////////

/*
    These functions were provided so, Persistent World and other multiplayer
    gamers would have some functions to look at that they can modify to make
    work with their own persistent world.   People do these in so many ways that
    while these are functional, they used the default Bioware database commands
    and as a result are slow.   This was known when they were designed but, it
    was determined that having some sample functions that could be modified
    might be beneficial to the community.
*/


void HORSE_SupportDeleteFromDatabase(object oPC,string sDatabase,int nN=1)
{ // PURPOSE: Delete Henchmen information from the database
    string sN=IntToString(nN);
    DeleteCampaignVariable(sDatabase,"sX3_RR_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"sX3_TAG_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SCR_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HAP_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HTL_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HNAP_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HAP_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_APP_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_PHEN_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_FOOT_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_NOAN_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_CAPP_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_CPHE_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_CTAIL_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SPRM_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SPOM_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SPRDM_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SPODM_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"bX3_MOUNTED_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"sX3_HTAG_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"sX3_HRR_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HPOR_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HHP_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_RHP_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"bX3_ISM_"+sN,oPC);
    DeleteCampaignVariable(sDatabase,"nX3_TAL_"+sN,oPC);
    if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS"))
    { // saddlebags enabled
        DeleteCampaignVariable(sDatabase,"bX3_HSB_"+sN,oPC);
    } // saddlebags enabled
} // HORSE_SupportDeleteFromDatabase()


void HORSE_SupportSaveToDatabase(object oPC,object oHenchman,string sDatabase,int nN=1)
{ // PURPOSE: Save henchman to database
    string sN=IntToString(nN);
    SetCampaignString(sDatabase,"sX3_RR_",GetSkinString(oHenchman,"sX3_HorseResRef"),oPC);
    SetCampaignString(sDatabase,"sX3_TAG_",GetSkinString(oHenchman,"sX3_HorseMountTag"),oPC);
    SetCampaignString(sDatabase,"sX3_SCR_",GetLocalString(oHenchman,"sX3_HorseMountScript"),oPC);
    //SetCampaignInt(sDatabase,"nX3_HAP_",GetSkinInt(oHenchman,"X3_HORSE_APPEARANCE"),oPC);
    SetCampaignInt(sDatabase,"nX3_HTL_",GetLocalInt(oHenchman,"X3_HORSE_TAIL"),oPC);
    SetCampaignInt(sDatabase,"nX3_HNAP_",GetLocalInt(oHenchman,"X3_HORSE_NULL_APPEARANCE"),oPC);
    SetCampaignInt(sDatabase,"nX3_APP_",GetSkinInt(oHenchman,"nX3_HorseRiderAppearance"),oPC);
    SetCampaignInt(sDatabase,"nX3_PHEN_",GetSkinInt(oHenchman,"nX3_HorseRiderPhenotype"),oPC);
    SetCampaignInt(sDatabase,"nX3_FOOT_",GetSkinInt(oHenchman,"nX3_StoredFootstep"),oPC);
    SetCampaignInt(sDatabase,"nX3_NOAN_",GetLocalInt(oHenchman,"X3_NO_MOUNT_ANIMATE"),oPC);
    SetCampaignInt(sDatabase,"nX3_CAPP_",GetAppearanceType(oHenchman),oPC);
    SetCampaignInt(sDatabase,"nX3_CPHE_",GetPhenoType(oHenchman),oPC);
    SetCampaignInt(sDatabase,"nX3_CTAIL_",GetCreatureTailType(oHenchman),oPC);
    SetCampaignString(sDatabase,"sX3_SPRM_",GetLocalString(oHenchman,"X3_HORSE_PREMOUNT_SCRIPT"),oPC);
    SetCampaignString(sDatabase,"sX3_SPOM_",GetLocalString(oHenchman,"X3_HORSE_POSTMOUNT_SCRIPT"),oPC);
    SetCampaignString(sDatabase,"sX3_SPRDM_",GetSkinString(oHenchman,"X3_HORSE_PREDISMOUNT_SCRIPT"),oPC);
    SetCampaignString(sDatabase,"sX3_SPODM_",GetSkinString(oHenchman,"X3_HORSE_POSTDISMOUNT_SCRIPT"),oPC);
    SetCampaignInt(sDatabase,"bX3_MOUNTED_",HorseGetIsMounted(oHenchman),oPC);
    SetCampaignString(sDatabase,"sX3_HTAG_"+sN,GetTag(oHenchman),oPC);
    SetCampaignString(sDatabase,"sX3_HRR_"+sN,GetResRef(oHenchman),oPC);
    SetCampaignInt(sDatabase,"nX3_HPOR_"+sN,GetLocalInt(oHenchman,"nX3_HorsePortrait"),oPC);
    SetCampaignInt(sDatabase,"nX3_HHP_"+sN,GetSkinInt(oHenchman,"nX3_HorseHP"),oPC);
    SetCampaignInt(sDatabase,"nX3_RHP_"+sN,GetLocalInt(oHenchman,"nX3_RiderHP"),oPC);
    SetCampaignInt(sDatabase,"bX3_ISM_"+sN,GetSkinInt(oHenchman,"bX3_IS_MOUNTED"),oPC);
    SetCampaignInt(sDatabase,"nX3_TAL_"+sN,GetSkinInt(oHenchman,"nX3_HorseRiderTail"),oPC);
    if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS"))
    { // saddlebags enabled
        SetCampaignInt(sDatabase,"bX3_HSB_"+sN,GetLocalInt(oHenchman,"bX3_HAS_SADDLEBAGS"),oPC);
    } // saddlebags enabled
} // HORSE_SupportSaveToDatabase()


int HORSE_SupportGetHenchmanExistsInDatabase(object oPC,string sDatabase,int nN=1)
{ // PURPOSE: Return TRUE if there is a henchman saved in the database
    string sS=GetCampaignString(sDatabase,"sX3_HTAG_"+IntToString(nN),oPC);
    if (GetStringLength(sS)>0) return TRUE;
    return FALSE;
} // HORSE_SupportGetHenchmanExistsInDatabase()


void HORSE_SupportRestoreHenchmanFromDatabase(object oPC,string sDatabase,int nN=1)
{ // PURPOSE: This will reload and assign the henchman to the PC
    object oHenchman=OBJECT_INVALID;
    string sN=IntToString(nN);
    string sTag=GetCampaignString(sDatabase,"sX3_HTAG_"+sN,oPC);
    string sResRef=GetCampaignString(sDatabase,"sX3_HRR_"+sN,oPC);
    int nNN=1;
    object oOb;
    oOb=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nNN);
    while(!GetIsObjectValid(oHenchman)&&GetIsObjectValid(oOb))
    { // see if henchman is already in play
        if (sResRef==GetResRef(oOb)&&GetTag(oOb)==sTag) oHenchman=oOb;
        nNN++;
        oOb=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nNN);
    } // see if henchman is already in play
    if (!GetIsObjectValid(oHenchman))
    { // create henchman
        oHenchman=CreateObject(OBJECT_TYPE_CREATURE,sResRef,GetLocation(oPC),FALSE,sTag);
        AssignCommand(oHenchman,SetAssociateState(NW_ASC_DISTANCE_6_METERS,TRUE));
        DelayCommand(1.0,AddHenchman(oPC,oHenchman));
    } // create henchman
    // load and set henchman
    SetCreatureAppearanceType(oHenchman,GetCampaignInt(sDatabase,"nX3_CAPP_"+sN,oPC));
    SetPhenoType(GetCampaignInt(sDatabase,"nX3_CPHE_"+sN,oPC),oHenchman);
    SetCreatureTailType(GetCampaignInt(sDatabase,"nX3_CTAIL_"+sN,oPC),oHenchman);
    SetSkinString(oHenchman,"sX3_HorseResRef",GetCampaignString(sDatabase,"sX3_RR_"+sN,oPC));
    SetSkinString(oHenchman,"sX3_HorseMountTag",GetCampaignString(sDatabase,"sX3_TAG_"+sN,oPC));
    SetLocalString(oHenchman,"sX3_HorseMountScript",GetCampaignString(sDatabase,"sX3_SCR_"+sN,oPC));
    SetLocalString(oHenchman,"X3_HORSE_PREMOUNT_SCRIPT",GetCampaignString(sDatabase,"sX3_SPRM_"+sN,oPC));
    SetLocalString(oHenchman,"X3_HORSE_POSTMOUNT_SCRIPT",GetCampaignString(sDatabase,"sX3_SPOM_"+sN,oPC));
    SetSkinString(oHenchman,"X3_HORSE_PREDISMOUNT_SCRIPT",GetCampaignString(sDatabase,"sX3_SPRDM_"+sN,oPC));
    SetSkinString(oHenchman,"X3_HORSE_POSTDISMOUNT_SCRIPT",GetCampaignString(sDatabase,"sX3_SPODM_"+sN,oPC));
    //SetSkinInt(oHenchman,"X3_HORSE_APPEARANCE",GetCampaignInt(sDatabase,"nX3_HAP_"+sN,oPC));
    SetLocalInt(oHenchman,"X3_HORSE_TAIL",GetCampaignInt(sDatabase,"nX3_HTL_"+sN,oPC));
    SetLocalInt(oHenchman,"X3_HORSE_NULL_APPEARANCE",GetCampaignInt(sDatabase,"nX3_HNAP_"+sN,oPC));
    SetSkinInt(oHenchman,"nX3_HorseRiderAppearance",GetCampaignInt(sDatabase,"nX3_APP_"+sN,oPC));
    SetSkinInt(oHenchman,"nX3_HorseRiderPhenotype",GetCampaignInt(sDatabase,"nX3_PHEN_"+sN,oPC));
    SetSkinInt(oHenchman,"nX3_StoredFootstep",GetCampaignInt(sDatabase,"nX3_FOOT_"+sN,oPC));
    SetLocalInt(oHenchman,"X3_NO_MOUNT_ANIMATE",GetCampaignInt(sDatabase,"nX3_NOAN_"+sN,oPC));
    SetLocalInt(oHenchman,"nX3_HorsePortrait",GetCampaignInt(sDatabase,"nX3_HPOR_"+sN,oPC));
    SetSkinInt(oHenchman,"nX3_HorseHP",GetCampaignInt(sDatabase,"nX3_HHP_"+sN,oPC));
    SetLocalInt(oHenchman,"nX3_RiderHP",GetCampaignInt(sDatabase,"nX3_RHP_"+sN,oPC));
    SetSkinInt(oHenchman,"bX3_IS_MOUNTED",GetCampaignInt(sDatabase,"bX3_ISM_"+sN,oPC));
    SetSkinInt(oHenchman,"nX3_HorseRiderTail",GetCampaignInt(sDatabase,"nX3_TAL_"+sN,oPC));
    if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS"))
    { // saddlebags enabled
        SetLocalInt(oHenchman,"bX3_HAS_SADDLEBAGS",GetCampaignInt(sDatabase,"bX3_HSB_"+sN,oPC));
    } // saddlebags enabled
} // HORSE_SupportRestoreHenchmanFromDatabase()


void HORSE_SupportDeleteMountedPCFromDatabase(object oPC,string sDatabase)
{ // PURPOSE: This will remove the info about this PC being mounted
    DeleteCampaignVariable(sDatabase,"sX3_RR",oPC);
    DeleteCampaignVariable(sDatabase,"sX3_TAG",oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SCR",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HAP",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HTL",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HNAP",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HAP",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_APP",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_PHEN",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_FOOT",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_NOAN",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_CAPP",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_CPHE",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_CTAIL",oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SPRM",oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SPOM",oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SPRDM",oPC);
    DeleteCampaignVariable(sDatabase,"sX3_SPODM",oPC);
    DeleteCampaignVariable(sDatabase,"bX3_MOUNTED",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_PALUS",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HPOR",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_HHP",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_RHP",oPC);
    DeleteCampaignVariable(sDatabase,"bX3_ISM",oPC);
    DeleteCampaignVariable(sDatabase,"nX3_TAL",oPC);
    if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS"))
    { // saddlebags enabled
        DeleteCampaignVariable(sDatabase,"bX3_HSB",oPC);
    } // saddlebags enabled
} // HORSE_SupportDeleteMountedPCFromDatabase()


void HORSE_SupportStoreMountedPCInDatabase(object oPC,string sDatabase)
{ // PURPOSE: This will store the PCs information about being mounted
    SetCampaignString(sDatabase,"sX3_RR",GetSkinString(oPC,"sX3_HorseResRef"),oPC);
    SetCampaignString(sDatabase,"sX3_TAG",GetSkinString(oPC,"sX3_HorseMountTag"),oPC);
    SetCampaignString(sDatabase,"sX3_SCR",GetLocalString(oPC,"sX3_HorseMountScript"),oPC);
    //SetCampaignInt(sDatabase,"nX3_HAP",GetSkinInt(oPC,"X3_HORSE_APPEARANCE"),oPC);
    SetCampaignInt(sDatabase,"nX3_HTL",GetLocalInt(oPC,"X3_HORSE_TAIL"),oPC);
    SetCampaignInt(sDatabase,"nX3_HNAP",GetLocalInt(oPC,"X3_HORSE_NULL_APPEARANCE"),oPC);
    SetCampaignInt(sDatabase,"nX3_APP",GetSkinInt(oPC,"nX3_HorseRiderAppearance"),oPC);
    SetCampaignInt(sDatabase,"nX3_PHEN",GetSkinInt(oPC,"nX3_HorseRiderPhenotype"),oPC);
    SetCampaignInt(sDatabase,"nX3_FOOT",GetSkinInt(oPC,"nX3_StoredFootstep"),oPC);
    SetCampaignInt(sDatabase,"nX3_NOAN",GetLocalInt(oPC,"X3_NO_MOUNT_ANIMATE"),oPC);
    SetCampaignInt(sDatabase,"nX3_CAPP",GetAppearanceType(oPC),oPC);
    SetCampaignInt(sDatabase,"nX3_CPHE",GetPhenoType(oPC),oPC);
    SetCampaignInt(sDatabase,"nX3_CTAIL",GetCreatureTailType(oPC),oPC);
    SetCampaignString(sDatabase,"sX3_SPRM",GetLocalString(oPC,"X3_HORSE_PREMOUNT_SCRIPT"),oPC);
    SetCampaignString(sDatabase,"sX3_SPOM",GetLocalString(oPC,"X3_HORSE_POSTMOUNT_SCRIPT"),oPC);
    SetCampaignString(sDatabase,"sX3_SPRDM",GetSkinString(oPC,"X3_HORSE_PREDISMOUNT_SCRIPT"),oPC);
    SetCampaignString(sDatabase,"sX3_SPODM",GetSkinString(oPC,"X3_HORSE_POSTDISMOUNT_SCRIPT"),oPC);
    SetCampaignInt(sDatabase,"nX3_HPOR",GetLocalInt(oPC,"nX3_HorsePortrait"),oPC);
    SetCampaignInt(sDatabase,"nX3_RHP",GetLocalInt(oPC,"nX3_RiderHP"),oPC);
    SetCampaignInt(sDatabase,"nX3_HHP",GetSkinInt(oPC,"nX3_HorseHP"),oPC);
    SetCampaignInt(sDatabase,"bX3_MOUNTED",TRUE,oPC);
    SetCampaignInt(sDatabase,"bX3_ISM",GetSkinInt(oPC,"bX3_IS_MOUNTED"),oPC);
    SetCampaignInt(sDatabase,"nX3_PALUS",GetLocalInt(oPC,"nX3_PALADIN_UNSUMMON"),oPC);
    SetCampaignInt(sDatabase,"nX3_TAL",GetSkinInt(oPC,"nX3_HorseRiderTail"),oPC);
    if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS"))
    { // saddlebags enabled
        SetCampaignInt(sDatabase,"bX3_HSB",GetLocalInt(oPC,"bX3_HAS_SADDLEBAGS"),oPC);
    } // saddlebags enabled
} // HORSE_SupportStoreMountedPCInDatabase()


void HORSE_SupportReloadMountedPCFromDatabase(object oPC,string sDatabase)
{ // PURPOSE: This will restore the mounted information about the PC
    SetCreatureAppearanceType(oPC,GetCampaignInt(sDatabase,"nX3_CAPP",oPC));
    SetPhenoType(GetCampaignInt(sDatabase,"nX3_CPHE",oPC),oPC);
    SetCreatureTailType(GetCampaignInt(sDatabase,"nX3_CTAIL",oPC),oPC);
    SetSkinString(oPC,"sX3_HorseResRef",GetCampaignString(sDatabase,"sX3_RR",oPC));
    SetSkinString(oPC,"sX3_HorseMountTag",GetCampaignString(sDatabase,"sX3_TAG",oPC));
    SetLocalString(oPC,"sX3_HorseMountScript",GetCampaignString(sDatabase,"sX3_SCR",oPC));
    SetLocalString(oPC,"X3_HORSE_PREMOUNT_SCRIPT",GetCampaignString(sDatabase,"sX3_SPRM",oPC));
    SetLocalString(oPC,"X3_HORSE_POSTMOUNT_SCRIPT",GetCampaignString(sDatabase,"sX3_SPOM",oPC));
    SetSkinString(oPC,"X3_HORSE_PREDISMOUNT_SCRIPT",GetCampaignString(sDatabase,"sX3_SPRDM",oPC));
    SetSkinString(oPC,"X3_HORSE_POSTDISMOUNT_SCRIPT",GetCampaignString(sDatabase,"sX3_SPODM",oPC));
    //SetSkinInt(oPC,"X3_HORSE_APPEARANCE",GetCampaignInt(sDatabase,"nX3_HAP",oPC));
    SetLocalInt(oPC,"X3_HORSE_TAIL",GetCampaignInt(sDatabase,"nX3_HTL",oPC));
    SetLocalInt(oPC,"X3_HORSE_NULL_APPEARANCE",GetCampaignInt(sDatabase,"nX3_HNAP",oPC));
    SetSkinInt(oPC,"nX3_HorseRiderAppearance",GetCampaignInt(sDatabase,"nX3_APP",oPC));
    SetSkinInt(oPC,"nX3_HorseRiderPhenotype",GetCampaignInt(sDatabase,"nX3_PHEN",oPC));
    SetSkinInt(oPC,"nX3_StoredFootstep",GetCampaignInt(sDatabase,"nX3_FOOT",oPC));
    SetLocalInt(oPC,"X3_NO_MOUNT_ANIMATE",GetCampaignInt(sDatabase,"nX3_NOAN",oPC));
    SetLocalInt(oPC,"nX3_PALADIN_UNSUMMON",GetCampaignInt(sDatabase,"nX3_PALUS",oPC));
    SetLocalInt(oPC,"nX3_HorsePortrait",GetCampaignInt(sDatabase,"nX3_HPOR",oPC));
    SetLocalInt(oPC,"nX3_RiderHP",GetCampaignInt(sDatabase,"nX3_RHP",oPC));
    SetSkinInt(oPC,"nX3_HorseHP",GetCampaignInt(sDatabase,"nX3_HHP",oPC));
    SetSkinInt(oPC,"bX3_IS_MOUNTED",GetCampaignInt(sDatabase,"bX3_ISM",oPC));
    SetSkinInt(oPC,"nX3_HorseRiderTail",GetCampaignInt(sDatabase,"nX3_TAL",oPC));
    if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS"))
    { // saddlebags enabled
        SetLocalInt(oPC,"bX3_HAS_SADDLEBAGS",GetCampaignInt(sDatabase,"bX3_HSB",oPC));
    } // saddlebags enabled
    if (HorseGetIsMounted(oPC)&&GetStringLeft(GetSkinString(oPC,"sX3_HorseResRef"),GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX) AssignCommand(oPC,HORSE_SupportMonitorPaladinUnsummon(oPC));
} // HORSE_SupportReloadMountedPCFromDatabase()


////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
//-----------------------------
// This is where the actual functions defined in the prototype section are
// completed.
////////////////////////////////////////////////////////////////////////////////


void HorseReloadFromDatabase(object oPC,string sDatabase)
{ // PURPOSE: Reload status from database and set it the same
    int nN;
    // Reload settings for oPC
    HORSE_SupportReloadMountedPCFromDatabase(oPC,sDatabase);
    nN=1;
    while(HORSE_SupportGetHenchmanExistsInDatabase(oPC,sDatabase,nN))
    { // restore henchmen
        HORSE_SupportRestoreHenchmanFromDatabase(oPC,sDatabase,nN);
        nN++;
    } // restore henchmen
} // HorseReloadFromDatabase()


void HorseSaveToDatabase(object oPC,string sDatabase)
{ // PURPOSE: Save Status to Database
    int nN=1;
    int nMax;
    object oHenchman;
    if (HorseGetIsMounted(oPC))
    { // Store mounted info
        HORSE_SupportStoreMountedPCInDatabase(oPC,sDatabase);
    } // Store mounted info
    else
    { // Delete mounted info
        HORSE_SupportDeleteMountedPCFromDatabase(oPC,sDatabase);
    } // Delete mounted info
    while(HORSE_SupportGetHenchmanExistsInDatabase(oPC,sDatabase,nN))
    { // count
        nMax++;
        nN++;
    } // count
    nN=1;
    while(nN<=nMax)
    { // remove old
        HORSE_SupportDeleteFromDatabase(oPC,sDatabase,nN);
        nN++;
    } // remove old
    nN=1;
    oHenchman=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nN);
    while(GetIsObjectValid(oHenchman))
    { // traverse henchmen
        HORSE_SupportSaveToDatabase(oPC,oHenchman,sDatabase,nN);
        nN++;
        oHenchman=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nN);
    } // traverse henchmen
} // HorseSaveToDatabase()


object HorseCreateHorse(string sResRef,location lLoc,object oOwner=OBJECT_INVALID,string sTag="",int nAppearance=-1,int nTail=-1,int nFootstep=-1,string sScript="")
{ // PURPOSE: Spawn a horse with the specified information
    object oHorse=OBJECT_INVALID;
    int nHenchmen=HORSE_SupportCountHenchmen(oOwner);
    int nMax=GetLocalInt(GetModule(),"X3_HORSE_MAX_HENCHMEN");
    int bIncHenchmen=GetLocalInt(GetModule(),"X3_HORSE_NO_HENCHMAN_INCREASE");
    int nCurr=GetMaxHenchmen();
    if (GetStringLength(sResRef)>0)
    { // resref specified
        oHorse=CreateObject(OBJECT_TYPE_CREATURE,sResRef,lLoc,FALSE,sTag);
        if (GetIsObjectValid(oHorse))
        { // horse successfully created
            SetLocalInt(oHorse,"bX3_IS_MOUNT",TRUE);
            SetLocalString(oHorse,"sX3_OriginalName",GetName(oHorse));
            if (GetIsObjectValid(oOwner)&&GetObjectType(oOwner)==OBJECT_TYPE_CREATURE)
            { // assign owner
                SetLocalObject(oHorse,"oX3_HorseOwner",oOwner);
                if (nHenchmen==nCurr)
                { // see if increase possible
                    if (!bIncHenchmen)
                    { // increase is permissable
                        if (nMax==0||nMax>0)
                        { // do the increase
                            SetMaxHenchmen(nCurr+1);
                        } // do the increase
                    } // increase is permissable
                } // see if increase possible
                AddHenchman(oOwner,oHorse);
                //AssignCommand(oHorse,SetAssociateState(NW_ASC_DISTANCE_6_METERS,TRUE));
                SetAssociateState(NW_ASC_DISTANCE_6_METERS,TRUE,oHorse);
                if (GetMaster(oHorse)==oOwner) SetName(oHorse,GetName(oOwner)+"'s "+GetName(oHorse));
                if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsPC(oOwner)) SetLocalInt(oOwner,"bX3_STORE_MOUNT_INFO",TRUE);
            } // assign owner
            if (nAppearance>-1)
            { // set appearance
                SetCreatureAppearanceType(oHorse,nAppearance);
            } // set appearance
            if (nTail>-1)
            { // set tail
                SetCreatureTailType(nTail,oHorse);
            } // set tail
            if (nFootstep>-1)
            { // footstep
                SetFootstepType(nFootstep,oHorse);
            } // footstep
            if (GetStringLength(sScript)>0)
            { // post spawn script
                SetLocalString(oHorse,"sX3_HORSE_CREATED_SCRIPT",sScript);
                ExecuteScript(sScript,oHorse);
            } // post spawn script
        } // horse successfully created
    } // resref specified
    return oHorse;
} // HorseCreateHorse()


int HorseGetIsMounted(object oTarget)
{ // PURPOSE: Return whether oTarget is mounted
    if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        if (GetSkinInt(oTarget,"bX3_IS_MOUNTED")) return TRUE;
    } // valid parameter
    return FALSE;
} // HorseGetIsMounted()


int HorseGetCanBeMounted(object oTarget,object oRider=OBJECT_INVALID,int bAssignMount=FALSE)
{ // PURPOSE: This will return whether oTarget can be mounted
    int nAppearance;
    string sS;
    object oOb;
    if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
    { // valid oTarget type
        if (GetIsDead(oTarget)) return FALSE;
        if (GetIsPC(oTarget)) return FALSE;
        if (GetIsObjectValid(oRider)&&GetObjectType(oRider)!=OBJECT_TYPE_CREATURE) return FALSE;
        if (GetIsObjectValid(oRider)&&GetIsEnemy(oRider,oTarget)) return FALSE;
        if (GetIsDMPossessed(oTarget)) return FALSE;
        if (HorseGetIsMounted(oRider)) return FALSE;
        //if (GetIsObjectValid(oRider)&&GetCreatureTailType(oRider)!=CREATURE_TAIL_TYPE_NONE) return FALSE;
        nAppearance=GetAppearanceType(oRider);
        if (GetIsPC(oRider)&&nAppearance>6&&GetLocalInt(oRider,"X3_CUSTOM_RACE_APPEARANCE")!=nAppearance&&!Horse_SupportRaceAppearance(nAppearance)) return FALSE; // PC is shape shifted
        if (GetIsObjectValid(oRider)&&GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
        { // Rider is a creature
            sS=HORSE_SupportRaceRestrictString(oRider);
            if (GetLocalInt(oTarget,sS)) return FALSE; // race restricted
        } // Rider is a creature
        oOb=GetMaster(oTarget);
        if (GetIsObjectValid(oOb)&&GetIsObjectValid(oRider))
        { // has master make sure is part of party
            if (oOb!=oRider&&oOb!=GetMaster(oRider)&&GetMaster(oOb)!=GetMaster(oRider))
            { // not part of party
                return FALSE;
            } // not part of party
        } // has master make sure is part of party
        if (GetLocalInt(oTarget,"X3_HORSE_NOT_RIDEABLE_OWNER"))
        { // not rideable due to owner
            return FALSE;
        } // not rideable due to owner
        if (GetLocalInt(GetArea(oTarget),"X3_NO_MOUNTING")&&!bAssignMount)
        { // no mounting allowed in this area
            return FALSE;
        } // no mounting allowed in this area
        sS=GetResRef(oTarget);
        if (GetStringLeft(sS,GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX&&GetIsObjectValid(oRider))
        { // paladin mount
            if (HorseGetOwner(oTarget)!=oRider) return FALSE;
        } // paladin mount
        if (!HorseGetIsAMount(oTarget)) return FALSE;
        return TRUE;
    } // valid oTarget type
    return FALSE;
} // HorseGetCanBeMounted()


string HorseGetMountFailureMessage(object oTarget,object oRider=OBJECT_INVALID)
{ // PURPOSE: This will return the error message
    int nAppearance;
    string sS;
    object oOb;
    if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
    { // valid oTarget type
        if (GetIsDead(oTarget)) return StringToRGBString(GetStringByStrRef(111993),STRING_COLOR_ROSE);
        if (GetIsPC(oTarget)) return StringToRGBString(GetStringByStrRef(111994),STRING_COLOR_ROSE);
        if (GetIsObjectValid(oRider)&&GetObjectType(oRider)!=OBJECT_TYPE_CREATURE) return StringToRGBString(GetStringByStrRef(111995),STRING_COLOR_ROSE);
        if (GetIsObjectValid(oRider)&&GetIsEnemy(oRider,oTarget)) return StringToRGBString(GetStringByStrRef(111996),STRING_COLOR_ROSE);
        if (GetIsDMPossessed(oTarget)) return StringToRGBString(GetStringByStrRef(111997),STRING_COLOR_ROSE);
        if (HorseGetIsMounted(oRider)) return StringToRGBString(GetStringByStrRef(111998),STRING_COLOR_ROSE);
        //if (GetIsObjectValid(oRider)&&GetCreatureTailType(oRider)!=CREATURE_TAIL_TYPE_NONE) return StringToRGBString(GetStringByStrRef(111998),STRING_COLOR_ROSE);
        nAppearance=GetAppearanceType(oRider);
        if (GetIsPC(oRider)&&nAppearance>6&&GetLocalInt(oRider,"X3_CUSTOM_RACE_APPEARANCE")!=nAppearance&&!Horse_SupportRaceAppearance(nAppearance)) return StringToRGBString(GetStringByStrRef(111999),STRING_COLOR_ROSE);
        if (GetIsObjectValid(oRider)&&GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
        { // Rider is a creature
            sS=HORSE_SupportRaceRestrictString(oRider);
            if (GetLocalInt(oTarget,sS)) return StringToRGBString(GetStringByStrRef(112000),STRING_COLOR_PINK);
        } // Rider is a creature
        oOb=GetMaster(oTarget);
        if (GetIsObjectValid(oOb)&&GetIsObjectValid(oRider))
        { // has master make sure is part of party
            if (oOb!=oRider&&GetMaster(oRider)!=oOb)
            { // not part of party
                return StringToRGBString(GetStringByStrRef(112001),STRING_COLOR_ROSE);
            } // not part of party
        } // has master make sure is part of party
        if (GetLocalInt(oTarget,"X3_HORSE_NOT_RIDEABLE_OWNER"))
        { // not rideable due to owner
            return StringToRGBString(GetStringByStrRef(112002),STRING_COLOR_PINK);
        } // not rideable due to owner
        if (GetLocalInt(GetArea(oTarget),"X3_NO_MOUNTING"))
        { // no mounting allowed in this area
            return StringToRGBString(GetStringByStrRef(112003),STRING_COLOR_PINK);
        } // no mounting allowed in this area
        sS=GetResRef(oTarget);
        if (GetStringLeft(sS,GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX&&GetIsObjectValid(oRider))
        { // paladin mount
            if (HorseGetOwner(oTarget)!=oRider) return StringToRGBString(GetStringByStrRef(112004),STRING_COLOR_PINK);
        } // paladin mount
        if (!HorseGetIsAMount(oTarget)) return StringToRGBString(GetStringByStrRef(112005),STRING_COLOR_PINK);
    } // valid oTarget type
    else
    {
        // The target is not a mount (as its not a creature).
        return StringToRGBString(GetStringByStrRef(112005),STRING_COLOR_ROSE);
    }
    return "";
} // HorseGetMountFailureMessage()


void HorseSetOwner(object oHorse,object oOwner,int bAssign=FALSE)
{ // PURPOSE: Set oHorse to be owned by oOwner
    object oPreviousOwner;
    string sName;
    int nHenchmen=HORSE_SupportCountHenchmen(oOwner);
    int nMax=GetLocalInt(GetModule(),"X3_HORSE_MAX_HENCHMEN");
    int bIncHenchmen=GetLocalInt(GetModule(),"X3_HORSE_NO_HENCHMAN_INCREASE");
    int nCurr=GetMaxHenchmen();
    if (GetObjectType(oHorse)==OBJECT_TYPE_CREATURE&&GetObjectType(oOwner)==OBJECT_TYPE_CREATURE)
    { // valid parameters
        //oPreviousOwner=GetMaster(oHorse);
        //if (oPreviousOwner==oOwner) return; // already is the owner
        if ((HorseGetCanBeMounted(oHorse,oOwner,TRUE)||GetIsPC(oOwner))&&!HorseGetIsAMount(oOwner))
        { // horse can be mounted
            oPreviousOwner=GetMaster(oHorse);
            if (oPreviousOwner!=oOwner)
            { // new owner
                if (GetObjectType(oPreviousOwner)==OBJECT_TYPE_CREATURE)
                { // remove as henchman from previous owner
                    RemoveHenchman(oPreviousOwner,oHorse);
                    if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsPC(oPreviousOwner)) SetLocalInt(oPreviousOwner,"bX3_STORE_MOUNT_INFO",TRUE);
                } // remove as henchman from previous owner
                if (nHenchmen==nCurr)
                { // see if increase possible
                    if (!bIncHenchmen)
                    { // increase is permissable
                        if (nMax==0||nMax>0)
                        { // do the increase
                            SetMaxHenchmen(nCurr+1);
                        } // do the increase
                    } // increase is permissable
                } // see if increase possible
                AssignCommand(oHorse,ClearAllActions());
                AddHenchman(oOwner,oHorse);
                SetLocalObject(oHorse,"oX3_HorseOwner",oOwner);
                //AssignCommand(oHorse,SetAssociateState(NW_ASC_DISTANCE_6_METERS,TRUE));
                DelayCommand(1.0,SetAssociateState(NW_ASC_DISTANCE_6_METERS,TRUE,oHorse));
                if (bAssign) SetLocalObject(oOwner,"oAssignedHorse",oHorse);
            } // new owner
            else
            { // make sure variables on oHorse are correct
                SetLocalObject(oHorse,"oX3_HorseOwner",oOwner);
                //AssignCommand(oHorse,SetAssociateState(NW_ASC_DISTANCE_6_METERS,TRUE));
                SetAssociateState(NW_ASC_DISTANCE_6_METERS,TRUE,oHorse);
                if (bAssign) SetLocalObject(oOwner,"oAssignedHorse",oHorse);
                if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsPC(oOwner)) SetLocalInt(oOwner,"bX3_STORE_MOUNT_INFO",TRUE);
            } // make sure variables on oHorse are correct
            sName=GetLocalString(oHorse,"sX3_OriginalName");
            if (GetStringLength(sName)<1)
            { // define original name
                sName=GetName(oHorse);
                SetLocalString(oHorse,"sX3_OriginalName",sName);
            } // define original name
            if (GetMaster(oHorse)==oOwner)
            { // was set okay
                if (GetStringLowerCase(GetStringRight(GetName(oOwner),1))=="s"||GetStringLowerCase(GetStringRight(GetName(oOwner),1))=="z")
                  SetName(oHorse,GetName(oOwner)+"' "+sName);
                else { SetName(oHorse,GetName(oOwner)+"'s "+sName); }
            } // was set okay
        } // horse can be mounted
        else
        { // not valid
            if (GetIsPC(oOwner))
            { // PC
                PrintString("X3 HORSE ERROR: Attempt made to set "+GetName(oOwner)+" as owner of "+GetName(oHorse)+" is an invalid assignment.");
            } // PC
            else
            { // error
                PrintString("X3 HORSE ERROR: Attempt made to set "+GetName(oOwner)+" as owner of "+GetName(oHorse)+" is an invalid assignment.");
            } // error
        } // not valid
    } // valid parameters
} // HorseSetOwner()


void HorseRemoveOwner(object oHorse)
{ // PURPOSE: Remove the owner from oHorse
    object oOwner;
    string sString;
    if (GetObjectType(oHorse)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        oOwner=GetLocalObject(oHorse,"oX3_HorseOwner");
        if (GetObjectType(oOwner)==OBJECT_TYPE_CREATURE)
        { // owner found
            if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsPC(oOwner)) SetLocalInt(oOwner,"bX3_STORE_MOUNT_INFO",TRUE);
            sString=GetResRef(oHorse);
            // do not allow removing paladin horses from owner
            if (GetStringLeft(sString,GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX) return;
            if (GetMaster(oHorse)==oOwner) RemoveHenchman(oOwner,oHorse);
            DeleteLocalObject(oHorse,"oX3_HorseOwner");
            if (oHorse==GetLocalObject(oOwner,"oAssignedHorse"))
            {
                DeleteLocalObject(oOwner,"oAssignedHorse");
                HORSE_Support_AssignRemainingMount(oOwner);
            }
        } // owner found
    } // valid parameter
    sString=GetLocalString(oHorse,"sX3_OriginalName");
    if (GetStringLength(sString)>0) SetName(oHorse,sString);
} // HorseRemoveOwner()


object HorseGetOwner(object oHorse)
{ // PURPOSE: Return who the owner of oHorse is or return OBJECT_INVALID
    object oOwner;
    if (GetObjectType(oHorse)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        oOwner=GetLocalObject(oHorse,"oX3_HorseOwner");
        if (GetObjectType(oOwner)==OBJECT_TYPE_CREATURE) return oOwner;
    } // valid parameter
    return OBJECT_INVALID;
} // HorseGetOwner()


void HorseAddHorseMenu(object oPC)
{ // PURPOSE: Add Horse Menu to the PC
    object oSkin=SKIN_SupportGetSkin(oPC);
    itemproperty iProp;
    if (GetIsPC(oPC))
    { // valid parameter
        iProp=ItemPropertyBonusFeat(IP_CONST_HORSE_MENU);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oSkin);
    } // valid parameter
} // HorseAddHorseMenu()


void HorseSetPhenotype(object oRider,int bJoust=FALSE)
{ // PURPOSE: To set the proper phenotype for oRider when mounted
    int nCurrent=GetPhenoType(oRider);
    int nPheno=-1;
    if (bJoust)
    { // jousting
        if (GetLocalInt(oRider,"X3_CUSTOM_RACE_JOUST_PHENO")>0) nPheno=GetLocalInt(oRider,"X3_CUSTOM_RACE_JOUST_PHENO");
        else if (nCurrent==PHENOTYPE_NORMAL||nCurrent==HORSE_PHENOTYPE_MOUNTED_N) nPheno=HORSE_PHENOTYPE_JOUSTING_N;
        else if (nCurrent==PHENOTYPE_BIG||nCurrent==HORSE_PHENOTYPE_MOUNTED_L) nPheno=HORSE_PHENOTYPE_JOUSTING_L;
    } // jousting
    else
    { // not jousting
        if (GetLocalInt(oRider,"X3_CUSTOM_RACE_MOUNTED_PHENO")>0) nPheno=GetLocalInt(oRider,"X3_CUSTOM_RACE_MOUNTED_PHENO");
        else if (nCurrent==PHENOTYPE_NORMAL||nCurrent==HORSE_PHENOTYPE_JOUSTING_N) nPheno=HORSE_PHENOTYPE_MOUNTED_N;
        else if (nCurrent==PHENOTYPE_BIG||nCurrent==HORSE_PHENOTYPE_JOUSTING_L) nPheno=HORSE_PHENOTYPE_MOUNTED_L;
    } // not jousting
    if (nPheno!=-1) SetPhenoType(nPheno,oRider);
} // HorseSetPhenotype()


int HorseGetIsDisabled(object oCreature)
{ // PURPOSE: blocked path, death, entanglement, confusion, paralysis, stun, petrification, fear, turned, sleep, knockdown detection by Azbest
    int bDisabled=FALSE;
    if (GetIsDead(oCreature)||GetLocalInt(oCreature,"bPathIsBlocked"))
    {
        bDisabled=TRUE;
    }
    else
    {
        effect eEffect=GetFirstEffect(oCreature);
        while(GetIsEffectValid(eEffect)&&!bDisabled)
        { // traverse effects
            if ((GetEffectType(eEffect)==EFFECT_TYPE_INVALIDEFFECT&&(GetEffectDurationType(eEffect)==DURATION_TYPE_TEMPORARY||GetEffectDurationType(eEffect)==DURATION_TYPE_PERMANENT))||
                 GetEffectType(eEffect)==EFFECT_TYPE_ENTANGLE||
                 GetEffectType(eEffect)==EFFECT_TYPE_CONFUSED||
                 GetEffectType(eEffect)==EFFECT_TYPE_PARALYZE||
                 GetEffectType(eEffect)==EFFECT_TYPE_STUNNED||
                 GetEffectType(eEffect)==EFFECT_TYPE_PETRIFY||
                 GetEffectType(eEffect)==EFFECT_TYPE_FRIGHTENED||
                 GetEffectType(eEffect)==EFFECT_TYPE_TURNED||
                 GetEffectType(eEffect)==EFFECT_TYPE_SLEEP)
            { // match
                bDisabled=TRUE;
            } // match
            eEffect=GetNextEffect(oCreature);
        } // traverse effects
    }
    return bDisabled;
} // HorseGetIsDisabled()


void HorseMount(object oHorse,int bAnimate=TRUE,int bInstant=FALSE,int nState=0)
{ // PURPOSE: Handle the mounting of oHorse
  // 0 = Initial state
  // 1 = move to horse
  // 2 = adjust for animation
  // 3 = animate
  // 4 = store horse and premount info
  // 5 = set appearances
  // 6 = destroy oHorse
    object oRider=OBJECT_SELF;
    float fMonitorSpeed=0.4f;
    float fDenominator=3.0; // fraction denominator used to calculate synchronised timing of the process that runs concurently with animation
    string sS;
    string sTag;
    string sResRef;
    int nApp,nTail,nPheno,nN;
    location lLoc;
    float fF;
    object oOb;
    int nStoredState=GetLocalInt(oRider,"nX3_StoredMountState");
    int bPostMount=FALSE;
    float fTimeDelay; // used to hold delay common references and reduce some repeated math
    int bAct=GetLocalInt(GetModule(),"X3_HORSE_ACT_VS_DELAY");
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_MOUNT_MULTIPLE");
    float fX3_TIMEOUT_TO_MOUNT=GetLocalFloat(GetModule(),"fX3_TIMEOUT_TO_MOUNT");
    if (GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE")>fX3_MOUNT_MULTIPLE) fX3_MOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE");
    if (fX3_MOUNT_MULTIPLE<=0.0) fX3_MOUNT_MULTIPLE=1.0;
    if (GetLocalFloat(oRider,"fX3_TIMEOUT_TO_MOUNT")!=0.0) fX3_TIMEOUT_TO_MOUNT=GetLocalFloat(oRider,"fX3_TIMEOUT_TO_MOUNT");
    if (fX3_TIMEOUT_TO_MOUNT<6.0) fX3_TIMEOUT_TO_MOUNT=18.0;
    if (GetStringLength(GetLocalString(oHorse,"X3_HORSE_POSTMOUNT_SCRIPT"))>0) bPostMount=TRUE;
    if (HorseGetIsDisabled()) return; // drop out if disabled
    if (GetObjectType(oHorse)!=OBJECT_TYPE_CREATURE) return;
    if (GetIsInCombat(oRider)||GetIsInCombat(oHorse)||IsInConversation(oRider)) return;
    if (nState!=0&&nStoredState>nState) return; // abort recursion of this state
    switch(nState)
    { // main mounting switch
        case 0:
        { // ----- 0 - Initial State
            DeleteLocalInt(oRider,"nX3_StoredMountState");
            if (!HorseGetCanBeMounted(oHorse,oRider))
            { // not mountable
                if (GetIsPC(oRider))
                { // provide error message
                    FloatingTextStrRefOnCreature(111983,oRider,FALSE);
                } // provide error message
                return;
            } // not mountable
            if (GetDistanceBetween(oHorse,oRider)>20.0)
            { // too far
                ClearAllActions();
                ActionMoveToObject(oHorse,TRUE,15.0);
                return;
            } // too far
            sS=GetLocalString(oHorse,"X3_HORSE_PREMOUNT_SCRIPT");
            if (GetStringLength(sS)>0)
            { // premount script
                SetLocalObject(oRider,"oX3_TempHorse",oHorse);
                ExecuteScript(sS,oRider);
                if (GetLocalInt(oHorse,"X3_HORSE_NOMOUNT"))
                { // no mount set
                    DeleteLocalInt(oHorse,"X3_HORSE_NOMOUNT");
                    return;
                } // no mount set
            } // premount script
            SetLocalInt(oHorse,"X3_DOING_HORSE_ACTION",TRUE);
            SetLocalInt(oRider,"X3_DOING_HORSE_ACTION",TRUE);
            if (bAct)
            { // make sure horse action can be cancelled if actions cancelled
                fTimeDelay=8.0*fX3_MOUNT_MULTIPLE;
                DelayCommand(fTimeDelay,DeleteLocalInt(oHorse,"X3_DOING_HORSE_ACTION"));
                DelayCommand(fTimeDelay,DeleteLocalInt(oRider,"X3_DOING_HORSE_ACTION"));
            } // make sure horse action can be cancelled if actions cancelled
            SetSkinInt(oRider,"nX3_StoredFootstep",GetFootstepType(oRider));
            SetSkinInt(oRider,"nX3_HorseRiderPhenotype",GetPhenoType(oRider));
            SetLocalInt(oRider,"X3_HORSE_TAIL",HorseGetMountTail(oHorse));
            SetSkinInt(oRider,"nX3_HorseRiderAppearance",GetAppearanceType(oRider));
            SetSkinInt(oRider,"nX3_HorseTail",GetCreatureTailType(oHorse));
            SetSkinInt(oRider,"nX3_HorseAppearance",GetAppearanceType(oHorse));
            SetLocalInt(oRider,"nX3_HorsePortrait",GetPortraitId(oHorse));
            SetLocalInt(oRider,"nX3_RiderHP",GetCurrentHitPoints(oRider));
            SetSkinInt(oRider,"nX3_HorseHP",GetCurrentHitPoints(oHorse));
            SetSkinInt(oRider,"nX3_HorseRiderTail",GetCreatureTailType(oRider));
            SetLocalInt(oRider,"bX3_IS_RIDER",TRUE);
            if (!GetIsPC(oRider))
            { // not a PC - set associate state
                SetAssociateState(NW_ASC_IS_BUSY,TRUE,oRider);
            } // not a PC - set associate state
            AssignCommand(oHorse,ClearAllActions(TRUE));
            fTimeDelay=(fX3_TIMEOUT_TO_MOUNT+HORSE_MOUNT_DURATION)*fX3_MOUNT_MULTIPLE;
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneImmobilize(),oHorse,fTimeDelay);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneGhost(),oHorse,fTimeDelay);
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")&&!bAct) AssignCommand(GetModule(),DelayCommand(2.0,HORSE_SupportSetMountingSentinel(oRider,oHorse,fX3_TIMEOUT_TO_MOUNT)));
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")&&!bAct) SetCommandable(FALSE,oHorse);
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")&&!bAct) SetCommandable(FALSE,oRider);
            fTimeDelay=fMonitorSpeed*fX3_MOUNT_MULTIPLE;
            SetLocalFloat(oRider,"X3_TOTAL_MOUNT_ANIMATION_DELAY",fDenominator*fTimeDelay); // sets a small time delay so that the following code doesnt happen at once
            if (!bAnimate&&bInstant)
            { // rapid mount
                DelayCommand(fTimeDelay,HorseMount(oHorse,bAnimate,bInstant,4));
            } // rapid mount
            else
            { // move
                if (!bAct)
                { // not actions
                    DelayCommand(fTimeDelay,HorseMount(oHorse,bAnimate,bInstant,1));
                } // not actions
                else
                { // use actions - interruptable
                    ClearAllActions();
                    ActionMoveToObject(oHorse,TRUE,1.5);
                    ActionDoCommand(HorseMount(oHorse,bAnimate,bInstant,1));
                } // use actions - interruptable
            } // move
            break;
        } // ----- 0 - Initial State
        case 1:
        { // ----- 1 - Move To Horse
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")&&GetCommandable(oHorse)&&!bAct) SetCommandable(FALSE,oHorse);
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")&&GetCommandable(oRider)&&!bAct) SetCommandable(FALSE,oRider);
            oOb=GetLocalObject(oHorse,"oX3_TempRider");
            if (oOb!=oRider&&GetIsObjectValid(oOb))
            { // someone else is mounting that
                if (GetIsPC(oRider))
                { // someone else mounting
                    FloatingTextStringOnCreature(GetName(oOb)+GetStringByStrRef(111984),oRider,FALSE);
                } // someone else mounting
                DeleteLocalInt(oRider,"X3_DOING_HORSE_ACTION");
                if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")&&!bAct) SetCommandable(TRUE,oRider);
                return;
            } // someone else is mounting that
            SetLocalObject(oHorse,"oX3_TempRider",oRider);
            lLoc=HORSE_SupportGetMountLocation(oHorse,oRider,-90.0);
            if (GetLocalInt(GetArea(oRider),"bX3_MOUNT_NO_ZAXIS")||GetLocalInt(GetModule(),"bX3_MOUNT_NO_ZAXIS")||GetLocalInt(oRider,"bX3_MOUNT_NO_ZAXIS"))
            { // use vector without z axis - thanks Azbest
                vector vLoc=GetPositionFromLocation(lLoc);
                vector vRider=GetPosition(oRider);
                vLoc-=Vector(0.0,0.0,vLoc.z);
                vRider-=Vector(0.0,0.0,vRider.z);
                fF=VectorMagnitude(vLoc-vRider);
            } // use vector without z axis - thanks Azbest
            else
            { // use location including Z axis
                fF=GetDistanceBetweenLocations(GetLocation(oRider),lLoc);
            } // use location including Z axis
            fMonitorSpeed=GetLocalFloat(GetModule(),"fX3_FREQUENCY");
            if (fMonitorSpeed<0.5||fMonitorSpeed>9.0) fMonitorSpeed=1.0; // frequency
            fTimeDelay=fMonitorSpeed*fX3_MOUNT_MULTIPLE;
            if (fX3_TIMEOUT_TO_MOUNT<fTimeDelay) fX3_TIMEOUT_TO_MOUNT=fTimeDelay;
            if (fF>0.1&&GetLocalInt(oRider,"nX3_MovingMount")<=FloatToInt(fX3_TIMEOUT_TO_MOUNT/fTimeDelay))
            { // keep moving
                nN=GetLocalInt(oRider,"nX3_MovingMount");
                nN++; // used to support timing out if cannot reach destination
                SetLocalInt(oRider,"nX3_MovingMount",nN);
                if (nN>FloatToInt(fX3_TIMEOUT_TO_MOUNT/fTimeDelay))
                { // timed out
                    if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE"))
                    {
                        SetCommandable(TRUE,oRider);
                        ClearAllActions();
                        ActionWait(X3_ACTION_DELAY*fX3_MOUNT_MULTIPLE);
                        ActionJumpToLocation(lLoc);
                        SetCommandable(FALSE,oRider);
                    }
                    bAnimate=FALSE;
                } // timed out
                else
                { // keep trying
                    if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE"))
                    {
                        SetCommandable(TRUE,oRider);
                        ClearAllActions();
                        ActionMoveToLocation(lLoc,TRUE);
                        SetCommandable(FALSE,oRider);
                    }
                    SetLocalInt(oRider,"nX3_StoredMountState",1);
                    float fLastHorseDist=GetDistanceBetween(oRider,oHorse);
                    if (fLastHorseDist==GetLocalFloat(oRider,"fLastHorseDist"))
                    {
                        if (GetLocalInt(GetArea(oRider),"X3_ABORT_WHEN_STUCK")||GetLocalInt(oHorse,"X3_ABORT_WHEN_STUCK"))
                        { // break next call if we are found twice within the same distance from horse, which means we are stuck
                            SetLocalInt(oRider,"bPathIsBlocked",TRUE);
                            SetLocalInt(oRider,"nX3_StoredMountState",2);
                        } // break next call if we are found twice within the same distance from horse, which means we are stuck
                        else
                        { // if we are stuck, we want to mount
                            // no need to set bPathIsBlocked flag, because forced mount continues the proper chain of commands
                            SetLocalInt(oRider,"nX3_MovingMount",FloatToInt(fX3_TIMEOUT_TO_MOUNT/fTimeDelay)+1);
                        } // if we are stuck, we want to mount
                    }
                    SetLocalFloat(oRider,"fLastHorseDist",fLastHorseDist);
                } // keep trying
                DelayCommand(fTimeDelay,HorseMount(oHorse,bAnimate,bInstant,1));
            } // keep moving
            else
            { // next state
                DeleteLocalInt(oRider,"nX3_MovingMount");
                DeleteLocalFloat(oRider,"fLastHorseDist");
                if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE"))
                {
                    SetCommandable(TRUE,oRider);
                    ClearAllActions();
                    SetFacing(GetFacing(oHorse));
                    SetCommandable(FALSE,oRider);
                }
                if (bAnimate&&!GetLocalInt(oHorse,"X3_NO_MOUNT_ANIMATE"))
                { // see about animate
                    DelayCommand(0.1*fX3_MOUNT_MULTIPLE,HorseMount(oHorse,bAnimate,bInstant,2));
                } // see about animate
                else
                { // no animate
                    DelayCommand(0.1*fX3_MOUNT_MULTIPLE,HorseMount(oHorse,bAnimate,bInstant,4));
                } // no animate
            } // next state
            break;
        } // ----- 1 - Move to Horse
        case 2:
        { // ----- 2 - Adjust for Animation
            SetLocalInt(oRider,"nX3_StoredMountState",3);
            nTail=GetLocalInt(oRider,"X3_HORSE_TAIL");
            SetLocalInt(oHorse,"X3_HORSE_TAIL",nTail);
            nApp=HORSE_SupportNullAppearance(oHorse,oRider);
            if (nApp>0) SetCreatureAppearanceType(oHorse,nApp);
            SetCreatureTailType(nTail,oHorse);
            DelayCommand(1.0*fX3_MOUNT_MULTIPLE,HorseMount(oHorse,bAnimate,bInstant,3)); // 1.0 second seems to be long enough to set up for animation
            break;
        } // ----- 2 - Adjust for Animation
        case 3:
        { // ----- 3 - Animate
            SetLocalInt(oRider,"nX3_StoredMountState",4);
            fMonitorSpeed=HORSE_MOUNT_DURATION;
            if (GetLocalFloat(oHorse,"X3_HORSE_MOUNT_DURATION")>0.0) fMonitorSpeed=GetLocalFloat(oHorse,"X3_HORSE_MOUNT_DURATION");
            if (fMonitorSpeed<1.0) fMonitorSpeed=1.0;
            fMonitorSpeed*=fX3_MOUNT_MULTIPLE;
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneGhost(),oHorse,fMonitorSpeed+0.5);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneGhost(),oRider,fMonitorSpeed+0.5);
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE"))
            {
                SetCommandable(TRUE,oRider);
                ClearAllActions();
                ActionPlayAnimation(HORSE_ANIMATION_MOUNT,1.0,fMonitorSpeed);
                SetCommandable(FALSE,oRider);
            }
            SetLocalFloat(oRider,"X3_TOTAL_MOUNT_ANIMATION_DELAY",fMonitorSpeed);  // "case 4:" and "case 5:" need to happen concurrently and with the same time duration as the animation itself :)
            HorseMount(oHorse,bAnimate,bInstant,4);
            break;
        } // ----- 3 - Animate
        case 4:
        { // ----- 4 - Store Horse and Premount Info
            SetLocalInt(oRider,"nX3_StoredMountState",5);
            sResRef=GetResRef(oHorse);
            if (GetStringLength(sResRef)<1) SendMessageToPC(oRider,"x3_inc_horse(HorseMount): Error finding horse ResRef in case 4.");
            SetSkinString(oRider,"sX3_HorseResRef",sResRef);
            SetSkinString(oRider,"sX3_HorseMountTag",GetTag(oHorse));
            SetLocalString(oRider,"sX3_HorseMountScript",GetLocalString(oHorse,"sX3_HORSE_CREATED_SCRIPT"));
            SetSkinString(oRider,"X3_HORSE_PREDISMOUNT_SCRIPT",GetLocalString(oHorse,"X3_HORSE_PREDISMOUNT_SCRIPT"));
            SetSkinString(oRider,"X3_HORSE_POSTDISMOUNT_SCRIPT",GetLocalString(oHorse,"X3_HORSE_POSTDISMOUNT_SCRIPT"));
            SetLocalInt(oRider,"X3_NO_MOUNT_ANIMATE",GetLocalInt(oHorse,"X3_NO_MOUNT_ANIMATE"));
            if (GetLocalInt(oHorse,"X3_ABORT_WHEN_STUCK")) SetLocalInt(oRider,"X3_ABORT_WHEN_STUCK",TRUE);
            if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS"))
            { // saddlebags support enabled
                if (GetLocalInt(oHorse,"bX3_HAS_SADDLEBAGS")&&GetLocalObject(oHorse,"oX3_HorseOwner")!=oRider) if (GetMaster(oHorse)!=oRider) HorseSetOwner(oHorse,oRider,TRUE);
                SetLocalInt(oRider,"bX3_HAS_SADDLEBAGS",GetLocalInt(oHorse,"bX3_HAS_SADDLEBAGS"));
                if (GetLocalInt(oHorse,"bX3_HAS_SADDLEBAGS"))
                { // transfer inventory
                    HorseStoreInventory(oHorse,oRider);
                } // transfer inventory
            } // saddlebads support enabled
            fMonitorSpeed=GetLocalFloat(oRider,"X3_TOTAL_MOUNT_ANIMATION_DELAY")*(fDenominator-1.0)/fDenominator;
            DelayCommand(fMonitorSpeed,HorseMount(oHorse,bAnimate,bInstant,5));
            break;
        } // ----- 4 - Store Horse and Premount Info
        case 5:
        { // ----- 5 - Set Appearance
            SetLocalInt(oRider,"nX3_StoredMountState",6);
            nApp=GetAppearanceType(oHorse);
            nTail=GetLocalInt(oRider,"X3_HORSE_TAIL");
            SetCreatureAppearanceType(oRider,HORSE_SupportGetMountedAppearance(oRider));
            HorseSetPhenotype(oRider);
            SetCreatureTailType(nTail,oRider);
            nApp=GetLocalInt(oHorse,"X3_HORSE_FOOTSTEP");
            if (nApp>0) SetFootstepType(nApp,oRider);
            else { SetFootstepType(HORSE_FOOTSTEP_SOUND,oRider); }
            fMonitorSpeed=GetLocalFloat(oRider,"X3_TOTAL_MOUNT_ANIMATION_DELAY")/fDenominator;
            if (!bAnimate||bInstant) fTimeDelay=fMonitorSpeed;
            else fTimeDelay=0.6; //  changing appearance, pheno and tail takes about 0.6 second, hide the horse after that amount of time
            DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY),oHorse,fMonitorSpeed*fDenominator));
            DelayCommand(fMonitorSpeed,HorseMount(oHorse,bAnimate,bInstant,6));
            break;
        } // ----- 5 - Set Appearance
        case 6:
        { // ----- 6 - Destroy oHorse
            SetLocalInt(oRider,"nX3_StoredMountState",7);
            SetSkinInt(oRider,"bX3_IS_MOUNTED",TRUE);
            SetLocalObject(oRider,"oX3_Saddlebags",GetLocalObject(oHorse,"oX3_Saddlebags"));
            sS=GetLocalString(oHorse,"X3_HORSE_POSTMOUNT_SCRIPT");
            if (bPostMount)
            { // run post mount script
                SetLocalObject(oRider,"oX3_TempHorse",oHorse);
                ExecuteScript(sS,oRider);
                DeleteLocalObject(oRider,"oX3_TempHorse");
                DeleteLocalInt(oRider,"bX3_HORSE_MODIFIERS");
            } // run post mount script
            else
            { // no post mount script
                HORSE_SupportIncreaseSpeed(oRider,oHorse);
                HORSE_SupportAdjustMountedArcheryPenalty(oRider);
                DelayCommand(0.4,HORSE_SupportApplyMountedSkillDecreases(oRider));
                HORSE_SupportApplyACBonus(oRider,oHorse);
                HORSE_SupportApplyHPBonus(oRider,oHorse);
            } // no post mount script
            SetLocalInt(oRider,"bX3_HORSE_MODIFIERS",TRUE);
            if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")) SetLocalInt(oRider,"bX3_STORE_MOUNT_INFO",TRUE);
            DeleteLocalFloat(oRider,"X3_TOTAL_MOUNT_ANIMATION_DELAY");
            AssignCommand(oHorse,SetIsDestroyable(TRUE,FALSE,FALSE));
            DestroyObject(oHorse,0.3);
            DelayCommand(0.5*fX3_MOUNT_MULTIPLE,DeleteLocalInt(oRider,"X3_DOING_HORSE_ACTION"));
            if (!GetIsPC(oRider))
            { // not a PC - set associate state
                DelayCommand(0.5*fX3_MOUNT_MULTIPLE,SetAssociateState(NW_ASC_IS_BUSY,FALSE,oRider));
            } // not a PC - set associate state
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")) DelayCommand(0.5*fX3_MOUNT_MULTIPLE,SetCommandable(TRUE,oRider));
            break;
        } // ----- 6 - Destroy oHorse
        default: break;
    } // main mounting switch
} // HorseMount()


object HorseDismount(int bAnimate=TRUE,int bSetOwner=TRUE)
{ // PURPOSE: Dismount the horse
    object oRider=OBJECT_SELF;
    object oHorse=OBJECT_INVALID;
    object oOb;
    string sS,sRR,sT;
    int nN,nApp,nTail,nFootstep;
    int bPostDismount=FALSE;
    location lLoc;
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_MOUNT_MULTIPLE");
    float fX3_DISMOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_DISMOUNT_MULTIPLE");
    if (GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE")>fX3_MOUNT_MULTIPLE) fX3_MOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE");
    if (fX3_MOUNT_MULTIPLE<=0.0) fX3_MOUNT_MULTIPLE=1.0;
    if (GetLocalFloat(oRider,"fX3_DISMOUNT_MULTIPLE")>0.0) fX3_DISMOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_DISMOUNT_MULTIPLE");
    if (fX3_DISMOUNT_MULTIPLE>0.0) fX3_MOUNT_MULTIPLE=fX3_DISMOUNT_MULTIPLE; // use dismount multiple instead of mount multiple
    float fDelay=1.0*fX3_MOUNT_MULTIPLE; // base delay for non-animated dismount
    if (GetStringLength(GetLocalString(oHorse,"X3_HORSE_POSTDISMOUNT_SCRIPT"))>0) bPostDismount=TRUE;
    if (GetIsObjectValid(oRider))
    { // oRider is a valid object
        if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")) SetCommandable(FALSE,oRider);
        if (HorseGetIsMounted(oRider))
        { // Mounted
            if (!GetIsPC(oRider))
            { // not PC - set associate state busy
                SetAssociateState(NW_ASC_IS_BUSY,TRUE,oRider);
            } // not PC - set associate state busy
            sS=GetSkinString(oRider,"X3_HORSE_PREDISMOUNT_SCRIPT");
            if (GetStringLength(sS)>0)
            { // PREDISMOUNT SCRIPT
                ExecuteScript(sS,oRider);
                if (GetLocalInt(oRider,"X3_HORSE_NOMOUNT"))
                { // abort
                    DeleteLocalInt(oRider,"X3_HORSE_NOMOUNT");
                    return OBJECT_INVALID;
                } // abort
            } // PREDISMOUNT SCRIPT
            DeleteSkinString(oRider,"X3_HORSE_PREDISMOUNT_SCRIPT");
            SetLocalInt(oRider,"X3_DOING_HORSE_ACTION",TRUE);
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE"))
            {
                SetCommandable(TRUE,oRider);
                ClearAllActions();
                SetCommandable(FALSE,oRider);
            }
            if (bAnimate&&!GetLocalInt(oRider,"X3_NO_MOUNT_ANIMATE"))
            { // animated dismount
                if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE"))
                {
                    SetCommandable(TRUE,oRider);
                    ActionWait(X3_ACTION_DELAY*fX3_MOUNT_MULTIPLE);
                    ActionPlayAnimation(HORSE_ANIMATION_DISMOUNT,1.0,HORSE_DISMOUNT_DURATION*fX3_MOUNT_MULTIPLE);
                    SetCommandable(FALSE,oRider);
                }
                fDelay=(X3_ACTION_DELAY+HORSE_DISMOUNT_DURATION)*fX3_MOUNT_MULTIPLE; // delay for animated dismount
            }
            sRR=GetSkinString(oRider,"sX3_HorseResRef");
            if (GetStringLength(sRR)>0)
            { // create dismounted horse
                if (bSetOwner) oOb=oRider;
                sT=GetSkinString(oRider,"sX3_HorseMountTag");
                nApp=GetSkinInt(oRider,"nX3_HorseAppearance");
                nTail=GetSkinInt(oRider,"nX3_HorseTail"); // add this to be preserved
                if (nApp<7) nApp=-1;
                if (nTail<3) nTail=-1;
                if (nFootstep<2) nFootstep=-1;
                nFootstep=GetFootstepType(oRider);
                sS=GetLocalString(oRider,"sX3_HorseMountScript");
                lLoc=HORSE_SupportGetMountLocation(oRider,oRider,-90.0);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneGhost(),oRider,fDelay+1.0*fX3_MOUNT_MULTIPLE);
                oHorse=HorseCreateHorse(sRR,GetLocation(oRider),oOb,sT,nApp,nTail,nFootstep,sS);
                SetLocalInt(oHorse,"X3_DOING_HORSE_ACTION",TRUE);
                if (GetLocalInt(oRider,"X3_ABORT_WHEN_STUCK")) SetLocalInt(oHorse,"X3_ABORT_WHEN_STUCK",TRUE);
                if (!GetIsObjectValid(oHorse))
                { // failed to create
                    SendMessageToPC(oRider,"x3_inc_horse(HorseDismount): Failed to create horse.");
                } // failed to create
                if (oOb==oRider) SetLocalObject(oRider,"oAssignedHorse",oHorse);
                if (GetLocalInt(oRider,"nX3_HorsePortrait")>0) SetPortraitId(oHorse,GetLocalInt(oRider,"nX3_HorsePortrait"));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY),oHorse,fDelay+0.5*fX3_MOUNT_MULTIPLE);
                if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS")&&GetIsObjectValid(oHorse))
                { // saddlebags support enabled
                    SetLocalInt(oHorse,"bX3_HAS_SADDLEBAGS",GetLocalInt(oRider,"bX3_HAS_SADDLEBAGS"));
                    if (GetLocalInt(oRider,"bX3_HAS_SADDLEBAGS"))
                    { // transfer contents
                        HorseRestoreInventory(oHorse);
                    } // transfer contents
                } // saddlebads support enabled
            } // create dismounted horse
            else
            { // resref not defined
                SendMessageToPC(oRider,"x3_inc_horse(HorseDismount): Error resref missing.");
            } // resref not defined
            DeleteSkinInt(oRider,"bX3_IS_MOUNTED");
            if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")) SetLocalInt(oRider,"bX3_STORE_MOUNT_INFO",TRUE);
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE"))
            {
                SetCommandable(TRUE,oRider);
                if (!bAnimate||GetLocalInt(oRider,"X3_NO_MOUNT_ANIMATE")) ActionWait(fDelay);
                ActionMoveToLocation(lLoc,FALSE);
                SetCommandable(FALSE,oRider);
            }
            DelayCommand(fDelay-0.8*fX3_MOUNT_MULTIPLE,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneGhost(),oHorse,1.7*fX3_MOUNT_MULTIPLE));
            //DelayCommand(fDelay-0.8*fX3_MOUNT_MULTIPLE+1.7*fX3_MOUNT_MULTIPLE, FloatingTextStringOnCreature("ghost off",oRider)); // this tells us when the ghost effect from the above line wears off
            DelayCommand(fDelay-0.7*fX3_MOUNT_MULTIPLE,HORSE_SupportResetUnmountedAppearance(oRider)); // keep in mind: changing mounted appearances takes about 0.6 seconds
            DelayCommand(fDelay+0.0*fX3_MOUNT_MULTIPLE,HORSE_SupportTransferPreservedValues(oRider,oHorse));
            DelayCommand(fDelay+0.7*fX3_MOUNT_MULTIPLE,HORSE_SupportCleanVariables(oRider));
            DelayCommand(fDelay+1.0*fX3_MOUNT_MULTIPLE,DeleteLocalInt(oRider,"X3_DOING_HORSE_ACTION"));
            DelayCommand(fDelay+1.0*fX3_MOUNT_MULTIPLE,DeleteLocalInt(oHorse,"X3_DOING_HORSE_ACTION"));
            if (!GetIsPC(oRider))
            { // not PC - set associate state not busy
                DelayCommand(fDelay+1.0*fX3_MOUNT_MULTIPLE,SetAssociateState(NW_ASC_IS_BUSY,FALSE,oRider));
            } // not PC - set associate state not busy
            if (!GetLocalInt(GetModule(),"X3_NO_MOUNT_COMMANDABLE")) DelayCommand(fDelay+1.0*fX3_MOUNT_MULTIPLE,SetCommandable(TRUE,oRider));
        } // Mounted
    } // oRider is a valid object
    return oHorse;
} // HorseDismount()


int HorseGetMountTail(object oHorse)
{ // PURPOSE: Determine the tail that is needed to represent this horse
    int nTail=GetCreatureTailType(oHorse);
    int nApp=GetAppearanceType(oHorse);
    if (GetLocalInt(oHorse,"X3_HORSE_TAIL")>0) return GetLocalInt(oHorse,"X3_HORSE_TAIL");
    if (nApp>=HORSE_APPEARANCE_OFFSET&&nApp<=HORSE_APPEARANCE_OFFSET+HORSE_NUMBER_OF_HORSES)
    { // default horses
        return (nApp-HORSE_APPEARANCE_OFFSET)+HORSE_TAIL_OFFSET;
    } // default horses
    else if (nApp>=HORSE_NULL_RACE_DWARF&&nApp<=HORSE_NULL_RACE_HUMAN) return nTail;
    return CREATURE_TAIL_TYPE_NONE;
} // HorseGetMountTail()


void HorseInstantDismount(object oRider)
{ // PURPOSE: Instantly dismount oRider
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_MOUNT_MULTIPLE");
    float fX3_DISMOUNT_MULTIPLE=GetLocalFloat(GetArea(oRider),"fX3_DISMOUNT_MULTIPLE");
    if (GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE")>fX3_MOUNT_MULTIPLE) fX3_MOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_MOUNT_MULTIPLE");
    if (fX3_MOUNT_MULTIPLE<=0.0) fX3_MOUNT_MULTIPLE=1.0;
    if (GetLocalFloat(oRider,"fX3_DISMOUNT_MULTIPLE")>0.0) fX3_DISMOUNT_MULTIPLE=GetLocalFloat(oRider,"fX3_DISMOUNT_MULTIPLE");
    if (fX3_DISMOUNT_MULTIPLE>0.0) fX3_MOUNT_MULTIPLE=fX3_DISMOUNT_MULTIPLE; // use dismount multiple instead of mount multiple
    HORSE_SupportResetUnmountedAppearance(oRider);
    DeleteLocalInt(oRider,"bX3_HORSE_MODIFIERS");
    DelayCommand(0.1*fX3_MOUNT_MULTIPLE,HORSE_SupportOriginalSpeed(oRider));
    DelayCommand(0.2*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveMountedSkillDecreases(oRider));
    DelayCommand(0.2*fX3_MOUNT_MULTIPLE,HORSE_SupportAdjustMountedArcheryPenalty(oRider));
    DelayCommand(0.3*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveACBonus(oRider));
    DelayCommand(0.3*fX3_MOUNT_MULTIPLE,HORSE_SupportRemoveHPBonus(oRider));
    if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")) SetLocalInt(oRider,"bX3_STORE_MOUNT_INFO",TRUE);
    DelayCommand(0.4*fX3_MOUNT_MULTIPLE,HORSE_SupportMountCleanVariables(oRider));
    DeleteSkinInt(oRider,"bX3_IS_MOUNTED");
} // HorseInstantDismount()


void HorseInstantMount(object oRider,int nTail,int bJoust=FALSE,string sResRef="")
{ // PURPOSE: Instantly mount oRider
    string sRR=sResRef;
    if (GetStringLength(sRR)<1) sRR="x3_horse001";
    SetSkinInt(oRider,"nX3_StoredFootstep",GetFootstepType(oRider));
    SetSkinInt(oRider,"nX3_HorseRiderPhenotype",GetPhenoType(oRider));
    SetSkinInt(oRider,"nX3_HorseRiderAppearance",GetAppearanceType(oRider));
    SetLocalInt(oRider,"nX3_RiderHP",GetCurrentHitPoints(oRider));
    SetSkinInt(oRider,"nX3_HorseRiderTail",GetCreatureTailType(oRider));
    SetCreatureAppearanceType(oRider,HORSE_SupportGetMountedAppearance(oRider));
    HorseSetPhenotype(oRider,bJoust);
    SetCreatureTailType(nTail,oRider);
    SetFootstepType(HORSE_FOOTSTEP_SOUND,oRider);
    SetSkinString(oRider,"sX3_HorseResRef",sRR);
    HORSE_SupportIncreaseSpeed(oRider,OBJECT_INVALID);
    HORSE_SupportAdjustMountedArcheryPenalty(oRider);
    SetSkinInt(oRider,"bX3_IS_MOUNTED",TRUE);
    DelayCommand(0.5,HORSE_SupportApplyMountedSkillDecreases(oRider));
    if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")) SetLocalInt(oRider,"bX3_STORE_MOUNT_INFO",TRUE);
    SetLocalInt(oRider,"bX3_HORSE_MODIFIERS",TRUE);
} // HorseInstantMount()


object HorseGetPaladinMount(object oRider)
{ // PURPOSE: Return the paladin mount for oRider
    string sS;
    object oNPC;
    int nN=1;
    if (GetIsObjectValid(oRider)&&GetObjectType(oRider)==OBJECT_TYPE_CREATURE)
    { // valid parameter
        sS=GetResRef(oRider);
        if (GetStringLeft(sS,GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX) return oRider; // oRider IS a paladin mount
        sS=GetSkinString(oRider,"sX3_HorseResRef");
        if (GetStringLeft(sS,GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX) return oRider; // oRider is riding a paladin mount
        oNPC=GetLocalObject(oRider,"oX3PaladinMount");
        if (GetIsObjectValid(oNPC)&&GetStringLeft(GetResRef(oNPC),GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX) return oNPC;
        oNPC=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oRider,nN);
        while(GetIsObjectValid(oNPC))
        { // check henchmen
            sS=GetResRef(oNPC);
            if (GetStringLeft(sS,GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX) return oNPC;
            nN++;
            oNPC=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oRider,nN);
        } // check henchmen
        return GetLocalObject(oRider,"oX3PaladinMount");
    } // valid parameter
    return OBJECT_INVALID;
} // HorseGetPaladinMount()


object HorseSummonPaladinMount(int bPHBDuration=FALSE)
{ // PURPOSE: Summon Paladin Mount
    object oSummoner=OBJECT_SELF;
    object oMount;
    location lLoc;
    int nLevel=GetLevelByClass(CLASS_TYPE_PALADIN,oSummoner);
    int nDespawnTime;
    int nCurrentTime;
    int nMountNum=1;
    string sResRef=HORSE_PALADIN_PREFIX;
    effect eVFX;
    oMount=HorseGetPaladinMount(oSummoner);
    if (!GetIsObjectValid(oMount)&&nLevel>4&&GetObjectType(oSummoner)==OBJECT_TYPE_CREATURE)
    { // okay to summon - only one paladin mount at a time
        if ((GetIsPC(oSummoner)||GetIsDM(oSummoner))&&!GetHasFeat(FEAT_HORSE_MENU,oSummoner)) HorseAddHorseMenu(oSummoner);
        if (nLevel>7&&nLevel<11) nMountNum=2;
        else if (nLevel>10&&nLevel<15) nMountNum=3;
        else if (nLevel>14&&nLevel<25) nMountNum=4;
        else if (nLevel>24&&nLevel<30) nMountNum=5;
        else if (nLevel>29&&nLevel<35) nMountNum=6;
        else if (nLevel>34&&nLevel<40) nMountNum=7;
        else if (nLevel>39) nMountNum=8;
        lLoc=HORSE_SupportGetMountLocation(oSummoner,oSummoner);
        oMount=HorseCreateHorse(sResRef+IntToString(nMountNum),lLoc,oSummoner);
        if (!GetIsObjectValid(oMount)) oMount=HorseCreateHorse(sResRef+IntToString(nMountNum),GetLocation(oSummoner),oSummoner);
        if (GetIsObjectValid(oMount))
        { // oMount created
            eVFX=EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oMount,3.0);
            eVFX=EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
            if (nMountNum>3) eVFX=EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,GetLocation(oMount));
            if (bPHBDuration)
            { // Players Handbook 3.5 edition durations
                nCurrentTime=HORSE_SupportAbsoluteMinute();
                nDespawnTime=(2*nLevel*60)+nCurrentTime;
                SetLocalInt(oSummoner,"nX3_PALADIN_UNSUMMON",nDespawnTime);
            } // Players Handbook 3.5 edition durations
            else
            { // 24 hour - popular bioware
                nCurrentTime=HORSE_SupportAbsoluteMinute();
                nDespawnTime=nCurrentTime+(60*24);
                SetLocalInt(oSummoner,"nX3_PALADIN_UNSUMMON",nDespawnTime);
            } // 24 hour - popular bioware
            if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsPC(oSummoner)) SetLocalInt(oSummoner,"bX3_STORE_MOUNT_INFO",TRUE);
            SetLocalObject(oSummoner,"oX3PaladinMount",oMount);
        } // oMount created
    } // okay to summon - only one paladin mount at a time
    else { oMount=OBJECT_INVALID; }
    return oMount;
} // HorseSummonPaladinMount()


void HorseUnsummonPaladinMount()
{ // PURPOSE: Unsummon Paladin Mount
    object oPaladin=OBJECT_SELF;
    object oMount=HorseGetPaladinMount(oPaladin);
    effect eVFX;
    if (!GetIsObjectValid(oMount)) oMount=GetLocalObject(oPaladin,"oX3PaladinMount");
    if (GetIsObjectValid(oMount)&&oMount!=oPaladin)
    { // Paladin Mount exists
        if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsPC(oPaladin)) SetLocalInt(oPaladin,"bX3_STORE_MOUNT_INFO",TRUE);
        if (oMount==oPaladin)
        { // Mounted - must dismount first
            ClearAllActions(TRUE);
            oMount=HorseDismount(FALSE,TRUE);
            DelayCommand(3.0,HorseUnsummonPaladinMount());
        } // Mounted - must dismount first
        else
        { // is the mount
            if (GetIsPC(oPaladin))
            {
                SendMessageToPCByStrRef(oPaladin,111985);
            }
            DeleteLocalInt(oPaladin,"nX3_PALADIN_UNSUMMON");
            eVFX=EffectVisualEffect(VFX_IMP_UNSUMMON);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,GetLocation(oMount));
            DestroyObject(oMount);
        } // is the mount
    } // Paladin Mount exists
    else
    { // perhaps the command is being called by the mount itself
        if (GetStringLeft(GetResRef(oPaladin),GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX)
        { // is a paladin mount despawning itself
            oMount=oPaladin;
            eVFX=EffectVisualEffect(VFX_IMP_UNSUMMON);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,GetLocation(oMount));
            DestroyObject(oMount);
        } // is a paladin mount despawning itself
    } // perhaps the command is being called by the mount itself
} // HorseUnsummonPaladinMount()


int HorseGetIsAMount(object oTarget)
{ // PURPOSE: Return TRUE if oTarget is a mountable creature
    int nApp;
    int nTail;
    if (GetSkinInt(oTarget,"bX3_IS_MOUNTED")) return FALSE;
    if (GetLocalInt(oTarget,"bX3_IS_MOUNT")) return TRUE;
    else if (GetLocalInt(oTarget,"bX3_IS_RIDER")) return FALSE;
    else if (GetStringLength(GetLocalString(oTarget,"X3_HORSE_PREMOUNT_SCRIPT"))>0) return TRUE;
    else if (GetStringLength(GetLocalString(oTarget,"X3_HORSE_PREDISMOUNT_SCRIPT"))>0) return TRUE;
    else if (GetStringLength(GetLocalString(oTarget,"X3_HORSE_POSTDISMOUNT_SCRIPT"))>0) return TRUE;
    else if (GetStringLength(GetLocalString(oTarget,"X3_HORSE_POSTMOUNT_SCRIPT"))>0) return TRUE;
    else if (GetStringLength(GetLocalString(oTarget,"X3_HORSE_OWNER_TAG"))>0) return TRUE;
    else if (GetLocalInt(oTarget,"X3_HORSE_NULL_APPEARANCE")>0) return TRUE;
    //else if (GetSkinInt(oTarget,"X3_HORSE_APPEARANCE")>0) return TRUE;
    else if (GetLocalInt(oTarget,"X3_HORSE_TAIL")>0) return TRUE;
    nApp=GetAppearanceType(oTarget);
    nTail=GetCreatureTailType(oTarget);
    if (nApp>=HORSE_APPEARANCE_OFFSET&&nApp<=HORSE_APPEARANCE_OFFSET+HORSE_NUMBER_OF_HORSES) return TRUE;
    if (nApp==HORSE_NULL_RACE_GNOME||nApp==HORSE_NULL_RACE_ELF||nApp==HORSE_NULL_RACE_GNOME||nApp==HORSE_NULL_RACE_HALFELF||
        nApp==HORSE_NULL_RACE_HALFLING||nApp==HORSE_NULL_RACE_HALFORC||nApp==HORSE_NULL_RACE_HUMAN)
    { // might be a tail always based mount
        if (nTail>=HORSE_TAIL_OFFSET&&nTail<=HORSE_TAIL_OFFSET+HORSE_NUMBER_OF_HORSES&&nTail!=14) return TRUE;
    } // might be a tail always based mount
    return FALSE;
} // HorseGetIsAMount()


void HorseStoreInventory(object oCreature,object oRider=OBJECT_INVALID)
{ // PURPOSE: To store inventory being carried by oCreature
    object oWP=GetWaypointByTag("X3_HORSE_INVENTORY_STORAGE");
    object oOwner=GetMaster(oCreature);
    object oOwnersMaster=GetMaster(oOwner);
    object oItem;
    object oChest;
    object oCont;
    int nC;
    int nN;
    string sR;
    string sT;
    int nST;
    int nCH;
    string sID=GetTag(oCreature); // ID to uniquely identify for inventory storage
    string sDB="X3SADDLEBAG"+GetTag(GetModule());
    if (GetStringLength(GetLocalString(GetModule(),"X3_SADDLEBAG_DATABASE"))>0) sDB=GetLocalString(GetModule(),"X3_SADDLEBAG_DATABASE");
    if (GetStringLength(sID)>6) sID=GetStringLeft(sID,6);
    sID=sID+GetStringRight(GetResRef(oCreature),2);
    if (oOwner!=oCreature&&GetIsObjectValid(oOwner))
    { // owner specified
        if (!GetIsPC(oOwner))
        { // henchman owner
            sT=GetTag(oOwner);
            if (GetStringLength(sT)>8) sT=GetStringLeft(sT,6)+GetStringRight(sT,2);
            sID=sID+sT;
            if (GetIsObjectValid(oOwnersMaster)&&oOwner!=oOwnersMaster&&GetIsPC(oOwnersMaster))
            { // PC
                sID=sID+GetPCPublicCDKey(oOwnersMaster)+GetStringLeft(GetName(oOwnersMaster),4);
            } // PC
        } // henchman owner
        else
        { // PC owner
            sID=sID+GetPCPublicCDKey(oOwner)+GetStringLeft(GetName(oOwner),4);
        } // PC owner
    } // owner specified
    if (GetIsObjectValid(oWP))
    { // do not use database
        // I am using a placeable that has inventory but, by default does not
        // have scripts that produce extra inventory.
        oChest=CreateObject(OBJECT_TYPE_PLACEABLE,"x3_plc_jars001",GetLocation(oWP),FALSE,"X3_"+sID);
        SetName(oChest,GetName(oCreature)+"'s Inventory");
        SetLocalObject(oCreature,"oX3_Saddlebags",oChest);
        HORSE_SupportTransferInventory(oCreature,oChest,GetLocation(oChest));
    } // do not use database
    else
    { // use database
        nC=0;
        oItem=GetFirstItemInInventory(oCreature);
        while(GetIsObjectValid(oItem))
        { // store inventory
            nC++;
            sR=GetResRef(oItem);
            sT=GetTag(oItem);
            nST=GetItemStackSize(oItem);
            nCH=GetItemCharges(oItem);
            SetCampaignString(sDB,"sR"+sID+IntToString(nC),sR);
            SetCampaignString(sDB,"sT"+sID+IntToString(nC),sT);
            SetCampaignInt(sDB,"nS"+sID+IntToString(nC),nST);
            SetCampaignInt(sDB,"nC"+sID+IntToString(nC),nCH);
            DestroyObject(oItem,0.1);
            oItem=GetNextItemInInventory(oCreature);
        } // store inventory
        SetCampaignInt(sDB,"nCO_"+sID,nC);
        if (GetIsObjectValid(oRider)) SetLocalString(oRider,"sDB_Inv",sID);
    } // use database
} // HorseStoreInventory()


void HorseRestoreInventory(object oCreature,int bDrop=FALSE)
{ // PURPOSE: To restore inventory that was stored while mounted
    object oWP=GetWaypointByTag("X3_HORSE_INVENTORY_STORAGE");
    object oOwner=GetMaster(oCreature);
    object oOwnersMaster=GetMaster(oOwner);
    object oItem;
    object oChest;
    int nC;
    int nN;
    string sR;
    string sT;
    int nST;
    int nCH;
    string sID=GetTag(oCreature);// ID to uniquely identify for inventory storage
    string sDB="X3SADDLEBAG"+GetTag(GetModule());
    if (GetStringLength(GetLocalString(GetModule(),"X3_SADDLEBAG_DATABASE"))>0) sDB=GetLocalString(GetModule(),"X3_SADDLEBAG_DATABASE");
    if (GetStringLength(sID)>6) sID=GetStringLeft(sID,6);
    sID=sID+GetStringRight(GetResRef(oCreature),2);
    if (oOwner!=oCreature&&GetIsObjectValid(oOwner))
    { // owner specified
        if (!GetIsPC(oOwner))
        { // henchman owner
            sT=GetTag(oOwner);
            if (GetStringLength(sT)>8) sT=GetStringLeft(sT,6)+GetStringRight(sT,2);
            sID=sID+sT;
            if (GetIsObjectValid(oOwnersMaster)&&oOwner!=oOwnersMaster&&GetIsPC(oOwnersMaster))
            { // PC
                sID=sID+GetPCPublicCDKey(oOwnersMaster)+GetStringLeft(GetName(oOwnersMaster),4);
            } // PC
        } // henchman owner
        else
        { // PC owner
            sID=sID+GetPCPublicCDKey(oOwner)+GetStringLeft(GetName(oOwner),4);
        } // PC owner
    } // owner specified
    if (GetIsObjectValid(oWP))
    { // do not use database
        oChest=GetObjectByTag("X3_"+sID);
        if (!GetIsObjectValid(oChest)) oChest=GetLocalObject(oOwner,"oX3_Saddlebags");
        if (GetIsObjectValid(oChest))
        { // chest found
            HORSE_SupportTransferInventory(oChest,oCreature,GetLocation(oCreature),TRUE);
        } // chest found
        else
        { // error
            PrintString("ERROR: x3_inc_horse 'HorseRestoreInventory()' Could not find chest 'X3_"+sID+"'!");
        } // error
    } // do not use database
    else
    { // use database
        nC=GetCampaignInt(sDB,"nCO_"+sID);
        while(nC>0)
        { // restore inventory
            sR=GetCampaignString(sDB,"sR"+sID+IntToString(nC));
            sT=GetCampaignString(sDB,"sT"+sID+IntToString(nC));
            nST=GetCampaignInt(sDB,"nS"+sID+IntToString(nC));
            nCH=GetCampaignInt(sDB,"nC"+sID+IntToString(nC));
            DeleteCampaignVariable(sDB,"sR"+sID+IntToString(nC));
            DeleteCampaignVariable(sDB,"sT"+sID+IntToString(nC));
            DeleteCampaignVariable(sDB,"nS"+sID+IntToString(nC));
            DeleteCampaignVariable(sDB,"nC"+sID+IntToString(nC));
            if (!bDrop) oItem=CreateItemOnObject(sR,oCreature,nST,sT);
            else
            { // drop
                oItem=CreateObject(OBJECT_TYPE_ITEM,sR,GetLocation(oCreature),FALSE,sT);
                if (GetItemStackSize(oItem)!=nST&&nST!=0) SetItemStackSize(oItem,nST);
            } // drop
            if (nCH>0) SetItemCharges(oItem,nCH);
            nC--;
        } // restore inventory
        DeleteCampaignVariable(sDB,"nCO_"+sID);
    } // use database
} // HorseRestoreInventory()


void HorseChangeToDefault(object oCreature)
{ // PURPOSE: HorseChangeToDefault
    int nRace=GetRacialType(oCreature);
    int nDefApp=StringToInt(Get2DAString("racialtypes","Appearance",nRace));
    int nDefPhen;
    int nPheno=GetPhenoType(oCreature);
    if (nPheno==HORSE_PHENOTYPE_JOUSTING_L||nPheno==HORSE_PHENOTYPE_MOUNTED_L) nDefPhen=PHENOTYPE_BIG;
    else { nDefPhen=PHENOTYPE_NORMAL; }
    SetCreatureAppearanceType(oCreature,nDefApp);
    SetPhenoType(nDefPhen,oCreature);
    SetCreatureTailType(CREATURE_TAIL_TYPE_NONE,oCreature);
    SetFootstepType(FOOTSTEP_TYPE_NORMAL,oCreature);
    DeleteLocalInt(oCreature,"bX3_HORSE_MODIFIERS");
    DelayCommand(0.1,HORSE_SupportOriginalSpeed(oCreature));
    DelayCommand(0.2,HORSE_SupportRemoveMountedSkillDecreases(oCreature));
    DelayCommand(0.2,HORSE_SupportAdjustMountedArcheryPenalty(oCreature));
    DelayCommand(0.4,HORSE_SupportRemoveACBonus(oCreature));
    DelayCommand(0.4,HORSE_SupportRemoveHPBonus(oCreature));
    DelayCommand(1.0,HORSE_SupportCleanVariables(oCreature));
    if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsPC(oCreature)) SetLocalInt(oCreature,"bX3_STORE_MOUNT_INFO",TRUE);
} // HorseChangeToDefault()


void HorseIfNotDefaultAppearanceChange(object oCreature)
{ // PURPOSE: See if not default appearance
    int nRace=GetRacialType(oCreature);
    int nDefApp=StringToInt(Get2DAString("racialtypes","Appearance",nRace));
    if (GetAppearanceType(oCreature)!=nDefApp) HorseChangeToDefault(oCreature);
} // HorseIfNotDefaultAppearanceChange()


object HorseGetMyHorse(object oRider)
{ // PURPOSE: Return active horse
    object oRet=GetLocalObject(oRider,"oX3_TempHorse");
    if (GetIsObjectValid(oRet)) return oRet;
    return GetLocalObject(oRider,"oAssignedHorse");
} // HorseGetMyHorse()


int HorseGetHasAHorse(object oRider)
{ // PURPOSE: Return if oRider has a horse
    int nN=1;
    object oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oRider,nN);
    while(GetIsObjectValid(oHench))
    { // traverse henchmen
        if (HorseGetIsAMount(oHench)) return TRUE;
        nN++;
        oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oRider,nN);
    } // traverse henchmen
    return FALSE;
} // HorseGetHasAHorse()


object HorseGetHorse(object oRider,int nN=1)
{ // PURPOSE: Return the nNth horse of oRider
    int nC=1;
    int nH=0;
    object oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oRider,nC);
    while(GetIsObjectValid(oHench))
    { // traverse henchmen
        if (HorseGetIsAMount(oHench))
        { // is a horse
           nH++;
           if (nH==nN) return oHench;
        } // is a horse
        nC++;
        oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oRider,nC);
    } // traverse henchmen
    return OBJECT_INVALID;
} // HorseGetHorse()


void HorseRestoreHenchmenLocations(object oPC)
{ // PURPOSE: Restore the locations of the henchmen of henchmen
    object oHench;
    int nN;
    int nC;
    object oAssoc;
    int bNoMounts;
    int bNoMounting;
    int bRunAgain=FALSE;
    float fDelay=0.2;
    object oArea;
    if (GetLocalInt(GetModule(),"X3_RESTORE_HENCHMEN_LOCATIONS"))
    { // restore location of henchmen belonging to henchmen
        nN=1;
        oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nN);
        while(GetIsObjectValid(oHench))
        { // hench
            oArea=GetArea(oHench);
            bNoMounts=FALSE;
            bNoMounting=FALSE;
            if (!GetLocalInt(oArea,"X3_MOUNT_OK_EXCEPTION"))
            { // find out if horses ok
                if (GetLocalInt(GetModule(),"X3_MOUNTS_EXTERNAL_ONLY")&&GetIsAreaInterior(oArea)) bNoMounts=TRUE;
                else if (GetLocalInt(GetModule(),"X3_MOUNTS_NO_UNDERGROUND")&&!GetIsAreaAboveGround(oArea)) bNoMounts=TRUE;
            } // find out if horses ok
            if (GetLocalInt(oArea,"X3_NO_MOUNTING")||GetLocalInt(oArea,"X3_NO_HORSES")||bNoMounts) bNoMounting=TRUE;
            nC=1;
            oAssoc=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oHench,nC);
            while(GetIsObjectValid(oAssoc))
            { // check each associate
                if (HorseGetIsMounted(oAssoc)&&(bNoMounts||bNoMounting))
                { // dismount
                    bRunAgain=TRUE;
                    DelayCommand(fDelay,AssignCommand(oAssoc,HORSE_SupportDismountWrapper(FALSE,TRUE)));
                    fDelay=fDelay+0.2;
                } // dismount
                else if (HorseGetIsAMount(oAssoc)&&bNoMounts)
                { // no mounts
                    DelayCommand(fDelay,RemoveHenchman(oHench,oAssoc));
                    DelayCommand(fDelay+0.01,SetAssociateState(NW_ASC_MODE_STAND_GROUND,TRUE,oAssoc));
                    fDelay=fDelay+0.2;
                } // no mounts
                else if (GetArea(oAssoc)!=oArea)
                { // jump
                    AssignCommand(oAssoc,ClearAllActions(TRUE));
                    AssignCommand(oAssoc,ActionJumpToObject(oHench));
                } // jump
                nC++;
                oAssoc=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oHench,nC);
            } // check each associate
            nN++;
            oHench=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC,nN);
        } // hench
        nN=1;
        oHench=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_NOT_PC,oPC,nN);
        while(GetIsObjectValid(oHench))
        { // test non-henchmen
            if (!GetIsObjectValid(GetMaster(oHench))||GetMaster(oHench)==oHench)
            { // test associates
                oArea=GetArea(oHench);
                bNoMounts=FALSE;
                bNoMounting=FALSE;
                if (!GetLocalInt(oArea,"X3_MOUNT_OK_EXCEPTION"))
                { // find out if horses ok
                    if (GetLocalInt(GetModule(),"X3_MOUNTS_EXTERNAL_ONLY")&&GetIsAreaInterior(oArea)) bNoMounts=TRUE;
                    else if (GetLocalInt(GetModule(),"X3_MOUNTS_NO_UNDERGROUND")&&!GetIsAreaAboveGround(oArea)) bNoMounts=TRUE;
                } // find out if horses ok
                if (GetLocalInt(oArea,"X3_NO_MOUNTING")||GetLocalInt(oArea,"X3_NO_HORSES")||bNoMounts) bNoMounting=TRUE;
                nC=1;
                oAssoc=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oHench,nC);
                while(GetIsObjectValid(oAssoc))
                { // check each associate
                    if (HorseGetIsMounted(oAssoc)&&(bNoMounts||bNoMounting))
                    { // dismount
                        bRunAgain=TRUE;
                        DelayCommand(fDelay,AssignCommand(oAssoc,HORSE_SupportDismountWrapper(FALSE,TRUE)));
                        fDelay=fDelay+0.2;
                    } // dismount
                    else if (HorseGetIsAMount(oAssoc)&&bNoMounts)
                    { // no mounts
                        DelayCommand(fDelay,RemoveHenchman(oHench,oAssoc));
                        DelayCommand(fDelay+0.01,SetAssociateState(NW_ASC_MODE_STAND_GROUND,TRUE,oAssoc));
                        fDelay=fDelay+0.2;
                    } // no mounts
                    else if (GetArea(oAssoc)!=oArea)
                    { // jump
                        AssignCommand(oAssoc,ClearAllActions(TRUE));
                        AssignCommand(oAssoc,ActionJumpToObject(oHench));
                    } // jump
                    nC++;
                    oAssoc=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oHench,nC);
                } // check each associate
            } // test associates
            nN++;
            oHench=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_NOT_PC,oPC,nN);
        } // test non-henchmen
        if (bRunAgain) DelayCommand(5.0+fDelay,HorseRestoreHenchmenLocations(oPC));
    } // restore location of henchmen belonging to henchmen
} // HorseRestoreHenchmenLocations()


////////////////////////////////////////////////////////////////////////////////
///////////////////////////////   TRANSITIONS   ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


void HorseHitchHorses(object oHitch,object oClicker,location lPreJump)
{ // PURPOSE: Hitch all associates to clicker
    object oOb;
    object oHench;
    int nN=1;
    int nNN;
    int bNotAllowed=FALSE;
    float fX3_MOUNT_MULTIPLE=GetLocalFloat(GetArea(oClicker),"fX3_MOUNT_MULTIPLE");
    float fX3_DISMOUNT_MULTIPLE=GetLocalFloat(GetArea(oClicker),"fX3_DISMOUNT_MULTIPLE");
    if (GetLocalFloat(oClicker,"fX3_MOUNT_MULTIPLE")>fX3_MOUNT_MULTIPLE) fX3_MOUNT_MULTIPLE=GetLocalFloat(oClicker,"fX3_MOUNT_MULTIPLE");
    if (fX3_MOUNT_MULTIPLE<=0.0) fX3_MOUNT_MULTIPLE=1.0;
    if (GetLocalFloat(oClicker,"fX3_DISMOUNT_MULTIPLE")>0.0) fX3_DISMOUNT_MULTIPLE=GetLocalFloat(oClicker,"fX3_DISMOUNT_MULTIPLE");
    if (fX3_DISMOUNT_MULTIPLE>0.0) fX3_MOUNT_MULTIPLE=fX3_DISMOUNT_MULTIPLE; // use dismount multiple instead of mount multiple
    float fDelay=0.2*fX3_MOUNT_MULTIPLE;
    oOb=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oClicker,nN);
    while(GetIsObjectValid(oOb))
    { // traverse henchmen
        if (HorseGetIsAMount(oOb)&&(!GetLocalInt(oOb,"X3_DOING_HORSE_ACTION")))
        { // is a mount
            bNotAllowed=TRUE;
            if (GetStringLeft(GetResRef(oOb),GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX) SetLocalObject(oClicker,"oX3PaladinMount",oOb);
            if (GetIsObjectValid(oHitch)&&GetDistanceBetween(oClicker,oHitch)<15.0)
            { // jump to hitch
                DelayCommand(0.1,RemoveHenchman(oClicker,oOb));
                AssignCommand(oOb,ClearAllActions(TRUE));
                //AssignCommand(oOb,ActionWait(X3_ACTION_DELAY/2*fX3_MOUNT_MULTIPLE));
                AssignCommand(oOb,ActionJumpToObject(oHitch));
                AssignCommand(oOb,ActionDoCommand(SetFacingPoint(GetPosition(oHitch))));
                SetAssociateState(NW_ASC_MODE_STAND_GROUND,TRUE,oOb);
            } // jump to hitch
            else
            { // stand where you are and make way
                DelayCommand(0.1,RemoveHenchman(oClicker,oOb));
                SetAssociateState(NW_ASC_MODE_STAND_GROUND,TRUE,oOb);
                AssignCommand(oOb,ClearAllActions(TRUE));
                if (GetDistanceBetween(oOb,oClicker)<3.0) DelayCommand(1.0*fX3_MOUNT_MULTIPLE,AssignCommand(oOb,ActionMoveAwayFromLocation(lPreJump,FALSE,3.0+IntToFloat(Random(15))/10.0)));
                else if (GetDistanceBetween(oOb,oClicker)>4.0) DelayCommand(1.0*fX3_MOUNT_MULTIPLE,AssignCommand(oOb,ActionMoveToLocation(GetBehindLocation(oClicker))));
            } // stand where you are and make way
        } // is a mount
        else
        { // check for mounts for this henchman
            oHench=oOb;
            nNN=1;
            oOb=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oHench,nNN);
            while(GetIsObjectValid(oOb))
            { // traverse henchmen
                if (HorseGetIsAMount(oOb)&&(!GetLocalInt(oOb,"X3_DOING_HORSE_ACTION")))
                { // is a mount
                    bNotAllowed=TRUE;
                    if (GetStringLeft(GetResRef(oOb),GetStringLength(HORSE_PALADIN_PREFIX))==HORSE_PALADIN_PREFIX) SetLocalObject(oHench,"oX3PaladinMount",oOb);
                    if (GetIsObjectValid(oHitch)&&GetDistanceBetween(oClicker,oHitch)<15.0)
                    { // jump to hitch
                        DelayCommand(0.1,RemoveHenchman(oHench,oOb));
                        AssignCommand(oOb,ClearAllActions(TRUE));
                        //AssignCommand(oOb,ActionWait(X3_ACTION_DELAY/2*fX3_MOUNT_MULTIPLE));
                        AssignCommand(oOb,ActionJumpToObject(oHitch));
                        AssignCommand(oOb,ActionDoCommand(SetFacingPoint(GetPosition(oHitch))));
                        SetAssociateState(NW_ASC_MODE_STAND_GROUND,TRUE,oOb);
                    } // jump to hitch
                    else
                    { // stand where you are and make way
                        DelayCommand(0.1,RemoveHenchman(oHench,oOb));
                        AssignCommand(oOb,ClearAllActions(TRUE));
                        SetAssociateState(NW_ASC_MODE_STAND_GROUND,TRUE,oOb);
                        fDelay+=0.2*fX3_MOUNT_MULTIPLE;
                        //if (GetDistanceBetween(oOb,oClicker)<4.0) DelayCommand(fDelay,AssignCommand(oOb,ActionMoveAwayFromLocation(lPreJump,FALSE,4.0+IntToFloat(Random(15))/10.0)));
                        if (GetDistanceBetween(oOb,OBJECT_SELF)<4.0) DelayCommand(fDelay,AssignCommand(oOb,ActionMoveAwayFromLocation(lPreJump,FALSE,4.0+IntToFloat(Random(15))/10.0)));
                        //else if (GetDistanceBetween(oOb,oClicker)>5.0) DelayCommand(fDelay,AssignCommand(oOb,ActionMoveToLocation(GetBehindLocation(oClicker))));
                        else if (GetDistanceBetween(oOb,OBJECT_SELF)>5.0) DelayCommand(fDelay,AssignCommand(oOb,ActionMoveToObject(OBJECT_SELF,FALSE,4.0+IntToFloat(Random(15))/10.0)));
                        //SendMessageToPC(oClicker, FloatToString(GetDistanceBetween(oOb,OBJECT_SELF)));
                    } // stand where you are and make way
                } // is a mount
                nNN++;
                oOb=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oHench,nNN);
            } // traverse henchmen
        } // check for mounts for this henchman
        nN++;
        oOb=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oClicker,nN);
    } // traverse henchmen
    if (bNotAllowed) SendMessageToPCByStrRef(oClicker,111990);
} // HorseHitchHorses()


void HorseForceJump(object oJumper,object oDestination,float fRange=2.0,int nTimeOut=10)
{ // PURPOSE: Make sure jump
    //SendMessageToPC(oJumper,"nw_g0_transition:ForceJump("+IntToString(nTimeOut)+")");
    if (nTimeOut>0&&(GetArea(oJumper)!=GetArea(oDestination)||GetDistanceBetween(oJumper,oDestination)>fRange))
    { // jump
        AssignCommand(oJumper,ClearAllActions(TRUE));
        AssignCommand(oJumper,ActionJumpToObject(oDestination));
        DelayCommand(1.0,HorseForceJump(oJumper,oDestination,fRange,nTimeOut-1));
    } // jump
} // HorseForceJump()


void HorseMoveAssociates(object oMaster)
{ // PURPOSE: Give the PC some breathing room
    int nN,nNN;
    float fDelay=0.2;
    object oHench,oAssociate,oSummon;
    nN=1;
    oAssociate=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oMaster,nN);
    while(GetIsObjectValid(oAssociate))
    { // move associates
        if (HorseGetIsAMount(oAssociate)||HorseGetIsMounted(oAssociate))
        { // only move mounts or mounted associates
            if (GetArea(oAssociate)==GetArea(oMaster)&&GetDistanceBetween(oMaster,oAssociate)<3.0)
            { // move away
                AssignCommand(oAssociate,ClearAllActions());
                DelayCommand(1.0,AssignCommand(oAssociate,ActionMoveAwayFromObject(oMaster,FALSE,3.0+IntToFloat(Random(10))/10.0)));
            } // move away
        } // only move mounts or mounted associates
        else
        { // henchmen of henchman
            oHench=oAssociate;
            nNN=1;
            oAssociate=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oHench,nNN);
            while(GetIsObjectValid(oAssociate))
            { // traverse henchmen
                if (HorseGetIsAMount(oAssociate)||HorseGetIsMounted(oAssociate))
                { // only move mounts or mounted associates
                    if (GetArea(oAssociate)==GetArea(oMaster)&&GetDistanceBetween(oMaster,oAssociate)<3.0)
                    { // move away
                        fDelay+=0.2;
                        AssignCommand(oAssociate,ClearAllActions());
                        DelayCommand(fDelay,AssignCommand(oAssociate,ActionMoveAwayFromObject(oMaster,FALSE,3.0+IntToFloat(Random(15))/10.0)));
                    } // move away
                } // only move mounts or mounted associates
                nNN++;
                oAssociate=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oHench,nNN);
                oSummon=GetAssociate(ASSOCIATE_TYPE_SUMMONED,oHench,nNN);
            } // traverse henchmen
            nNN=1;
            oSummon=GetAssociate(ASSOCIATE_TYPE_SUMMONED,oHench,nNN);
            while(GetIsObjectValid(oSummon))
            { // traverse summons
                if (HorseGetIsAMount(oSummon)||HorseGetIsMounted(oSummon))
                { // only move mounts or mounted associates
                    if (GetArea(oSummon)==GetArea(oMaster)&&GetDistanceBetween(oMaster,oSummon)<3.0)
                    { // move away
                        fDelay+=0.2;
                        AssignCommand(oSummon,ClearAllActions());
                        DelayCommand(fDelay,AssignCommand(oSummon,ActionMoveAwayFromObject(oMaster,FALSE,3.0+IntToFloat(Random(15))/10.0)));
                    } // move away
                } // only move mounts or mounted associates
                nNN++;
                oSummon=GetAssociate(ASSOCIATE_TYPE_SUMMONED,oHench,nNN);
            } // traverse summons
        } // henchmen of henchman
        nN++;
        oAssociate=GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oMaster,nN);
    } // move associates
    nN=1;
    oAssociate=GetAssociate(ASSOCIATE_TYPE_SUMMONED,oMaster,nN);
    while(GetIsObjectValid(oAssociate))
    { // move associates
        if (HorseGetIsAMount(oAssociate)||HorseGetIsMounted(oAssociate))
        { // only move mounts or mounted associates
            if (GetArea(oAssociate)==GetArea(oMaster)&&GetDistanceBetween(oMaster,oAssociate)<3.0)
            { // move away
                AssignCommand(oAssociate,ClearAllActions());
                DelayCommand(1.0,AssignCommand(oAssociate,ActionMoveAwayFromObject(oMaster,FALSE,3.0+IntToFloat(Random(10))/10.0)));
            } // move away
        } // only move mounts or mounted associates
        nN++;
        oAssociate=GetAssociate(ASSOCIATE_TYPE_SUMMONED,oMaster,nN);
    } // move associates
} // HorseMoveAssociates()


////////////////////////////////////////////////////////////////////////////////
/////////////////////////////   DEATH HANDLING   ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////


void HorseDismountWrapper()
{ // Wrap
    object oNPC=OBJECT_SELF;
    if (HorseGetIsMounted(oNPC))
    { // make sure dismount
        DelayCommand(0.1,HORSE_SupportResetUnmountedAppearance(oNPC));
        DelayCommand(0.8,HORSE_SupportCleanVariables(oNPC));
        DelayCommand(1.0,HORSE_SupportRemoveACBonus(oNPC));
        DelayCommand(1.0,HORSE_SupportRemoveHPBonus(oNPC));
        DelayCommand(1.0,HORSE_SupportRemoveMountedSkillDecreases(oNPC));
        DelayCommand(1.0,HORSE_SupportAdjustMountedArcheryPenalty(oNPC));
        DelayCommand(1.0,HORSE_SupportOriginalSpeed(oNPC));
        DelayCommand(2.0,HorseDismountWrapper());
    } // make sure dismount
} // HorseDismountWrapper()


void HorseReassign(object oHorse,object oHench,object oMaster)
{ // PURPOSE: To handle horse reassign
    if (GetIsObjectValid(oMaster)&&oMaster!=oHench)
    { // reassign
        HorseSetOwner(oHorse,oMaster);
        DeleteLocalObject(oHench,"oAssignedHorse");
    } // reassign
    else
    { // free
        HorseRemoveOwner(oHorse);
        DeleteLocalObject(oHench,"oAssignedHorse");
    } // free
} // HorseReassign()


int HorseHandleDeath()
{ // PURPOSE: Handle horses, re-assigning dying henchman's horse, handle mounted henchman's death (dismount, transfer saddlebag content to horse, re-assign horse to PC or free it)
    object oDied=OBJECT_SELF;
    object oHorse=HorseGetHorse(oDied);
    object oMaster=GetMaster(oDied);
    if (GetLocalInt(GetModule(),"X3_ENABLE_MOUNT_DB")&&GetIsObjectValid(GetMaster(oDied))) SetLocalInt(GetMaster(oDied),"bX3_STORE_MOUNT_INFO",TRUE);
    if (HorseGetIsAMount(oDied))
    { // check dying horse for saddlebags and eventual re-assigning to master
        if (GetLocalInt(GetModule(),"X3_HORSE_ENABLE_SADDLEBAGS")&&GetLocalInt(oDied,"bX3_HAS_SADDLEBAGS"))
        { // might have saddle bags
            object oOwner=HorseGetOwner(oDied);
            if (!GetIsPC(oOwner)&&GetIsObjectValid(oOwner)&&oOwner!=oDied)
            { // npc
                oOwner=GetMaster(oOwner);
                if (GetIsPC(oOwner))
                { // set to PC then drop
                    HorseSetOwner(oDied,oOwner);
                } // set to PC then drop
            } // npc
            else if (GetIsPC(oOwner))
            { // PC
            } // PC
            DeleteLocalInt(oDied,"bX3_HAS_SADDLEBAGS"); // if you don't want to remove saddlebags for horse resurrection purpose, make sure that the corpse's inventory content is moved to the resurrected living horse again (if you do that, you can possibly remove the check for saddlebags including the repeated call of the death script)
            DelayCommand(0.1,ExecuteScript(GetLocalString(oDied,"sX3_DEATH_SCRIPT"),oDied));
            return TRUE; // no resurrection for horses by default
        } // might have saddle bags
        return TRUE;  // horse should not respawn like other henchmen
    } // check dying horse for saddlebags and eventual re-assigning to master
    if (GetIsObjectValid(oHorse)) HorseReassign(oHorse,oDied,GetMaster(oDied)); // check henchman's horses for possible re-assigning to master or free them
    // * Bob Minors Jan 2008: added support for X3 mounts:
    // * If killed while mounted, we are dismounted. This takes about 0.5s so drop out and rerun this script again afterward
    if (HorseGetIsMounted(oDied))
    { // check if creature died in mounted state
        oHorse=HorseDismount(FALSE,TRUE);
        SetLocalObject(oDied,"oAssignedHorse",oHorse); // Kludge
        HorseReassign(oHorse,oDied,oMaster);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectKnockdown(),oHorse,1.8);
        DelayCommand(2.0,AssignCommand(oHorse,ActionMoveAwayFromObject(oDied,TRUE,3.0))); // drop rider and jump aside
        DelayCommand(1.2,ExecuteScript(GetLocalString(oDied,"sX3_DEATH_SCRIPT"),oDied)); // give dismount and potential inventory transfer some space before rerun
        //return TRUE; // this return makes the dead mounted henchman non-resurrectable, so its commented out so that they can be resurrected by default
    } // check if creature died in mounted state
return FALSE;
} //HorseHandleDeath()


////////////////////////////////////////////////////////////////////////////////
///////////////////////////   PRELOAD ANIMATIONS   /////////////////////////////
////////////////////////////////////////////////////////////////////////////////


void HorsePreloadAnimations(object oPC)
{ // PURPOSE: Force a preload of mount animations
    int nApp=GetAppearanceType(oPC);
    int nTail=GetCreatureTailType(oPC);
    //SetCreatureAppearanceType(oPC,HORSE_SupportGetMountedAppearance(oPC));
    if (nTail==0) nTail=14;
    HORSE_SupportRestoreFromPreload(oPC,nApp,nTail);
} // HorsePreloadAnimations()


//void main(){}
