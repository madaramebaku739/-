const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.weeklyFineCheck = functions.pubsub.schedule('0 21 * * 0').timeZone('Asia/Tokyo').onRun(async () => {
  const users = await admin.firestore().collection('users').get();
  const batch = admin.firestore().batch();

  users.forEach((doc) => {
    const data = doc.data();
    const goal = data.weeklyGoal || 0;
    const checkedIn = data.checkedInThisWeek || 0;
    const fineAmount = data.fineAmount || 0;
    const fineTriggered = checkedIn < goal && fineAmount > 0;

    batch.update(doc.ref, {
      fineTriggered,
      checkedInThisWeek: 0,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  await batch.commit();
  return null;
});

exports.createStripeCheckout = functions.https.onCall(async (data, context) => {
  const amount = data.amount;
  const userId = context.auth?.uid || data.userId;
  // TODO: Stripe SDKでcheckout.sessions.createを実装
  const placeholderUrl = `https://yourdomain.com/pay-fine?user=${userId}&amount=${amount}`;
  return { url: placeholderUrl };
});
