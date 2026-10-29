/* GESTURE SCRIPT - PC performs gesture and voicechat TASKCOMPLETE */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_TASKCOMPLETE, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL));
}

