/* GESTURE SCRIPT - PC performs gesture and voicechat LAUGH */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_LAUGH, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
}

