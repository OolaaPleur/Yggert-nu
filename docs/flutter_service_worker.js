'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"index.html": "65d5854022051707cf46ae2059eb7e85",
"/": "65d5854022051707cf46ae2059eb7e85",
"sqlite3.wasm": "2068781fd3a05f89e76131a98da09b5b",
"assets/NOTICES": "9260611c3efe21e28749083121fd7a64",
"assets/assets/tuul_scooter.png": "80a90fb5d93d65bf5c100e069155d82e",
"assets/assets/public_transport/trolleybus.png": "c809016d5d0fab883b57f4e2a2401423",
"assets/assets/public_transport/tram.png": "d9dbc0d7d86730423b2c2e15c0b06612",
"assets/assets/public_transport/ferry.png": "aec94b3c949459e5465d07ceaf90e892",
"assets/assets/public_transport/county_bus.png": "d20b2fc61d6f572e885de3d8fce58ba4",
"assets/assets/public_transport/train.png": "6867e0dfae75f6fb4e8f460775994dc7",
"assets/assets/bolt_car.png": "9a4347e87ebec1f9d65e553876652197",
"assets/assets/default_avatar.png": "c2b7a004cfd22a2962acdb702006f136",
"assets/assets/hoog_scooter.png": "5145f2741820dfca3182f30ebe356f59",
"assets/assets/scooter_low_battery.png": "000b091578520028e2184a6bc0cfbf43",
"assets/assets/bus.png": "8cbae9207af11d6a8ec15692d574e1da",
"assets/assets/bolt_scooter.png": "3090eee944fc5aefb66f6d4a446c4336",
"assets/assets/intro/intro_google_sign_in.png": "c5b2b3e3781cca3293311a202c37c3c2",
"assets/assets/intro/intro_theme_change.png": "33744f4f201de3447b2c0ae8ae428efa",
"assets/assets/intro/intro_end.png": "321a1bc70d7718bde06c17757eff0ccd",
"assets/assets/intro/intro_please_note.png": "2ece15a054221f1db5c1f1dfb0f3bfd6",
"assets/assets/intro/intro_city.png": "a6e4a7e3c95b5b53ed921e7a0ea69108",
"assets/assets/intro/intro_bus_stop.png": "352c17bb63b04586264d74c858d17aa3",
"assets/assets/bicycle.png": "b6140084911d557b70e5fe6e81dfd587",
"assets/assets/launcher_icon/launcher_icon.png": "6b8f55ea8eb60653c448c3c0d25241ff",
"assets/assets/launcher_icon/web_icon.png": "aad7caf7ec793aaf7ceb3b3e92ece335",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "f6f49ae4519160aed362cafaeb363e68",
"assets/fonts/MaterialIcons-Regular.otf": "1855adc1688daa50b113611277fcb29d",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin.json": "122be202bbfe56cf2c77898dae82b471",
"assets/packages/auth_buttons/images/default/email.svg": "c6828e2af8812ae296aaf7f929b76e7a",
"assets/packages/auth_buttons/images/default/twitter.svg": "d6af3024c120e0d6806029acf5ffb63c",
"assets/packages/auth_buttons/images/default/google.svg": "cd8d3cee1ef93bb55ab202d78ad7b34d",
"assets/packages/auth_buttons/images/default/facebook.svg": "f06ef4966df341c33645b9b172f3f7a7",
"assets/packages/auth_buttons/images/default/github_black.svg": "c47f1e019451022bd4c08b532e26fcbb",
"assets/packages/auth_buttons/images/default/microsoft.svg": "007e4f3f6c88105755160ebcec91391e",
"assets/packages/auth_buttons/images/default/apple.svg": "dec9066f990b3215aa069595e1185f43",
"assets/packages/auth_buttons/images/default/huawei.svg": "55ff4e48fbe273c6317d70304d2dd877",
"assets/packages/auth_buttons/images/secondary/email.svg": "6fde813b1adb70ca0c041b705b44fd6a",
"assets/packages/auth_buttons/images/secondary/twitter.svg": "234149a0ae0404a9cd7d77320a604af3",
"assets/packages/auth_buttons/images/secondary/google.svg": "99034cf0b91fa72aefa3e325698dc2aa",
"assets/packages/auth_buttons/images/secondary/facebook.svg": "2419544c4fc92fd91236170fb0e481bc",
"assets/packages/auth_buttons/images/secondary/github.svg": "04f160b7dfd8099bcb9f233c5f6420f4",
"assets/packages/auth_buttons/images/secondary/microsoft.svg": "161520a869ea0639540a9bc37865a33f",
"assets/packages/auth_buttons/images/secondary/apple.svg": "50d04c649c4fb9fb2523f6aac93bb8a0",
"assets/packages/auth_buttons/images/secondary/huawei.svg": "9de2c5a9d066c43849081d75bdbcae7f",
"assets/packages/auth_buttons/images/outlined/email.svg": "e98f2e3657f36e1be6feaa285107ef2a",
"assets/packages/auth_buttons/images/outlined/twitter.svg": "aed80dd035d02a257e2669612e88efad",
"assets/packages/auth_buttons/images/outlined/google.svg": "2f8c5d7b7c839625df3b61b09fd4a842",
"assets/packages/auth_buttons/images/outlined/facebook.svg": "767dc51c9930d30e0ce2478a7d974bd7",
"assets/packages/auth_buttons/images/outlined/github.svg": "ee0330f29a95eeb06fb58e226e763515",
"assets/packages/auth_buttons/images/outlined/microsoft.svg": "945571112b39116453dc1b9cd57f8b83",
"assets/packages/auth_buttons/images/outlined/apple.svg": "f7e040b24c6f6929b75985b77c6fb740",
"assets/packages/auth_buttons/images/outlined/huawei.svg": "251575035ea7c10dc380f51cfcf26630",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/AssetManifest.json": "6a6b616cddddb399d2b3087d46ecb598",
"version.json": "69e80162fae94c5610c9a4b9b51e0b9f",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js": "ed4ba09d8fea390012d53397ccdc8e14",
"sqflite_sw.js": "5267f89a5a1aa5a985f5cc30f85e3def",
"icons/Icon-maskable-512.png": "0d3d6064ffa88a6f792050a76ff87856",
"icons/Icon-192.png": "c0082220312c1bbdf8a915038cda8886",
"icons/Icon-512.png": "0d3d6064ffa88a6f792050a76ff87856",
"icons/Icon-maskable-192.png": "c0082220312c1bbdf8a915038cda8886",
"manifest.json": "8706392c36cb36f5dc09469ad8a9aafa",
"favicon.png": "c01c1f84b244bc0916fc7d7a2fcba85a",
"flutter_bootstrap.js": "9fbf309ff07cc044d71e8736c63c45b3"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
