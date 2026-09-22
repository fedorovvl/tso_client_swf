package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapSequentialStep;

    public class StepParseSettings extends BootstrapSequentialStep 
    {


        override protected function execute():void
        {
            add(new StepParseXML(global.gfxSettingsFilename, gParse.DispatcherGfxSettings));
            add(new StepParseXML((("config_" + global.realmLanguage) + ".xml"), gParse.DispatcherLanguageConfig));
            add(new StepParseXML(global.unitsFilename, gParse.DispatcherUnits));
            add(new StepParseXML(global.gameSettingsFilename, gParse.DispatcherGameSettings));
            add(new StepParseXMLMulti(global.skillSettingsFilenames_vector, gParse.DispatcherSkillConfig));
            add(new StepParseXML(global.votesFilename, gParse.DispatcherVotes));
            add(new StepParseXML(global.votesGroupFilename, gParse.DispatcherVotesShopGroup));
            add(new StepParseXML(global.shopConfigFilename, gParse.DispatcherShopConfig));
            add(new StepParseXML(global.helpDefinitionsFilename, gParse.DispatcherHelpDefinitions));
            add(new StepParseXML(global.gameEventsFilename, gParse.DispatcherGameEvents));
            add(new StepParseXML(global.collectionsFilename, gParse.DispatcherCollections));
            add(new StepParseXML(("advent_calendar/" + global.adventCalendarFilename), gParse.DispatcherAdventCalendar));
            add(new StepParseXML(global.epicWorkyardFilename, gParse.DispatcherEpicWorkyards));
            add(new StepParseXML(global.achievementsFilename, gParse.DispatcherAchievements));
            add(new StepParseXML(global.taskFilename, gParse.DispatcherTasks));
            add(new StepParseXML(global.triggersFilename, gParse.DispatcherTriggers));
            add(new StepParseXML(global.eventsFilename, gParse.DispatcherEvents));
            add(new StepParseXML(global.genericValuesFilename, gParse.DispatcherGenericValues));
            add(new StepParseXML(global.itemLimitsFilename, gParse.DispatcherItemLimits));
            add(new StepParseXML(global.reactionsFilename, gParse.DispatcherReactions));
            super.execute();
        }


    }
}
