/* GESTURE SCRIPT - PC performs gesture and voicechat TAUNT */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_TAUNT, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
}

