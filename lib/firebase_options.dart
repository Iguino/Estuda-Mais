import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      // Substitua pelos dados do seu aplicativo Web no Firebase Console.
      apiKey: 'AIzaSyCsdQV5Cs2E8fGciHO-8wa6W84KSgsXkoE',
      authDomain: 'estuda-mais-dd088.firebaseapp.com',
      projectId: 'estuda-mais-dd088',
      storageBucket: 'estuda-mais-dd088.firebasestorage.app',
      messagingSenderId: '584707243265',
      appId: '1:584707243265:web:a7bbd39a4381792dc42f00',
    );
  }
}