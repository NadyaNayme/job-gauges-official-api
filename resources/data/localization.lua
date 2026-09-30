local localization = {
    en = {
        general = {
            combatStyleNames = {
                necromancy = "Necromancy",
                magic = "Magic",
                melee = "Melee",
                ranged = "Ranged",
                all = "All",
            },
            gaugeSettingsTitle = "Job Gauge Settings",
            dynamicSwappingLabel = "Dynamically swap active style gauge using...",
            dynamicSwappingOptions = {
                ultimateAbilities = "Ultimate Abilities Used",
                equippedMainhandWeapon = "Equipped Mainhand Weapon",
                setItMyself = "I'll set it myself"
            },
            styleButtonsLabel = "If you chose 'I'll set it myself', set your active gauge using the below buttons",
            displaySettingsTitle = "Display Settings",
            hideInCombatLabel = "Hide the gauges while out of combat or banking",
            hideInCombatOptions = {
                yes = "Yes",
                no = "No",
            },
            displayTimeAsLabel = "How should time be displayed?",
            displayTimeAsOptions = {
                preciseTime = "Precise (16.8)",
                nearestSecond = "Rounded (17)",
                preciseTicks = "Game Ticks (28)"
            },
            readyTextLabel = "Change 'Ready' text (set blank to hide)",
            readyTextPlaceholder = "Ready text",
            colourSettingsTitle = "Colour Settings",
            durationText = {
                label = "Duration Remaining / Stacks Text",
                tooltip = "Choose the colour of duration and stacks text",
                windowTitle = "Duration Text",
                acceptButton = "Set Colour",
            },
            cooldownText = {
                label = "Cooldown Remaining Text",
                tooltip = "Choose the colour of remaining cooldown duration",
                windowTitle = "Cooldown Text",
                acceptButton = "Set Colour",
            },
            readyText = {
                label = "'Ready' Text",
                tooltip = "Choose the colour of 'Ready' text",
                windowTitle = "Ready Text",
                acceptButton = "Set Colour",
            },
            abilityBorder = {
                label = "Ability Border Colour",
                tooltip = "Choose the colour of the ability icon borders",
                windowTitle = "Ability Shadow",
                acceptButton = "Set Colour",
            },
            backdropColour = {
                label = "Backdrop Colour",
                tooltip = "Choose the colour of the ability backdrop",
                windowTitle = "Ability Backdrop",
                acceptButton = "Set Colour",
            },
            positionSettingsTitle = "Position Settings",
            lockPositionLabel = "Lock Position - Prevents repositioning",
            componentEditingLabel = "Advanced Positioning - Allow moving individual components",
            lockPositionHelp = "Hold Shift+Ctrl to reposition <br>(While hovering a component if using Advanced Positioning)"
        },
        necromancy = {
            gaugeComponentsTitle = "Necromancy Gauge Components",
            visibilityOptions = {
                deathGrasp = "Show Death Grasp (T70 Weapon Spec)",
                deathEssence = "Show Death Essence (Omni Guard Weapon Spec)",
                soulCrush = "Show Soul Crush (Devourer's guard Weapon Spec)",
                conjures = "Show Conjures",
                residualSouls = "Show Residual Souls",
                necrosisStacks = "Show Necrosis Stacks",
                bloat = "Show Bloat",
                livingDeath = "Show Living Death",
                invokeDeath = "Show Invoke Death",
                threadsOfFate = "Show Threads of Fate",
                splitSoul = "Show Split Soul"
            },
            incantationsReadyTextLabel = "Change 'Ready' text for Incantations (set blank to hide)"
        },
        magic = {
            gaugeComponentsTitle = "Magic Gauge Components",
            visibilityOptions = {
                soulfire = "Show Soulfire (Roar of Awakening Special Attack)",
                instability = "Show Instability (Fractured Staff of Armadyl Special Attack)",
                activeSpell = "Show Active Spell",
                runicCharge = "Show Runic Charge",
                tsunami = "Show Tsunami",
                sunshine = "Show Sunshine"
            },
            spellTrackingColoursTitle = "Spell Tracking Colours",
            expiringFlash = {
                label = "Expiring Flash - This color alternates when under 10s to keep stacks",
                tooltip = "Choose the colour of Expiring text",
                windowTitle = "Expiring Text",
                acceptButton = "Set Colour",
            },
            bloodTithe = {
                label = "Blood Tithe (Exsanguinate)",
                tooltip = "Choose the colour for Blood Tithe",
                windowTitle = "Blood Tithe",
                acceptButton = "Set Colour",
            },
            glacialEmbrace = {
                label = "Glacial Embrace (Incite Fear)",
                tooltip = "Choose the colour for Glacial Embrace",
                windowTitle = "Glacial Embrace",
                acceptButton = "Set Colour",
            },
            essenceCorruption = {
                label = "Essence Corruption (Roar of Awakening passive)",
                tooltip = "Choose the colour for Essence Corruption",
                windowTitle = "Essence Corruption",
                acceptButton = "Set Colour",
            }
        },
        melee = {
            gaugeComponentsTitle = "Melee Gauge Components",
            blackhole = "Show Blackhole (Zaros Godsword Special Attack)",
            igneousShowdown = "Show Igneous Showdown (Ek-ZekKil Special Attack)",
            bloodlust = "Show Bloodlust Stacks",
            chaosRoar = "Show Chaos Roar",
            meteorStrike = "Show Meteor Strike",
            berserk = "Show Berserk"
        },
        ranged = {
            gaugeComponentsTitle = "Ranged Gauge Components",
            crystalRain = "Show Crystal Rain (Seren Godbow Special Attack)",
            splitSoul = "Show Split Soul (Eldritch Crossbow Special Attack)",
            equippedAmmo = "Show Equipped Ammo",
            searingWinds = "Show Searing Winds (Galeshot)",
            shadowImbued = "Show Shadow Imbued (Imbue: Shadows)",
            deathsSwiftness = "Show Death's Swiftness",
            perfectEquilibrium = "Show Perfect Equilibrium",
            guthixianRunes = "Show Guthixian Runes",
            guthixianRuneLabel = "Guthixian Rune for Perfect Equilibrium Stacks",
            guthixianRunesColoursTitle = "Guthixian Runes Colours",
            activeColours = {
                label = "Active Color & Active Shadow",
                activeTooltip = "Choose the active colour",
                inactiveTooltip = "Choose the inactive colour",
                acceptButton = "Set Colour",
            },
            inactiveColours = {
                label = "Inactive Color & Inactive Shadow",
                activeTooltip = "Choose the active shadow colour",
                inactiveTooltip = "Choose the inactive shadow colour",
                acceptButton = "Set Colour",
            },
        }
    },
    de = {
        general = {
            combatStyleNames = {
                necromancy = "Nekromantie",
                magic = "Magie",
                melee = "Nahkampf",
                ranged = "Fernkampf",
            },
            gaugeSettingsTitle = "Job-Gauge-Einstellungen",
            dynamicSwappingLabel = "Aktive Stil-Gauge dynamisch wechseln anhand von...",
            dynamicSwappingOptions = {
                ultimateAbilities = "Verwendete ultimative Fähigkeiten",
                equippedMainhandWeapon = "Ausgerüstete Haupthandwaffe",
                setItMyself = "Ich lege sie selbst fest"
            },
            styleButtonsLabel = "Wenn du „Ich lege sie selbst fest“ gewählt hast, lege deine aktive Gauge mit den folgenden Schaltflächen fest",
            displaySettingsTitle = "Anzeigeeinstellungen",
            hideInCombatLabel = "Gauges außerhalb des Kampfes oder beim Bankieren ausblenden",
            hideInCombatOptions = {
                yes = "Ja",
                no = "Nein",
            },
            displayTimeAsLabel = "Genaue Zeit anzeigen oder auf die nächste Sekunde aufrunden?",
            displayTimeAsOptions = {
                preciseTime = "Genaue Zeit (16,8)",
                nearestSecond = "Nächste Sekunde (17)"
            },
            readyTextLabel = "„Bereit“-Text ändern (leer lassen, um ihn auszublenden)",
            colourSettingsTitle = "Farbeinstellungen",
            durationText = {
                label = "Text für verbleibende Dauer / Stapel",
                tooltip = "Farbe des Dauer- und Stapeltexts auswählen",
                windowTitle = "Dauertext",
                acceptButton = "Farbe festlegen",
            },
            cooldownText = {
                label = "Text für verbleibende Abklingzeit",
                tooltip = "Farbe der verbleibenden Abklingzeit auswählen",
                windowTitle = "Abklingzeittext",
                acceptButton = "Farbe festlegen",
            },
            readyText = {
                label = "„Bereit“-Text",
                tooltip = "Farbe des „Bereit“-Texts auswählen",
                windowTitle = "Bereit-Text",
                acceptButton = "Farbe festlegen",
            },
            abilityBorder = {
                label = "Farbe des Fähigkeitsrahmens",
                tooltip = "Farbe der Rahmen der Fähigkeitssymbole auswählen",
                windowTitle = "Fähigkeitsschatten",
                acceptButton = "Farbe festlegen",
            },
            positionSettingsTitle = "Positionseinstellungen",
            lockPositionLabel = "Position sperren",
            lockPositionHelp = "Halte Umschalt+Strg gedrückt, während die Position entsperrt ist, um deine Gauges neu zu positionieren"
        },
        necromancy = {
            gaugeComponentsTitle = "Komponenten der Nekromantie-Gauge",
            visibilityOptions = {
                deathGrasp = "Death Grasp anzeigen (T70-Waffenspezialangriff)",
                deathEssence = "Death Essence anzeigen (Omni-Guard-Waffenspezialangriff)",
                soulCrush = "Soul Crush anzeigen (Devourer's-Guard-Waffenspezialangriff)",
                conjures = "Beschwörungen anzeigen",
                residualSouls = "Verbleibende Seelen anzeigen",
                necrosisStacks = "Nekrose-Stapel anzeigen",
                bloat = "Bloat anzeigen",
                livingDeath = "Living Death anzeigen",
                invokeDeath = "Invoke Death anzeigen",
                threadsOfFate = "Threads of Fate anzeigen",
                splitSoul = "Split Soul anzeigen"
            },
            incantationsReadyTextLabel = "„Bereit“-Text für Beschwörungen ändern (leer lassen, um ihn auszublenden)"
        },
        magic = {
            gaugeComponentsTitle = "Komponenten der Magie-Gauge",
            visibilityOptions = {
                soulfire = "Soulfire anzeigen (Roar of Awakening-Spezialangriff)",
                instability = "Instability anzeigen (Spezialangriff des Fractured Staff of Armadyl)",
                activeSpell = "Aktiven Zauber anzeigen",
                runicCharge = "Runic Charge anzeigen",
                tsunami = "Tsunami anzeigen",
                sunshine = "Sunshine anzeigen"
            },
            spellTrackingColoursTitle = "Farben der Zauberverfolgung",
            expiringFlash = {
                label = "Ablaufendes Aufblitzen – diese Farbe ändert sich unter 10s,<br> um Stapel sichtbar zu halten",
                tooltip = "Farbe des Ablauftexts auswählen",
                windowTitle = "Ablauftext",
                acceptButton = "Farbe festlegen",
            },
            bloodTithe = {
                label = "Blood Tithe (Exsanguinate)",
                tooltip = "Farbe für Blood Tithe auswählen",
                windowTitle = "Blood Tithe",
                acceptButton = "Farbe festlegen",
            },
            glacialEmbrace = {
                label = "Glacial Embrace (Incite Fear)",
                tooltip = "Farbe für Glacial Embrace auswählen",
                windowTitle = "Glacial Embrace",
                acceptButton = "Farbe festlegen",
            },
            essenceCorruption = {
                label = "Essence Corruption (passiv von Roar of Awakening)",
                tooltip = "Farbe für Essence Corruption auswählen",
                windowTitle = "Essence Corruption",
                acceptButton = "Farbe festlegen",
            }
        },
        melee = {
            gaugeComponentsTitle = "Komponenten der Nahkampf-Gauge",
            blackhole = "Blackhole anzeigen (Zaros-Godsword-Spezialangriff)",
            igneousShowdown = "Igneous Showdown anzeigen (Ek-ZekKil-Spezialangriff)",
            bloodlust = "Bloodlust-Stapel anzeigen",
            chaosRoar = "Chaos Roar anzeigen",
            meteorStrike = "Meteor Strike anzeigen",
            berserk = "Berserk anzeigen"
        },
        ranged = {
            gaugeComponentsTitle = "Komponenten der Fernkampf-Gauge",
            crystalRain = "Crystal Rain anzeigen (Seren-Godbow-Spezialangriff)",
            splitSoul = "Split Soul anzeigen (Eldritch-Crossbow-Spezialangriff)",
            equippedAmmo = "Ausgerüstete Munition anzeigen",
            searingWinds = "Searing Winds anzeigen (Galeshot)",
            shadowImbued = "Shadow Imbued anzeigen (Imbue: Shadows)",
            deathsSwiftness = "Death's Swiftness anzeigen",
            perfectEquilibrium = "Perfect Equilibrium anzeigen",
            guthixianRuneLabel = "Guthixian-Rune für Perfect-Equilibrium-Stapel",
            guthixianRunesColoursTitle = "Farben der Guthixian-Runen",
            activeColours = {
                label = "Aktive Farbe & aktiver Schatten",
                activeTooltip = "Aktive Farbe auswählen",
                inactiveTooltip = "Inaktive Farbe auswählen",
                acceptButton = "Farbe festlegen",
            },
            inactiveColours = {
                label = "Inaktive Farbe & inaktiver Schatten",
                activeTooltip = "Farbe des aktiven Schattens auswählen",
                inactiveTooltip = "Farbe des inaktiven Schattens auswählen",
                acceptButton = "Farbe festlegen",
            },
        }
    },
    pt = {
        general = {
            combatStyleNames = {
                necromancy = "Necromancia",
                magic = "Magia",
                melee = "Combate Corpo a Corpo",
                ranged = "Combate à Distância",
            },
            gaugeSettingsTitle = "Configurações da Interface de Combate",
            dynamicSwappingLabel = "Alternar dinamicamente a interface de estilo ativa usando...",
            dynamicSwappingOptions = {
                ultimateAbilities = "Recursos de Faixa Preta usados",
                equippedMainhandWeapon = "Arma de mão principal equipada",
                setItMyself = "Vou defini-la manualmente"
            },
            styleButtonsLabel = "Se você escolheu 'Vou defini-la manualmente', defina sua interface ativa usando os botões abaixo",
            displaySettingsTitle = "Configurações de Exibição",
            hideInCombatLabel = "Ocultar as interfaces fora de combate ou ao usar o banco",
            hideInCombatOptions = {
                yes = "Sim",
                no = "Não",
            },
            displayTimeAsLabel = "Mostrar o tempo preciso ou arredondar para o segundo mais próximo?",
            displayTimeAsOptions = {
                preciseTime = "Tempo Preciso (16,8)",
                nearestSecond = "Segundo Mais Próximo (17)"
            },
            readyTextLabel = "Alterar o texto 'Pronto' (deixe em branco para ocultar)",
            colourSettingsTitle = "Configurações de Cores",
            durationText = {
                label = "Texto de Duração Restante / Pilhas",
                tooltip = "Escolha a cor do texto de duração e pilhas",
                windowTitle = "Texto de Duração",
                acceptButton = "Definir Cor",
            },
            cooldownText = {
                label = "Texto do Tempo de Recarga Restante",
                tooltip = "Escolha a cor do texto do tempo de recarga restante",
                windowTitle = "Texto do Tempo de Recarga",
                acceptButton = "Definir Cor",
            },
            readyText = {
                label = "Texto 'Pronto'",
                tooltip = "Escolha a cor do texto 'Pronto'",
                windowTitle = "Texto Pronto",
                acceptButton = "Definir Cor",
            },
            abilityBorder = {
                label = "Cor da Borda do Recurso",
                tooltip = "Escolha a cor das bordas dos ícones de recursos",
                windowTitle = "Sombra do Recurso",
                acceptButton = "Definir Cor",
            },
            positionSettingsTitle = "Configurações de Posição",
            lockPositionLabel = "Bloquear Posição",
            lockPositionHelp = "Mantenha Shift+Ctrl pressionado enquanto a posição estiver desbloqueada para reposicionar suas interfaces"
        },
        necromancy = {
            gaugeComponentsTitle = "Componentes da Interface de Necromancia",
            visibilityOptions = {
                deathGrasp = "Mostrar Death Grasp (Recurso de arma T70)",
                deathEssence = "Mostrar Death Essence (Recurso especial da Omni guard)",
                soulCrush = "Mostrar Soul Crush (Recurso especial da Devourer's guard)",
                conjures = "Mostrar Evocações",
                residualSouls = "Mostrar Almas Residuais",
                necrosisStacks = "Mostrar Pilhas de Necrose",
                bloat = "Mostrar Bloat",
                livingDeath = "Mostrar Morte Encarnada",
                invokeDeath = "Mostrar Evocar Morte",
                threadsOfFate = "Mostrar Linhas do Destino",
                splitSoul = "Mostrar Split Soul"
            },
            incantationsReadyTextLabel = "Alterar o texto 'Pronto' para Encantamentos (deixe em branco para ocultar)"
        },
        magic = {
            gaugeComponentsTitle = "Componentes da Interface de Magia",
            visibilityOptions = {
                soulfire = "Mostrar Soulfire (Recurso especial de Roar of Awakening)",
                instability = "Mostrar Instability (Recurso especial do Fractured Staff of Armadyl)",
                activeSpell = "Mostrar Feitiço Ativo",
                runicCharge = "Mostrar Carga Rúnica",
                tsunami = "Mostrar Tsunami",
                sunshine = "Mostrar Sunshine"
            },
            spellTrackingColoursTitle = "Cores de Rastreamento de Feitiços",
            expiringFlash = {
                label = "Flash de Expiração - Esta cor alterna abaixo de 10s para manter<br>as pilhas visíveis",
                tooltip = "Escolha a cor do texto de Expiração",
                windowTitle = "Texto de Expiração",
                acceptButton = "Definir Cor",
            },
            bloodTithe = {
                label = "Dízimo de Sangue (Exsanguinate)",
                tooltip = "Escolha a cor de Dízimo de Sangue",
                windowTitle = "Dízimo de Sangue",
                acceptButton = "Definir Cor",
            },
            glacialEmbrace = {
                label = "Abraço Glacial (Incitar Medo)",
                tooltip = "Escolha a cor de Abraço Glacial",
                windowTitle = "Abraço Glacial",
                acceptButton = "Definir Cor",
            },
            essenceCorruption = {
                label = "Corrupção da Essência (passivo de Roar of Awakening)",
                tooltip = "Escolha a cor de Corrupção da Essência",
                windowTitle = "Corrupção da Essência",
                acceptButton = "Definir Cor",
            }
        },
        melee = {
            gaugeComponentsTitle = "Componentes da Interface de Combate Corpo a Corpo",
            blackhole = "Mostrar Blackhole (Recurso especial da Espada divina de Zaros)",
            igneousShowdown = "Mostrar Igneous Showdown (Recurso especial da Ek-ZekKil)",
            bloodlust = "Mostrar Pilhas de Bloodlust",
            chaosRoar = "Mostrar Chaos Roar",
            meteorStrike = "Mostrar Colisão de Meteoro",
            berserk = "Mostrar Berserk"
        },
        ranged = {
            gaugeComponentsTitle = "Componentes da Interface de Combate à Distância",
            crystalRain = "Mostrar Crystal Rain (Recurso especial do Arco divino de Seren)",
            splitSoul = "Mostrar Split Soul (Recurso especial da Besta cruzada Eldritch)",
            equippedAmmo = "Mostrar Munição Equipada",
            searingWinds = "Mostrar Searing Winds (Galeshot)",
            shadowImbued = "Mostrar Shadow Imbued (Imbue: Shadows)",
            deathsSwiftness = "Mostrar Rapidez da Morte",
            perfectEquilibrium = "Mostrar Perfect Equilibrium",
            guthixianRuneLabel = "Runa Guthixian para as Pilhas de Perfect Equilibrium",
            guthixianRunesColoursTitle = "Cores das Runas Guthixian",
            activeColours = {
                label = "Cor Ativa & Sombra Ativa",
                activeTooltip = "Escolha a cor ativa",
                inactiveTooltip = "Escolha a cor inativa",
                acceptButton = "Definir Cor",
            },
            inactiveColours = {
                label = "Cor Inativa & Sombra Inativa",
                activeTooltip = "Escolha a cor da sombra ativa",
                inactiveTooltip = "Escolha a cor da sombra inativa",
                acceptButton = "Definir Cor",
            },
        }
    },
    fr = {
        general = {
            combatStyleNames = {
                necromancy = "Nécromancie",
                magic = "Magie",
                melee = "Combat rapproché",
                ranged = "Combat à distance",
            },
            gaugeSettingsTitle = "Paramètres de la jauge de combat",
            dynamicSwappingLabel = "Changer dynamiquement de jauge de style active selon...",
            dynamicSwappingOptions = {
                ultimateAbilities = "Ultimes utilisés",
                equippedMainhandWeapon = "Arme principale équipée",
                setItMyself = "Je la définirai moi-même"
            },
            styleButtonsLabel = "Si vous avez choisi « Je la définirai moi-même », définissez votre jauge active à l'aide des boutons ci-dessous",
            displaySettingsTitle = "Paramètres d'affichage",
            hideInCombatLabel = "Masquer les jauges hors combat ou lors de l'utilisation de la banque",
            hideInCombatOptions = {
                yes = "Oui",
                no = "Non",
            },
            displayTimeAsLabel = "Afficher le temps précis ou arrondir à la seconde la plus proche ?",
            displayTimeAsOptions = {
                preciseTime = "Temps précis (16,8)",
                nearestSecond = "Seconde la plus proche (17)"
            },
            readyTextLabel = "Modifier le texte « Prêt » (laisser vide pour le masquer)",
            colourSettingsTitle = "Paramètres de couleur",
            durationText = {
                label = "Texte de durée restante / cumuls",
                tooltip = "Choisissez la couleur du texte de durée et de cumuls",
                windowTitle = "Texte de durée",
                acceptButton = "Définir la couleur",
            },
            cooldownText = {
                label = "Texte du temps de recharge restant",
                tooltip = "Choisissez la couleur du texte du temps de recharge restant",
                windowTitle = "Texte du temps de recharge",
                acceptButton = "Définir la couleur",
            },
            readyText = {
                label = "Texte « Prêt »",
                tooltip = "Choisissez la couleur du texte « Prêt »",
                windowTitle = "Texte Prêt",
                acceptButton = "Définir la couleur",
            },
            abilityBorder = {
                label = "Couleur de bordure des capacités",
                tooltip = "Choisissez la couleur des bordures des icônes de capacités",
                windowTitle = "Ombre des capacités",
                acceptButton = "Définir la couleur",
            },
            positionSettingsTitle = "Paramètres de position",
            lockPositionLabel = "Verrouiller la position",
            lockPositionHelp = "Maintenez Maj+Ctrl enfoncées lorsque la position est déverrouillée pour repositionner vos jauges"
        },
        necromancy = {
            gaugeComponentsTitle = "Composants de la jauge de Nécromancie",
            visibilityOptions = {
                deathGrasp = "Afficher Death Grasp (spécial d'arme T70)",
                deathEssence = "Afficher Death Essence (spécial de l'Omni guard)",
                soulCrush = "Afficher Soul Crush (spécial de la Devourer's guard)",
                conjures = "Afficher les invocations",
                residualSouls = "Afficher les âmes résiduelles",
                necrosisStacks = "Afficher les cumuls de nécrose",
                bloat = "Afficher Bloat",
                livingDeath = "Afficher Living Death",
                invokeDeath = "Afficher Invoke Death",
                threadsOfFate = "Afficher Threads of Fate",
                splitSoul = "Afficher Split Soul"
            },
            incantationsReadyTextLabel = "Modifier le texte « Prêt » pour les incantations (laisser vide pour le masquer)"
        },
        magic = {
            gaugeComponentsTitle = "Composants de la jauge de Magie",
            visibilityOptions = {
                soulfire = "Afficher Soulfire (spécial de Roar of Awakening)",
                instability = "Afficher Instability (spécial du Fractured Staff of Armadyl)",
                activeSpell = "Afficher le sort actif",
                runicCharge = "Afficher Charge runique",
                tsunami = "Afficher Tsunami",
                sunshine = "Afficher Sunshine"
            },
            spellTrackingColoursTitle = "Couleurs du suivi des sorts",
            expiringFlash = {
                label = "Clignotement d'expiration - Cette couleur change sous 10s afin <br>de conserver les cumuls",
                tooltip = "Choisissez la couleur du texte d'expiration",
                windowTitle = "Texte d'expiration",
                acceptButton = "Définir la couleur",
            },
            bloodTithe = {
                label = "Blood Tithe (Exsanguinate)",
                tooltip = "Choisissez la couleur de Blood Tithe",
                windowTitle = "Blood Tithe",
                acceptButton = "Définir la couleur",
            },

            glacialEmbrace = {
                label = "Glacial Embrace (Incite Fear)",
                tooltip = "Choisissez la couleur de Glacial Embrace",
                windowTitle = "Glacial Embrace",
                acceptButton = "Définir la couleur",
            },

            essenceCorruption = {
                label = "Essence Corruption (passif de Roar of Awakening)",
                tooltip = "Choisissez la couleur de Essence Corruption",
                windowTitle = "Essence Corruption",
                acceptButton = "Définir la couleur",
            }
        },

        melee = {
            gaugeComponentsTitle = "Composants de la jauge de Combat rapproché",
            blackhole = "Afficher Blackhole (spécial de l'épée divine de Zaros)",
            igneousShowdown = "Afficher Igneous Showdown (spécial de l'Ek-ZekKil)",
            bloodlust = "Afficher les cumuls de Bloodlust",
            chaosRoar = "Afficher Chaos Roar",
            meteorStrike = "Afficher Meteor Strike",
            berserk = "Afficher Berserk"
        },
        ranged = {
            gaugeComponentsTitle = "Composants de la jauge de Combat à distance",
            crystalRain = "Afficher Crystal Rain (spécial de l'arc divin de Seren)",
            splitSoul = "Afficher Split Soul (spécial de l'arbalète eldritch)",
            equippedAmmo = "Afficher les munitions équipées",
            searingWinds = "Afficher Searing Winds (Galeshot)",
            shadowImbued = "Afficher Shadow Imbued (Imbue: Shadows)",
            deathsSwiftness = "Afficher Death's Swiftness",
            perfectEquilibrium = "Afficher Perfect Equilibrium",
            guthixianRuneLabel = "Rune Guthixian pour les cumuls de Perfect Equilibrium",
            guthixianRunesColoursTitle = "Couleurs des runes Guthixian",
            activeColours = {
                label = "Couleur active & ombre active",
                activeTooltip = "Choisissez la couleur active",
                inactiveTooltip = "Choisissez la couleur inactive",
                acceptButton = "Définir la couleur",
            },
            inactiveColours = {
                label = "Couleur inactive & ombre inactive",
                activeTooltip = "Choisissez la couleur de l'ombre active",
                inactiveTooltip = "Choisissez la couleur de l'ombre inactive",
                acceptButton = "Définir la couleur",
            },
        }
    }
}

return localization