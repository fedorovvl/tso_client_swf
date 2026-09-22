package Communication.VO.Guild
{
    import GuildSystem.PERMISSIONS;

    public class dGuildPlayerPermissionVO 
    {

        public var permissionCreated:Boolean = false;

        public var motd:int = PERMISSIONS.NO;
        public var description:int = PERMISSIONS.NO;
        public var officerNote:int = PERMISSIONS.NO;
        public var ranksEdit:int = PERMISSIONS.NO;
        public var ranksAssign:int = PERMISSIONS.NO;
        public var banner:int = PERMISSIONS.NO;
        public var guildMail:int = PERMISSIONS.NO;
        public var kick:int = PERMISSIONS.NO;
        public var invite:int = PERMISSIONS.NO;
        public var joinRequestAllow:int = PERMISSIONS.NO;
        public var joinRequestAccept:int = PERMISSIONS.NO;
        public var note:int = PERMISSIONS.NO;
        public var officersChannel:int = PERMISSIONS.NO;
        public var successorAssign:int = PERMISSIONS.NO;


        public function BannerWrite():Boolean
        {
            return ((this.banner >= PERMISSIONS.WRITE) ? true : false);
        }

        public function NoteWrite():Boolean
        {
            return ((this.note >= PERMISSIONS.WRITE) ? true : false);
        }

        public function RanksEdit():Boolean
        {
            return ((this.ranksEdit >= PERMISSIONS.WRITE) ? true : false);
        }

        public function SuccessorAssign():Boolean
        {
            return ((this.successorAssign >= PERMISSIONS.WRITE) ? true : false);
        }

        public function OfficerNoteWrite():Boolean
        {
            return ((this.officerNote >= PERMISSIONS.WRITE) ? true : false);
        }

        public function JoinRequestAccept():Boolean
        {
            return ((this.joinRequestAccept >= PERMISSIONS.WRITE) ? true : false);
        }

        public function JoinRequestAllow():Boolean
        {
            return ((this.joinRequestAllow >= PERMISSIONS.WRITE) ? true : false);
        }

        public function OfficerNoteRead():Boolean
        {
            return ((this.officerNote >= PERMISSIONS.READ) ? true : false);
        }

        public function DescriptionWrite():Boolean
        {
            return ((this.description >= PERMISSIONS.WRITE) ? true : false);
        }

        public function Kick():Boolean
        {
            return ((this.kick >= PERMISSIONS.WRITE) ? true : false);
        }

        public function Invite():Boolean
        {
            return ((this.invite >= PERMISSIONS.WRITE) ? true : false);
        }

        public function GuildMail():Boolean
        {
            return ((this.guildMail >= PERMISSIONS.WRITE) ? true : false);
        }

        public function MOTDWrite():Boolean
        {
            return ((this.motd >= PERMISSIONS.WRITE) ? true : false);
        }

        public function RanksAssign():Boolean
        {
            return ((this.ranksAssign >= PERMISSIONS.WRITE) ? true : false);
        }

        public function OfficersChannel():Boolean
        {
            return ((this.officersChannel >= PERMISSIONS.WRITE) ? true : false);
        }


    }
}
