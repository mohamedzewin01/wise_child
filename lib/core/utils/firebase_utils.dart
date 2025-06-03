// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class FirebaseUtils {
//
//   static CollectionReference<OrdersFirebaseModel?> get ordersCollection {
//     return FirebaseFirestore.instance
//         .collection(AppConstants.collection)
//         .withConverter<OrdersFirebaseModel>(
//       fromFirestore: (snapshot, _) =>
//           OrdersFirebaseModel.fromJson(snapshot.data()!),
//       toFirestore: (order, _) => order.toJson(),
//     );
//   }
//
//
//   static Stream<OrdersFirebaseModel?> getOrders({required String idOrder}) {
//     try {
//
//       return ordersCollection
//           .doc(idOrder)
//           .snapshots()
//           .map((snapshot) => snapshot.data());
//     }catch (e) {
//       return const Stream.empty();
//     }
//   }
// }
