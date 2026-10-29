/* GESTURE SCRIPT - PC performs gesture and voicechat HIDE */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_HIDE, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL));
}

