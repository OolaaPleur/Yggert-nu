'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-512.png": "0d3d6064ffa88a6f792050a76ff87856",
"icons/Icon-192.png": "c0082220312c1bbdf8a915038cda8886",
"icons/Icon-512.png": "0d3d6064ffa88a6f792050a76ff87856",
"icons/Icon-maskable-192.png": "c0082220312c1bbdf8a915038cda8886",
"sqflite_sw.js": "5267f89a5a1aa5a985f5cc30f85e3def",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin.json": "22c80c8ad2f7396c5edd177fcaaba1d5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/default_avatar.png": "c2b7a004cfd22a2962acdb702006f136",
"assets/assets/bolt_scooter.png": "3090eee944fc5aefb66f6d4a446c4336",
"assets/assets/bolt_car.png": "9a4347e87ebec1f9d65e553876652197",
"assets/assets/public_transport/tram.png": "d9dbc0d7d86730423b2c2e15c0b06612",
"assets/assets/public_transport/train.png": "6867e0dfae75f6fb4e8f460775994dc7",
"assets/assets/public_transport/county_bus.png": "d20b2fc61d6f572e885de3d8fce58ba4",
"assets/assets/public_transport/ferry.png": "aec94b3c949459e5465d07ceaf90e892",
"assets/assets/public_transport/trolleybus.png": "c809016d5d0fab883b57f4e2a2401423",
"assets/assets/bicycle.png": "b6140084911d557b70e5fe6e81dfd587",
"assets/assets/launcher_icon/web_icon.png": "aad7caf7ec793aaf7ceb3b3e92ece335",
"assets/assets/launcher_icon/launcher_icon.png": "6b8f55ea8eb60653c448c3c0d25241ff",
"assets/assets/hoog_scooter.png": "5145f2741820dfca3182f30ebe356f59",
"assets/assets/scooter_low_battery.png": "000b091578520028e2184a6bc0cfbf43",
"assets/assets/bus.png": "8cbae9207af11d6a8ec15692d574e1da",
"assets/assets/tuul_scooter.png": "80a90fb5d93d65bf5c100e069155d82e",
"assets/assets/intro/intro_city.png": "a6e4a7e3c95b5b53ed921e7a0ea69108",
"assets/assets/intro/intro_please_note.png": "2ece15a054221f1db5c1f1dfb0f3bfd6",
"assets/assets/intro/intro_theme_change.png": "33744f4f201de3447b2c0ae8ae428efa",
"assets/assets/intro/intro_end.png": "321a1bc70d7718bde06c17757eff0ccd",
"assets/assets/intro/intro_bus_stop.png": "352c17bb63b04586264d74c858d17aa3",
"assets/assets/intro/intro_google_sign_in.png": "c5b2b3e3781cca3293311a202c37c3c2",
"assets/fonts/MaterialIcons-Regular.otf": "4c56cf46e594b842ab66a6efd00d6fc3",
"assets/AssetManifest.bin": "4593a480989e5b967926afed5975caac",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/auth_buttons/images/secondary/email_white.png": "5f57417e36ae055d6f9f525e04c51213",
"assets/packages/auth_buttons/images/secondary/facebook.png": "17bc7ce24f8be2338c0fe756bc91021a",
"assets/packages/auth_buttons/images/secondary/apple.png": "c92e950ff74f3d0aed25eae8f2b625a3",
"assets/packages/auth_buttons/images/secondary/microsoft.png": "8f8e4c2c6c1158fa0eb76c9dcca4a106",
"assets/packages/auth_buttons/images/secondary/google.png": "f6e6e8105bf24721e61dd67a38d894ed",
"assets/packages/auth_buttons/images/secondary/huawei.png": "2a9a4ae758b9ba527dc309de7f12706e",
"assets/packages/auth_buttons/images/secondary/email.png": "5a8046651666ff2e14ebb87473d87177",
"assets/packages/auth_buttons/images/default/huawei_white.png": "b5c5ab42a71d5dde71d8cd965db05009",
"assets/packages/auth_buttons/images/default/email_white.png": "b138a1aedb7f7f0891923b0121cc8520",
"assets/packages/auth_buttons/images/default/facebook.png": "7cf5256d509b37c5e023d0e3bf89ca33",
"assets/packages/auth_buttons/images/default/apple.png": "ebc6d25b2a5f85ac1c55fc8493a6933d",
"assets/packages/auth_buttons/images/default/facebook_white.png": "9377466f32681729736ca9347a2e4363",
"assets/packages/auth_buttons/images/default/apple_white.png": "fee7941657354ff5a6522fb270de6b50",
"assets/packages/auth_buttons/images/default/twitter_white.png": "0d4470494f8f7ed308ed1c0f59f13fa6",
"assets/packages/auth_buttons/images/default/microsoft.png": "96da9d69ca3c3f18e9383d01075a4a39",
"assets/packages/auth_buttons/images/default/twitter.png": "ce08a5ef8628e44e8f042f47d5df1661",
"assets/packages/auth_buttons/images/default/github_black.png": "d7670a9b94f89048f0aa78dd1f813bc1",
"assets/packages/auth_buttons/images/default/google.png": "6937ba6a7d2de8aa07701225859ae402",
"assets/packages/auth_buttons/images/default/huawei.png": "0ca2ffbecc245b5793e865ed98087fa8",
"assets/packages/auth_buttons/images/default/email.png": "220771d987f09a46b5ee470d7d1fe14f",
"assets/packages/auth_buttons/images/default/github_white.png": "b69ee90f95f5baea1f6440b27d4d3d7f",
"assets/packages/auth_buttons/images/outlined/huawei_white.png": "fba6b79ab27cb950b8dc65d70a350cfa",
"assets/packages/auth_buttons/images/outlined/email_white.png": "3eed4eeffc6338fb1db70926f75e5dda",
"assets/packages/auth_buttons/images/outlined/facebook.png": "1ff2150aebd4781a3e290a1cc7dc1e1c",
"assets/packages/auth_buttons/images/outlined/apple.png": "982c4374fd8d68c835f51e1b218946c9",
"assets/packages/auth_buttons/images/outlined/facebook_white.png": "1148a3359d95ba55000798b3565d35ad",
"assets/packages/auth_buttons/images/outlined/apple_white.png": "b53bfa858ef99ed1cdcba417f5911847",
"assets/packages/auth_buttons/images/outlined/twitter_white.png": "7e0f8d607a2fd2e431d48bdad71cb7f9",
"assets/packages/auth_buttons/images/outlined/microsoft.png": "b74a53bdc17df88dd0ee39f302f8fb5a",
"assets/packages/auth_buttons/images/outlined/twitter.png": "6cc42f4430ea2d28e6bcebe8caba835e",
"assets/packages/auth_buttons/images/outlined/google.png": "f16a82299f7fb65ad5b9fa493b4fdc79",
"assets/packages/auth_buttons/images/outlined/huawei.png": "596b8fc29dca10fb847162d8190ab922",
"assets/packages/auth_buttons/images/outlined/email.png": "4e322dbd031e5940d60ba4f82204d73d",
"assets/AssetManifest.json": "f423269148d9bf785cdd2a3024137735",
"assets/NOTICES": "7617ae7b4218538a171bebe8008e534e",
"index.html": "3bcea8b6156315cbe123c66637cc9173",
"/": "3bcea8b6156315cbe123c66637cc9173",
"main.dart.js": "0aaafa21753cde1878d7f8889f8bc60b",
"favicon.png": "c01c1f84b244bc0916fc7d7a2fcba85a",
"version.json": "5cd50ac47da8e55b1621297580f2328f",
"sqlite3.wasm": "2068781fd3a05f89e76131a98da09b5b",
"flutter_bootstrap.js": "8f0af8d3a19fc55df9a73f81c8efac3e",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"manifest.json": "8706392c36cb36f5dc09469ad8a9aafa",
"flutter.js": "f393d3c16b631f36852323de8e583132"};
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
