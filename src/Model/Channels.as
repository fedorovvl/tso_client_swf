package Model
{
    import Model.Notifiers.SpecialistNotifier;
    import Model.Notifiers.InputNotifier;
    import Model.Notifiers.Channel;
    import Model.Notifiers.QuestChannel;
    import Model.Notifiers.CalendarChannel;
    import Model.Notifiers.TickChannel;
    import Model.Notifiers.ZoneChannel;
    import Model.Notifiers.RenderChannel;
    import Model.Notifiers.ResourceChannel;
    import Model.Notifiers.TaskManagerChannel;
    import Model.Notifiers.RequirementsChannel;

    public final class Channels 
    {

        public var CHANNEL_MAP:ChannelMap = new ChannelMap();
        public var SPECIALIST:SpecialistNotifier = new SpecialistNotifier();
        public var INPUT:InputNotifier = global.getApplication().inputNotifier;
        public var SKILL:Channel = new Channel();
        public var BUFF:Channel = new Channel();
        public var BUILDING:Channel = new Channel();
        public var GUILD:Channel = new Channel();
        public var QUEST:QuestChannel = new QuestChannel();
        public var TIMED_PRODUCTION:Channel = new Channel();
        public var TRADE:Channel = new Channel();
        public var PRODUCTION:Channel = new Channel();
        public var CALENDAR:CalendarChannel = new CalendarChannel();
        public var TICK:TickChannel = new TickChannel();
        public var ZONE:ZoneChannel = new ZoneChannel();
        public var RENDER:RenderChannel = new RenderChannel();
        public var RESOURCE:ResourceChannel = new ResourceChannel();
        public var TASK_MANAGER:TaskManagerChannel = new TaskManagerChannel();
        public var CONTENT_GENERATOR:Channel = new Channel();
        public var REQUIREMENTS:RequirementsChannel = new RequirementsChannel();


    }
}
