/* GESTURE SCRIPT - PC performs gesture and voicechat HEALME */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_HEALME, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_PLEADING));
}

