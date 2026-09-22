package GUI.LoadingScreen
{
    import flash.utils.Dictionary;
    import flash.display.Bitmap;
    import GUI.Assets.gLoadingScreenInterface;

    public final class LoadingScreenLoca 
    {

        private static const copyright:Dictionary = new Dictionary();
        private static const additionalCopyright:Dictionary = new Dictionary();
        private static const beta:Dictionary = new Dictionary();

        {
            copyright["de"] = "© 2010 Ubisoft Entertainment. Alle Rechte vorbehalten. Die Siedler, Blue Byte und das Blue Byte-Logo sind Warenzeichen von Ubisoft GmbH in den USA und/oder anderen Ländern. Ubisoft und das Ubisoft-Logo sind Warenzeichen von Ubisoft Entertainment in den USA und/ oder anderen Ländern. Entwickelt von Blue Byte Software.";
            copyright["fr"] = "© 2010 Ubisoft Entertainment. Tous droits réservés. The Settlers, Blue Byte et le logo Blue Byte sont des marques déposées de Ubisoft GmbH aux États-Unis et/ou dans les autres pays. Ubisoft et le logo Ubisoft sont des marques déposées de Ubisoft Entertainment aux États-Unis et/ou dans les autres pays. Développé par Blue Byte Software.";
            copyright["uk"] = "© 2010 Ubisoft Entertainment. All Rights Reserved. The Settlers, Blue Byte and the Blue Byte logo are trademarks of Ubisoft GmbH in the U.S. and/or other countries. Ubisoft and the Ubisoft logo are trademarks of Ubisoft Entertainment in the U.S. and/or other countries. Developed by Blue Byte Software.";
            additionalCopyright["gr"] = "Copyright (c) 2007, Greek Font Society (www.greekfontsociety.org, gfs@greekfontsociety.org), with Reserved Font Name 'GFS Neohellenic'.";
            beta["br"] = "Este jogo ainda está na versão Beta. Sendo assim, certos elementos funcionais e do jogo ainda não estão finalizados.  Ajude-nos a fazer melhorias compartilhando suas opiniões e relatando todos os bugs que encontrar!  Lembre-se de conferir as seções de informações oficiais e anúncios na seção geral de opiniões do fórum para encontrar as últimas novidades (incluindo os períodos de manutenção).";
            beta["cn"] = "這場比賽是仍處於測試階段。因此，某些功能元素和遊戲元素尚未最後確定。幫助我們進一步改善遊戲，分享您的反饋和報告所有的錯誤！一定要檢查出的官方信息和公告部分在一般反饋節的論壇，了解最新的更新（包括維護時間）。";
            beta["cz"] = "Tato hra je stále ve verzi beta.  Některé funkční a herní prvky nejsou proto ještě dokončeny.  Pomozte nám dále vylepšit hru, podělte se o své názory a nahlaste nám veškeré chyby!  Nezapomeňte si přečíst oficiální informace a sdělení v části fóra věnované obecné zpětné vazbě. Najdete zde nejnovější aktualizace (včetně časů údržby).";
            beta["de"] = "Bei dieser Version handelt es sich um eine sogenannte Beta Testversion in welcher noch Fehler vorhanden sein können. Diverse Spielelemente können zudem noch nicht auf dem finalen Stand sein. Wir freuen uns schon sehr darauf, das Spiel durch dein Feedback weiter verbessern zu können. Bitte beachte auch die Offiziellen Informationen und Ankündigungen im Forum, unter Allgemeines Feedback. Dort findest du neben Changelogs auch Infos zu Wartungsarbeiten.";
            beta["es"] = "El juego aún está en fase Beta. Por tanto, algunos elementos funcionales y del juego todavía no han sido completados. ¡Ayúdanos a seguir mejorando el juego compartiendo tu opinión e informando de todos los errores que encuentres! Asegúrate de leer las secciones de información oficial y de anuncios en la sección de opinión general del foro para estar al tanto de las últimas actualizaciones (incluyendo las horas de mantenimiento).";
            beta["fr"] = "Cette version est dite de bêta-test; elle est donc susceptible de présenter des bugs ou des fonctionnalités non intégrées. Il est possible que certains éléments de jeu ne soient pas encore finalisés. Nous vous remercions de nous donner l'occasion d'améliorer le jeu en fonction de vos commentaires. Consultez également les informations et annonces officielles du forum, dans la section Commentaires généraux. Outre les journaux de modifications, vous y trouverez aussi des informations relatives aux travaux de maintenance.";
            beta["gr"] = "Αυτό το παιχνίδι βρίσκεται ακόμα σε beta στάδιο. Συνεπώς, συγκεκριμένες λειτουργίες και στοιχεία του παιχνιδιού δεν έχουν ολοκληρωθεί. Βοήθησέ μας να κάνουμε περισσότερες βελτιώσεις στο παιχνίδι γράφοντάς μας τη γνώμη σου και αναφέροντάς μας όλα τα σφάλματα! Φρόντισε να ελέγξεις τις επίσημες πληροφορίες και ανακοινώσεις στην ενότητα της γενικής συζήτησης στο φόρουμ, για να βρεις τις τελευταίες ενημερώσεις (συμπεριλαμβανόμενων των χρόνων συντήρησης).";
            beta["it"] = "Questo gioco è ancora in versione beta. Pertanto alcune funzioni e alcuni elementi non sono ancora in versione definitiva. Aiutaci a migliorare il gioco dandoci la tua opinione e segnalandoci i bug! Controlla la sezione del forum dedicata alle comunicazioni ufficiali e agli annunci per scoprire gli ultimi aggiornamenti (comprese le sospensioni dovute alla manutenzione).";
            beta["mx"] = "El juego aún está en fase Beta. Por tanto, algunos elementos funcionales y del juego todavía no han sido completados. ¡Ayúdanos a seguir mejorando el juego compartiendo tu opinión e informando de todos los errores que encuentres! Asegúrate de leer las secciones de información oficial y de anuncios en la sección de opinión general del foro para estar al tanto de las últimas actualizaciones (incluyendo las horas de mantenimiento).";
            beta["nl"] = "Dit spel bevindt zich nog in de bèta-fase. Bepaalde functies en spel-elementen zijn nog niet beschikbaar. Help ons het spel te verbeteren door ons je feedback te geven en door alle bugs te melden! Lees de sectie met officiële informatie en meldingen in de feedbacksectie van het forum voor de nieuwste updates (waaronder de tijden waarop onderhoud wordt uitgevoerd).";
            beta["pl"] = "Gra znajduje się jeszcze w wersji Beta.  Dlatego część jej funkcji i elementów nie została jeszcze skończona.  Pomóż nam dokonać ulepszeń, dzieląc się z nami wrażeniami i informując nas o błędach!  Zapoznaj się z oficjalnymi informacjami i ogłoszeniami w dziale informacji ogólnych na forum, gdzie znajdziesz najnowsze uaktualnienia (podajemy tam też informacje o przerwach technicznych).";
            beta["ro"] = "Jocul e încă în Beta. Ca atare, anumite elemente funcționale și elemente de joc nu sunt încă finalizate. Ajută-ne să aducem mai multe îmbunătățiri jocului împărtășind feedback-ul tău cu noi și raportând toate bug-urile! Nu uita să verifici secțiunile de informații oficiale și anunțuri din secțiunea de feedback general a forumului pentru a afla ultimele infomații (inclusiv perioadele de mentenanță).";
            beta["ru"] = "Игра находится в стадии бета-тестирования. В связи с этим некоторые игровые элементы еще не завершены или могут функционировать неверно. Помогите нам улучшить игру, отправив отзыв и сообщив об ошибках! Последние новости проекта вы можете найти в раздел официальной информации и объявлений.";
            beta["tr"] = "Bu oyun hala Beta sürümünde.  Bu nedenle, belirli işlevsel öğeler ve oyun öğeleri henüz son şeklini almadı.  Bize geri bildirimde bulunarak ve tüm hataları bildirerek oyunda daha fazla geliştirme yapmamıza yardım et!  Son güncellemeleri (bakım zamanları dahil) bulmak için forumun genel geribildirim bölümündeki resmi bilgiler ve duyurular bölümüne bakmayı unutma.";
            beta["uk"] = "This game is still in Beta. As such, certain functional elements and game elements are not yet finalized. Help us make further improvements to the game by sharing your feedback and reporting all bugs! Be sure to check out the official information and announcements sections in the general feedback section of the forum to find out the latest updates (including maintenance times).";
        }


        public static function getBetaText(_arg_1:String):String
        {
            return ((beta[_arg_1]) ? beta[_arg_1] : beta["uk"]);
        }

        public static function getCopyrightText(_arg_1:String):String
        {
            var _local_2:String = ((copyright[_arg_1]) ? copyright[_arg_1] : copyright["uk"]);
            if (additionalCopyright[_arg_1])
            {
                _local_2 = (_local_2 + (" " + additionalCopyright[_arg_1]));
            };
            return (_local_2);
        }

        public static function getStyleFilename(_arg_1:String):String
        {
            switch (_arg_1.toLowerCase())
            {
                case "gr":
                case "el-gr":
                    return ("el_gr.swf");
                case "cn":
                case "zh-cn":
                    return ("zh_cn.swf");
                case "ar":
                case "ar-ar":
                case "ar-ae":
                    return ("ar_ae.swf");
                default:
                    return ("defa.swf");
            };
        }

        public static function getLogoBitmap(_arg_1:gLoadingScreenInterface, _arg_2:String, _arg_3:Boolean):Bitmap
        {
            var _local_4:String = ("LoadingScreenLogo_" + _arg_2);
            if (_arg_3)
            {
                _local_4 = (_local_4 + "_beta");
            };
            var _local_5:Bitmap = _arg_1.LoadIcon(_local_4);
            if (((_local_5 == null) || (_local_5.width == 1)))
            {
                _local_5 = _arg_1.LoadIcon(((_arg_3) ? "LoadingScreenLogo_en_beta" : "LoadingScreenLogo_en"));
            };
            return (_local_5);
        }


    }
}
