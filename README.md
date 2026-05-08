# LoreLabFlutter
This is a mobile app for creating fictional worlds, characters and stories using Flutter.

## Preduvjeti

- Flutter SDK (verzija 3.x.x ili novija) - instalirati preko dokumentacije i postaviti korisničku varijablu okruženja, dodati path(C:\flutter\bin)
- Android Studio (emulator: Pixel 3 sa API-jem 36)
- Android SDK
- VS Code s Flutter i Dart dodacima
- Git

## Instalacija

1. Klonirajte repozitorij
   git clone https://github.com/JosipRoncevic/LoreLabFlutter.git

2. Uđite u direktorij projekta
   cd LoreLabFlutter

3. Instalirajte ovisnosti
   flutter pub get
   - Potrebno je pričekati nekoliko minuta kako bi se maknule sve greške. Najbolje restartati cijeli VS Code nakon ovoga.

5. Pokrenite aplikaciju
   flutter run
   - Mogući su problemi ukoliko se ne koristi java JDK 17. U tom slučaju postaviti put sistemske varijable okruženja na putanju do npr. C:\Program Files\Java\jdk-17\bin
   - Nakon ovoga vjerovatno će se, ako nisu prisutni automatski preuzeti: Android SDK Platforma 36, NDK 27 i CMake 3.22.1 i build bi trebao proći glatko
