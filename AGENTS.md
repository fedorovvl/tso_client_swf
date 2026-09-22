# AGENTS.md — инструкции для агентов (TSO-клиент)

## 1. Что за проект

Клиент игры TSO. Гибридный тулчейн:
- **компилятор** — Flex 4 (`sdk/4.16.1`, mxmlc из Apache Flex 4.16.1);
- **рантайм** — Flex 3.6 (`sdk/3.6.0/frameworks/libs/framework.swc`, `rpc.swc`, `mxml-manifest.xml`).

Сборка: `build.cmd -DebugBuild` (Windows) или `./build.sh -DebugBuild` (Linux, после `chmod +x build.sh`)
→ `client.swf`. Ключи компилятора важные: `-compiler.strict=false`,
`-compiler.keep-generated-actionscript` (по требованию, generated-код — в `generated/`).
Лог: `compile.log`,
линк-репорт: только с флагом (по умолчанию выключен).

Зависимости (`libs/`): `Flint2d_4.0.1.swc`, `XIFF-quiet.swc`, `as3crypto.swc`,
`as3zlib.swc`, `PureMVC_AS3_2_0_4.swc`, `PureMVC_AS3_MultiCore_1_0_5.swc`
+ 2 вендоренных класса в `src/`..

## 2. Жёсткие правила MXML (нарушение = красный билд или рантайм-крах)

1. **Корень: только `id` + `xmlns` (+ `width/height`, `implements`, `cacheAsBitmap`/`clipContent` как plain-свойства).**
   ЛЮБОЙ стиль/констрейнт на корне (`styleName/color/padding/left/right/top/bottom/percentWidth/...`)
   генерит `new CSSStyleDeclaration(null, styleManager)`, а `styleManager` есть только во Flex 4
   → `Error #1065` при создании компонента. Корневые стили — только кодом
   (`setStyle` в `childrenCreated()`). На дочерних нодах стилевые атрибуты можно.
    Проверка: `grep "CSSStyleDeclaration(null, styleManager)" generated` — пусто.
2. **Биндинги только вида `{f(x)}`** (вызов функции). Запрещены `<mx:Binding source=...>`
   и голые `{prop}`: Flex-4 mxmlc генерит для них 5-аргументный `new Binding(...)`,
    а рантайм-`Binding` 3.6 принимает 4 → `Error #1063`. Проверка по `generated`:
   все `new Binding` — 4-аргументные. Что нельзя в `{f(x)}` (стили корня, `targets` эффектов,
   `{prop}`) — императивно в `childrenCreated()`.
3. **События только через `addEventListener` в `childrenCreated()`.**
   Запрещены MXML-атрибуты `click="__foo(event)"`, `creationComplete="..."`,
   `toolTipCreate="..."` (на MXML-компонентах и `mx:Canvas` — ломаный generated-код).
4. **ViewStack-страницы — сиблинги + `addChild`.** Сам ViewStack — самозакрывающийся
   сиблинг, страницы — сиблинги после него, attach в `childrenCreated()`.
   Причина: plain `Canvas` не проходит MXML-проверку `INavigatorContent`.
   Для наследников `BasicPanel` обязательно ПЛЮС фильтр (см. п.5).
5. **`BasicPanel.addSubComponents()` вырывает страницы из стаков.** Он работает по
   `creationComplete` внутренней канвы (позже `childrenCreated`) и делает
   `content.addChild()` каждому элементу `subComponents`. Фикс: после `addChild`-перемещений
   перезаписать `subComponents` только не-страницами
   (прецеденты: `TradeWindow`: `subComponents = [detailsStack, hr, buttonBar]`,
   `GuildWindow.mxml:112`). У компонентов с корнем plain `Canvas` этой проблемы нет.
6. **Detached-контейнеры:** на каждый контейнер с детьми — `LegacyMxmlContent.createChildren(id)`
   в `childrenCreated()` (см. `src/GUI/Components/LegacyMxmlContent.as`).
   `TitleContainer.contentChild` строится жадно кодом (`new` + `addChild`), не разметкой.
7. **Вотчер-утилиты удалять парой:** файл `src/_...WatcherSetupUtil.as` + запись в `mixins`.
   Перед удалением — греп по `src/` на имя утилиты: прямые ссылки И строковые
   (`getDefinitionByName("...")` — компилятор их не ловит, упадёт в рантайме #1065).
   Механизм: MXML-компонент сам подтягивает утилиту в конструкторе
   (`MailWindow-generated.as:1030-1036`), записи в `mixins` избыточны, но безвредны.
8. **Коллизии `id`:** `id` не должен совпадать с членами базового класса
   (прецедент: `GuildBank` `id="content"` конфликтовал с `BasicPanel.content` → #1009;
   переименовано в `mainContent`). Дубли `.as` + `.mxml` одного класса — ошибка сборки.
9. **Состояния:** `mx:State`/`mx:SetProperty` в разметке MXML-компилятор может отклонять —
   тогда кодом (`SetProperty` + `currentState`). `itemRenderer`/`ClassFactory` — кодом
   в `childrenCreated()` (с `outerDocument` для inline-рендереров).
10. **Локализация:** наивный `{loca('X')}` вычисляется один раз и протухает при смене языка.
    Для подписей, живших на вотчерах с `languageChanged`, делать `refreshLabels()` + подписку
    (прецедент `PvPColoniesWindow`). Скины `gAssetManager` — кодом или `{GetClass(...)}`
    ( benign-варнинг «will not be able to detect assignments» — норма).
    ЗАПРЕЩЕНЫ вызовы `cLocaManager`/`global.*` в инициализаторах полей и конструкторах:
    панели SWMMO создаются до загрузки loca (`getLabel` падает с #1010 на пустом
    `mTexts`). Только в `childrenCreated()` и позже, под гардом `IsInitialized()`
    (прецедент: `StarMenu.sortOptions`).
11. **Сущности в CDATA:** `&lt;`/`&gt;`/`&amp;` в Script чинить; `addTo(..., content)` → `addTo(...)`.
12. **Живые только биндинги со статическими корнями.** Сетап биндингов выполняется в конструкторе,
   когда сиблинги ещё null, а мемберы — plain var без `[Bindable]` (проверено по `generated`:
   `setup()` в конструкторе, мемберы без `[Bindable]`): вотчер с null-корнем не резолвится никогда,
   такой `{f(x)}` мёртв с рождения (не выполняется даже однократно). Декларативно оставлять можно
   ТОЛЬКО источники, не-null уже в конструкторе: `gAssetManager.GetClass(...)`, статика, константы.
   Всё динамическое на сиблингах (`visible`/`enabled`/`width`/`height`/`x`/`selected`/`text`/`dataProvider`)
   — императивно: `visible` → подписки `show`/`hide`, геометрия → `resize`/`move`, плюс начальный вызов
   в `childrenCreated()` (прецеденты: плейсхолдеры `TradingPanel`, `busyVisible`, `digit2Left`,
   `syncIncludeInLayout`, `autoscrollChanged` в `ChatPanel`). Особо: `visible`, выставленный до первой
   валидации, НЕ диспатчит show/hide (`UIComponent.setVisible`: `if (!initialized) return`) —
   такие присвоения для вотчеров/слушателей невидимы. Проверка: греп `{...}` по `.mxml` — каждый
   динамический источник должен иметь парный слушатель в `childrenCreated()`.

## 3. Известные грабли вне MXML (не ломать!)

- **XIFF-quiet proxy:** XIFF-`Room` наследуется от XIFF-`ArrayCollection` (flash_proxy) —
  обращаться только к членам, существующим в SWC (`roomJID/roomName/source/join/leave`,
  константы `RoomEvent`). Неизвестный трейт со `strict=false` уходит в позднее связывание
  → `Unknown Property` в рантайме (прецедент: `RoomGroup.isActive` → локальный флаг).
- **`_SWMMO_FlexInit`, `_ThemeStyles`, `_SWMMOWatcherSetupUtil`** — не вотчеры, не трогать.
  `_ThemeStyles` load-bearing для бута: 64 синхронные декларации нужны коду
  раньше, чем долетает любая асинхронная тема (без него виснет
  StepBootEngine — молча, без ошибок). Проверено откатом 21.09.2026.
- **`BasicPanel.mxml` обязан содержать expression-биндинг** `enabled="{enabled && true}"`:
  без него у базы нет `IBindingClient`-слотов и наследники падают с `#1069 _bindingsByDestination`.
- Скрипты `build.cmd`, `compiler-config.xml`, `src/_SWMMO_mx_managers_SystemManager.as`
  правит только координатор.

