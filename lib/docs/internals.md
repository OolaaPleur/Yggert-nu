## Internals

1. For theme I used flex_color_scheme package, also author has great website, to fine-tune some widgets use site https://rydmike.com/flexcolorscheme/themesplayground-v7/#/
2. On naming exception and InfoMessage enums, its name should be used in localization string name, e.g. CantFetchBoltScootersData - AppLocalizations.of(context)!.snackbarCantFetchBoltScootersData or InfoMessage.noNeedToDownload - AppLocalizations.of(context)!.snackbarNoNeedToDownload
3. Code for custom paint (located here lib/screens/settings/widgets/animated_icon_button.dart) generated with https://fluttershapemaker.com/ , these SVGs also located in assets folder.
4. Right now app uses OSM tiles, but in code there is commented line with mapbox tiles. They are vector, they are looking slick, but potentially they are quite pricey.
5. To find similar colors I used https://www.color-hex.com/color/fff59d
6. Because isolate could only work with primitives, it would be hard to compute it in isolate.