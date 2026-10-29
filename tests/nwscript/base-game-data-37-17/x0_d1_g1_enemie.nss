/* GESTURE SCRIPT - PC performs gesture and voicechat ENEMIES */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_ENEMIES, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_LOOK_FAR));
}

