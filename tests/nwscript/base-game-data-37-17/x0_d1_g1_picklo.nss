/* GESTURE SCRIPT - PC performs gesture and voicechat PICKLOCK */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_PICKLOCK, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL));
}

