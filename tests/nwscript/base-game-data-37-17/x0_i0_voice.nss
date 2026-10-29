//::///////////////////////////////////////////////
//:: x0_i0_voice
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    I'm isolating any calls to PlayVoiceChat
    into this include file to make it easier to
    fiddle with the distribution of voicechat
    in the game.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: February 2003
//:://////////////////////////////////////////////


// * Frequency these voices play
const int VOICE_CANDO = 60;
const int VOICE_CANNOTDO = 100;
const int VOICE_PICKLOCK = 60;
const int VOICE_TASKDONE = 60;
const int VOICE_STOP = 60;
const int VOICE_CUSS = 90;
const int VOICE_HEAL = 25;
const int VOICE_HELLO = 90;
const int VOICE_BYE = 90;
const int VOICE_YES = 90;
const int VOICE_NO = 90;
const int VOICE_LAUGH = 100;
const int VOICE_POISON = 100;
const int VOICE_THREAT = 90;
const int VOICE_BADIDEA = 90;
const int VOICE_FLEE = 90;
const int VOICE_DEATH = 25;
const int VOICE_LOOKHERE = 100;

// * NW_I0_GENERIC


// Play the I can do that voicechat
void VoiceCanDo(int bAlways=FALSE);
// Play the I can't do that voicechat
void VoiceCannotDo(int bAlways=FALSE);
// Play Pickpocket acknowledgement
void VoicePicklock(int bAlways=FALSE);
// Play task complete acknowledgement
void VoiceTaskComplete(int bAlways=FALSE);
// Play the stop voice
void VoiceStop(int bAlways=FALSE);
void VoiceCuss(int bAlways=FALSE);

// * Death script

void VoiceHealMe(int bAlways=FALSE);

// * X0_I0_ANIMS

void VoiceYes(int bAlways=FALSE);
void VoiceNo(int bAlways=FALSE);
void VoiceLaugh(int bAlways=FALSE);
void VoiceHello(int bAlways=FALSE);
void VoiceGoodbye(int bAlways=FALSE);
void VoicePoisoned(int bAlways=FALSE);


// * x0_inc_henAI

void VoiceThreaten(int bAlways=FALSE);
void VoiceBadIdea(int bAlways=FALSE);
void VoiceFlee(int bAlways=FALSE);
void VoiceNearDeath(int bAlways=FALSE);
void VoiceLookHere(int bAlways=FALSE);


// * PRIVATE: Test to see if valid to return this voice
int VoiceTest(int nVoice, int bAlways)
{
    if ((d100() > (100 - nVoice) ) || bAlways == TRUE)
        return TRUE;
    return FALSE;
}

void VoiceCanDo(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_CANDO, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_CANDO);
}

void VoiceCannotDo(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_CANNOTDO, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_CANTDO);
}

void VoicePicklock(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_PICKLOCK, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_PICKLOCK);
}

void VoiceTaskComplete(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_TASKDONE, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_TASKCOMPLETE);
}

void VoiceStop(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_STOP, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_STOP);
}

void VoiceCuss(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_CUSS, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_CUSS);
}

void VoiceHealMe(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_HEAL, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_HEALME);
}

void VoiceHello(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_HELLO, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_HELLO);
}
void VoiceGoodbye(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_BYE, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_GOODBYE);
}
void VoiceYes(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_YES, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_YES);
}

void VoiceNo(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_NO, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_NO);
}


void VoiceLaugh(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_LAUGH, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_LAUGH);
}

void VoicePoisoned(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_POISON, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_POISONED);
}

void VoiceBadIdea(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_BADIDEA, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_BADIDEA);
}

void VoiceThreaten(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_THREAT, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_THREATEN);
}

void VoiceFlee(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_FLEE, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_FLEE);
}

void VoiceNearDeath(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_DEATH, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_NEARDEATH);
}

void VoiceLookHere(int bAlways=FALSE)
{
    if (VoiceTest(VOICE_LOOKHERE, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_LOOKHERE);
}

/* COMPILER STUB FOR TESTING ONLY
void main()
{}                               */
